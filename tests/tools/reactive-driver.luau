--!strict

local Environment = require "../../comparisons/scene-composition/cost-model"
local Types = require "../../comparisons/scene-composition/lanes/types"

local function unavailable(): never
	error("Game workloads use only values, computeds, nodes and keyed lists", 0)
end

local function create(environment: Environment.Environment): Types.Driver
	local Instance = environment.globals.Instance
	local version = 0
	local roots: { [() -> ()]: boolean } = {}
	local readers: { [unknown]: () -> unknown } = {}
	setmetatable(readers, { __mode = "k" })
	return {
		batch = function(run)
			run()
			for root in roots do
				root()
			end
		end,
		mount = function(container, build)
			local effects: { () -> () } = {}
			local function computed<T>(body: (Types.Use) -> T): Types.Source<T>
				local seen = -1
				local cached: T
				local function read(): T
					if seen ~= version then
						cached = body(function<U>(source: Types.Source<U>): U
							return source.read()
						end)
						seen = version
					end
					return cached
				end
				readers[read] = read
				return {
					binding = read,
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
				local instance = Instance.new(class)
				for property, value in props do
					assert(type(property) == "string")
					local binding = readers[value]
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
				for _, child in children or {} do
					environment.instance(child).Parent = instance
				end
				return instance
			end
			local scope: Types.Scope = {
				computed = computed,
				value = function<T>(initial: T): Types.Source<T>
					local current = initial
					local function read(): T
						return current
					end
					readers[read] = read
					return {
						binding = read,
						read = read,
						write = function(next: T)
							current = next
							version += 1
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
							local label = rows[row.id]
							if label == nil then
								label = Instance.new "TextLabel"
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
				event = unavailable,
				branch = unavailable,
				counterState = unavailable,
				spring = unavailable,
			}
			local root = environment.instance(build(scope))
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
				table.clear(effects)
			end
		end,
	}
end

return { create = create }
