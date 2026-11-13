--!strict
local fs = require "@std/fs"
local process = require "@std/process"
local Finish = require "./lib/check-result"

local FLOOR = 0.9
local WRITE_SLACK = 1.25

type Row = { lane: string, ratio: number, low: number?, high: number?, writes: number?, created: number? }

local function cells(line: string): { string }
	local out = {}
	for _, cell in string.split(line, "|") do
		table.insert(out, (string.gsub(cell, "^%s*(.-)%s*$", "%1")))
	end
	return out
end

local function rows(path: string): { [string]: { Row } }
	local workloads: { [string]: { Row } } = {}
	for _, line in string.split(fs.readFileToString(path), "\n") do
		local c = cells(line)
		local lane = c[4] and (string.gsub(c[4], " %(workaround%)$", ""))
		local ratio = tonumber((string.gsub(c[7] or "", "x$", "")))
		if lane and ratio and c[3] and string.match(c[3], "^%d+$") then
			local list = workloads[c[2]] or {}
			workloads[c[2]] = list
			local low, high = string.match(c[6] or "", "^([%d%.]+)%D+([%d%.]+)$")
			table.insert(list, {
				lane = lane,
				ratio = ratio,
				low = tonumber(low),
				high = tonumber(high),
				writes = tonumber(c[11]),
				created = tonumber(c[12]),
			})
		end
	end
	return workloads
end

local paths = process.args[2]
assert(paths, "usage: lute run tools/check-floor.luau COMPARISON.md[,...]")
local failures: { string } = {}
local notes: { string } = {}
local checked = 0
for _, path in string.split(paths, ",") do
	for workload, list in rows(path) do
		local plain: Row? = nil
		for _, row in list do
			if row.lane == "plain" then
				plain = row
			end
		end
		if plain then
			for _, row in list do
				if row.lane ~= "plain" then
					checked += 1
					local laneHigh, plainLow = row.high, plain.low
					if laneHigh and plainLow and laneHigh < plainLow then
						table.insert(
							failures,
							`{workload} / {row.lane}: every sample is faster than every plain sample ({row.ratio}x plain)`
						)
					elseif row.ratio < FLOOR then
						table.insert(
							notes,
							`{workload} / {row.lane}: median {row.ratio}x plain, within the plain sample range`
						)
					end
					local plainWrites, laneWrites = plain.writes, row.writes
					if plainWrites and laneWrites and plainWrites > laneWrites * WRITE_SLACK + 10 then
						table.insert(
							notes,
							`{workload} / {row.lane}: plain writes {plainWrites}, lane writes {laneWrites}`
						)
					end
					local plainCreated, laneCreated = plain.created, row.created
					if plainCreated and laneCreated and plainCreated > laneCreated then
						table.insert(
							notes,
							`{workload} / {row.lane}: plain creates {plainCreated}, lane creates {laneCreated}`
						)
					end
				end
			end
		end
	end
end
table.sort(failures)
table.sort(notes)
print(`check-floor: compared {checked} lanes with plain`)
for _, note in notes do
	print("note: " .. note)
end
Finish("check-floor", failures)
