--!strict

local Environment = require "../cost-model"
local Types = require "./types"

type Scope = (unknown) -> unknown
type Getter<T> = (Scope?) -> T
type Lookup = { binding: (unknown) -> Getter<unknown>?, event: (unknown) -> string? }
type Signals = {
	createSignal: <T>(T) -> (Getter<T>, (T) -> ()),
	createComputed: ((Scope) -> unknown) -> Getter<unknown>,
	createEffect: ((Scope) -> ()) -> () -> (),
	batch: (() -> ()) -> (),
}

local function unsupported(id: string): string?
	if id == "animate-many" then
		return "Signals is a state library. Springs are outside its scope."
	end
	return nil
end

local function create(environment: Environment.Environment): Types.Driver
	local loadSignals: (string) -> Signals = environment.load
	local signals = loadSignals ".lute/dependencies/signals/src"
	local scopeFor: ({ () -> () }, Lookup?) -> Types.Scope
	function scopeFor(releases: { () -> () }, inherited: Lookup?): Types.Scope
		local bindings: { [unknown]: Getter<unknown> } = {}
		local events: { [unknown]: string } = {}
		local lookup: Lookup = {
			binding = function(key: unknown): Getter<unknown>?
				return bindings[key] or (if inherited then inherited.binding(key) else nil)
			end,
			event = function(key: unknown): string?
				return events[key] or (if inherited then inherited.event(key) else nil)
			end,
		}
		local childrenBindings: { [unknown]: (Environment.Instance) -> () } = {}
		local scope: Types.Scope
		local function value<T>(initial: T): Types.Source<T>
			local get, set = signals.createSignal(initial)
			bindings[get] = function(track: Scope?): unknown
				return get(track)
			end
			return {
				binding = get,
				read = function(): T
					return get(nil)
				end,
				write = set,
				bind = function(map: (T) -> unknown): unknown
					local computed = signals.createComputed(function(track: Scope): unknown
						return map(get(track))
					end)
					bindings[computed] = computed
					return computed
				end,
			}
		end
		local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local instance = environment.globals.Instance.new(class)
			table.insert(releases, function()
				instance:Destroy()
			end)
			for key, property in properties do
				local event = lookup.event(key)
				if event then
					local connection = environment.signal(instance, event):Connect(environment.callback(property))
					table.insert(releases, function()
						connection:Disconnect()
					end)
				else
					assert(type(key) == "string")
					local binding = lookup.binding(property)
					if binding then
						table.insert(
							releases,
							signals.createEffect(function(track: Scope)
								instance[key] = binding(track)
							end)
						)
					else
						instance[key] = property
					end
				end
			end
			if children then
				for _, child in children do
					local binding = childrenBindings[child]
					if binding then
						binding(instance)
					else
						environment.instance(child).Parent = instance
					end
				end
			end
			return instance
		end
		scope = {
			value = value,
			node = node,
			event = function(name: string): unknown
				local key = {}
				events[key] = name
				return key
			end,
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
			keyed = function(list: Types.Source<{ Types.Row }>): unknown
				local key = {}
				childrenBindings[key] = function(parent: Environment.Instance)
					local rows: { [number]: Environment.Instance } = {}
					table.insert(releases, function()
						for _, instance in rows do
							instance:Destroy()
						end
						table.clear(rows)
					end)
					local get = list.binding :: Getter<{ Types.Row }>
					table.insert(
						releases,
						signals.createEffect(function(track: Scope)
							local retained: { [number]: boolean } = {}
							for index, row in get(track) do
								retained[row.id] = true
								local instance = rows[row.id]
								if instance == nil then
									instance = environment.globals.Instance.new "TextLabel"
									rows[row.id] = instance
									instance.Text = tostring(row.id)
									instance.LayoutOrder = index
									instance.Parent = parent
								elseif instance.LayoutOrder ~= index then
									instance.LayoutOrder = index
								end
							end
							for id, instance in rows do
								if not retained[id] then
									rows[id] = nil
									instance:Destroy()
								end
							end
						end)
					)
				end
				return key
			end,
			branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
				local key = {}
				childrenBindings[key] = function(parent: Environment.Instance)
					local owned: { () -> () } = {}
					local function release()
						for index = #owned, 1, -1 do
							owned[index]()
						end
						table.clear(owned)
					end
					table.insert(releases, release)
					local get = open.binding :: Getter<boolean>
					table.insert(
						releases,
						signals.createEffect(function(track: Scope)
							release()
							if get(track) then
								environment.instance(build(scopeFor(owned, lookup))).Parent = parent
							end
						end)
					)
				end
				return key
			end,
			spring = function(): unknown
				error("Signals has no native spring", 0)
			end,
		}
		return scope
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local owned: { () -> () } = {}
			local function release()
				for index = #owned, 1, -1 do
					owned[index]()
				end
				table.clear(owned)
			end
			local ok, detail = pcall(function()
				environment.instance(build(scopeFor(owned))).Parent = container
			end)
			if not ok then
				release()
				error(detail, 0)
			end
			return release
		end,
		batch = function(run: () -> ())
			signals.batch(run)
			environment.drain()
		end,
	}
end

return { create = create, unsupported = unsupported }
