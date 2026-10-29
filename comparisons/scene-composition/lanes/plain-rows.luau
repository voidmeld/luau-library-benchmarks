--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Rows = require "./rows"

local function create(environment: Environment.Environment): Types.Driver
	local releases: { () -> () } = {}
	local bindings: { [unknown]: ((unknown) -> ()) -> () -> () } = {}
	local collections: { [unknown]: (Environment.Instance) -> () } = {}
	local scope: Types.Scope
	local function value<T>(initial: T): Types.Source<T>
		local current = initial
		local listeners: { [(T) -> ()]: boolean } = {}
		local function bind(map: (T) -> unknown): unknown
			local marker = {}
			bindings[marker] = function(write: (unknown) -> ()): () -> ()
				local function update(next: T)
					write(map(next))
				end
				update(current)
				listeners[update] = true
				return function()
					listeners[update] = nil
				end
			end
			return marker
		end
		local binding = bind(function(next: T): unknown
			return next
		end)
		return {
			binding = binding,
			read = function(): T
				return current
			end,
			write = function(next: T)
				if current == next then
					return
				end
				current = next
				for listener in listeners do
					listener(next)
				end
			end,
			bind = bind,
		}
	end
	local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
		local instance = environment.globals.Instance.new(class)
		table.insert(releases, function()
			instance:Destroy()
		end)
		for key, property in properties do
			assert(type(key) == "string")
			if key == "Activated" then
				local connection = environment.signal(instance, key):Connect(environment.callback(property))
				table.insert(releases, function()
					connection:Disconnect()
				end)
			elseif bindings[property] then
				table.insert(
					releases,
					bindings[property](function(next: unknown)
						instance[key] = next
					end)
				)
			else
				instance[key] = property
			end
		end
		if children then
			for _, child in children do
				if collections[child] then
					collections[child](instance)
				else
					environment.instance(child).Parent = instance
				end
			end
		end
		return instance
	end
	local function unused(): never
		error("plain row driver only supports row workloads", 0)
	end
	scope = {
		rowState = function(initial: string): Types.RowState
			return Rows.state(scope, initial)
		end,
		value = value,
		node = node,
		event = function(name: string): unknown
			return name
		end,
		keyed = function(_list: Types.Source<{ Types.Row }>): unknown
			return unused()
		end,
		branch = function(_open: Types.Source<boolean>, _build: (Types.Scope) -> unknown): unknown
			return unused()
		end,
		counterState = function(_initial: number): Types.CounterState
			return unused()
		end,
		spring = function(_target: Types.Source<number>, _offset: number): unknown
			return unused()
		end,
		rows = function(list: Types.Source<{ Types.ModelRow }>): unknown
			local marker = {}
			collections[marker] = function(parent: Environment.Instance)
				local current: { [number]: { position: Types.Source<number>, release: () -> () } } = {}
				local stop = bindings[list.binding](function(next: unknown)
					local rows = next :: { Types.ModelRow }
					local wanted: { [number]: boolean } = {}
					for index, row in rows do
						wanted[row.id] = true
						local entry = current[row.id]
						if entry then
							entry.position.write(index)
						else
							local outer = releases
							local owned: { () -> () } = {}
							releases = owned
							local position = value(index)
							local instance = environment.instance(Rows.node(scope, row, position.binding))
							releases = outer
							instance.Parent = parent
							current[row.id] = {
								position = position,
								release = function()
									for offset = #owned, 1, -1 do
										owned[offset]()
									end
								end,
							}
						end
					end
					for id, entry in current do
						if not wanted[id] then
							entry.release()
							current[id] = nil
						end
					end
				end)
				table.insert(releases, function()
					stop()
					for _, entry in current do
						entry.release()
					end
				end)
			end
			return marker
		end,
	} :: Types.Scope
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local owned: { () -> () } = {}
			releases = owned
			environment.instance(build(scope)).Parent = container
			return function()
				for index = #owned, 1, -1 do
					owned[index]()
				end
				table.clear(owned)
			end
		end,
		batch = function(run: () -> ())
			run()
			environment.drain()
		end,
	}
end

return { create = create }
