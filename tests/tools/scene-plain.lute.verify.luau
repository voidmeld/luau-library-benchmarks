--!strict

local Test = require "../harness"
local Environment = require "../../comparisons/scene-composition/cost-model"
local Lists = require "../../comparisons/scene-composition/workloads/large-lists"
local Plain = require "../../comparisons/scene-composition/lanes/plain-rows"
local Shared = require "../../comparisons/scene-composition/workloads/shared"
local Types = require "../../comparisons/scene-composition/workloads/types"
local Workloads = require "../../comparisons/scene-composition/workloads"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function context(): Types.Context
	local environment = Environment.create()
	return {
		env = environment,
		library = environment.globals,
		extras = {},
		container = environment.container(),
		observe = function(_snapshot: string) end,
	}
end

local function plainCase(id: string): Types.Case
	for _, workload in Workloads.all do
		if workload.id == id then
			return assert(workload.cases.plain)
		end
	end
	error("missing workload " .. id, 0)
end

local function animated(host: Types.Context, offset: (number) -> number)
	local Instance = host.env.globals.Instance
	local frame = Instance.new "Frame"
	for index = 1, Shared.ANIMATED do
		local node = Instance.new "Frame"
		node.LayoutOrder = offset(index)
		node.Parent = frame
	end
	frame.Parent = host.container
end

describe("Plain scene workloads", function()
	it("gives every keyed lane the same added rows and a full permutation", function()
		local initial, prepended = Shared.keyedLists "keyed-prepend"
		expect(#initial):toBe(Shared.KEYED_ROWS)
		expect(#prepended):toBe(Shared.KEYED_ROWS + 10)
		expect(prepended[1].id):toBe(401)
		expect(prepended[10].id):toBe(410)
		expect(prepended[11]):toBe(initial[1])
		local base, inserted = Shared.keyedLists "keyed-insert"
		expect(inserted[150]):toBe(base[150])
		expect(inserted[151].id):toBe(501)
		expect(inserted[160].id):toBe(510)
		expect(inserted[161]):toBe(base[151])
		local start, shuffled = Shared.keyedLists "keyed-shuffle"
		expect(#shuffled):toBe(#start)
		local seen: { [number]: boolean } = {}
		for _, row in shuffled do
			expect(seen[row.id]):toBeNil()
			seen[row.id] = true
		end
		expect(shuffled[1] == start[1] and shuffled[2] == start[2]):toBe(false)
	end)

	it("hands status-panel lanes one prepared list per badge count", function()
		local lists = Shared.badgeLists()
		expect(#lists):toBe(Shared.BADGES + 1)
		expect(#lists[1]):toBe(0)
		expect(#Shared.badgesAt(lists, 1)):toBe(2)
		expect(#Shared.badgesAt(lists, Shared.BADGES - 1)):toBe(Shared.BADGES)
		expect(Shared.badgesAt(lists, Shared.BADGES)):toBe(lists[2])
		expect(Shared.badgesAt(lists, 3)[1]):toBe(lists[2][1])
	end)

	it("reconciles a received list by id and writes only moved rows", function()
		local host = context()
		local Instance = host.env.globals.Instance
		local baseline = host.env.liveInstances()
		local frame = Instance.new "Frame"
		frame.Parent = host.container
		local labels = Shared.labels(frame)
		local first, second, third = { id = 1 }, { id = 2 }, { id = 3 }
		Shared.applyLabels(labels, Instance, { first, second, third })
		local kept = labels.byId[3]
		host.env.resetCounters()
		Shared.applyLabels(labels, Instance, { third, first })
		local counters = host.env.counters()
		expect(counters.instancesCreated):toBe(0)
		expect(counters.instancesDestroyed):toBe(1)
		expect(counters.propertyWrites):toBe(2)
		expect(labels.byId[3]):toBe(kept)
		expect(labels.byId[2]):toBeNil()
		Shared.releaseLabels(labels)
		expect(host.env.liveInstances()):toBe(baseline)
	end)

	it("rejects an animated node that has not moved or has reached its target", function()
		local midway = context()
		animated(midway, function(index: number): number
			return index + 50
		end)
		Shared.checkMidway(midway.env, midway.container)
		for _, offset in { 0, Shared.ANIMATE_TARGET } do
			local host = context()
			animated(host, function(index: number): number
				return index + offset
			end)
			local ok, problem = pcall(Shared.checkMidway, host.env, host.container)
			expect(ok):toBe(false)
			expect(tostring(problem)):toContain "not between"
		end
	end)

	it("animates on the heartbeat and disconnects at rest and on release", function()
		local case = plainCase "animate-many"
		local host = context()
		local connections = host.env.liveConnections()
		local state = case.prepare(host)
		expect(host.env.liveConnections()):toBe(connections)
		host.env.resetCounters()
		case.run(state, host)
		expect(host.env.counters().connectionsMade):toBe(1)
		expect(host.env.liveConnections()):toBe(connections + 1)
		case.snapshot(state, host)
		expect(host.env.liveConnections()):toBe(connections)
		case.release(state, host)

		local moving = context()
		local instances, linked = moving.env.liveInstances(), moving.env.liveConnections()
		local live = case.prepare(moving)
		case.run(live, moving)
		expect(moving.env.liveConnections()):toBe(linked + 1)
		case.release(live, moving)
		expect(moving.env.liveConnections()):toBe(linked)
		expect(moving.env.liveInstances()):toBe(instances)
	end)

	it("destroys and disconnects each removed plain row", function()
		local removals: { [string]: number } = { ["rows-remove-one"] = 1, ["rows-clear"] = 1000 }
		for id, removed in removals do
			local host = context()
			local linked = host.env.liveConnections()
			local case = Lists.caseFor(id, Plain.create)
			local state = case.prepare(host)
			host.env.resetCounters()
			case.run(state, host)
			local counters = host.env.counters()
			expect(counters.instancesDestroyed):toBe(removed * 5)
			expect(counters.connectionsBroken):toBe(removed * 2)
			case.release(state, host)
			expect(host.env.liveConnections()):toBe(linked)
		end
	end)

	it("loads plain with one Frame and no driver", function()
		local case = plainCase "library-load"
		local host = context()
		local state = case.prepare(host)
		host.env.resetCounters()
		case.run(state, host)
		expect(host.env.counters().instancesCreated):toBe(1)
		expect(#host.env.children(host.container)):toBe(1)
		case.release(state, host)
		expect(#host.env.children(host.container)):toBe(0)
	end)
end)

return nil
