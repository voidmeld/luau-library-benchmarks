--!strict

local HEAP_TOLERANCE_KB = 16
local TIME_TOLERANCE = 0.05

local ACCEPTED: { [string]: string } = {
	["derived-chain-100/roact/heap"] = "Roact keeps no derived graph between renders and recomputes every value on each update, so it holds less memory and takes more time than plain.",
	["derived-fan-in-1000/roact/heap"] = "Roact keeps no derived graph between renders and recomputes every value on each update, so it holds less memory and takes more time than plain.",
	["form-validation/vide/time"] = "Plain keeps one global version, so each write recomputes every derived value; Vide tracks dependencies and recomputes only the affected ones.",
}

export type Below = { flagged: { string }, accepted: { string } }

local function create(): Below
	return { flagged = {}, accepted = {} }
end

local function record(below: Below, lane: string, workload: string, metric: string, line: string)
	local reason = ACCEPTED[workload .. "/" .. lane .. "/" .. metric]
	if reason ~= nil then
		table.insert(below.accepted, line .. ". " .. reason)
	else
		table.insert(below.flagged, line)
	end
end

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
	if time < plainTime * (1 - TIME_TOLERANCE) then
		record(
			below,
			lane,
			workload,
			"time",
			("`%s` on `%s`: time %.3f us, plain %.3f us"):format(lane, workload, time, plainTime)
		)
	end
	if heap ~= nil and plainHeap ~= nil and heap < plainHeap - HEAP_TOLERANCE_KB then
		record(
			below,
			lane,
			workload,
			"heap",
			("`%s` on `%s`: heap %.3f KiB, plain %.3f KiB"):format(lane, workload, heap, plainHeap)
		)
	end
end

local function section(below: Below): string
	local parts: { string } = {}
	if #below.flagged > 0 then
		table.insert(
			parts,
			"\n## Below plain\n\nA library lane measured less than the plain lane on these rows, by more than "
				.. math.floor(TIME_TOLERANCE * 100)
				.. "% of time or "
				.. HEAP_TOLERANCE_KB
				.. " KiB of heap. The plain lane is meant to be the minimal hand-written version of each task, so each row marks a harness defect to fix, not a library result.\n\n- "
				.. table.concat(below.flagged, "\n- ")
				.. "\n"
		)
	end
	if #below.accepted > 0 then
		table.insert(
			parts,
			"\n## Accepted below plain\n\nOn these rows a library lane measures less than plain because it trades one resource for another. The plain lane is minimal for its design.\n\n- "
				.. table.concat(below.accepted, "\n- ")
				.. "\n"
		)
	end
	return table.concat(parts)
end

return {
	create = create,
	check = check,
	section = section,
	ACCEPTED = ACCEPTED,
	HEAP_TOLERANCE_KB = HEAP_TOLERANCE_KB,
	TIME_TOLERANCE = TIME_TOLERANCE,
}
