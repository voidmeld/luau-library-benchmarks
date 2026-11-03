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

local function report(below: Below)
	for _, line in below.flagged do
		print("below plain: " .. line)
	end
	for _, line in below.accepted do
		print("below plain, accepted: " .. line)
	end
end

return {
	create = create,
	check = check,
	report = report,
	ACCEPTED = ACCEPTED,
	HEAP_TOLERANCE_KB = HEAP_TOLERANCE_KB,
	TIME_TOLERANCE = TIME_TOLERANCE,
}
