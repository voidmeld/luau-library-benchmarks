--!strict

local BelowPlain = require "../below-plain"

export type Row = {
	workload: string,
	iterations: number,
	lane: string,
	microseconds: number,
	lowest: number,
	highest: number,
	mountedKb: number,
	teardownKb: number,
	writes: number,
	created: number,
}

export type Description = { id: string, what: string }

local HEAP_FLOOR_KB = 1

local function ratio(value: number, base: number): string
	return if base > 0 then ("%.2fx"):format(value / base) else "—"
end

local function heapRatio(value: number, base: number): string
	return ("%.2fx"):format(math.max(value, HEAP_FLOOR_KB) / math.max(base, HEAP_FLOOR_KB))
end

local function geometric(rows: { Row }, lane: string, value: (Row) -> number, floor: number): (string, number)
	local base: { [string]: number } = {}
	for _, row in rows do
		if row.lane == "plain" then
			base[row.workload] = value(row)
		end
	end
	local total, count = 0, 0
	for _, row in rows do
		local reference = base[row.workload]
		if row.lane == lane and reference ~= nil then
			total += math.log(math.max(value(row), floor) / math.max(reference, floor))
			count += 1
		end
	end
	return if count > 0 then ("%.2fx"):format(math.exp(total / count)) else "—", count
end

local function markdown(
	rows: { Row },
	revision: string,
	facet: string,
	descriptions: { Description },
	fallbacks: { string }?
): string
	local lines = {
		"# UI components comparison",
		"",
		("Harness revision: `%s`. Facet: `%s`."):format(revision, facet),
		"",
		"Headless samples on the Verify reflection engine double. Each pair runs the same player task with Facet controls and with plain Instances that carry the same style tags, layout and state. Both lanes use the same Facet theme compiler for native style rules; cold mounts and complete lifetimes include that shared setup cost. Time is per complete workload sample, including its iteration count. Time range is the lowest and highest measured sample. Ratios divide by the plain lane; lower is smaller. Heap is the retained Luau heap estimate while the scene is mounted, less the heap before the scene was prepared. Teardown is the retained heap after the scene stops, less the same baseline. Heap ratios and heap means count a reading below 1 KiB as 1 KiB. Writes and Created count only the measured iterations. Every workload enters both geometric means; the summary gives the count. A ratio describes one workload on one host. It does not rank the quality of a library.",
		"",
		"Loader fallbacks: " .. (if fallbacks and #fallbacks > 0 then table.concat(fallbacks, ", ") else "none") .. ".",
		"",
		"| Workload | Iterations | Lane | Median time (us) | Time range (us) | / plain | Median heap (KiB) | / plain | Teardown (KiB) | Writes | Created |",
		"| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |",
	}
	local baselines: { [string]: Row } = {}
	for _, row in rows do
		if row.lane == "plain" then
			baselines[row.workload] = row
		end
	end
	local below = BelowPlain.create()
	for _, row in rows do
		local base = assert(baselines[row.workload])
		BelowPlain.check(
			below,
			row.lane,
			row.workload,
			row.microseconds,
			base.microseconds,
			row.mountedKb,
			base.mountedKb
		)
		table.insert(
			lines,
			("| %s | %d | %s | %.3f | %.3f–%.3f | %s | %.3f | %s | %.3f | %d | %d |"):format(
				row.workload,
				row.iterations,
				row.lane,
				row.microseconds,
				row.lowest,
				row.highest,
				ratio(row.microseconds, base.microseconds),
				row.mountedKb,
				heapRatio(row.mountedKb, base.mountedKb),
				row.teardownKb,
				row.writes,
				row.created
			)
		)
	end
	table.insert(lines, BelowPlain.section(below))
	table.insert(lines, "\n## Summary\n")
	table.insert(lines, "| Lane | Workloads | Geometric mean time / plain | Geometric mean heap / plain |")
	table.insert(lines, "| --- | ---: | ---: | ---: |")
	for _, lane in { "plain", "facet" } do
		local time, count = geometric(rows, lane, function(row: Row): number
			return row.microseconds
		end, 0)
		local heap = geometric(rows, lane, function(row: Row): number
			return row.mountedKb
		end, HEAP_FLOOR_KB)
		table.insert(lines, ("| %s | %d | %s | %s |"):format(lane, count, time, heap))
	end
	table.insert(lines, "\n## Workloads\n")
	for _, workload in descriptions do
		table.insert(lines, "- `" .. workload.id .. "`: " .. workload.what)
	end
	return table.concat(lines, "\n") .. "\n"
end

return { markdown = markdown, geometric = geometric }
