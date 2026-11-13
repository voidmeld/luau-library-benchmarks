--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"

type Field = S.Node & {
	Focused: Roblox.Signal<>,
	FocusLost: Roblox.Signal<boolean, unknown>,
	IsFocused: (S.Node) -> boolean,
}
type Held = { GetState: (Held) -> boolean, Released: Roblox.Signal<> }
type Dragged = {
	DragStart: Roblox.Signal<unknown>,
	DragContinue: Roblox.Signal<unknown>,
	DragEnd: Roblox.Signal<>,
}
type Point = { X: number, Y: number }
type Option = { value: string, label: string }
type Segmented = { node: S.Node, segments: { [string]: S.Node }, choose: (string) -> () }
type Adjusted = { refresh: () -> () }
type Owned = { cleanups: { () -> () } }
type InputService = S.Node & {
	GetLastInputType: (S.Node) -> unknown,
	LastInputTypeChanged: Roblox.Signal<unknown>,
	PreferredInput: unknown,
}

local SEGMENTED = "pl-segmented"
local SLIDES = "pl-segmented-slides"
local SEGMENT = "pl-segment"
local CURRENT = "pl-segment-current"
local SELECTION_FILL = "pl-segment-fill"
local STEPPER_TRACK = "pl-stepper-track"
local STEPPER_BUTTON = "pl-stepper-button"
local GLYPH = "pl-glyph"
local RAIL = "pl-slider-rail"
local SLIDER_FILL = "pl-slider-fill"
local THUMB = "pl-slider-thumb"

local SEGMENT_INSET = 3
local KNOB = 24
local REPEAT = table.freeze { delay = 0.4, interval = 0.1, burst = 5 }

local function segmentRules(world: Types.Engine, sheet: S.Node)
	local radius = Theme.radius.control + 2
	Theme.rule(world, sheet, "." .. SEGMENTED, Theme.plate "control")
	Theme.rule(world, sheet, `.{SEGMENTED}::UICorner`, Theme.corner(world, radius))
	Theme.rule(world, sheet, `.{SEGMENTED}::UIPadding`, Theme.padding(world, SEGMENT_INSET, SEGMENT_INSET))
	Theme.rule(
		world,
		sheet,
		"." .. SEGMENT,
		{ BackgroundTransparency = 1, TextColor3 = Theme.token "contentSecondary" }
	)
	Theme.rule(world, sheet, `.{SEGMENT}::UICorner`, Theme.corner(world, radius - SEGMENT_INSET))
	Theme.rule(world, sheet, "." .. SELECTION_FILL, Theme.plate "accent")
	Theme.rule(world, sheet, `.{SELECTION_FILL}::UICorner`, Theme.corner(world, radius - SEGMENT_INSET))
	Theme.rule(world, sheet, `.{SEGMENT}:Hover`, {
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.token "controlHover",
		TextColor3 = Theme.token "content",
	})
	Theme.rule(world, sheet, `.{SEGMENT}:Press`, {
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.token "controlPressed",
		TextColor3 = Theme.token "content",
	})
	Theme.rule(world, sheet, "." .. CURRENT, {
		BackgroundTransparency = 0,
		BackgroundColor3 = Theme.token "accent",
		TextColor3 = Theme.token "onAccent",
	})
	Theme.rule(world, sheet, `.{CURRENT}:Hover`, {
		BackgroundColor3 = Theme.token "accent",
		TextColor3 = Theme.token "onAccent",
	})
	Theme.rule(world, sheet, `.{CURRENT}:Press`, {
		BackgroundColor3 = Theme.token "accent",
		TextColor3 = Theme.token "onAccent",
	})
	Theme.rule(world, sheet, `.{SLIDES} > .{CURRENT}`, { BackgroundTransparency = 1 })
end

local function repeater(world: Types.Engine, holding: () -> boolean, fire: () -> (), stop: () -> ()): Roblox.Connection
	local elapsed, deadline = 0, REPEAT.delay
	return world.heartbeat:Connect(function(delta: number)
		if not holding() then
			stop()
			return
		end
		elapsed += delta
		local steps = 0
		while elapsed >= deadline and steps < REPEAT.burst do
			fire()
			deadline += REPEAT.interval
			steps += 1
		end
		if steps == REPEAT.burst then
			deadline = elapsed + REPEAT.interval
		end
	end)
end

local function channels(node: S.Node, property: string): string
	local values: { string } = {}
	for channel in string.gmatch(tostring(node:GetStyled(property)), "[%d%.%-e]+") do
		table.insert(values, tostring(math.round((tonumber(channel) or 0) * 255)))
	end
	return table.concat(values, ",")
end

local function segmented(
	world: Types.Engine,
	owned: Owned,
	name: string,
	options: { Option },
	initial: string,
	chosen: (string) -> ()
): Segmented
	local Enum, UDim, UDim2, Vector2 = world.types.Enum, world.types.UDim, world.types.UDim2, world.types.Vector2
	local track = S.create(world, "ScrollingFrame", name, nil, {
		Size = UDim2.new(1, 0, 0, 44 + 2 * SEGMENT_INSET),
		ScrollingDirection = Enum.ScrollingDirection.X,
		Selectable = false,
		AutomaticCanvasSize = Enum.AutomaticSize.None,
		CanvasSize = UDim2.fromScale(1, 1),
		ClipsDescendants = false,
	})
	track.ScrollingEnabled = false
	track.ScrollBarThickness = 0
	track.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	track:AddTag(SEGMENTED)
	local layout = S.create(world, "UIListLayout", "UIListLayout", track, {
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
	})
	layout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	local segments: { [string]: S.Node } = {}
	local orders: { S.Node } = {}
	local limits: { S.Node } = {}
	local current = initial
	local spring: S.SpringState = { position = 0, velocity = 0, reference = 0, target = 0 }
	local slide = S.create(world, "Folder", "Slide", track)
	local unit = S.create(world, "Frame", "SlideUnit", slide, { Size = UDim2.fromScale(1, 1) })
	unit.Visible = false
	local fill = S.create(world, "Frame", "SelectionFill", slide)
	fill.ZIndex = 0
	fill.Active = false
	fill.Visible = false
	fill:AddTag(SELECTION_FILL)
	local glide = S.spring(Theme.motion.springs.control)
	local stepping: Roblox.Connection? = nil
	local function rectAt(order: number): (Point?, Point?)
		local box = orders[order]
		if box == nil then
			return nil, nil
		end
		local whole, origin = S.vector2(world, unit.AbsoluteSize), S.vector2(world, unit.AbsolutePosition)
		local room = S.vector2(world, layout.AbsoluteContentSize)
		local at, size = S.vector2(world, box.AbsolutePosition), S.vector2(world, box.AbsoluteSize)
		if whole.X <= 0 or whole.Y <= 0 then
			return nil, nil
		end
		local x = math.clamp(at.X - origin.X, 0, room.X)
		local y = math.clamp(at.Y - origin.Y, 0, room.Y)
		return { X = x / whole.X, Y = y / whole.Y }, {
			X = math.min(size.X, room.X - x) / whole.X,
			Y = math.min(size.Y, room.Y - y) / whole.Y,
		}
	end
	local function render()
		local room = S.vector2(world, layout.AbsoluteContentSize)
		local low = math.floor(spring.position)
		local t = spring.position - low
		local fromAt, fromSize = rectAt(low)
		local toAt, toSize = rectAt(low + 1)
		if room.X <= 0 or room.Y <= 0 then
			fromAt = nil
		elseif fromAt == nil or (t > 0 and toAt == nil) then
			fromAt, fromSize = rectAt(spring.target)
			t = 0
		end
		if fromAt and fromSize then
			local at, size = fromAt, fromSize
			if t > 0 and toAt and toSize then
				at = { X = fromAt.X + (toAt.X - fromAt.X) * t, Y = fromAt.Y + (toAt.Y - fromAt.Y) * t }
				size = { X = fromSize.X + (toSize.X - fromSize.X) * t, Y = fromSize.Y + (toSize.Y - fromSize.Y) * t }
			end
			fill.Position = UDim2.fromScale(at.X, at.Y)
			fill.Size = UDim2.fromScale(size.X, size.Y)
			fill.Visible = true
			track:AddTag(SLIDES)
		else
			fill.Visible = false
			track:RemoveTag(SLIDES)
		end
	end
	local function settle()
		if stepping then
			stepping:Disconnect()
			stepping = nil
		end
	end
	local function advance(delta: number)
		if glide(spring, delta) then
			settle()
		end
		render()
	end
	local function choose(value: string)
		current = value
		for index, option in options do
			local segment = segments[option.value]
			if option.value == value then
				segment:AddTag(CURRENT)
				spring.reference, spring.target = spring.position, index
			else
				segment:RemoveTag(CURRENT)
			end
		end
		if stepping == nil and spring.position ~= spring.target then
			stepping = world.heartbeat:Connect(advance)
		end
	end
	for index, option in options do
		local segment = S.button(world, track, option.value, option.label, function()
			if current ~= option.value then
				choose(option.value)
				chosen(option.value)
			end
		end)
		segment.LayoutOrder = index
		segment.AutomaticSize = Enum.AutomaticSize.X
		segment:AddTag(SEGMENT)
		limits[index] = S.create(world, "UISizeConstraint", "UISizeConstraint", segment, {
			MinSize = Vector2.new(44 - 24, 0),
		})
		local flex = S.create(world, "UIFlexItem", "UIFlexItem", segment)
		flex.FlexMode = Enum.UIFlexMode.Grow
		segments[option.value] = segment
		orders[index] = segment
		if option.value == initial then
			segment:AddTag(CURRENT)
			spring.position, spring.reference, spring.target = index, index, index
		end
		for _, property in { "AbsolutePosition", "AbsoluteSize" } do
			segment:GetPropertyChangedSignal(property):Connect(render)
		end
	end
	local function measured()
		local width = S.vector2(world, track.AbsoluteSize).X
		for _, limit in limits do
			limit.MaxSize = Vector2.new(math.max(44, width - 2 * SEGMENT_INSET), math.huge)
		end
		render()
	end
	track:GetPropertyChangedSignal("AbsoluteSize"):Connect(measured)
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(render)
	for _, property in { "AbsolutePosition", "AbsoluteSize" } do
		unit:GetPropertyChangedSignal(property):Connect(render)
	end
	table.insert(owned.cleanups, settle)
	return { node = track, segments = segments, choose = choose }
end

local function adjustment(
	world: Types.Engine,
	screen: S.Node,
	owned: Owned,
	node: S.Node,
	read: () -> number,
	bounds: { min: number, max: number },
	apply: (number) -> (),
	cancel: (() -> ())?
): Adjusted
	local Enum = world.types.Enum
	local gui = world.guiService
	local held: S.Node? = nil
	local repeating: Roblox.Connection? = nil
	local entries: { { context: S.Node, direction: number, arrow: boolean } } = {}
	local cancelling: S.Node? = nil
	local inside = false
	local function active(): boolean
		return gui ~= nil and gui.SelectedObject == node and node.Interactable ~= false
	end
	local function movable(direction: number): boolean
		local value = read()
		return if direction < 0 then value > bounds.min else value < bounds.max
	end
	local function release()
		held = nil
		if repeating then
			repeating:Disconnect()
			repeating = nil
		end
	end
	local function start(action: S.Node, direction: number)
		release()
		if not active() or not movable(direction) then
			return
		end
		local state = (action :: unknown) :: Held
		local engaged = state:GetState()
		apply(direction)
		held = action
		repeating = repeater(world, function(): boolean
			return held == action and active() and movable(direction) and not (engaged and not state:GetState())
		end, function()
			apply(direction)
		end, release)
	end
	local function bind(name: string, keys: { unknown }, direction: number, arrow: boolean)
		local action: S.Node
		local label = "Adjust" .. name
		local context = S.action(world, screen, label, 250, keys, function()
			start(action, direction)
		end)
		action = world.node(assert(context:FindFirstChild(label)))
		local released = (action :: unknown) :: Held
		released.Released:Connect(function()
			if held == action then
				release()
			end
		end)
		table.insert(entries, { context = context, direction = direction, arrow = arrow })
	end
	bind("Decrease", { Enum.KeyCode.Comma, Enum.KeyCode.ButtonL1 }, -1, false)
	bind("Increase", { Enum.KeyCode.Period, Enum.KeyCode.ButtonR1 }, 1, false)
	bind("DecreaseArrow", { Enum.KeyCode.Left, Enum.KeyCode.DPadLeft }, -1, true)
	bind("IncreaseArrow", { Enum.KeyCode.Right, Enum.KeyCode.DPadRight }, 1, true)
	if cancel then
		cancelling = S.action(world, screen, "AdjustCancel", 100, { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, cancel)
	end
	local function refresh()
		local now = active()
		if inside and not now and cancel then
			cancel()
		end
		inside = now
		for _, entry in entries do
			entry.context.Enabled = now and (not entry.arrow or movable(entry.direction))
		end
		if cancelling then
			cancelling.Enabled = now
		end
		if not now then
			release()
		end
	end
	if gui then
		local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(refresh)
		table.insert(owned.cleanups, function()
			connection:Disconnect()
		end)
	end
	table.insert(owned.cleanups, release)
	refresh()
	return { refresh = refresh }
end

local function quantize(value: number, bounds: { min: number, max: number, step: number }): number
	local clamped = math.clamp(value, bounds.min, bounds.max)
	return math.clamp(
		bounds.min + math.floor((clamped - bounds.min) / bounds.step + 0.5) * bounds.step,
		bounds.min,
		bounds.max
	)
end

local function stepped(value: number, direction: number, bounds: { min: number, max: number, step: number }): number
	local delta = bounds.step * (if direction < 0 then -1 else 1)
	local nextValue = quantize(math.clamp(value, bounds.min, bounds.max) + delta, bounds)
	return if nextValue == quantize(value, bounds)
		then math.clamp(nextValue + delta, bounds.min, bounds.max)
		else nextValue
end

local function formatted(value: number): string
	if value == 0 then
		return "0"
	end
	if value % 1 == 0 then
		return string.format("%d", value)
	end
	local text = string.gsub(string.gsub(string.format("%.2f", value), "0+$", ""), "%.$", "")
	return if text == "-0" then "0" else text
end

local function release(owned: Owned)
	for index = #owned.cleanups, 1, -1 do
		owned.cleanups[index]()
	end
	table.clear(owned.cleanups)
end

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "settings-17-values",
	iterations = 17,
	what = "Change ten toggles, four sliders and three segmented pickers; native value readouts show the result. Toggles and picker segments change through their Activated input, sliders through the model in headless worlds and a track drag in Studio. While a slider holds native selection, its arrow, shoulder and cancel InputContexts follow its value; the picker selection fill slides with the theme control spring.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local toggles: { Types.Value<boolean> } = {}
		local sliders: { Types.Value<number> } = {}
		local pickers: { Types.Value<string> } = {}
		if lane == "facet" then
			for _ = 1, 10 do
				table.insert(toggles, world.Compose.cell(false))
			end
			for _ = 1, 4 do
				table.insert(sliders, world.Compose.cell(0))
			end
			for _ = 1, 3 do
				table.insert(pickers, world.Compose.cell "low")
			end
		end
		local options: { Option } = { { value = "low", label = "Low" }, { value = "high", label = "High" } }
		local range = { min = 0, max = 1, step = 0.1 }
		local owned: Owned = { cleanups = {} }
		local valueNodes: { S.Node } = {}
		local plainToggles: { boolean } = table.create(10, false)
		local plainSliders: { number } = table.create(4, 0)
		local setSlider: (number, number) -> () = function() end
		local mounted = S.mount(world, lane, function()
			local UI = world.UI
			local children: { Types.Node } = {}
			for i, value in toggles do
				table.insert(
					children,
					UI.Toggle("Toggle" .. i) { label = `Option {i}`, value = value, presentation = "button" }
				)
			end
			for i, value in sliders do
				table.insert(children, UI.Slider("Slider" .. i) { value = value, min = 0, max = 1, step = 0.1 })
			end
			for i, selected in pickers do
				table.insert(
					children,
					UI.Picker("Picker" .. i) { selected = assert(selected), options = options, style = "segmented" }
				)
			end
			for i = 1, 17 do
				table.insert(
					children,
					UI.Text("Value" .. i) {
						text = function(use: Types.Use)
							if i <= 10 then
								return if use(toggles[i]) then "1" else "0"
							end
							if i <= 14 then
								return tostring(use(sliders[i - 10]))
							end
							return if use(pickers[i - 14]) == "high" then "1" else "0"
						end,
					}
				)
			end
			return UI.VStack "Settings" { width = 640, gap = 8, table.unpack(children) }
		end, function(screen, sheet)
			local Enum, UDim, UDim2, Vector2 =
				world.types.Enum, world.types.UDim, world.types.UDim2, world.types.Vector2
			segmentRules(world, sheet)
			for _, role in { { RAIL, "control" }, { SLIDER_FILL, "selection" }, { THUMB, "accent" } } do
				Theme.rule(world, sheet, "." .. role[1], Theme.plate(role[2]))
			end
			local root = S.stack(world, nil, "Settings", false, { width = 640, gap = 8 })
			for i = 1, 10 do
				local toggle: S.Node
				toggle = S.button(world, root, "Toggle" .. i, `Option {i}`, function()
					plainToggles[i] = not plainToggles[i]
					if plainToggles[i] then
						toggle:AddTag(Theme.tags.selected)
					else
						toggle:RemoveTag(Theme.tags.selected)
					end
					S.setText(world, valueNodes[i], if plainToggles[i] then "1" else "0")
				end)
			end
			local parts: { { fill: S.Node, thumb: S.Node, readout: S.Node, adjusted: Adjusted? } } = {}
			setSlider = function(index: number, value: number)
				local nextValue = quantize(value, range)
				if plainSliders[index] == nextValue then
					return
				end
				plainSliders[index] = nextValue
				local part = parts[index]
				local fraction = (nextValue - range.min) / (range.max - range.min)
				local shift = math.round((0.5 - fraction) * KNOB)
				part.fill.Size = UDim2.new(fraction, shift, 0, 6)
				part.thumb.Position = UDim2.new(fraction, shift, 0.5, 0)
				S.setText(world, part.readout, formatted(nextValue))
				S.setText(world, valueNodes[10 + index], tostring(nextValue))
				if part.adjusted then
					part.adjusted.refresh()
				end
			end
			local input = if world.inputService then (world.inputService :: unknown) :: InputService else nil
			local drags: { S.Node } = {}
			local lastInput: unknown = if input then input:GetLastInputType() else nil
			local function pointer(): boolean
				local preferred: unknown = if input then input.PreferredInput else nil
				return preferred ~= Enum.PreferredInput.Gamepad and lastInput ~= Enum.UserInputType.Keyboard
			end
			for i = 1, 4 do
				local slider = S.create(world, "Frame", "Slider" .. i, nil, {
					BackgroundTransparency = 1,
					Selectable = true,
					Size = UDim2.fromScale(1, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
				})
				local row = S.create(world, "UIListLayout", "UIListLayout", slider, {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 8),
				})
				row.VerticalAlignment = Enum.VerticalAlignment.Center
				local track = S.create(world, "Frame", "Track", slider, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(0, 44),
				})
				track.LayoutOrder = 1
				local function bar(name: string, role: string): S.Node
					local node = S.create(world, "Frame", name, track, { Size = UDim2.new(1, 0, 0, 6) })
					node.AnchorPoint = Vector2.new(0, 0.5)
					node.Position = UDim2.fromScale(0, 0.5)
					node:AddTag(role)
					S.create(world, "UICorner", "UICorner", node).CornerRadius = UDim.new(0, 3)
					return node
				end
				bar("Rail", RAIL)
				local fill = bar("Fill", SLIDER_FILL)
				fill.Size = UDim2.new(0, KNOB / 2, 0, 6)
				local stop = S.create(world, "Frame", "ThumbStop", track, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(44, 44),
				})
				stop.AnchorPoint = Vector2.new(0.5, 0.5)
				stop.Position = UDim2.new(0, KNOB / 2, 0.5, 0)
				stop.ZIndex = 3
				local thumb = S.create(world, "Frame", "Thumb", stop, { Size = UDim2.fromOffset(KNOB, KNOB) })
				thumb.AnchorPoint = Vector2.new(0.5, 0.5)
				thumb.Position = UDim2.fromScale(0.5, 0.5)
				thumb:AddTag(THUMB)
				S.create(world, "UICorner", "UICorner", thumb).CornerRadius = UDim.new(1, 0)
				S.create(world, "UICorner", "UICorner", stop).CornerRadius = UDim.new(0.5, 0)
				local detector = S.create(world, "UIDragDetector", "Drag", track)
				detector.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				detector.Enabled = pointer()
				table.insert(drags, detector)
				S.create(world, "UISizeConstraint", "UISizeConstraint", track, { MinSize = Vector2.new(44, 44) })
				S.create(world, "UIFlexItem", "UIFlexItem", track).FlexMode = Enum.UIFlexMode.Fill
				local readout = S.create(world, "TextLabel", "Value", slider, {
					Text = "0",
					Size = UDim2.fromOffset(44, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					TextXAlignment = Enum.TextXAlignment.Right,
				})
				readout.LayoutOrder = 2
				S.tag(readout, Theme.tags.text, Theme.tags.body)
				parts[i] = { fill = fill, thumb = stop, readout = readout }
				local snapshot: number? = nil
				local function drive(position: unknown)
					if snapshot == nil then
						return
					end
					local point = S.vector2(world, position).X - S.vector2(world, track.AbsolutePosition).X
					local length = S.vector2(world, track.AbsoluteSize).X
					if length <= 0 then
						return
					end
					local travel = length - KNOB
					local fraction = if travel > 0 then (point - KNOB / 2) / travel else 0.5
					setSlider(i, range.min + math.clamp(fraction, 0, 1) * (range.max - range.min))
				end
				local function cancel()
					local restore = snapshot
					snapshot = nil
					if restore ~= nil then
						setSlider(i, restore)
					end
				end
				local signals = (detector :: unknown) :: Dragged
				signals.DragStart:Connect(function(position: unknown)
					snapshot = plainSliders[i]
					drive(position)
				end)
				signals.DragContinue:Connect(drive)
				signals.DragEnd:Connect(function()
					snapshot = nil
				end)
				parts[i].adjusted = adjustment(
					world,
					screen,
					owned,
					slider,
					function(): number
						return plainSliders[i]
					end,
					range,
					function(direction: number)
						setSlider(i, stepped(plainSliders[i], direction, range))
					end,
					cancel
				)
				slider.Parent = root
				slider.LayoutOrder = 10 + i
			end
			if input then
				local function sync()
					local allowed = pointer()
					for _, detector in drags do
						detector.Enabled = allowed
					end
				end
				local preferred = input:GetPropertyChangedSignal("PreferredInput"):Connect(sync)
				local changed = input.LastInputTypeChanged:Connect(function(kind: unknown)
					lastInput = kind
					sync()
				end)
				table.insert(owned.cleanups, function()
					preferred:Disconnect()
					changed:Disconnect()
				end)
			end
			for i = 1, 3 do
				local picker = segmented(world, owned, "Picker" .. i, options, "low", function(value: string)
					S.setText(world, valueNodes[14 + i], if value == "high" then "1" else "0")
				end)
				picker.node.LayoutOrder = 14 + i
				picker.node.Parent = root
			end
			for i = 1, 17 do
				valueNodes[i] = S.fill(world, S.text(world, root, "Value" .. i, "0", true))
				valueNodes[i].LayoutOrder = 17 + i
			end
			root.Parent = screen
		end)
		local function stop()
			release(owned)
			mounted()
		end
		local function part(name: string, index: number, child: string): S.Node
			local container = S.find(world, name .. index)
			return world.node(assert(container:FindFirstChild(child, true), "missing " .. child))
		end
		local function round(value: number): string
			return string.format("%.0f", value)
		end
		local function geometry(node: S.Node): string
			local at, size = S.vector2(world, node.AbsolutePosition), S.vector2(world, node.AbsoluteSize)
			return `{round(at.X)},{round(at.Y)} {round(size.X)}x{round(size.Y)}`
		end
		local names =
			{ "Settings", "Track", "Rail", "Fill", "ThumbStop", "Thumb", "Value", "low", "high", "SelectionFill" }
		for i = 1, 10 do
			table.insert(names, "Toggle" .. i)
		end
		for i = 1, 4 do
			table.insert(names, "Slider" .. i)
		end
		for i = 1, 3 do
			table.insert(names, "Picker" .. i)
		end
		for i = 1, 17 do
			table.insert(names, "Value" .. i)
		end
		return {
			step = function(index: number)
				if index <= 10 then
					S.fire(world, "Toggle" .. index, "Activated")
				elseif index <= 14 then
					local slider = index - 10
					local drag = world.drag
					if drag then
						local node = S.find(world, "Slider" .. slider)
						local extent = S.vector2(world, node.AbsoluteSize)
						drag(node, node, { X = extent.X - 1, Y = extent.Y / 2 })
					elseif lane == "facet" then
						sliders[slider]:set(1)
					else
						setSlider(slider, 1)
					end
				else
					local picker = index - 14
					world.fire(part("Picker", picker, "high"), "Activated")
				end
				world.frame()
			end,
			snapshot = function()
				local rows = { S.observe(world, names) }
				do
					for i = 1, 4 do
						local fill, thumb = part("Slider", i, "Fill"), part("Slider", i, "ThumbStop")
						table.insert(
							rows,
							`Slider{i}: fill={geometry(fill)} thumb={geometry(thumb)} paint={channels(
								fill,
								"BackgroundColor3"
							)}`
						)
					end
					for i = 1, 3 do
						local fill = part("Picker", i, "SelectionFill")
						local facts = { `Picker{i}: fill={geometry(fill)} shown={fill.Visible}` }
						for _, key in { "low", "high" } do
							local segment = part("Picker", i, key)
							table.insert(
								facts,
								`{key}={channels(segment, "TextColor3")}/{string.format(
									"%.3f",
									tonumber(segment:GetStyled "BackgroundTransparency") or -1
								)}`
							)
						end
						table.insert(rows, table.concat(facts, " "))
					end
				end
				return table.concat(rows, "\n")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "text-input-200",
	iterations = 200,
	what = "Type 200 characters through a native TextBox; validation rejects punctuation and accepts letters. While the field edits, an InputContext holds the arrow keys and Escape or ButtonB cancels to the text at focus; the 100th character is followed by a cancel and the next by a new focus.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local value = S.model(world, lane, "")
		local function validate(proposed: string): string?
			return if string.find(proposed, "[^a-z]") then nil else proposed
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			return UI.TextInput "Name" { value = assert(value), validate = validate, placeholder = "Player name" }
		end, function(screen, sheet)
			local Enum = world.types.Enum
			Theme.fields(world, sheet)
			local input = S.create(world, "TextBox", "Name", nil, {
				Text = "",
				PlaceholderText = "Player name",
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = world.types.UDim2.new(1, 0, 0, 44),
			})
			local field = (input :: unknown) :: Field
			input.TextYAlignment = Enum.TextYAlignment.Center
			S.tag(input, Theme.tags.text, Theme.tags.body, Theme.tags.field)
			S.padding(world, input, Theme.fieldInset.x, Theme.fieldInset.y)
			local accepted, snapshot, editing, writing = "", "", false, false
			local function write(text: string)
				writing = true
				input.Text = text
				writing = false
			end
			local holding: S.Node, cancelling: S.Node
			local function edit(on: boolean)
				editing = on
				holding.Enabled, cancelling.Enabled = on, on
			end
			local function cancel()
				if not editing then
					return
				end
				edit(false)
				accepted = snapshot
				write(accepted)
				if field:IsFocused() then
					input:ReleaseFocus()
				end
			end
			holding, cancelling = S.editing(world, screen, cancel)
			edit(false)
			field.Focused:Connect(function()
				if not editing then
					snapshot = accepted
					edit(true)
				end
			end)
			field.FocusLost:Connect(function(_entered: boolean, cause: unknown)
				local key = if type(cause) == "table" or type(cause) == "userdata"
					then ((cause :: unknown) :: { KeyCode: unknown }).KeyCode
					else nil
				if key == Enum.KeyCode.Escape or key == Enum.KeyCode.ButtonB then
					cancel()
				elseif editing then
					edit(false)
					write(accepted)
				end
			end)
			input:GetPropertyChangedSignal("Text"):Connect(function()
				local proposed = input.Text
				if writing or not editing or type(proposed) ~= "string" then
					return
				end
				accepted = validate(proposed) or accepted
				if proposed ~= accepted then
					write(accepted)
				end
			end)
			input.Parent = screen
		end)
		S.fire(world, "Name", "Focused")
		local editor = S.find(world, "Name")
		local field = (editor :: unknown) :: Field
		local cancelAt = 100
		return {
			step = function(index: number)
				if index == cancelAt + 1 then
					S.fire(world, "Name", "Focused")
				end
				local text = editor.Text
				assert(type(text) == "string")
				editor.Text = text .. (if index % 10 == 0 then "!" else "a")
				if index == cancelAt then
					local escape = world.types.Enum.KeyCode.Escape
					if world.key and field:IsFocused() then
						world.key(escape)
					else
						world.fire(editor, "FocusLost", false, { KeyCode = escape })
					end
				end
			end,
			snapshot = function()
				return S.observe(world, { "Name" })
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "button-feedback-50",
	iterations = 15,
	what = "Visit 15 of 50 buttons through Hover, Press and Idle, one frame each. Facet uses its theme state rules; plain uses its own Hover and Press StyleRules with the same colours and timings. Checkpoints compare the styled paint during the release transition and after it settles; the Studio driver uses real mouse input.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local count, visits, settle = 50, 15, 5
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local children: { Types.Node } = {}
			for i = 1, count do
				table.insert(children, UI.Button("Action" .. i) { label = `Action {i}`, onActivate = function() end })
			end
			return UI.Grid "Actions" { columns = 5, gap = 8, table.unpack(children) }
		end, function(screen)
			local root = S.grid(world, screen, "Actions", 5)
			for i = 1, count do
				S.button(world, root, "Action" .. i, `Action {i}`, function() end)
			end
		end)
		local buttons = {}
		for i = 1, count do
			table.insert(buttons, S.find(world, "Action" .. i))
		end
		local visited, trail = 0, ""
		return {
			step = function(index: number)
				local button = buttons[index]
				local seen = { channels(button, "BackgroundColor3") }
				for _, state in
					{ world.types.Enum.GuiState.Hover, world.types.Enum.GuiState.Press, world.types.Enum.GuiState.Idle }
				do
					world.poke(button, "GuiState", state)
					assert(button.GuiState == state, "button feedback did not reach the requested state")
					world.frame()
					table.insert(seen, channels(button, "BackgroundColor3"))
				end
				visited, trail = index, table.concat(seen, ">")
			end,
			snapshot = function()
				local names = { "Actions" }
				if visited > settle then
					table.insert(names, "Action" .. visited - settle)
				end
				local moving = visited > 0 and visited < visits
				if moving then
					table.insert(names, "Action" .. visited)
				end
				return S.observe(world, names) .. (if moving and S.simulated(world) then `\ntrail={trail}` else "")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "stepper-segments-100",
	iterations = 100,
	what = "Change a bounded quantity and a segmented choice 100 times, then render one frame. Every tenth change goes through the Increase button and a segment's Activated input, the rest through the application model. The stepper has 44-pixel Decrease and Increase icon buttons that repeat while held and disable at the limits; the picker selection fill slides with the theme control spring.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local quantity, selected = S.model(world, lane, 0), S.model(world, lane, "a")
		local options: { Option } = { { value = "a", label = "Solo" }, { value = "b", label = "Team" } }
		local bounds = { min = 0, max = 100 }
		local owned: Owned = { cleanups = {} }
		local count, choice = 0, "a"
		local setQuantity: (number) -> () = function() end
		local picker: Segmented? = nil
		local summary: S.Node? = nil
		local mounted = S.mount(world, lane, function()
			local UI = world.UI
			return UI.VStack "Choices" {
				width = 640,
				gap = 8,
				UI.Stepper "Quantity" { value = assert(quantity), min = 0, max = 100 },
				UI.Picker "Mode" { selected = assert(selected), options = options, style = "segmented" },
				UI.Text "Summary" {
					text = function(use: Types.Use)
						return `{use(assert(quantity))}:{use(assert(selected))}`
					end,
				},
			}
		end, function(screen, sheet)
			local Enum, UDim, UDim2, Vector2 =
				world.types.Enum, world.types.UDim, world.types.UDim2, world.types.Vector2
			segmentRules(world, sheet)
			Theme.rule(world, sheet, "." .. STEPPER_TRACK, Theme.plate "control")
			Theme.rule(world, sheet, `.{STEPPER_TRACK}::UICorner`, Theme.corner(world, Theme.radius.control))
			Theme.utility(world, sheet, STEPPER_BUTTON)
			Theme.rule(world, sheet, `.{STEPPER_BUTTON}.{Theme.tags.disabled}`, { BackgroundTransparency = 0.6 })
			Theme.rule(world, sheet, `.{GLYPH} > Path2D`, { Color3 = Theme.token "content" })
			local root = S.stack(world, nil, "Choices", false, { width = 640, gap = 8 })
			local stepper = S.create(world, "Frame", "Quantity", nil, {
				BackgroundTransparency = 1,
				Selectable = true,
				Size = UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
			})
			local content = S.create(world, "Frame", "Content", stepper, {
				BackgroundTransparency = 1,
				Size = UDim2.fromOffset(0, 44),
				AutomaticSize = Enum.AutomaticSize.X,
			})
			local row = S.create(world, "UIListLayout", "UIListLayout", content, {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 12),
			})
			row.VerticalAlignment = Enum.VerticalAlignment.Center
			local controls = S.create(world, "Frame", "Controls", content, {
				Size = UDim2.fromOffset(0, 44),
				AutomaticSize = Enum.AutomaticSize.X,
			})
			controls.LayoutOrder = 2
			controls:AddTag(STEPPER_TRACK)
			local strip = S.create(world, "UIListLayout", "UIListLayout", controls, {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			})
			strip.VerticalAlignment = Enum.VerticalAlignment.Center
			local padding = S.create(world, "UIPadding", "UIPadding", controls)
			padding.PaddingLeft, padding.PaddingRight = UDim.new(0, 2), UDim.new(0, 2)
			local readout = S.create(world, "TextLabel", "Value", controls, {
				Text = "0",
				Size = UDim2.fromOffset(40, 44),
			})
			readout.LayoutOrder = 2
			readout.TextYAlignment = Enum.TextYAlignment.Center
			S.tag(readout, Theme.tags.text, Theme.tags.body)
			local buttons: { [number]: S.Node } = {}
			local function allowed(direction: number): boolean
				return if direction < 0 then count > bounds.min else count < bounds.max
			end
			local painted: { [number]: boolean } = {}
			local function paint()
				for direction, button in buttons do
					local open = allowed(direction)
					if painted[direction] ~= open then
						painted[direction] = open
						button.Interactable = open
						if open then
							button:RemoveTag(Theme.tags.disabled)
						else
							button:AddTag(Theme.tags.disabled)
						end
					end
				end
			end
			setQuantity = function(value: number)
				local nextValue = math.clamp(value, bounds.min, bounds.max)
				if nextValue == count then
					return
				end
				count = nextValue
				S.setText(world, readout, tostring(count))
				S.setText(world, assert(summary), `{count}:{choice}`)
				paint()
			end
			for _, entry in
				{
					{ name = "Decrease", direction = -1, strokes = { { 0.22, 0.5, 0.78, 0.5 } } },
					{
						name = "Increase",
						direction = 1,
						strokes = { { 0.5, 0.22, 0.5, 0.78 }, { 0.22, 0.5, 0.78, 0.5 } },
					},
				}
			do
				local direction = entry.direction
				local repeated = false
				local button = S.button(world, controls, entry.name, "", function()
					if not repeated and allowed(direction) then
						setQuantity(count + direction)
					end
					repeated = false
				end)
				button.Size = UDim2.fromOffset(44, 44)
				button.AutomaticSize = Enum.AutomaticSize.None
				button.Selectable = false
				button.LayoutOrder = if direction < 0 then 1 else 3
				button:AddTag(STEPPER_BUTTON)
				local icon = S.create(world, "ImageLabel", "LeadingIcon", button, {
					BackgroundTransparency = 1,
					Size = UDim2.fromOffset(20, 20),
				})
				icon.AnchorPoint = Vector2.new(0.5, 0.5)
				icon.Position = UDim2.fromScale(0.5, 0.5)
				icon:AddTag(GLYPH)
				for _, line in entry.strokes do
					local stroke = S.create(world, "Path2D", "Stroke", icon)
					stroke.Thickness = 20 / 12
					local path = (stroke :: unknown) :: S.Path
					path:SetControlPoints {
						world.types.Path2DControlPoint.new(UDim2.fromScale(line[1], line[2]), UDim2.new(), UDim2.new()),
						world.types.Path2DControlPoint.new(UDim2.fromScale(line[3], line[4]), UDim2.new(), UDim2.new()),
					}
				end
				local held = false
				local beat: Roblox.Connection? = nil
				local function stop()
					held = false
					if beat then
						beat:Disconnect()
						beat = nil
					end
				end
				local events = (button :: unknown) :: { InputEnded: Roblox.Signal<unknown> }
				button.InputBegan:Connect(function(input: unknown)
					local facts = (input :: unknown) :: { UserInputType: unknown, KeyCode: unknown }
					local presses: { unknown } = {
						Enum.UserInputType.MouseButton1,
						Enum.UserInputType.Touch,
						Enum.KeyCode.ButtonA,
						Enum.KeyCode.Return,
						Enum.KeyCode.Space,
					}
					if
						not allowed(direction)
						or not (table.find(presses, facts.UserInputType) or table.find(presses, facts.KeyCode))
					then
						return
					end
					stop()
					held, repeated = true, false
					beat = repeater(world, function(): boolean
						return held and allowed(direction) and button.Interactable ~= false
					end, function()
						repeated = true
						setQuantity(count + direction)
					end, stop)
				end)
				events.InputEnded:Connect(stop)
				button.MouseLeave:Connect(stop)
				table.insert(owned.cleanups, stop)
				buttons[direction] = button
			end
			paint()
			adjustment(
				world,
				screen,
				owned,
				stepper,
				function(): number
					return count
				end,
				bounds,
				function(direction: number)
					setQuantity(count + direction)
				end
			)
			stepper.Parent = root
			stepper.LayoutOrder = 1
			local made = segmented(world, owned, "Mode", options, "a", function(value: string)
				choice = value
				S.setText(world, assert(summary), `{count}:{choice}`)
			end)
			picker = made
			made.node.LayoutOrder = 2
			made.node.Parent = root
			summary = S.fill(world, S.text(world, root, "Summary", "0:a", true))
			assert(summary).LayoutOrder = 3
			root.Parent = screen
		end)
		local function stop()
			release(owned)
			mounted()
		end
		local function styled(name: string, property: string): string
			local value = S.find(world, name):GetStyled(property)
			return if type(value) == "number" then string.format("%.3f", value) else tostring(value)
		end
		return {
			step = function(index: number)
				local nextChoice = if index % 2 == 0 then "a" else "b"
				if index % 10 == 1 then
					S.fire(world, "Increase", "Activated")
					world.fire(assert(S.find(world, "Mode"):FindFirstChild(nextChoice)), "Activated")
				elseif lane == "facet" then
					assert(quantity):set(index)
					assert(selected):set(nextChoice)
				else
					setQuantity(index)
					if choice ~= nextChoice then
						choice = nextChoice
						assert(picker).choose(nextChoice)
						S.setText(world, assert(summary), `{count}:{choice}`)
					end
				end
				world.frame()
			end,
			snapshot = function()
				local controls = {}
				for _, name in { "Decrease", "Increase" } do
					local button = S.find(world, name)
					table.insert(
						controls,
						`{name}: interactable={button.Interactable} textAlpha={styled(name, "TextTransparency")} selectable={button.Selectable}`
					)
				end
				local names = {
					"Choices",
					"Quantity",
					"Controls",
					"Decrease",
					"Value",
					"Increase",
					"Mode",
					"a",
					"b",
					"SelectionFill",
				}
				table.insert(names, "Summary")
				return S.observe(world, names) .. "\n" .. table.concat(controls, "\n")
			end,
			stop = stop,
		}
	end,
})

return workloads
