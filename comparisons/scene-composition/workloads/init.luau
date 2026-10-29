--!strict

local Types = require "@self/types"
local scenes = require "@self/scenes"
local structure = require "@self/structure"
local world = require "@self/world"
local update = require "@self/update"
local gameUI = require "@self/game-ui"
local lists = require "@self/large-lists"

export type Context = Types.Context
export type Case = Types.Case
export type Workload = Types.Workload

local all: { Workload } = {}

local function include(workloads: { Workload })
	for _, workload in workloads do
		table.insert(all, workload)
	end
end

include(update)
include(structure)
include(scenes)
include(world)
include(gameUI.all)
include(lists.all)

return {
	all = all,
}
