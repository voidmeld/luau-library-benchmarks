--!strict

local Environment = require "../cost-model"
local Types = require "./types"

local function create(environment: Environment.Environment): Types.Driver
	local version, depth = 0, 0
	local roots: { [() -> ()]: boolean } = {}
	local bindings: { [unknown]: () -> unknown } = {}
	setmetatable(bindings, { __mode = "k" })
	local function flush()
		for root in roots do
			root()
		end
	end
	return {
		batch = function(run)
			depth += 1
			run()
			depth -= 1
			if depth == 0 then
				flush()
			end
		end,
		mount = function(container, build)
			local effects: { () -> () } = {}
			local made: { Environment.Instance } = {}
			local theme: Types.Source<string>? = nil
			local api: Types.Scope
			local function computed<T>(body: (Types.Use) -> T): Types.Source<T>
				local seen = -1
				local cached: T
				local key = {}
				local function read(): T
					if seen ~= version then
						cached = body(function<U>(source: Types.Source<U>): U
							return source.read()
						end)
						seen = version
					end
					return cached
				end
				bindings[key] = read
				return {
					binding = key,
					read = read,
					write = function()
						error("A derived value is read-only", 0)
					end,
					bind = function(map: (T) -> unknown): unknown
						return computed(function()
							return map(read())
						end).binding
					end,
				}
			end
			local function node(class: string, props: Types.Properties, children: { unknown }?): unknown
				local instance = environment.globals.Instance.new(class)
				table.insert(made, instance)
				for property, value in props do
					assert(type(property) == "string")
					local binding = bindings[value]
					if binding then
						local previous: unknown = nil
						local function update()
							local next = binding()
							if previous ~= next then
								instance[property] = next
								previous = next
							end
						end
						update()
						table.insert(effects, update)
					else
						instance[property] = value
					end
				end
				local items: { unknown } = children or {}
				for _, child in items do
					environment.instance(child).Parent = instance
				end
				return instance
			end
			api = {
				computed = computed :: Types.Compute,
				value = function<T>(initial: T): Types.Source<T>
					local current = initial
					local key = {}
					bindings[key] = function(): T
						return current
					end
					return {
						binding = key,
						read = function(): T
							return current
						end,
						write = function(next: T)
							current = next
							version += 1
							if depth == 0 then
								flush()
							end
						end,
						bind = function(map: (T) -> unknown): unknown
							return computed(function()
								return map(current)
							end).binding
						end,
					}
				end,
				node = node,
				keyed = function(list: Types.Source<{ Types.Row }>): unknown
					local frame = environment.instance(node("Frame", {}))
					local rows: { [number]: Environment.Instance } = {}
					local function update()
						local retained: { [number]: boolean } = {}
						for index, row in list.read() do
							retained[row.id] = true
							local label = rows[row.id] or environment.globals.Instance.new "TextLabel"
							if not rows[row.id] then
								label.Text = tostring(row.id)
								label.Parent = frame
								rows[row.id] = label
							end
							if label.LayoutOrder ~= index then
								label.LayoutOrder = index
							end
						end
						for id, label in rows do
							if not retained[id] then
								label:Destroy()
								rows[id] = nil
							end
						end
					end
					update()
					table.insert(effects, update)
					return frame
				end,
				provideTheme = function(source: Types.Source<string>, render: () -> unknown): unknown
					local previous = theme
					theme = source
					local result = render()
					theme = previous
					return result
				end,
				themeText = function()
					return assert(theme).binding
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
			} :: Types.Scope
			local root = environment.instance(build(api))
			root.Parent = container
			local function update()
				for _, effect in effects do
					effect()
				end
			end
			roots[update] = true
			return function()
				roots[update] = nil
				root:Destroy()
				table.clear(made)
				table.clear(effects)
			end
		end,
	}
end

return { create = create }
