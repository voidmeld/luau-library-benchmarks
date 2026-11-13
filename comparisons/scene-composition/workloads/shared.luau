--!strict

local Environment = require "../cost-model"

export type Row = { id: number }
export type Labels = {
	frame: Environment.Instance,
	byId: { [number]: Environment.Instance },
	positions: { [number]: number },
	shown: { Row },
}

local KEYED_ROWS = 300
local BADGES = 40
local ANIMATED = 200
local ANIMATE_TARGET = 100
local ANIMATE_FRAMES = 30
local ANIMATE_CHECK = 5

local function rows(count: number, offset: number): { Row }
	local createList: (number, Row?) -> { Row } = table.create
	local list: { Row } = createList(count)
	for index = 1, count do
		list[index] = { id = offset + index }
	end
	return list
end

local function keyedLists(id: string): ({ Row }, { Row })
	local initial = rows(KEYED_ROWS, 0)
	local changed = table.clone(initial)
	if id == "keyed-shuffle" then
		local seed = 12345
		for index = #changed, 2, -1 do
			seed = (seed * 1103515245 + 12345) % 2147483648
			local pick = (seed % index) + 1
			changed[index], changed[pick] = changed[pick], changed[index]
		end
	elseif id == "keyed-prepend" then
		for index, row in rows(10, KEYED_ROWS + 100) do
			table.insert(changed, index, row)
		end
	elseif id == "keyed-insert" then
		local middle = KEYED_ROWS // 2
		for index, row in rows(10, KEYED_ROWS + 200) do
			table.insert(changed, middle + index, row)
		end
	else
		error("keyed workload has no input lists: " .. id, 0)
	end
	return initial, changed
end

local function badgeLists(): { { Row } }
	local pool = rows(BADGES, 0)
	local lists: { { Row } } = { {} }
	for count = 1, BADGES do
		local list = rows(0, 0)
		table.move(pool, 1, count, 1, list)
		lists[count + 1] = list
	end
	return lists
end

local function badgesAt(lists: { { Row } }, tick: number): { Row }
	return lists[(tick % BADGES) + 2]
end

local function labels(frame: Environment.Instance): Labels
	return { frame = frame, byId = {}, positions = {}, shown = {} }
end

local function applyLabels(state: Labels, instances: Environment.InstanceFactory, list: { Row })
	local byId, positions = state.byId, state.positions
	local wanted: { [number]: boolean } = {}
	for _, row in list do
		wanted[row.id] = true
	end
	for _, row in state.shown do
		local id = row.id
		if not wanted[id] then
			byId[id]:Destroy()
			byId[id] = nil
			positions[id] = nil
		end
	end
	for index, row in list do
		local id = row.id
		local node = byId[id]
		if node == nil then
			node = instances.new "TextLabel"
			node.Text = tostring(id)
			node.LayoutOrder = index
			node.Parent = state.frame
			byId[id] = node
			positions[id] = index
		elseif positions[id] ~= index then
			node.LayoutOrder = index
			positions[id] = index
		end
	end
	state.shown = list
end

local function releaseLabels(state: Labels)
	for _, row in state.shown do
		state.byId[row.id]:Destroy()
	end
	table.clear(state.byId)
	table.clear(state.positions)
	state.shown = {}
	state.frame:Destroy()
end

local function checkMidway(environment: Environment.Environment, container: Environment.Instance)
	local nodes = environment.children(environment.children(container)[1])
	assert(#nodes == ANIMATED, "wrong number of animated nodes")
	for index, node in nodes do
		local order = environment.get(node, "LayoutOrder")
		assert(type(order) == "number", "animated node has no LayoutOrder")
		if order <= index or order >= index + ANIMATE_TARGET then
			error(
				("animated node %d is at %d after %d frames, not between %d and %d"):format(
					index,
					order,
					ANIMATE_CHECK,
					index,
					index + ANIMATE_TARGET
				),
				0
			)
		end
	end
end

return {
	ANIMATED = ANIMATED,
	ANIMATE_TARGET = ANIMATE_TARGET,
	ANIMATE_FRAMES = ANIMATE_FRAMES,
	ANIMATE_CHECK = ANIMATE_CHECK,
	BADGES = BADGES,
	KEYED_ROWS = KEYED_ROWS,
	keyedLists = keyedLists,
	badgeLists = badgeLists,
	badgesAt = badgesAt,
	labels = labels,
	applyLabels = applyLabels,
	releaseLabels = releaseLabels,
	checkMidway = checkMidway,
}
