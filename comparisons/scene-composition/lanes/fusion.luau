--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"
local Derived = require "./derived"

type Value<T> = { set: (Value<T>, T) -> () }
type Scope = { unknown }
type Use = (unknown) -> unknown
type Fusion = {
	Contextual: (
		unknown
	) -> { now: (unknown) -> unknown, is: (unknown, unknown) -> { during: (unknown, () -> unknown) -> unknown } },
	scoped: () -> Scope,
	Value: <T>(Scope, T) -> Value<T>,
	peek: <T>(Value<T>) -> T,
	Computed: (Scope, (Use, Scope) -> unknown) -> unknown,
	Spring: (Scope, unknown, number, number) -> Value<number>,
	ForPairs: (Scope, unknown, (Use, Scope, Types.Row, boolean) -> (Types.Row, unknown)) -> unknown,
	New: (Scope, string) -> (Types.Properties) -> Environment.Instance,
	Children: unknown,
	OnEvent: (string) -> unknown,
	doCleanup: (Scope) -> (),
}

local function create(environment: Environment.Environment, stateDriver: State.State?): Types.Driver
	local loadFusion: (string) -> Fusion = environment.load
	local fusion = loadFusion ".lute/dependencies/fusion/src"
	local theme = fusion.Contextual(nil)
	environment.drain()
	local scopeFor: (Scope) -> Types.Scope
	function scopeFor(scope: Scope): Types.Scope
		local function value<T>(initial: T): Types.Source<T>
			local state = fusion.Value(scope, initial)
			local cell = if stateDriver
				then stateDriver.value(initial, function(next: T)
					state:set(next)
				end)
				else nil
			if cell then
				table.insert(scope, cell.release)
			end
			return {
				binding = state,
				read = function(): T
					return if cell then cell.read() else fusion.peek(state)
				end,
				write = function(next: T)
					if cell then
						cell.write(next)
					else
						state:set(next)
					end
				end,
				bind = function(map: (T) -> unknown): unknown
					return fusion.Computed(scope, function(use: Use): unknown
						use(state)
						return map(fusion.peek(state))
					end)
				end,
			}
		end
		local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local props = table.clone(properties)
			if children then
				props[fusion.Children] = children
			end
			return fusion.New(scope, class)(props)
		end
		local api: Types.Scope = {
			spring = function(target: Types.Source<number>, offset: number): unknown
				local moved = fusion.Spring(
					scope,
					target.bind(function(value: number): unknown
						return value + offset
					end),
					2 * math.pi / 0.3,
					1
				)
				return fusion.Computed(scope, function(use: Use): unknown
					use(moved)
					return math.round(fusion.peek(moved))
				end)
			end,
			counterState = function(initial: number): Types.CounterState
				local text = value(initial)
				return {
					node = node("TextLabel", {
						Text = text.bind(function(current: number): unknown
							return tostring(current)
						end),
					}),
					write = text.write,
				}
			end,
			value = value,
			node = node,
			event = fusion.OnEvent,
			keyed = function(list: Types.Source<{ Types.Row }>): unknown
				local positions: { [Types.Row]: number } = {}
				local orderVersion = list.bind(function(rows: { Types.Row }): unknown
					local result: { [Types.Row]: number } = {}
					for index, row in rows do
						result[row] = index
					end
					positions = result
					return result
				end)
				local keyed = list.bind(function(rows: { Types.Row }): unknown
					local result: { [Types.Row]: boolean } = {}
					for _, row in rows do
						result[row] = true
					end
					return result
				end)
				return fusion.ForPairs(
					scope,
					keyed,
					function(_use: Use, inner: Scope, row: Types.Row, _present: boolean): (Types.Row, unknown)
						return row,
							fusion.New(inner, "TextLabel") {
								Text = tostring(row.id),
								LayoutOrder = fusion.Computed(inner, function(use: Use): unknown
									use(orderVersion)
									return positions[row] or 0
								end),
							}
					end
				)
			end,
			branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
				local visible = open.binding
				return fusion.Computed(scope, function(use: Use, inner: Scope): unknown
					local current = use(visible)
					return if current then build(scopeFor(inner)) else nil
				end)
			end,
		}
		Derived.extend(api, function(body)
			return fusion.Computed(scope, function(use: Use, _inner: Scope): unknown
				return body(use)
			end)
		end, function(binding)
			return fusion.peek(binding :: Value<unknown>)
		end)
		api.provideTheme = function(value, build)
			local provider = theme:is(value)
			return provider:during(build)
		end
		api.themeText = function()
			return (theme:now() :: Types.Source<string>).binding
		end
		return api
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local scope = fusion.scoped()
			local api = scopeFor(scope)
			local ok, detail = pcall(function()
				environment.instance(build(api)).Parent = container
			end)
			if not ok then
				fusion.doCleanup(scope)
				error(detail, 0)
			end
			return function()
				fusion.doCleanup(scope)
			end
		end,
		batch = function(run: () -> ())
			if stateDriver then
				stateDriver.batch(run)
			else
				run()
			end
			environment.drain()
		end,
	}
end

return { create = create }
