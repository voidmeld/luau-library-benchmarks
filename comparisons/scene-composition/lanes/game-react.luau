--!strict
--!native

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"

type React = {
	createElement: (unknown, Types.Properties?, { unknown }?) -> unknown,
	memo: (unknown) -> unknown,
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
type Render = { count: number, positions: { [unknown]: number }, values: { [number]: unknown } }
type RowProps = { row: Types.Row, index: number }

local function readOnly(_: unknown): ()
	error("A derived value is read-only", 0)
end

local function read<T>(source: Types.Source<T>): T
	return source.read()
end

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
	local Row = react.memo(function(props: RowProps): unknown
		return react.createElement("TextLabel", { Text = tostring(props.row.id), LayoutOrder = props.index })
	end)
	local render: Render = { count = 0, positions = {}, values = {} }
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
		render.count += 1
		render.values[render.count] = current
		render.positions[source] = render.count
		return source
	end
	local untracked: { number }? = nil
	local api: Types.Scope = {
		select = function<T, U>(source: Types.Source<T>, map: (T) -> U): Types.Source<U>
			local current = source.read()
			local selected = react.useMemo(function(): U
				return map(current)
			end, { current })
			return constant(selected, readOnly)
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
			local tracked = react.useRef(untracked)
			local known = tracked.current
			local first: { value: T }? = nil
			local positions: { number }
			if known then
				positions = known
			else
				local found: { number } = {}
				first = {
					value = body(function<U>(source: Types.Source<U>): U
						table.insert(
							found,
							(assert(render.positions[source], "A derived value read an unknown source"))
						)
						return source.read()
					end),
				}
				tracked.current = found
				positions = found
			end
			local dependencies: { unknown } = table.create(#positions)
			for index, position in positions do
				dependencies[index] = render.values[position]
			end
			local value = react.useMemo(function(): T
				return if first then first.value else body(read)
			end, dependencies)
			return constant(value, readOnly)
		end,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			return react.createElement(class, properties, children)
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			local children: { unknown } = {}
			for index, row in list.read() do
				children[index] = react.createElement(Row, { key = tostring(row.id), row = row, index = index })
			end
			return react.createElement("Frame", {}, children)
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
	return {
		mount = function(container, build)
			local root = renderer.createRoot(container)
			local owned: Render = { count = 0, positions = {}, values = {} }
			local function release()
				root:unmount()
				owned.count = 0
				table.clear(owned.positions)
				table.clear(owned.values)
				environment.drain()
			end
			local ok, detail = pcall(function()
				renderer.flushSync(function()
					root:render(react.createElement(function(): unknown
						render = owned
						owned.count = 0
						table.clear(owned.positions)
						return build(api)
					end))
				end)
				environment.drain()
			end)
			if not ok then
				release()
				error(detail, 0)
			end
			return release
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
