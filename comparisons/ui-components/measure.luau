--!strict

local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Lute = require "../../.lute/dependencies/verify/src/lute"
local Verify = require "../../.lute/dependencies/verify/src/core"
local Roblox = require "../../.lute/dependencies/verify/src/roblox"
local Headless = require "./headless"
local Types = require "./types"
local Report = require "./report"

export type Work = { properties: { [string]: number }, classes: { [string]: number } }
export type Evidence = {
	problem: string?,
	timing: Benchmark.CollectionResult,
	memory: { [string]: { Lute.MemoryResult } },
	rows: { Report.Row },
	work: { [string]: Work },
}
type Sample = { world: Headless.Headless, scene: Types.Scene }

local SAMPLES = 9
local LANES: { Types.Lane } = { "plain", "facet" }

local function settle(world: Headless.Headless)
	for _ = 1, Headless.SETTLE_FRAMES do
		world.frame()
	end
end

local function prepare(workload: Types.Workload, lane: Types.Lane): Sample
	local world = Headless.create()
	local scene = workload.prepare(world, lane)
	settle(world)
	return { world = world, scene = scene }
end

local function exercise(workload: Types.Workload, sample: Sample)
	for index = 1, workload.iterations do
		sample.scene.step(index)
	end
end

local function release(sample: Sample)
	sample.scene.stop()
	sample.world.dispose()
end

local function median(values: { number }): number
	return assert(Verify.performance.summarize({
		samples = values,
		unit = "KiB",
		context = { environment = "ui-components", signal = "retained-heap", timing = "observed" },
	}).p50)
end

local function yardstick(): Benchmark.Yardstick
	return {
		run = function()
			local total = 0
			for index = 1, 20000 do
				total += index % 7
			end
		end,
		samples = 32,
		iterations = 64,
		warmup = 16,
		maxSpread = 4,
		maxDrift = 0.25,
		driftBase = "mean",
	}
end

local function timingOf(workload: Types.Workload, position: number): Benchmark.CollectionResult
	local order: { Types.Lane } = if position % 2 == 1 then { "plain", "facet" } else { "facet", "plain" }
	local specs: { Benchmark.Spec } = {}
	for _, lane in order do
		assert(lane == "plain" or lane == "facet")
		local current: Sample? = nil
		local spec: Benchmark.Spec = {
			name = tostring(lane),
			unit = "microseconds",
			samples = SAMPLES,
			warmup = 2,
			warmupScope = "sample",
			iterations = 1,
			environment = { observed = "ui-components" },
			deadlineSeconds = 300,
			beforeSample = function()
				current = prepare(workload, lane)
			end,
			workload = function()
				exercise(workload, assert(current))
			end,
			afterSample = function()
				release(assert(current))
				current = nil
			end,
		}
		table.insert(specs, spec)
	end
	return Benchmark.collect {
		name = workload.id,
		benchmarks = specs,
		calibrationAttempts = 3,
		yardstick = yardstick(),
	}
end

local function workOf(workload: Types.Workload, lane: Types.Lane): (number, number, Work)
	local sample = prepare(workload, lane)
	local writes, created = 0, 0
	local work: Work = { properties = {}, classes = {} }
	local observer = sample.world.observe(function(event: Roblox.EnvironmentEvent)
		if event.operation == "setProperty" then
			writes += 1
			local key = event.object.ClassName .. "." .. assert(event.member)
			work.properties[key] = (work.properties[key] or 0) + 1
		elseif event.operation == "create" then
			created += 1
			local key = event.object.ClassName
			work.classes[key] = (work.classes[key] or 0) + 1
		end
	end)
	exercise(workload, sample)
	observer:Disconnect()
	release(sample)
	return writes, created, work
end

return function(workload: Types.Workload, position: number): Evidence
	local timing = timingOf(workload, position)
	local memory: { [string]: { Lute.MemoryResult } } = {}
	local rows: { Report.Row } = {}
	local work: { [string]: Work } = {}
	if timing.failure ~= nil or #timing.invalid > 0 then
		return {
			timing = timing,
			memory = memory,
			rows = rows,
			work = work,
			problem = timing.failure or Lute.encode(timing.invalid),
		}
	end
	for _, lane in LANES do
		assert(lane == "plain" or lane == "facet")
		local result: Benchmark.Result? = nil
		for _, candidate in timing.results do
			if candidate.name == lane then
				result = candidate
			end
		end
		if result == nil or result.failure ~= nil or #result.invalid > 0 or #result.samples ~= SAMPLES then
			return { timing = timing, memory = memory, rows = rows, work = work, problem = Lute.encode(result) }
		end
		local mounted, teardown = {}, {}
		local retained: { Lute.MemoryResult } = {}
		memory[lane] = retained
		for _ = 1, 3 do
			local world = Headless.create()
			local measured = Lute.memory.measure({
				setup = function(): Sample
					local scene = workload.prepare(world, lane)
					settle(world)
					return { world = world, scene = scene }
				end,
				run = function(sample: Sample)
					exercise(workload, sample)
				end,
				teardown = function(sample: Sample)
					sample.scene.stop()
				end,
				iterations = 1,
			}, { cycles = 8, maxAllocations = 2500000, deadlineSeconds = 30 })
			world.dispose()
			table.insert(retained, measured)
			table.insert(mounted, measured.mountedRetainedKb)
			table.insert(teardown, measured.teardownRetainedKb)
		end
		local writes, created, counted = workOf(workload, lane)
		work[lane] = counted
		table.insert(rows, {
			workload = workload.id,
			iterations = workload.iterations,
			lane = tostring(lane),
			microseconds = assert(result.summary.p50),
			mountedKb = median(mounted),
			teardownKb = median(teardown),
			writes = writes,
			created = created,
		})
	end
	return { timing = timing, memory = memory, rows = rows, work = work }
end
