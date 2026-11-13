--!strict

local Test = require "../harness"
local Environment = require "../../comparisons/scene-composition/cost-model"
local GameUI = require "../../comparisons/scene-composition/workloads/game-ui"
local Reactive = require "./reactive-driver"
local Lane = require "../../comparisons/scene-composition/lanes/types"
local Workloads = require "../../comparisons/scene-composition/workloads"
local Lute = require "../../.lute/dependencies/verify/src/lute"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function hostFor(environment: Environment.Environment, checking: boolean): Workloads.Context
	return {
		env = environment,
		library = nil,
		extras = {},
		container = environment.container(),
		observe = if checking then function() end else nil,
		collect = if checking
			then function()
				Lute.memory.settle { cycles = 2 }
			end
			else nil,
	}
end

local function rejected(id: string, decorate: (Lane.Scope, Environment.Environment) -> Lane.Scope): string
	local environment = Environment.create()
	local driver = Reactive.create(environment)
	local mount = driver.mount
	driver.mount = function(container, build)
		return mount(container, function(scope)
			return build(decorate(scope, environment))
		end)
	end
	local case = GameUI.caseFor(id, function()
		return driver
	end)
	local context = hostFor(environment, true)
	local state = case.prepare(context)
	local ok, problem = pcall(function()
		case.run(state, context)
	end)
	case.release(state, context)
	expect(ok):toBe(false)
	return tostring(problem)
end

describe("game UI parity", function()
	it("checks each plain workload like a library lane and matches its trees and creations", function()
		expect(#GameUI.all):toBe(11)
		for _, workload in GameUI.all do
			local traces: { string } = {}
			local created: { number } = {}
			for _, case in { workload.cases.plain, GameUI.caseFor(workload.id, Reactive.create) } do
				local environment = Environment.create()
				local context = hostFor(environment, true)
				local observed: { string } = {}
				context.observe = function(snapshot: string)
					table.insert(observed, snapshot)
				end
				local instances, connections = environment.liveInstances(), environment.liveConnections()
				local state = case.prepare(context)
				table.insert(observed, case.snapshot(state, context))
				environment.resetCounters()
				for _ = 1, workload.iterations do
					case.run(state, context)
				end
				table.insert(created, environment.counters().instancesCreated)
				table.insert(observed, case.snapshot(state, context))
				table.insert(traces, table.concat(observed, "\n"))
				case.release(state, context)
				environment.drain()
				expect(environment.liveInstances()):toBe(instances)
				expect(environment.liveConnections()):toBe(connections)
			end
			expect(traces[1] == traces[2]):toBe(true)
			expect(created[1]):toBe(created[2])
		end
	end)

	it("reads no counters and walks no labels in a run without checks", function()
		for _, workload in GameUI.all do
			local cases = { workload.cases.plain, GameUI.caseFor(workload.id, Reactive.create) }
			for _, case in cases do
				local environment = Environment.create()
				local counters, children = environment.counters, environment.children
				local reads = 0
				environment.counters = function(): Environment.Counters
					reads += 1
					return counters()
				end
				environment.children = function(node: Environment.Instance): { Environment.Instance }
					reads += 1
					return children(node)
				end
				local context = hostFor(environment, false)
				local state = case.prepare(context)
				reads = 0
				for _ = 1, workload.iterations do
					case.run(state, context)
				end
				expect(reads):toBe(0)
				case.release(state, context)
			end
		end
	end)

	it("rejects a diamond that computes its join twice for one source write", function()
		local message = rejected("derived-diamond", function(scope)
			local api = table.clone(scope)
			local computed = assert(scope.computed)
			local twice: Lane.Compute = function<T>(body: (Lane.Use) -> T): Lane.Source<T>
				return computed(function(use)
					body(use)
					return body(use)
				end)
			end
			api.computed = twice
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

	it("rejects a tree that forgets open branches when a root closes", function()
		local message = rejected("tree-expand-collapse", function(scope)
			local api = table.clone(scope)
			api.keyed = function(source: Lane.Source<{ Lane.Row }>): unknown
				local open: { [number]: boolean } = {}
				local closed: { [number]: boolean } = {}
				local forgetful = assert(scope.computed)(function(use)
					local rows = use(source)
					local visible: { [number]: boolean } = {}
					for _, row in rows do
						visible[row.id] = true
					end
					for root = 1, 10 do
						if visible[100 + (root - 1) * 10 + 1] then
							open[root] = true
						elseif open[root] then
							closed[root] = true
						end
					end
					local result: { Lane.Row } = {}
					for _, row in rows do
						local child = if row.id > 1000 then (row.id - 1001) // 20 + 101 else nil
						if child == nil or not closed[(child - 101) // 10 + 1] then
							table.insert(result, row)
						end
					end
					return result
				end)
				return scope.keyed(forgetful)
			end
			return api
		end)
		expect(message):toContain "The filtered list has the wrong length"
	end)

	it("rejects a form whose validation message stays stale", function()
		local message = rejected("form-validation", function(scope)
			local api = table.clone(scope)
			local computed = assert(scope.computed)
			local count = 0
			local stale: Lane.Compute = function<T>(body: (Lane.Use) -> T): Lane.Source<T>
				count += 1
				if count == 2 then
					local first: T? = nil
					return computed(function(use)
						local value = body(use)
						local kept = first
						if kept == nil then
							first = value
							return value
						end
						return kept
					end)
				end
				return computed(body)
			end
			api.computed = stale
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
		local message = rejected("teardown-under-load", function(scope, environment)
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
					table.insert(nodes, environment.instance(node))
				end
				return node
			end
			return api
		end)
		expect(message):toContain "A released page received a property write"
	end)
end)

return Test
