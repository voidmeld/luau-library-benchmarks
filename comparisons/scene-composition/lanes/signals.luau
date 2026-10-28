--!strict

local Environment = require "../cost-model"
local Types = require "./types"

type Scope = (unknown) -> unknown
type Getter<T> = (Scope?) -> T
type Signals = {
	createSignal: <T>(T) -> (Getter<T>, (T) -> ()),
	createComputed: ((Scope) -> unknown) -> Getter<unknown>,
	createEffect: ((Scope) -> ()) -> () -> (),
	batch: (() -> ()) -> (),
}

local function unsupported(id: string): string?
	if id:match "^keyed%-" or id == "status-panel" then
		return "Signals is a state library. Keyed Instance collections and row lifetimes are outside its scope."
	elseif id == "branch-swap" then
		return "Signals is a state library. Conditional Instance ownership is outside its scope, and a scene reconciler would change what this lane measures."
	elseif id == "animate-many" then
		return "Signals is a state library. Springs are outside its scope."
	end
	return nil
end

local function create(environment: Environment.Environment): Types.Driver
	local signals: Signals = environment.load ".lute/dependencies/signals/src"
	local releases: { () -> () } = {}
	local bindings: { [unknown]: Getter<unknown> } = {}
	local events: { [unknown]: string } = {}
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
			local event = events[key]
			if event then
				local connection = environment.signal(instance, event):Connect(environment.callback(property))
				table.insert(releases, function()
					connection:Disconnect()
				end)
			else
				assert(type(key) == "string")
				local binding = bindings[property]
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
				environment.instance(child).Parent = instance
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
		keyed = function(): unknown
			error("Signals has no native keyed collection", 0)
		end,
		branch = function(): unknown
			error("Signals has no native conditional ownership", 0)
		end,
		spring = function(): unknown
			error("Signals has no native spring", 0)
		end,
	}
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local owned: { () -> () } = {}
			releases = owned
			local function release()
				for index = #owned, 1, -1 do
					owned[index]()
				end
				table.clear(owned)
				table.clear(bindings)
				table.clear(events)
			end
			local ok, detail = pcall(function()
				environment.instance(build(scope)).Parent = container
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
