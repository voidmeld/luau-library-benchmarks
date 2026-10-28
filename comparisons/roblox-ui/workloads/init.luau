--!strict

local Types = require "@self/types"
local mount = require "@self/mount"
local scenes = require "@self/scenes"
local structure = require "@self/structure"
local world = require "@self/world"
local update = require "@self/update"

export type Context = Types.Context
export type Case = Types.Case
export type Workload = Types.Workload

local all: { Workload } = {}

local function include(workloads: { Workload })
	for _, workload in workloads do
		table.insert(all, workload)
	end
end

include(mount)
include(update)
include(structure)
include(scenes)
include(world)

return {
	all = all,
}
