--!strict

local Test = require "../harness"
local Environment = require "../../comparisons/scene-composition/cost-model"
local GameUI = require "../../comparisons/scene-composition/workloads/game-ui"
local Plain = require "../../comparisons/scene-composition/lanes/game-plain"
local Lane = require "../../comparisons/scene-composition/lanes/types"
local Workloads = require "../../comparisons/scene-composition/workloads"
local Lute = require "../../.lute/dependencies/verify/src/lute"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function rejected(id: string, decorate: (Lane.Scope) -> Lane.Scope): string
	local environment = Environment.create()
	local driver = Plain.create(environment)
	local mount = driver.mount
	driver.mount = function(container, build)
		return mount(container, function(scope)
			return build(decorate(scope))
		end)
	end
	local case = GameUI.caseFor(id, function()
		return driver
	end)
	local context: Workloads.Context = {
		env = environment,
		library = nil,
		extras = {},
		container = environment.container(),
		observe = function() end,
		collect = function()
			Lute.memory.settle { cycles = 2 }
		end,
	}
	local state = case.prepare(context)
	local ok, problem = pcall(function()
		case.run(state, context)
	end)
	case.release(state, context)
	expect(ok):toBe(false)
	return tostring(problem)
end

describe("game UI parity", function()
	it("rejects a diamond that computes its join twice for one source write", function()
		local message = rejected("derived-diamond", function(scope)
			local api = table.clone(scope)
			local computed = assert(scope.computed)
			api.computed = (
				function<T>(body: (Lane.Use) -> T): Lane.Source<T>
					return computed(function(use)
						body(use)
						return body(use)
					end)
				end :: unknown
			) :: Lane.Compute?
			return api
		end)
		expect(message):toContain "The diamond join must recompute once"
	end)

	it("rejects a filtered list with the right records in the wrong order", function()
		local message = rejected("filter-as-you-type", function(scope)
			local api = table.clone(scope)
			api.keyed = function(source: Lane.Source<{ Lane.Row }>): unknown
				local reversed = assert(scope.computed)(function(use)
					local rows = use(source)
					local result: { Lane.Row } = {}
					for index = #rows, 1, -1 do
						table.insert(result, rows[index])
					end
					return result
				end)
				return scope.keyed(reversed)
			end
			return api
		end)
		expect(message):toContain "The filtered list has the wrong order or values"
	end)

	it("rejects a sorted table with the right rows in the wrong order", function()
		local message = rejected("table-sort-filter", function(scope)
			local api = table.clone(scope)
			api.select = nil
			api.keyed = function(source: Lane.Source<{ Lane.Row }>): unknown
				local reversed = assert(scope.computed)(function(use)
					local rows = use(source)
					local result: { Lane.Row } = {}
					for index = #rows, 1, -1 do
						table.insert(result, rows[index])
					end
					return result
				end)
				return scope.keyed(reversed)
			end
			return api
		end)
		expect(message):toContain "The filtered list has the wrong order or values"
	end)

	it("rejects a tree that rebuilds retained rows", function()
		local message = rejected("tree-expand-collapse", function(scope)
			local api = table.clone(scope)
			api.keyed = function(source: Lane.Source<{ Lane.Row }>): unknown
				local copied = assert(scope.computed)(function(use)
					local result: { Lane.Row } = {}
					for index, row in use(source) do
						result[index] = { id = row.id }
					end
					return result
				end)
				return scope.keyed(copied)
			end
			return api
		end)
		expect(message):toContain "lost its Instance identity"
	end)

	it("rejects a form whose validation message stays stale", function()
		local message = rejected("form-validation", function(scope)
			local api = table.clone(scope)
			local computed = assert(scope.computed)
			local count = 0
			api.computed = (
				function<T>(body: (Lane.Use) -> T): Lane.Source<T>
					count += 1
					if count == 2 then
						local first: T? = nil
						return computed(function(use)
							local value = body(use)
							if first == nil then
								first = value
							end
							return first :: T
						end)
					end
					return computed(body)
				end :: unknown
			) :: Lane.Compute?
			return api
		end)
		expect(message):toContain "A form label is stale"
	end)

	it("rejects a HUD that drops a readout update", function()
		local count = 0
		local message = rejected("hud-per-frame", function(scope)
			local api = table.clone(scope)
			api.value = function<T>(initial: T): Lane.Source<T>
				count += 1
				local source = scope.value(initial)
				if count == 20 then
					source.write = function() end
				end
				return source
			end
			return api
		end)
		expect(message):toContain "A HUD readout is stale"
	end)

	it("rejects destroyed page nodes that remain reachable in Luau memory", function()
		local retained: { unknown } = {}
		local message = rejected("teardown-under-load", function(scope)
			local api = table.clone(scope)
			api.node = function(class, props, children)
				local node = scope.node(class, props, children)
				if class == "TextLabel" then
					table.insert(retained, node)
				end
				return node
			end
			return api
		end)
		expect(message):toContain "A closed page retained a released node in Luau memory"
		expect(#retained):toBe(2000)
		table.clear(retained)
	end)

	it("rejects a source that writes to a page after it closes", function()
		local nodes: { Environment.Instance } = {}
		local message = rejected("teardown-under-load", function(scope)
			local api = table.clone(scope)
			api.value = function<T>(initial: T): Lane.Source<T>
				local source = scope.value(initial)
				local write = source.write
				source.write = function(next: T)
					write(next)
					for _, node in nodes do
						if node.Parent == nil then
							node.LayoutOrder = 999
						end
					end
				end
				return source
			end
			api.node = function(class, props, children)
				local node = scope.node(class, props, children)
				if class == "TextLabel" then
					table.insert(nodes, node :: Environment.Instance)
				end
				return node
			end
			return api
		end)
		expect(message):toContain "A released page received a property write"
	end)
end)

return Test
