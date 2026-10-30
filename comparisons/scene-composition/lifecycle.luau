--!strict

local Lute = require "../../.lute/dependencies/verify/src/lute"
local Environment = require "./cost-model"
local Frameworks = require "./harness/frameworks"
local Parity = require "./parity"
local Workloads = require "./workloads"
local WorkloadTypes = require "./workloads/types"

local function contextFor(framework: Frameworks.Framework, cold: boolean?): Workloads.Context
	local opened = Frameworks.open(framework, cold)
	local environment = opened.environment
	return {
		env = environment,
		library = opened.loaded.library,
		extras = opened.loaded.extras,
		container = environment.container(),
	}
end

local function unchangedRows(context: Workloads.Context): { [string]: Environment.Instance }
	local rows: { [string]: Environment.Instance } = {}
	for _, frame in context.env.children(context.container) do
		for _, node in context.env.children(frame) do
			local text = context.env.get(node, "Text")
			if type(text) == "string" then
				rows[text] = node
			end
		end
	end
	return rows
end

local function parity(workload: Workloads.Workload, frameworks: { Frameworks.Framework }): string?
	local problem = Parity.workload(workload, frameworks)
	if problem then
		return problem
	end
	local reference: { string }? = nil
	local referenceName = ""
	local referenceCreated: number? = nil
	local referenceConnections: number? = nil
	for _, framework in frameworks do
		local case = workload.cases[framework.name]
		if not case then
			continue
		end
		local context = contextFor(framework, workload.id == "library-load")
		local observed: { string } = {}
		context.observe = function(snapshot: string)
			table.insert(observed, snapshot)
		end
		context.collect = function()
			Lute.memory.settle { cycles = 2 }
		end
		local instances, connections = context.env.liveInstances(), context.env.liveConnections()
		local state = case.prepare(context)
		context.env.drain()
		local snapshots = { case.snapshot(state, context) }
		local previous = unchangedRows(context)
		local created, connected = 0, 0
		local detail: unknown = nil
		local ok = xpcall(function()
			for _ = 1, workload.iterations do
				context.env.resetCounters()
				table.clear(observed)
				case.run(state, context)
				context.env.drain()
				local counters = context.env.counters()
				local checkWork = state.checkWork
				if checkWork then
					checkWork(counters)
				end
				created += counters.instancesCreated
				connected += counters.connectionsMade
				if #observed > 0 then
					table.insert(snapshots, table.concat(observed, "\n"))
				end
				if
					workload.id == "update-leaf"
					or (workload.id == "update-repeated" and not framework.writesEveryValue)
				then
					assert(
						context.env.counters().propertyWrites == 1,
						framework.name .. " did not commit exactly one property write"
					)
				end
				table.insert(snapshots, case.snapshot(state, context))
				if workload.id:match "^keyed%-" or workload.id == "status-panel" then
					local current = unchangedRows(context)
					for key, node in current do
						assert(
							previous[key] == nil or previous[key] == node,
							framework.name .. " replaced retained row " .. key
						)
					end
					previous = current
				end
			end
		end, function(problem: unknown)
			detail = problem
		end)
		case.release(state, context)
		context.env.drain()
		Frameworks.close(framework)
		if not ok then
			return framework.name .. ": " .. tostring(detail)
		end
		if
			context.env.liveInstances() ~= instances + (state.moduleInstances or 0)
			or context.env.liveConnections() ~= connections + (state.moduleConnections or 0)
		then
			return framework.name .. " retained scene instances or connections after release"
		end
		if reference then
			if #reference ~= #snapshots then
				return framework.name .. " has a different number of checkpoints from " .. referenceName
			end
			for index, snapshot in snapshots do
				if reference[index] ~= snapshot then
					return framework.name .. " differs at checkpoint " .. tostring(index - 1)
				end
			end
			if created ~= referenceCreated and workload.id ~= "library-load" then
				return ("%s created %d instances; %s created %d"):format(
					framework.name,
					created,
					referenceName,
					assert(referenceCreated)
				)
			end
			if connected < assert(referenceConnections) then
				return ("%s made %d connections; %s made %d"):format(
					framework.name,
					connected,
					referenceName,
					assert(referenceConnections)
				)
			end
		else
			reference = snapshots
			referenceName = framework.name
			referenceCreated = created
			referenceConnections = connected
		end
	end
	return nil
end

export type MemoryResult = Lute.MemoryResult & { retainedGrowthKb: number? }

local function freshContext(framework: Frameworks.Framework, cold: boolean): Workloads.Context
	local opened = Frameworks.open(framework, true)
	local environment = opened.environment
	local loaded = if cold then opened.loaded else framework.load(environment)
	environment.drain()
	return {
		env = environment,
		library = loaded.library,
		extras = loaded.extras,
		container = environment.container(),
	}
end

local function memory(workload: Workloads.Workload, framework: Frameworks.Framework): MemoryResult
	local cold = workload.id == "library-load"
	local context = freshContext(framework, cold)
	local case = assert(workload.cases[framework.name])
	local instances, connections = context.env.liveInstances(), context.env.liveConnections()
	local retention = workload.id == "teardown-under-load" or workload.id == "open-close-retention"
	local retentionBaseline: number? = nil
	local result = Lute.memory.measure({
		setup = function(): WorkloadTypes.State
			local state = case.prepare(context)
			context.env.drain()
			if retention then
				retentionBaseline = Lute.memory.settle({ cycles = 8 }).heapKb
			end
			return state
		end,
		run = function(state: WorkloadTypes.State)
			for _ = 1, workload.iterations do
				case.run(state, context)
			end
			context.env.drain()
		end,
		teardown = function(state: WorkloadTypes.State)
			case.release(state, context)
			context.env.drain()
			assert(
				context.env.liveInstances() == instances + (state.moduleInstances or 0),
				"retained scene instances after release"
			)
			assert(
				context.env.liveConnections() == connections + (state.moduleConnections or 0),
				"retained scene connections after release"
			)
		end,
		iterations = 1,
	}, { cycles = 8, maxAllocations = 2500000, deadlineSeconds = 10 })
	return {
		method = result.method,
		baseline = result.baseline,
		mounted = result.mounted,
		teardown = result.teardown,
		mountedRetainedKb = result.mountedRetainedKb,
		teardownRetainedKb = result.teardownRetainedKb,
		retainedGrowthKb = if retentionBaseline then math.max(0, result.mounted.heapKb - retentionBaseline) else nil,
	}
end

local function work(workload: Workloads.Workload, framework: Frameworks.Framework): Environment.Counters
	local context = contextFor(framework, workload.id == "library-load")
	local case = assert(workload.cases[framework.name])
	local state = case.prepare(context)
	context.env.drain()
	context.env.resetCounters()
	for _ = 1, workload.iterations do
		case.run(state, context)
	end
	context.env.drain()
	local counters = context.env.counters()
	case.release(state, context)
	context.env.drain()
	return counters
end

return { parity = parity, memory = memory, work = work }
