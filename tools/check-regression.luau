--!strict
local fs = require "@std/fs"
local process = require "@std/process"
local Finish = require "./lib/check-result"

local TIME_TOLERANCE = 1.05
local HEAP_TOLERANCE = 1.05
local KIB_SLACK = 16

type Row = { ratio: number, heap: number, teardown: number }
type Samples = { ratio: { number }, heap: { number }, teardown: { number } }

local function cells(line: string): { string }
	local out = {}
	for _, cell in string.split(line, "|") do
		table.insert(out, (string.gsub(cell, "^%s*(.-)%s*$", "%1")))
	end
	return out
end

local function load(path: string, lanes: { [string]: true }, into: { [string]: Samples })
	for _, line in string.split(fs.readFileToString(path), "\n") do
		local c = cells(line)
		local lane = c[4] and (string.gsub(c[4], " %(workaround%)$", ""))
		if lane and lanes[lane] and c[3] and string.match(c[3], "^%d+$") then
			local ratio = tonumber((string.gsub(c[7] or "", "x$", "")))
			local heap, teardown = tonumber(c[8]), tonumber(c[10])
			if ratio and heap and teardown then
				local key = c[2] .. " / " .. lane
				local samples = into[key] or { ratio = {}, heap = {}, teardown = {} }
				into[key] = samples
				table.insert(samples.ratio, ratio)
				table.insert(samples.heap, heap)
				table.insert(samples.teardown, teardown)
			end
		end
	end
end

local function median(values: { number }): number
	local sorted = table.clone(values)
	table.sort(sorted)
	local middle = #sorted // 2
	return if #sorted % 2 == 1 then sorted[middle + 1] else (sorted[middle] + sorted[middle + 1]) / 2
end

local function highest(values: { number }): number
	return math.max(table.unpack(values))
end

local function gather(list: string, lanes: { [string]: true }): ({ [string]: Samples }, number)
	local samples: { [string]: Samples } = {}
	local count = 0
	for _, path in string.split(list, ",") do
		load(path, lanes, samples)
		count += 1
	end
	return samples, count
end

local baselineList, candidateList, laneList = process.args[2], process.args[3], process.args[4]
assert(
	baselineList and candidateList and laneList,
	"usage: lute run tools/check-regression.luau BASELINE.md[,...] CANDIDATE.md[,...] LANE[,LANE]"
)
local lanes: { [string]: true } = {}
for _, lane in string.split(laneList, ",") do
	lanes[lane] = true
end
local baseline, baselineRuns = gather(baselineList, lanes)
local candidate, candidateRuns = gather(candidateList, lanes)
local findings: { string } = {}
local compared = 0
for key, now in candidate do
	local before = baseline[key]
	if before then
		compared += 1
		local ratio, heap, teardown = median(now.ratio), median(now.heap), median(now.teardown)
		local beforeRatio, beforeHeap, beforeTeardown =
			median(before.ratio), median(before.heap), median(before.teardown)
		if ratio > beforeRatio * TIME_TOLERANCE and ratio > highest(before.ratio) then
			table.insert(findings, `{key}: time/plain median {beforeRatio} -> {ratio}`)
		end
		if heap > beforeHeap * HEAP_TOLERANCE + KIB_SLACK and heap > highest(before.heap) then
			table.insert(findings, `{key}: heap median {beforeHeap} -> {heap} KiB`)
		end
		if teardown > beforeTeardown + KIB_SLACK and teardown > highest(before.teardown) then
			table.insert(findings, `{key}: teardown median {beforeTeardown} -> {teardown} KiB`)
		end
	end
end
table.sort(findings)
assert(compared > 0, "no workloads matched between baseline and candidate")
print(
	`check-regression: compared {compared} workload lanes over {baselineRuns} baseline and {candidateRuns} candidate runs`
)
Finish("check-regression", findings)
