--!strict
--!native

local Environment = require "../cost-model"
local Types = require "./types"
local Lane = require "../lanes/types"

type Factory = (Environment.Environment) -> Lane.Driver

local ids = {
	"derived-diamond",
	"derived-chain-100",
	"derived-fan-in-1000",
	"filter-as-you-type",
	"theme-propagation",
	"hud-per-frame",
	"teardown-under-load",
	"open-close-retention",
	"tree-expand-collapse",
	"form-validation",
	"table-sort-filter",
}

local HUD_FRAMES = 60
local HUD_READOUTS = 20
local RETENTION_CYCLES = 10
local FORM_FIELDS = 20
local FORM_SUMMARY = 2 * FORM_FIELDS + 1
local THEME_CONSUMERS = 1000
local FIRST_THEME = "light"
local CHAIN_LENGTH = 100
local FAN_IN = 1000

local appIds = { "tree-expand-collapse", "form-validation", "table-sort-filter" }

local prefixes = { "crystal1", "crystal2", "crystar1", "crylon12", "creature", "copper12", "bronze12", "silver12" }
local records: { { row: Lane.Row, name: string } } = {}
for index = 1, 500 do
	records[index] =
		{ row = { id = index }, name = prefixes[(index - 1) % #prefixes + 1] .. string.format("%03d", index) }
end

local function filtered(query: string): { Lane.Row }
	local found: { { row: Lane.Row, name: string } } = {}
	for _, record in records do
		if string.find(record.name, query, 1, true) then
			table.insert(found, record)
		end
	end
	table.sort(found, function(left: { row: Lane.Row, name: string }, right: { row: Lane.Row, name: string })
		return left.name < right.name
	end)
	local rows: { Lane.Row } = {}
	for index, record in found do
		rows[index] = record.row
	end
	return rows
end

local queries: { string } = {}
for index = 1, 8 do
	queries[index] = string.sub("crystal1", 1, index)
end
queries[9] = ""

local treeRows: { [number]: Lane.Row } = {}
for id = 1, 3000 do
	treeRows[id] = { id = id }
end

local function visibleTree(expanded: { [number]: boolean }): { Lane.Row }
	local rows: { Lane.Row } = {}
	for root = 1, 10 do
		table.insert(rows, treeRows[root])
		if expanded[root] then
			for child = 1, 10 do
				local childId = 100 + (root - 1) * 10 + child
				table.insert(rows, treeRows[childId])
				if expanded[childId] then
					for leaf = 1, 20 do
						table.insert(rows, treeRows[1000 + (childId - 101) * 20 + leaf])
					end
				end
			end
		end
	end
	return rows
end

local function expandedSet(roots: { number }, children: { number }): { [number]: boolean }
	local set: { [number]: boolean } = {}
	for _, root in roots do
		set[root] = true
	end
	for _, child in children do
		set[child] = true
	end
	return set
end

local function childrenOf(root: number): { number }
	local result: { number } = {}
	for child = 1, 10 do
		result[child] = 100 + (root - 1) * 10 + child
	end
	return result
end

local allOpen = table.clone(childrenOf(1))
table.move(childrenOf(2), 1, 10, 11, allOpen)

type Player = { row: Lane.Row, keys: { [string]: number } }
local players: { Player } = {}
local seed = 20261029
local function random(limit: number): number
	seed = (seed * 48271) % 2147483647
	return seed % limit + 1
end
local words = { "amber", "blaze", "cinder", "drift", "ember", "frost", "glint", "haze" }
local names: { { id: number, name: string } } = {}
for index = 1, 1000 do
	local keys = {
		level = random(100),
		score = random(100000),
		team = random(8),
		wins = random(500),
		losses = random(500),
		ping = random(300),
		id = index,
	}
	players[index] = { row = { id = index }, keys = keys }
	names[index] = { id = index, name = words[random(#words)] .. string.format("%04d", random(10000)) }
end
table.sort(names, function(left: { id: number, name: string }, right: { id: number, name: string })
	return if left.name == right.name then left.id < right.id else left.name < right.name
end)
for rank, entry in names do
	players[entry.id].keys.name = rank
end

type TableView = { column: string, descending: boolean, team: number?, minimumLevel: number? }

local function tableRows(view: TableView): { Lane.Row }
	local found: { Player } = {}
	for _, player in players do
		if (view.team == nil or player.keys.team == view.team) and player.keys.level >= (view.minimumLevel or 0) then
			table.insert(found, player)
		end
	end
	local column, descending = view.column, view.descending
	table.sort(found, function(left: Player, right: Player)
		local a, b = left.keys[column], right.keys[column]
		if a == b then
			return left.keys.id < right.keys.id
		end
		return if descending then a > b else a < b
	end)
	local rows: { Lane.Row } = {}
	for index, player in found do
		rows[index] = player.row
	end
	return rows
end

type ListOf<T> = { initial: T, inputs: { T }, expected: { { Lane.Row } }, view: (T) -> { Lane.Row } }
type ListTask = { open: (<T>(ListOf<T>) -> unknown) -> unknown }

local function listTask<T>(initial: T, inputs: { T }, view: (T) -> { Lane.Row }): ListTask
	local expected: { { Lane.Row } } = {}
	for index, input in inputs do
		expected[index] = view(input)
	end
	local typed: ListOf<T> = { initial = initial, inputs = inputs, expected = expected, view = view }
	return {
		open = function(visit: <U>(ListOf<U>) -> unknown): unknown
			return visit(typed)
		end,
	}
end

local collapsed: { [number]: boolean } = {}
local tableViews: { TableView } = {
	{ column = "score", descending = true },
	{ column = "level", descending = false },
	{ column = "level", descending = false, team = 3 },
	{ column = "wins", descending = true, team = 3, minimumLevel = 50 },
	{ column = "wins", descending = true, minimumLevel = 50 },
	{ column = "name", descending = false },
}

local listTasks: { [string]: ListTask } = {
	["filter-as-you-type"] = listTask("", queries, filtered),
	["tree-expand-collapse"] = listTask(collapsed, {
		expandedSet({ 1 }, {}),
		expandedSet({ 1 }, { 101 }),
		expandedSet({ 1 }, childrenOf(1)),
		expandedSet({ 1, 2 }, allOpen),
		expandedSet({ 2 }, allOpen),
		expandedSet({ 1, 2 }, allOpen),
		expandedSet({}, {}),
	}, visibleTree),
	["table-sort-filter"] = listTask({ column = "name", descending = false }, tableViews, tableRows),
}

local function fieldProblem(index: number, text: string): string
	if text == "" then
		return "required"
	end
	local kind = index % 3
	if kind == 1 then
		return if tonumber(text) == nil then "number" else ""
	elseif kind == 2 then
		return if #text == 6 then "" else "6 characters"
	end
	return ""
end

local formEdits: { { field: number, text: string } } = {}
for index = 1, FORM_FIELDS do
	local kind = index % 3
	table.insert(formEdits, {
		field = index,
		text = if kind == 1
			then tostring(index * 7)
			elseif kind == 2 then string.format("C%05d", index)
			else "Player" .. tostring(index),
	})
end
for index = 5, FORM_FIELDS, 5 do
	table.insert(
		formEdits,
		{ field = index, text = if index % 3 == 1 then "x" .. tostring(index) elseif index % 3 == 2 then "C1" else "" }
	)
end
for index = 1, FORM_FIELDS do
	table.insert(formEdits, { field = index, text = "" })
end

local function formSummary(problems: number): string
	return if problems == 0 then "ready" else tostring(problems) .. " to fix"
end

local joins = 0
local function joined(left: number, right: number): number
	joins += 1
	assert(left / 2 + 10 == right, "The diamond joined inconsistent source versions")
	return left + right
end

local function layoutOrder(environment: Environment.Environment, label: Environment.Instance): number
	local order = environment.get(label, "LayoutOrder")
	assert(type(order) == "number", "LayoutOrder must be a number")
	return order
end

local function labels(environment: Environment.Environment, container: Environment.Instance): { Environment.Instance }
	local result: { Environment.Instance } = {}
	local function visit(node: Environment.Instance)
		for _, child in environment.children(node) do
			if child.ClassName == "TextLabel" then
				table.insert(result, child)
			end
			visit(child)
		end
	end
	visit(container)
	return result
end

type Harness = {
	environment: Environment.Environment,
	container: Environment.Instance,
	checking: boolean,
	observe: () -> (),
	collect: (() -> ())?,
	tick: number,
}

type Built = { run: () -> (), release: () -> () }

type Pages = {
	open: (Environment.Instance, number, number) -> () -> (),
	pulse: (number) -> (),
	release: () -> (),
}

local function stateCase(open: (Harness) -> Built): Types.Case
	return Types.stateful(function(context: Types.Context): Types.State
		local environment = context.env
		local keys = { "Text", "LayoutOrder" }
		local function snapshot(): string
			return environment.snapshot(context.container, keys, "LayoutOrder")
		end
		local built = open {
			environment = environment,
			container = context.container,
			checking = context.observe ~= nil,
			observe = function()
				local observe = context.observe
				if observe then
					observe(snapshot())
				end
			end,
			collect = context.collect,
			tick = 0,
		}
		environment.drain()
		return { run = built.run, snapshot = snapshot, release = built.release }
	end)
end

local function derivedRun(harness: Harness, id: string, set: (number) -> ()): () -> ()
	local environment = harness.environment
	return function()
		harness.tick += 1
		local tick = harness.tick
		local before = joins
		local writes = if harness.checking then environment.counters().propertyWrites else 0
		set(tick + 1)
		if harness.checking then
			local current = labels(environment, harness.container)
			local expected = if id == "derived-diamond"
				then 3 * (tick + 1) + 10
				elseif id == "derived-chain-100" then tick + 101
				else 500500 + tick
			assert(
				#current == 1 and environment.get(current[1], "Text") == tostring(expected),
				"The derived output is wrong"
			)
			assert(
				environment.counters().propertyWrites - writes == 1,
				"The derived update must commit one property write"
			)
			assert(id ~= "derived-diamond" or joins - before == 1, "The diamond join must recompute once")
		end
		harness.observe()
	end
end

local function listRun<T>(harness: Harness, listed: ListOf<T>, set: (T) -> ()): () -> ()
	local environment = harness.environment
	return function()
		local previous: { [string]: Environment.Instance } = {}
		local positions: { [string]: unknown } = {}
		if harness.checking then
			for _, label in labels(environment, harness.container) do
				local key = tostring(environment.get(label, "Text"))
				previous[key] = label
				positions[key] = environment.get(label, "LayoutOrder")
			end
		end
		for index, input in listed.inputs do
			local before = if harness.checking then environment.counters() else nil
			set(input)
			if before then
				local current = labels(environment, harness.container)
				table.sort(current, function(left, right)
					return layoutOrder(environment, left) < layoutOrder(environment, right)
				end)
				local expectedRows = listed.expected[index]
				assert(#current == #expectedRows, "The filtered list has the wrong length")
				local retained: { [string]: Environment.Instance } = {}
				local nextPositions: { [string]: unknown } = {}
				local added, removed, requiredWrites = 0, 0, 0
				for position, label in current do
					local key = tostring(environment.get(label, "Text"))
					assert(
						key == tostring(expectedRows[position].id),
						"The filtered list has the wrong order or values"
					)
					assert(
						environment.get(label, "LayoutOrder") == position,
						"The filtered list has the wrong position"
					)
					assert(previous[key] == nil or previous[key] == label, "A filtered row lost its Instance identity")
					retained[key] = label
					nextPositions[key] = position
					if previous[key] == nil then
						added += 1
						requiredWrites += 2
					elseif positions[key] ~= position then
						requiredWrites += 1
					end
				end
				for key in previous do
					if retained[key] == nil then
						removed += 1
					end
				end
				local after = environment.counters()
				assert(
					after.instancesCreated - before.instancesCreated == added,
					"The search created unnecessary nodes"
				)
				assert(
					after.instancesDestroyed - before.instancesDestroyed == removed,
					"The search did not release removed nodes"
				)
				assert(
					after.propertyWrites - before.propertyWrites >= requiredWrites,
					"The search did not perform the required text and position writes"
				)
				previous = retained
				positions = nextPositions
			end
			harness.observe()
		end
	end
end

local function formRun(harness: Harness, set: (number, string) -> ()): () -> ()
	local environment = harness.environment
	local values: { string } = table.create(FORM_FIELDS, "")
	return function()
		for _, edit in formEdits do
			local previousProblem, previousCount = "", 0
			local before: Environment.Counters? = nil
			if harness.checking then
				previousProblem = fieldProblem(edit.field, values[edit.field])
				for index, text in values do
					if fieldProblem(index, text) ~= "" then
						previousCount += 1
					end
				end
				before = environment.counters()
			end
			set(edit.field, edit.text)
			if before then
				local changed = values[edit.field] ~= edit.text
				values[edit.field] = edit.text
				local count = 0
				for index, text in values do
					if fieldProblem(index, text) ~= "" then
						count += 1
					end
				end
				local current = labels(environment, harness.container)
				assert(#current == FORM_SUMMARY, "The form must keep every field and summary label")
				for _, label in current do
					local order = layoutOrder(environment, label)
					local field = (order + 1) // 2
					local expected = if order == FORM_SUMMARY
						then formSummary(count)
						elseif order % 2 == 1 then values[field]
						else fieldProblem(field, values[field])
					assert(environment.get(label, "Text") == expected, "A form label is stale")
				end
				local required = (if changed then 1 else 0)
					+ (if fieldProblem(edit.field, edit.text) ~= previousProblem then 1 else 0)
					+ (if count ~= previousCount then 1 else 0)
				local after = environment.counters()
				assert(
					after.instancesCreated == before.instancesCreated
						and after.instancesDestroyed == before.instancesDestroyed,
					"A form edit must not create or destroy nodes"
				)
				assert(
					after.propertyWrites - before.propertyWrites >= required,
					"A form edit did not perform the required text writes"
				)
			end
			harness.observe()
		end
	end
end

local function themeRun(harness: Harness, set: (string) -> ()): () -> ()
	local environment = harness.environment
	return function()
		harness.tick += 1
		local nextTheme = if harness.tick % 2 == 1 then "dark" else FIRST_THEME
		local writes = if harness.checking then environment.counters().propertyWrites else 0
		set(nextTheme)
		if harness.checking then
			local current = labels(environment, harness.container)
			assert(#current == THEME_CONSUMERS, "The theme must reach 1,000 nodes")
			for _, label in current do
				assert(environment.get(label, "Text") == nextTheme, "A theme consumer is stale")
			end
			assert(
				environment.counters().propertyWrites - writes == THEME_CONSUMERS,
				"The theme swap must write each consumer once"
			)
		end
		harness.observe()
	end
end

local function hudRun(harness: Harness, set: (number) -> ()): () -> ()
	local environment = harness.environment
	return function()
		for _ = 1, HUD_FRAMES do
			harness.tick += 1
			local tick = harness.tick
			local writes = if harness.checking then environment.counters().propertyWrites else 0
			set(tick)
			environment.step(1 / 60)
			if harness.checking then
				local current = labels(environment, harness.container)
				assert(#current == HUD_READOUTS, "The HUD must keep 20 readouts")
				for _, label in current do
					local index = layoutOrder(environment, label)
					assert(
						environment.get(label, "Text") == tostring(tick * HUD_READOUTS + index),
						"A HUD readout is stale"
					)
				end
				assert(
					environment.counters().propertyWrites - writes == HUD_READOUTS,
					"Each HUD frame must write 20 readouts"
				)
			end
			harness.observe()
		end
	end
end

local function pageCase(harness: Harness, id: string, pages: Pages): Built
	local environment = harness.environment
	local checking = harness.checking
	environment.drain()
	local pageHost = environment.globals.Instance.new "Frame"
	pageHost.Parent = harness.container
	pageHost.LayoutOrder = 1
	local baselineInstances = environment.liveInstances()
	local baselineConnections = environment.liveConnections()
	local count = if id == "open-close-retention" then 500 else 2000
	local tick = 0
	local pulsing = false
	local pulse = environment.heartbeat:Connect(function()
		if pulsing then
			return
		end
		pulsing = true
		tick += 1
		pages.pulse(tick)
		pulsing = false
	end)
	return {
		run = function()
			local released: { [number]: Environment.Instance } = {}
			setmetatable(released, { __mode = "v" })
			local releasedCount = 0
			for _ = 1, if id == "open-close-retention" then RETENTION_CYCLES else 1 do
				local close = pages.open(pageHost, count, tick)
				environment.drain()
				for _ = 1, 3 do
					local writes = if checking then environment.counters().propertyWrites else 0
					environment.step(1 / 60)
					if checking then
						local current = labels(environment, harness.container)
						assert(#current == count, "The live page has the wrong node count")
						assert(
							environment.counters().propertyWrites - writes == count,
							"A source pulse must write each live node once"
						)
						for _, label in current do
							assert(environment.get(label, "LayoutOrder") == tick, "A live page missed a source pulse")
						end
					end
				end
				harness.observe()
				if checking then
					for _, label in pageHost:GetDescendants() do
						releasedCount += 1
						released[releasedCount] = label
					end
				end
				close()
				environment.drain()
				local writes = if checking then environment.counters().propertyWrites else 0
				for _ = 1, 3 do
					environment.step(1 / 60)
				end
				if checking then
					assert(environment.counters().propertyWrites == writes, "A released page received a property write")
					assert(environment.liveInstances() == baselineInstances, "A closed page retained nodes")
					assert(
						environment.liveConnections() == baselineConnections + 1,
						"A closed page retained connections"
					)
				end
				harness.observe()
			end
			if checking then
				assert(harness.collect, "Retention parity needs a collection callback")()
				assert(next(released) == nil, "A closed page retained a released node in Luau memory")
			end
		end,
		release = function()
			pulse:Disconnect()
			pages.release()
			pageHost:Destroy()
		end,
	}
end

local function page(scope: Lane.Scope, count: number, property: string, binding: unknown): unknown
	local children: { unknown } = {}
	for index = 1, count do
		children[index] = scope.node("TextLabel", { Text = "", [property] = binding })
	end
	return scope.node("Frame", {}, children)
end

local function libraryPages(harness: Harness, id: string, driver: Lane.Driver): Built
	local source: Lane.Source<number>
	local owner = driver.mount(harness.container, function(scope)
		source = scope.value(0)
		return scope.node("Frame", { LayoutOrder = -1 })
	end)
	return pageCase(harness, id, {
		open = function(host: Environment.Instance, count: number): () -> ()
			return driver.mount(host, function(scope)
				local binding = if scope.computed
					then assert(scope.computed)(function(use)
						return use(source)
					end).binding
					else source.binding
				return page(scope, count, "LayoutOrder", binding)
			end)
		end,
		pulse = function(value: number)
			driver.batch(function()
				source.write(value)
			end)
		end,
		release = owner,
	})
end

local function libraryList<T>(
	harness: Harness,
	driver: Lane.Driver,
	scope: Lane.Scope,
	listed: ListOf<T>,
	wrapKeyed: boolean?
): (unknown, () -> ())
	local query = scope.value(listed.initial)
	local list = if scope.select
		then assert(scope.select)(query, listed.view)
		else assert(scope.computed)(function(use)
			return listed.view(use(query))
		end)
	local run = listRun(harness, listed, function(input: T)
		driver.batch(function()
			query.write(input)
		end)
	end)
	local content = scope.keyed(list)
	local node = if wrapKeyed then scope.node("Frame", {}, { content }) else content
	return node, run
end

local function libraryForm(harness: Harness, driver: Lane.Driver, scope: Lane.Scope): (unknown, () -> ())
	local computed = assert(scope.computed)
	local fields: { Lane.Source<string> } = {}
	local problems: { Lane.Source<string> } = {}
	local children: { unknown } = {}
	for index = 1, FORM_FIELDS do
		local field = scope.value ""
		local problem = computed(function(use)
			return fieldProblem(index, use(field))
		end)
		fields[index], problems[index] = field, problem
		children[2 * index - 1] = scope.node("TextLabel", {
			Text = field.bind(function(text)
				return text
			end),
			LayoutOrder = 2 * index - 1,
		})
		children[2 * index] = scope.node("TextLabel", {
			Text = problem.bind(function(text)
				return text
			end),
			LayoutOrder = 2 * index,
		})
	end
	local summary = computed(function(use)
		local count = 0
		for _, problem in problems do
			if use(problem) ~= "" then
				count += 1
			end
		end
		return count
	end)
	children[FORM_SUMMARY] = scope.node("TextLabel", {
		Text = summary.bind(formSummary),
		LayoutOrder = FORM_SUMMARY,
	})
	local run = formRun(harness, function(field: number, text: string)
		driver.batch(function()
			fields[field].write(text)
		end)
	end)
	return scope.node("Frame", {}, children), run
end

local function libraryTheme(harness: Harness, driver: Lane.Driver, scope: Lane.Scope): (unknown, () -> ())
	local theme = scope.value(FIRST_THEME)
	local run = themeRun(harness, function(nextTheme: string)
		driver.batch(function()
			theme.write(nextTheme)
		end)
	end)
	local function build(): unknown
		local children: { unknown } = {}
		for index = 1, THEME_CONSUMERS do
			children[index] = if scope.themeNode
				then assert(scope.themeNode)()
				else scope.node(
					"TextLabel",
					{ Text = if scope.themeText then assert(scope.themeText)() else theme.binding }
				)
		end
		return scope.node("Frame", {}, children)
	end
	local node = if scope.provideTheme then scope.provideTheme(theme, build) else build()
	return node, run
end

local function libraryHud(harness: Harness, driver: Lane.Driver, scope: Lane.Scope): (unknown, () -> ())
	local sources: { Lane.Source<number> } = {}
	local children: { unknown } = {}
	for index = 1, HUD_READOUTS do
		local source = scope.value(0)
		sources[index] = source
		children[index] = scope.node("TextLabel", {
			Text = source.bind(function(value)
				return tostring(value)
			end),
			LayoutOrder = index,
		})
	end
	local run = hudRun(harness, function(tick: number)
		driver.batch(function()
			for index, source in sources do
				source.write(tick * HUD_READOUTS + index)
			end
		end)
	end)
	return scope.node("Frame", {}, children), run
end

local function libraryDerived(harness: Harness, driver: Lane.Driver, scope: Lane.Scope, id: string): (unknown, () -> ())
	local computed = assert(scope.computed)
	local head = scope.value(1)
	local result: Lane.Source<number>
	if id == "derived-diamond" then
		local left = computed(function(use)
			return use(head) * 2
		end)
		local right = computed(function(use)
			return use(head) + 10
		end)
		result = (scope.coherentComputed or computed)(function(use)
			return joined(use(left), use(right))
		end)
	elseif id == "derived-chain-100" then
		result = head
		for _ = 1, CHAIN_LENGTH do
			local previous = result
			result = computed(function(use)
				return use(previous) + 1
			end)
		end
	else
		local sources = { head }
		for index = 2, FAN_IN do
			sources[index] = scope.value(index)
		end
		result = computed(function(use)
			local total = 0
			for _, source in sources do
				total += use(source)
			end
			return total
		end)
	end
	local run = derivedRun(harness, id, function(value: number)
		driver.batch(function()
			head.write(value)
		end)
	end)
	local text = result.bind(function(value)
		return tostring(value)
	end)
	return page(scope, 1, "Text", text), run
end

local function caseFor(id: string, factory: Factory, wrapKeyed: boolean?): Types.Case
	return stateCase(function(harness: Harness): Built
		local driver = factory(harness.environment)
		if id == "teardown-under-load" or id == "open-close-retention" then
			return libraryPages(harness, id, driver)
		end
		local run: () -> () = function() end
		local release = driver.mount(harness.container, function(scope)
			local node: unknown
			local task = listTasks[id]
			if task then
				node = task.open(function<T>(listed: ListOf<T>): unknown
					local content: unknown
					content, run = libraryList(harness, driver, scope, listed, wrapKeyed)
					return content
				end)
			elseif id == "form-validation" then
				node, run = libraryForm(harness, driver, scope)
			elseif id == "theme-propagation" then
				node, run = libraryTheme(harness, driver, scope)
			elseif id == "hud-per-frame" then
				node, run = libraryHud(harness, driver, scope)
			else
				node, run = libraryDerived(harness, driver, scope, id)
			end
			return node
		end)
		return {
			run = function()
				run()
			end,
			release = release,
		}
	end)
end

local function plainPages(harness: Harness, id: string): Built
	local Instance = harness.environment.globals.Instance
	local owner = Instance.new "Frame"
	owner.LayoutOrder = -1
	owner.Parent = harness.container
	local frame: Environment.Instance? = nil
	local nodes: { Environment.Instance }? = nil
	local function close()
		assert(frame):Destroy()
		frame, nodes = nil, nil
	end
	return pageCase(harness, id, {
		open = function(host: Environment.Instance, count: number, value: number): () -> ()
			local opened = Instance.new "Frame"
			local made: { Environment.Instance } = {}
			for index = 1, count do
				local label = Instance.new "TextLabel"
				label.Text = ""
				label.LayoutOrder = value
				label.Parent = opened
				made[index] = label
			end
			opened.Parent = host
			frame, nodes = opened, made
			return close
		end,
		pulse = function(value: number)
			local live = nodes
			if live then
				for _, label in live do
					label.LayoutOrder = value
				end
			end
		end,
		release = function()
			owner:Destroy()
		end,
	})
end

local function plainList<T>(harness: Harness, listed: ListOf<T>): Built
	local Instance = harness.environment.globals.Instance
	local frame = Instance.new "Frame"
	local byId: { [number]: Environment.Instance } = {}
	local orderOf: { [number]: number } = {}
	local wanted: { [number]: boolean } = {}
	local function show(rows: { Lane.Row })
		for index, row in rows do
			local id = row.id
			wanted[id] = true
			local label = byId[id]
			if label == nil then
				local created = Instance.new "TextLabel"
				created.Text = tostring(id)
				created.LayoutOrder = index
				created.Parent = frame
				byId[id] = created
				orderOf[id] = index
			elseif orderOf[id] ~= index then
				label.LayoutOrder = index
				orderOf[id] = index
			end
		end
		for id, label in byId do
			if not wanted[id] then
				label:Destroy()
				byId[id] = nil
				orderOf[id] = nil
			end
		end
		table.clear(wanted)
	end
	show(listed.view(listed.initial))
	frame.Parent = harness.container
	return {
		run = listRun(harness, listed, function(input: T)
			show(listed.view(input))
		end),
		release = function()
			frame:Destroy()
			table.clear(byId)
			table.clear(orderOf)
		end,
	}
end

local function plainForm(harness: Harness): Built
	local Instance = harness.environment.globals.Instance
	local frame = Instance.new "Frame"
	local texts: { string } = table.create(FORM_FIELDS, "")
	local problems: { string } = {}
	local fieldLabels: { Environment.Instance } = {}
	local problemLabels: { Environment.Instance } = {}
	local count = 0
	for index = 1, FORM_FIELDS do
		local problem = fieldProblem(index, "")
		problems[index] = problem
		if problem ~= "" then
			count += 1
		end
		local field = Instance.new "TextLabel"
		field.Text = ""
		field.LayoutOrder = 2 * index - 1
		field.Parent = frame
		local message = Instance.new "TextLabel"
		message.Text = problem
		message.LayoutOrder = 2 * index
		message.Parent = frame
		fieldLabels[index], problemLabels[index] = field, message
	end
	local summary = Instance.new "TextLabel"
	summary.Text = formSummary(count)
	summary.LayoutOrder = FORM_SUMMARY
	summary.Parent = frame
	frame.Parent = harness.container
	return {
		run = formRun(harness, function(index: number, text: string)
			if texts[index] == text then
				return
			end
			texts[index] = text
			fieldLabels[index].Text = text
			local previous = problems[index]
			local problem = fieldProblem(index, text)
			if problem == previous then
				return
			end
			problems[index] = problem
			problemLabels[index].Text = problem
			local nextCount = count + (if problem == "" then -1 elseif previous == "" then 1 else 0)
			if nextCount ~= count then
				count = nextCount
				summary.Text = formSummary(count)
			end
		end),
		release = function()
			frame:Destroy()
			table.clear(fieldLabels)
			table.clear(problemLabels)
		end,
	}
end

local function plainTheme(harness: Harness): Built
	local Instance = harness.environment.globals.Instance
	local frame = Instance.new "Frame"
	local consumers: { Environment.Instance } = {}
	for index = 1, THEME_CONSUMERS do
		local label = Instance.new "TextLabel"
		label.Text = FIRST_THEME
		label.Parent = frame
		consumers[index] = label
	end
	frame.Parent = harness.container
	local current = FIRST_THEME
	return {
		run = themeRun(harness, function(theme: string)
			if theme == current then
				return
			end
			current = theme
			for _, label in consumers do
				label.Text = theme
			end
		end),
		release = function()
			frame:Destroy()
			table.clear(consumers)
		end,
	}
end

local function plainHud(harness: Harness): Built
	local Instance = harness.environment.globals.Instance
	local frame = Instance.new "Frame"
	local readouts: { Environment.Instance } = {}
	local shown: { number } = table.create(HUD_READOUTS, 0)
	for index = 1, HUD_READOUTS do
		local label = Instance.new "TextLabel"
		label.Text = tostring(0)
		label.LayoutOrder = index
		label.Parent = frame
		readouts[index] = label
	end
	frame.Parent = harness.container
	return {
		run = hudRun(harness, function(tick: number)
			for index, label in readouts do
				local value = tick * HUD_READOUTS + index
				if value ~= shown[index] then
					shown[index] = value
					label.Text = tostring(value)
				end
			end
		end),
		release = function()
			frame:Destroy()
			table.clear(readouts)
		end,
	}
end

local function plainDerived(harness: Harness, id: string): Built
	local Instance = harness.environment.globals.Instance
	local derive: (number) -> number
	if id == "derived-diamond" then
		derive = function(head: number): number
			return joined(head * 2, head + 10)
		end
	elseif id == "derived-chain-100" then
		local steps: { (number) -> number } = {}
		for index = 1, CHAIN_LENGTH do
			steps[index] = function(value: number): number
				return value + 1
			end
		end
		derive = function(head: number): number
			local value = head
			for _, step in steps do
				value = step(value)
			end
			return value
		end
	else
		local values: { number } = {}
		for index = 1, FAN_IN do
			values[index] = index
		end
		derive = function(head: number): number
			values[1] = head
			local total = 0
			for _, value in values do
				total += value
			end
			return total
		end
	end
	local frame = Instance.new "Frame"
	local label = Instance.new "TextLabel"
	label.Text = tostring(derive(1))
	label.Parent = frame
	frame.Parent = harness.container
	return {
		run = derivedRun(harness, id, function(head: number)
			label.Text = tostring(derive(head))
		end),
		release = function()
			frame:Destroy()
		end,
	}
end

local function plainCase(id: string): Types.Case
	return stateCase(function(harness: Harness): Built
		if id == "teardown-under-load" or id == "open-close-retention" then
			return plainPages(harness, id)
		elseif id == "form-validation" then
			return plainForm(harness)
		elseif id == "theme-propagation" then
			return plainTheme(harness)
		elseif id == "hud-per-frame" then
			return plainHud(harness)
		end
		local task = listTasks[id]
		if task then
			local built: Built? = nil
			task.open(function<T>(listed: ListOf<T>): unknown
				built = plainList(harness, listed)
				return nil
			end)
			return assert(built)
		end
		return plainDerived(harness, id)
	end)
end

local all: { Types.Workload } = {}
for _, id in ids do
	table.insert(all, {
		id = id,
		title = id,
		what = (if table.find(appIds, id) then "App UI: " else "Game UI: ") .. id,
		samples = 9,
		iterations = if string.sub(id, 1, 8) == "derived-" or id == "theme-propagation" then 3 else 1,
		warmup = 2,
		cases = { plain = plainCase(id) },
	})
end

local function contains(id: string): boolean
	return table.find(ids, id) ~= nil
end

return { all = all, caseFor = caseFor, contains = contains }
