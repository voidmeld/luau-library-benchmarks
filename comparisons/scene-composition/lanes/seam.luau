--!strict

local Environment = require "../cost-model"
local Types = require "./types"

type Value<T> = { Value: T }
type NativeScope = {
	AddObject: <T>(NativeScope, T) -> T,
	InnerScope: (NativeScope) -> unknown,
	Destroy: (NativeScope) -> (),
}
type Use = (unknown) -> unknown
type Seam = {
	Scope: () -> NativeScope,
	Value: <T>(T) -> Value<T>,
	Computed: ((Use) -> unknown) -> unknown,
	ForPairs: (unknown, (Use, Types.Row, boolean) -> unknown) -> unknown,
	New: (unknown, Types.Properties) -> unknown,
	Children: unknown,
	OnEvent: (string) -> unknown,
	Batch: (() -> ()) -> (),
	Spring: (unknown, number, number) -> unknown,
}

local function create(environment: Environment.Environment): Types.Driver
	local seam: Seam = environment.load ".lute/dependencies/seam/src"
	local scopeFor: (NativeScope) -> Types.Scope
	function scopeFor(native: NativeScope): Types.Scope
		local states: { [unknown]: boolean } = {}
		local function computed(callback: (Use) -> unknown): unknown
			local state = native:AddObject(seam.Computed(callback))
			states[state] = true
			return state
		end
		local function value<T>(initial: T): Types.Source<T>
			local state = native:AddObject(seam.Value(initial))
			states[state] = true
			return {
				binding = state,
				read = function(): T
					return state.Value
				end,
				write = function(next: T)
					state.Value = next
				end,
				bind = function(map: (T) -> unknown): unknown
					return computed(function(use: Use): unknown
						use(state)
						return map(state.Value)
					end)
				end,
			}
		end
		local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local props = table.clone(properties)
			if children then
				local items = children
				props[seam.Children] = computed(function(use: Use): unknown
					local result: { unknown } = {}
					for _, child in items do
						local current = if states[child] then use(child) else child
						if type(current) == "table" then
							for _, item in environment.entries(current) do
								table.insert(result, item)
							end
						elseif current ~= nil then
							table.insert(result, current)
						end
					end
					return result
				end)
			end
			return native:AddObject(seam.New(class, props))
		end
		return {
			value = value,
			node = node,
			event = seam.OnEvent,
			counterState = function(initial: number): Types.CounterState
				local source = value(initial)
				return {
					node = node(
						"TextLabel",
						{ Text = source.bind(function(n: number): unknown
							return tostring(n)
						end) }
					),
					write = source.write,
				}
			end,
			spring = function(target: Types.Source<number>, offset: number): unknown
				local spring = native:AddObject(seam.Spring(
					target.bind(function(n: number): unknown
						return n + offset
					end),
					2 * math.pi / 0.3,
					1
				))
				return computed(function(use: Use): unknown
					local current = use(spring)
					assert(type(current) == "number")
					return math.round(current)
				end)
			end,
			branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
				local current: NativeScope? = nil
				return computed(function(use: Use): unknown
					use(open.binding)
					if current ~= nil then
						current:Destroy()
						current = nil
					end
					if not open.read() then
						return {}
					end
					local inner = native:InnerScope() :: NativeScope
					current = inner
					return build(scopeFor(inner))
				end)
			end,
			keyed = function(list: Types.Source<{ Types.Row }>): unknown
				local positions: { [Types.Row]: number } = {}
				local order = list.bind(function(rows: { Types.Row }): unknown
					local result: { [Types.Row]: number } = {}
					for index, row in rows do
						result[row] = index
					end
					positions = result
					return result
				end)
				local rowReleases: { [Types.Row]: () -> () } = {}
				local keyed = list.bind(function(rows: { Types.Row }): unknown
					local result: { [Types.Row]: boolean } = {}
					for _, row in rows do
						result[row] = true
					end
					for row, release in rowReleases do
						if not result[row] then
							rowReleases[row] = nil
							release()
						end
					end
					return result
				end)
				local result = native:AddObject(
					seam.ForPairs(keyed, function(_use: Use, row: Types.Row, _present: boolean): unknown
						local rowScope = native:InnerScope() :: NativeScope
						rowReleases[row] = function()
							rowScope:Destroy()
						end
						return scopeFor(rowScope).node("TextLabel", {
							Text = tostring(row.id),
							LayoutOrder = rowScope:AddObject(seam.Computed(function(use: Use): unknown
								use(order)
								return positions[row] or 0
							end)),
						})
					end)
				)
				states[result] = true
				return result
			end,
		}
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local native = seam.Scope()
			local ok, detail = pcall(function()
				local root = build(scopeFor(native))
				seam.New(container, { [seam.Children] = { root } })
			end)
			if not ok then
				native:Destroy()
				error(detail, 0)
			end
			return function()
				native:Destroy()
			end
		end,
		batch = function(run: () -> ())
			seam.Batch(run)
			environment.step(0)
			environment.drain()
		end,
	}
end

return { create = create }
