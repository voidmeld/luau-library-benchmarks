--!strict

local Headless = require "./headless"
local Types = require "./types"

local LANES: { Types.Lane } = { "plain", "facet" }

local function difference(reference: string, snapshot: string): number
	local index = 1
	while index <= math.min(#reference, #snapshot) and reference:byte(index) == snapshot:byte(index) do
		index += 1
	end
	return index
end

return function(workload: Types.Workload): boolean
	local snapshots: { string } = {}
	for _, lane in LANES do
		assert(lane == "plain" or lane == "facet")
		local world = Headless.create()
		local before = world.census()
		local scene = workload.prepare(world, lane)
		for _ = 1, Headless.SETTLE_FRAMES do
			world.frame()
		end
		local ok, problem = pcall(function()
			for checkpoint = 0, workload.iterations do
				if checkpoint > 0 then
					scene.step(checkpoint)
				end
				local snapshot = scene.snapshot()
				if lane == "plain" then
					snapshots[checkpoint + 1] = snapshot
				else
					local reference = snapshots[checkpoint + 1]
					local at = difference(reference, snapshot)
					assert(
						snapshot == reference,
						("%s differs at checkpoint %d, byte %d\nPLAIN: %s\nFACET: %s"):format(
							workload.id,
							checkpoint,
							at,
							reference:sub(at, at + 300),
							snapshot:sub(at, at + 300)
						)
					)
				end
			end
		end)
		scene.stop()
		local after = world.census()
		world.dispose()
		assert(
			after.live == before.live,
			("%s left %d instances in the %s lane"):format(workload.id, after.live - before.live, lane)
		)
		assert(
			after.connections == before.connections,
			("%s left %d connections in the %s lane"):format(workload.id, after.connections - before.connections, lane)
		)
		assert(ok, tostring(problem))
	end
	return true
end
