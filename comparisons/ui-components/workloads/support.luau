--!strict

local Types = require "../types"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../../.lute/dependencies/verify/src/roblox/datatypes"
local Theme = require "./plain-theme"

export type Node = Types.Node
export type Path = { SetControlPoints: (Path, { unknown }) -> () }
export type StackOptions = { gap: number?, width: number?, height: number?, fill: boolean?, surface: string? }
type Tweener = { Create: (Tweener, Node, unknown, { [string]: unknown }) -> Node }
type Playable = { Play: (Playable) -> () }
type Binding = { name: string, keys: { unknown }, pressed: (() -> ())?, aim: ((unknown) -> ())? }
type Properties = { [string]: unknown }
type Vector = { X: number, Y: number, Magnitude: number }
type Scaled = { Scale: number, Offset: number }
type Dimensions = { X: Scaled, Y: Scaled }
type Rgb = { R: number, G: number, B: number }
type Typeface = { Family: string, Weight: unknown, Style: unknown }

local FRAME = 1 / 60
local SETTLE_MARGIN = 0.05

local function settle(world: Types.Engine, seconds: number)
	world.frame(seconds + SETTLE_MARGIN)
end

local function frames(world: Types.Engine, count: number, seconds: number?)
	for _ = 1, count do
		world.frame(seconds)
	end
end

local function vector2(world: Types.Engine, value: unknown): Vector
	assert(world.types.typeof(value) == "Vector2", "expected a Vector2")
	return value :: Vector
end

local function udim2(world: Types.Engine, value: unknown): Dimensions
	assert(world.types.typeof(value) == "UDim2", "expected a UDim2")
	return value :: Dimensions
end

local function model<T>(world: Types.World, lane: Types.Lane, value: T): Types.Value<T>?
	return if lane == "facet" then world.Compose.cell(value) else nil
end

local function motion(world: Types.World, lane: Types.Lane): Types.Motion
	return if lane == "facet" then world.motion else Theme.motion
end

local function controls(world: Types.World, environment: Types.Props): Types.Controls
	return world.Facet.controls(world.runtime, {
		types = world.types,
		services = {
			TextService = world.textService,
			GuiService = world.guiService,
			UserInputService = world.inputService,
		},
		environment = environment,
	})
end

local function simulated(world: Types.Engine): boolean
	return world.tweenService == nil
end

local ordered: { [Node]: number } = {}
setmetatable(ordered, { __mode = "ks" })

local function place(node: Node, parent: Roblox.Instance?)
	if parent ~= nil then
		local container = parent :: Node
		local count = ordered[container]
		if count ~= nil and node:IsA "GuiObject" then
			count += 1
			ordered[container] = count
			node.LayoutOrder = count
		end
	end
	node.Parent = parent
end

local function create(
	world: Types.Engine,
	class: string,
	name: string,
	parent: Roblox.Instance?,
	props: Properties?
): Node
	local node: Node = world.new(class)
	node.Name = name
	if props then
		for key, value in props do
			node[key] = value
		end
	end
	place(node, parent)
	return node
end

local function blank(world: Types.Engine, name: string, parent: Roblox.Instance?, size: unknown): Node
	return create(world, "Frame", name, parent, { BackgroundTransparency = 1, BorderSizePixel = 0, Size = size })
end

local function hit(world: Types.Engine, name: string, parent: Node, selectable: boolean, size: unknown): Node
	return create(world, "TextButton", name, parent, {
		Text = "",
		AutoButtonColor = false,
		Selectable = selectable,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = size,
	})
end

local function padding(world: Types.Engine, parent: Node, x: number, y: number, bottom: number?): Node
	local UDim = world.types.UDim
	local node = create(world, "UIPadding", "UIPadding", parent)
	node.PaddingLeft, node.PaddingRight = UDim.new(0, x), UDim.new(0, x)
	node.PaddingTop, node.PaddingBottom = UDim.new(0, y), UDim.new(0, bottom or y)
	return node
end

local function find(world: Types.Engine, name: string): Node
	return world.node((assert(world.target:FindFirstChild(name, true), "missing node " .. name)))
end

local function tag(node: Node, ...: string)
	for _, name in { ... } do
		node:AddTag(name)
	end
end

type Hold = {
	constraint: Node,
	widest: number,
	length: number,
	revision: number,
	floor: number,
	face: unknown,
	size: unknown,
	prefix: string,
}

local holds: { [Node]: Hold } = {}
setmetatable(holds, { __mode = "k" })
local measured: { [Types.Engine]: { [string]: number } } = {}
setmetatable(measured, { __mode = "k" })

local function widthOf(world: Types.Engine, held: Hold, node: Node, value: string, ready: (number) -> ()): number?
	local service = world.textService
	if service == nil then
		local bounds: unknown = node.TextBounds
		return if world.types.typeof(bounds) == "Vector2" then vector2(world, bounds).X else 0
	end
	local widths = measured[world]
	if widths == nil then
		local fresh: { [string]: number } = {}
		widths = fresh
		measured[world] = fresh
	end
	local known: { [string]: number } = widths
	local face, size = held.face, held.size
	local key = held.prefix .. value
	local cached = known[key]
	if cached ~= nil then
		return cached
	end
	local params = world.new "GetTextBoundsParams"
	params.Text, params.Font, params.Size, params.Width = value, face, size, 0
	local function measure()
		local ok, bounds: unknown = pcall(service.GetTextBoundsAsync, service, params)
		params:Destroy()
		if ok and world.types.typeof(bounds) == "Vector2" then
			local width = vector2(world, bounds).X
			known[key] = width
			ready(width)
		end
	end
	world.spawn(measure)
	return known[key]
end

local function floorTo(world: Types.Engine, held: Hold, width: number)
	if held.floor ~= width then
		held.floor = width
		held.constraint.MinSize = world.types.Vector2.new(width, 0)
	end
end

local function widen(world: Types.Engine, held: Hold, length: number, revision: number, width: number)
	if length ~= held.length or revision ~= held.revision or held.constraint.Parent == nil then
		return
	end
	if width > held.widest then
		held.widest = width
	elseif width < held.widest then
		floorTo(world, held, held.widest)
	end
end

local function reserve(world: Types.Engine, held: Hold, node: Node, value: string, length: number, revision: number)
	local width = widthOf(world, held, node, value, function(measuredWidth: number)
		widen(world, held, length, revision, measuredWidth)
	end)
	if width then
		widen(world, held, length, revision, width)
	end
end

local function restyle(held: Hold, node: Node)
	held.face, held.size = node:GetStyled "FontFace", node:GetStyled "TextSize"
	held.prefix = `{tostring(held.face)}|{tostring(held.size)}|`
end

local function holdFor(world: Types.Engine, node: Node): Hold
	local hold = holds[node]
	if hold == nil then
		local current = tostring(node.Text)
		local length = utf8.len(current) or #current
		local created: Hold = {
			constraint = create(world, "UISizeConstraint", "Hold", node),
			widest = 0,
			length = length,
			revision = 0,
			floor = 0,
			face = nil,
			size = nil,
			prefix = "",
		}
		restyle(created, node)
		holds[node] = created
		hold = created
		reserve(world, created, node, current, length, 0)
		local function reset()
			created.revision += 1
			created.widest = 0
			restyle(created, node)
			floorTo(world, created, 0)
			local now = tostring(node.Text)
			created.length = utf8.len(now) or #now
			reserve(world, created, node, now, created.length, created.revision)
		end
		for _, property in { "FontFace", "TextSize" } do
			node:GetStyledPropertyChangedSignal(property):Connect(reset)
		end
	end
	return assert(hold)
end

local function text(
	world: Types.Engine,
	parent: Node,
	name: string,
	value: string,
	bound: boolean?,
	kind: string?
): Node
	local node = create(world, "TextLabel", name, nil, {
		Text = value,
		AutoLocalize = if bound then false else nil,
		Size = world.types.UDim2.fromOffset(0, 0),
		AutomaticSize = world.types.Enum.AutomaticSize.XY,
		TextXAlignment = world.types.Enum.TextXAlignment.Left,
	})
	node:AddTag(Theme.tags.text)
	if kind ~= "" then
		node:AddTag(assert(Theme.typeTags[kind or "body"], "unknown type role"))
	end
	place(node, parent)
	if bound then
		holdFor(world, node)
	end
	return node
end

local function fill(world: Types.Engine, node: Node): Node
	node.Size = world.types.UDim2.fromScale(1, 0)
	node.AutomaticSize = world.types.Enum.AutomaticSize.Y
	return node
end

local function cardText(
	world: Types.Engine,
	parent: Node,
	name: string,
	value: string,
	kind: "label" | "caption",
	top: number,
	bottom: number
): Node
	local node = fill(world, text(world, parent, name, value, nil, kind))
	node.TextWrapped = true
	node.TextTruncate = world.types.Enum.TextTruncate.AtEnd
	padding(world, node, Theme.card.inset, top, bottom)
	local size = if kind == "caption" then Theme.typography.caption else Theme.typography.label
	local clamp = create(world, "UISizeConstraint", "LineClamp", node)
	clamp.MaxSize = world.types.Vector2.new(
		math.huge,
		math.ceil(Theme.card.lines * size * Theme.typography.lineHeight) + top + bottom
	)
	return node
end

local activations: { [Node]: () -> () } = {}
setmetatable(activations, { __mode = "k" })

local TARGET = 44
local DRAG_THRESHOLD = 6

local function addFloor(world: Types.Engine, node: Node)
	create(world, "UISizeConstraint", "TargetFloor", node, { MinSize = world.types.Vector2.new(TARGET, TARGET) })
end

local function targetFloor(world: Types.Engine, node: Node)
	if node:FindFirstChild "TargetFloor" == nil then
		addFloor(world, node)
	end
end

local function button(world: Types.Engine, parent: Node, name: string, label: string, activate: () -> ()): Node
	local node = create(world, "TextButton", name, nil, {
		Text = label,
		AutoButtonColor = false,
		Selectable = true,
		Size = world.types.UDim2.fromOffset(0, TARGET),
		AutomaticSize = world.types.Enum.AutomaticSize.XY,
	})
	node:AddTag(Theme.tags.button)
	local input = world.inputService
	if
		label ~= ""
		and input ~= nil
		and input.PreferredInput ~= nil
		and input.PreferredInput ~= world.types.Enum.PreferredInput.KeyboardAndMouse
	then
		addFloor(world, node)
	end
	place(node, parent)
	activations[node] = activate
	node.Activated:Connect(function(...: unknown)
		activate()
	end)
	return node
end

local function setText(world: Types.Engine, node: Node, value: string)
	local previous = tostring(node.Text)
	if previous == value then
		return
	end
	local held = holdFor(world, node)
	node.Text = value
	local length = utf8.len(value) or #value
	if length ~= held.length then
		held.widest, held.length = 0, length
		held.revision += 1
		floorTo(world, held, 0)
	end
	reserve(world, held, node, value, length, held.revision)
end

local function stack(
	world: Types.Engine,
	parent: Node?,
	name: string,
	horizontal: boolean?,
	options: StackOptions?
): Node
	local settings: StackOptions = options or {}
	local Enum, UDim2 = world.types.Enum, world.types.UDim2
	local width, height = settings.width, settings.height
	local plate = settings.surface
	local node = create(world, "Frame", name, nil, {
		BackgroundTransparency = if plate then nil else 1,
		BorderSizePixel = if plate then nil else 0,
		Size = if settings.fill then UDim2.new(1, 0, 0, height or 0) else UDim2.fromOffset(width or 0, height or 0),
		AutomaticSize = if settings.fill
			then (if height then nil else Enum.AutomaticSize.Y)
			elseif width and height then nil
			elseif width then Enum.AutomaticSize.Y
			elseif height then Enum.AutomaticSize.X
			else Enum.AutomaticSize.XY,
	})
	create(world, "UIListLayout", "Layout", node, {
		FillDirection = if horizontal then Enum.FillDirection.Horizontal else nil,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = if settings.gap and settings.gap ~= 0 then world.types.UDim.new(0, settings.gap) else nil,
	})
	if plate then
		node:AddTag(plate)
	end
	ordered[node] = 0
	place(node, parent)
	return node
end

local function grid(world: Types.Engine, parent: Node, name: string, columns: number, gap: number?): Node
	local spacing = gap or 8
	local node = create(world, "Frame", name, nil, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromScale(1, 0),
		AutomaticSize = world.types.Enum.AutomaticSize.Y,
	})
	create(world, "UIGridLayout", "Layout", node, {
		CellSize = world.types.UDim2.new(1 / columns, -math.ceil(spacing * (columns - 1) / columns), 0, TARGET),
		CellPadding = world.types.UDim2.fromOffset(spacing, spacing),
		FillDirectionMaxCells = columns,
		SortOrder = world.types.Enum.SortOrder.LayoutOrder,
	})
	ordered[node] = 0
	place(node, parent)
	return node
end

local function fire(world: Types.Engine, name: string, event: string, ...: unknown)
	world.fire(find(world, name), event, ...)
end

type Tweens = { service: Node, live: { [Node]: boolean }, stop: () -> () }
local tweening: { [Types.Engine]: Tweens } = {}
setmetatable(tweening, { __mode = "k" })

local function tweensFor(world: Types.Engine): Tweens
	local existing = tweening[world]
	if existing then
		return existing
	end
	local service: Node = world.tweenService or world.new "TweenService"
	local live: { [Node]: boolean } = {}
	local created: Tweens = {
		service = service,
		live = live,
		stop = function()
			for tween in live do
				tween:Destroy()
			end
			table.clear(live)
			if world.tweenService == nil then
				service:Destroy()
			end
			tweening[world] = nil
		end,
	}
	tweening[world] = created
	return created
end

local function easing(world: Types.Engine, ease: string): (Datatypes.EnumMember, Datatypes.EnumMember)
	local Enum = world.types.Enum
	local direction, name = string.match(ease, "^(%l+)(%u%a*)$")
	return if direction and name then Enum.EasingStyle[name] else Enum.EasingStyle.Linear,
		if direction == "inOut"
			then Enum.EasingDirection.InOut
			elseif direction == "in" then Enum.EasingDirection.In
			else Enum.EasingDirection.Out
end

export type SpringState = { position: number, velocity: number, target: number, reference: number }

local function spring(config: Theme.Spring): (SpringState, number) -> boolean
	local stiffness = (2 * math.pi / config.period) ^ 2
	local drag = 2 * config.damping * 2 * math.pi / config.period
	return function(state: SpringState, delta: number): boolean
		local remaining = math.min(delta, config.limit)
		while remaining > 0 do
			local h = if remaining > config.step then config.step else remaining
			remaining -= h
			state.velocity += (-stiffness * (state.position - state.target) - drag * state.velocity) * h
			state.position += state.velocity * h
		end
		local epsilon = math.max(math.abs(state.reference - state.target) * config.tolerance, config.tolerance)
		if math.abs(state.position - state.target) <= epsilon and math.abs(state.velocity) * config.step <= epsilon then
			state.position, state.velocity = state.target, 0
			return true
		end
		return false
	end
end

local function animate(
	world: Types.Engine,
	node: Node,
	seconds: number,
	ease: string,
	goal: { [string]: unknown },
	done: (() -> ())?
)
	local tweens = tweensFor(world)
	local info = world.types.TweenInfo.new(seconds, easing(world, ease))
	local tween = ((tweens.service :: unknown) :: Tweener):Create(node, info, goal)
	tweens.live[tween] = true
	tween.Completed:Connect(function()
		tweens.live[tween] = nil
		tween:Destroy()
		if done then
			done()
		end
	end)
	local playable = (tween :: unknown) :: Playable
	playable:Play()
end

local function inputs(world: Types.Engine, parent: Node, name: string, priority: number, bindings: { Binding }): Node
	local context = create(world, "InputContext", name)
	context.Priority = priority
	context.Sink = true
	for _, binding in bindings do
		local action = create(world, "InputAction", binding.name, context)
		if binding.aim then
			action.Type = world.types.Enum.InputActionType.Direction2D
			action.StateChanged:Connect(binding.aim)
		end
		for _, key in binding.keys do
			local bound = create(world, "InputBinding", "InputBinding", action)
			bound.KeyCode = key
		end
		local pressed = binding.pressed
		if pressed then
			action.Pressed:Connect(function(...: unknown)
				pressed()
			end)
		end
	end
	context.Parent = parent
	return context
end

local function action(
	world: Types.Engine,
	parent: Node,
	name: string,
	priority: number,
	keys: { unknown },
	pressed: (() -> ())?
): Node
	return inputs(world, parent, name, priority, { { name = name, keys = keys, pressed = pressed } })
end

local function editing(world: Types.Engine, parent: Node, cancel: () -> ()): (Node, Node)
	local KeyCode = world.types.Enum.KeyCode
	local holding = action(world, parent, "TextEditing", 10000, {
		KeyCode.Up,
		KeyCode.Down,
		KeyCode.Left,
		KeyCode.Right,
		KeyCode.DPadUp,
		KeyCode.DPadDown,
		KeyCode.DPadLeft,
		KeyCode.DPadRight,
	})
	return holding, action(world, parent, "Cancel", 10000, { KeyCode.Escape, KeyCode.ButtonB }, cancel)
end

local function trap(world: Types.Engine, panel: Node)
	local Stop = world.types.Enum.SelectionBehavior.Stop
	panel.SelectionGroup = true
	panel.SelectionBehaviorUp = Stop
	panel.SelectionBehaviorDown = Stop
	panel.SelectionBehaviorLeft = Stop
	panel.SelectionBehaviorRight = Stop
end

local function selected(world: Types.Engine): Node?
	local gui = world.guiService
	return if gui then gui.SelectedObject :: Node? else nil
end

local function reduced(world: Types.Engine): boolean
	local gui = world.guiService
	return gui ~= nil and gui.ReducedMotionEnabled == true
end

local function window(world: Types.Engine, node: Node): (number, number)
	local value = node.AbsoluteWindowSize
	if world.types.typeof(value) ~= "Vector2" then
		return 0, 0
	end
	local size = vector2(world, value)
	return size.X, size.Y
end

local function returnKey(world: Types.Engine): { UserInputType: unknown, KeyCode: unknown }
	return { UserInputType = world.types.Enum.UserInputType.Keyboard, KeyCode = world.types.Enum.KeyCode.Return }
end

local function focus(world: Types.Engine, target: Node): () -> ()
	local gui: Node? = world.guiService
	if gui == nil then
		return function() end
	end
	local service = gui
	local previous = service.SelectedObject
	service.SelectedObject = target
	return function()
		if service.SelectedObject == target then
			service.SelectedObject = previous
		end
	end
end

local function sinks(world: Types.Engine): number
	local count = 0
	for _, node in world.target:GetDescendants() do
		if node:IsA "InputContext" and node.Sink == true and node.Enabled == true then
			count += 1
		end
	end
	return count
end

local function keyboard(world: Types.Engine, screen: Node): () -> ()
	local gui = world.guiService
	if gui == nil then
		return function() end
	end
	local input = world.inputService
	local function typing(): boolean
		return input ~= nil and input:GetFocusedTextBox() ~= nil
	end
	local function activatable(): Node?
		local node = selected(world)
		return if node and node:IsDescendantOf(screen) and activations[node] then node else nil
	end
	local Enum = world.types.Enum
	local context = inputs(world, screen, "PlainKeyboardActivation", 5000, {
		{
			name = "Activate",
			keys = { Enum.KeyCode.Return, Enum.KeyCode.Space },
			pressed = function()
				local node = activatable()
				if node and node.Interactable ~= false and not typing() then
					activations[node]()
				end
			end,
		},
	})
	local function sync()
		context.Enabled = activatable() ~= nil and not typing()
	end
	local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(sync)
	sync()
	return function()
		connection:Disconnect()
	end
end

local function mount(
	world: Types.World,
	lane: Types.Lane,
	facet: () -> Node,
	plain: (Node, Node?) -> (),
	unthemed: boolean?
): () -> ()
	if lane == "facet" then
		local Host, Facet, runtime = world.Host, world.Facet, world.runtime
		return runtime.mount(function()
			return world.UI.provide(function()
				if unthemed then
					local bare: Types.Props = { Name = "Comparison", facet() }
					return Host.ScreenGui(bare)
				end
				local content = facet()
				local sheet =
					Facet.themes.createStyleSheet(runtime, Facet.themes.neutralPackage(), { types = world.types })
				local link = Host.StyleLink { StyleSheet = world.Compose.static(sheet) }
				local props: Types.Props = { Name = "Comparison", sheet, link, content }
				return Host.ScreenGui(props)
			end)
		end, world.target)
	end
	local screen = create(world, "ScreenGui", "Comparison", nil, {
		ZIndexBehavior = world.types.Enum.ZIndexBehavior.Sibling,
	})
	local sheet, unstyle = nil, nil
	if not unthemed then
		sheet, unstyle = Theme.create(world, screen)
	end
	plain(screen, sheet)
	screen.Parent = world.target
	local stopKeyboard = keyboard(world, screen)
	return function()
		stopKeyboard()
		for node in activations do
			if node.Parent == nil or node:IsDescendantOf(screen) then
				activations[node] = nil
			end
		end
		if unstyle then
			unstyle()
		end
		local tweens = tweening[world]
		if tweens then
			tweens.stop()
		end
		screen:Destroy()
	end
end

local function progress(world: Types.Engine, parent: Node, name: string, value: number): Node
	local root = stack(world, parent, name, false, { fill = true })
	local track = create(world, "Frame", "Track", root, { Size = world.types.UDim2.new(1, 0, 0, 6) })
	track:AddTag(Theme.tags.track)
	local clip = create(world, "Frame", "FillClip", track, {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Size = world.types.UDim2.fromScale(1, 1),
	})
	local bar = create(world, "Frame", "Fill1", clip, { Size = world.types.UDim2.fromScale(value, 1) })
	bar:AddTag(Theme.tags.fill)
	return bar
end

local function fraction(world: Types.Engine, name: string): string
	local clip = find(world, name):FindFirstChild("Fill1", true)
	assert(clip)
	local size: unknown = clip.Size
	return string.format("%.4f", udim2(world, size).X.Scale)
end

local function rounded(value: number, places: number): string
	local text = string.format(`%.{places}f`, value)
	return if tonumber(text) == 0 then string.format(`%.{places}f`, 0) else text
end

local function rgb(world: Types.Engine, value: unknown): string
	if world.types.typeof(value) ~= "Color3" then
		return tostring(value)
	end
	local color = value :: Rgb
	return `{math.round(color.R * 255)},{math.round(color.G * 255)},{math.round(color.B * 255)}`
end

local function typeface(world: Types.Engine, value: unknown): string
	if world.types.typeof(value) ~= "Font" then
		return tostring(value)
	end
	local face = value :: Typeface
	local family = string.match(face.Family, "([^/]+)%.json$") or face.Family
	return `{family}/{string.match(tostring(face.Weight), "[^.]+$")}/{string.match(tostring(face.Style), "[^.]+$")}`
end

local function number(value: unknown, places: number): string
	return if type(value) == "number" then rounded(value, places) else tostring(value)
end

local function shown(world: Types.Engine, node: Roblox.Instance): boolean
	local at: Roblox.Instance? = node
	while at ~= nil and at ~= world.target do
		if at:IsA "GuiObject" and at.Visible == false then
			return false
		end
		if at:IsA "CanvasGroup" and type(at.GroupTransparency) == "number" and at.GroupTransparency >= 0.999 then
			return false
		end
		if at:IsA "LayerCollector" and at.Enabled == false then
			return false
		end
		at = at.Parent
	end
	return at ~= nil
end

local function contexts(world: Types.Engine): string
	local found: { { priority: number, keys: string } } = {}
	for _, node in world.target:GetDescendants() do
		if node:IsA "InputContext" and node.Enabled == true then
			local keys: { string } = {}
			for _, action in node:GetChildren() do
				if action:IsA "InputAction" and action.Enabled ~= false then
					for _, binding in action:GetChildren() do
						if binding:IsA "InputBinding" then
							table.insert(keys, (string.match(tostring(binding.KeyCode), "[^.]+$") or "?"))
						end
					end
				end
			end
			table.sort(keys)
			local priority = node.Priority
			table.insert(found, {
				priority = if type(priority) == "number" then priority else 0,
				keys = table.concat(keys, "+"),
			})
		end
	end
	table.sort(
		found,
		function(left: { priority: number, keys: string }, right: { priority: number, keys: string }): boolean
			if left.priority ~= right.priority then
				return left.priority > right.priority
			end
			return left.keys < right.keys
		end
	)
	local rows: { string } = {}
	for _, entry in found do
		table.insert(rows, `{entry.priority}:{entry.keys}`)
	end
	return table.concat(rows, ";")
end

local function facts(world: Types.Engine, label: string, found: Roblox.Instance?): string
	if found == nil then
		return label .. ": absent"
	end
	local node = world.node(found)
	local facts: { string } = { label .. ":", if shown(world, node) then "shown" else "hidden" }
	if node:IsA "TextLabel" or node:IsA "TextButton" or node:IsA "TextBox" then
		local value = tostring(node.Text)
		table.insert(facts, `text={value}`)
		if value ~= "" then
			table.insert(facts, `ink={rgb(world, node:GetStyled "TextColor3")}`)
			table.insert(facts, `alpha={number(node:GetStyled "TextTransparency", 3)}`)
			table.insert(facts, `size={number(node:GetStyled "TextSize", 1)}`)
			table.insert(facts, `font={typeface(world, node:GetStyled "FontFace")}`)
		end
	end
	if node:IsA "GuiObject" then
		local transparency = node:GetStyled "BackgroundTransparency"
		table.insert(facts, `bgAlpha={number(transparency, 3)}`)
		if type(transparency) == "number" and transparency < 1 then
			table.insert(facts, `bg={rgb(world, node:GetStyled "BackgroundColor3")}`)
		end
	end
	if world.layout and node:IsA "GuiBase2d" then
		local at, size = vector2(world, node.AbsolutePosition), vector2(world, node.AbsoluteSize)
		table.insert(facts, `at={rounded(at.X, 0)},{rounded(at.Y, 0)}`)
		table.insert(facts, `extent={rounded(size.X, 0)}x{rounded(size.Y, 0)}`)
	end
	return table.concat(facts, " ")
end

local function observe(world: Types.Engine, names: { string }): string
	local rows: { string } = {}
	for _, name in names do
		table.insert(rows, facts(world, name, world.target:FindFirstChild(name, true)))
	end
	local current = selected(world)
	table.insert(rows, `selected={if current then tostring(current.Name) else "none"}`)
	table.insert(rows, `inputs={contexts(world)}`)
	return table.concat(rows, "\n")
end

return {
	FRAME = FRAME,
	settle = settle,
	frames = frames,
	vector2 = vector2,
	udim2 = udim2,
	model = model,
	motion = motion,
	controls = controls,
	simulated = simulated,
	create = create,
	blank = blank,
	hit = hit,
	padding = padding,
	find = find,
	text = text,
	fill = fill,
	cardText = cardText,
	button = button,
	tag = tag,
	setText = setText,
	stack = stack,
	fire = fire,
	observe = observe,
	facts = facts,
	shown = shown,
	rgb = rgb,
	rounded = rounded,
	number = number,
	mount = mount,
	grid = grid,
	progress = progress,
	fraction = fraction,
	animate = animate,
	inputs = inputs,
	TARGET = TARGET,
	DRAG_THRESHOLD = DRAG_THRESHOLD,
	easing = easing,
	spring = spring,
	targetFloor = targetFloor,
	selected = selected,
	reduced = reduced,
	window = window,
	returnKey = returnKey,
	action = action,
	editing = editing,
	trap = trap,
	focus = focus,
	sinks = sinks,
}
