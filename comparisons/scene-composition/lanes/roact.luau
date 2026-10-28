--!strict

local Upstream = require "../harness/upstream"
local Environment = require "../cost-model"
local Types = require "./types"

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
	if id == "scene-3d" then
		return "Roact assigns Instance.Name from reconciliation keys. Named children use dictionary keys, whose mounting order cannot satisfy this workload's ordered named-tree contract."
	end
	if id == "animate-many" then
		return "Roact has no native spring primitive."
	end
	return nil
end

local function create(environment: Environment.Environment): Types.Driver
	local roact: Roact = Upstream.create(environment).load ".lute/dependencies/roact/src"
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
		value = value,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local keyed: { [unknown]: unknown } = {}
			if children then
				for index, child in children do
					keyed[index] = child
				end
			end
			return roact.createElement(class, properties, keyed)
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
		branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
			return reactive(open, function(visible: boolean): unknown
				return if visible then build(scope) else nil
			end)
		end,
		spring = function(): unknown
			error("Roact has no native spring", 0)
		end,
	}
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
