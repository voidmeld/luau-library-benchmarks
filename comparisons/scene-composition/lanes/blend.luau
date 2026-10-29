--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local GameBlend = require "./game-blend"
local Rows = require "./rows"

type Destroyable = { Destroy: (Destroyable) -> () }
type State<T> = { Value: T, Destroy: (State<T>) -> () }
type Maid = { GiveTask: (Maid, unknown) -> (), Destroy: (Maid) -> () }
type Observable = { Subscribe: (Observable) -> Destroyable }
type Blend = {
	State: <T>(T) -> State<T>,
	New: (string) -> (Types.Properties) -> Observable,
	Computed: <T>(unknown, (T) -> unknown) -> unknown,
	Throttled: (unknown) -> unknown,
	Shared: (unknown) -> unknown,
	toPropertyObservable: (unknown) -> unknown,
	ComputedPairs: <T>(unknown, (number, T, Maid) -> unknown) -> unknown,
	Spring: (unknown, number, number) -> unknown,
	Children: unknown,
	OnEvent: (string) -> unknown,
	mount: (Environment.Instance, Types.Properties) -> Maid,
}

local function create(environment: Environment.Environment): Types.Driver
	local loadBlend: (string) -> Blend = environment.load
	local blend = loadBlend ".lute/dependencies/blend/src/blend/src/Shared/Blend/Blend.lua"
	local loadMaidClass: (string) -> { new: () -> Maid } = environment.load
	local maidClass = loadMaidClass ".lute/dependencies/blend/src/maid/src/Shared/Maid.lua"
	local extendGame = GameBlend.create(environment)
	local function scopeFor(maid: Maid): Types.Scope
		local scope: Types.Scope
		scope = {
			rowState = function(initial: string): Types.RowState
				return Rows.state(scope, initial)
			end,
			spring = function(target: Types.Source<number>, offset: number): unknown
				local moved = blend.Spring(
					target.bind(function(value: number): unknown
						return value + offset
					end),
					2 * math.pi / 0.3,
					1
				)
				return blend.Computed(moved, function(value: number): unknown
					return math.round(value)
				end)
			end,
			counterState = function(initial: number): Types.CounterState
				local text = scope.value(initial)
				local observed = blend.Throttled(blend.toPropertyObservable(text.binding))
				local formatted = blend.Computed(observed, function(current: number): unknown
					return tostring(current)
				end)
				return { node = scope.node("TextLabel", { Text = formatted }), write = text.write }
			end,
			value = function<T>(initial: T): Types.Source<T>
				local state = blend.State(initial)
				maid:GiveTask(state)
				return {
					binding = state,
					read = function(): T
						return state.Value
					end,
					write = function(next: T)
						state.Value = next
					end,
					bind = function(map: (T) -> unknown): unknown
						return blend.Computed(state, map)
					end,
				}
			end,
			node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
				local props = table.clone(properties)
				if children then
					props[blend.Children] = children
				end
				return blend.New(class)(props)
			end,
			keyed = function(list: Types.Source<{ Types.Row }>): unknown
				local positions = blend.Shared(list.bind(function(rows: { Types.Row }): unknown
					local result: { [Types.Row]: number } = {}
					for index, row in rows do
						result[row] = index
					end
					return result
				end))
				local keyed = list.bind(function(rows: { Types.Row }): unknown
					local result: { [number]: Types.Row } = {}
					for _, row in rows do
						result[row.id] = row
					end
					return result
				end)
				return blend.ComputedPairs(keyed, function(_key: number, row: Types.Row): unknown
					return blend.New "TextLabel" {
						Text = tostring(row.id),
						LayoutOrder = blend.Computed(positions, function(order: { [Types.Row]: number }): unknown
							return order[row] or 0
						end),
					}
				end)
			end,
			rows = function(list: Types.Source<{ Types.ModelRow }>): unknown
				local loadRx: (string) -> { distinct: () -> (unknown) -> unknown } = environment.load
				local rx = loadRx ".lute/dependencies/blend/src/rx/src/Shared/Rx.lua"
				local positions = blend.Shared(list.bind(function(rows: { Types.ModelRow }): unknown
					local result: { [number]: number } = {}
					for index, row in rows do
						result[row.id] = index
					end
					return result
				end))
				local keyed = list.bind(function(rows: { Types.ModelRow }): unknown
					local result: { [number]: Types.ModelRow } = {}
					for _, row in rows do
						result[row.id] = row
					end
					return result
				end)
				return blend.ComputedPairs(keyed, function(_key: number, row: Types.ModelRow): unknown
					local previous = 0
					local position = blend.Computed(positions, function(order: { [number]: number }): unknown
						previous = order[row.id] or previous
						return previous
					end)
					return Rows.node(scope, row, rx.distinct()(position))
				end)
			end,
			branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
				local entries = open.bind(function(visible: boolean): unknown
					return if visible then { true } else {}
				end)
				return blend.ComputedPairs(
					entries,
					function(_index: number, _visible: boolean, innerMaid: Maid): unknown
						return build(scopeFor(innerMaid))
					end
				)
			end,
			event = blend.OnEvent,
		} :: Types.Scope
		extendGame(scope, function(task: unknown)
			maid:GiveTask(task)
		end)
		return scope
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local maid = maidClass.new()
			local ok, detail = pcall(function()
				maid:GiveTask(blend.mount(container, { [blend.Children] = build(scopeFor(maid)) }))
			end)
			if not ok then
				maid:Destroy()
				error(detail, 0)
			end
			return function()
				maid:Destroy()
			end
		end,
		batch = function(run: () -> ())
			run()
			environment.drain()
		end,
	}
end

return { create = create }
