--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Derived = require "./derived"

type Vide = {
	derive: (() -> unknown) -> () -> unknown,
	context: () -> (...unknown) -> unknown,
	strict: boolean,
	source: <T>(T) -> (T?) -> T,
	create: (string) -> (Types.Properties) -> Environment.Instance,
	cleanup: (unknown) -> (),
	values: (() -> { Types.Row }, (Types.Row, () -> number) -> unknown) -> unknown,
	show: (() -> boolean, () -> unknown) -> unknown,
	mount: (() -> unknown, Environment.Instance) -> () -> (),
	batch: (() -> ()) -> (),
	spring: (() -> number, number, number) -> () -> number,
}

local function create(environment: Environment.Environment): Types.Driver
	local loadVide: (string) -> Vide = environment.load
	local vide = loadVide ".lute/dependencies/vide/src"
	vide.strict = false
	local theme = vide.context()
	local function owned(instance: unknown): unknown
		vide.cleanup(instance)
		return instance
	end
	local scope: Types.Scope
	scope = {
		spring = function(target: Types.Source<number>, offset: number): unknown
			local moved = vide.spring(function(): number
				return target.read() + offset
			end, 0.3, 1)
			return function(): number
				return math.round(moved())
			end
		end,
		counterState = function(initial: number): Types.CounterState
			local text = scope.value(initial)
			return {
				node = scope.node(
					"TextLabel",
					{ Text = text.bind(function(current: number): unknown
						return tostring(current)
					end) }
				),
				write = text.write,
			}
		end,
		value = function<T>(initial: T): Types.Source<T>
			local source = vide.source(initial)
			return {
				binding = source,
				read = function(): T
					return source()
				end,
				write = function(next: T)
					source(next)
				end,
				bind = function(map: (T) -> unknown): unknown
					return function(): unknown
						return map(source())
					end
				end,
			}
		end,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local props = table.clone(properties)
			if children then
				props[1] = children
			end
			return vide.create(class)(props)
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			return vide.values(list.read, function(row: Types.Row, index: () -> number): unknown
				local instance = vide.create "TextLabel" { Text = tostring(row.id), LayoutOrder = index }
				vide.cleanup(instance)
				return instance
			end)
		end,
		branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
			return vide.show(open.read, function(): unknown
				return owned(build(scope))
			end)
		end,
		event = function(name: string): unknown
			return name
		end,
	} :: Types.Scope
	Derived.extend(scope, function(body)
		return vide.derive(function()
			return body(function(binding)
				return (binding :: () -> unknown)()
			end)
		end)
	end, function(binding)
		return (binding :: () -> unknown)()
	end)
	scope.provideTheme = function(value: Types.Source<string>, build: () -> unknown): unknown
		return theme(value, build)
	end
	scope.themeText = function(): unknown
		return (theme() :: Types.Source<string>).binding
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			return vide.mount(function(): unknown
				return owned(build(scope))
			end, container)
		end,
		batch = function(run: () -> ())
			vide.batch(run)
			environment.drain()
		end,
	}
end

return { create = create }
