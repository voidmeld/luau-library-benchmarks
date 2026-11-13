--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"

type Point = { X: number, Y: number }
type Area = { Min: Point, Max: Point }
type Anchor = { p: number, o: number }
type Insets = {
	GetInsetArea: (Insets, unknown) -> unknown,
	GetGuiInset: (Insets) -> (unknown, unknown),
}

local DIALOG_WIDTH = 560
local MARGIN = 16
local INSET = 16
local GAP = 8
local OUTSIDE = 24
local TARGET = 44
local FADE_IN = 0.6
local FADE_OUT = 0.5
local OBSERVED = { "ModalEntry", "DialogModal", "Scrim", "Panel", "Title", "Accept1", "Accept2" }

local function present(x: number): number
	return 1 - (1 - math.clamp(x, 0, 1)) ^ 3
end

local function bands(world: Types.Engine, screen: S.Node): (Point, Point)
	local zero = { X = 0, Y = 0 }
	if world.guiService == nil then
		return zero, zero
	end
	local gui = (world.guiService :: unknown) :: Insets
	local Enum = world.types.Enum
	local ok, full, content = pcall(function(): (unknown, unknown)
		return gui:GetInsetArea(Enum.ScreenInsets.None), gui:GetInsetArea(screen.ScreenInsets)
	end)
	if ok and world.types.typeof(full) == "Rect" and world.types.typeof(content) == "Rect" then
		local outer, inner = full :: Area, content :: Area
		return { X = inner.Min.X - outer.Min.X, Y = inner.Min.Y - outer.Min.Y }, {
			X = outer.Max.X - inner.Max.X,
			Y = outer.Max.Y - inner.Max.Y,
		}
	end
	if screen.IgnoreGuiInset ~= true and screen.ScreenInsets == Enum.ScreenInsets.CoreUISafeInsets then
		local measured, topLeft: unknown, bottomRight: unknown = pcall(gui.GetGuiInset, gui)
		if measured and world.types.typeof(topLeft) == "Vector2" then
			return topLeft :: Point, if world.types.typeof(bottomRight) == "Vector2" then bottomRight :: Point else zero
		end
	end
	return zero, zero
end

local workloads: { Types.Workload } = {
	{
		id = "modal-on-modal",
		iterations = 20,
		what = "Open a confirmation over a retained dialog, close the upper dialog, then close the lower dialog. Both lanes trap selection, suspend lower input and restore focus in stack order.",
		prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
			local previousGui = world.guiService
			local motion = S.motion(world, lane)
			local gui = previousGui or world.new "GuiService"
			local priorSelection = gui.SelectedObject
			world.guiService = gui
			local presented = { S.model(world, lane, false), S.model(world, lane, false) }
			local layers: { [number]: S.Node } = {}
			local contexts: { [number]: S.Node } = {}
			local leaves: { [number]: () -> () } = {}
			local parent: S.Node? = nil
			local entry: S.Node? = nil
			local depth, accepted = 0, 0
			local expectedAccepted = 0
			local titles = { "Outer terms", "Inner confirmation" }
			local function dismiss(level: number)
				if lane == "facet" then
					assert(presented[level]):set(false)
					return
				end
				local leave = leaves[level]
				if leave then
					leaves[level] = nil
					leave()
				end
			end
			local function open(level: number)
				if lane == "facet" then
					assert(presented[level]):set(true)
					if not world.layout then
						world.pin(S.find(world, "Accept" .. level), 120, 44)
					end
					return
				end
				assert(motion.present == "outCubic", "the plain dialog curve copies the outCubic present easing")
				local screen = assert(parent)
				local UDim2, Enum = world.types.UDim2, world.types.Enum
				local root = S.create(world, "Frame", "DialogModal", nil, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
				})
				root.Active = true
				root.ZIndex = 100
				S.trap(world, root)
				local scrim = S.create(world, "ScrollingFrame", "Scrim", root, {
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					CanvasSize = UDim2.new(),
					Selectable = false,
				})
				scrim.Active = true
				scrim.ScrollBarThickness = 0
				scrim.ZIndex = 100
				scrim:AddTag(Theme.tags.scrim)
				local scrimFade = S.create(world, "UIGradient", "ScrimFade", scrim)
				local outside = S.create(world, "TextButton", "DismissTarget", root, {
					Text = "",
					AutoButtonColor = false,
					Selectable = false,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
				})
				outside.Active = true
				outside.ZIndex = 100
				local panel = S.create(world, "Frame", "Panel", root, { AutomaticSize = Enum.AutomaticSize.Y })
				panel.AnchorPoint = world.types.Vector2.new(0.5, 0.5)
				panel.Position = UDim2.fromScale(0.5, 0.5)
				panel.ZIndex = 101
				panel.SelectionGroup = true
				S.tag(panel, Theme.tags.panel, Theme.tags.flush)
				S.create(world, "UICorner", "UICorner", panel)
				local panelFade = S.create(world, "UIGradient", "FadePaint", panel)
				local fade = S.create(world, "CanvasGroup", "Fade", panel, {
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
				})
				local room = S.create(world, "ScrollingFrame", "Room", fade, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(),
					ScrollingDirection = Enum.ScrollingDirection.Y,
				})
				local limit = S.create(world, "UISizeConstraint", "RoomLimit", room)
				local regions = S.stack(world, room, "Regions", false, { fill = true, gap = GAP })
				local padding = S.create(world, "UIPadding", "UIPadding", regions)
				for _, side in { "PaddingTop", "PaddingBottom", "PaddingLeft", "PaddingRight" } do
					padding[side] = world.types.UDim.new(0, INSET)
				end
				local header = S.stack(world, regions, "Header", true, { fill = true, gap = GAP })
				assert(header:FindFirstChild "Layout").VerticalAlignment = Enum.VerticalAlignment.Center
				S.fill(world, S.text(world, header, "Title", titles[level], nil, "heading")).TextWrapped = true
				local row = S.stack(world, regions, "Actions", true, { fill = true, gap = GAP })
				assert(row:FindFirstChild "Layout").HorizontalFlex = Enum.UIFlexAlignment.Fill
				local action = S.button(world, row, "Accept" .. level, "Accept", function()
					accepted += 1
					dismiss(level)
				end)
				action.AutomaticSize = Enum.AutomaticSize.None
				action.Size = UDim2.fromOffset(0, TARGET)
				if action:FindFirstChild "TargetFloor" == nil then
					S.create(world, "UISizeConstraint", "TargetFloor", action, {
						MinSize = world.types.Vector2.new(TARGET, TARGET),
					})
				end
				local function fit()
					local extent = S.vector2(world, screen.AbsoluteSize)
					panel.Size = UDim2.fromOffset(math.max(0, math.min(DIALOG_WIDTH, extent.X - 2 * MARGIN)), 0)
					local minimum = math.min(TARGET, math.max(0, extent.Y - 32))
					limit.MaxSize = world.types.Vector2.new(math.huge, math.max(minimum, extent.Y - 4 * MARGIN))
					local near, far = bands(world, screen)
					scrim.Position = UDim2.fromOffset(-near.X, -near.Y)
					scrim.Size = UDim2.new(1, near.X + far.X, 1, near.Y + far.Y)
				end
				fit()
				local resized = screen:GetPropertyChangedSignal("AbsoluteSize"):Connect(fit)
				local presence = S.create(world, "NumberValue", "Presence", root)
				local leaving = false
				local anchor: Anchor = { p = 0, o = 0 }
				local opacity = 0
				local function progress(): number
					local value: unknown = presence.Value
					return if type(value) == "number" then value else 0
				end
				local function paint()
					local p = progress()
					if leaving then
						local cleared = 1 - present(FADE_OUT)
						opacity = if anchor.p > cleared
							then anchor.o * math.clamp((p - cleared) / (anchor.p - cleared), 0, 1)
							elseif anchor.p > 0 then anchor.o * math.clamp(p / anchor.p, 0, 1)
							else 0
					else
						local opaque = math.max(present(FADE_IN), anchor.p + 1e-3)
						opacity = anchor.o + (1 - anchor.o) * math.clamp((p - anchor.p) / (opaque - anchor.p), 0, 1)
					end
					local transparency = world.types.NumberSequence.new(1 - opacity)
					scrimFade.Transparency = transparency
					panelFade.Transparency = transparency
					fade.GroupTransparency = 1 - opacity
				end
				presence.Changed:Connect(paint)
				paint()
				local back = S.action(
					world,
					root,
					"ModalBack",
					2000,
					{ Enum.KeyCode.Escape, Enum.KeyCode.ButtonB },
					function()
						dismiss(level)
					end
				)
				outside.Activated:Connect(function(input: unknown)
					if type(input) ~= "table" and type(input) ~= "userdata" then
						return
					end
					local event = input :: { UserInputType: unknown, Position: Point? }
					local kind = event.UserInputType
					if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.Touch then
						return
					end
					local point = event.Position
					if point then
						local at, size = S.vector2(world, panel.AbsolutePosition), S.vector2(world, panel.AbsoluteSize)
						if
							point.X >= at.X - OUTSIDE
							and point.X <= at.X + size.X + OUTSIDE
							and point.Y >= at.Y - OUTSIDE
							and point.Y <= at.Y + size.Y + OUTSIDE
						then
							return
						end
					end
					dismiss(level)
				end)
				layers[level] = root
				contexts[level] = back
				root.Parent = screen
				local restore = S.focus(world, action)
				if level == 2 then
					assert(contexts[1]).Enabled = false
				end
				S.animate(world, presence, motion.dialog.enter, motion.present, { Value = 1 })
				leaves[level] = function()
					back.Enabled = false
					if level == 2 and contexts[1] then
						assert(contexts[1]).Enabled = true
					end
					restore()
					root.Interactable = false
					anchor = { p = progress(), o = opacity }
					leaving = true
					S.animate(world, presence, motion.dialog.exit, motion.present, { Value = 0 }, function()
						resized:Disconnect()
						root:Destroy()
						if layers[level] == root then
							layers[level] = nil
							contexts[level] = nil
						end
					end)
				end
			end
			local stop = S.mount(world, lane, function()
				local UI = world.Facet.controls(world.runtime, {
					types = world.types,
					services = S.services(world),
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
				local button = S.button(world, screen, "ModalEntry", "Open", function() end)
				if button:FindFirstChild "TargetFloor" == nil then
					S.create(world, "UISizeConstraint", "TargetFloor", button, {
						MinSize = world.types.Vector2.new(TARGET, TARGET),
					})
				end
			end)
			entry = S.find(world, "ModalEntry")
			gui.SelectedObject = entry
			local keyboard =
				{ UserInputType = world.types.Enum.UserInputType.Keyboard, KeyCode = world.types.Enum.KeyCode.Return }
			local settle = math.ceil((math.max(motion.dialog.enter, motion.dialog.exit) + 0.05) / S.FRAME)
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
					S.frames(world, settle, S.FRAME)
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
					local blocked = false
					for _, node in world.target:GetDescendants() do
						if
							node:IsA "GuiObject"
							and node.Active
							and node.Visible
							and (node:IsA "GuiButton" or node:IsA "ScrollingFrame")
							and node.Size == world.types.UDim2.fromScale(1, 1)
							and not base:IsDescendantOf(node)
						then
							blocked = true
						end
					end
					assert(blocked == (depth > 0), "modal did not isolate the entry control")
					assert(traps >= depth, "modal did not trap selection at each level")
					local focused = gui.SelectedObject
					local wanted = if depth > 0 then S.find(world, "Accept" .. depth) else entry
					if focused ~= wanted then
						local name = if focused then tostring((focused :: S.Node).Name) else "nil"
						error(`modal focus did not restore in stack order: depth {depth} selected {name}`, 0)
					end
					return `{accepted}:{table.concat(titlesPresent, ",")}:traps={traps}\n{S.observe(world, OBSERVED)}`
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
}

return workloads
