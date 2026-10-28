--!strict

local process = require "@lute/process"
local Verify = require "../../../.lute/dependencies/verify/src/core"
local Lanes = require "../lanes"
local Workloads = require "../workloads"
local UNSUPPORTED = require "./unsupported"

export type Machine = { [string]: string }

type Lane = { name: string }

local function command(argv: { string }): string
	local result = process.run(argv)
	return if result.ok then (result.stdout:gsub("%s+$", "")) else "unknown"
end

local function machine(): Machine
	local bytes = tonumber(command { "sysctl", "-n", "hw.memsize" })
	return {
		cpu = command { "sysctl", "-n", "machdep.cpu.brand_string" },
		cores = command { "sysctl", "-n", "hw.ncpu" },
		memory = if bytes then ("%d GiB"):format(bytes // (1024 * 1024 * 1024)) else "unknown",
		os = "macOS " .. command { "sw_vers", "-productVersion" },
		model = command { "sysctl", "-n", "hw.model" },
	}
end

local function median(samples: { number }): number
	local sorted = table.clone(samples)
	table.sort(sorted)
	local middle = (#sorted + 1) // 2
	return if #sorted % 2 == 1 then sorted[middle] else (sorted[middle] + sorted[middle + 1]) / 2
end

local function ratio(value: number?, reference: number?): string
	if value == nil or reference == nil or reference <= 0 then
		return "—"
	end
	return ("%.2fx"):format(value / reference)
end

local function lanes(): { Lane }
	local result: { Lane } = { { name = "plain" } }
	for _, entry in Lanes do
		table.insert(result, { name = entry.name })
	end
	return result
end

local function markdown(report: Verify.Report, host: Machine): string
	local luau: { [string]: number } = {}
	local snapshots: { [string]: string } = {}
	local status: { [string]: string } = {}
	for _, result in report.results do
		status[result.id] = result.status
		local evidence = result.evidence
		if evidence ~= nil then
			for _, measurement in evidence.measurements do
				luau[measurement.name] = median(measurement.input.samples)
			end
		end
		for _, artifact in result.artifacts do
			if artifact.name == "snapshot.txt" and artifact.content ~= nil then
				snapshots[result.id] = artifact.content
			end
		end
	end
	local environment = report.environment
	local lines = {
		"# Scene composition library comparison in a Roblox Studio client",
		"",
		"Each lane runs the same workloads against real Roblox Instances in a Roblox Studio play client. "
			.. "Libraries load from their pinned source, or from their published Roblox release model, with no change to library code. "
			.. "Time is the median Luau time of one workload sample, from the client script profiler. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. "
			.. "Each ratio divides by the plain lane, which does the same work with no library; lower is smaller. "
			.. "A ratio describes one workload on one machine. It does not rank the quality of a library.",
		"",
		"## Machine",
		"",
		"| Item | Value |",
		"| --- | --- |",
		("| CPU | %s |"):format(host.cpu),
		("| Cores | %s |"):format(host.cores),
		("| Memory | %s |"):format(host.memory),
		("| Model | %s |"):format(host.model),
		("| Operating system | %s |"):format(host.os),
		("| Roblox Studio | %s |"):format(environment.version or "unknown"),
		("| Context | %s |"):format(environment.context or "unknown"),
		"",
		"## Results",
		"",
		"| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |",
		"| --- | ---: | --- | ---: | ---: | --- |",
	}
	local summary: { [string]: { measured: number, logRatio: number } } = {}
	for _, workload in Workloads.all do
		local plain = luau[workload.id .. "/plain"]
		local reference = snapshots[workload.id .. "/plain"]
		for _, lane in lanes() do
			local id = workload.id .. "/" .. lane.name
			local reasons: { [string]: string } = workload.unsupported or {}
			local reason = UNSUPPORTED[workload.id]
				or (if workload.cases[lane.name] == nil then reasons[lane.name] else nil)
			if reason ~= nil then
				table.insert(
					lines,
					("| %s | %d | %s | unsupported: %s | — | — |"):format(
						workload.id,
						workload.iterations,
						lane.name,
						(reason:gsub("|", "\\|"))
					)
				)
			elseif luau[id] ~= nil then
				local same = if snapshots[id] == nil or reference == nil
					then "—"
					elseif snapshots[id] == reference then "yes"
					else "no"
				if plain ~= nil and plain > 0 and luau[id] > 0 then
					local totals = summary[lane.name] or { measured = 0, logRatio = 0 }
					summary[lane.name] = totals
					totals.measured += 1
					totals.logRatio += math.log(luau[id] / plain)
				end
				table.insert(
					lines,
					("| %s | %d | %s | %.0f | %s | %s |"):format(
						workload.id,
						workload.iterations,
						lane.name,
						luau[id],
						ratio(luau[id], plain),
						same
					)
				)
			else
				table.insert(
					lines,
					("| %s | %d | %s | %s | — | — |"):format(
						workload.id,
						workload.iterations,
						lane.name,
						status[id] or "missing"
					)
				)
			end
		end
	end
	table.insert(lines, "\n## Summary\n")
	table.insert(
		lines,
		"The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count.\n"
	)
	table.insert(lines, "| Lane | Measured | Geometric mean time / plain |")
	table.insert(lines, "| --- | ---: | ---: |")
	for _, lane in lanes() do
		local entry = summary[lane.name]
		table.insert(
			lines,
			("| %s | %d | %s |"):format(
				lane.name,
				if entry then entry.measured else 0,
				if entry and entry.measured > 0
					then ("%.2fx"):format(math.exp(entry.logRatio / entry.measured))
					else "—"
			)
		)
	end
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown, machine = machine }
