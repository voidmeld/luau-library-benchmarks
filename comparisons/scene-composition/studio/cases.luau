--!strict

local Engine = require "./engine"
local Environment = require "../cost-model"
local Lanes = require "../lanes"
local Loader = require "./loader"
local Memory = require "./memory"
local Profile = require "./profile"
local Settings = require "../../memory-settings"
local UNSUPPORTED = require "./unsupported"
local WorkloadTypes = require "../workloads/types"
local Workloads = require "../workloads"

export type Sample = number
export type Result = { samples: { Sample }, snapshot: string, mounted: { number }, teardown: { number } }
export type Case = {
	workload: string,
	lane: string,
	iterations: number,
	unsupported: string?,
	run: (samples: number) -> Result,
}

type Lane = {
	name: string,
	load: (Environment.Environment) -> { library: unknown, extras: WorkloadTypes.Extras },
}

local HARNESS = "ReplicatedStorage.VerifyModules.comparisons."
local MAX_WARMUP = 2
local TIMING_MINIMUM = Settings.studioTimingMinimum
local BUDGET = Settings.studioBudgetSeconds

local function lanes(): { Lane }
	local result: { Lane } = {
		{
			name = "plain",
			load = function(environment: Environment.Environment): { library: unknown, extras: WorkloadTypes.Extras }
				return { library = environment.globals, extras = {} }
			end,
		},
	}
	for _, entry in Lanes do
		table.insert(result, { name = entry.name, load = entry.load })
	end
	return result
end

local function measure(
	workload: WorkloadTypes.Workload,
	lane: Lane,
	case: WorkloadTypes.Case,
	count: number,
	loader: Loader.Loader,
	environment: Environment.Environment
): Result
	local cold = workload.id == "library-load"
	local loaded = if cold then { library = nil, extras = {} } else lane.load(environment)
	local prefixes = { HARNESS, loader.prefix }
	local samples: { Sample } = {}
	local snapshot = ""
	local warmup = math.clamp(workload.warmup, 1, MAX_WARMUP)
	local total = warmup + count
	local measuring: number? = nil
	for index = 1, total do
		local sampleLoader = if cold then Loader.create() else nil
		local sampleEnvironment = if sampleLoader then Engine.create(sampleLoader.load) else environment
		local samplePrefixes = if sampleLoader then { HARNESS, sampleLoader.prefix } else prefixes
		local container = sampleEnvironment.container()
		local context: WorkloadTypes.Context = {
			env = sampleEnvironment,
			library = loaded.library,
			extras = loaded.extras,
			container = container,
		}
		local state = case.prepare(context)
		sampleEnvironment.drain()
		local measured = index > warmup
		if measured then
			measuring = measuring or os.clock()
			Profile.start()
		end
		for _ = 1, workload.iterations do
			case.run(state, context)
		end
		sampleEnvironment.drain()
		if measured then
			table.insert(samples, Profile.stop(samplePrefixes))
		end
		local last = index == total
			or (measuring ~= nil and #samples >= TIMING_MINIMUM and os.clock() - measuring > BUDGET)
		if last then
			snapshot = case.snapshot(state, context)
		end
		case.release(state, context)
		sampleEnvironment.drain()
		container:Destroy()
		if sampleLoader then
			sampleLoader.release()
		end
		if last then
			break
		end
	end
	type Lifecycle =
		{ state: WorkloadTypes.State, context: WorkloadTypes.Context, environment: Environment.Environment }
	local retained = Memory.measure(function(): (Memory.Spec<Lifecycle>, () -> ())
		local sampleLoader = if cold then Loader.create() else nil
		local sampleEnvironment = Engine.create(if sampleLoader then sampleLoader.load else loader.load)
		local sampleLoaded = if cold then { library = nil, extras = {} } else lane.load(sampleEnvironment)
		sampleEnvironment.drain()
		local spec: Memory.Spec<Lifecycle> = {
			setup = function(): Lifecycle
				local context: WorkloadTypes.Context = {
					env = sampleEnvironment,
					library = sampleLoaded.library,
					extras = sampleLoaded.extras,
					container = sampleEnvironment.container(),
				}
				local state = case.prepare(context)
				sampleEnvironment.drain()
				return { state = state, context = context, environment = sampleEnvironment }
			end,
			run = function(lifecycle: Lifecycle)
				for _ = 1, workload.iterations do
					case.run(lifecycle.state, lifecycle.context)
				end
				lifecycle.environment.drain()
			end,
			teardown = function(lifecycle: Lifecycle)
				case.release(lifecycle.state, lifecycle.context)
				lifecycle.environment.drain()
				lifecycle.context.container:Destroy()
			end,
			iterations = 1,
		}
		return spec, function()
			if sampleLoader then
				sampleLoader.release()
			end
		end
	end)
	return { samples = samples, snapshot = snapshot, mounted = retained.mounted, teardown = retained.teardown }
end

local function run(workload: WorkloadTypes.Workload, lane: Lane, case: WorkloadTypes.Case, count: number): Result
	local loader = Loader.create()
	local environment = Engine.create(loader.load)
	local ok, result = pcall(measure, workload, lane, case, count, loader, environment)
	loader.release()
	Engine.frame()
	if not ok then
		error(result, 0)
	end
	return result
end

local function cases(): { Case }
	local result: { Case } = {}
	for _, workload in Workloads.all do
		for _, lane in lanes() do
			local case = workload.cases[lane.name]
			local reasons: { [string]: string } = workload.unsupported or {}
			local reason: string? = UNSUPPORTED[workload.id]
			if reason == nil and case == nil then
				reason = reasons[lane.name] or "no implementation"
			end
			table.insert(result, {
				workload = workload.id,
				lane = lane.name,
				iterations = workload.iterations,
				unsupported = reason,
				run = function(count: number): Result
					return run(workload, lane, assert(case), count)
				end,
			})
		end
	end
	return result
end

return { cases = cases, FREQUENCY = Profile.FREQUENCY }
