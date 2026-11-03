--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Rows = require "./rows"

local function create(environment: Environment.Environment): Types.Driver
	local releases: { () -> () } = {}
	type Marker = {
		cell: Marker,
		map: (unknown) -> unknown,
		current: unknown,
		listeners: { [(unknown) -> ()]: boolean }?,
	}
	local MARKER = {}
	local function marked(property: unknown): Marker?
		if type(property) == "table" and getmetatable(property) == MARKER then
			return property :: Marker
		end
		return nil
	end
	local function same(next: unknown): unknown
		return next
	end
	local collections: { [unknown]: (Environment.Instance) -> () } = {}
	setmetatable(collections, { __mode = "k" })
	local grouped = false
	local scope: Types.Scope
	local function subscribe(marker: Marker, write: (unknown) -> ()): () -> ()
		local cell, map = marker.cell, marker.map
		local function update(next: unknown)
			write(map(next))
		end
		update(cell.current)
		local set = cell.listeners or {}
		cell.listeners = set
		set[update] = true
		return function()
			set[update] = nil
			if next(set) == nil and cell.listeners == set then
				cell.listeners = nil
			end
		end
	end
	local methods: { [string]: (Marker) -> unknown } = {
		read = function(cell: Marker): unknown
			return function(): unknown
				return cell.current
			end
		end,
		write = function(cell: Marker): unknown
			return function(next: unknown)
				if cell.current == next then
					return
				end
				cell.current = next
				local listeners = cell.listeners
				if listeners then
					for listener in listeners do
						listener(next)
					end
				end
			end
		end,
		bind = function(cell: Marker): unknown
			return function(map: (unknown) -> unknown): unknown
				return setmetatable({ cell = cell, map = map }, MARKER)
			end
		end,
	}
	local SOURCE = {
		__index = function(source: { [string]: unknown }, key: string): unknown
			local method = methods[key]
			if method == nil then
				return nil
			end
			local made = method(source.binding :: Marker)
			rawset(source, key, made)
			return made
		end,
	}
	local function value<T>(initial: T): Types.Source<T>
		local cell = setmetatable({ current = initial, map = same }, MARKER) :: Marker
		cell.cell = cell
		return (setmetatable({ binding = cell }, SOURCE) :: unknown) :: Types.Source<T>
	end
	local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
		local instance = environment.globals.Instance.new(class)
		if not grouped then
			table.insert(releases, function()
				instance:Destroy()
			end)
		end
		for key, property in properties do
			assert(type(key) == "string")
			if key == "Activated" then
				local connection = environment.signal(instance, key):Connect(environment.callback(property))
				if not grouped then
					table.insert(releases, function()
						connection:Disconnect()
					end)
				end
			elseif marked(property) then
				local marker = assert(marked(property))
				table.insert(
					releases,
					subscribe(marker, function(next: unknown)
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
	local built: Types.Scope = {
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
				local count = 0
				local shown: { number } = {}
				local listed = assert(marked(list.binding))
				local stop = subscribe(listed, function(next: unknown)
					local rows = next :: { Types.ModelRow }
					for index, row in rows do
						if shown[index] == row.id then
							continue
						end
						shown[index] = row.id
						local entry = current[row.id]
						if entry then
							entry.position.write(index)
						else
							local outer = releases
							local owned: { () -> () } = {}
							releases = owned
							grouped = true
							local position = value(index)
							local instance = environment.instance(Rows.node(scope, row, position.binding))
							grouped = false
							releases = outer
							table.insert(owned, 1, function()
								instance:Destroy()
							end)
							instance.Parent = parent
							current[row.id] = {
								position = position,
								release = function()
									for offset = #owned, 1, -1 do
										owned[offset]()
									end
								end,
							}
							count += 1
						end
					end
					for index = #shown, #rows + 1, -1 do
						shown[index] = nil
					end
					if count == #rows then
						return
					end
					local wanted: { [number]: boolean } = {}
					for _, row in rows do
						wanted[row.id] = true
					end
					for id, entry in current do
						if not wanted[id] then
							entry.release()
							current[id] = nil
							count -= 1
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
	}
	scope = built
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
