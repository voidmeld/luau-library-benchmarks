--!strict

local Types = require "../types"
local S = require "./support"

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "input-type-switch-20",
	iterations = 20,
	what = "Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local preferred = S.model(world, lane, "KeyboardAndMouse")
		local nodes: { S.Node } = {}
		local names: { string } = {}
		for i = 1, 20 do
			table.insert(names, "Prompt" .. i)
		end
		local stop = S.mount(world, lane, function()
			local UI = world.Facet.controls(world.runtime, {
				types = world.types,
				userInputService = world.inputService,
				environment = { preferredInput = assert(preferred), viewingDistance = "near" },
			})
			local environment = UI.environment()
			local children: { Types.Node } = {}
			for i = 1, 20 do
				local props: Types.Props = {
					UI.Button("Control" .. i) { label = `Action {i}`, onActivate = function() end },
					UI.Text(names[i]) {
						text = function(use: Types.Use)
							return if use(environment.effectiveInput) == "Gamepad"
								then "A: activate"
								else "Enter: activate"
						end,
					},
				}
				table.insert(children, UI.HStack(props))
			end
			return UI.VStack "Prompts" { table.unpack(children) }
		end, function(screen)
			local root = S.stack(world, screen, "Prompts")
			for i = 1, 20 do
				local row = S.stack(world, root, "ActionRow" .. i, true)
				S.button(world, row, "Control" .. i, `Action {i}`, function() end)
				nodes[i] = S.text(world, row, names[i], "Enter: activate", true)
			end
		end)
		return {
			step = function(index: number)
				local gamepad = index % 2 == 1
				if lane == "facet" then
					assert(preferred):set(if gamepad then "Gamepad" else "KeyboardAndMouse")
				else
					for _, node in nodes do
						S.setText(world, node, if gamepad then "A: activate" else "Enter: activate")
					end
				end
				world.frame()
			end,
			snapshot = function()
				return S.snapshot(world, names)
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "localized-text-swap-50",
	iterations = 10,
	what = "Swap translated strings on 50 retained labels between English and German. Both lanes use the same LocalizationTable translators and disable automatic localization of translated text.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local tableNode = world.new "LocalizationTable"
		type Entry = { Key: string, Source: string, Values: { [string]: string } }
		type Translator = { FormatByKey: (Translator, string, { [string]: unknown }) -> string }
		type Localization = {
			SetEntries: (Localization, { Entry }) -> (),
			GetTranslator: (Localization, string) -> Translator,
		}
		local localization = (tableNode :: unknown) :: Localization
		local entries: { Entry } = {}
		for i = 1, 50 do
			local entry: Entry = {
				Key = "Task" .. i,
				Source = `Task {i}`,
				Values = { ["en-us"] = `Task {i}`, ["de-de"] = `Aufgabe {i} abschliessen` },
			}
			table.insert(entries, entry)
		end
		localization:SetEntries(entries)
		local translators = { localization:GetTranslator "en-us", localization:GetTranslator "de-de" }
		local selected = S.model(world, lane, 1)
		local nodes: { S.Node } = {}
		local names: { string } = {}
		for i = 1, 50 do
			table.insert(names, "Translation" .. i)
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local children: { Types.Node } = {}
			for i = 1, 50 do
				table.insert(
					children,
					UI.Text(names[i]) {
						text = function(use: Types.Use)
							return translators[use(assert(selected))]:FormatByKey("Task" .. i, {})
						end,
					}
				)
			end
			return UI.VStack "Localized" { table.unpack(children) }
		end, function(screen)
			local root = S.stack(world, screen, "Localized")
			for i = 1, 50 do
				nodes[i] = S.text(world, root, names[i], translators[1]:FormatByKey("Task" .. i, {}), true)
			end
		end)
		local retained: { S.Node } = {}
		for i, name in names do
			retained[i] = S.find(world, name)
		end
		return {
			step = function(index: number)
				local nextLocale = if index % 2 == 1 then 2 else 1
				if lane == "facet" then
					assert(selected):set(nextLocale)
				else
					for i, node in nodes do
						S.setText(world, node, translators[nextLocale]:FormatByKey("Task" .. i, {}))
					end
				end
				world.frame()
			end,
			snapshot = function()
				for i, name in names do
					local node = S.find(world, name)
					assert(
						node == retained[i] and node.AutoLocalize == false,
						"translation must retain each label and avoid a second translation"
					)
				end
				return S.snapshot(world, names)
			end,
			stop = function()
				stop()
				tableNode:Destroy()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "text-size-preference-50",
	iterations = 8,
	what = "Change an authored text-size preference across four ranks on a 50-label screen. Facet updates the theme StyleRules; plain updates one shared native body rule.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local preference = S.model(world, lane, "Medium")
		local rule: S.Node? = nil
		type Rule =
			{ SetProperties: (Rule, { [string]: unknown }) -> (), GetProperties: (Rule) -> { [string]: unknown } }
		local stop = S.mount(world, lane, function()
			local UI = world.Facet.controls(
				world.runtime,
				{ types = world.types, environment = { preferredTextSize = assert(preference) } }
			)
			local children: { Types.Node } = {}
			for i = 1, 50 do
				table.insert(children, UI.Text("Preference" .. i) { text = `Task {i}` })
			end
			return UI.VStack "TextPreferences" { table.unpack(children) }
		end, function(screen)
			local root = S.stack(world, screen, "TextPreferences")
			for i = 1, 50 do
				S.text(world, root, "Preference" .. i, `Task {i}`)
			end
		end)
		local sheet = world.node(assert(S.find(world, "Comparison"):FindFirstChildWhichIsA "StyleSheet"))
		for _, candidate in sheet:GetDescendants() do
			if candidate:IsA "StyleRule" and candidate.Selector == ".facet-type-body" then
				rule = world.node(candidate)
				break
			end
		end
		local body = (assert(rule, "missing body typography rule") :: unknown) :: Rule
		local properties = body:GetProperties()
		local base = properties.TextSize
		assert(type(base) == "number", "body rule needs a numeric text size")
		local stepSize = world.Facet.themes.neutralPackage().metrics.controls.typography.preferredSizeStep
		if lane == "plain" and world.guiService then
			local native = world.guiService.PreferredTextSize
			local name = if world.types.typeof(native) == "EnumItem"
				then (native :: { Name: string }).Name
				else "Medium"
			local ranks: { [string]: number } = { Medium = 0, Large = 1, Larger = 2, Largest = 3 }
			base -= (ranks[name] or 0) * stepSize
			properties.TextSize = base
			body:SetProperties(properties)
		end
		return {
			step = function(index: number)
				local rank = index % 4
				if lane == "facet" then
					assert(preference):set(({ "Medium", "Large", "Larger", "Largest" })[rank + 1])
				else
					local nextProps = table.clone(properties)
					nextProps.TextSize = base + rank * stepSize
					body:SetProperties(nextProps)
				end
				world.frame()
			end,
			snapshot = function()
				return tostring(body:GetProperties().TextSize)
			end,
			stop = stop,
		}
	end,
})

return workloads
