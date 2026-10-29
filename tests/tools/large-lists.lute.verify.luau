--!strict

local Test = require "../harness"
local Environment = require "../../comparisons/scene-composition/cost-model"
local Frameworks = require "../../comparisons/scene-composition/harness/frameworks"
local Upstream = require "../../comparisons/scene-composition/harness/upstream"
local Lists = require "../../comparisons/scene-composition/workloads/large-lists"
local Types = require "../../comparisons/scene-composition/workloads/types"
local Plain = require "../../comparisons/scene-composition/lanes/plain-rows"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function context(): Types.Context
	local opened = Frameworks.open({
		name = "large-lists-fixture",
		version = "fixture",
		what = "fresh test host",
		load = function(): Frameworks.Loaded
			return { library = nil, extras = {} }
		end,
	}, true)
	return {
		env = opened.environment,
		container = opened.environment.container(),
		library = nil,
		extras = {},
		observe = function(_snapshot: string) end,
	}
end

describe("Large game list workloads", function()
	it("checks each plain workload against its tree, work counts and teardown", function()
		expect(#Lists.all):toBe(10)
		for _, workload in Lists.all do
			local host = context()
			local instances, connections = host.env.liveInstances(), host.env.liveConnections()
			local case = workload.cases.plain
			local state = case.prepare(host)
			host.env.resetCounters()
			case.run(state, host)
			host.env.drain()
			if state.checkWork then
				state.checkWork(host.env.counters())
			end
			expect(#case.snapshot(state, host) > 0):toBe(true)
			case.release(state, host)
			expect(host.env.liveInstances()):toBe(instances)
			expect(host.env.liveConnections()):toBe(connections)
		end
	end)

	it("rejects a redundant write to an unchanged label", function()
		local host = context()
		local case = Lists.caseFor("rows-update-every-10th", Plain.create)
		local state = case.prepare(host)
		case.run(state, host)
		local root = host.env.children(host.container)[1]
		local frame = host.env.children(root)[2]
		local children = host.env.children(frame)
		local label = children[1]
		for _, child in children do
			if host.env.get(child, "LayoutOrder") == 2 then
				label = child
			end
		end
		local ok, problem = pcall(function()
			label.Text = host.env.get(label, "Text")
			case.snapshot(state, host)
		end)
		case.release(state, host)
		expect(ok):toBe(false)
		expect(tostring(problem)):toContain "wrote an unchanged row property"
	end)

	it("rejects a second write to a changed label", function()
		local host = context()
		local case = Lists.caseFor("rows-update-every-10th", Plain.create)
		local state = case.prepare(host)
		case.run(state, host)
		local frame = host.env.children(host.env.children(host.container)[1])[1]
		for _, child in host.env.children(frame) do
			if host.env.get(child, "LayoutOrder") == 2 then
				child.Text = host.env.get(child, "Text")
			end
		end
		local ok, problem = pcall(function()
			case.snapshot(state, host)
		end)
		case.release(state, host)
		expect(ok):toBe(false)
		expect(tostring(problem)):toContain "changed property must be written exactly once"
	end)

	it("defers module execution and uses a separate module cache for each cold sample", function()
		local previous: Upstream.Mode = Upstream.mode()
		Upstream.setMode "like-for-like"
		local libraries: { unknown } = {}
		for _ = 1, 2 do
			local host = context()
			local case = Lists.caseFor("library-load", function(environment: Environment.Environment)
				local load: (string) -> unknown = environment.load
				table.insert(libraries, load ".lute/dependencies/signals/src")
				return Plain.create(environment)
			end)
			local count = #libraries
			local state = case.prepare(host)
			expect(#libraries):toBe(count)
			case.run(state, host)
			expect(#libraries):toBe(count + 1)
			case.release(state, host)
		end
		Upstream.setMode(previous)
		expect(libraries[1] == libraries[2]):toBe(false)
	end)
end)

return nil
