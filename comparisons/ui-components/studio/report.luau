--!strict

local Verify = require "../../../.lute/dependencies/verify/src/core"
local Workloads = require "../workloads"
local UNSUPPORTED = require "./unsupported"
local Lock = require "../../../dependencies.lock"

export type Machine = { [string]: string }

local LANES = { "plain", "facet" }

local function median(samples: { number }): number
	local sorted = table.clone(samples)
	table.sort(sorted)
	local middle = (#sorted + 1) // 2
	return if #sorted % 2 == 1 then sorted[middle] else (sorted[middle] + sorted[middle + 1]) / 2
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
	local facetCommit, facetTree = "unknown", "unknown"
	for _, dependency in Lock.dependencies do
		if dependency.name == "facet" then
			facetCommit, facetTree = dependency.commit, dependency.tree
		end
	end
	local lines = {
		"# UI components comparison in a Roblox Studio client",
		"",
		"Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state, against real Roblox Instances in a Roblox Studio play client. "
			.. "Facet loads from its pinned source with no change. "
			.. "Time is the median Luau time of one workload sample, from the client script profiler. Each sample ends with a real frame, so the time includes the deferred tasks and frame callbacks that the steps cause, and excludes idle frame time. "
			.. "Each ratio divides by the plain lane; lower is smaller. "
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
		("| Facet commit | `%s` |"):format(facetCommit),
		("| Facet tree | `%s` |"):format(facetTree),
		("| Date | %s |"):format(host.date),
		"",
		"Native input calls and the resulting benchmark and library handlers are in the profiler scope for both lanes. Native input routing outside those stacks, rendering, later engine layout and native interpolation are outside the scope. Toast expiry is 0.05 seconds in both lanes; enter and exit durations use the theme. Each case checks every checkpoint in an unmeasured parity pass before profiling.",
		"",
		"## Results",
		"",
		"| Workload | Iterations | Lane | Luau time (us) | / plain | Same checkpoints as plain |",
		"| --- | ---: | --- | ---: | ---: | --- |",
	}
	local total, measured = 0, 0
	for _, workload in Workloads.all do
		local plain = luau[workload.id .. "/plain"]
		local reference = snapshots[workload.id .. "/plain"]
		local reason = UNSUPPORTED[workload.id]
		for _, lane in LANES do
			local id = workload.id .. "/" .. lane
			local time = luau[id]
			if reason ~= nil then
				table.insert(
					lines,
					("| %s | %d | %s | unsupported: %s | — | — |"):format(
						workload.id,
						workload.iterations,
						lane,
						reason
					)
				)
			elseif time ~= nil then
				local same = if snapshots[id] == nil or reference == nil
					then "—"
					elseif snapshots[id] == reference then "yes"
					else "no"
				local ratio = "—"
				if plain == 0 then
					ratio = "plain below resolution"
				elseif plain ~= nil then
					ratio = ("%.2fx"):format(time / plain)
					if lane == "facet" and time > 0 then
						total += math.log(time / plain)
						measured += 1
					end
				end
				table.insert(
					lines,
					("| %s | %d | %s | %.0f | %s | %s |"):format(
						workload.id,
						workload.iterations,
						lane,
						time,
						ratio,
						same
					)
				)
			else
				table.insert(
					lines,
					("| %s | %d | %s | %s | — | — |"):format(
						workload.id,
						workload.iterations,
						lane,
						status[id] or "missing"
					)
				)
			end
		end
	end
	table.insert(lines, "\n## Summary\n")
	table.insert(
		lines,
		"The geometric mean divides each measured Facet median by the plain median of the same workload. The profiler samples every 100 us, so a plain median below that reads 0 and has no ratio.\n"
	)
	table.insert(lines, "| Lane | Measured | Geometric mean time / plain |")
	table.insert(lines, "| --- | ---: | ---: |")
	table.insert(lines, ("| plain | %d | 1.00x |"):format(measured))
	table.insert(
		lines,
		("| facet | %d | %s |"):format(
			measured,
			if measured > 0 then ("%.2fx"):format(math.exp(total / measured)) else "—"
		)
	)
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown }
