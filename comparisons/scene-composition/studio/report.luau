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
	local windows = system.os == "windows" or system.os == "Windows_NT"
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

local function memoryColumns(luau: { [string]: number }, id: string, plainId: string): string
	local heap, teardown = luau[id .. "/memory/mounted"], luau[id .. "/memory/teardown"]
	local plain = luau[plainId .. "/memory/mounted"]
	if heap == nil or teardown == nil then
		return "— | — | —"
	end
	local heapRatio = if plain == nil then "—" elseif plain == 0 then "plain zero" else ("%.2fx"):format(heap / plain)
	return ("%.0f | %s | %.0f"):format(heap, heapRatio, teardown)
end

local function markdown(report: Verify.Report, host: Machine): string
	local luau: { [string]: number } = {}
	local ranges: { [string]: string } = {}
	local snapshots: { [string]: string } = {}
	local status: { [string]: string } = {}
	for _, result in report.results do
		status[result.id] = result.status
		local evidence = result.evidence
		if evidence ~= nil then
			for _, measurement in evidence.measurements do
				luau[measurement.name] = median(measurement.input.samples)
				local spread = measurement.evaluation.summary
				if spread.minimum ~= nil and spread.maximum ~= nil then
					ranges[measurement.name] = ("%.0f–%.0f"):format(spread.minimum, spread.maximum)
				end
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
			.. "Time is the median Luau time of one workload sample, from the client script profiler. Time range is the lowest and highest measured sample, so a wide range marks a noisy case. Each update in a sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the update causes, and excludes idle frame time. "
			.. "Heap is the median retained Luau heap with the workload mounted, after its timed steps, in KiB. Teardown is the median retained heap after release. Both use the Verify `gc-witness-low-water/2` method, the same as the headless results: allocation pressure drives full collection cycles, a weak witness detects each cycle, and the reading is the lowest heap after them. Heap counts Luau memory only; engine Instance memory is not in it. "
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
		"| Workload | Iterations | Lane | Luau time (us) | Time range (us) | / plain | Heap (KiB) | / plain | Teardown (KiB) | Same tree as plain |",
		"| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |",
	}
	local summary: { [string]: number } = {}
	local ratios: { [string]: { [string]: number } } = {}
	local heapRatios: { [string]: { [string]: number } } = {}
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
					("| %s | %d | %s | unsupported: %s | — | — | — | — | — | — |"):format(
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
				summary[lane.name] = (summary[lane.name] or 0) + 1
				if plain ~= nil and plain > 0 and luau[id] > 0 then
					local laneRatios = ratios[lane.name] or {}
					ratios[lane.name] = laneRatios
					laneRatios[workload.id] = luau[id] / plain
				end
				local heap, plainHeap = luau[id .. "/memory/mounted"], luau[workload.id .. "/plain/memory/mounted"]
				if heap ~= nil and plainHeap ~= nil and heap > 0 and plainHeap > 0 then
					local laneHeaps = heapRatios[lane.name] or {}
					heapRatios[lane.name] = laneHeaps
					laneHeaps[workload.id] = heap / plainHeap
				end
				table.insert(
					lines,
					("| %s | %d | %s | %.0f | %s | %s | %s | %s |"):format(
						workload.id,
						workload.iterations,
						lane.name,
						luau[id],
						ranges[id] or "—",
						ratio(luau[id], plain),
						memoryColumns(luau, id, workload.id .. "/plain"),
						same
					)
				)
			else
				table.insert(
					lines,
					("| %s | %d | %s | %s | — | — | — | — | — | — |"):format(
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
		"The summary treats Luau time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. Lanes support different workloads, so compare a geometric mean only together with its measured count. The profiler samples every 100 us, so a plain time median below that reads 0, and a plain heap of 0 has no heap ratio. Such a workload is not in that geometric mean; its values still compare the libraries.\n"
	)
	local function sharedBy(byLane: { [string]: { [string]: number } }): { string }
		local found: { string } = {}
		for _, workload in Workloads.all do
			local everyLane = true
			for _, lane in lanes() do
				if byLane[lane.name] == nil or byLane[lane.name][workload.id] == nil then
					everyLane = false
					break
				end
			end
			if everyLane then
				table.insert(found, workload.id)
			end
		end
		return found
	end
	local function geometric(values: { [string]: number }?, ids: { string }?): string
		if values == nil then
			return "—"
		end
		local total, count = 0, 0
		if ids then
			for _, id in ids do
				total += math.log(values[id])
				count += 1
			end
		else
			for _, value in values do
				total += math.log(value)
				count += 1
			end
		end
		return if count > 0 then ("%.2fx"):format(math.exp(total / count)) else "—"
	end
	local function listed(ids: { string }): string
		return if #ids > 0 then "`" .. table.concat(ids, "`, `") .. "`" else "none"
	end
	local sharedTime, sharedHeap = sharedBy(ratios), sharedBy(heapRatios)
	table.insert(
		lines,
		("The shared columns use only the workloads that every lane measured: %d for time (%s) and %d for heap (%s).\n"):format(
			#sharedTime,
			listed(sharedTime),
			#sharedHeap,
			listed(sharedHeap)
		)
	)
	table.insert(
		lines,
		"| Lane | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |"
	)
	table.insert(lines, "| --- | ---: | ---: | ---: | ---: | ---: |")
	for _, lane in lanes() do
		table.insert(
			lines,
			("| %s | %d | %s | %s | %s | %s |"):format(
				lane.name,
				summary[lane.name] or 0,
				geometric(ratios[lane.name]),
				geometric(heapRatios[lane.name]),
				geometric(ratios[lane.name], sharedTime),
				geometric(heapRatios[lane.name], sharedHeap)
			)
		)
	end
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown, machine = machine }
