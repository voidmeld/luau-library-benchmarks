--!strict

local Types = require "../types"
local S = require "./support"

return {
	{
		id = "modal-on-modal",
		iterations = 20,
		what = "Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.",
		prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
			local previousGui = world.guiService
			local gui = previousGui or world.new "GuiService"
			local priorSelection = gui.SelectedObject
			world.guiService = gui
			local presented = { S.model(world, lane, false), S.model(world, lane, false) }
			local panels: { [number]: S.Node } = {}
			local contexts: { [number]: S.Node } = {}
			local restores: { [number]: () -> () } = {}
			local parent: S.Node? = nil
			local entry: S.Node? = nil
			local function available(node: S.Node, enabled: boolean)
				node.Interactable = enabled
				node.Selectable = enabled
			end
			local depth, accepted = 0, 0
			local expectedAccepted = 0
			local titles = { "Outer terms", "Inner confirmation" }
			local function close(level: number)
				accepted += 1
				if lane == "facet" then
					assert(presented[level]):set(false)
					return
				end
				local panel = assert(panels[level])
				assert(contexts[level]).Enabled = false
				if level == 2 then
					assert(contexts[1]).Enabled = true
					assert(panels[1]).Interactable = true
					available(S.find(world, "Accept1"), true)
				else
					available(assert(entry), true)
				end
				assert(restores[level])()
				panel.Interactable = false
				S.animate(
					world,
					panel,
					world.motion.dialog.exit,
					world.motion.present,
					{ GroupTransparency = 1 },
					function()
						panel:Destroy()
						panels[level] = nil
						contexts[level] = nil
					end
				)
			end
			local function open(level: number)
				if lane == "facet" then
					assert(presented[level]):set(true)
					if world.key == nil then
						world.pin(S.find(world, "Accept" .. level), 120, 44)
					end
					return
				end
				local panel = S.layer(world, "ModalLayer" .. level, function()
					close(level)
				end, "facet-scrim")
				panel.ZIndex = 100 * level
				panels[level] = panel
				local body = S.stack(world, panel, "Panel" .. level)
				body.ZIndex = 100 * level + 1
				S.tag(body, "facet-dialog", "facet-panel")
				S.trap(world, body)
				S.text(world, body, "ModalTitle" .. level, titles[level], nil, "heading")
				local action = S.button(world, body, "Accept" .. level, "Accept", function()
					close(level)
				end)
				contexts[level] = S.inputs(world, panel, "ModalBack" .. level, 2000 + level, {
					{
						name = "Back",
						keys = { world.types.Enum.KeyCode.ButtonB },
						pressed = function()
							close(level)
						end,
					},
				})
				panel.Parent = assert(parent)
				restores[level] = S.focus(world, action)
				if level == 2 then
					assert(contexts[1]).Enabled = false
					assert(panels[1]).Interactable = false
					available(S.find(world, "Accept1"), false)
				else
					available(assert(entry), false)
				end
				S.animate(world, panel, world.motion.dialog.enter, world.motion.present, { GroupTransparency = 0 })
			end
			local stop = S.mount(world, lane, function()
				local UI = world.Facet.controls(world.runtime, {
					types = world.types,
					services = {
						GuiService = gui,
						UserInputService = world.inputService,
						TextService = world.textService,
					},
					environment = { preferredInput = "Gamepad", viewingDistance = "near" },
				})
				local children: { Types.Node } =
					{ UI.Button "ModalEntry" { label = "Open", onActivate = function() end } }
				for level = 1, 2 do
					local actions: { Types.DialogAction } = {
						{
							id = "Accept" .. level,
							label = "Accept",
							onActivate = function()
								accepted += 1
							end,
						},
					}
					table.insert(
						children,
						UI.Dialog("Stacked" .. level) {
							isPresented = assert(presented[level]),
							onPresentedChange = function(value: boolean)
								assert(presented[level]):set(value)
							end,
							title = titles[level],
							actions = actions,
						}
					)
				end
				return world.Host.Frame {
					Name = "ModalStack",
					Size = world.types.UDim2.fromScale(1, 1),
					table.unpack(children),
				}
			end, function(screen)
				parent = screen
				S.button(world, screen, "ModalEntry", "Open", function() end)
			end)
			entry = S.find(world, "ModalEntry")
			gui.SelectedObject = entry
			local keyboard =
				{ UserInputType = world.types.Enum.UserInputType.Keyboard, KeyCode = world.types.Enum.KeyCode.Return }
			return {
				step = function(index: number)
					local phase = (index - 1) % 4
					if phase < 2 then
						depth = phase + 1
						open(depth)
					else
						expectedAccepted += 1
						S.fire(world, "Accept" .. (4 - phase), "Activated", keyboard)
						depth = 3 - phase
					end
					world.frame(math.max(world.motion.dialog.enter, world.motion.dialog.exit) + 0.05)
				end,
				snapshot = function()
					local titlesPresent: { string } = {}
					local traps = 0
					for _, node in world.target:GetDescendants() do
						if node:IsA "TextLabel" and (node.Text == titles[1] or node.Text == titles[2]) then
							table.insert(titlesPresent, tostring(node.Text))
						end
						if
							node:IsA "GuiObject"
							and node.SelectionGroup == true
							and node.SelectionBehaviorDown == world.types.Enum.SelectionBehavior.Stop
						then
							traps += 1
						end
					end
					table.sort(titlesPresent)
					assert(#titlesPresent == depth, "modal stack did not retain the covered dialog")
					assert(accepted == expectedAccepted, "modal input did not accept exactly once")
					local base = assert(entry)
					assert(
						base.Interactable == (depth == 0) and base.Selectable == (depth == 0),
						"modal did not isolate the entry control"
					)
					if depth > 0 then
						local outer = S.find(world, "Accept1")
						assert(
							outer.Interactable == (depth == 1) and outer.Selectable == (depth == 1),
							"modal did not isolate the lower dialog"
						)
					end
					local focused = gui.SelectedObject
					local wanted = if depth > 0 then S.find(world, "Accept" .. depth) else entry
					if focused ~= wanted then
						local name = if focused then tostring((focused :: S.Node).Name) else "nil"
						error(`modal focus did not restore in stack order: depth {depth} selected {name}`, 0)
					end
					return `{accepted}:{table.concat(titlesPresent, ",")}:traps={traps}:sinks={S.sinks(world)}`
				end,
				stop = function()
					stop()
					world.guiService = previousGui
					local prior = priorSelection :: S.Node?
					gui.SelectedObject = if prior and prior:FindFirstAncestorWhichIsA "BasePlayerGui"
						then prior
						else nil
					if previousGui == nil then
						gui:Destroy()
					end
				end,
			}
		end,
	},
} :: { Types.Workload }
