--!strict

local Types = require "./types"

local SETTLE_FRAMES = 300
local STABLE_FRAMES = 15
local STUDIO_CHECKPOINTS = 10
local PREPARE_SECONDS = 0.25
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
	world.frame(PREPARE_SECONDS)
	local ok, previous = pcall(scene.snapshot)
	local changed = previous
	local stable = 0
	for _ = 1, SETTLE_FRAMES do
		world.frame(FRAME_SECONDS)
		local good, current = pcall(scene.snapshot)
		if good and ok and current == previous then
			stable += 1
			if stable >= STABLE_FRAMES then
				return current
			end
		else
			stable = 0
			changed, previous, ok = previous, current, good
		end
	end
	if not ok then
		error(tostring(previous), 0)
	end
	error(`the snapshot did not settle\n{differences(tostring(changed), tostring(previous), "BEFORE", "AFTER")}`, 0)
end

local function collect(workload: Types.Workload, world: Types.World, lane: Types.Lane, settle: boolean?): { string }
	local scene = workload.prepare(world, lane)
	local snapshots: { string } = {}
	local iterations = workload.iterations
	local function observe(index: number): string
		if not settle then
			return scene.snapshot()
		end
		local sampled = iterations <= STUDIO_CHECKPOINTS
			or index == 0
			or index == iterations
			or math.floor(index * STUDIO_CHECKPOINTS / iterations)
				~= math.floor((index - 1) * STUDIO_CHECKPOINTS / iterations)
		return if sampled then settled(world, scene) else ""
	end
	local ok, problem = pcall(function()
		for _ = 1, 30 do
			world.frame()
		end
		table.insert(snapshots, observe(0))
		for index = 1, iterations do
			scene.step(index)
			table.insert(snapshots, observe(index))
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
