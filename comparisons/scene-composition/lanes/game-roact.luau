--!strict

local Environment = require "../cost-model"
local Types = require "./types"

type Component = {
	setState: (Component, { version: number }) -> (),
	render: ((Component) -> unknown)?,
}
type Roact = {
	Component: { extend: (unknown, string) -> Component },
	createElement: (unknown, Types.Properties?, { [unknown]: unknown }?) -> unknown,
	createContext: (unknown) -> { Provider: unknown, Consumer: unknown },
	mount: (unknown, Environment.Instance) -> unknown,
	unmount: (unknown) -> (),
}

local function create(environment: Environment.Environment): Types.Driver
	local loadRoact: (string) -> Roact = environment.load
	local roact = loadRoact ".lute/dependencies/roact/src"
	local theme = roact.createContext "light"
	return {
		batch = function(run)
			run()
			environment.drain()
		end,
		mount = function(container, build)
			local cells: { { value: unknown } } = {}
			local cursor, version = 0, 0
			local mounted: Component? = nil
			local live = true
			local function constant<T>(current: T): Types.Source<T>
				return {
					binding = current,
					read = function(): T
						return current
					end,
					write = function()
						error("A derived value is read-only", 0)
					end,
					bind = function(map: (T) -> unknown): unknown
						return map(current)
					end,
				}
			end
			local api: Types.Scope = {
				value = function<T>(initial: T): Types.Source<T>
					cursor += 1
					if not cells[cursor] then
						cells[cursor] = { value = initial }
					end
					local cell = cells[cursor]
					local source = constant(cell.value :: T)
					source.write = function(next: T)
						cell.value = next
						if live and mounted then
							version += 1
							mounted:setState { version = version }
						end
					end
					return source
				end,
				computed = function<T>(body: (Types.Use) -> T): Types.Source<T>
					return constant(body(function<U>(source: Types.Source<U>): U
						return source.read()
					end))
				end,
				node = function(class: string, props: Types.Properties, children: { unknown }?): unknown
					local keyed: { [unknown]: unknown } = {}
					local items: { unknown } = children or {}
					for index, child in items do
						keyed[index] = child
					end
					return roact.createElement(class, props, keyed)
				end,
				keyed = function(list: Types.Source<{ Types.Row }>): unknown
					local children: { [unknown]: unknown } = {}
					for index, row in list.read() do
						children[tostring(row.id)] =
							roact.createElement("TextLabel", { Text = tostring(row.id), LayoutOrder = index })
					end
					return roact.createElement("Frame", {}, children)
				end,
				provideTheme = function(source: Types.Source<string>, render: () -> unknown): unknown
					return roact.createElement(theme.Provider, { value = source.read() }, { render() })
				end,
				themeNode = function()
					return roact.createElement(theme.Consumer, {
						render = function(value: string)
							return roact.createElement("TextLabel", { Text = value })
						end,
					})
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
			local component = roact.Component:extend "GamePage"
			component.render = function(self)
				mounted = self
				cursor = 0
				return build(api)
			end
			local handle = roact.mount(roact.createElement(component), container)
			return function()
				live = false
				mounted = nil
				roact.unmount(handle)
				table.clear(cells)
			end
		end,
	}
end

return { create = create }
