--!strict

local Frameworks = require "./harness/frameworks"
local Workloads = require "./workloads"

local function firstDifference(expected: string, actual: string): string
	local expectedLines: { string } = {}
	local actualLines: { string } = {}
	for line in string.gmatch(expected, "[^\n]*") do
		table.insert(expectedLines, line)
	end
	for line in string.gmatch(actual, "[^\n]*") do
		table.insert(actualLines, line)
	end
	for index = 1, math.max(#expectedLines, #actualLines) do
		if expectedLines[index] ~= actualLines[index] then
			return ("line %d: expected %s, produced %s"):format(
				index,
				tostring(expectedLines[index]),
				tostring(actualLines[index])
			)
		end
	end
	return "trees differ in length"
end

local function mismatch(order: { Frameworks.Framework }, snapshots: { [string]: string }): string?
	local reference: string? = nil
	local referenceName = ""
	for _, framework in order do
		local snapshot = snapshots[framework.name]
		if snapshot == nil then
			continue
		end
		if reference == nil then
			reference = snapshot
			referenceName = framework.name
		elseif snapshot ~= reference then
			return ("%s differs from %s (%s)"):format(
				framework.name,
				referenceName,
				firstDifference(reference, snapshot)
			)
		end
	end
	return nil
end

local function workloadSnapshot(workload: Workloads.Workload, framework: Frameworks.Framework): (string?, string?)
	local result: Frameworks.Opened? = nil
	local loaded, problem: unknown = pcall(function()
		result = Frameworks.open(framework)
	end)
	if not loaded then
		return nil, ("could not load: %s"):format(tostring(problem))
	end
	local resolved = assert(result)
	local environment = resolved.environment
	local case = workload.cases[framework.name]
	local observed: { string } = {}
	local context: Workloads.Context = {
		env = environment,
		library = resolved.loaded.library,
		extras = resolved.loaded.extras,
		container = environment.container(),
		observe = function(snapshot: string)
			table.insert(observed, snapshot)
		end,
	}
	local snapshot: string? = nil
	local ran, err: unknown = pcall(function()
		local state = case.prepare(context)
		for _ = 1, workload.iterations do
			case.run(state, context)
		end
		environment.drain()
		table.insert(observed, case.snapshot(state, context))
		snapshot = table.concat(observed, "\n")
		case.release(state, context)
		environment.drain()
	end)
	if not ran then
		return nil, ("raised: %s"):format(tostring(err))
	end
	return snapshot, nil
end

local function workload(subject: Workloads.Workload, order: { Frameworks.Framework }): string?
	local snapshots: { [string]: string } = {}
	local problems: { string } = {}
	for _, framework in order do
		if subject.cases[framework.name] == nil then
			local unsupported = subject.unsupported
			if unsupported == nil or unsupported[framework.name] == nil then
				table.insert(
					problems,
					("%s has neither an implementation nor a recorded reason for not having one"):format(framework.name)
				)
			end
			continue
		end
		local snapshot, err = workloadSnapshot(subject, framework)
		if err ~= nil then
			table.insert(problems, ("%s %s"):format(framework.name, err))
		elseif snapshot ~= nil then
			snapshots[framework.name] = snapshot
		end
	end
	if #problems > 0 then
		return table.concat(problems, "; ")
	end
	return mismatch(order, snapshots)
end

return {
	workload = workload,
}
