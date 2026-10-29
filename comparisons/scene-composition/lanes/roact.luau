--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Rows = require "./rows"

type Binding<T> = { getValue: (Binding<T>) -> T, map: (Binding<T>, (T) -> unknown) -> unknown }
type Component = {
	setState: (Component, { version: number }) -> (),
	init: ((Component) -> ())?,
	render: ((Component) -> unknown)?,
	didMount: ((Component) -> ())?,
	willUnmount: ((Component) -> ())?,
}
type Roact = {
	createElement: (unknown, Types.Properties?, { [unknown]: unknown }?) -> unknown,
	createFragment: ({ [unknown]: unknown }) -> unknown,
	createBinding: <T>(T) -> (Binding<T>, (T) -> ()),
	Component: { extend: (unknown, string) -> Component },
	Event: { [string]: unknown },
	mount: (unknown, Environment.Instance) -> unknown,
	unmount: (unknown) -> (),
}

local function unsupported(id: string): string?
	if id == "animate-many" then
		return "Roact does not include a spring."
	end
	return nil
end

local function create(environment: Environment.Environment): Types.Driver
	local loadRoact: (string) -> Roact = environment.load
	local roact = loadRoact ".lute/dependencies/roact/src"
	local scope: Types.Scope
	local function reactive<T>(source: Types.Source<T>, render: (T) -> unknown): unknown
		local component = roact.Component:extend "Comparison"
		local disconnect: (() -> ())? = nil
		local version = 0
		component.init = function(self: Component)
			self:setState { version = 0 }
		end
		component.render = function(): unknown
			return render(source.read())
		end
		component.didMount = function(self: Component)
			disconnect = assert(source.watch)(function(_next: T)
				version += 1
				self:setState { version = version }
			end)
		end
		component.willUnmount = function()
			if disconnect then
				disconnect()
			end
		end
		return roact.createElement(component)
	end
	local function value<T>(initial: T): Types.Source<T>
		local binding, update = roact.createBinding(initial)
		local listeners: { [(T) -> ()]: boolean } = {}
		return {
			binding = binding,
			read = function(): T
				return binding:getValue()
			end,
			write = function(next: T)
				update(next)
				for listener in listeners do
					listener(next)
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
	end
	scope = {
		rowState = function(initial: string): Types.RowState
			return Rows.state(scope, initial)
		end,
		value = value,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local keyed: { [unknown]: unknown } = {}
			if children then
				for index, child in children do
					keyed[index] = child
				end
			end
			local props = table.clone(properties)
			local name = props.Name or class
			props.Name = nil
			return roact.createFragment { [name] = roact.createElement(class, props, keyed) }
		end,
		event = function(name: string): unknown
			return roact.Event[name]
		end,
		counterState = function(initial: number): Types.CounterState
			local source = value(initial)
			return {
				node = roact.createElement(
					"TextLabel",
					{ Text = source.bind(function(n: number): unknown
						return tostring(n)
					end) }
				),
				write = source.write,
			}
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			return reactive(list, function(rows: { Types.Row }): unknown
				local children: { [unknown]: unknown } = {}
				for index, row in rows do
					children[tostring(row.id)] =
						roact.createElement("TextLabel", { Text = tostring(row.id), LayoutOrder = index })
				end
				return roact.createFragment(children)
			end)
		end,
		rows = function(list: Types.Source<{ Types.ModelRow }>): unknown
			return reactive(list, function(rows: { Types.ModelRow }): unknown
				local children: { [unknown]: unknown } = {}
				for index, row in rows do
					children[tostring(row.id)] = Rows.node(scope, row, index)
				end
				return roact.createFragment(children)
			end)
		end,
		branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
			return reactive(open, function(visible: boolean): unknown
				return if visible then build(scope) else nil
			end)
		end,
		spring = function(): unknown
			error("Roact has no native spring", 0)
		end,
	} :: Types.Scope
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local handle = roact.mount(build(scope), container)
			return function()
				roact.unmount(handle)
			end
		end,
		batch = function(run: () -> ())
			run()
			environment.drain()
		end,
	}
end

return { create = create, unsupported = unsupported }
