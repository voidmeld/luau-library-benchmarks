--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"

local workloads: { Types.Workload } = {}
local SIZE_TOKEN = "PlainBodyTextSize"
local RANKS = { "Medium", "Large", "Larger", "Largest" }

table.insert(workloads, {
	id = "input-type-switch-20",
	iterations = 20,
	what = "Switch the authored preferred-input fact between keyboard and gamepad on 20 action controls and prompts. This measures adaptation after input detection.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local preferred = S.model(world, lane, "KeyboardAndMouse")
		local nodes: { S.Node } = {}
		local controls: { S.Node } = {}
		local names: { string } = {}
		local observed: { string } = { "Prompts" }
		for i = 1, 20 do
			table.insert(names, "Prompt" .. i)
			table.insert(observed, "ActionRow" .. i)
			table.insert(observed, "Control" .. i)
			table.insert(observed, "Prompt" .. i)
		end
		local stop = S.mount(world, lane, function()
			local UI = S.controls(world, { preferredInput = assert(preferred), viewingDistance = "near" })
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
				table.insert(children, UI.HStack("ActionRow" .. i)(props))
			end
			return UI.VStack "Prompts" { table.unpack(children) }
		end, function(screen)
			local root = S.stack(world, screen, "Prompts")
			for i = 1, 20 do
				local row = S.stack(world, root, "ActionRow" .. i, true)
				controls[i] = S.button(world, row, "Control" .. i, `Action {i}`, function() end)
				nodes[i] = S.text(world, row, names[i], "Enter: activate", true)
			end
		end)
		return {
			step = function(index: number)
				local gamepad = index % 2 == 1
				if lane == "facet" then
					assert(preferred):set(if gamepad then "Gamepad" else "KeyboardAndMouse")
				else
					for i, node in nodes do
						S.setText(world, node, if gamepad then "A: activate" else "Enter: activate")
						if gamepad then
							S.targetFloor(world, controls[i])
						else
							local floor = controls[i]:FindFirstChild "TargetFloor"
							if floor then
								floor:Destroy()
							end
						end
					end
				end
				world.frame()
			end,
			snapshot = function()
				return S.observe(world, observed)
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
		local observed: { string } = { "Localized" }
		for i = 1, 50 do
			table.insert(names, "Translation" .. i)
			table.insert(observed, "Translation" .. i)
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
				return S.observe(world, observed)
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
	what = "Change an authored text-size preference across four ranks on a 50-label screen. Facet updates its theme text-size tokens; plain updates one native StyleSheet text-size token that its body rule reads.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local preference = S.model(world, lane, RANKS[1])
		local gui = world.guiService
		local native: unknown = if gui then gui.PreferredTextSize else nil
		local nativeName = if world.types.typeof(native) == "EnumItem"
			then (native :: { Name: string }).Name
			else RANKS[1]
		local nativeRank = (table.find(RANKS, nativeName) or 1) - 1
		local rank = 0
		local function sizeFor(chosen: number): number
			return Theme.typography.body + (chosen - nativeRank) * Theme.typography.step
		end
		local textSheet: S.Node? = nil
		local observed: { string } = { "TextPreferences" }
		for i = 1, 50 do
			table.insert(observed, "Preference" .. i)
		end
		local stop = S.mount(world, lane, function()
			local UI = S.controls(world, { preferredTextSize = assert(preference) })
			local children: { Types.Node } = {}
			for i = 1, 50 do
				table.insert(children, UI.Text("Preference" .. i) { text = `Task {i}` })
			end
			return UI.VStack "TextPreferences" { table.unpack(children) }
		end, function(screen, sheet)
			sheet:SetAttribute(SIZE_TOKEN, sizeFor(rank))
			Theme.rule(world, sheet, "." .. Theme.tags.body, { TextSize = "$" .. SIZE_TOKEN })
			textSheet = sheet
			local root = S.stack(world, screen, "TextPreferences")
			for i = 1, 50 do
				S.text(world, root, "Preference" .. i, `Task {i}`)
			end
		end)
		local labels: { S.Node } = {}
		for i = 1, 50 do
			labels[i] = S.find(world, "Preference" .. i)
		end
		return {
			step = function(index: number)
				rank = index % #RANKS
				if lane == "facet" then
					assert(preference):set(RANKS[rank + 1])
				else
					assert(textSheet):SetAttribute(SIZE_TOKEN, sizeFor(rank))
					if not S.simulated(world) then
						for _, label in labels do
							label.AutomaticSize = world.types.Enum.AutomaticSize.None
						end
						world.frame()
						for _, label in labels do
							label.AutomaticSize = world.types.Enum.AutomaticSize.XY
						end
					end
				end
				world.frame()
			end,
			snapshot = function()
				local expected = sizeFor(rank)
				for _, label in labels do
					assert(label:GetStyled "TextSize" == expected, "a label did not follow the text-size preference")
				end
				return S.observe(world, observed)
			end,
			stop = stop,
		}
	end,
})

return workloads
