--!strict

local Types = require "./types"

local SETTLE_FRAMES = 300
local STABLE_FRAMES = 10

local function settled(world: Types.World, scene: Types.Scene): string
	local previous = scene.snapshot()
	local stable = 0
	for _ = 1, SETTLE_FRAMES do
		world.frame()
		local current = scene.snapshot()
		if current == previous then
			stable += 1
			if stable >= STABLE_FRAMES then
				return current
			end
		else
			stable = 0
			previous = current
		end
	end
	return previous
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
		assert(
			snapshot == observed[index],
			`{workload} differs at checkpoint {index - 1}\nPLAIN: {snapshot}\nFACET: {observed[index]}`
		)
	end
end

return { collect = collect, match = match, settled = settled }
