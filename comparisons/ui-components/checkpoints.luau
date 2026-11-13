--!strict

local Types = require "./types"

local SETTLE_FRAMES = 300
local STABLE_FRAMES = 6
local FRAME_SECONDS = 1 / 60

local function lines(text: string): { string }
	return string.split(text, "\n")
end

local function differences(before: string, after: string, first: string, second: string): string
	local left, right = lines(before), lines(after)
	local rows: { string } = {}
	for index = 1, math.max(#left, #right) do
		local a, b = left[index], right[index]
		if a ~= b then
			table.insert(rows, `line {index}\n{first}: {a or "(none)"}\n{second}: {b or "(none)"}`)
			if #rows == 4 then
				break
			end
		end
	end
	return table.concat(rows, "\n")
end

local function settled(world: Types.World, scene: Types.Scene): string
	local previous = scene.snapshot()
	local changed = previous
	local stable = 0
	for _ = 1, SETTLE_FRAMES do
		world.frame(FRAME_SECONDS)
		local current = scene.snapshot()
		if current == previous then
			stable += 1
			if stable >= STABLE_FRAMES then
				return current
			end
		else
			stable = 0
			changed, previous = previous, current
		end
	end
	error(`the snapshot did not settle\n{differences(changed, previous, "BEFORE", "AFTER")}`, 0)
end

local function collect(workload: Types.Workload, world: Types.World, lane: Types.Lane, settle: boolean?): { string }
	local scene = workload.prepare(world, lane)
	local snapshots: { string } = {}
	local function observe(): string
		return if settle then settled(world, scene) else scene.snapshot()
	end
	local ok, problem = pcall(function()
		for _ = 1, 30 do
			world.frame()
		end
		table.insert(snapshots, observe())
		for index = 1, workload.iterations do
			scene.step(index)
			table.insert(snapshots, observe())
		end
	end)
	scene.stop()
	world.frame()
	world.dispose()
	assert(ok, `{workload.id} {lane} lane failed at checkpoint {#snapshots}: {tostring(problem)}`)
	return snapshots
end

local function match(workload: string, reference: { string }, observed: { string })
	assert(#reference == #observed, workload .. " has a different checkpoint count")
	for index, snapshot in reference do
		local other = observed[index]
		if snapshot ~= other then
			error(`{workload} differs at checkpoint {index - 1}\n{differences(snapshot, other, "PLAIN", "FACET")}`, 0)
		end
	end
end

return { collect = collect, match = match, settled = settled }
