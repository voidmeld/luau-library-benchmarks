--!strict

local Types = require "../types"
local S = require "./support"
type FrameProps = Types.Props

local workloads: { Types.Workload } = {}

local function labels(world: Types.World, prefix: string): string
	local rows: { string } = {}
	for _, node in world.target:GetDescendants() do
		if node:IsA "TextLabel" and type(node.Text) == "string" and string.sub(node.Text, 1, #prefix) == prefix then
			table.insert(rows, node.Text)
		end
	end
	table.sort(rows)
	return table.concat(rows, "\n")
end

table.insert(workloads, {
	id = "toast-stream-20",
	iterations = 40,
	what = "Show 20 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes use the theme toast enter and exit motion.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI, Compose = world.UI, world.Compose
		local duration = world.toastDuration or 4
		local initial: { number } = {}
		local messages = S.model(world, lane, initial)
		local panel: S.Node? = nil
		local parent: S.Node? = nil
		local remaining = 0
		local connection = world.heartbeat:Connect(function(dt: number)
			local shown = panel
			if lane == "plain" and shown then
				remaining -= dt
				if remaining <= 0 then
					panel = nil
					local row = assert(shown:FindFirstChild "ToastRow") :: S.Node
					S.animate(world, row, world.motion.toast.exit, world.motion.present, {
						GroupTransparency = 1,
						Position = world.types.UDim2.fromOffset(0, -16),
					}, function()
						shown:Destroy()
					end)
				end
			end
		end)
		local stop = S.mount(world, lane, function()
			local Host = world.Host
			local props: FrameProps = {
				Name = "Toasts",
				Compose.keyed {
					from = assert(messages),
					key = function(id: number)
						return id
					end,
					render = function(current: Types.ReadOnlyValue<number>)
						return UI.Toast {
							duration = duration,
							message = function(use: Types.Use)
								return `Reward {use(current)}`
							end,
						}
					end,
				},
			}
			return Host.Frame(props)
		end, function(screen)
			local stack = S.stack(world, screen, "ToastStack")
			local padding = S.create(world, "UIPadding", "UIPadding", stack)
			padding.PaddingTop = world.types.UDim.new(0, 16)
			parent = stack
		end)
		return {
			step = function(index: number)
				if index % 2 == 1 then
					local id = math.ceil(index / 2)
					if lane == "facet" then
						assert(messages):set { id }
					else
						local slot = S.create(world, "Frame", "ToastSlot", nil, {
							BackgroundTransparency = 1,
							Size = world.types.UDim2.fromScale(1, 0),
							AutomaticSize = world.types.Enum.AutomaticSize.Y,
						})
						local row = S.create(world, "CanvasGroup", "ToastRow", slot, {
							Size = world.types.UDim2.fromScale(1, 0),
							AutomaticSize = world.types.Enum.AutomaticSize.Y,
						})
						S.tag(row, "facet-snackbar", "facet-panel", "facet-floating")
						row.GroupTransparency = 1
						row.Position = world.types.UDim2.fromOffset(0, -16)
						local padding = S.create(world, "UIPadding", "UIPadding", row)
						padding.PaddingLeft, padding.PaddingRight =
							world.types.UDim.new(0, 12), world.types.UDim.new(0, 12)
						padding.PaddingTop, padding.PaddingBottom =
							world.types.UDim.new(0, 8), world.types.UDim.new(0, 8)
						S.create(world, "UICorner", "UICorner", row)
						S.text(world, row, "Message", `Reward {id}`, nil, "")
						slot.Parent = assert(parent)
						panel = slot
						remaining = duration
						S.animate(world, row, world.motion.toast.enter, world.motion.present, {
							GroupTransparency = 0,
							Position = world.types.UDim2.fromOffset(0, 0),
						})
					end
					world.frame()
				else
					world.frame(duration + world.motion.toast.enter + 0.05)
					world.frame(world.motion.toast.exit + 0.05)
				end
			end,
			snapshot = function()
				return `{labels(world, "Reward ")}\nsnackbar={S.tagged(world, "facet-snackbar")}`
			end,
			stop = function()
				connection:Disconnect()
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "tabs-5-20-switches",
	iterations = 20,
	what = "Switch 20 times among five peer pages and keep each visited page and its content. Both lanes mark the current tab, show its selection indicator and add shoulder-button input contexts.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local selection = S.model(world, lane, "1")
		local current = "1"
		local expected = "1"
		local pages: { [string]: S.Node } = {}
		local tabButtons: { [string]: S.Node } = {}
		local stopSelection: (() -> ())? = nil
		local tabs: { Types.Tab } = {}
		for i = 1, 5 do
			table.insert(tabs, {
				id = tostring(i),
				label = `Tab {i}`,
				content = function()
					return UI.Text("Page" .. i) { text = `Page {i} content` }
				end,
			})
		end
		local stop = S.mount(world, lane, function()
			return UI.TabView "Tabs" {
				selection = assert(selection),
				tabs = tabs,
				placement = "topBar",
				transition = false,
			}
		end, function(screen)
			local Enum = world.types.Enum
			local root = S.stack(world, screen, "Tabs")
			local bar = S.stack(world, root, "TabBar", true)
			local content = S.create(world, "Frame", "Content", root, {
				BackgroundTransparency = 1,
				Size = world.types.UDim2.fromScale(1, 1),
			})
			local buttons: { [string]: S.Node } = {}
			local marks: { [string]: S.Node } = {}
			local function select(id: string)
				local previous = pages[current]
				if previous then
					previous.Visible = false
					buttons[current]:RemoveTag "facet-tab-current"
					marks[current].Visible = false
				end
				current = id
				local page = pages[id]
				if page == nil then
					local made = S.create(world, "Frame", id, nil, {
						BackgroundTransparency = 1,
						Size = world.types.UDim2.fromScale(1, 1),
					})
					made.SelectionGroup = true
					S.text(world, made, "Page" .. id, `Page {id} content`)
					made.Parent = content
					pages[id] = made
					page = made
				end
				assert(page).Visible = true
				buttons[id]:AddTag "facet-tab-current"
				marks[id].Visible = true
			end
			for i = 1, 5 do
				local id = tostring(i)
				local button = S.button(world, bar, "Tab" .. i, `Tab {i}`, function()
					select(id)
				end)
				S.tag(button, "facet-tab-item")
				local mark = S.create(world, "Frame", "SelectionIndicator", button, { BorderSizePixel = 0 })
				mark.Visible = false
				S.tag(mark, "facet-selection-indicator")
				buttons[id], marks[id] = button, mark
				tabButtons[id] = button
			end
			local function shift(by: number)
				select(tostring((tonumber(current) :: number - 1 + by) % 5 + 1))
			end
			local bumpers = {
				S.inputs(world, screen, "FacetPreviousTab", 50, {
					{
						name = "PreviousTab",
						keys = { Enum.KeyCode.ButtonL1 },
						pressed = function()
							shift(-1)
						end,
					},
				}),
				S.inputs(world, screen, "FacetNextTab", 50, {
					{
						name = "NextTab",
						keys = { Enum.KeyCode.ButtonR1 },
						pressed = function()
							shift(1)
						end,
					},
				}),
			}
			local gui: S.Node? = world.guiService
			local function sync()
				local selected: S.Node? = if gui then gui.SelectedObject :: S.Node? else nil
				local inside = selected ~= nil and selected:IsDescendantOf(bar)
				for _, context in bumpers do
					context.Enabled = inside
				end
			end
			if gui then
				local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(sync)
				stopSelection = function()
					connection:Disconnect()
				end
			end
			sync()
			select "1"
		end)
		if lane == "facet" then
			for _, node in world.target:GetDescendants() do
				if node:IsA "GuiButton" and node:HasTag "facet-tab-item" then
					tabButtons[tostring(node.Name)] = world.node(node)
				end
			end
		end
		return {
			step = function(index: number)
				local id = tostring(index % 5 + 1)
				expected = id
				world.fire(assert(tabButtons[id]), "Activated")
				world.frame()
			end,
			snapshot = function()
				local id = if lane == "facet" then assert(selection):peek() else current
				assert(id == expected, "tab input did not select the requested page")
				local marked: { string } = {}
				for _, node in world.target:GetDescendants() do
					if node:HasTag "facet-tab-current" then
						table.insert(marked, tostring(node.Text))
					end
				end
				return `{S.find(world, "Page" .. id).Text}:{labels(world, "Page ")}\ncurrent={table.concat(marked, ",")} indicators={S.tagged(
					world,
					"facet-selection-indicator"
				)} sinks={S.sinks(world)}`
			end,
			stop = function()
				if stopSelection then
					stopSelection()
				end
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "radial-50-cycles",
	iterations = 100,
	what = "Open a four-command radial menu, select Wave and close it, 50 times. Both lanes draw four Path2D ring sectors, a centre close button, a selection preview, a scrim, gamepad and keyboard input contexts and the theme radial fade, and hide the launcher while the menu is open. Both lanes put the launcher at the screen centre, so the ring opens around it.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local open = S.model(world, lane, false)
		local actions = { "Wave", "Dance", "Point", "Cheer" }
		local items: { Types.RadialItem<string> } = {}
		local selected = ""
		local commits, expectedCommits = 0, 0
		for _, label in actions do
			local item: Types.RadialAction<string> = {
				id = label,
				label = label,
				onSelect = function()
					selected = label
					commits += 1
				end,
			}
			table.insert(items, item)
		end
		local parent: S.Node? = nil
		local launcher: S.Node? = nil
		local Enum, D2, V2 = world.types.Enum, world.types.UDim2, world.types.Vector2
		local stop = S.mount(world, lane, function()
			local spec: Types.RadialMenuSpec<string> = {
				label = "Emotes",
				isPresented = assert(open),
				items = items,
				preset = "donut",
				AnchorPoint = V2.new(0.5, 0.5),
				Position = D2.fromScale(0.5, 0.5),
			}
			return UI.RadialMenu "Emotes"(spec)
		end, function(screen)
			parent = screen
			local button = S.button(world, screen, "Launcher", "Emotes", function() end)
			button.AnchorPoint = V2.new(0.5, 0.5)
			button.Position = D2.fromScale(0.5, 0.5)
			launcher = button
		end)
		local inner, outer, gap = 72, 152, 2
		local radius = (inner + outer) / 2
		local function arc(angle: number): { unknown }
			local trim = math.deg(math.asin(gap / 2 / radius))
			local from, to = math.rad(angle - 45 + trim), math.rad(angle + 45 - trim)
			local handle = 4 / 3 * math.tan((to - from) / 4) * radius
			local points: { unknown } = {}
			for _, at in { from, to } do
				local x, y = outer + math.sin(at) * radius, outer - math.cos(at) * radius
				local dx, dy = math.cos(at) * handle, math.sin(at) * handle
				table.insert(
					points,
					world.types.Path2DControlPoint.new(
						D2.fromOffset(x, y),
						D2.fromOffset(-dx, -dy),
						D2.fromOffset(dx, dy)
					)
				)
			end
			return points
		end
		local function openRing()
			local closing = false
			local candidate: number? = nil
			local buttons: { S.Node } = {}
			local wedges: { S.Node } = {}
			local contexts: { S.Node } = {}
			local restore = function() end
			local root: S.Node
			local function close()
				if closing then
					return
				end
				closing = true
				root.Interactable = false
				for _, context in contexts do
					context.Enabled = false
				end
				restore()
				assert(launcher).Visible = true
				S.animate(
					world,
					root,
					world.motion.radial.exit,
					world.motion.present,
					{ GroupTransparency = 1 },
					function()
						root:Destroy()
					end
				)
			end
			root = S.layer(world, "RadialModal", close)
			local ring = S.create(world, "Frame", "RadialPanel", root, {
				BackgroundTransparency = 1,
				Size = D2.fromOffset(2 * outer, 2 * outer),
			})
			ring.AnchorPoint = V2.new(0.5, 0.5)
			ring.Position = D2.fromScale(0.5, 0.5)
			ring.ZIndex = 101
			S.trap(world, ring)
			local plate = S.create(world, "Frame", "SelectionPlate", root, { BorderSizePixel = 0 })
			plate.Visible = false
			S.tag(plate, "facet-tooltip")
			local preview = S.text(world, root, "SelectionPreview", "", nil, "caption")
			preview.Visible = false
			local function highlight(index: number?)
				local previous = candidate
				if previous then
					buttons[previous]:RemoveTag "facet-selected"
					buttons[previous]:RemoveTag "facet-radial-candidate"
					wedges[previous]:RemoveTag "facet-radial-candidate"
				end
				candidate = index
				if index then
					S.tag(buttons[index], "facet-selected", "facet-radial-candidate")
					S.tag(wedges[index], "facet-radial-candidate")
					preview.Text = actions[index]
				end
				preview.Visible = index ~= nil
				plate.Visible = index ~= nil
			end
			local function choose(index: number)
				if closing then
					return
				end
				selected = actions[index]
				commits += 1
				close()
			end
			for index, label in actions do
				local angle = (index - 1) * 90
				local sector = S.create(world, "Frame", "Sector-" .. label, ring, {
					BackgroundTransparency = 1,
					Size = D2.fromScale(1, 1),
				})
				local wedge = S.create(world, "Path2D", "Sector", sector)
				wedge.Thickness = outer - inner
				wedge.Closed = false
				wedge.ZIndex = 102
				S.tag(wedge, "facet-radial-sector")
				local path = (wedge :: unknown) :: S.Path
				path:SetControlPoints(arc(angle))
				local button = S.button(world, sector, label, label, function()
					choose(index)
				end)
				S.tag(button, "facet-radial-item", "facet-radial-label", "facet-appearance-utility")
				button.AnchorPoint = V2.new(0.5, 0.5)
				button.Position = D2.fromOffset(
					outer + math.sin(math.rad(angle)) * radius,
					outer - math.cos(math.rad(angle)) * radius
				)
				button.ZIndex = 105
				button.MouseEnter:Connect(function(...: unknown)
					highlight(index)
				end)
				button.MouseLeave:Connect(function(...: unknown)
					highlight(nil)
				end)
				button.SelectionGained:Connect(function(...: unknown)
					highlight(index)
				end)
				buttons[index], wedges[index] = button, wedge
			end
			local center = S.button(world, root, "Center", "", close)
			S.tag(center, "facet-button-glyph", "facet-appearance-utility")
			center.AnchorPoint = V2.new(0.5, 0.5)
			center.Position = D2.fromScale(0.5, 0.5)
			center.ZIndex = 106
			S.create(world, "UICorner", "UICorner", center)
			local icon = S.create(world, "ImageLabel", "LeadingIcon", center, {
				BackgroundTransparency = 1,
				Size = D2.fromOffset(20, 20),
			})
			S.tag(icon, "facet-icon")
			local function toward(index: number): () -> ()
				return function()
					highlight(index)
				end
			end
			table.insert(
				contexts,
				S.inputs(world, root, "FacetModalBack", 2000, {
					{ name = "ModalBack", keys = { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, pressed = close },
				})
			)
			table.insert(
				contexts,
				S.inputs(world, root, "FacetRadial", 2000, {
					{
						name = "RadialAim",
						keys = { Enum.KeyCode.Thumbstick1 },
						aim = function(value: unknown)
							if world.types.typeof(value) ~= "Vector2" then
								return
							end
							local aim = S.vector2(world, value)
							if aim.Magnitude < 0.5 then
								return
							end
							highlight(math.floor((math.deg(math.atan2(aim.X, aim.Y)) + 45) % 360 / 90) + 1)
						end,
					},
					{
						name = "RadialCommit",
						keys = { Enum.KeyCode.ButtonA, Enum.KeyCode.Return },
						pressed = function()
							if candidate then
								choose(candidate)
							end
						end,
					},
					{ name = "Radial-up", keys = { Enum.KeyCode.DPadUp, Enum.KeyCode.Up }, pressed = toward(1) },
					{
						name = "Radial-right",
						keys = { Enum.KeyCode.DPadRight, Enum.KeyCode.Right },
						pressed = toward(2),
					},
					{ name = "Radial-down", keys = { Enum.KeyCode.DPadDown, Enum.KeyCode.Down }, pressed = toward(3) },
					{ name = "Radial-left", keys = { Enum.KeyCode.DPadLeft, Enum.KeyCode.Left }, pressed = toward(4) },
				})
			)
			assert(launcher).Visible = false
			root.Parent = assert(parent)
			restore = S.focus(world, buttons[1])
			S.animate(world, root, world.motion.radial.enter, world.motion.present, { GroupTransparency = 0 })
		end
		return {
			step = function(index: number)
				if index % 2 == 1 then
					if lane == "facet" then
						assert(open):set(true)
					else
						openRing()
					end
				else
					local target: S.Node? = nil
					for _, node in world.target:GetDescendants() do
						if node:IsA "TextButton" and node.Text == "Wave" then
							target = world.node(node)
							break
						end
					end
					assert(target, "Wave target missing")
					expectedCommits += 1
					world.fire(target, "Activated")
					if lane == "facet" then
						assert(open):set(false)
					end
				end
				world.frame(math.max(world.motion.radial.enter, world.motion.radial.exit) + 0.05)
				assert(commits == expectedCommits, "radial input did not commit exactly once")
			end,
			snapshot = function()
				return `{selected}\nitems={S.tagged(world, "facet-radial-item")} sectors={S.tagged(
					world,
					"facet-radial-sector"
				)} sinks={S.sinks(world)} launcher={S.find(world, "Launcher").Visible} wave={S.tagsOf(world, "Wave")}`
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "navigation-5-20-cycles",
	iterations = 200,
	what = "Push five child pages and pop them, 20 times; root has no Back action and covered pages remain retained.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local initial: { Types.NavigationEntry<number> } = {}
		local path = S.model(world, lane, initial)
		local depth = 0
		local pages: { S.Node } = {}
		local parent: S.Node? = nil
		local function plainPush(level: number)
			if #pages > 0 then
				pages[#pages].Visible = false
			end
			local page = S.stack(world, assert(parent), "Level" .. level)
			local bar = S.stack(world, page, "NavigationBar", true)
			if level > 0 then
				local back = S.button(world, bar, "Back" .. level, "", function() end)
				local row = S.stack(world, back, "Content", true)
				S.create(world, "ImageLabel", "LeadingIcon", row, { Size = world.types.UDim2.fromOffset(20, 20) })
				S.text(world, row, "Title", "Back")
			end
			S.text(world, bar, "Title", `Level {level}`)
			local destination = S.stack(world, page, "Destination")
			S.text(world, destination, "PageText" .. level, `Destination {level}`)
			table.insert(pages, page)
		end
		local destinations: { [string]: Types.NavigationDestination<number> } = {
			level = {
				title = "Details",
				content = function(entry: { value: number }?)
					assert(entry and entry.value)
					return UI.Text("PageText" .. entry.value) { text = `Destination {entry.value}` }
				end,
			},
		}
		local stop = S.mount(world, lane, function()
			return UI.NavigationStack "Navigation" {
				path = assert(path),
				root = {
					title = "Home",
					content = function()
						return UI.Text "PageText0" { text = "Destination 0" }
					end,
				},
				destinations = destinations,
				transition = false,
			}
		end, function(screen)
			parent = S.stack(world, screen, "Navigation")
			plainPush(0)
		end)
		return {
			step = function(index: number)
				local phase = (index - 1) % 10
				depth += if phase < 5 then 1 else -1
				if lane == "facet" then
					local nextPath = table.clone(assert(path):peek())
					if phase < 5 then
						table.insert(nextPath, { id = "level", value = depth })
					else
						table.remove(nextPath)
					end
					assert(path):set(nextPath)
				elseif phase < 5 then
					plainPush(depth)
				else
					assert(table.remove(pages)):Destroy()
					pages[#pages].Visible = true
				end
				world.frame()
			end,
			snapshot = function()
				return tostring(S.find(world, "PageText" .. depth).Text) .. ":" .. labels(world, "Destination ")
			end,
			stop = stop,
		}
	end,
})

return workloads
