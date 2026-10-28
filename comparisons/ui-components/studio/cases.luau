--!strict

local Loader = require "../../scene-composition/studio/loader"
local Profile = require "../../scene-composition/studio/profile"
local Types = require "../types"
local UNSUPPORTED = require "./unsupported"
local World = require "./world"
local Workloads = require "../workloads"

export type Result = { samples: { number }, snapshot: string }
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

local function measure(workload: Types.Workload, lane: Types.Lane, count: number, loader: Loader.Loader): Result
	local load: (string) -> Types.Facet = loader.load
	local Facet = load(FACET)
	local prefixes = { HARNESS, loader.prefix }
	local samples: { number } = {}
	local snapshot = ""
	local total = 1 + count
	for index = 1, total do
		local world = World.create(Facet)
		local scene = workload.prepare(world, lane)
		World.frame()
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
		if index == total then
			snapshot = scene.snapshot()
		end
		scene.stop()
		World.frame()
		world.dispose()
	end
	return { samples = samples, snapshot = snapshot }
end

local function run(workload: Types.Workload, lane: Types.Lane, count: number): Result
	local loader = Loader.create()
	local ok, result = pcall(measure, workload, lane, count, loader)
	loader.release()
	World.frame()
	if not ok then
		error(result, 0)
	end
	return result
end

local function cases(): { Case }
	local result: { Case } = {}
	for _, workload in Workloads.all do
		for _, lane in LANES do
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
