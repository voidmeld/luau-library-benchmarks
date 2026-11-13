--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"

type FieldEvents = {
	Focused: Roblox.Signal<>,
	FocusLost: Roblox.Signal<boolean, unknown>,
	IsFocused: (FieldEvents) -> boolean,
}
type Pressed = { KeyCode: unknown }
type LastInput = { GetLastInputType: (LastInput) -> unknown }
type Line = { y: number, x: number, text: string }
type Pooled = { row: S.Node, label: S.Node, index: number }

local workloads: { Types.Workload } = {}

local EDGE = 4
local GAP = 8
local SLOT = 44
local ROW = 40
local OVERSCAN = 2
local FIELD_INSET = { x = 10, y = 6 }
local CARD_INSET = 8
local CARD_GAP = 4
local CARD_LINES = 2
local CARD_CELL = 128
local LIFT = { scale = 1.04, seconds = 0.2, ease = "outQuad" }
local ARTWORK = "rbxasset://textures/ui/GuiImagePlaceholder.png"

local TAGS = table.freeze {
	row = "pl-collection-row",
	field = "pl-field",
	cardText = "pl-card-text",
}

local function canvas(world: Types.World, name: string, offset: boolean): string
	local node = S.find(world, name)
	local size = S.vector2(world, node.AbsoluteCanvasSize)
	local text = `{name}: canvas={S.number(size.X, 0)}x{S.number(size.Y, 0)} bar={S.number(
		node:GetStyled "ScrollBarThickness",
		0
	)}`
	if offset then
		local at = S.vector2(world, node.CanvasPosition)
		text ..= ` offset={S.number(at.X, 0)},{S.number(at.Y, 0)}`
	end
	return text
end

local function lines(world: Types.World, root: Roblox.Instance): string
	local found: { Line } = {}
	for _, node in root:GetDescendants() do
		if node:IsA "TextLabel" and S.shown(world, node) then
			local text = tostring(node.Text)
			if text ~= "" then
				local at = S.vector2(world, node.AbsolutePosition)
				table.insert(found, { y = math.round(at.Y), x = math.round(at.X), text = text })
			end
		end
	end
	table.sort(found, function(left: Line, right: Line): boolean
		if left.y ~= right.y then
			return left.y < right.y
		end
		if left.x ~= right.x then
			return left.x < right.x
		end
		return left.text < right.text
	end)
	local rows: { string } = {}
	for _, line in found do
		table.insert(rows, `{line.y}:{line.text}`)
	end
	return table.concat(rows, "\n")
end

local function named(root: Roblox.Instance, pattern: string): { [string]: Roblox.Instance }
	local found: { [string]: Roblox.Instance } = {}
	for _, node in root:GetDescendants() do
		local name = tostring(node.Name)
		if string.match(name, pattern) then
			found[name] = node
		end
	end
	return found
end

local function windowOf(world: Types.World, node: S.Node): (number, number)
	local value = node.AbsoluteWindowSize
	if world.types.typeof(value) ~= "Vector2" then
		return 0, 0
	end
	local size = S.vector2(world, value)
	return size.X, size.Y
end

local function inset(world: Types.World, parent: S.Node, x: number, top: number, bottom: number): S.Node
	local padding = S.create(world, "UIPadding", "UIPadding", parent)
	local UDim = world.types.UDim
	padding.PaddingLeft = UDim.new(0, x)
	padding.PaddingRight = UDim.new(0, x)
	padding.PaddingTop = UDim.new(0, top)
	padding.PaddingBottom = UDim.new(0, bottom)
	return padding
end

local function label(world: Types.World, parent: S.Node, name: string, value: string, bound: boolean): S.Node
	local node = S.fill(world, S.text(world, parent, name, value))
	if bound then
		node.AutoLocalize = false
	end
	return node
end

local function scrollView(world: Types.World, parent: S.Node, name: string, selectable: boolean): S.Node
	local node = S.create(world, "ScrollingFrame", name, parent, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromOffset(640, 480),
		CanvasSize = world.types.UDim2.new(),
		AutomaticCanvasSize = world.types.Enum.AutomaticSize.Y,
		ScrollingDirection = world.types.Enum.ScrollingDirection.Y,
		Selectable = selectable,
	})
	node.Active = true
	node.SelectionGroup = true
	S.create(world, "UIListLayout", "UIListLayout", node, {
		SortOrder = world.types.Enum.SortOrder.LayoutOrder,
		Padding = world.types.UDim.new(0, GAP),
	})
	return node
end

local function collection(world: Types.World, parent: S.Node, name: string, width: number, height: number): S.Node
	local node = S.create(world, "ScrollingFrame", name, parent, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.fromOffset(width, height),
		ScrollingDirection = world.types.Enum.ScrollingDirection.Y,
		Selectable = false,
	})
	node.ScrollBarThickness = 6
	node.SelectionGroup = true
	return node
end

local function cardRules(world: Types.World, sheet: S.Node)
	Theme.rule(world, sheet, `.{TAGS.cardText}::UIPadding, .{TAGS.cardText} > UIPadding`, {
		PaddingLeft = world.types.UDim.new(0, 0),
		PaddingRight = world.types.UDim.new(0, 0),
		PaddingTop = world.types.UDim.new(0, 0),
		PaddingBottom = world.types.UDim.new(0, CARD_INSET),
	})
end

local function cardText(
	world: Types.World,
	parent: S.Node,
	name: string,
	value: string,
	kind: string,
	top: number,
	bottom: number
): S.Node
	local node = S.fill(world, S.text(world, parent, name, value, nil, kind))
	node.TextWrapped = true
	node.TextTruncate = world.types.Enum.TextTruncate.AtEnd
	inset(world, node, CARD_INSET, top, bottom)
	local size = if kind == "caption" then Theme.typography.caption else Theme.typography.label
	local clamp = S.create(world, "UISizeConstraint", "LineClamp", node)
	clamp.MaxSize =
		world.types.Vector2.new(math.huge, math.ceil(CARD_LINES * size * Theme.typography.lineHeight) + top + bottom)
	return node
end

local function card(world: Types.World, parent: S.Node, name: string, title: string, caption: string?, image: string?)
	local root = S.stack(world, parent, name, false, { fill = true, surface = if image then nil else Theme.tags.panel })
	if image == nil then
		root:AddTag(TAGS.cardText)
	end
	local body = S.stack(
		world,
		root,
		"Body",
		false,
		{ fill = true, gap = CARD_GAP, surface = if image then Theme.tags.panel else nil }
	)
	if image then
		body:AddTag(Theme.tags.flush)
		local artwork = S.create(world, "ImageLabel", "Artwork", body, {
			BackgroundTransparency = 1,
			Image = image,
			Size = world.types.UDim2.new(1, 0, 0, 100000),
		})
		artwork.ScaleType = world.types.Enum.ScaleType.Crop
		local aspect =
			S.create(world, "UIAspectRatioConstraint", "UIAspectRatioConstraint", artwork, { AspectRatio = 16 / 9 })
		aspect.AspectType = world.types.Enum.AspectType.FitWithinMaxSize
		aspect.DominantAxis = world.types.Enum.DominantAxis.Width
	end
	cardText(world, body, "Title", title, "label", if image then 0 else CARD_INSET, 0)
	if caption then
		S.tag(cardText(world, body, "Caption", caption, "caption", 0, CARD_INSET), Theme.tags.secondary)
	end
	local lift = S.create(world, "UIScale", "Lift", root)
	root.MouseEnter:Connect(function()
		S.animate(world, lift, LIFT.seconds, LIFT.ease, { Scale = LIFT.scale })
	end)
	root.MouseLeave:Connect(function()
		S.animate(world, lift, LIFT.seconds, LIFT.ease, { Scale = 1 })
	end)
	return root
end

local function cardFacts(world: Types.World, name: string): string
	local root = S.find(world, name)
	local body = root:FindFirstChild "Body"
	local rows = { S.facts(world, name .. ".Body", body) }
	for _, part in { "Artwork", "Title", "Caption" } do
		local found = if body then body:FindFirstChild(part) else nil
		if part ~= "Artwork" or (found ~= nil and S.shown(world, found)) then
			table.insert(rows, S.facts(world, `{name}.{part}`, found))
		end
	end
	return table.concat(rows, "\n")
end

local function gridNavigation(
	world: Types.World,
	screen: S.Node,
	root: S.Node,
	hits: { S.Node },
	columns: number
): () -> ()
	local gui = world.guiService
	if gui == nil then
		return function() end
	end
	local service = gui
	local Enum = world.types.Enum
	local indexOf: { [unknown]: number } = {}
	for index, hit in hits do
		indexOf[hit] = index
	end
	local function focused(): number?
		return indexOf[service.SelectedObject]
	end
	local count = #hits
	local extent = math.ceil(count / columns) * (SLOT + GAP) - GAP
	local function viewport(): (number, number)
		local _, height = windowOf(world, root)
		local window = height - 2 * EDGE
		return math.max(0, S.vector2(world, root.CanvasPosition).Y - EDGE), window
	end
	local function reveal(index: number)
		local offset, window = viewport()
		local top = math.floor((index - 1) / columns) * (SLOT + GAP)
		local last = math.max(0, extent - window)
		local requested = if top < offset then top elseif top + SLOT > offset + window then top + SLOT - window else nil
		if requested then
			requested = math.clamp(requested, 0, last)
			root.CanvasPosition = world.types.Vector2.new(
				0,
				if requested <= 0 then 0 elseif requested >= last then last else requested + EDGE
			)
		end
	end
	local input = world.inputService
	local function keyed(): boolean
		if input == nil then
			return false
		end
		local last = ((input :: unknown) :: LastInput):GetLastInputType()
		return last == Enum.UserInputType.Keyboard or string.find(tostring(last), "Gamepad", 1, true) ~= nil
	end
	local function keep(hit: S.Node)
		local _, window = windowOf(world, root)
		local height = S.vector2(world, hit.AbsoluteSize).Y
		local room = math.clamp((window - height) / 2, 0, height)
		local top = S.vector2(world, hit.AbsolutePosition).Y - S.vector2(world, root.AbsolutePosition).Y - room
		local span = height + 2 * room
		local shift = if top < 0 or span > window then top elseif top + span > window then top + span - window else 0
		if shift ~= 0 then
			local offset = S.vector2(world, root.CanvasPosition).Y
			local most = math.max(0, S.vector2(world, root.AbsoluteCanvasSize).Y - window)
			root.CanvasPosition = world.types.Vector2.new(0, math.clamp(offset + shift, 0, most))
		end
	end
	local function go(target: (number) -> number?)
		local index = focused()
		local landed = if index then target(index) else nil
		if landed and hits[landed] then
			service.SelectedObject = hits[landed]
		end
	end
	local function column(index: number): number
		return (index - 1) % columns
	end
	local function within(index: number, step: number): number?
		local landed = index + step
		return if landed >= 1 and landed <= count then landed else nil
	end
	local function paged(index: number, direction: number): number
		local _, window = viewport()
		local rows = direction * math.max(1, math.floor((window - SLOT) / (SLOT + GAP)))
		local landed = index + rows * columns
		while landed > count do
			landed -= columns
		end
		while landed < 1 do
			landed += columns
		end
		return landed
	end
	local contexts: { S.Node } = {}
	local function action(name: string, keys: { unknown }, target: (number) -> number?)
		table.insert(
			contexts,
			S.inputs(world, screen, name, 200, {
				{
					name = name,
					keys = keys,
					pressed = function()
						go(target)
					end,
				},
			})
		)
	end
	action("CollectionLeft", { Enum.KeyCode.Left, Enum.KeyCode.DPadLeft }, function(index: number): number?
		return if column(index) > 0 then index - 1 else nil
	end)
	action("CollectionRight", { Enum.KeyCode.Right, Enum.KeyCode.DPadRight }, function(index: number): number?
		return if column(index) < columns - 1 then within(index, 1) else nil
	end)
	action("CollectionUp", { Enum.KeyCode.Up, Enum.KeyCode.DPadUp }, function(index: number): number?
		return within(index, -columns)
	end)
	action("CollectionDown", { Enum.KeyCode.Down, Enum.KeyCode.DPadDown }, function(index: number): number?
		return within(index, columns)
	end)
	action("CollectionFirst", { Enum.KeyCode.Home }, function(): number?
		return 1
	end)
	action("CollectionLast", { Enum.KeyCode.End }, function(): number?
		return count
	end)
	action("CollectionPageDown", { Enum.KeyCode.PageDown, Enum.KeyCode.ButtonR2 }, function(index: number): number?
		return paged(index, 1)
	end)
	action("CollectionPageUp", { Enum.KeyCode.PageUp, Enum.KeyCode.ButtonL2 }, function(index: number): number?
		return paged(index, -1)
	end)
	local function follow()
		local index = focused()
		local eligible = index ~= nil and not (input ~= nil and input:GetFocusedTextBox() ~= nil)
		for _, context in contexts do
			context.Enabled = eligible
		end
		if index then
			reveal(index)
			if keyed() then
				keep(hits[index])
			end
		end
	end
	local connection = service:GetPropertyChangedSignal("SelectedObject"):Connect(follow)
	follow()
	return function()
		connection:Disconnect()
	end
end

for _, count in { 500 } do
	table.insert(workloads, {
		id = "inventory-" .. count,
		iterations = 40,
		what = `Select among {count} retained slots 40 times; each slot has an activation target and selected state.`,
		prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
			local columns = 10
			local initial: { [number]: boolean } = { [1] = true }
			local selected = S.model(world, lane, initial)
			local data: { number } = {}
			for i = 1, count do
				table.insert(data, i)
			end
			local current = 1
			local expected = 1
			local labels: { S.Node } = {}
			local targets: { S.Node } = {}
			local release: () -> () = function() end
			local stop = S.mount(world, lane, function()
				local UI = world.UI
				local spec: Types.KeyedCollectionSpec<number, number> = {
					from = data,
					key = function(id: number)
						return id
					end,
					mode = "all",
					columns = columns,
					itemSize = SLOT,
					gap = GAP,
					measure = false,
					selection = assert(selected),
					Size = world.types.UDim2.fromOffset(640, 480),
					render = function(item: Types.ReadOnlyValue<number>)
						return UI.Text("Slot" .. item:peek()) {
							text = function(use: Types.Use)
								return `Item {use(item)}`
							end,
						}
					end,
				}
				return UI.VirtualGrid "Inventory"(spec)
			end, function(screen, sheet)
				local styles = assert(sheet)
				local UDim, UDim2 = world.types.UDim, world.types.UDim2
				Theme.rule(world, styles, "." .. TAGS.row, {
					BackgroundColor3 = Theme.token "control",
					BackgroundTransparency = 0,
					BorderSizePixel = 0,
				})
				Theme.rule(world, styles, `.{TAGS.row}::UICorner`, { CornerRadius = UDim.new(0, 8) })
				Theme.rule(world, styles, `.{TAGS.row}::UIStroke`, {
					Color = Theme.token "surface",
					Thickness = 1,
					Transparency = 0,
					BorderStrokePosition = world.types.Enum.BorderStrokePosition.Inner,
				})
				Theme.rule(
					world,
					styles,
					`.{TAGS.row}.{Theme.tags.selected}`,
					{ BackgroundColor3 = Theme.token "controlSelected" }
				)
				local rows = math.ceil(count / columns)
				local root = collection(world, screen, "Inventory", 640, 480)
				root.CanvasSize = UDim2.fromOffset(0, 2 * EDGE + rows * (SLOT + GAP) - GAP)
				local items = S.create(world, "Frame", "Items", root, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
				})
				inset(world, items, EDGE, EDGE, EDGE)
				local grid = S.create(world, "UIGridLayout", "UIGridLayout", items, {
					CellSize = UDim2.fromOffset(SLOT, SLOT),
					CellPadding = UDim2.fromOffset(GAP, GAP),
					FillDirectionMaxCells = columns,
					SortOrder = world.types.Enum.SortOrder.LayoutOrder,
				})
				local function fit()
					local window = windowOf(world, root)
					local width = math.floor((window - 2 * EDGE - GAP * (columns - 1)) / columns)
					if width > 0 then
						grid.CellSize = UDim2.fromOffset(width, SLOT)
					end
				end
				root:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(fit)
				fit()
				local plates: { S.Node } = {}
				local function choose(index: number)
					if index ~= current then
						plates[current]:RemoveTag(Theme.tags.selected)
						current = index
						plates[current]:AddTag(Theme.tags.selected)
					end
				end
				for i = 1, count do
					local plate = S.create(world, "Frame", tostring(i), items)
					plate.LayoutOrder = i
					plate:AddTag(TAGS.row)
					if i == current then
						plate:AddTag(Theme.tags.selected)
					end
					local hit = S.create(world, "TextButton", "RowHit", plate, {
						Text = "",
						AutoButtonColor = false,
						Selectable = true,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
					})
					hit.Activated:Connect(function()
						choose(i)
					end)
					plates[i], targets[i] = plate, hit
					labels[i] = label(world, plate, "Slot" .. i, `Item {i}`, true)
				end
				release = gridNavigation(world, screen, root, targets, columns)
			end)
			local root = S.find(world, "Inventory")
			if lane == "facet" then
				local found = named(root, "^Slot%d+$")
				for i = 1, count do
					local slot = world.node(assert(found["Slot" .. i], "a VirtualGrid cell did not render"))
					labels[i] = slot
					local row = assert(slot.Parent, "a VirtualGrid cell has no row")
					targets[i] =
						world.node(assert(row:FindFirstChild "RowHit", "a VirtualGrid cell has no browse stop"))
				end
			end
			world.pin(root, 640, 480)
			local mouse = { UserInputType = world.types.Enum.UserInputType.MouseButton1 }
			return {
				step = function(index: number)
					expected = index % count + 1
					world.fire(targets[expected], "Activated", mouse, 1)
				end,
				snapshot = function()
					S.settle(world, Theme.paint.normal)
					local key = current
					if lane == "facet" then
						local keys = 0
						for id in assert(selected):peek() do
							key = id
							keys += 1
						end
						assert(keys == 1, "inventory must hold one selected key")
					end
					local found = named(root, "^Slot%d+$")
					local paint = S.rgb(world, Theme.color(world, "controlSelected"))
					local active: { string } = {}
					for i = 1, count do
						local slot = labels[i]
						assert(found["Slot" .. i] == slot, "inventory replaced a retained label")
						local plate = assert(slot.Parent, "inventory detached a retained label")
						assert(targets[i].Parent == plate, "inventory replaced a retained activation target")
						if S.rgb(world, world.node(plate):GetStyled "BackgroundColor3") == paint then
							table.insert(active, tostring(i))
						end
					end
					assert(#active == 1 and active[1] == tostring(key), "inventory must show one selected slot")
					assert(key == expected, "inventory input did not select the requested slot")
					local watched: { number } = {}
					for _, slot in { 1, key - 1, key, key + 1, count } do
						if slot >= 1 and slot <= count and not table.find(watched, slot) then
							table.insert(watched, slot)
						end
					end
					table.sort(watched)
					local names = { "Inventory", "Items" }
					for _, slot in watched do
						table.insert(names, "Slot" .. slot)
					end
					local rows = {
						`{key}:{tostring(labels[key].Text)}:{table.concat(active, ",")}`,
						S.observe(world, names),
						canvas(world, "Inventory", true),
					}
					for _, slot in watched do
						table.insert(rows, S.facts(world, `Plate{slot}`, labels[slot].Parent))
						table.insert(rows, S.facts(world, `Hit{slot}`, targets[slot]))
					end
					return table.concat(rows, "\n")
				end,
				stop = function()
					release()
					stop()
				end,
			}
		end,
	})
end

table.insert(workloads, {
	id = "shop-filter-200",
	iterations = 10,
	what = "Edit a native TextBox with ten queries, including empty and no match; retain the 200 catalog rows and set their visibility.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local query = S.model(world, lane, "")
		local queries = { "1", "20", "Item", "99", "missing", "2", "10", "50", "200", "" }
		local items: { S.Node } = {}
		local function matches(text: string, value: string): boolean
			return string.find(text, value, 1, true) ~= nil
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local children: { Types.Node } =
				{ UI.TextInput "Filter" { value = assert(query), placeholder = "Filter items" } }
			for i = 1, 200 do
				local text = `Item {i}`
				table.insert(
					children,
					UI.Button("Item" .. i) {
						label = text,
						onActivate = function() end,
						Visible = function(use: Types.Use)
							return matches(text, use(assert(query)))
						end,
					}
				)
			end
			return UI.ScrollView "Shop" {
				gap = GAP,
				Size = world.types.UDim2.fromOffset(640, 480),
				table.unpack(children),
			}
		end, function(screen, sheet)
			local styles = assert(sheet)
			local Enum = world.types.Enum
			Theme.rule(world, styles, "." .. TAGS.field, {
				BackgroundColor3 = Theme.token "control",
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
			})
			Theme.rule(world, styles, `.{TAGS.field}::UICorner`, { CornerRadius = world.types.UDim.new(0, 8) })
			local scroll = scrollView(world, screen, "Shop", false)
			local input = S.create(world, "TextBox", "Filter", scroll, {
				Text = "",
				PlaceholderText = "Filter items",
				Size = world.types.UDim2.new(1, 0, 0, SLOT),
				ClearTextOnFocus = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				Selectable = true,
			})
			input.LayoutOrder = 1
			S.tag(input, Theme.tags.text, Theme.tags.body, TAGS.field)
			inset(world, input, FIELD_INSET.x, FIELD_INSET.y, FIELD_INSET.y)
			local value = ""
			local before = ""
			local editing = false
			local function apply(next: string)
				value = next
				for i, item in items do
					item.Visible = matches(`Item {i}`, value)
				end
			end
			local editingKeys: { unknown } = {
				Enum.KeyCode.Up,
				Enum.KeyCode.Down,
				Enum.KeyCode.Left,
				Enum.KeyCode.Right,
				Enum.KeyCode.DPadUp,
				Enum.KeyCode.DPadDown,
				Enum.KeyCode.DPadLeft,
				Enum.KeyCode.DPadRight,
			}
			local events = (input :: unknown) :: FieldEvents
			local contexts: { S.Node } = {}
			local function edit(active: boolean)
				editing = active
				for _, context in contexts do
					context.Enabled = active
				end
			end
			local function cancel()
				if editing then
					edit(false)
					input.Text = before
					apply(before)
					if events:IsFocused() then
						input:ReleaseFocus()
					end
				end
			end
			contexts[1] =
				S.inputs(world, screen, "TextEditing", 10000, { { name = "TextEditing", keys = editingKeys } })
			contexts[2] = S.inputs(world, screen, "Cancel", 10000, {
				{ name = "Cancel", keys = { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, pressed = cancel },
			})
			edit(false)
			events.Focused:Connect(function()
				if not editing then
					before = value
					edit(true)
				end
			end)
			events.FocusLost:Connect(function(_entered: boolean, pressed: unknown)
				local key = if type(pressed) == "table" or type(pressed) == "userdata"
					then (pressed :: Pressed).KeyCode
					else nil
				if key == Enum.KeyCode.Escape or key == Enum.KeyCode.ButtonB then
					cancel()
				else
					edit(false)
				end
			end)
			input:GetPropertyChangedSignal("Text"):Connect(function()
				local text = input.Text
				if editing and type(text) == "string" and text ~= value then
					apply(text)
				end
			end)
			for i = 1, 200 do
				local item = S.button(world, scroll, "Item" .. i, `Item {i}`, function() end)
				item.LayoutOrder = i + 1
				table.insert(items, item)
			end
		end)
		if lane == "facet" then
			local found = named(S.find(world, "Shop"), "^Item%d+$")
			for i = 1, 200 do
				items[i] = world.node(assert(found["Item" .. i], "missing catalog row"))
			end
		end
		return {
			step = function(index: number)
				S.fire(world, "Filter", "Focused")
				S.find(world, "Filter").Text = queries[index]
				world.frame()
			end,
			snapshot = function()
				S.settle(world, Theme.paint.normal)
				local rows = { tostring(S.find(world, "Filter").Text) }
				local visible: { string } = {}
				for i, item in items do
					if item.Visible ~= false then
						table.insert(rows, `Item {i}`)
						table.insert(visible, "Item" .. i)
					end
				end
				local names = { "Shop", "Filter", "Item1", "Item2", "Item200" }
				if #visible > 0 then
					table.insert(names, visible[1])
					table.insert(names, visible[#visible])
				end
				table.insert(rows, S.observe(world, names))
				table.insert(rows, canvas(world, "Shop", true))
				return table.concat(rows, "\n")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "virtual-scroll-2000",
	iterations = 15,
	what = "Scroll a fixed 40-pixel row window down in 796-pixel steps; the plain lane keeps a small reusable row pool.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local total = 2000
		local height = 400
		local data: { string } = {}
		for i = 1, total do
			table.insert(data, `Row {i}`)
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local spec: Types.KeyedCollectionSpec<string, string> = {
				from = data,
				key = function(item: string)
					return item
				end,
				itemSize = ROW,
				measure = false,
				overscan = OVERSCAN,
				Size = world.types.UDim2.fromOffset(640, height),
				render = function(current: Types.ReadOnlyValue<string>)
					return UI.Text { text = current }
				end,
			}
			return UI.VirtualList "Rows"(spec)
		end, function(screen)
			local UDim2 = world.types.UDim2
			local scroll = collection(world, screen, "Rows", 640, height)
			scroll.CanvasSize = UDim2.fromOffset(0, total * ROW)
			local items = S.create(world, "Frame", "Items", scroll, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			})
			local pool: { Pooled } = {}
			for _ = 1, math.ceil(height / ROW) + 1 + 2 * OVERSCAN do
				local row = S.create(world, "Frame", "Row", items, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(1, 0, 0, ROW),
				})
				row.Visible = false
				table.insert(pool, { row = row, label = label(world, row, "TextLabel", "", true), index = 0 })
			end
			local function place()
				local _, window = windowOf(world, scroll)
				local offset = S.vector2(world, scroll.CanvasPosition).Y
				local first, last = 1, 0
				if window > 0 then
					first = math.max(1, math.floor(offset / ROW) + 1 - OVERSCAN)
					last = math.min(total, math.ceil((offset + window) / ROW) + OVERSCAN)
				end
				for _, entry in pool do
					if entry.index < first or entry.index > last then
						entry.index = 0
					end
				end
				for index = first, last do
					local entry = pool[(index - 1) % #pool + 1]
					if entry.index ~= index then
						entry.index = index
						entry.row.Name = data[index]
						entry.row.LayoutOrder = index
						entry.row.Position = UDim2.fromOffset(0, (index - 1) * ROW)
						entry.label.Text = data[index]
					end
				end
				for _, entry in pool do
					entry.row.Visible = entry.index ~= 0
				end
			end
			scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(place)
			scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(place)
			place()
		end)
		local scroll = S.find(world, "Rows")
		world.pin(scroll, 640, height)
		return {
			step = function(index: number)
				scroll.CanvasPosition = world.types.Vector2.new(0, math.floor(index * 79600 / 100))
				world.frame()
			end,
			snapshot = function()
				S.settle(world, Theme.paint.normal)
				local offset = S.vector2(world, scroll.CanvasPosition).Y
				local first = math.max(1, math.floor(offset / ROW) + 1 - OVERSCAN)
				local last = math.min(total, math.ceil((offset + height) / ROW) + OVERSCAN)
				local top = S.find(world, data[first])
				return table.concat({
					canvas(world, "Rows", true),
					lines(world, scroll),
					S.observe(world, { "Rows", "Items", data[first], data[last] }),
					S.facts(world, data[first] .. ".Text", top:FindFirstChildWhichIsA("TextLabel", true)),
				}, "\n")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "chat-append-250",
	iterations = 250,
	what = "Append 250 keyed messages; remove the oldest when the log exceeds 100 rows.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local initial: { number } = {}
		local messages = S.model(world, lane, initial)
		local plainRows: { S.Node } = {}
		local chat: S.Node? = nil
		local latest = 0
		local stop = S.mount(world, lane, function()
			local UI, Compose = world.UI, world.Compose
			return UI.ScrollView "Chat" {
				gap = GAP,
				Size = world.types.UDim2.fromOffset(640, 480),
				Compose.keyed {
					from = assert(messages),
					key = function(id: number)
						return id
					end,
					render = function(current: Types.ReadOnlyValue<number>)
						return UI.Text("Message" .. current:peek()) {
							text = function(use: Types.Use)
								return `Player: message {use(current)}`
							end,
						}
					end,
				},
			}
		end, function(screen)
			chat = scrollView(world, screen, "Chat", true)
		end)
		return {
			step = function(index: number)
				latest = index
				if lane == "facet" then
					local nextRows = table.clone(assert(messages):peek())
					table.insert(nextRows, index)
					if #nextRows > 100 then
						table.remove(nextRows, 1)
					end
					assert(messages):set(nextRows)
				else
					local row = label(world, assert(chat), "Message" .. index, `Player: message {index}`, true)
					row.LayoutOrder = index
					table.insert(plainRows, row)
					if #plainRows > 100 then
						assert(table.remove(plainRows, 1)):Destroy()
					end
				end
			end,
			snapshot = function()
				S.settle(world, Theme.paint.normal)
				local names = { "Chat" }
				if latest > 0 then
					table.insert(names, "Message" .. math.max(1, latest - 99))
					table.insert(names, "Message" .. latest)
				end
				return table.concat({
					canvas(world, "Chat", true),
					lines(world, S.find(world, "Chat")),
					S.observe(world, names),
				}, "\n")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "card-collection-60",
	iterations = 1,
	what = "Mount 60 cards with the same artwork, item title and price caption; theme setup is excluded.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local cards: S.Node? = nil
		local unmount: () -> () = function() end
		local stop = S.mount(world, lane, function()
			return world.Host.Folder { Name = "Stage" }
		end, function() end)
		local screen = S.find(world, "Comparison")
		return {
			step = function()
				if lane == "facet" then
					local UI = world.UI
					unmount = world.runtime.mount(function()
						return UI.provide(function()
							local children: { Types.Node } = {}
							for i = 1, 60 do
								table.insert(
									children,
									UI.Card("Card" .. i) {
										title = `Kart {i}`,
										caption = `{i * 10} coins`,
										image = ARTWORK,
									}
								)
							end
							return UI.Grid "Cards" {
								columns = 6,
								gap = GAP,
								cellHeight = CARD_CELL,
								table.unpack(children),
							}
						end)
					end, screen)
				else
					local root = S.grid(world, screen, "Cards", 6, GAP)
					local layout = assert(root:FindFirstChildWhichIsA "UIGridLayout")
					layout.CellSize = world.types.UDim2.new(1 / 6, -math.ceil(GAP * 5 / 6), 0, CARD_CELL)
					for i = 1, 60 do
						card(world, root, "Card" .. i, `Kart {i}`, `{i * 10} coins`, ARTWORK)
					end
					cards = root
				end
			end,
			snapshot = function()
				S.settle(world, Theme.paint.normal)
				if world.target:FindFirstChild("Cards", true) == nil then
					return "unmounted"
				end
				local rows: { string } = {}
				for i = 1, 60 do
					local node = S.find(world, "Card" .. i)
					table.insert(
						rows,
						tostring(assert(node:FindFirstChild("Title", true)).Text)
							.. ":"
							.. tostring(assert(node:FindFirstChild("Caption", true)).Text)
							.. ":"
							.. tostring(assert(node:FindFirstChild("Artwork", true)).Image)
					)
				end
				table.insert(rows, S.observe(world, { "Cards", "Card1", "Card6", "Card7", "Card60" }))
				table.insert(rows, cardFacts(world, "Card1"))
				table.insert(rows, cardFacts(world, "Card60"))
				return table.concat(rows, "\n")
			end,
			stop = function()
				unmount()
				if cards then
					cards:Destroy()
				end
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "mixed-scroll-300",
	iterations = 50,
	what = "Scroll 300 retained mixed rows: 100 text rows, 100 action buttons and 100 text cards.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local children: { Types.Node } = {}
			for i = 1, 300 do
				local name, text = "Row" .. i, `Row {i}`
				if i % 3 == 0 then
					table.insert(children, UI.Card(name) { title = text })
				elseif i % 3 == 1 then
					table.insert(children, UI.Text(name) { text = text })
				else
					table.insert(children, UI.Button(name) { label = text, onActivate = function() end })
				end
			end
			return UI.ScrollView "Mixed" {
				gap = GAP,
				Size = world.types.UDim2.fromOffset(640, 480),
				table.unpack(children),
			}
		end, function(screen, sheet)
			cardRules(world, assert(sheet))
			local root = scrollView(world, screen, "Mixed", false)
			for i = 1, 300 do
				local name, text = "Row" .. i, `Row {i}`
				local row = if i % 3 == 0
					then card(world, root, name, text)
					elseif i % 3 == 1 then label(world, root, name, text, false)
					else S.button(world, root, name, text, function() end)
				row.LayoutOrder = i
			end
		end)
		local root = S.find(world, "Mixed")
		return {
			step = function(index: number)
				root.CanvasPosition = world.types.Vector2.new(0, index * 100)
				world.frame()
			end,
			snapshot = function()
				S.settle(world, Theme.paint.normal)
				local found = named(root, "^Row%d+$")
				local origin = S.vector2(world, root.AbsolutePosition).Y
				local _, window = windowOf(world, root)
				local rows: { string } = {}
				local visible: { string } = {}
				for i = 1, 300 do
					local node = world.node(assert(found["Row" .. i], "mixed scroll lost a retained row"))
					table.insert(
						rows,
						tostring(if i % 3 == 0 then assert(node:FindFirstChild("Title", true)).Text else node.Text)
					)
					local at, size = S.vector2(world, node.AbsolutePosition).Y, S.vector2(world, node.AbsoluteSize).Y
					if at + size > origin and at < origin + window then
						table.insert(visible, `Row{i}@{S.number(at - origin, 0)}`)
					end
				end
				table.insert(rows, canvas(world, "Mixed", false))
				table.insert(rows, "onscreen=" .. table.concat(visible, ","))
				local names = { "Mixed", "Row1", "Row2", "Row3" }
				if #visible > 0 then
					table.insert(names, (string.match(visible[1], "^[^@]+") or ""))
					table.insert(names, (string.match(visible[#visible], "^[^@]+") or ""))
				end
				table.insert(rows, S.observe(world, names))
				table.insert(rows, cardFacts(world, "Row3"))
				return table.concat(rows, "\n")
			end,
			stop = stop,
		}
	end,
})

return workloads
