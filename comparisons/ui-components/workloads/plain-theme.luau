--!strict

local Types = require "../types"

type Node = Types.Node
type World = Types.Engine
export type Properties = { [string]: unknown }
export type Transition = "normal" | "hover" | "press" | "pop" | "instant" | "none"
export type Palette = { [string]: { number } }
type State = { priority: number, preference: number, scrims: { [Node]: number } }
export type Spring = { period: number, damping: number, tolerance: number, step: number, limit: number }
export type Motion = Types.Motion & {
	glide: number,
	spread: number,
	reducedFade: number,
	dialogFade: { enter: number, exit: number },
	lift: { scale: number, seconds: number, ease: string },
	springs: { control: Spring, snappy: Spring },
}

local FAMILY = "rbxasset://fonts/families/BuilderSans.json"

local PALETTE: Palette = {
	surface = { 18, 20, 26 },
	surfaceStrong = { 28, 31, 40 },
	control = { 41, 45, 58 },
	controlHover = { 49, 54, 69 },
	controlPressed = { 34, 37, 48 },
	controlSelected = { 45, 58, 92 },
	content = { 236, 239, 245 },
	contentStrong = { 250, 251, 253 },
	contentSecondary = { 158, 165, 182 },
	accent = { 44, 98, 210 },
	onAccent = { 255, 255, 255 },
	selection = { 44, 98, 210 },
	onSelection = { 255, 255, 255 },
	inverseSurface = { 250, 251, 253 },
	onInverse = { 18, 20, 26 },
	danger = { 176, 42, 42 },
	onDanger = { 255, 255, 255 },
	success = { 29, 122, 66 },
	onSuccess = { 255, 255, 255 },
	warning = { 212, 154, 28 },
	onWarning = { 26, 20, 6 },
	hairline = { 255, 255, 255 },
	tableHeader = { 41, 45, 58 },
	tableRow = { 41, 45, 58 },
	tableRowAlternate = { 49, 54, 69 },
}

local TAGS = table.freeze {
	text = "pl-text",
	caption = "pl-caption",
	label = "pl-label",
	body = "pl-body",
	heading = "pl-heading",
	title = "pl-title",
	control = "pl-control",
	secondary = "pl-secondary",
	button = "pl-button",
	selected = "pl-selected",
	disabled = "pl-disabled",
	surface = "pl-surface",
	panel = "pl-panel",
	flush = "pl-flush",
	scrim = "pl-scrim",
	track = "pl-track",
	fill = "pl-fill",
	field = "pl-field",
	divider = "pl-divider",
}

local MOTION: Motion = {
	dialog = { enter = 0.2, exit = 0.15 },
	toast = { enter = 0.2, exit = 0.2 },
	radial = { enter = 0.2, exit = 0.12 },
	travel = 0.3,
	present = "outCubic",
	travelEase = "outCubic",
	glide = 0.22,
	spread = 0.2,
	reducedFade = 0.15,
	dialogFade = { enter = 0.6, exit = 0.5 },
	lift = { scale = 1.04, seconds = 0.2, ease = "outQuad" },
	springs = {
		control = { period = 0.25, damping = 1, tolerance = 1e-3, step = 1 / 120, limit = 0.25 },
		snappy = { period = 0.2, damping = 1, tolerance = 1e-4, step = 1 / 120, limit = 0.25 },
	},
}

local function outCubic(progress: number): number
	return 1 - (1 - math.clamp(progress, 0, 1)) ^ 3
end

local PAINT = table.freeze { normal = 0.2, hover = 0.15, press = 0.08, style = "Quad" }
local POP = table.freeze { seconds = 0.15, style = "Cubic", rest = 0.94 }

local TYPOGRAPHY = table.freeze {
	caption = 14,
	label = 15,
	body = 16,
	heading = 20,
	title = 24,
	control = 18,
	lineHeight = 1.2,
	step = 2,
}

local ROLES: { { tag: string, size: number, weight: string } } = {
	{ tag = TAGS.caption, size = TYPOGRAPHY.caption, weight = "Regular" },
	{ tag = TAGS.label, size = TYPOGRAPHY.label, weight = "Regular" },
	{ tag = TAGS.body, size = TYPOGRAPHY.body, weight = "Regular" },
	{ tag = TAGS.heading, size = TYPOGRAPHY.heading, weight = "Bold" },
	{ tag = TAGS.title, size = TYPOGRAPHY.title, weight = "Bold" },
	{ tag = TAGS.control, size = TYPOGRAPHY.control, weight = "Regular" },
}

local TYPE_TAGS: { [string]: string } = {
	caption = TAGS.caption,
	label = TAGS.label,
	body = TAGS.body,
	heading = TAGS.heading,
	title = TAGS.title,
	control = TAGS.control,
}

local TIMINGS: { [Transition]: string } = {
	normal = "$motionNormal",
	hover = "$motionHover",
	press = "$motionPress",
	pop = "$motionPop",
	instant = "$motionInstant",
}

local SCRIM_TRANSPARENCY = 0.55
local HAIRLINE_TRANSPARENCY = 0.92
local RADIUS = table.freeze { control = 8, panel = 12 }
local FIELD_INSET = table.freeze { x = 10, y = 6 }
local CARD = table.freeze { inset = 8, gap = 4, lines = 2 }

local states: { [Node]: State } = {}
setmetatable(states, { __mode = "ks" })

local function token(name: string): string
	assert(PALETTE[name], "unknown plain theme colour " .. name)
	return "$" .. name
end

local function color(world: World, name: string): unknown
	local value = PALETTE[name]
	assert(value, "unknown plain theme colour " .. name)
	return world.types.Color3.fromRGB(value[1], value[2], value[3])
end

local function font(world: World, weight: string?): unknown
	local Enum = world.types.Enum
	return world.types.Font.new(FAMILY, Enum.FontWeight[weight or "Regular"], Enum.FontStyle.Normal)
end

local function timing(world: World, seconds: number, style: string): unknown
	local Enum = world.types.Enum
	return world.types.TweenInfo.new(seconds, Enum.EasingStyle[style], Enum.EasingDirection.Out)
end

local function transitionOf(selector: string): Transition
	return if string.find(selector, ":Press", 1, true)
		then "press"
		elseif string.find(selector, ":Hover", 1, true) then "hover"
		else "normal"
end

local function animates(world: World, property: string, value: unknown, transition: Transition): boolean
	return world.types.typeof(value) == "Color3"
		or (type(value) == "string" and string.sub(value, 1, 1) == "$" and PALETTE[string.sub(value, 2)] ~= nil)
		or string.find(property, "Transparency$") ~= nil
		or (property == "Scale" and (transition == "pop" or transition == "instant"))
end

local function rule(world: World, sheet: Node, selector: string, properties: Properties, transition: Transition?): Node
	local state = assert(states[sheet], "the plain theme did not make this StyleSheet")
	state.priority += 10
	local node = world.new "StyleRule"
	node.Name = selector
	node.Selector = selector
	node.Priority = state.priority
	node:SetProperties(properties)
	local chosen = transition or transitionOf(selector)
	local reference = TIMINGS[chosen]
	if reference then
		local transitions: Properties = {}
		local animated = false
		for property, value in properties do
			if animates(world, property, value, chosen) then
				transitions[property] = reference
				animated = true
			end
		end
		if animated then
			node:SetPropertyTransitions(transitions)
		end
	end
	node.Parent = sheet
	return node
end

local function preferenceOf(world: World): number
	local gui = world.guiService
	local value: unknown = if gui then gui.PreferredTransparency else nil
	return if type(value) == "number" and value == value then math.clamp(value, 0, 1) else 1
end

local function scaled(transparency: number, preference: number): number
	return if transparency > 0 and transparency < 1 then transparency * preference else transparency
end

local function scrim(world: World, sheet: Node, selector: string, transparency: number): Node
	local state = assert(states[sheet], "the plain theme did not make this StyleSheet")
	local node = rule(world, sheet, selector, {
		BackgroundColor3 = world.types.Color3.new(0, 0, 0),
		BackgroundTransparency = scaled(transparency, state.preference),
		BorderSizePixel = 0,
	})
	state.scrims[node] = transparency
	return node
end

local function padding(world: World, left: number, top: number): Properties
	local UDim = world.types.UDim
	return {
		PaddingLeft = UDim.new(0, left),
		PaddingRight = UDim.new(0, left),
		PaddingTop = UDim.new(0, top),
		PaddingBottom = UDim.new(0, top),
	}
end

local function corner(world: World, radius: number): Properties
	return { CornerRadius = world.types.UDim.new(0, radius) }
end

local function plate(name: string): Properties
	return { BackgroundColor3 = token(name), BackgroundTransparency = 0, BorderSizePixel = 0 }
end

local function base(world: World, sheet: Node)
	local Enum = world.types.Enum
	local regular = font(world)
	rule(world, sheet, "ScrollingFrame", {
		HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
		VerticalScrollBarInset = Enum.ScrollBarInset.Always,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = token "contentSecondary",
		ScrollBarImageTransparency = 0.4,
	})
	rule(world, sheet, "." .. TAGS.text, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = regular,
		TextColor3 = token "content",
	})
	for _, role in ROLES do
		local properties: Properties = {
			FontFace = font(world, role.weight),
			LineHeight = TYPOGRAPHY.lineHeight,
			TextSize = role.size,
		}
		if role.tag == TAGS.caption then
			properties.TextColor3 = token "contentSecondary"
		end
		rule(world, sheet, "." .. role.tag, properties)
	end
	rule(world, sheet, "." .. TAGS.secondary, { TextColor3 = token "contentSecondary" })
	rule(world, sheet, "TextBox." .. TAGS.text, { PlaceholderColor3 = token "contentSecondary" })
	rule(world, sheet, "." .. TAGS.surface, plate "surface")
	rule(world, sheet, `.{TAGS.surface}::UICorner`, corner(world, RADIUS.control))
	rule(world, sheet, "." .. TAGS.panel, plate "surfaceStrong")
	rule(world, sheet, `.{TAGS.panel}::UICorner`, corner(world, RADIUS.panel))
	rule(world, sheet, "." .. TAGS.track, plate "control")
	rule(world, sheet, "." .. TAGS.button, {
		BackgroundColor3 = token "control",
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		FontFace = regular,
		TextColor3 = token "content",
		TextSize = TYPOGRAPHY.control,
	})
	rule(world, sheet, `.{TAGS.button}::UICorner, .{TAGS.track}::UICorner`, corner(world, RADIUS.control))
	rule(world, sheet, `.{TAGS.button}::UIPadding, .{TAGS.button} > UIPadding`, padding(world, 12, 0))
	rule(world, sheet, `.{TAGS.panel}::UIPadding, .{TAGS.panel} > UIPadding`, padding(world, 16, 16))
	rule(
		world,
		sheet,
		`.{TAGS.panel}.{TAGS.flush}::UIPadding, .{TAGS.panel}.{TAGS.flush} > UIPadding`,
		padding(world, 0, 0)
	)
	rule(world, sheet, `.{TAGS.track} >> .{TAGS.fill}::UICorner`, corner(world, RADIUS.control))
	rule(world, sheet, `.{TAGS.button}:Hover`, { BackgroundColor3 = token "controlHover" })
	rule(world, sheet, `.{TAGS.button}:Press`, { BackgroundColor3 = token "controlPressed" })
	rule(world, sheet, "." .. TAGS.selected, {
		BackgroundColor3 = token "controlSelected",
		TextColor3 = token "content",
	})
	rule(world, sheet, `.{TAGS.selected} >> .{TAGS.text}`, { TextColor3 = token "content" })
	rule(world, sheet, `.{TAGS.disabled}, .{TAGS.disabled} >> .{TAGS.text}`, { TextTransparency = 0.4 })
	rule(world, sheet, "." .. TAGS.fill, plate "accent")
	scrim(world, sheet, "." .. TAGS.scrim, SCRIM_TRANSPARENCY)
	rule(world, sheet, `.{TAGS.button}.{TAGS.disabled}`, { BackgroundTransparency = 0.6 })
end

local function fields(world: World, sheet: Node)
	rule(world, sheet, "." .. TAGS.field, plate "control")
	rule(world, sheet, `.{TAGS.field}::UICorner`, corner(world, RADIUS.control))
end

local function dividers(world: World, sheet: Node)
	rule(world, sheet, "." .. TAGS.divider, {
		BackgroundColor3 = token "hairline",
		BackgroundTransparency = HAIRLINE_TRANSPARENCY,
		BorderSizePixel = 0,
	})
end

local function utility(world: World, sheet: Node, tag: string)
	rule(world, sheet, "." .. tag, { BackgroundTransparency = 1 })
	rule(world, sheet, `.{tag}:Hover`, { BackgroundTransparency = 0, BackgroundColor3 = token "controlHover" })
	rule(world, sheet, `.{tag}:Press`, { BackgroundTransparency = 0, BackgroundColor3 = token "controlPressed" })
end

local function sheet(world: World): (Node, () -> ())
	local node = world.new "StyleSheet"
	node.Name = "PlainTheme"
	local state: State = { priority = 0, preference = preferenceOf(world), scrims = {} }
	states[node] = state
	for name in PALETTE do
		node:SetAttribute(name, color(world, name))
	end
	node:SetAttribute("motionNormal", timing(world, PAINT.normal, PAINT.style))
	node:SetAttribute("motionHover", timing(world, math.min(PAINT.hover, PAINT.normal), PAINT.style))
	node:SetAttribute("motionPress", timing(world, math.min(PAINT.press, PAINT.normal), PAINT.style))
	node:SetAttribute("motionPop", timing(world, POP.seconds, POP.style))
	node:SetAttribute("motionInstant", timing(world, 0, PAINT.style))
	base(world, node)
	local gui = world.guiService
	local release: () -> () = function() end
	if gui then
		local connection = gui:GetPropertyChangedSignal("PreferredTransparency"):Connect(function()
			state.preference = preferenceOf(world)
			for target, transparency in state.scrims do
				local properties = target:GetProperties()
				properties.BackgroundTransparency = scaled(transparency, state.preference)
				target:SetProperties(properties)
			end
		end)
		release = function()
			connection:Disconnect()
		end
	end
	return node, release
end

local function link(world: World, screen: Node, target: Node): Node
	local node = world.new "StyleLink"
	node.StyleSheet = target
	node.Parent = screen
	return node
end

local function create(world: World, screen: Node): (Node, () -> ())
	local made, release = sheet(world)
	made.Parent = screen
	link(world, screen, made)
	return made, release
end

return {
	tags = TAGS,
	typeTags = TYPE_TAGS,
	motion = MOTION,
	outCubic = outCubic,
	paint = PAINT,
	pop = POP,
	typography = TYPOGRAPHY,
	radius = RADIUS,
	fieldInset = FIELD_INSET,
	card = CARD,
	token = token,
	color = color,
	create = create,
	link = link,
	rule = rule,
	padding = padding,
	corner = corner,
	plate = plate,
	fields = fields,
	dividers = dividers,
	utility = utility,
}
