--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Lane = require "../lanes/types"
local Plain = require "../lanes/game-plain"

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
}

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
local expectedRows: { { Lane.Row } } = {}
for index = 1, 8 do
	queries[index] = string.sub("crystal1", 1, index)
	expectedRows[index] = filtered(queries[index])
end
queries[9], expectedRows[9] = "", filtered ""

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

local function page(scope: Lane.Scope, count: number, property: string, binding: unknown): unknown
	local children: { unknown } = {}
	for index = 1, count do
		children[index] = scope.node("TextLabel", { [property] = binding })
	end
	return scope.node("Frame", {}, children)
end

local function caseFor(id: string, factory: Factory, wrapKeyed: boolean?): Types.Case
	return {
		prepare = function(context): Types.State
			local environment = context.env
			local driver = factory(environment)
			local checking = context.observe ~= nil
			local keys = if id == "teardown-under-load" or id == "open-close-retention"
				then { "LayoutOrder" }
				else { "Text", "LayoutOrder" }
			local function snapshot(): string
				return environment.snapshot(context.container, keys, "LayoutOrder")
			end
			local function observe()
				if context.observe then
					context.observe(snapshot())
				end
			end
			local tick, joins = 0, 0
			local run: () -> () = function() end
			local release: () -> ()
			if id == "teardown-under-load" or id == "open-close-retention" then
				local source: Lane.Source<number>
				local owner = driver.mount(context.container, function(scope)
					source = scope.value(0)
					return scope.node("Frame", { LayoutOrder = -1 })
				end)
				environment.drain()
				local pageHost = environment.globals.Instance.new "Frame"
				pageHost.Parent = context.container
				pageHost.LayoutOrder = 1
				local baselineInstances = environment.liveInstances()
				local baselineConnections = environment.liveConnections()
				local pulsing = false
				local pulse = environment.heartbeat:Connect(function()
					if pulsing then
						return
					end
					pulsing = true
					tick += 1
					driver.batch(function()
						source.write(tick)
					end)
					pulsing = false
				end)
				run = function()
					local released: { [number]: Environment.Instance } = {}
					setmetatable(released, { __mode = "v" })
					local releasedCount = 0
					for _ = 1, if id == "open-close-retention" then 50 else 1 do
						local close = driver.mount(pageHost, function(scope)
							local binding = if scope.computed
								then assert(scope.computed)(function(use)
									return use(source)
								end).binding
								else source.binding
							return page(
								scope,
								if id == "open-close-retention" then 500 else 2000,
								"LayoutOrder",
								binding
							)
						end)
						environment.drain()
						for _ = 1, 3 do
							local writes = environment.counters().propertyWrites
							environment.step(1 / 60)
							if checking then
								local current = labels(environment, context.container)
								local count = if id == "open-close-retention" then 500 else 2000
								assert(#current == count, "The live page has the wrong node count")
								assert(
									environment.counters().propertyWrites - writes == count,
									"A source pulse must write each live node once"
								)
								for _, label in current do
									assert(
										environment.get(label, "LayoutOrder") == tick,
										"A live page missed a source pulse"
									)
								end
							end
						end
						observe()
						if checking then
							for _, label in pageHost:GetDescendants() do
								releasedCount += 1
								released[releasedCount] = label
							end
						end
						close()
						environment.drain()
						local writes = environment.counters().propertyWrites
						for _ = 1, 3 do
							environment.step(1 / 60)
						end
						if checking then
							assert(
								environment.counters().propertyWrites == writes,
								"A released page received a property write"
							)
							assert(environment.liveInstances() == baselineInstances, "A closed page retained nodes")
							assert(
								environment.liveConnections() == baselineConnections + 1,
								"A closed page retained connections"
							)
						end
						observe()
					end
					if checking then
						assert(context.collect, "Retention parity needs a collection callback")()
						assert(next(released) == nil, "A closed page retained a released node in Luau memory")
					end
				end
				release = function()
					pulse:Disconnect()
					owner()
					pageHost:Destroy()
				end
			else
				release = driver.mount(context.container, function(scope)
					if id == "filter-as-you-type" then
						local query = scope.value ""
						local list = if scope.select
							then assert(scope.select)(query, filtered)
							else assert(scope.computed)(function(use)
								return filtered(use(query))
							end)
						run = function()
							local previous: { [string]: Environment.Instance } = {}
							local positions: { [string]: number } = {}
							for _, label in labels(environment, context.container) do
								local key = tostring(environment.get(label, "Text"))
								previous[key] = label
								positions[key] = environment.get(label, "LayoutOrder") :: number
							end
							for index, text in queries do
								local before = environment.counters()
								driver.batch(function()
									query.write(text)
								end)
								if checking then
									local current = labels(environment, context.container)
									table.sort(current, function(left, right)
										return (environment.get(left, "LayoutOrder") :: number)
											< environment.get(right, "LayoutOrder") :: number
									end)
									assert(#current == #expectedRows[index], "The filtered list has the wrong length")
									local retained: { [string]: Environment.Instance } = {}
									local nextPositions: { [string]: number } = {}
									local added, removed, requiredWrites = 0, 0, 0
									for position, label in current do
										local key = tostring(environment.get(label, "Text"))
										assert(
											key == tostring(expectedRows[index][position].id),
											"The filtered list has the wrong order or values"
										)
										assert(
											environment.get(label, "LayoutOrder") == position,
											"The filtered list has the wrong position"
										)
										assert(
											previous[key] == nil or previous[key] == label,
											"A filtered row lost its Instance identity"
										)
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
								observe()
							end
						end
						local content = scope.keyed(list)
						return if wrapKeyed then scope.node("Frame", {}, { content }) else content
					elseif id == "theme-propagation" then
						local theme = scope.value "light"
						run = function()
							tick += 1
							local nextTheme = if tick % 2 == 1 then "dark" else "light"
							local writes = environment.counters().propertyWrites
							driver.batch(function()
								theme.write(nextTheme)
							end)
							if checking then
								local current = labels(environment, context.container)
								assert(#current == 1000, "The theme must reach 1,000 nodes")
								for _, label in current do
									assert(environment.get(label, "Text") == nextTheme, "A theme consumer is stale")
								end
								assert(
									environment.counters().propertyWrites - writes == 1000,
									"The theme swap must write each consumer once"
								)
							end
							observe()
						end
						local function build(): unknown
							local children: { unknown } = {}
							for index = 1, 1000 do
								children[index] = if scope.themeNode
									then assert(scope.themeNode)()
									else scope.node(
										"TextLabel",
										{ Text = if scope.themeText then assert(scope.themeText)() else theme.binding }
									)
							end
							return scope.node("Frame", {}, children)
						end
						return if scope.provideTheme then scope.provideTheme(theme, build) else build()
					elseif id == "hud-per-frame" then
						local sources: { Lane.Source<number> } = {}
						local children: { unknown } = {}
						for index = 1, 20 do
							local source = scope.value(0)
							sources[index] = source
							children[index] = scope.node("TextLabel", {
								Text = source.bind(function(value)
									return tostring(value)
								end),
								LayoutOrder = index,
							})
						end
						run = function()
							for _ = 1, 600 do
								tick += 1
								local writes = environment.counters().propertyWrites
								driver.batch(function()
									for index, source in sources do
										source.write(tick * 20 + index)
									end
								end)
								environment.step(1 / 60)
								if checking then
									local current = labels(environment, context.container)
									assert(#current == 20, "The HUD must keep 20 readouts")
									for _, label in current do
										local index = environment.get(label, "LayoutOrder") :: number
										assert(
											environment.get(label, "Text") == tostring(tick * 20 + index),
											"A HUD readout is stale"
										)
									end
									assert(
										environment.counters().propertyWrites - writes == 20,
										"Each HUD frame must write 20 readouts"
									)
								end
								observe()
							end
						end
						return scope.node("Frame", {}, children)
					end
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
							joins += 1
							local a, b = use(left), use(right)
							assert(a / 2 + 10 == b, "The diamond joined inconsistent source versions")
							return a + b
						end)
					elseif id == "derived-chain-100" then
						result = head
						for _ = 1, 100 do
							local previous = result
							result = computed(function(use)
								return use(previous) + 1
							end)
						end
					else
						local sources = { head }
						for index = 2, 1000 do
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
					run = function()
						tick += 1
						local before, writes = joins, environment.counters().propertyWrites
						driver.batch(function()
							head.write(tick + 1)
						end)
						if checking then
							local current = labels(environment, context.container)
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
							assert(
								id ~= "derived-diamond" or joins - before == 1,
								"The diamond join must recompute once"
							)
						end
						observe()
					end
					return page(
						scope,
						1,
						"Text",
						result.bind(function(value)
							return tostring(value)
						end)
					)
				end)
			end
			environment.drain()
			return {
				run = function()
					run()
				end,
				snapshot = snapshot,
				release = release,
			}
		end,
		run = function(state)
			state.run()
		end,
		snapshot = function(state)
			return state.snapshot()
		end,
		release = function(state)
			state.release()
		end,
	}
end

local all: { Types.Workload } = {}
for _, id in ids do
	table.insert(all, {
		id = id,
		title = id,
		what = "Game UI: " .. id,
		samples = 9,
		iterations = if string.sub(id, 1, 8) == "derived-" or id == "theme-propagation" then 3 else 1,
		warmup = 2,
		cases = { plain = caseFor(id, Plain.create) },
	})
end

local function contains(id: string): boolean
	return table.find(ids, id) ~= nil
end

return { all = all, caseFor = caseFor, contains = contains }
