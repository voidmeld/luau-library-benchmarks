--!strict

local Loader = require "../../scene-composition/studio/loader"
local Profile = require "../../scene-composition/studio/profile"
local Memory = require "../../scene-composition/studio/memory"
local Types = require "../types"
local UNSUPPORTED = require "./unsupported"
local World = require "./world"
local Workloads = require "../workloads"
local Checkpoints = require "../checkpoints"

export type Result = { samples: { number }, snapshot: string, mounted: { number }, teardown: { number } }
export type Case = {
	workload: string,
	lane: Types.Lane,
	iterations: number,
	unsupported: string?,
	run: (samples: number) -> Result,
}

local HARNESS = "ReplicatedStorage.VerifyModules.comparisons."
local FACET = ".lute/dependencies/facet/src"
local LANES: { Types.Lane } = { "plain", "facet" }
local SETTLE_FRAMES = 30

local function measure(
	workload: Types.Workload,
	lane: Types.Lane,
	count: number,
	loader: Loader.Loader,
	reference: { string }
): Result
	local load: (string) -> Types.Facet = loader.load
	local Facet = load(FACET)
	local prefixes = { HARNESS, loader.prefix }
	local samples: { number } = {}
	local total = 1 + count
	for index = 1, total do
		local world = World.create(Facet)
		local scene = workload.prepare(world, lane)
		for _ = 1, SETTLE_FRAMES do
			World.frame()
		end
		local measured = index > total - count
		if measured then
			Profile.start()
		end
		for iteration = 1, workload.iterations do
			scene.step(iteration)
		end
		World.frame()
		if measured then
			table.insert(samples, Profile.stop(prefixes))
		end
		assert(scene.snapshot() == reference[#reference], "sample did not reach the verified final state")
		scene.stop()
		World.frame()
		world.dispose()
	end
	local world = World.create(Facet)
	type Scene = typeof(workload.prepare(world, lane))
	local retained = Memory.measure {
		setup = function(): Scene
			local scene = workload.prepare(world, lane)
			for _ = 1, SETTLE_FRAMES do
				World.frame()
			end
			return scene
		end,
		run = function(scene: Scene)
			for iteration = 1, workload.iterations do
				scene.step(iteration)
			end
			World.frame()
		end,
		teardown = function(scene: Scene)
			scene.stop()
			World.frame()
		end,
		iterations = 1,
	}
	world.dispose()
	return {
		samples = samples,
		snapshot = table.concat(reference, "\n---\n"),
		mounted = retained.mounted,
		teardown = retained.teardown,
	}
end

local function verify(workload: Types.Workload): { string }
	local reference: { string } = {}
	for _, lane in LANES do
		assert(lane == "plain" or lane == "facet")
		local loader = Loader.create()
		local load: (string) -> Types.Facet = loader.load
		local ok, snapshots = pcall(function()
			return Checkpoints.collect(workload, World.create(load(FACET)), lane)
		end)
		loader.release()
		World.frame()
		if not ok then
			error(snapshots, 0)
		end
		if lane == "plain" then
			reference = snapshots
		else
			Checkpoints.match(workload.id, reference, snapshots)
		end
	end
	return reference
end

local function run(workload: Types.Workload, lane: Types.Lane, count: number): Result
	local reference = verify(workload)
	local loader = Loader.create()
	local ok, result = pcall(measure, workload, lane, count, loader, reference)
	loader.release()
	World.frame()
	if not ok then
		error(result, 0)
	end
	return result
end

local function cases(): { Case }
	local result: { Case } = {}
	for position, workload in Workloads.all do
		local order: { Types.Lane } = if position % 2 == 1 then { "plain", "facet" } else { "facet", "plain" }
		for _, lane in order do
			assert(lane == "plain" or lane == "facet")
			table.insert(result, {
				workload = workload.id,
				lane = lane,
				iterations = workload.iterations,
				unsupported = UNSUPPORTED[workload.id],
				run = function(count: number): Result
					return run(workload, lane, count)
				end,
			})
		end
	end
	return result
end

return { cases = cases }
