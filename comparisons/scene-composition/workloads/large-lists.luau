--!strict

local Types = require "./types"
local Lane = require "../lanes/types"
local Plain = require "../lanes/plain-rows"
local Environment = require "../cost-model"

type Factory = (Environment.Environment) -> Lane.Driver
type RowNodes = { frame: Environment.Instance, children: { Environment.Instance } }

local descriptions = {
	{ "library-load", "Initialize the UI library for a game screen", "Initialize the UI library for a game screen." },
	{ "rows-append-1000", "Load another page of server entries", "Load another page of server entries." },
	{ "rows-clear", "Clear the chat log at round end", "Clear the chat log at round end." },
	{ "rows-create-1000", "Open a 1,000-player leaderboard", "Open a 1,000-player leaderboard." },
	{ "rows-create-10000", "Open a 10,000-row item catalog", "Open a 10,000-row item catalog." },
	{ "rows-remove-one", "Remove one inventory item", "Remove one inventory item." },
	{ "rows-swap", "Exchange two inventory positions", "Exchange two inventory positions." },
	{ "rows-update-every-10th", "Update every tenth leaderboard entry", "Update every tenth leaderboard entry." },
}

local adjectives = { "ancient", "swift", "sturdy", "rare", "enchanted", "frozen", "bright", "wild" }
local colors = { "red", "blue", "green", "gold", "silver", "purple", "white" }
local nouns = { "sword", "shield", "potion", "gem", "helmet", "bow", "staff", "boots", "ring" }

local function label(id: number): string
	return adjectives[(id * 17 % #adjectives) + 1]
		.. " "
		.. colors[(id * 7 % #colors) + 1]
		.. " "
		.. nouns[(id * 11 % #nouns) + 1]
end

local function nodes(context: Types.Context): { [number]: RowNodes }
	local result: { [number]: RowNodes } = {}
	local root = context.env.children(context.container)[1]
	if root == nil then
		return result
	end
	for _, frame in context.env.children(root) do
		assert(frame.ClassName == "Frame", "row must be a Frame")
		local children = context.env.children(frame)
		table.sort(children, function(left: Environment.Instance, right: Environment.Instance): boolean
			return (context.env.get(left, "LayoutOrder") :: number) < (context.env.get(right, "LayoutOrder") :: number)
		end)
		assert(#children == 4, "row must have id, label, select and remove children")
		for index, child in children do
			assert(context.env.get(child, "LayoutOrder") == index, "wrong row child position")
			assert(child.ClassName == (if index <= 2 then "TextLabel" else "TextButton"), "wrong row child class")
		end
		assert(context.env.get(children[3], "Text") == "select", "missing select action")
		assert(context.env.get(children[4], "Text") == "remove", "missing remove action")
		local id = assert(tonumber(tostring(context.env.get(children[1], "Text"))))
		assert(result[id] == nil, "duplicate row id")
		result[id] = { frame = frame, children = children }
	end
	return result
end

local function caseFor(id: string, factory: Factory): Types.Case
	return {
		prepare = function(context: Types.Context): Types.State
			local environment = context.env
			local dispose: () -> () = function() end
			if id == "library-load" then
				local state: Types.State
				state = {
					moduleInstances = 0,
					moduleConnections = 0,
					run = function()
						local instances, connections = environment.liveInstances(), environment.liveConnections()
						local driver = factory(environment)
						state.moduleInstances = environment.liveInstances() - instances
						state.moduleConnections = environment.liveConnections() - connections
						dispose = driver.mount(context.container, function(scope: Lane.Scope): unknown
							return scope.node("Frame", {})
						end)
					end,
					snapshot = function(): string
						return environment.snapshot(context.container)
					end,
					release = function()
						dispose()
					end,
				} :: Types.State
				return state
			end
			local driver = factory(environment)
			local run: () -> () = function() end
			local expected: { Lane.ModelRow } = {}
			local expectedLabels: { [number]: string } = {}
			local ran = false
			dispose = driver.mount(context.container, function(scope: Lane.Scope): unknown
				local list = scope.value({} :: { Lane.ModelRow })
				local selected: Lane.ModelRow? = nil
				local function makeRows(count: number, offset: number): { Lane.ModelRow }
					local rows: { Lane.ModelRow } = {}
					for index = 1, count do
						local key = offset + index
						local rowState = assert(scope.rowState)(label(key))
						local row: Lane.ModelRow = {
							id = key,
							label = rowState.label,
							selected = rowState.selected,
							highlight = rowState.highlight,
							select = function() end,
							remove = function() end,
						}
						row.select = function()
							if selected == row then
								return
							end
							if selected then
								selected.selected.write(false)
							end
							row.selected.write(true)
							selected = row
						end
						row.remove = function()
							local nextRows = table.clone(list.read())
							for position, current in nextRows do
								if current.id == key then
									table.remove(nextRows, position)
									break
								end
							end
							list.write(nextRows)
						end
						rows[index] = row
						expectedLabels[key] = label(key)
					end
					return rows
				end
				local empty = id == "rows-create-1000" or id == "rows-create-10000"
				local createCount = if id == "rows-create-10000" then 10000 else 1000
				local initial = makeRows(if empty then 0 else 1000, 0)
				expected = initial
				list.write(initial)
				run = function()
					ran = true
					driver.batch(function()
						if empty then
							expected = makeRows(createCount, if empty then 0 else 1000)
							list.write(expected)
						elseif id == "rows-update-every-10th" then
							for index = 1, 1000, 10 do
								local row = initial[index]
								expectedLabels[row.id] = label(row.id) .. " · new best"
								row.label.write(expectedLabels[row.id])
							end
						elseif id == "rows-swap" then
							expected = table.clone(initial)
							expected[2], expected[999] = expected[999], expected[2]
							list.write(expected)
						elseif id == "rows-remove-one" then
							initial[500].remove()
							expected = table.clone(initial)
							table.remove(expected, 500)
						elseif id == "rows-append-1000" then
							expected = table.clone(initial)
							for _, row in makeRows(1000, 1000) do
								table.insert(expected, row)
							end
							list.write(expected)
						elseif id == "rows-clear" then
							expected = {}
							list.write(expected)
						end
					end)
				end
				return scope.node("Frame", {}, { assert(scope.rows)(list) })
			end)
			environment.drain()
			local before: { [number]: RowNodes } = if context.observe then nodes(context) else {}
			local retained: { [Environment.Instance]: boolean } = {}
			local allowed: { [Environment.Instance]: string } = {}
			for key, row in before do
				retained[row.frame] = true
				for _, child in row.children do
					retained[child] = true
				end
				if id == "rows-update-every-10th" and (key - 1) % 10 == 0 then
					allowed[row.children[2]] = "Text"
				elseif (id == "rows-swap" and (key == 2 or key == 999)) or (id == "rows-remove-one" and key > 500) then
					allowed[row.frame] = "LayoutOrder"
				end
			end
			local writes: { [Environment.Instance]: number } = {}
			local violations: { string } = {}
			local watch = environment.watchWrites
			if context.observe and watch then
				watch(function(instance: Environment.Instance, property: string)
					if retained[instance] then
						if allowed[instance] ~= property then
							table.insert(violations, "wrote an unchanged row property: " .. property)
						end
						writes[instance] = (writes[instance] or 0) + 1
					end
				end)
			end
			return {
				run = run,
				checkWork = function(counters: Environment.Counters)
					local created = if id == "rows-create-10000"
						then 50000
						elseif id == "rows-create-1000" or id == "rows-append-1000" then 5000
						else 0
					local destroyed = if id == "rows-clear" then 5000 elseif id == "rows-remove-one" then 5 else 0
					assert(counters.instancesCreated == created, "wrong number of created Instances")
					assert(counters.instancesDestroyed == destroyed, "wrong number of destroyed Instances")
					local changed = if id == "rows-update-every-10th"
						then 100
						elseif id == "rows-swap" then 2
						elseif id == "rows-remove-one" then 500
						else 0
					if created == 0 then
						assert(counters.propertyWrites == changed, "wrong number of property writes")
					end
				end,
				snapshot = function(): string
					assert(#violations == 0, violations[1])
					local current = nodes(context)
					local count = 0
					for _ in current do
						count += 1
					end
					assert(count == #expected, "wrong row count")
					for position, row in expected do
						local actual = assert(current[row.id], "missing row id")
						assert(environment.get(actual.frame, "LayoutOrder") == position, "wrong row position")
						assert(environment.get(actual.frame, "BackgroundTransparency") == 1, "wrong row selection")
						assert(environment.get(actual.children[2], "Text") == expectedLabels[row.id], "wrong row label")
						local previous = before[row.id]
						if previous then
							assert(previous.frame == actual.frame, "replaced a retained row")
							for index, child in actual.children do
								assert(previous.children[index] == child, "replaced a retained row child")
							end
						end
					end
					if ran and context.observe and watch then
						for instance in allowed do
							assert(writes[instance] == 1, "changed property must be written exactly once")
						end
					end
					return environment.snapshot(
						context.container,
						{ "Text", "LayoutOrder", "BackgroundTransparency" },
						"LayoutOrder"
					)
				end,
				release = function()
					if watch then
						watch(nil)
					end
					dispose()
				end,
			}
		end,
		run = function(state: Types.State)
			state.run()
		end,
		snapshot = function(state: Types.State): string
			return state.snapshot()
		end,
		release = function(state: Types.State)
			state.release()
		end,
	}
end

local all: { Types.Workload } = {}
for _, description in descriptions do
	table.insert(all, {
		id = description[1],
		title = description[2],
		what = description[3],
		samples = if description[1] == "rows-create-10000" then 5 else 25,
		iterations = 1,
		warmup = if description[1] == "rows-create-10000" then 1 else 5,
		cases = { plain = caseFor(description[1], Plain.create) },
		unsupported = {},
	})
end

return { all = all, caseFor = caseFor }
