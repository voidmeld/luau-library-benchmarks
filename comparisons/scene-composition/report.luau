--!strict

local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Verify = require "../../.lute/dependencies/verify/src/core"
local Frameworks = require "./harness/frameworks"
local Workloads = require "./workloads"
local Lock = require "../../dependencies.lock"
local Environment = require "./cost-model"

export type WorkMetric = { name: string, label: string, read: (Environment.Counters) -> number }

local WORK: { WorkMetric } = {
	{
		name = "writes",
		label = "Writes",
		read = function(counters: Environment.Counters): number
			return counters.propertyWrites
		end,
	},
	{
		name = "created",
		label = "Created",
		read = function(counters: Environment.Counters): number
			return counters.instancesCreated
		end,
	},
	{
		name = "connections",
		label = "Connections",
		read = function(counters: Environment.Counters): number
			return counters.connectionsMade
		end,
	},
	{
		name = "deferred",
		label = "Deferred",
		read = function(counters: Environment.Counters): number
			return counters.tasksDeferred
		end,
	},
}

local function store(name: string, report: Verify.Report): Benchmark.Stored
	local measurements: { Benchmark.StoredMeasurement } = {}
	for _, result in report.results do
		if result.status ~= "passed" or result.evidence == nil then
			continue
		end
		for _, measurement in result.evidence.measurements do
			table.insert(measurements, {
				name = measurement.name,
				unit = measurement.input.unit,
				environment = measurement.input.context.environment,
				samples = table.clone(measurement.input.samples),
			})
		end
	end
	return { schemaVersion = 1, name = name, measurements = measurements }
end

local function median(samples: { number }): number
	assert(#samples > 0, "median needs samples")
	local sorted = table.clone(samples)
	table.sort(sorted)
	local middle = (#sorted + 1) // 2
	return if #sorted % 2 == 1 then sorted[middle] else (sorted[middle] + sorted[middle + 1]) / 2
end

local function ratio(value: number, reference: number): string
	return if reference > 0 then ("%.2fx"):format(value / reference) else "n/a (zero baseline)"
end

local function escape(value: string): string
	return (value:gsub("|", "\\|"):gsub("\n", " "))
end

local function workOf(byName: { [string]: Benchmark.StoredMeasurement }, prefix: string): string?
	local cells: { string } = {}
	for _, metric in WORK do
		local measurement = byName[prefix .. "/work/" .. metric.name]
		if measurement == nil then
			return nil
		end
		table.insert(cells, ("%d"):format(median(measurement.samples)))
	end
	return table.concat(cells, " | ")
end

local function markdown(
	run: Benchmark.Stored,
	workloads: { Workloads.Workload },
	frameworks: { Frameworks.Framework }
): (string, boolean)
	local byName: { [string]: Benchmark.StoredMeasurement } = {}
	for _, measurement in run.measurements do
		byName[measurement.name] = measurement
	end
	local lines = {
		"# Scene composition library comparison",
		"",
		"Headless cost-model samples. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the mounted retained Luau estimate. Writes, Created, Connections and Deferred count the engine property writes, instances, signal connections and deferred tasks of the timed iterations. A zero heap baseline has no ratio. These results do not measure Roblox engine performance. A ratio describes one workload on one host. It does not rank the quality of a library.",
		"",
		"| Workload | Iterations | Framework | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created | Connections | Deferred |",
		"| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
	}
	local complete = true
	local summary: { [string]: { supported: number, measured: number } } = {}
	local timeRatios: { [string]: { [string]: number } } = {}
	local heapRatios: { [string]: { [string]: number } } = {}
	for _, framework in frameworks do
		summary[framework.name] = { supported = 0, measured = 0 }
		timeRatios[framework.name] = {}
		heapRatios[framework.name] = {}
	end
	for _, workload in workloads do
		local label = workload.id
		local plainTime = byName[workload.id .. "/plain"]
		local plainHeap = byName[workload.id .. "/plain/memory/mounted"]
		for _, framework in frameworks do
			local prefix = workload.id .. "/" .. framework.name
			local time = byName[prefix]
			local heap = byName[prefix .. "/memory/mounted"]
			local teardown = byName[prefix .. "/memory/teardown"]
			if workload.cases[framework.name] == nil then
				local reason = assert(
					workload.unsupported and workload.unsupported[framework.name],
					"unsupported reason is missing"
				)
				table.insert(
					lines,
					("| %s | %d | %s | unsupported: %s | — | — | — | — | — | — | — | — | — |"):format(
						label,
						workload.iterations,
						framework.name,
						escape(reason)
					)
				)
			elseif time and heap and teardown and plainTime and plainHeap and workOf(byName, prefix) then
				local timeMedian, heapMedian = median(time.samples), median(heap.samples)
				local plainMedian = median(plainTime.samples)
				local lane = summary[framework.name]
				lane.supported += 1
				lane.measured += 1
				if timeMedian > 0 and plainMedian > 0 then
					timeRatios[framework.name][workload.id] = timeMedian / plainMedian
				end
				local plainHeapMedian = median(plainHeap.samples)
				if heapMedian > 0 and plainHeapMedian > 0 then
					heapRatios[framework.name][workload.id] = heapMedian / plainHeapMedian
				end
				table.insert(
					lines,
					("| %s | %d | %s | %.3f | %s | %s | %.3f | %s | %.3f | %s |"):format(
						label,
						workload.iterations,
						framework.name,
						timeMedian,
						("%.3f–%.3f"):format(
							math.min(table.unpack(time.samples)),
							math.max(table.unpack(time.samples))
						),
						ratio(timeMedian, plainMedian),
						heapMedian,
						ratio(heapMedian, median(plainHeap.samples)),
						median(teardown.samples),
						assert(workOf(byName, prefix))
					)
				)
			else
				complete = false
				summary[framework.name].supported += 1
				table.insert(
					lines,
					("| %s | %d | %s | missing evidence | — | — | — | — | — | — | — | — | — |"):format(
						label,
						workload.iterations,
						framework.name
					)
				)
			end
		end
	end
	local retentionWorkloads: { Workloads.Workload } = {}
	for _, workload in workloads do
		if workload.id == "teardown-under-load" or workload.id == "open-close-retention" then
			table.insert(retentionWorkloads, workload)
		end
	end
	if #retentionWorkloads > 0 then
		table.insert(lines, "\n## Page retention\n")
		table.insert(
			lines,
			"Growth is the retained Luau heap after the page closes minus the retained heap with only its source owner and host mounted. Collection runs before both readings. The source owner stays alive during the run. Collection noise can make the difference negative; such a reading counts as 0, as in the Verify mounted and teardown readings.\n"
		)
		table.insert(lines, "| Workload | Framework | Median retained growth (KiB) |")
		table.insert(lines, "| --- | --- | ---: |")
		for _, workload in retentionWorkloads do
			for _, framework in frameworks do
				if workload.cases[framework.name] then
					local growth = byName[workload.id .. "/" .. framework.name .. "/memory/growth"]
					if growth == nil then
						complete = false
					end
					table.insert(
						lines,
						("| %s | %s | %s |"):format(
							workload.id,
							framework.name,
							if growth then ("%.3f"):format(median(growth.samples)) else "missing evidence"
						)
					)
				end
			end
		end
	end
	table.insert(lines, "\n## Summary\n")
	table.insert(
		lines,
		("This summary uses the %d selected workloads and treats time and retained heap alike. Each geometric mean divides a lane's median by the plain median of the same workload. A workload whose plain heap is zero has no heap ratio. Lanes support different workloads, so compare a geometric mean only together with its measured count.\n"):format(
			#workloads
		)
	)
	local function sharedBy(ratios: { [string]: { [string]: number } }): { string }
		local found: { string } = {}
		for _, workload in workloads do
			local everyLane = true
			for _, framework in frameworks do
				if ratios[framework.name][workload.id] == nil then
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
	local function geometric(values: { [string]: number }, ids: { string }?): string
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
	local sharedTime, sharedHeap = sharedBy(timeRatios), sharedBy(heapRatios)
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
		"| Framework | Supported | Measured | Geometric mean time / plain | Geometric mean heap / plain | Shared workloads, time / plain | Shared workloads, heap / plain |"
	)
	table.insert(lines, "| --- | ---: | ---: | ---: | ---: | ---: | ---: |")
	for _, framework in frameworks do
		local lane = summary[framework.name]
		table.insert(
			lines,
			("| %s | %d | %d | %s | %s | %s | %s |"):format(
				framework.name,
				lane.supported,
				lane.measured,
				geometric(timeRatios[framework.name]),
				geometric(heapRatios[framework.name]),
				geometric(timeRatios[framework.name], sharedTime),
				geometric(heapRatios[framework.name], sharedHeap)
			)
		)
	end
	table.insert(lines, "\n## Source identities\n")
	table.insert(
		lines,
		"Harness revision: `"
			.. run.name
			.. "`. Full source state, tools, environment and command are in `context.json`.\n"
	)
	table.insert(lines, "| Dependency | Version | Commit | Tree | Rights |")
	table.insert(lines, "| --- | --- | --- | --- | --- |")
	for _, dependency in Lock.dependencies do
		if dependency.name == "verify" then
			continue
		end
		table.insert(
			lines,
			("| %s | %s | `%s` | `%s` | %s |"):format(
				dependency.name,
				dependency.version,
				dependency.commit,
				dependency.tree,
				dependency.rights
			)
		)
	end
	table.insert(
		lines,
		"\nRaw samples, calibration attempts, parity results and heap readings are in the evidence artifact. Unsupported rows are omissions with reasons, not performance results. Missing evidence does not qualify as a complete comparison.\n"
	)
	return table.concat(lines, "\n"), complete
end

local function fallbacks(report: Verify.Report): string
	local seen: { [string]: true } = {}
	local chunks: { string } = {}
	for _, result in report.results do
		for _, artifact in result.artifacts do
			if artifact.name ~= "loader-fallbacks.txt" or artifact.content == nil then
				continue
			end
			for chunk in (artifact.content :: string):gmatch "[^\n]+" do
				if not seen[chunk] then
					seen[chunk] = true
					table.insert(chunks, chunk)
				end
			end
		end
	end
	table.sort(chunks)
	local lines = {
		"\n## Loader fallbacks\n",
		"The loader binds the cost-model globals of each library file on its first line. These files cannot take that binding. They load with their own copy of the cost-model global table as their environment, so their global reads do not use the Luau fast paths.\n",
	}
	if #chunks == 0 then
		table.insert(lines, "No file used the fallback.")
	end
	for _, chunk in chunks do
		table.insert(lines, "- `" .. chunk:gsub("^@", "") .. "`")
	end
	return table.concat(lines, "\n") .. "\n"
end

return { WORK = WORK, fallbacks = fallbacks, markdown = markdown, median = median, store = store }
