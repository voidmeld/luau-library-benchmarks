--!strict

local Engine = require "./engine"
local Environment = require "../cost-model"
local Lanes = require "../lanes"
local Loader = require "./loader"
local Profile = require "./profile"
local UNSUPPORTED = require "./unsupported"
local WorkloadTypes = require "../workloads/types"
local Workloads = require "../workloads"

export type Sample = number
export type Result = { samples: { Sample }, snapshot: string }
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
	environment: Environment.Environment,
	container: Environment.Instance
): Result
	local loaded = lane.load(environment)
	local context: WorkloadTypes.Context = {
		env = environment,
		library = loaded.library,
		extras = loaded.extras,
		container = container,
	}
	local prefixes = { HARNESS, loader.prefix }
	local state = case.prepare(context)
	environment.drain()
	for _ = 1, math.max(1, workload.warmup) do
		for _ = 1, workload.iterations do
			case.run(state, context)
		end
		environment.drain()
	end
	local samples: { Sample } = {}
	for _ = 1, count do
		Engine.frame()
		Profile.start()
		for _ = 1, workload.iterations do
			case.run(state, context)
		end
		environment.drain()
		table.insert(samples, Profile.stop(prefixes))
	end
	local snapshot = case.snapshot(state, context)
	case.release(state, context)
	environment.drain()
	return { samples = samples, snapshot = snapshot }
end

local function run(workload: WorkloadTypes.Workload, lane: Lane, case: WorkloadTypes.Case, count: number): Result
	local loader = Loader.create()
	local environment = Engine.create(loader.load)
	local container = environment.container()
	local ok, result = pcall(measure, workload, lane, case, count, loader, environment, container)
	container:Destroy()
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
