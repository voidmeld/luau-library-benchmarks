--!strict
local fs = require "@std/fs"
local process = require "@std/process"
local Finish = require "./lib/check-result"

local TIME_TOLERANCE = 1.08
local HEAP_TOLERANCE = 1.05
local KIB_SLACK = 16

type Row = { ratio: number, heap: number, teardown: number }

local function cells(line: string): { string }
	local out = {}
	for _, cell in string.split(line, "|") do
		table.insert(out, (string.gsub(cell, "^%s*(.-)%s*$", "%1")))
	end
	return out
end

local function load(path: string, lanes: { [string]: true }): { [string]: Row }
	local rows: { [string]: Row } = {}
	for _, line in string.split(fs.readFileToString(path), "\n") do
		local c = cells(line)
		local lane = c[4] and (string.gsub(c[4], " %(workaround%)$", ""))
		if lane and lanes[lane] and c[3] and string.match(c[3], "^%d+$") then
			local ratio = tonumber((string.gsub(c[7] or "", "x$", "")))
			local heap, teardown = tonumber(c[8]), tonumber(c[10])
			if ratio and heap and teardown then
				rows[c[2] .. " / " .. lane] = { ratio = ratio, heap = heap, teardown = teardown }
			end
		end
	end
	return rows
end

local baselinePath, candidatePath, laneList = process.args[2], process.args[3], process.args[4]
assert(
	baselinePath and candidatePath and laneList,
	"usage: lute run tools/check-regression.luau BASELINE.md CANDIDATE.md LANE[,LANE]"
)
local lanes: { [string]: true } = {}
for _, lane in string.split(laneList, ",") do
	lanes[lane] = true
end
local baseline, candidate = load(baselinePath, lanes), load(candidatePath, lanes)
local findings: { string } = {}
local compared = 0
for key, now in candidate do
	local before = baseline[key]
	if before then
		compared += 1
		if now.ratio > before.ratio * TIME_TOLERANCE then
			table.insert(findings, `{key}: time/plain {before.ratio} -> {now.ratio}`)
		end
		if now.heap > before.heap * HEAP_TOLERANCE + KIB_SLACK then
			table.insert(findings, `{key}: heap {before.heap} -> {now.heap} KiB`)
		end
		if now.teardown > before.teardown + KIB_SLACK then
			table.insert(findings, `{key}: teardown {before.teardown} -> {now.teardown} KiB`)
		end
	end
end
table.sort(findings)
assert(compared > 0, "no workloads matched between baseline and candidate")
print(`check-regression: compared {compared} workload lanes`)
Finish("check-regression", findings)
