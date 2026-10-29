--!strict

local Types = require "../types"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
type ScreenProps = Types.Props

export type Node = Types.Node
type Tweener = { Create: (Tweener, Node, unknown, { [string]: unknown }) -> Node }
type Playable = { Play: (Playable) -> () }
export type Path = { SetControlPoints: (Path, { unknown }) -> () }
type Binding = { name: string, keys: { unknown }, pressed: (() -> ())?, aim: ((unknown) -> ())? }
type Properties = {
	Text: unknown?,
	AutoLocalize: unknown?,
	BackgroundTransparency: unknown?,
	BorderSizePixel: unknown?,
	TextSize: unknown?,
	Size: unknown?,
	TextXAlignment: unknown?,
	AutoButtonColor: unknown?,
	Selectable: unknown?,
	FillDirection: unknown?,
	SortOrder: unknown?,
	Padding: unknown?,
	ZIndexBehavior: unknown?,
	CellSize: unknown?,
	CellPadding: unknown?,
	FillDirectionMaxCells: unknown?,
	ClipsDescendants: unknown?,
	AutomaticCanvasSize: unknown?,
	PlaceholderText: unknown?,
	ClearTextOnFocus: unknown?,
	CanvasSize: unknown?,
	CanvasPosition: unknown?,
	Image: unknown?,
	AutomaticSize: unknown?,
	AspectRatio: unknown?,
	ScrollingDirection: unknown?,
	Anchored: unknown?,
	Adornee: unknown?,
}
type Vector = { X: number, Y: number, Magnitude: number }
type Scaled = { Scale: number, Offset: number }
type Dimensions = { X: Scaled, Y: Scaled }

local function vector2(world: Types.World, value: unknown): Vector
	assert(world.types.typeof(value) == "Vector2", "expected a Vector2")
	return value :: Vector
end

local function udim2(world: Types.World, value: unknown): Dimensions
	assert(world.types.typeof(value) == "UDim2", "expected a UDim2")
	return value :: Dimensions
end

local function model<T>(world: Types.World, lane: Types.Lane, value: T): Types.Value<T>?
	return if lane == "facet" then world.Compose.cell(value) else nil
end

local function create(
	world: Types.World,
	class: string,
	name: string,
	parent: Roblox.Instance?,
	props: Properties?
): Node
	local node: Node = world.new(class)
	node.Name = name
	if props then
		if props.Text ~= nil then
			node.Text = props.Text
		end
		if props.AutoLocalize ~= nil then
			node.AutoLocalize = props.AutoLocalize
		end
		if props.BackgroundTransparency ~= nil then
			node.BackgroundTransparency = props.BackgroundTransparency
		end
		if props.BorderSizePixel ~= nil then
			node.BorderSizePixel = props.BorderSizePixel
		end
		if props.TextSize ~= nil then
			node.TextSize = props.TextSize
		end
		if props.Size ~= nil then
			node.Size = props.Size
		end
		if props.TextXAlignment ~= nil then
			node.TextXAlignment = props.TextXAlignment
		end
		if props.AutoButtonColor ~= nil then
			node.AutoButtonColor = props.AutoButtonColor
		end
		if props.Selectable ~= nil then
			node.Selectable = props.Selectable
		end
		if props.FillDirection ~= nil then
			node.FillDirection = props.FillDirection
		end
		if props.SortOrder ~= nil then
			node.SortOrder = props.SortOrder
		end
		if props.Padding ~= nil then
			node.Padding = props.Padding
		end
		if props.ZIndexBehavior ~= nil then
			node.ZIndexBehavior = props.ZIndexBehavior
		end
		if props.CellSize ~= nil then
			node.CellSize = props.CellSize
		end
		if props.CellPadding ~= nil then
			node.CellPadding = props.CellPadding
		end
		if props.FillDirectionMaxCells ~= nil then
			node.FillDirectionMaxCells = props.FillDirectionMaxCells
		end
		if props.ClipsDescendants ~= nil then
			node.ClipsDescendants = props.ClipsDescendants
		end
		if props.AutomaticCanvasSize ~= nil then
			node.AutomaticCanvasSize = props.AutomaticCanvasSize
		end
		if props.PlaceholderText ~= nil then
			node.PlaceholderText = props.PlaceholderText
		end
		if props.ClearTextOnFocus ~= nil then
			node.ClearTextOnFocus = props.ClearTextOnFocus
		end
		if props.CanvasSize ~= nil then
			node.CanvasSize = props.CanvasSize
		end
		if props.CanvasPosition ~= nil then
			node.CanvasPosition = props.CanvasPosition
		end
		if props.Image ~= nil then
			node.Image = props.Image
		end
		if props.AutomaticSize ~= nil then
			node.AutomaticSize = props.AutomaticSize
		end
		if props.AspectRatio ~= nil then
			node.AspectRatio = props.AspectRatio
		end
		if props.ScrollingDirection ~= nil then
			node.ScrollingDirection = props.ScrollingDirection
		end
		if props.Anchored ~= nil then
			node.Anchored = props.Anchored
		end
		if props.Adornee ~= nil then
			node.Adornee = props.Adornee
		end
	end
	node.Parent = parent
	return node
end

local function find(world: Types.World, name: string): Node
	return world.node((assert(world.target:FindFirstChild(name, true), "missing node " .. name)))
end

local function tag(node: Node, ...: string)
	for _, name in { ... } do
		node:AddTag(name)
	end
end

local prepareHold: (Types.World, Node) -> () = function(_world: Types.World, _node: Node) end

local function text(world: Types.World, parent: Node, name: string, value: string, bound: boolean?, kind: string?): Node
	local node = create(world, "TextLabel", name, nil, {
		Text = value,
		AutoLocalize = if bound then false else nil,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromOffset(0, 0),
		AutomaticSize = world.types.Enum.AutomaticSize.XY,
		TextXAlignment = world.types.Enum.TextXAlignment.Left,
	})
	tag(node, "facet-text")
	if kind ~= "" then
		tag(node, "facet-type-" .. (kind or "body"))
	end
	node.Parent = parent
	if bound then
		prepareHold(world, node)
	end
	return node
end

local activations = (setmetatable({}, { __mode = "k" }) :: unknown) :: { [Node]: () -> () }

local function button(world: Types.World, parent: Node, name: string, label: string, activate: () -> ()): Node
	local node = create(world, "TextButton", name, nil, {
		Text = label,
		AutoButtonColor = false,
		Selectable = true,
		Size = world.types.UDim2.fromOffset(0, 0),
		AutomaticSize = world.types.Enum.AutomaticSize.XY,
	})
	tag(node, "facet-button", "facet-role-default")
	node.Parent = parent
	activations[node] = activate
	node.Activated:Connect(function(...: unknown)
		activate()
	end)
	return node
end

type Hold = { constraint: Node, widest: number, length: number, revision: number }
type Styled = {
	GetStyled: (Styled, string) -> unknown,
	GetStyledPropertyChangedSignal: (Styled, string) -> Roblox.Signal<>,
}
type Measurer = (Node, Node) -> unknown

local function styled(node: Node, key: string): unknown
	return ((node :: unknown) :: Styled):GetStyled(key)
end
local holds = (setmetatable({}, { __mode = "k" }) :: unknown) :: { [Node]: Hold }
local widths: { [string]: number } = {}

local function widthOf(world: Types.World, node: Node, value: string, ready: (number) -> ()): number?
	local service = world.textService
	if service == nil then
		local bounds: unknown = node.TextBounds
		return if world.types.typeof(bounds) == "Vector2" then vector2(world, bounds).X else 0
	end
	local face, size = styled(node, "FontFace"), styled(node, "TextSize")
	local key = `{tostring(face)}|{tostring(size)}|{value}`
	local known = widths[key]
	if known ~= nil then
		return known
	end
	local params = world.new "GetTextBoundsParams"
	params.Text, params.Font, params.Size, params.Width = value, face, size, 0
	local function measure()
		local ok, measured: unknown = pcall(service.GetTextBoundsAsync :: Measurer, service, params)
		params:Destroy()
		if ok and world.types.typeof(measured) == "Vector2" then
			local width = vector2(world, measured).X
			widths[key] = width
			ready(width)
		end
	end
	world.spawn(measure)
	return widths[key]
end

local function widen(world: Types.World, held: Hold, length: number, revision: number, width: number)
	if
		length == held.length
		and revision == held.revision
		and held.constraint.Parent ~= nil
		and width > held.widest
	then
		held.widest = width
		held.constraint.MinSize = world.types.Vector2.new(width, 0)
	end
end

local function holdFor(world: Types.World, node: Node): Hold
	local hold = holds[node]
	if hold == nil then
		local current = tostring(node.Text)
		local length = utf8.len(current) or #current
		local created: Hold = {
			constraint = create(world, "UISizeConstraint", "Hold", node),
			widest = 0,
			length = length,
			revision = 0,
		}
		holds[node] = created
		hold = created
		local width = widthOf(world, node, current, function(measured: number)
			widen(world, created, length, 0, measured)
		end)
		if width then
			widen(world, created, length, 0, width)
		end
		local function reset()
			created.revision += 1
			created.widest = 0
			created.constraint.MinSize = world.types.Vector2.zero
			local revision = created.revision
			local current = tostring(node.Text)
			local length = utf8.len(current) or #current
			created.length = length
			local width = widthOf(world, node, current, function(measured: number)
				widen(world, created, length, revision, measured)
			end)
			if width then
				widen(world, created, length, revision, width)
			end
		end
		for _, property in { "FontFace", "TextSize" } do
			((node :: unknown) :: Styled):GetStyledPropertyChangedSignal(property):Connect(reset)
		end
	end
	return assert(hold)
end

prepareHold = function(world: Types.World, node: Node)
	holdFor(world, node)
end

local function setText(world: Types.World, node: Node, value: string)
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
		held.constraint.MinSize = world.types.Vector2.new(0, 0)
	end
	local revision = held.revision
	local width = widthOf(world, node, value, function(measured: number)
		widen(world, held, length, revision, measured)
	end)
	if width then
		widen(world, held, length, revision, width)
	end
end

local function stack(world: Types.World, parent: Node?, name: string, horizontal: boolean?): Node
	local node = create(world, "Frame", name, parent, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromOffset(640, 480),
	})
	create(world, "UIListLayout", "Layout", node, {
		FillDirection = if horizontal
			then world.types.Enum.FillDirection.Horizontal
			else world.types.Enum.FillDirection.Vertical,
		SortOrder = world.types.Enum.SortOrder.LayoutOrder,
		Padding = world.types.UDim.new(0, 8),
	})
	return node
end

local function connect(_world: Types.World, node: Node, event: string, callback: (...unknown) -> ())
	assert(event == "DragEnd")
	node.DragEnd:Connect(callback)
end

local function fire(world: Types.World, name: string, event: string, ...: unknown)
	world.fire(find(world, name), event, ...)
end

local function snapshot(world: Types.World, names: { string }): string
	local rows: { string } = {}
	for _, name in names do
		local node = find(world, name)
		local value = node.Text
		table.insert(rows, name .. ":" .. tostring(value))
	end
	return table.concat(rows, "\n")
end

type Tweens = { service: Node, live: { [Node]: boolean }, stop: () -> () }
local tweening = (setmetatable({}, { __mode = "k" }) :: unknown) :: { [Types.World]: Tweens }

local function tweensFor(world: Types.World): Tweens
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

local function animate(
	world: Types.World,
	node: Node,
	seconds: number,
	ease: string,
	goal: { [string]: unknown },
	done: (() -> ())?
)
	local tweens = tweensFor(world)
	local Enum = world.types.Enum
	local direction, name = string.match(ease, "^(%l+)(%u%a*)$")
	local style = if direction then Enum.EasingStyle else nil
	local info = world.types.TweenInfo.new(
		seconds,
		if style and name then style[name] else Enum.EasingStyle.Linear,
		if direction == "inOut"
			then Enum.EasingDirection.InOut
			elseif direction == "in" then Enum.EasingDirection.In
			else Enum.EasingDirection.Out
	)
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

local function inputs(world: Types.World, parent: Node, name: string, priority: number, bindings: { Binding }): Node
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

local function trap(world: Types.World, panel: Node)
	local Stop = world.types.Enum.SelectionBehavior.Stop
	panel.SelectionGroup = true
	panel.SelectionBehaviorUp = Stop
	panel.SelectionBehaviorDown = Stop
	panel.SelectionBehaviorLeft = Stop
	panel.SelectionBehaviorRight = Stop
end

local function focus(world: Types.World, target: Node): () -> ()
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

local function layer(world: Types.World, name: string, dismiss: () -> (), scrimTag: string?): Node
	local root = create(world, "CanvasGroup", name, nil, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromScale(1, 1),
	})
	root.GroupTransparency = 1
	root.Active = true
	root.ZIndex = 100
	local scrim = create(world, "Frame", "Scrim", root, {
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromScale(1, 1),
	})
	if scrimTag then
		tag(scrim, scrimTag)
	else
		scrim.BackgroundColor3 = world.types.Color3.new(0, 0, 0)
		scrim.BackgroundTransparency = 0.55
	end
	local outside = create(world, "TextButton", "DismissTarget", root, {
		Text = "",
		AutoButtonColor = false,
		Selectable = false,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromScale(1, 1),
	})
	outside.Activated:Connect(function(...: unknown)
		dismiss()
	end)
	return root
end

local function tagged(world: Types.World, name: string): number
	local count = 0
	for _, node in world.target:GetDescendants() do
		if node:HasTag(name) and (not node:IsA "GuiObject" or node.Visible == true) then
			count += 1
		end
	end
	return count
end

local function sinks(world: Types.World): number
	local count = 0
	for _, node in world.target:GetDescendants() do
		if node:IsA "InputContext" and node.Sink == true and node.Enabled == true then
			count += 1
		end
	end
	return count
end

local function tagsOf(world: Types.World, name: string): string
	local node = world.target:FindFirstChild(name, true)
	if node == nil then
		return "absent"
	end
	local names = node:GetTags()
	table.sort(names)
	return table.concat(names, ",")
end

local function themed(world: Types.World, screen: Node): () -> ()
	local stop = world.runtime.mount(function()
		return world.Facet.themes.createStyleSheet(
			world.runtime,
			world.Facet.themes.neutralPackage(),
			{ types = world.types }
		)
	end, screen)
	local sheet = screen:FindFirstChildWhichIsA "StyleSheet"
	local link: Node = world.new "StyleLink"
	link.StyleSheet = sheet
	link.Parent = screen
	local warm: Node = world.new "Folder"
	warm.Name = "StateTags"
	for _, name in { "facet-selected", "facet-disabled", "facet-busy" } do
		warm:AddTag(name)
	end
	warm.Parent = screen
	return stop
end

local function keyboard(world: Types.World, screen: Node): () -> ()
	local gui = world.guiService
	if gui == nil then
		return function() end
	end
	local function selected(): Node?
		local current = gui.SelectedObject
		if current == nil then
			return nil
		end
		local node = (current :: unknown) :: Node
		return if node:IsDescendantOf(screen) and activations[node] then node else nil
	end
	local context = inputs(world, screen, "PlainKeyboardActivation", 50, {
		{
			name = "Activate",
			keys = { world.types.Enum.KeyCode.Return },
			pressed = function()
				local node = selected()
				if node and node.Interactable ~= false then
					activations[node]()
				end
			end,
		},
	})
	local function sync()
		context.Enabled = selected() ~= nil
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
	plain: (Node) -> (),
	unthemed: boolean?
): () -> ()
	if lane == "facet" then
		local Host = world.Host
		local screen: Types.Node? = nil
		local stop = world.runtime.mount(function()
			return world.UI.provide(function()
				local props: ScreenProps = { Name = "Comparison", facet() }
				local made = Host.ScreenGui(props)
				screen = made
				return made
			end)
		end, world.target)
		local unstyle = if unthemed then nil else themed(world, (assert(screen) :: unknown) :: Node)
		return function()
			if unstyle then
				unstyle()
			end
			stop()
		end
	end
	local screen = create(world, "ScreenGui", "Comparison", world.target, {
		ZIndexBehavior = world.types.Enum.ZIndexBehavior.Sibling,
	})
	plain(screen)
	local stopKeyboard = keyboard(world, screen)
	local unstyle = if unthemed then nil else themed(world, screen)
	return function()
		stopKeyboard()
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

local function grid(world: Types.World, parent: Node, name: string, columns: number): Node
	local node = create(world, "Frame", name, parent, {
		BackgroundTransparency = 1,
		Size = world.types.UDim2.fromOffset(640, 480),
	})
	create(world, "UIGridLayout", "Layout", node, {
		CellSize = world.types.UDim2.fromOffset(640 / columns - 8, 44),
		CellPadding = world.types.UDim2.fromOffset(8, 8),
		FillDirectionMaxCells = columns,
		SortOrder = world.types.Enum.SortOrder.LayoutOrder,
	})
	return node
end

local function progress(world: Types.World, parent: Node, name: string, value: number): Node
	local root = stack(world, parent, name, true)
	local track = create(world, "Frame", "Track", root, { Size = world.types.UDim2.fromOffset(240, 6) })
	local clip = create(world, "Frame", "FillClip", track, {
		ClipsDescendants = true,
		BackgroundTransparency = 1,
		Size = world.types.UDim2.fromScale(1, 1),
	})
	return create(world, "Frame", "Fill1", clip, { Size = world.types.UDim2.fromScale(value, 1) })
end

local function fraction(world: Types.World, name: string): string
	local clip = find(world, name):FindFirstChild("Fill1", true)
	assert(clip)
	local size: unknown = clip.Size
	return string.format("%.4f", udim2(world, size).X.Scale)
end

local function setProgress(world: Types.World, name: string, value: number)
	local fill = assert(find(world, name):FindFirstChild("Fill1", true))
	fill.Size = world.types.UDim2.fromScale(value, 1)
end

return {
	vector2 = vector2,
	udim2 = udim2,
	model = model,
	create = create,
	find = find,
	text = text,
	button = button,
	tag = tag,
	setText = setText,
	stack = stack,
	connect = connect,
	fire = fire,
	snapshot = snapshot,
	mount = mount,
	grid = grid,
	progress = progress,
	fraction = fraction,
	setProgress = setProgress,
	animate = animate,
	inputs = inputs,
	trap = trap,
	focus = focus,
	layer = layer,
	tagged = tagged,
	sinks = sinks,
	tagsOf = tagsOf,
}
