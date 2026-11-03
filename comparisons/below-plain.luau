--!strict

local HEAP_TOLERANCE_KB = 16

export type Below = { string }

local function check(
	below: Below,
	lane: string,
	workload: string,
	time: number,
	plainTime: number,
	heap: number?,
	plainHeap: number?
)
	if lane == "plain" then
		return
	end
	if time < plainTime then
		table.insert(below, ("`%s` on `%s`: time %.3f us, plain %.3f us"):format(lane, workload, time, plainTime))
	end
	if heap ~= nil and plainHeap ~= nil and heap < plainHeap - HEAP_TOLERANCE_KB then
		table.insert(below, ("`%s` on `%s`: heap %.3f KiB, plain %.3f KiB"):format(lane, workload, heap, plainHeap))
	end
end

local function section(below: Below): string
	if #below == 0 then
		return ""
	end
	return "\n## Below plain\n\nA library lane measured less than the plain lane on these rows, by time or by more than "
		.. HEAP_TOLERANCE_KB
		.. " KiB of heap. The plain lane is meant to be the minimal hand-written version of each task, so each row marks a harness defect to fix, not a library result.\n\n- "
		.. table.concat(below, "\n- ")
		.. "\n"
end

return { check = check, section = section, HEAP_TOLERANCE_KB = HEAP_TOLERANCE_KB }
