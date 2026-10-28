--!strict

local system = require "@lute/system"

local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Lute = require "../../.lute/dependencies/verify/src/lute"
local Environment = require "./cost-model"
local Frameworks = require "./harness/frameworks"
local Workloads = require "./workloads"
local WorkloadTypes = require "./workloads/types"

export type Entry = {
	id: string,
	collection: Benchmark.Collection,
}

export type Filter = {
	filter: string?,
	offset: number?,
}

type Sample = {
	environment: Environment.Environment,
	context: Workloads.Context,
	state: WorkloadTypes.State,
	baselineInstances: number,
	baselineConnections: number,
}

local clock = os.clock

local function identity(): string
	local cpus = system.cpus()
	return ("%s-%s-%s-%dthreads"):format(
		system.os,
		system.arch,
		if #cpus > 0 then cpus[1].model else "unknown",
		system.threadCount()
	)
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

local function rotated<T>(values: { T }, by: number): { T }
	local count = #values
	local out = table.create(count)
	for index = 1, count do
		out[index] = values[((index - 1 + by) % count) + 1]
	end
	return out
end

local function makeContext(framework: Frameworks.Framework): (Environment.Environment, Workloads.Context)
	local opened = Frameworks.open(framework)
	local environment = opened.environment
	local loaded = opened.loaded
	return environment,
		{
			env = environment,
			library = loaded.library,
			extras = loaded.extras,
			container = environment.container(),
		}
end

local function environmentCounts(counters: Environment.Counters): { [string]: number }
	return {
		instancesCreated = counters.instancesCreated,
		instancesDestroyed = counters.instancesDestroyed,
		propertyWrites = counters.propertyWrites,
		propertyReads = counters.propertyReads,
		parentChanges = counters.parentChanges,
		connectionsMade = counters.connectionsMade,
		connectionsBroken = counters.connectionsBroken,
		eventsFired = counters.eventsFired,
		tasksDeferred = counters.tasksDeferred,
	}
end

local function recordEnvironment(sampler: Benchmark.Sampler, sample: Sample, counters: Environment.Counters)
	for name, value in environmentCounts(counters) do
		sampler.series("counter." .. name, { value })
	end
	sampler.series("leakedInstances", { sample.environment.liveInstances() - sample.baselineInstances })
	sampler.series("leakedConnections", { sample.environment.liveConnections() - sample.baselineConnections })
	sampler.series("diagnostics", { #sample.environment.diagnostics() })
end

local function workloadMember(
	workload: Workloads.Workload,
	framework: Frameworks.Framework,
	observed: string
): Benchmark.Spec
	local case = workload.cases[framework.name]
	local samples: { [unknown]: Sample } = {}
	setmetatable(samples, { __mode = "kv" })
	return {
		name = ("%s/%s"):format(workload.id, framework.name),
		unit = "microseconds",
		clock = clock,
		warmup = workload.warmup,
		warmupScope = "sample",
		samples = workload.samples,
		percentiles = { 75, 90 },
		environment = { observed = observed },
		beforeSample = function(): Sample
			local environment, context = makeContext(framework)
			local baselineInstances = environment.liveInstances()
			local baselineConnections = environment.liveConnections()
			local sample: Sample = {
				environment = environment,
				context = context,
				state = case.prepare(context),
				baselineInstances = baselineInstances,
				baselineConnections = baselineConnections,
			}
			environment.drain()
			environment.resetCounters()
			samples[sample] = sample
			Lute.memory.settle { cycles = 2 }
			return sample
		end,
		workload = function(state: unknown)
			local sample = samples[state]
			for _ = 1, workload.iterations do
				case.run(sample.state, sample.context)
			end
		end,
		finalize = function(state: unknown)
			samples[state].environment.drain()
		end,
		teardown = function()
			Frameworks.close(framework)
		end,
		afterSample = function(state: unknown, sampler: Benchmark.Sampler)
			local sample = samples[state]
			local counters = sample.environment.counters()
			case.release(sample.state, sample.context)
			sample.environment.drain()
			recordEnvironment(sampler, sample, counters)
		end,
	}
end

local function workloadEntry(workload: Workloads.Workload, position: number, observed: string): Entry
	local order = rotated(Frameworks.available(), position - 1)
	local members: { Benchmark.Spec } = {}
	for _, framework in order do
		if workload.cases[framework.name] ~= nil then
			table.insert(members, workloadMember(workload, framework, observed))
		end
	end
	return {
		id = workload.id,
		collection = { name = workload.id, yardstick = yardstick(), benchmarks = members, clock = clock },
	}
end

local function prime(collection: Benchmark.Collection)
	for _, member in collection.benchmarks do
		local once = table.clone(member)
		once.warmup = 0
		once.samples = 1
		once.baseline = nil
		once.yardstick = nil
		local result = Benchmark.run(once)
		assert(result.failure == nil, result.failure)
	end
end

local function entries(settings: Filter): { Entry }
	local observed = identity()
	local found: { Entry } = {}
	local position = settings.offset or 0
	for _, workload in Workloads.all do
		if settings.filter == nil or string.find(workload.id, settings.filter, 1, true) ~= nil then
			position += 1
			table.insert(found, workloadEntry(workload, position, observed))
		end
	end
	return found
end

return {
	entries = entries,
	identity = identity,
	prime = prime,
}
