--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"
local GameReact = require "./game-react"

type Binding<T> = { getValue: (Binding<T>) -> T, map: (Binding<T>, (T) -> unknown) -> unknown }
type React = {
	createElement: (unknown, Types.Properties?, { unknown }?) -> unknown,
	createBinding: <T>(T) -> (Binding<T>, (T) -> ()),
	useState: <T>(T) -> (T, (T) -> ()),
	useLayoutEffect: (() -> () -> (), { unknown }) -> (),
	useMemo: <T>(() -> T, { unknown }) -> T,
	Event: { [string]: unknown },
}
type Root = { render: (Root, unknown) -> (), unmount: (Root) -> () }
type ReactRoblox = {
	createRoot: (Environment.Instance) -> Root,
	flushSync: (() -> ()) -> (),
	unstable_batchedUpdates: (() -> ()) -> (),
}

local function create(
	environment: Environment.Environment,
	stateDriver: State.State?,
	dependency: string?,
	game: boolean?
): Types.Driver
	if game then
		return GameReact.create(environment, stateDriver, dependency)
	end
	local root = ".lute/dependencies/" .. (dependency or "react") .. "/modules/"
	local loadReact: (string) -> React = environment.load
	local react = loadReact(root .. "react/src")
	local loadRoblox: (string) -> ReactRoblox = environment.load
	local roblox = loadRoblox(root .. "react-roblox/src")
	local scopeFor: ({ () -> () }) -> Types.Scope
	function scopeFor(releases: { () -> () }): Types.Scope
		local scope: Types.Scope
		scope = {
			spring = function(): unknown
				error("React has no native spring primitive", 0)
			end,
			value = function<T>(initial: T): Types.Source<T>
				local binding, update = react.createBinding(initial)
				local listeners: { [(T) -> ()]: boolean } = {}
				local function emit(next: T)
					update(next)
					for listener in listeners do
						listener(next)
					end
				end
				local cell = if stateDriver then stateDriver.value(initial, emit) else nil
				if cell then
					table.insert(releases, cell.release)
				end
				return {
					binding = binding,
					read = function(): T
						return if cell then cell.read() else binding:getValue()
					end,
					write = function(next: T)
						if cell then
							cell.write(next)
						else
							emit(next)
						end
					end,
					bind = function(map: (T) -> unknown): unknown
						return binding:map(map)
					end,
					watch = function(listener: (T) -> ()): () -> ()
						listeners[listener] = true
						return function()
							listeners[listener] = nil
						end
					end,
				}
			end,
			node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
				return react.createElement(class, properties, children)
			end,
			keyed = function(list: Types.Source<{ Types.Row }>): unknown
				return react.createElement(function(): unknown
					local rows, update = react.useState(list.read())
					react.useLayoutEffect(function(): () -> ()
						return assert(list.watch)(update)
					end, {})
					local children: { unknown } = {}
					for index, row in rows do
						children[index] = react.createElement("TextLabel", {
							key = tostring(row.id),
							Text = tostring(row.id),
							LayoutOrder = index,
						})
					end
					return children
				end)
			end,
			branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
				local function branch(): unknown
					local owned = react.useMemo(function(): { () -> () }
						return {}
					end, {})
					react.useLayoutEffect(function(): () -> ()
						return function()
							for index = #owned, 1, -1 do
								owned[index]()
							end
							table.clear(owned)
						end
					end, {})
					return react.useMemo(function(): unknown
						return build(scopeFor(owned))
					end, {})
				end
				return react.createElement(function(): unknown
					local visible, update = react.useState(open.read())
					react.useLayoutEffect(function(): () -> ()
						return assert(open.watch)(update)
					end, {})
					return if visible then react.createElement(branch) else nil
				end)
			end,
			event = function(name: string): unknown
				return react.Event[name]
			end,
			counterState = function(initial: number): Types.CounterState
				if stateDriver ~= nil then
					local source = scope.value(initial)
					return {
						node = scope.node("TextLabel", {
							Text = source.bind(function(value: number): unknown
								return tostring(value)
							end),
						}),
						write = source.write,
					}
				end
				local write: (number) -> () = function()
					error("text state is not mounted", 0)
				end
				local node = react.createElement(function(): unknown
					local text, update = react.useState(initial)
					write = update
					return react.createElement("TextLabel", { Text = tostring(text) })
				end)
				return {
					node = node,
					write = function(text: number)
						write(text)
					end,
				}
			end,
		}
		return scope
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local owned: { () -> () } = {}
			local root = roblox.createRoot(container)
			local ok, detail = pcall(function()
				roblox.flushSync(function()
					root:render(build(scopeFor(owned)))
				end)
				environment.drain()
			end)
			if not ok then
				root:unmount()
				environment.drain()
				for _, release in owned do
					release()
				end
				table.clear(owned)
				error(detail, 0)
			end
			return function()
				root:unmount()
				environment.drain()
				for _, release in owned do
					release()
				end
				table.clear(owned)
			end
		end,
		batch = function(run: () -> ())
			roblox.flushSync(function()
				roblox.unstable_batchedUpdates(function()
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
