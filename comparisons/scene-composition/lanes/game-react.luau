--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"
local Memo = require "./memo"

type Context = { Provider: unknown, Consumer: unknown }
type React = {
	createElement: (unknown, Types.Properties?, { unknown }?) -> unknown,
	createContext: (unknown) -> Context,
	useState: <T>(T) -> (T, (T) -> ()),
	useRef: <T>(T) -> { current: T },
	useMemo: <T>(() -> T, { unknown }) -> T,
	useLayoutEffect: (() -> () -> (), { unknown }) -> (),
}
type Root = { render: (Root, unknown) -> (), unmount: (Root) -> () }
type Renderer = {
	createRoot: (Environment.Instance) -> Root,
	flushSync: (() -> ()) -> (),
	unstable_batchedUpdates: (() -> ()) -> (),
}

local function create(
	environment: Environment.Environment,
	stateDriver: State.State?,
	dependency: string?
): Types.Driver
	local rootPath = ".lute/dependencies/" .. (dependency or "react") .. "/modules/"
	local loadReact: (string) -> React = environment.load
	local loadRenderer: (string) -> Renderer = environment.load
	local react = loadReact(rootPath .. "react/src")
	local renderer = loadRenderer(rootPath .. "react-roblox/src")
	local theme = react.createContext "light"
	local function remember(): Memo.Memo
		return Memo.create(function(class, props, children)
			return if children then react.createElement(class, props, children) else react.createElement(class, props)
		end, function(id, order)
			return react.createElement("TextLabel", { key = tostring(id), Text = tostring(id), LayoutOrder = order })
		end)
	end
	local memo = remember()
	local function constant<T>(current: T, write: (T) -> ()): Types.Source<T>
		local source: Types.Source<T> = {
			binding = current,
			read = function(): T
				return current
			end,
			write = write,
			bind = function(map: (T) -> unknown): unknown
				return map(current)
			end,
		}
		memo.source(source, current)
		return source
	end
	local api: Types.Scope
	local built: Types.Scope = {
		select = function<T, U>(source: Types.Source<T>, map: (T) -> U): Types.Source<U>
			local current = source.read()
			local selected = react.useMemo(function(): U
				return map(current)
			end, { current })
			return constant(selected, function()
				error("A selected value is read-only", 0)
			end)
		end,
		value = function<T>(initial: T): Types.Source<T>
			local current, update = react.useState(initial)
			if stateDriver then
				local empty: State.Cell<T>? = nil
				local stored = react.useRef(empty)
				react.useLayoutEffect(function()
					local cell = assert(stateDriver).value(initial, update)
					stored.current = cell
					return function()
						cell.release()
						stored.current = nil
					end
				end, {})
				return constant(current, function(next: T)
					assert(stored.current).write(next)
				end)
			end
			return constant(current, update)
		end,
		computed = function<T>(body: (Types.Use) -> T): Types.Source<T>
			return constant(memo.computed(body), function()
				error("A derived value is read-only", 0)
			end)
		end,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			return memo.node(class, properties, children)
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			local children: { unknown } = {}
			for index, row in list.read() do
				children[index] = memo.row(row.id, index)
			end
			return memo.node("Frame", {}, children)
		end,
		provideTheme = function(source: Types.Source<string>, build: () -> unknown): unknown
			return react.createElement(theme.Provider, { value = source.read() }, { build() })
		end,
		themeText = function(): unknown
			error("Use themeNode for reconciled context consumers", 0)
		end,
		event = function(): unknown
			error("Game workloads do not use events", 0)
		end,
		branch = function(): unknown
			error("Game workloads mount their page roots directly", 0)
		end,
		counterState = function(): Types.CounterState
			error("Game workloads use numeric state", 0)
		end,
		spring = function(): unknown
			error("Game workloads do not use springs", 0)
		end,
	}
	api = built
	local function themed(value: string): unknown
		return react.createElement("TextLabel", { Text = value })
	end
	api.themeNode = function(): unknown
		return memo.node(theme.Consumer, { children = themed })
	end
	return {
		mount = function(container, build)
			local root = renderer.createRoot(container)
			local owned = remember()
			local ok, detail = pcall(function()
				renderer.flushSync(function()
					root:render(react.createElement(function()
						memo = owned
						owned.begin()
						return build(api)
					end))
				end)
				environment.drain()
			end)
			if not ok then
				root:unmount()
				owned.clear()
				environment.drain()
				error(detail, 0)
			end
			return function()
				root:unmount()
				owned.clear()
				environment.drain()
			end
		end,
		batch = function(run)
			renderer.flushSync(function()
				renderer.unstable_batchedUpdates(function()
					if stateDriver then
						stateDriver.batch(run)
					else
						run()
					end
				end)
			end)
			environment.drain()
		end,
	}
end

return { create = create }
