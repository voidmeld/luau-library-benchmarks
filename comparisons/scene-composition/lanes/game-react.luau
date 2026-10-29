--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"

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
	local function constant<T>(current: T, write: (T) -> ()): Types.Source<T>
		return {
			binding = current,
			read = function(): T
				return current
			end,
			write = write,
			bind = function(map: (T) -> unknown): unknown
				return map(current)
			end,
		}
	end
	local api: Types.Scope
	api = {
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
				local stored = react.useRef(nil :: State.Cell<T>?)
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
			return constant(
				body(function<U>(source: Types.Source<U>): U
					return source.read()
				end),
				function()
					error("A derived value is read-only", 0)
				end
			)
		end,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			return react.createElement(class, properties, children)
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			local children: { unknown } = {}
			for index, row in list.read() do
				children[index] = react.createElement(
					"TextLabel",
					{ key = tostring(row.id), Text = tostring(row.id), LayoutOrder = index }
				)
			end
			return react.createElement("Frame", {}, children)
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
	} :: Types.Scope
	api.themeNode = function(): unknown
		return react.createElement(theme.Consumer, {
			children = function(value: string)
				return react.createElement("TextLabel", { Text = value })
			end,
		})
	end
	return {
		mount = function(container, build)
			local root = renderer.createRoot(container)
			local ok, detail = pcall(function()
				renderer.flushSync(function()
					root:render(react.createElement(function()
						return build(api)
					end))
				end)
				environment.drain()
			end)
			if not ok then
				root:unmount()
				environment.drain()
				error(detail, 0)
			end
			return function()
				root:unmount()
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
