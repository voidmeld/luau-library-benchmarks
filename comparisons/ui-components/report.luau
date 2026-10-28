--!strict

export type Row = {
	workload: string,
	iterations: number,
	lane: string,
	microseconds: number,
	mountedKb: number,
	teardownKb: number,
	writes: number,
	created: number,
}

export type Description = { id: string, what: string }

local function ratio(value: number, base: number): string
	return if base > 0 then ("%.2fx"):format(value / base) else "—"
end

local function geometric(rows: { Row }, lane: string, value: (Row) -> number): string
	local base: { [string]: number } = {}
	for _, row in rows do
		if row.lane == "plain" then
			base[row.workload] = value(row)
		end
	end
	local total, count = 0, 0
	for _, row in rows do
		local reference = base[row.workload]
		if row.lane == lane and reference ~= nil and reference > 0 and value(row) > 0 then
			total += math.log(value(row) / reference)
			count += 1
		end
	end
	return if count > 0 then ("%.2fx"):format(math.exp(total / count)) else "—"
end

local function markdown(rows: { Row }, revision: string, facet: string, descriptions: { Description }): string
	local lines = {
		"# UI components comparison",
		"",
		("Harness revision: `%s`. Facet: `%s`."):format(revision, facet),
		"",
		"Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Time is per complete workload sample, including its iteration count. Ratios divide by the plain lane, which uses no library; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted and after teardown. Writes and Created count only the measured iterations. A ratio describes one workload on one host. It does not rank the quality of a library.",
		"",
		"| Workload | Iterations | Lane | Median time (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |",
		"| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
	}
	local baselines: { [string]: Row } = {}
	for _, row in rows do
		if row.lane == "plain" then
			baselines[row.workload] = row
		end
	end
	for _, row in rows do
		local base = assert(baselines[row.workload])
		table.insert(
			lines,
			("| %s | %d | %s | %.3f | %s | %.3f | %s | %.3f | %d | %d |"):format(
				row.workload,
				row.iterations,
				row.lane,
				row.microseconds,
				ratio(row.microseconds, base.microseconds),
				row.mountedKb,
				ratio(row.mountedKb, base.mountedKb),
				row.teardownKb,
				row.writes,
				row.created
			)
		)
	end
	table.insert(lines, "\n## Summary\n")
	table.insert(lines, "| Lane | Geometric mean time / plain | Geometric mean heap / plain |")
	table.insert(lines, "| --- | ---: | ---: |")
	for _, lane in { "plain", "facet" } do
		table.insert(
			lines,
			("| %s | %s | %s |"):format(
				lane,
				geometric(rows, lane, function(row: Row): number
					return row.microseconds
				end),
				geometric(rows, lane, function(row: Row): number
					return row.mountedKb
				end)
			)
		)
	end
	table.insert(lines, "\n## Workloads\n")
	for _, workload in descriptions do
		table.insert(lines, "- `" .. workload.id .. "`: " .. workload.what)
	end
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown, geometric = geometric }
