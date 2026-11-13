--!strict

local Loader = require "../../scene-composition/studio/loader"
local Profile = require "../../scene-composition/studio/profile"
local Memory = require "../../scene-composition/studio/memory"
local Settings = require "../../memory-settings"
local Types = require "../types"
local UNSUPPORTED = require "./unsupported"
local World = require "./world"
local Workloads = require "../workloads"
local Checkpoints = require "../checkpoints"

export type Result = {
	samples: { number },
	repeats: number,
	snapshot: string,
	profile: string,
	mounted: { number },
	teardown: { number },
}
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
local WINDOW_MINIMUM = 5000
local MAX_REPEATS = 8

local function measure(
	workload: Types.Workload,
	lane: Types.Lane,
	count: number,
	loader: Loader.Loader,
	reference: { string }
): Result
	local load: (string) -> Types.Facet = loader.load
	local Facet = if lane == "facet" then load(FACET) else nil
	local prefixes = { HARNESS, loader.prefix }
	local samples: { number } = {}
	local profile = ""
	local function lifecycle(): number
		local world = World.create(Facet)
		local scene = workload.prepare(world, lane)
		for _ = 1, SETTLE_FRAMES do
			World.frame()
		end
		Profile.start()
		local began = os.clock()
		for iteration = 1, workload.iterations do
			scene.step(iteration)
		end
		local ran = (os.clock() - began) * 1000000
		World.frame()
		local elapsed = Profile.stop(prefixes)
		if profile == "" then
			profile = ("run %.0f us\n%s"):format(ran, Profile.breakdown(prefixes))
		end
		if elapsed < Profile.RESOLUTION then
			elapsed = math.min(math.max(elapsed, ran), Profile.RESOLUTION)
		end
		assert(scene.snapshot() == reference[#reference], "sample did not reach the verified final state")
		scene.stop()
		World.frame()
		world.dispose()
		return elapsed
	end
	local started = os.clock()
	local estimate = lifecycle()
	local wall = os.clock() - started
	local repeats = math.clamp(
		math.ceil(WINDOW_MINIMUM / math.max(estimate, Profile.RESOLUTION / 2)),
		1,
		math.clamp(math.floor(Settings.studioSampleWallSeconds / math.max(wall, 0.001)), 1, MAX_REPEATS)
	)
	local measuring = os.clock()
	for _ = 1, count do
		local sum = 0
		for _ = 1, repeats do
			sum += lifecycle()
		end
		table.insert(samples, sum / repeats)
		if #samples >= Settings.studioTimingMinimum and os.clock() - measuring > Settings.studioBudgetSeconds then
			break
		end
	end
	type Scene = typeof(workload.prepare(World.create(Facet), lane))
	local retained = Memory.measure(function(): (Memory.Spec<Scene>, () -> ())
		local world = World.create(Facet)
		local spec: Memory.Spec<Scene> = {
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
		return spec, function()
			world.dispose()
		end
	end)
	return {
		samples = samples,
		repeats = repeats,
		snapshot = table.concat(reference, "\n---\n"),
		profile = profile,
		mounted = retained.mounted,
		teardown = retained.teardown,
	}
end

type Verified = { [Types.Lane]: { string } }
local verified: { [string]: Verified } = {}

local function verify(workload: Types.Workload): Verified
	local known = verified[workload.id]
	if known ~= nil then
		return known
	end
	local collected: Verified = {}
	for _, lane in LANES do
		assert(lane == "plain" or lane == "facet")
		local loader = Loader.create()
		local load: (string) -> Types.Facet = loader.load
		local ok, snapshots = pcall(function()
			return Checkpoints.collect(workload, World.create(if lane == "facet" then load(FACET) else nil), lane)
		end)
		loader.release()
		World.frame()
		if not ok then
			error(snapshots, 0)
		end
		collected[lane] = snapshots
	end
	Checkpoints.match(workload.id, assert(collected.plain), assert(collected.facet))
	verified[workload.id] = collected
	return collected
end

local function run(workload: Types.Workload, lane: Types.Lane, count: number): Result
	local reference = assert(verify(workload)[lane])
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
