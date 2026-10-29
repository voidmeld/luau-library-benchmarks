--!strict

local Types = require "./types"

local function collect(workload: Types.Workload, world: Types.World, lane: Types.Lane): { string }
	local scene = workload.prepare(world, lane)
	local snapshots: { string } = {}
	local ok, problem = pcall(function()
		for _ = 1, 30 do
			world.frame()
		end
		table.insert(snapshots, scene.snapshot())
		for index = 1, workload.iterations do
			scene.step(index)
			table.insert(snapshots, scene.snapshot())
		end
	end)
	scene.stop()
	world.frame()
	world.dispose()
	assert(ok, tostring(problem))
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

return { collect = collect, match = match }
