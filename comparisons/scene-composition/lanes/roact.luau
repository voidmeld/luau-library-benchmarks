--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Rows = require "./rows"
local Joined = require "./joined"

type Binding<T> = { getValue: (Binding<T>) -> T, map: (Binding<T>, (T) -> unknown) -> unknown }
type Component = {
	setState: (Component, { version: number }) -> (),
	init: ((Component) -> ())?,
	render: ((Component) -> unknown)?,
	didMount: ((Component) -> ())?,
	willUnmount: ((Component) -> ())?,
}
type RowProps = { row: Types.ModelRow, index: number }
type RowComponent = { props: RowProps, render: ((RowComponent) -> unknown)? }
type Roact = {
	createElement: (unknown, Types.Properties?, { unknown }?) -> unknown,
	createFragment: ({ [unknown]: unknown }) -> unknown,
	createBinding: <T>(T) -> (Binding<T>, (T) -> ()),
	joinBindings: (unknown) -> unknown,
	createContext: (unknown) -> { Provider: unknown, Consumer: unknown },
	Component: { extend: (unknown, string) -> Component },
	PureComponent: { extend: (unknown, string) -> RowComponent },
	Event: { [string]: unknown },
	mount: (unknown, Environment.Instance, string?) -> unknown,
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
	local theme = roact.createContext(nil)
	local function themed(binding: unknown): unknown
		return roact.createElement("TextLabel", { Text = binding })
	end
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
	local lastElement: unknown = nil
	local lastClass: string? = nil
	local built: Types.Scope = {
		rowState = function(initial: string): Types.RowState
			return Rows.state(scope, initial)
		end,
		value = value,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local name = properties.Name
			if name == nil then
				local element = roact.createElement(class, properties, children)
				lastElement, lastClass = element, class
				return element
			end
			local props = table.clone(properties)
			props.Name = nil
			return roact.createFragment { [name] = roact.createElement(class, props, children) }
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
			local Row = roact.PureComponent:extend "Row"
			Row.render = function(self: RowComponent): unknown
				return Rows.node(scope, self.props.row, self.props.index)
			end
			return reactive(list, function(rows: { Types.ModelRow }): unknown
				local children: { [unknown]: unknown } = {}
				for index, row in rows do
					children[tostring(row.id)] = roact.createElement(Row, { row = row, index = index })
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
	built.provideTheme = function(source: Types.Source<string>, render: () -> unknown): unknown
		return roact.createElement(theme.Provider, { value = source.binding }, { render() })
	end
	built.themeNode = function(): unknown
		return roact.createElement(theme.Consumer, { render = themed })
	end
	Joined.extend(built, roact.joinBindings)
	scope = built
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local root = build(scope)
			local handle = roact.mount(root, container, if root == lastElement then lastClass else nil)
			lastElement, lastClass = nil, nil
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
