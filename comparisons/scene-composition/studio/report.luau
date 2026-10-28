--!strict

local process = require "@lute/process"
local system = require "@lute/system"
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

local function powershell(expression: string): string
	return command { "powershell", "-NoProfile", "-Command", expression }
end

local function machine(): Machine
	local windows = system.os == "windows"
	local cpus = system.cpus()
	return {
		cpu = if #cpus > 0 then cpus[1].model else "unknown",
		cores = tostring(system.threadCount()),
		memory = ("%d GiB"):format(math.floor(system.totalMemory() / 1024 + 0.5)),
		os = if windows
			then powershell "(Get-CimInstance Win32_OperatingSystem).Caption + ' ' + (Get-CimInstance Win32_OperatingSystem).Version"
			else "macOS " .. command { "sw_vers", "-productVersion" },
		model = if windows
			then powershell "(Get-CimInstance Win32_ComputerSystem).Manufacturer + ' ' + (Get-CimInstance Win32_ComputerSystem).Model"
			else command { "sysctl", "-n", "hw.model" },
		revision = command { "git", "rev-parse", "--short", "HEAD" },
		date = os.date "!%Y-%m-%d",
	}
end

local function median(samples: { number }): number
	local sorted = table.clone(samples)
	table.sort(sorted)
	local middle = (#sorted + 1) // 2
	return if #sorted % 2 == 1 then sorted[middle] else (sorted[middle] + sorted[middle + 1]) / 2
end

local function ratio(value: number?, reference: number?): string
	if reference == 0 then
		return "plain below resolution"
	elseif value == nil or reference == nil or reference < 0 then
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
			local digest = artifact.sha256 or artifact.content
			if artifact.name == "snapshot.txt" and digest ~= nil then
				snapshots[result.id] = digest
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
		("| Harness revision | `%s` |"):format(host.revision),
		("| Date | %s |"):format(host.date),
		"",
		"## Results",
		"",
		"| Workload | Iterations | Lane | Luau time (us) | / plain | Same tree as plain |",
		"| --- | ---: | --- | ---: | ---: | --- |",
	}
	local summary: { [string]: { measured: number, logRatio: number } } = {}
	local ratios: { [string]: { [string]: number } } = {}
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
					local laneRatios = ratios[lane.name] or {}
					ratios[lane.name] = laneRatios
					laneRatios[workload.id] = luau[id] / plain
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
		"The geometric mean divides each measured median Luau time by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain median below that reads 0. Such a workload has no ratio and is not in the geometric mean; its times still compare the libraries.\n"
	)
	local shared: { string } = {}
	for _, workload in Workloads.all do
		local everyLane = true
		for _, lane in lanes() do
			if ratios[lane.name] == nil or ratios[lane.name][workload.id] == nil then
				everyLane = false
				break
			end
		end
		if everyLane then
			table.insert(shared, workload.id)
		end
	end
	table.insert(
		lines,
		("The shared column uses only the %d workloads that every lane measured: %s.\n"):format(
			#shared,
			if #shared > 0 then "`" .. table.concat(shared, "`, `") .. "`" else "none"
		)
	)
	table.insert(lines, "| Lane | Measured | Geometric mean time / plain | Shared workloads, geometric mean / plain |")
	table.insert(lines, "| --- | ---: | ---: | ---: |")
	for _, lane in lanes() do
		local entry = summary[lane.name]
		local sharedLog = 0
		for _, id in shared do
			sharedLog += math.log(ratios[lane.name][id])
		end
		table.insert(
			lines,
			("| %s | %d | %s | %s |"):format(
				lane.name,
				if entry then entry.measured else 0,
				if entry and entry.measured > 0
					then ("%.2fx"):format(math.exp(entry.logRatio / entry.measured))
					else "—",
				if #shared > 0 then ("%.2fx"):format(math.exp(sharedLog / #shared)) else "—"
			)
		)
	end
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown, machine = machine }
