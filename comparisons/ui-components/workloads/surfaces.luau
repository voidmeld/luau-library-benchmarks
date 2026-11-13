--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"

type Node = S.Node
type Toast = { id: number, message: string, slot: Node?, fade: Node?, slide: Node?, remaining: number }
type Sector = { label: string, angle: number, x: number, y: number, width: number, height: number }

local workloads: { Types.Workload } = {}

local TOAST = table.freeze { margin = 8, gap = 8, z = 70, visible = 3, queue = 8 }
local RADIAL = table.freeze {
	ring = 96,
	clearance = 40,
	floor = 24,
	gap = 2,
	label = 40,
	hub = 32,
	target = 44,
}
local TAB_BAR, TAB_GAP, TAB_INDICATOR = 44, 8, 2
local NAV_BAR = 44

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

local function shown(world: Types.World, node: Node): boolean
	local at: Node? = node
	while at ~= nil and at ~= world.target do
		if at:IsA "GuiObject" and at.Visible == false then
			return false
		end
		if at:IsA "LayerCollector" and at.Enabled == false then
			return false
		end
		local parent = at.Parent
		at = if parent then world.node(parent) else nil
	end
	return at ~= nil
end

local function facts(world: Types.World, label: string, node: Node?): string
	if node == nil then
		return label .. ": absent"
	end
	local rows = { label .. ":", if shown(world, node) then "shown" else "hidden" }
	if node:IsA "TextLabel" or node:IsA "TextButton" then
		local text = tostring(node.Text)
		table.insert(rows, "text=" .. text)
		if text ~= "" then
			table.insert(rows, "ink=" .. S.rgb(world, node:GetStyled "TextColor3"))
			table.insert(rows, "size=" .. S.number(node:GetStyled "TextSize", 1))
			table.insert(rows, "font=" .. tostring(node:GetStyled "FontFace"))
			table.insert(rows, "align=" .. tostring(node:GetStyled "TextXAlignment"))
		end
	end
	if node:IsA "GuiObject" then
		local transparency = node:GetStyled "BackgroundTransparency"
		table.insert(rows, "bgAlpha=" .. S.number(transparency, 3))
		if type(transparency) == "number" and transparency < 1 then
			table.insert(rows, "bg=" .. S.rgb(world, node:GetStyled "BackgroundColor3"))
		end
	end
	if world.layout and node:IsA "GuiBase2d" then
		local at, size = S.vector2(world, node.AbsolutePosition), S.vector2(world, node.AbsoluteSize)
		table.insert(
			rows,
			`at={S.rounded(at.X, 0)},{S.rounded(at.Y, 0)} extent={S.rounded(size.X, 0)}x{S.rounded(size.Y, 0)}`
		)
	end
	return table.concat(rows, " ")
end

local function child(world: Types.World, parent: Node?, name: string, recursive: boolean?): Node?
	if parent == nil then
		return nil
	end
	local found = parent:FindFirstChild(name, recursive)
	return if found then world.node(found) else nil
end

local function inside(node: Node?, root: Node): boolean
	return node ~= nil and (node == root or node:IsDescendantOf(root))
end

local function selecting(world: Types.World): boolean
	local input, gui = world.inputService, world.guiService
	if input == nil then
		return false
	end
	local Enum = world.types.Enum
	local preferred = input.PreferredInput
	if preferred == Enum.PreferredInput.Touch then
		return false
	end
	if preferred == Enum.PreferredInput.Gamepad then
		return true
	end
	local last = (input.GetLastInputType :: (Node) -> unknown)(input)
	return gui ~= nil
		and gui.SelectedObject ~= nil
		and (last == Enum.UserInputType.Keyboard or string.find(tostring(last), "Gamepad", 1, true) ~= nil)
end

local function firstSelectable(world: Types.World, node: Node): Node?
	if node:IsA "GuiObject" then
		if node.Visible == false or node.Interactable == false then
			return nil
		end
		if node.Selectable == true then
			return node
		end
	end
	for _, item in node:GetChildren() do
		local found = firstSelectable(world, world.node(item))
		if found then
			return found
		end
	end
	return nil
end

local function glyph(world: Types.World, parent: Node, strokes: { { { number } } })
	local UDim2 = world.types.UDim2
	local icon = S.create(world, "ImageLabel", "LeadingIcon", parent, {
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(20, 20),
	})
	icon:AddTag "pl-icon"
	for _, points in strokes do
		local stroke = S.create(world, "Path2D", "Stroke", icon)
		stroke.Thickness = 20 / 12
		stroke.Closed = false
		stroke:AddTag "pl-icon-stroke"
		local controls: { unknown } = {}
		for _, point in points do
			table.insert(
				controls,
				world.types.Path2DControlPoint.new(UDim2.fromScale(point[1], point[2]), UDim2.new(), UDim2.new())
			)
		end
		local path = (stroke :: unknown) :: S.Path
		path:SetControlPoints(controls)
	end
	return icon
end

local function iconRules(world: Types.World, sheet: Node)
	Theme.rule(world, sheet, ".pl-icon", { ImageColor3 = Theme.token "content", BackgroundTransparency = 1 })
	Theme.rule(world, sheet, ".pl-icon-stroke", { Color3 = Theme.token "content" })
end

table.insert(workloads, {
	id = "toast-stream-4",
	iterations = 8,
	what = "Show 4 one-shot result toasts with a shared expiry parameter (four seconds headless, 0.05 seconds Studio). Both lanes stack toasts at the top of the overlay, show at most three and queue up to eight, slide each in with the theme present easing while fading it linearly, and fade only under reduced motion.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local duration = world.toastDuration or 4
		local motion = S.motion(world, lane)
		local initial: { number } = {}
		local messages = S.model(world, lane, initial)
		local layer: Node? = nil
		local stack: Node? = nil
		local queue: { Toast } = {}
		local visible: { Toast } = {}
		local sequence = 0
		local stopClock: (() -> ())? = nil
		local UDim, UDim2, Vector2 = world.types.UDim, world.types.UDim2, world.types.Vector2
		local function stackFor(): Node
			local existing = stack
			if existing then
				return existing
			end
			local made = S.blank(world, "ToastStack", nil, UDim2.new(1, -32, 1, 0))
			made.AnchorPoint = Vector2.new(0.5, 0)
			made.Position = UDim2.fromScale(0.5, 0)
			made.ZIndex = TOAST.z
			local padding = S.create(world, "UIPadding", "UIPadding", made)
			padding.PaddingTop, padding.PaddingBottom = UDim.new(0, TOAST.margin), UDim.new(0, TOAST.margin)
			local layout = S.create(world, "UIListLayout", "UIListLayout", made, {
				SortOrder = world.types.Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, TOAST.gap),
			})
			layout.HorizontalAlignment = world.types.Enum.HorizontalAlignment.Center
			made.Parent = assert(layer)
			stack = made
			return made
		end
		local function present(fade: Node, slide: Node, entering: boolean, done: (() -> ())?)
			local goal = if entering then 0 else 1
			if S.reduced(world) then
				slide.Value = 1
				S.animate(world, fade, Theme.motion.reducedFade, "outQuad", { GroupTransparency = goal }, done)
				return
			end
			local seconds = if entering then motion.toast.enter else motion.toast.exit
			S.animate(world, fade, seconds, "linear", { GroupTransparency = goal }, done)
			S.animate(world, slide, seconds, motion.present, { Value = 1 - goal })
		end
		local tick: (number) -> ()
		local function show(toast: Toast)
			local slot = S.create(world, "Frame", "ToastSlot", nil, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = world.types.Enum.AutomaticSize.Y,
			})
			slot.LayoutOrder = toast.id
			local row = S.create(world, "Frame", "ToastRow", slot, {
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = world.types.Enum.AutomaticSize.Y,
			})
			row.ZIndex = TOAST.z
			row.Active = false
			row.Interactable = false
			row:AddTag "pl-toast"
			local paint = S.create(world, "UIGradient", "FadePaint", row)
			local outline = S.create(world, "UIStroke", "Outline", row)
			outline:AddTag "pl-toast-outline"
			local outlinePaint = S.create(world, "UIGradient", "FadePaint", outline)
			local fade = S.create(world, "CanvasGroup", "Fade", row, {
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 0),
				AutomaticSize = world.types.Enum.AutomaticSize.Y,
			})
			local function dim()
				local amount = fade.GroupTransparency
				if type(amount) == "number" then
					local sequence = world.types.NumberSequence.new(amount)
					paint.Transparency, outlinePaint.Transparency = sequence, sequence
				end
			end
			fade.GroupTransparency = 1
			dim()
			fade:GetPropertyChangedSignal("GroupTransparency"):Connect(dim)
			local slide = S.create(world, "NumberValue", "Slide", row)
			local function follow()
				local amount = slide.Value
				if type(amount) == "number" then
					row.AnchorPoint = Vector2.new(0, 1 - amount)
					row.Position = UDim2.new(0, 0, 0, -(1 - amount) * TOAST.margin)
				end
			end
			slide.Value = 0
			follow()
			slide:GetPropertyChangedSignal("Value"):Connect(follow)
			local message = S.fill(world, S.text(world, fade, "Message", toast.message))
			message.TextWrapped = true
			message.LayoutOrder = 1
			slot.Parent = stackFor()
			toast.slot, toast.fade, toast.slide, toast.remaining = slot, fade, slide, duration
			table.insert(visible, toast)
			if stopClock == nil then
				local connection = world.heartbeat:Connect(tick)
				stopClock = function()
					connection:Disconnect()
				end
			end
			present(fade, slide, true)
		end
		local function pump()
			while #visible < TOAST.visible and #queue > 0 do
				show(assert(table.remove(queue, 1)))
			end
		end
		local function dismiss(toast: Toast)
			table.remove(visible, assert(table.find(visible, toast)))
			local slot, fade, slide = assert(toast.slot), assert(toast.fade), assert(toast.slide)
			present(fade, slide, false, function()
				slot:Destroy()
			end)
			pump()
		end
		tick = function(dt: number)
			for _, toast in table.clone(visible) do
				toast.remaining -= dt
				if toast.remaining <= 0 then
					dismiss(toast)
				end
			end
			local halt = stopClock
			if #visible == 0 and halt then
				halt()
				stopClock = nil
			end
		end
		local function push(message: string)
			sequence += 1
			table.insert(
				queue,
				{ id = sequence, message = message, slot = nil, fade = nil, slide = nil, remaining = duration }
			)
			while #queue > TOAST.queue do
				table.remove(queue)
			end
			pump()
		end
		local stop = S.mount(world, lane, function()
			local UI, Compose, Host = world.UI, world.Compose, world.Host
			local props: Types.Props = {
				Name = "Toasts",
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
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
		end, function(screen, sheet)
			layer = screen
			if sheet then
				Theme.rule(world, sheet, ".pl-toast", Theme.plate "surfaceStrong")
				Theme.rule(world, sheet, ".pl-toast::UICorner", Theme.corner(world, 8))
				Theme.rule(world, sheet, ".pl-toast::UIPadding", Theme.padding(world, 12, 8))
				Theme.rule(world, sheet, ".pl-toast-outline", {
					Color = Theme.token "hairline",
					Transparency = 0.3,
					Thickness = 1,
					ApplyStrokeMode = world.types.Enum.ApplyStrokeMode.Border,
				}, "none")
			end
		end)
		local function opacity(): string
			local found = world.target:FindFirstChild("Message", true)
			if found == nil then
				return "absent"
			end
			local remaining = 1
			local at: Node? = world.node(found)
			while at ~= nil and at ~= world.target do
				if at:IsA "CanvasGroup" and type(at.GroupTransparency) == "number" then
					remaining *= 1 - at.GroupTransparency
				end
				local parent = at.Parent
				at = if parent then world.node(parent) else nil
			end
			return S.rounded(1 - remaining, 2)
		end
		return {
			step = function(index: number)
				if index % 2 == 1 then
					local id = math.ceil(index / 2)
					if lane == "facet" then
						assert(messages):set { id }
					else
						push(`Reward {id}`)
					end
					world.frame()
				else
					S.settle(world, duration + motion.toast.enter)
					S.settle(world, motion.toast.exit)
				end
			end,
			snapshot = function()
				return `{labels(world, "Reward ")}\n{S.observe(world, { "ToastStack", "ToastRow", "Message" })}\nopacity={opacity()}`
			end,
			stop = function()
				local halt = stopClock
				if halt then
					halt()
					stopClock = nil
				end
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "tabs-5-5-switches",
	iterations = 5,
	what = "Select a peer tab and activate it, 5 times among five tabs, keeping each visited page and its content. Both lanes centre a scrolling 44-pixel tab bar, paint the current tab and its 2-pixel underline, keep each page a selection group with a per-tab focus bookmark, and enable L1 and R1 while focus is in the bar.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local selection = S.model(world, lane, "1")
		local current: string? = nil
		local expected = "1"
		local release: (() -> ())? = nil
		local tabs: { Types.Tab } = {}
		for i = 1, 5 do
			table.insert(tabs, {
				id = tostring(i),
				label = `Tab {i}`,
				content = function()
					return world.UI.Text("Page" .. i) { text = `Page {i} content` }
				end,
			})
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			return UI.TabView "Tabs" {
				selection = assert(selection),
				tabs = tabs,
				placement = "topBar",
				transition = false,
			}
		end, function(screen, sheet)
			local Enum, UDim2 = world.types.Enum, world.types.UDim2
			if sheet then
				Theme.rule(world, sheet, ".pl-tab-bar", { ScrollBarThickness = 0 })
				Theme.rule(
					world,
					sheet,
					".pl-tab",
					{ BackgroundTransparency = 1, TextColor3 = Theme.token "contentSecondary" }
				)
				Theme.rule(
					world,
					sheet,
					".pl-tab:Hover",
					{ BackgroundTransparency = 1, TextColor3 = Theme.token "content" }
				)
				Theme.rule(
					world,
					sheet,
					".pl-tab:Press",
					{ BackgroundTransparency = 1, TextColor3 = Theme.token "content" }
				)
				Theme.rule(world, sheet, ".pl-tab-current", { TextColor3 = Theme.token "content" })
				Theme.rule(world, sheet, ".pl-tab-indicator", Theme.plate "selection")
			end
			local root = S.blank(world, "Tabs", screen, UDim2.fromScale(1, 1))
			local bar = S.create(world, "ScrollingFrame", "TabBar", root, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, TAB_BAR),
				CanvasSize = UDim2.new(),
				AutomaticCanvasSize = Enum.AutomaticSize.X,
				ScrollingDirection = Enum.ScrollingDirection.X,
			})
			bar.ScrollBarThickness = 0
			bar.ZIndex = 2
			bar.SelectionGroup = true
			bar:AddTag "pl-tab-bar"
			local strip = S.stack(world, bar, "Strip", true, { gap = 4 })
			strip.Size = UDim2.fromScale(1, 1)
			strip.AutomaticSize = Enum.AutomaticSize.X
			local flow = assert(child(world, strip, "Layout"))
			flow.HorizontalAlignment = Enum.HorizontalAlignment.Center
			flow.VerticalAlignment = Enum.VerticalAlignment.Center
			local content = S.blank(world, "Content", root, UDim2.new(1, 0, 1, -(TAB_BAR + TAB_GAP)))
			content.Position = UDim2.fromOffset(0, TAB_BAR + TAB_GAP)
			local pages: { [string]: Node } = {}
			local buttons: { [string]: Node } = {}
			local marks: { [string]: Node } = {}
			local bookmarks: { [string]: Node } = {}
			local function select(id: string)
				if id == current then
					return
				end
				local gui = world.guiService
				local focused = S.selected(world)
				local leaving = false
				if current then
					local previous = pages[current]
					if inside(focused, previous) then
						leaving = true
						bookmarks[current] = assert(focused)
					end
					previous.Visible = false
					buttons[current]:RemoveTag "pl-tab-current"
					marks[current].Visible = false
				end
				current = id
				local page = pages[id]
				if page == nil then
					local made = S.blank(world, id, nil, UDim2.fromScale(1, 1))
					made.SelectionGroup = true
					S.fill(world, S.text(world, made, "Page" .. id, `Page {id} content`))
					made.Parent = content
					pages[id] = made
					page = made
				end
				local shownPage = assert(page)
				shownPage.Visible = true
				buttons[id]:AddTag "pl-tab-current"
				marks[id].Visible = true
				local bookmark = bookmarks[id]
				if gui and (leaving or (bookmark and bookmark.Parent ~= nil)) then
					local usable = bookmark ~= nil
						and inside(bookmark, shownPage)
						and bookmark.Visible == true
						and bookmark.Interactable ~= false
					gui.SelectedObject = if usable then bookmark else firstSelectable(world, shownPage) or buttons[id]
				end
			end
			for i = 1, 5 do
				local id = tostring(i)
				local button = S.button(world, strip, id, `Tab {i}`, function()
					select(id)
				end)
				button.Size = UDim2.fromOffset(0, TAB_BAR)
				button.AutomaticSize = Enum.AutomaticSize.X
				button.TextTruncate = Enum.TextTruncate.AtEnd
				button:AddTag "pl-tab"
				S.targetFloor(world, button)
				local mark = S.create(world, "Frame", "SelectionIndicator", button, {
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, TAB_INDICATOR),
				})
				mark.Position = UDim2.new(0, 0, 1, -TAB_INDICATOR)
				mark.Visible = false
				mark:AddTag "pl-tab-indicator"
				buttons[id], marks[id] = button, mark
			end
			local function shift(by: number)
				select(tostring(((tonumber(current) or 1) - 1 + by) % 5 + 1))
			end
			local bumpers = {
				S.action(world, screen, "PreviousTab", 50, { Enum.KeyCode.ButtonL1 }, function()
					shift(-1)
				end),
				S.action(world, screen, "NextTab", 50, { Enum.KeyCode.ButtonR1 }, function()
					shift(1)
				end),
			}
			local function sync()
				local focusInBar = inside(S.selected(world), bar)
				for _, context in bumpers do
					context.Enabled = focusInBar
				end
			end
			local gui = world.guiService
			if gui then
				local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(sync)
				release = function()
					connection:Disconnect()
				end
			end
			sync()
			select "1"
		end)
		local function tabButton(id: string): Node
			for _, node in world.target:GetDescendants() do
				if node:IsA "GuiButton" and node.Name == id then
					return world.node(node)
				end
			end
			error("missing tab " .. id, 0)
		end
		local function tabFacts(): string
			local rows: { string } = {}
			for i = 1, 5 do
				local button = tabButton(tostring(i))
				table.insert(rows, facts(world, "Tab" .. i, button))
				table.insert(rows, facts(world, "Underline" .. i, child(world, button, "SelectionIndicator")))
			end
			return table.concat(rows, "\n")
		end
		return {
			step = function(index: number)
				local id = tostring(index % 5 + 1)
				expected = id
				local target = tabButton(id)
				local gui = world.guiService
				if gui then
					gui.SelectedObject = target
				end
				world.fire(target, "Activated")
				world.frame()
			end,
			snapshot = function()
				local id = assert(if lane == "facet" then assert(selection):peek() else current)
				assert(id == expected, "tab input did not select the requested page")
				return `{S.find(world, "Page" .. id).Text}:{labels(world, "Page ")}\n{tabFacts()}\n{S.observe(world, {
					"Tabs",
					"Content",
					"Page1",
					"Page2",
					"Page3",
					"Page4",
					"Page5",
				})}`
			end,
			stop = function()
				if release then
					release()
				end
				stop()
			end,
		}
	end,
})

local function labelBounds(sector: Sector, inner: number, outer: number, span: number, height: number): (number, number)
	local innerSquared, outerSquared = inner * inner, outer * outer
	local sine, cosine = math.sin(math.rad(sector.angle)), math.cos(math.rad(sector.angle))
	local halfAngle = span / 2 - 2
	local threshold = math.cos(math.rad(halfAngle))
	local thresholdSquared = threshold * threshold
	local function cornerFits(x: number, y: number): boolean
		local radiusSquared = x * x + y * y
		if radiusSquared > outerSquared or halfAngle < 0 then
			return false
		end
		local projection = x * sine - y * cosine
		if threshold >= 0 then
			return projection >= 0 and projection * projection >= radiusSquared * thresholdSquared
		end
		return projection >= 0 or projection * projection <= radiusSquared * thresholdSquared
	end
	local function fits(width: number, tall: number): boolean
		local hx, hy = width / 2 + 3, tall / 2 + 3
		local nearX, nearY = math.max(0, math.abs(sector.x) - hx), math.max(0, math.abs(sector.y) - hy)
		if nearX * nearX + nearY * nearY < innerSquared then
			return false
		end
		return cornerFits(sector.x - hx, sector.y - hy)
			and cornerFits(sector.x - hx, sector.y + hy)
			and cornerFits(sector.x + hx, sector.y - hy)
			and cornerFits(sector.x + hx, sector.y + hy)
	end
	if not fits(height, height) then
		local low, high = 0, height
		for _ = 1, 14 do
			local middle = (low + high) / 2
			if fits(middle, middle) then
				low = middle
			else
				high = middle
			end
		end
		height = low
	end
	local low, high = 0, math.min(160, outer * 2)
	for _ = 1, 14 do
		local middle = (low + high) / 2
		if fits(middle, height) then
			low = middle
		else
			high = middle
		end
	end
	return low, height
end

table.insert(workloads, {
	id = "radial-15-cycles",
	iterations = 60,
	what = "Open a four-command donut radial menu from its launcher, activate Wave and let it close, 15 times, with a checkpoint in the middle of each enter and exit. Both lanes size the inner radius from the launcher with a 96-pixel ring, fit each label box to its sector, catch outside input on a transparent scrim, draw four Path2D sectors and a centre close button, spread the ring out from 0.2 scale with the theme radial timings, highlight the candidate or focused sector, hide the launcher until the exit ends, and add the modal back and radial input contexts.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local motion = S.motion(world, lane)
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
		local parent: Node? = nil
		local launcher: Node? = nil
		local closeRing: (() -> ())? = nil
		local arrangeRing: (() -> ())? = nil
		local timeline: { opening: Node?, fading: Node?, opacity: Node? } = {}
		local Enum, D2, V2 = world.types.Enum, world.types.UDim2, world.types.Vector2
		assert(motion.present == "outCubic", "the radial spread applies the theme present easing")
		local function progress(node: Node): number
			local value = node.Value
			return if type(value) == "number" then value else 0
		end
		local openRing: () -> ()
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local spec: Types.RadialMenuSpec<string> = {
				label = "Emotes",
				items = items,
				preset = "donut",
				ringWidth = RADIAL.ring,
				contentFit = "none",
				AnchorPoint = V2.new(0.5, 0.5),
				Position = D2.fromScale(0.5, 0.5),
			}
			return UI.RadialMenu "Emotes"(spec)
		end, function(screen, sheet)
			parent = screen
			if sheet then
				iconRules(world, sheet)
				Theme.utility(world, sheet, "pl-utility")
				Theme.rule(world, sheet, ".pl-glyph::UIPadding", Theme.padding(world, 0, 0))
				Theme.rule(world, sheet, ".pl-radial-sector", { Color3 = Theme.token "surfaceStrong" })
				Theme.rule(world, sheet, ".pl-radial-sector.pl-radial-candidate", { Color3 = Theme.token "selection" })
			end
			local function track(name: string): Node
				local made = S.create(world, "NumberValue", name, screen)
				made.Value = 0
				made:GetPropertyChangedSignal("Value"):Connect(function()
					local apply = arrangeRing
					if apply then
						apply()
					end
				end)
				return made
			end
			timeline.opening, timeline.fading, timeline.opacity =
				track "RadialOpening", track "RadialFading", track "RadialOpacity"
			local button = S.button(world, screen, "Launcher", "Emotes", function()
				local close = closeRing
				if close then
					close()
				else
					openRing()
				end
			end)
			button.AnchorPoint = V2.new(0.5, 0.5)
			button.Position = D2.fromScale(0.5, 0.5)
			launcher = button
		end)
		local function arc(angle: number, inner: number, outer: number): { unknown }
			local radius = (inner + outer) / 2
			local trim = math.deg(math.asin(RADIAL.gap / 2 / radius))
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
		openRing = function()
			local screen, button = assert(parent), assert(launcher)
			local extent = S.vector2(world, button.AbsoluteSize)
			local inner = math.max(RADIAL.floor, RADIAL.clearance, math.max(extent.X, extent.Y) / 2)
			local outer = inner + RADIAL.ring
			local radius = (inner + outer) / 2
			local viewport = S.vector2(world, screen.AbsoluteSize)
			local width = if viewport.X > 0 then viewport.X else 640
			local height = if viewport.Y > 0 then viewport.Y else 480
			local fx, fy = width / 2, height / 2
			if extent.X > 0 then
				local at = S.vector2(world, button.AbsolutePosition)
				fx, fy = at.X + extent.X / 2, at.Y + extent.Y / 2
			end
			local cx = math.clamp(fx, outer + 12, math.max(outer + 12, width - outer - 12))
			local cy = math.clamp(fy, outer + 20, math.max(outer + 20, height - outer - 20))
			local sectors: { Sector } = {}
			for index, label in actions do
				local angle = (index - 1) * 90
				local sector: Sector = {
					label = label,
					angle = angle,
					x = math.sin(math.rad(angle)) * radius,
					y = -math.cos(math.rad(angle)) * radius,
					width = 0,
					height = 0,
				}
				sector.width, sector.height = labelBounds(sector, inner, outer, 90, RADIAL.label)
				table.insert(sectors, sector)
			end
			local still = S.reduced(world)
			local closing = false
			local candidate: number? = nil
			local buttons: { Node } = {}
			local wedges: { Node } = {}
			local shapes: { Node } = {}
			local contexts: { Node } = {}
			local restore = function() end
			local modal = S.blank(world, "Modal", nil, D2.fromScale(1, 1))
			modal.Active = true
			modal.ZIndex = 100
			modal.SelectionGroup = true
			local panel: Node
			local commit: Node? = nil
			local focused: number? = nil
			local function highlight(index: number?)
				candidate = index
				for at, item in buttons do
					if at == candidate or at == focused then
						item:AddTag(Theme.tags.selected)
						wedges[at]:AddTag "pl-radial-candidate"
					else
						item:RemoveTag(Theme.tags.selected)
						wedges[at]:RemoveTag "pl-radial-candidate"
					end
				end
				if commit then
					commit.Enabled = index ~= nil
				end
			end
			local function ringStep(dx: number, dy: number): (number?, boolean)
				local function aligned(x: number, y: number): number
					local length = math.sqrt(x * x + y * y)
					return if length > 0 then (x * dx + y * dy) / length else -1
				end
				local current = candidate
				local best, chosen = 0, nil
				if current == nil then
					for index, sector in sectors do
						local score = aligned(sector.x, sector.y)
						if score > best then
							best, chosen = score, index
						end
					end
					return chosen, false
				end
				local here = sectors[current]
				if aligned(-here.x, -here.y) >= math.cos(math.rad(45)) then
					return nil, true
				end
				for _, step in { -1, 1 } do
					local index = (current - 1 + step) % #sectors + 1
					local score = aligned(sectors[index].x - here.x, sectors[index].y - here.y)
					if score > best then
						best, chosen = score, index
					end
				end
				return chosen, false
			end
			local opening, fading, opacity = assert(timeline.opening), assert(timeline.fading), assert(timeline.opacity)
			local function arrange()
				local shown, fade, appear = progress(opening), progress(fading), progress(opacity)
				local scale = if still
					then 1
					else Theme.motion.spread + (1 - Theme.motion.spread) * Theme.outCubic(shown) * (1 - Theme.outCubic(
						fade
					))
				for index, sector in sectors do
					buttons[index].Position = D2.fromOffset(cx + sector.x * scale, cy + sector.y * scale)
					shapes[index].Position = D2.fromOffset(cx + sector.x * (scale - 1), cy + sector.y * (scale - 1))
				end
				panel.GroupTransparency = if still then 0 else 1 - (1 - math.max(1 - shown, fade)) * appear
			end
			local function close()
				if closing then
					return
				end
				closing = true
				closeRing = nil
				modal.Interactable = false
				contexts[#contexts].Enabled = false
				highlight(nil)
				restore()
				local function finish()
					if arrangeRing == arrange then
						arrangeRing = nil
					end
					modal:Destroy()
					button.Visible = true
				end
				if still then
					fading.Value = 1
					finish()
				else
					S.animate(world, fading, motion.radial.exit, "linear", { Value = 1 }, finish)
				end
			end
			closeRing = close
			local function choose(index: number)
				if closing then
					return
				end
				selected = actions[index]
				commits += 1
				close()
			end
			local catcher = S.blank(world, "Scrim", modal, D2.fromScale(1, 1))
			catcher.Active = true
			catcher.ZIndex = 100
			local outside = S.hit(world, "DismissTarget", modal, false, D2.fromScale(1, 1))
			outside.ZIndex = 100
			outside.Activated:Connect(function(...: unknown)
				close()
			end)
			panel = S.create(world, "CanvasGroup", "RadialPanel", modal, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = D2.fromScale(1, 1),
			})
			panel.Active = true
			panel.ZIndex = 101
			panel.GroupTransparency = if still then 0 else 1
			S.trap(world, panel)
			local hit = S.hit(
				world,
				"CenterHit",
				panel,
				false,
				D2.fromOffset(math.max(RADIAL.hub, RADIAL.target), math.max(RADIAL.hub, RADIAL.target))
			)
			hit.AnchorPoint = V2.new(0.5, 0.5)
			hit.Position = D2.fromOffset(cx, cy)
			hit.ZIndex = 104
			hit.Activated:Connect(function(...: unknown)
				close()
			end)
			local hub = math.min(RADIAL.hub, 2 * inner - 4)
			local center = S.button(world, panel, "Center", "", close)
			center.Size = D2.fromOffset(hub, hub)
			center.AutomaticSize = Enum.AutomaticSize.None
			center.AnchorPoint = V2.new(0.5, 0.5)
			center.Position = D2.fromOffset(cx, cy)
			center.ZIndex = 105
			center:AddTag "pl-utility"
			center:AddTag "pl-glyph"
			S.create(world, "UICorner", "UICorner", center).CornerRadius = world.types.UDim.new(1, 0)
			local cross =
				glyph(world, center, { { { 0.26, 0.26 }, { 0.74, 0.74 } }, { { 0.74, 0.26 }, { 0.26, 0.74 } } })
			cross.AnchorPoint = V2.new(0.5, 0.5)
			cross.Position = D2.fromScale(0.5, 0.5)
			for index, sector in sectors do
				local holder = S.blank(world, "Sector-" .. sector.label, panel, D2.fromScale(1, 1))
				local shape = S.blank(world, "Paint", holder, D2.fromOffset(2 * outer, 2 * outer))
				shape.AnchorPoint = V2.new(0.5, 0.5)
				local wedge = S.create(world, "Path2D", "Sector", shape)
				wedge.Thickness = outer - inner
				wedge.Closed = false
				wedge.ZIndex = 102
				wedge:AddTag "pl-radial-sector"
				local path = (wedge :: unknown) :: S.Path
				path:SetControlPoints(arc(sector.angle, inner, outer))
				local item = S.button(world, holder, sector.label, sector.label, function()
					choose(index)
				end)
				local floor = item:FindFirstChild "TargetFloor"
				if floor then
					floor:Destroy()
				end
				item:AddTag "pl-utility"
				item:AddTag "pl-glyph"
				item.AutomaticSize = Enum.AutomaticSize.None
				item.Size = D2.fromOffset(sector.width, sector.height)
				item.AnchorPoint = V2.new(0.5, 0.5)
				item.ClipsDescendants = true
				item.TextWrapped = false
				item.ZIndex = 105
				item.MouseEnter:Connect(function(...: unknown)
					local input = world.inputService
					if input == nil or input.PreferredInput ~= Enum.PreferredInput.Touch then
						highlight(index)
					end
				end)
				item.MouseLeave:Connect(function(...: unknown)
					highlight(nil)
				end)
				item.SelectionGained:Connect(function(...: unknown)
					focused = index
					highlight(index)
				end)
				buttons[index], wedges[index], shapes[index] = item, wedge, shape
			end
			local function toward(dx: number, dy: number): () -> ()
				return function()
					local index, inward = ringStep(dx, dy)
					local gui = world.guiService
					if inward then
						highlight(nil)
						if gui then
							gui.SelectedObject = center
						end
					elseif index then
						highlight(index)
						if gui then
							gui.SelectedObject = buttons[index]
						end
					end
				end
			end
			table.insert(
				contexts,
				S.action(world, modal, "ModalBack", 2000, { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, close)
			)
			table.insert(
				contexts,
				S.inputs(world, modal, "Radial", 2200, {
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
					{ name = "Radial-up", keys = { Enum.KeyCode.DPadUp, Enum.KeyCode.Up }, pressed = toward(0, -1) },
					{
						name = "Radial-right",
						keys = { Enum.KeyCode.DPadRight, Enum.KeyCode.Right },
						pressed = toward(1, 0),
					},
					{
						name = "Radial-down",
						keys = { Enum.KeyCode.DPadDown, Enum.KeyCode.Down },
						pressed = toward(0, 1),
					},
					{
						name = "Radial-left",
						keys = { Enum.KeyCode.DPadLeft, Enum.KeyCode.Left },
						pressed = toward(-1, 0),
					},
				})
			)
			commit = child(world, contexts[#contexts], "RadialCommit")
			highlight(nil)
			button.Visible = false
			modal.Parent = screen
			if selecting(world) then
				restore = S.focus(world, buttons[1])
			end
			arrangeRing = arrange
			opening.Value = 0
			if still then
				fading.Value, opacity.Value, opening.Value = 0, 1, 1
			else
				S.animate(world, opening, motion.radial.enter, "linear", { Value = 1 })
				S.animate(world, fading, motion.radial.exit, "linear", { Value = 0 })
				S.animate(world, opacity, motion.radial.exit, "linear", { Value = 1 })
			end
			arrange()
		end
		local function sectorInk(label: string): string
			local holder = child(world, world.target, "Sector-" .. label, true)
			local path = child(world, holder, "Sector", true)
			return if path then S.rgb(world, path:GetStyled "Color3") else "absent"
		end
		local function scrim(): string
			local node = child(world, world.target, "Scrim", true)
			if node == nil then
				return "absent"
			end
			return `{S.number(node:GetStyled "BackgroundTransparency", 3)} active={tostring(node.Active)}`
		end
		local function preview(): string
			local node = child(world, world.target, "SelectionPreview", true)
			return if node and shown(world, node) then tostring(node.Text) else ""
		end
		return {
			step = function(index: number)
				local phase = (index - 1) % 4
				if phase == 0 then
					world.fire(S.find(world, "Launcher"), "Activated")
					world.frame(motion.radial.enter / 2)
				elseif phase == 2 then
					local target: Node? = nil
					for _, node in world.target:GetDescendants() do
						if node:IsA "TextButton" and node.Text == "Wave" then
							target = world.node(node)
							break
						end
					end
					expectedCommits += 1
					world.fire(assert(target, "Wave target missing"), "Activated")
					world.frame(motion.radial.exit / 2)
				else
					S.settle(world, math.max(motion.radial.enter, motion.radial.exit))
				end
				assert(commits == expectedCommits, "radial input did not commit exactly once")
			end,
			snapshot = function()
				local names = { "CenterHit", "Center", "Wave", "Dance", "Point", "Cheer" }
				local launcherNode = S.find(world, "Launcher")
				local launcherShown = shown(world, launcherNode)
				if launcherShown then
					table.insert(names, 1, "Launcher")
				end
				local inks: { string } = {}
				for _, label in actions do
					table.insert(inks, `{label}={sectorInk(label)}`)
				end
				return `{selected}\nlauncher={launcherShown} scrim={scrim()} preview={preview()}\nsectors {table.concat(
					inks,
					" "
				)}\n{S.observe(world, names)}`
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "navigation-5-6-cycles",
	iterations = 60,
	what = "Push five child pages, then select and activate each page's Back button to pop it, 6 times. Both lanes keep covered pages, show a 44-pixel bar with the destination title (left on the root, centred on child pages) and a Back button with a chevron and label, bind Escape and ButtonB to back, and move focus into the page that becomes top; the root has no Back action.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local initial: { Types.NavigationEntry<number> } = {}
		local path = S.model(world, lane, initial)
		local depth = 0
		local pages: { Node } = {}
		local remembered: { [Node]: Node } = {}
		local root: Node? = nil
		local back: Node? = nil
		local release: (() -> ())? = nil
		local UDim, UDim2, Enum = world.types.UDim, world.types.UDim2, world.types.Enum
		local plainPop: () -> ()
		local function landing(page: Node): Node?
			local destination = child(world, page, "Destination")
			return (if destination then firstSelectable(world, destination) else nil) or firstSelectable(world, page)
		end
		local function focusTop(fromInside: boolean, pushed: boolean)
			local gui = world.guiService
			if gui == nil then
				return
			end
			if not (fromInside or selecting(world) or (pushed and gui.SelectedObject ~= nil)) then
				return
			end
			local page = pages[#pages]
			local recalled = remembered[page]
			local usable = recalled ~= nil
				and recalled.Parent ~= nil
				and recalled.Visible == true
				and recalled.Selectable == true
				and recalled.Interactable ~= false
			local target = if usable then recalled else landing(page)
			if target ~= nil or fromInside then
				gui.SelectedObject = target
			end
		end
		local function plainPush(level: number)
			local stackRoot = assert(root)
			local fromInside = inside(S.selected(world), stackRoot)
			local covered = pages[#pages]
			if covered then
				covered.Visible = false
				covered.Interactable = false
			end
			local page = S.blank(world, if level == 0 then "Home" else "Details", nil, UDim2.fromScale(1, 1))
			local bar = S.blank(world, "NavigationBar", page, UDim2.new(1, 0, 0, NAV_BAR))
			local title = S.text(
				world,
				bar,
				"Title",
				if level == 0 then "Home" else "Details",
				nil,
				if level == 0 then "title" else "heading"
			)
			title.Size = UDim2.fromScale(1, 1)
			title.AutomaticSize = Enum.AutomaticSize.Y
			title.TextXAlignment = if level == 0 then Enum.TextXAlignment.Left else Enum.TextXAlignment.Center
			title.TextTruncate = Enum.TextTruncate.AtEnd
			local inset = S.create(world, "UIPadding", "UIPadding", title)
			inset.PaddingLeft, inset.PaddingRight = UDim.new(0, 12), UDim.new(0, 12)
			if level > 0 then
				local button = S.button(world, bar, "Back", "", function()
					plainPop()
				end)
				button:AddTag "pl-utility"
				button.AnchorPoint = world.types.Vector2.new(0, 0.5)
				button.Position = UDim2.fromScale(0, 0.5)
				local row = S.create(world, "Frame", "Content", button, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					AutomaticSize = Enum.AutomaticSize.XY,
				})
				local flow = S.create(world, "UIListLayout", "UIListLayout", row, {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 2),
				})
				flow.VerticalAlignment = Enum.VerticalAlignment.Center
				glyph(world, row, { { { 0.6, 0.22 }, { 0.34, 0.5 }, { 0.6, 0.78 } } }).LayoutOrder = 1
				S.text(world, row, "Title", "Back", nil, "control").LayoutOrder = 2
			end
			local destination = S.blank(world, "Destination", page, UDim2.new(1, 0, 1, -NAV_BAR))
			destination.Position = UDim2.fromOffset(0, NAV_BAR)
			S.fill(world, S.text(world, destination, "PageText" .. level, `Destination {level}`))
			page.Parent = stackRoot
			table.insert(pages, page)
			assert(back).Enabled = #pages > 1
			if level > 0 then
				focusTop(fromInside, true)
			end
		end
		plainPop = function()
			if #pages <= 1 then
				return
			end
			local fromInside = inside(S.selected(world), assert(root))
			local top = assert(table.remove(pages))
			remembered[top] = nil
			top:Destroy()
			local page = pages[#pages]
			page.Visible = true
			page.Interactable = true
			assert(back).Enabled = #pages > 1
			focusTop(fromInside, false)
		end
		local destinations: { [string]: Types.NavigationDestination<number> } = {
			level = {
				title = "Details",
				content = function(entry: { value: number }?)
					assert(entry and entry.value)
					return world.UI.Text("PageText" .. entry.value) { text = `Destination {entry.value}` }
				end,
			},
		}
		local stop = S.mount(world, lane, function()
			local UI = world.UI
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
		end, function(screen, sheet)
			if sheet then
				iconRules(world, sheet)
				Theme.utility(world, sheet, "pl-utility")
			end
			root = S.blank(world, "Navigation", screen, UDim2.fromScale(1, 1))
			back =
				S.action(world, screen, "NavigationBack", 1000, { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, plainPop)
			local gui = world.guiService
			if gui then
				local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(function()
					local page = pages[#pages]
					local focused = S.selected(world)
					if page and focused and inside(focused, page) then
						remembered[page] = focused
					end
				end)
				release = function()
					connection:Disconnect()
				end
			end
			plainPush(0)
		end)
		local function topPage(): Node?
			local found: Node? = nil
			for _, page in S.find(world, "Navigation"):GetChildren() do
				if page:IsA "GuiObject" and page.Visible == true then
					found = world.node(page)
				end
			end
			return found
		end
		local function topBack(): Node
			local bar = child(world, topPage(), "NavigationBar")
			return assert(child(world, bar, "Back"), "the top page has no Back button")
		end
		local function barFacts(): string
			local bar = child(world, topPage(), "NavigationBar")
			local button = child(world, bar, "Back")
			local content = child(world, button, "Content")
			return table.concat({
				facts(world, "Bar", bar),
				facts(world, "Title", child(world, bar, "Title")),
				facts(world, "Back", button),
				facts(world, "BackIcon", child(world, content, "LeadingIcon")),
				facts(world, "BackLabel", child(world, content, "Title")),
			}, "\n")
		end
		return {
			step = function(index: number)
				local phase = (index - 1) % 10
				if phase < 5 then
					depth += 1
					if lane == "facet" then
						local nextPath = table.clone(assert(path):peek())
						table.insert(nextPath, { id = "level", value = depth })
						assert(path):set(nextPath)
					else
						plainPush(depth)
					end
				else
					local target = topBack()
					local gui = world.guiService
					if gui then
						gui.SelectedObject = target
					end
					world.fire(target, "Activated")
					depth -= 1
				end
				world.frame()
			end,
			snapshot = function()
				local count = if lane == "facet" then #assert(path):peek() else #pages - 1
				assert(count == depth, "navigation input did not reach the requested depth")
				return `{S.find(world, "PageText" .. depth).Text}:{labels(world, "Destination ")}\n{barFacts()}\n{S.observe(
					world,
					{ "Navigation", "PageText" .. depth }
				)}`
			end,
			stop = function()
				if release then
					release()
				end
				stop()
			end,
		}
	end,
})

return workloads
