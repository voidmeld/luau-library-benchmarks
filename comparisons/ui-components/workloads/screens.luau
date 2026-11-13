--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
type FrameProps = Types.Props
type Watch = { Disconnect: (Watch) -> () }
type InputEvents = {
	LastInputTypeChanged: { Connect: (unknown, () -> ()) -> Watch },
	GetPropertyChangedSignal: (unknown, string) -> { Connect: (unknown, () -> ()) -> Watch },
}
type Easing = { GetValue: (Easing, number, unknown, unknown) -> number }
type Motion = { elapsed: number, seconds: number, progress: number, sample: (number) -> (), finish: () -> () }
type Motions = {
	start: (number, (number) -> (), () -> ()) -> Motion,
	cancel: (Motion) -> (),
	stop: () -> (),
}
type Glide = { goal: number, delta: number, motion: Motion }

type Player = { id: number, name: string, score: number, wins: number }
type Sort = { column: string, direction: "ascending" | "descending" }
type Controls = {
	indexOfKey: ((number) -> number?)?,
	offsetOf: ((number, ("center" | "end" | "start")?, number?) -> number)?,
	placementOf: ((number) -> Types.CollectionPlacement)?,
}

local TABLE = table.freeze {
	head = "pl-tablehead",
	row = "pl-tablerow",
	heading = "pl-tableheading",
	rowHeight = 44,
	headerHeight = 40,
	cellInset = 12,
	scrollBar = 6,
}

local workloads: { Types.Workload } = {}

local function fraction(value: unknown): string
	return if type(value) == "number" then string.format("%.3f", value) else tostring(value)
end

local function describe(world: Types.Engine, node: S.Node, unplaced: boolean?): string
	local facts: { string } = {}
	if node:IsA "TextLabel" or node:IsA "TextButton" then
		local value = tostring(node.Text)
		if value ~= "" then
			table.insert(facts, `text={value}`)
			table.insert(facts, `ink={S.rgb(world, node:GetStyled "TextColor3")}`)
			table.insert(facts, `alpha={fraction(node:GetStyled "TextTransparency")}`)
			table.insert(facts, `size={fraction(node:GetStyled "TextSize")}`)
		end
	end
	local transparency = node:GetStyled "BackgroundTransparency"
	table.insert(facts, `bgAlpha={fraction(transparency)}`)
	if type(transparency) == "number" and transparency < 1 then
		table.insert(facts, `bg={S.rgb(world, node:GetStyled "BackgroundColor3")}`)
	end
	if world.layout and not unplaced then
		local at, size = S.vector2(world, node.AbsolutePosition), S.vector2(world, node.AbsoluteSize)
		table.insert(facts, `at={S.rounded(at.X, 0)},{S.rounded(at.Y, 0)}`)
		table.insert(facts, `extent={S.rounded(size.X, 0)}x{S.rounded(size.Y, 0)}`)
	end
	return table.concat(facts, " ")
end

local function plateOf(world: Types.Engine, name: string): S.Node?
	local at: S.Node? = S.find(world, name)
	while at ~= nil and at ~= world.target do
		local node = at
		if node:IsA "GuiObject" then
			local transparency = node:GetStyled "BackgroundTransparency"
			if type(transparency) == "number" and transparency < 1 then
				return node
			end
		end
		local parent = node.Parent
		at = if parent then world.node(parent) else nil
	end
	return nil
end

local function visibleWithin(world: Types.Engine, name: string): string
	local root = S.find(world, name)
	type Entry = { x: number, y: number, line: string }
	local entries: { Entry } = {}
	for _, descendant in root:GetDescendants() do
		local node = world.node(descendant)
		if node:IsA "GuiObject" and node.Visible == true then
			local textual = (node:IsA "TextLabel" or node:IsA "TextButton") and tostring(node.Text) ~= ""
			local transparency = node:GetStyled "BackgroundTransparency"
			if textual or (type(transparency) == "number" and transparency < 1) then
				local at = S.vector2(world, node.AbsolutePosition)
				table.insert(entries, { x = at.X, y = at.Y, line = describe(world, node) })
			end
		end
	end
	table.sort(entries, function(left: Entry, right: Entry): boolean
		if left.x ~= right.x then
			return left.x < right.x
		end
		if left.y ~= right.y then
			return left.y < right.y
		end
		return left.line < right.line
	end)
	local lines: { string } = {}
	for _, entry in entries do
		table.insert(lines, `{name} > {entry.line}`)
	end
	return table.concat(lines, "\n")
end

local function canvas(world: Types.Engine, name: string): string
	local node = S.find(world, name)
	local position = S.vector2(world, node.CanvasPosition)
	local extent = if world.layout then S.vector2(world, node.AbsoluteCanvasSize) else nil
	return `{name}: canvasAt={S.rounded(position.X, 0)},{S.rounded(position.Y, 0)} canvas={if extent
		then `{S.rounded(extent.X, 0)}x{S.rounded(extent.Y, 0)}`
		else "unmeasured"}`
end

local function press(world: Types.Engine, name: string, label: string)
	for _, descendant in S.find(world, name):GetDescendants() do
		local node = world.node(descendant)
		local text = if node:IsA "TextButton" then tostring(node.Text) else ""
		if text == label or string.sub(text, 1, #label + 1) == label .. " " then
			world.fire(node, "Activated", S.returnKey(world))
			return
		end
	end
	error(`no button labelled {label} in {name}`, 0)
end

local function motions(world: Types.Engine, ease: string): Motions
	local style, towards = S.easing(world, ease)
	local active: { [Motion]: boolean } = {}
	local ticker: Roblox.Connection? = nil
	local service: S.Node? = nil
	local owned = false
	local function eased(share: number): number
		local current = service
		if current == nil then
			local created: S.Node = world.tweenService or world.new "TweenService"
			owned = world.tweenService == nil
			service = created
			current = created
		end
		return ((current :: unknown) :: Easing):GetValue(share, style, towards)
	end
	local function idle()
		local running = ticker
		if next(active) == nil and running then
			ticker = nil
			running:Disconnect()
		end
	end
	local function tick(step: number)
		for motion in table.clone(active) do
			if active[motion] then
				motion.elapsed = math.min(motion.seconds, motion.elapsed + step)
				motion.progress = eased(motion.elapsed / motion.seconds)
				motion.sample(motion.progress)
				if motion.elapsed >= motion.seconds then
					active[motion] = nil
					motion.finish()
				end
			end
		end
		idle()
	end
	return {
		start = function(seconds: number, sample: (number) -> (), finish: () -> ()): Motion
			local motion: Motion = { elapsed = 0, seconds = seconds, progress = 0, sample = sample, finish = finish }
			active[motion] = true
			if ticker == nil then
				ticker = world.heartbeat:Connect(tick)
			end
			return motion
		end,
		cancel = function(motion: Motion)
			active[motion] = nil
			idle()
		end,
		stop = function()
			table.clear(active)
			idle()
			local current = service
			if current and owned then
				current:Destroy()
			end
			service = nil
		end,
	}
end

local function tableRules(world: Types.Engine, sheet: S.Node)
	Theme.rule(world, sheet, "." .. TABLE.head, Theme.plate "tableHeader")
	Theme.rule(world, sheet, "." .. TABLE.row, Theme.plate "tableRow")
	Theme.rule(
		world,
		sheet,
		`.{TABLE.head}::UICorner, .{TABLE.row}::UICorner`,
		Theme.corner(world, Theme.radius.control)
	)
	Theme.rule(world, sheet, `.{TABLE.row}::UIStroke`, {
		Color = Theme.token "surface",
		Thickness = 1,
		Transparency = 0,
		BorderStrokePosition = world.types.Enum.BorderStrokePosition.Inner,
	})
	Theme.rule(world, sheet, "." .. TABLE.heading, { BackgroundTransparency = 1 })
	Theme.dividers(world, sheet)
end

table.insert(workloads, {
	id = "leaderboard-100",
	iterations = 6,
	what = "Sort 100 retained player rows by name, replace every score and scroll down, press the Score header twice for ascending and descending order, then replace every score again and let moved rows finish their glide. Checkpoints report rows in motion without their geometry.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local initial: { Player } = {}
		for i = 1, 100 do
			table.insert(
				initial,
				{ id = i, name = string.format("Player %03d", i), score = i * 7 % 101, wins = i * 3 % 97 }
			)
		end
		local source = S.model(world, lane, initial)
		local initialSort: Sort? = { column = "name", direction = "ascending" }
		local sort = S.model(world, lane, initialSort)
		local controls: Controls = {}
		local rows = initial
		local currentSort: Sort = { column = "name", direction = "ascending" }
		local positions: { [number]: number } = {}
		local plainRows: { [number]: S.Node } = {}
		local plainScores: { [number]: S.Node } = {}
		local headings: { [string]: S.Node } = {}
		local gliding: { [S.Node]: Glide } = {}
		local glides = motions(world, Theme.motion.present)
		local body: S.Node? = nil
		local columns: { Types.TableColumn<Player, number> } = {
			{
				id = "name",
				label = "Player",
				value = function(row: Player)
					return row.name
				end,
				width = 200,
				resizable = false,
				render = function(current: Types.ReadOnlyValue<Player>)
					return world.UI.Text("Name" .. current:peek().id) {
						text = function(use: Types.Use)
							return use(current).name
						end,
					}
				end,
			},
			{
				id = "score",
				label = "Score",
				value = function(row: Player)
					return row.score
				end,
				width = 100,
				resizable = false,
				render = function(current: Types.ReadOnlyValue<Player>)
					return world.UI.Text("Score" .. current:peek().id) {
						text = function(use: Types.Use)
							return tostring(use(current).score)
						end,
					}
				end,
			},
			{
				id = "wins",
				label = "Wins",
				value = function(row: Player)
					return row.wins
				end,
				width = 100,
				resizable = false,
				render = function(current: Types.ReadOnlyValue<Player>)
					return world.UI.Text("Wins" .. current:peek().id) {
						text = function(use: Types.Use)
							return tostring(use(current).wins)
						end,
					}
				end,
			},
		}
		local function compare(column: string, left: Player, right: Player): number
			if column == "name" then
				return if left.name == right.name then 0 elseif left.name < right.name then -1 else 1
			end
			local a = if column == "score" then left.score else left.wins
			local b = if column == "score" then right.score else right.wins
			return if a == b then 0 elseif a < b then -1 else 1
		end
		local function ordered(): { Player }
			local sourceIndex: { [number]: number } = {}
			for index, row in rows do
				sourceIndex[row.id] = index
			end
			local result = table.clone(rows)
			local column, descending = currentSort.column, currentSort.direction == "descending"
			table.sort(result, function(left: Player, right: Player): boolean
				local order = compare(column, left, right)
				if order == 0 then
					return sourceIndex[left.id] < sourceIndex[right.id]
				end
				return if descending then order > 0 else order < 0
			end)
			return result
		end
		local function visual(node: S.Node): number
			local entry = gliding[node]
			return if entry
				then entry.goal + entry.delta * (1 - entry.motion.progress)
				else S.udim2(world, node.Position).Y.Offset
		end
		local function glide(node: S.Node, goal: number, delta: number)
			local previous = gliding[node]
			if previous then
				glides.cancel(previous.motion)
			end
			local entry: Glide
			entry = {
				goal = goal,
				delta = delta,
				motion = glides.start(Theme.motion.glide, function()
					node.Position = world.types.UDim2.fromOffset(0, visual(node))
				end, function()
					if gliding[node] == entry then
						gliding[node] = nil
					end
				end),
			}
			gliding[node] = entry
		end
		local function arrange(reset: boolean)
			local frame = assert(body)
			local _, reach = S.window(world, frame)
			local reduced = S.reduced(world)
			for index, row in ordered() do
				if positions[row.id] ~= index then
					positions[row.id] = index
					local node = plainRows[row.id]
					local offset = (index - 1) * TABLE.rowHeight
					local delta = visual(node) - offset
					local entry = gliding[node]
					if math.abs(delta) <= reach and not reduced then
						glide(node, offset, delta)
					elseif entry then
						entry.goal = offset
						node.Position = world.types.UDim2.fromOffset(0, visual(node))
					else
						node.Position = world.types.UDim2.fromOffset(0, offset)
					end
				end
			end
			if reset then
				local at = S.vector2(world, frame.CanvasPosition)
				frame.CanvasPosition = world.types.Vector2.new(at.X, 0)
			end
		end
		local function label(column: Types.TableColumn<Player, number>): string
			local id, text = column.id, column.label
			assert(type(id) == "string" and type(text) == "string")
			local suffix = if currentSort.column == id
				then (if currentSort.direction == "descending" then " ↓" else " ↑")
				else ""
			return text .. suffix
		end
		local function sortBy(next: Sort)
			currentSort = next
			for _, column in columns do
				local id = column.id
				assert(type(id) == "string")
				headings[id].Text = label(column)
			end
			arrange(true)
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local spec: Types.KeyedTableSpec<Player, number> = {
				from = assert(source),
				key = function(row: Player)
					return row.id
				end,
				columns = columns,
				sort = assert(sort),
				mode = "all",
				controls = controls,
				Size = world.types.UDim2.fromOffset(640, 480),
			}
			return UI.Table "Leaderboard"(spec)
		end, function(screen, sheet)
			local Enum, UDim2, UDim = world.types.Enum, world.types.UDim2, world.types.UDim
			tableRules(world, assert(sheet))
			local root = S.create(world, "Frame", "Leaderboard", screen, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Size = UDim2.fromOffset(640, 480),
			})
			local band = S.create(world, "Frame", "HeaderBand", root, {
				Size = UDim2.new(1, 0, 0, TABLE.headerHeight),
			})
			band:AddTag(TABLE.head)
			local header = S.create(world, "Frame", "Header", root, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, -TABLE.scrollBar, 0, TABLE.headerHeight),
			})
			S.create(world, "UIListLayout", "Layout", header, {
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
			})
			local widths: { [string]: number } = {}
			for index, column in columns do
				local id, width = column.id, column.width
				assert(type(id) == "string" and type(width) == "number")
				widths[id] = width
				local cell = S.create(world, "Frame", id, header, {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.new(0, width, 1, 0),
				})
				cell.LayoutOrder = index
				local heading = S.button(world, cell, "Sort", label(column), function()
					local descending = currentSort.column == id and currentSort.direction == "ascending"
					sortBy { column = id, direction = if descending then "descending" else "ascending" }
				end)
				heading.Size = UDim2.fromScale(1, 1)
				heading.AutomaticSize = Enum.AutomaticSize.None
				heading.TextXAlignment = Enum.TextXAlignment.Left
				heading:AddTag(TABLE.heading)
				headings[id] = heading
				if index > 1 then
					local divider = S.create(world, "Frame", "ColumnDivider", cell, {
						Size = UDim2.new(0, 1, 0.6, 0),
					})
					divider.AnchorPoint = world.types.Vector2.new(0, 0.5)
					divider.Position = UDim2.fromScale(0, 0.5)
					divider.ZIndex = 2
					divider:AddTag(Theme.tags.divider)
				end
			end
			local frame = S.create(world, "ScrollingFrame", "Body", root, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, -TABLE.headerHeight),
				ScrollingDirection = Enum.ScrollingDirection.XY,
				CanvasSize = UDim2.fromOffset(400, #rows * TABLE.rowHeight),
			})
			frame.Position = UDim2.fromOffset(0, TABLE.headerHeight)
			frame.ScrollBarThickness = TABLE.scrollBar
			frame.SelectionGroup = true
			body = frame
			local items = S.create(world, "Frame", "Items", frame, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
			})
			for index, row in rows do
				local node = S.create(world, "TextButton", tostring(row.id), items, {
					Text = "",
					AutoButtonColor = false,
					Selectable = true,
					ClipsDescendants = true,
					Size = UDim2.new(1, 0, 0, TABLE.rowHeight),
				})
				node.Position = UDim2.fromOffset(0, (index - 1) * TABLE.rowHeight)
				node:AddTag(TABLE.row)
				positions[row.id] = index
				plainRows[row.id] = node
				S.create(world, "UIListLayout", "Layout", node, {
					FillDirection = Enum.FillDirection.Horizontal,
					SortOrder = Enum.SortOrder.LayoutOrder,
				})
				local values: { [string]: string } =
					{ name = row.name, score = tostring(row.score), wins = tostring(row.wins) }
				local prefixes: { [string]: string } = { name = "Name", score = "Score", wins = "Wins" }
				for order, column in columns do
					local id = column.id
					assert(type(id) == "string")
					local cell = S.create(world, "Frame", id, node, {
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						ClipsDescendants = true,
						Size = UDim2.new(0, widths[id], 1, 0),
					})
					cell.LayoutOrder = order
					local inset = S.create(world, "UIPadding", "Inset", cell)
					inset.PaddingLeft = UDim.new(0, TABLE.cellInset)
					inset.PaddingRight = UDim.new(0, TABLE.cellInset)
					local stack = S.create(world, "UIListLayout", "Layout", cell, {
						SortOrder = Enum.SortOrder.LayoutOrder,
					})
					stack.VerticalAlignment = Enum.VerticalAlignment.Center
					local text = S.fill(world, S.text(world, cell, prefixes[id] .. row.id, values[id]))
					text.AutoLocalize = false
					if id == "score" then
						plainScores[row.id] = text
					end
				end
			end
		end)
		return {
			step = function(index: number)
				if index == 1 then
					local next: Sort = { column = "name", direction = "ascending" }
					if lane == "facet" then
						assert(sort):set(next)
					else
						sortBy(next)
					end
				elseif index == 3 or index == 4 then
					press(world, "Header", "Score")
				elseif index == 6 then
					S.settle(world, Theme.motion.glide)
					return
				else
					if index == 2 then
						S.find(world, "Body").CanvasPosition = world.types.Vector2.new(0, 600)
					end
					local updated: { Player } = {}
					for _, row in rows do
						table.insert(
							updated,
							{ id = row.id, name = row.name, score = (row.score + index) % 101, wins = row.wins }
						)
					end
					rows = updated
					if lane == "facet" then
						assert(source):set(updated)
					else
						for _, row in rows do
							plainScores[row.id].Text = tostring(row.score)
						end
						if currentSort.column == "score" then
							arrange(false)
						end
					end
				end
				world.frame()
			end,
			snapshot = function()
				local order = if lane == "facet" then assert(assert(sort):peek()) else currentSort
				local result: { string } = { `sort={order.column}/{order.direction}` }
				for id = 1, 100 do
					local position = if lane == "facet" then assert(controls.indexOfKey)(id) else positions[id]
					table.insert(result, tostring(id) .. ":" .. tostring(position))
				end
				local frame = S.find(world, "Body")
				local top = S.vector2(world, frame.AbsolutePosition).Y - S.vector2(world, frame.CanvasPosition).Y
				local names: { string } = { "Leaderboard", "HeaderBand", "Header", "Body" }
				local moving: { string } = {}
				local plates: { string } = {}
				for id = 1, 100 do
					local index = if lane == "facet" then assert(controls.indexOfKey)(id) else positions[id]
					local row = assert(plateOf(world, "Name" .. id), "every row has a plate")
					local settled = not world.layout
						or S.rounded(S.vector2(world, row.AbsolutePosition).Y, 0)
							== S.rounded(top + (assert(index) - 1) * TABLE.rowHeight, 0)
					if id == 1 or id == 2 or id == 15 or id == 50 or id == 100 then
						table.insert(
							plates,
							`plate(Name{id}): {if settled then "" else "moving "}{describe(world, row, not settled)}`
						)
					end
					for _, prefix in { "Name", "Score", "Wins" } do
						if settled then
							table.insert(names, prefix .. id)
						else
							table.insert(
								moving,
								`{prefix}{id}: moving {describe(world, S.find(world, prefix .. id), true)}`
							)
						end
					end
				end
				return table.concat({
					table.concat(result, ","),
					visibleWithin(world, "Header"),
					canvas(world, "Body"),
					table.concat(plates, "\n"),
					table.concat(moving, "\n"),
					S.observe(world, names),
				}, "\n")
			end,
			stop = function()
				table.clear(gliding)
				glides.stop()
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "theme-swap-200",
	iterations = 4,
	what = "Swap the content colour on 200 themed buttons and back. Each swap is checked mid-transition and after the theme paint transition settles. Facet updates its theme source; plain sets one colour attribute on its theme StyleSheet.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local first: Types.ThemePackage? = nil
		local second: Types.ThemePackage? = nil
		local theme: Types.Value<Types.ThemePackage>? = nil
		local UI: Types.Controls? = nil
		local alternate = world.types.Color3.new(0.8, 0.9, 1)
		if lane == "facet" then
			local initial, changed = world.Facet.themes.neutralPackage(), world.Facet.themes.neutralPackage()
			changed.style.themes[1].colors.content = { r = 0.8, g = 0.9, b = 1 }
			local function freeze(value: unknown)
				if type(value) == "table" then
					if not table.isfrozen(value) then
						for key, child in value do
							freeze(key)
							freeze(child)
						end
						table.freeze(value)
					end
				end
			end
			freeze(initial)
			freeze(changed)
			first, second = initial, changed
			theme = S.model(world, lane, initial)
			UI = world.Facet.controls(world.runtime, { types = world.types, theme = assert(theme) })
		end
		local sheet: Types.Node? = nil
		local release: () -> () = function() end
		local stop = S.mount(world, lane, function()
			local Compose, Host, controls = world.Compose, world.Host, assert(UI)
			local children: { Types.Node } = {}
			for i = 1, 200 do
				table.insert(
					children,
					controls.Button("Themed" .. i) { label = `Action {i}`, onActivate = function() end }
				)
			end
			sheet = world.Facet.themes.createStyleSheet(world.runtime, assert(theme), { types = world.types })
			local content: { Types.Child } = {
				sheet,
				Host.StyleLink { StyleSheet = Compose.static(sheet) },
				controls.Grid "Controls" { columns = 10, gap = 8, table.unpack(children) },
			}
			local props: FrameProps = {
				Name = "ThemedScreen",
				Size = world.types.UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				table.unpack(content),
			}
			return Host.Frame(props)
		end, function(screen)
			local made, unstyle = Theme.create(world, screen)
			sheet, release = made, unstyle
			local root = S.grid(world, screen, "Controls", 10)
			for i = 1, 200 do
				S.button(world, root, "Themed" .. i, `Action {i}`, function() end)
			end
		end, true)
		return {
			step = function(index: number)
				if index % 2 == 0 then
					world.frame(0.4)
					return
				end
				local changed = index % 4 == 1
				if lane == "facet" then
					assert(theme):set(assert(if changed then second else first))
				else
					assert(sheet):SetAttribute("content", if changed then alternate else Theme.color(world, "content"))
				end
				world.frame(0.1)
			end,
			snapshot = function()
				local attribute = if lane == "facet" then "FacetColor_content" else "content"
				local content = S.rgb(world, assert(sheet):GetAttribute(attribute))
				local lines: { string } = { `content={content}` }
				local names: { string } = { "Controls" }
				for _, name in { "Themed1", "Themed2", "Themed11", "Themed100", "Themed200" } do
					if S.rgb(world, S.find(world, name):GetStyled "TextColor3") == content then
						table.insert(names, name)
					else
						table.insert(lines, `{name}: ink in transition`)
					end
				end
				table.insert(lines, S.observe(world, names))
				return table.concat(lines, "\n")
			end,
			stop = function()
				stop()
				release()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "heavy-screen-20-cycles",
	iterations = 20,
	what = "Close a scrolling screen of 200 actions and 200 text rows and open a fresh one, 20 times, inside one themed ScreenGui. Each lifetime is laid out for one frame. The theme StyleSheet stays mounted.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local initial: { number } = { 0 }
		local lifetime = S.model(world, lane, initial)
		local completed = 0
		local host: S.Node? = nil
		local current: S.Node? = nil
		local seen: S.Node? = nil
		local function build(screen: S.Node): S.Node
			local Enum, UDim2 = world.types.Enum, world.types.UDim2
			local root = S.create(world, "ScrollingFrame", "Heavy", nil, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromOffset(640, 480),
				CanvasSize = UDim2.fromOffset(0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollingDirection = Enum.ScrollingDirection.Y,
			})
			root.Selectable = false
			root.Active = true
			S.create(world, "UIListLayout", "Layout", root, {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = world.types.UDim.new(0, 8),
			})
			for i = 1, 200 do
				S.button(world, root, "Action" .. i, `Action {i}`, function() end).LayoutOrder = 2 * i - 1
				S.fill(world, S.text(world, root, "Detail" .. i, `Detail {i}`)).LayoutOrder = 2 * i
			end
			root.Parent = screen
			return root
		end
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			local spec: Types.KeyedCollectionSpec<number, number> = {
				from = assert(lifetime),
				key = function(cycle: number)
					return cycle
				end,
				render = function()
					local children: { Types.Node } = {}
					for i = 1, 200 do
						table.insert(
							children,
							UI.Button("Action" .. i) { label = `Action {i}`, onActivate = function() end }
						)
						table.insert(children, UI.Text("Detail" .. i) { text = `Detail {i}` })
					end
					return UI.ScrollView "Heavy" {
						gap = 8,
						Size = world.types.UDim2.fromOffset(640, 480),
						table.unpack(children),
					}
				end,
			}
			return (world.Compose.keyed(spec) :: unknown) :: Types.Node
		end, function(screen)
			host = screen
			current = build(screen)
		end)
		return {
			step = function(index: number)
				if lane == "facet" then
					local next: { number } = { index }
					assert(lifetime):set(next)
				else
					assert(current):Destroy()
					current = build(assert(host))
				end
				completed = index
				world.frame()
			end,
			snapshot = function()
				local heavy = S.find(world, "Heavy")
				local screen = assert(heavy.Parent)
				local open = 0
				for _, child in screen:GetChildren() do
					if child.Name == "Heavy" then
						open += 1
					end
				end
				local previous = seen
				local fresh = previous ~= heavy
				local released = previous == nil or previous.Parent == nil
				seen = heavy
				return table.concat({
					`lifetime={completed} open={open} fresh={fresh} released={released} content={#heavy:GetDescendants() >= 400}`,
					canvas(world, "Heavy"),
					S.observe(world, {
						"Heavy",
						"Action1",
						"Detail1",
						"Action2",
						"Detail100",
						"Action200",
						"Detail200",
					}),
				}, "\n")
			end,
			stop = stop,
		}
	end,
})

local DRAG = table.freeze {
	held = "pl-drag-held",
	tooltip = "pl-tooltip",
	accepted = "pl-drop-accepted",
	gap = 8,
	target = 44,
	width = 280,
	radius = 6,
	stroke = 0.4,
}

type DragMode = "armed" | "pointer"
type Point = { X: number, Y: number }
type DragSession = {
	id: number,
	mode: DragMode,
	ghost: S.Node,
	size: Point,
	origin: Point,
	position: Point?,
	target: S.Node?,
}
type DragSignal = { Connect: (DragSignal, (unknown) -> ()) -> Watch }
type Detector = { DragStart: DragSignal, DragContinue: DragSignal, DragEnd: DragSignal }
type Effective = "Touch" | "Gamepad" | "KeyboardAndMouse"

local function dragRules(world: Types.Engine, sheet: S.Node)
	local Enum = world.types.Enum
	Theme.rule(world, sheet, "." .. DRAG.held, { TextTransparency = 1 })
	Theme.rule(world, sheet, "." .. DRAG.tooltip, Theme.plate "surfaceStrong")
	Theme.rule(world, sheet, `.{DRAG.tooltip}::UICorner`, Theme.corner(world, DRAG.radius))
	Theme.rule(world, sheet, `.{DRAG.tooltip}::UIStroke`, {
		Color = Theme.token "hairline",
		Transparency = DRAG.stroke,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		BorderStrokePosition = Enum.BorderStrokePosition.Inner,
	})
	Theme.rule(world, sheet, "." .. DRAG.accepted, { Color = Theme.token "accent" })
end

local function textState(world: Types.Engine, name: string): string?
	local node = S.find(world, name)
	local alpha = node:GetStyled "TextTransparency"
	if alpha == 0 then
		return nil
	end
	local state = if type(alpha) == "number" and alpha >= 1 then "hidden" else "fading"
	local facts = { `{name}: text={tostring(node.Text)} {state}` }
	if world.layout then
		local at, size = S.vector2(world, node.AbsolutePosition), S.vector2(world, node.AbsoluteSize)
		table.insert(
			facts,
			`at={S.rounded(at.X, 0)},{S.rounded(at.Y, 0)} extent={S.rounded(size.X, 0)}x{S.rounded(size.Y, 0)}`
		)
	end
	return table.concat(facts, " ")
end

table.insert(workloads, {
	id = "tile-transfer-20",
	iterations = 41,
	what = "Pick up 20 tiles with keyboard activation and drop each into the second grid. Before each pickup the player waits for the previous drop preview to shrink away. Checkpoints alternate between the held state and the moment after the drop; the last one waits for the final preview.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local ids: { number } = {}
		local initial: { [number]: string } = {}
		for i = 1, 20 do
			table.insert(ids, i)
			initial[i] = "GridA"
		end
		local placement = S.model(world, lane, initial)
		local destinations: { [number]: string } = table.clone(initial)
		local watchers: { Watch } = {}
		local escape: Roblox.Connection? = nil
		local travels = motions(world, Theme.motion.travelEase)
		local completed = 0
		local phase = "mounted"
		local stop = S.mount(world, lane, function()
			local UI, Compose = world.UI, world.Compose
			local where = assert(placement)
			local function tiles(grid: string): unknown
				local spec: Types.KeyedCollectionSpec<number, number> = {
					from = function(use: Types.Use): { number }
						local current = use(where)
						local result: { number } = {}
						for _, id in ids do
							if current[id] == grid then
								table.insert(result, id)
							end
						end
						return result
					end,
					key = function(id: number)
						return id
					end,
					render = function(current: Types.ReadOnlyValue<number>)
						local id = current:peek()
						local tile = UI.Button("Tile" .. id) { label = `Tile {id}` }
						UI.draggable(tile, {
							payload = id,
							onEnd = function(accepted: boolean)
								local now = where:peek()
								if accepted and now[id] ~= destinations[id] then
									local moved = table.clone(now)
									moved[id] = destinations[id]
									where:set(moved)
								end
							end,
						})
						return tile
					end,
				}
				return Compose.keyed(spec)
			end
			local drop = UI.Button "Drop" { label = "Move here" }
			UI.dropTarget(drop, {
				onDrop = function(payload: unknown)
					assert(type(payload) == "number")
					destinations[payload] = "GridB"
				end,
			})
			return UI.VStack "Transfer" {
				width = "fill",
				gap = 8,
				UI.Grid "GridA" { columns = 5, gap = 8, tiles "GridA" },
				UI.Grid "GridB" { columns = 5, gap = 8, tiles "GridB" },
				drop,
			}
		end, function(screen, sheet)
			local Enum, UDim2, Vector2 = world.types.Enum, world.types.UDim2, world.types.Vector2
			dragRules(world, assert(sheet))
			local transfer = S.stack(world, screen, "Transfer", false, { fill = true, gap = 8 })
			local gridA = S.grid(world, transfer, "GridA", 5)
			local gridB = S.grid(world, transfer, "GridB", 5)
			local tiles: { [number]: S.Node } = {}
			local detectors: { [number]: S.Node } = {}
			local origins: { [number]: Point } = {}
			local pointerPress: { [number]: boolean } = {}
			local returning: { [number]: () -> () } = {}
			local session: DragSession? = nil
			local panel: S.Node? = nil
			local label: S.Node? = nil
			local limit: S.Node? = nil
			local input = world.inputService
			local gui = world.guiService
			local function point(value: unknown): Point
				local vector = S.vector2(world, value)
				return { X = vector.X, Y = vector.Y }
			end
			local function effective(): Effective
				if input == nil then
					return "KeyboardAndMouse"
				end
				local preferred = input.PreferredInput
				if preferred == Enum.PreferredInput.Touch then
					return "Touch"
				elseif preferred == Enum.PreferredInput.Gamepad then
					return "Gamepad"
				elseif input.MouseEnabled == true then
					return "KeyboardAndMouse"
				elseif input.TouchEnabled == true then
					return "Touch"
				elseif input.GamepadEnabled == true then
					return "Gamepad"
				end
				return "KeyboardAndMouse"
			end
			local function pointing(): boolean
				if input == nil then
					return true
				end
				local last = (input.GetLastInputType :: (S.Node) -> unknown)(input)
				return input.PreferredInput ~= Enum.PreferredInput.Gamepad
					and last ~= Enum.UserInputType.Keyboard
					and effective() ~= "Touch"
			end
			local drop: S.Node
			local outline: S.Node
			local cancel: S.Node
			local place: (DragSession) -> () = function(_current: DragSession) end
			local function statusPanel(): (S.Node, S.Node)
				local frame, text = panel, label
				if frame and text then
					return frame, text
				end
				local made = S.create(world, "Frame", "DragStatus", nil, {
					Size = UDim2.fromOffset(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
				})
				made.ZIndex = 1001
				made:AddTag(DRAG.tooltip)
				S.padding(world, made, DRAG.gap, DRAG.gap)
				local written = S.create(world, "TextLabel", "DragStatusText", made, {
					Text = "Choose a destination",
					Size = UDim2.fromOffset(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
				})
				written.TextWrapped = true
				written.ZIndex = 1002
				written:AddTag(Theme.tags.text)
				local bounds = S.vector2(world, screen.AbsoluteSize)
				limit = S.create(world, "UISizeConstraint", "UISizeConstraint", written, {
					MinSize = Vector2.zero,
				})
				assert(limit).MaxSize = Vector2.new(math.max(1, math.min(DRAG.width, bounds.X - 32)), math.huge)
				made.Parent = screen
				panel, label = made, written
				made:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
					local current = session
					if current then
						place(current)
					end
				end)
				return made, written
			end
			place = function(current: DragSession)
				local frame = assert(panel)
				if not frame.Visible and current.mode ~= "armed" then
					return
				end
				local layer = S.vector2(world, screen.AbsolutePosition)
				local bounds = S.vector2(world, screen.AbsoluteSize)
				local size = S.vector2(world, frame.AbsoluteSize)
				local anchor = current.target
				local at: Point = current.position
					or (if anchor then point(anchor.AbsolutePosition) else current.origin)
				local x, y = at.X - layer.X, at.Y - layer.Y
				local gap = DRAG.gap
				if current.mode == "armed" then
					local extent = current.size
					local left, top = x + gap, y + gap
					if anchor then
						local corner, extentOf =
							S.vector2(world, anchor.AbsolutePosition), S.vector2(world, anchor.AbsoluteSize)
						local edgeX, edgeY = corner.X + extentOf.X - layer.X, corner.Y + extentOf.Y - layer.Y
						left = edgeX + gap
						top = y - extent.Y - size.Y - gap * 3
						if top < gap and edgeY + extent.Y + size.Y + gap * 3 <= bounds.Y then
							top = edgeY + gap
						end
					end
					local ghost = current.ghost
					ghost.AnchorPoint = Vector2.zero
					ghost.Position = UDim2.fromOffset(
						math.clamp(left, gap, math.max(gap, bounds.X - extent.X - gap)),
						math.clamp(top, gap, math.max(gap, bounds.Y - extent.Y - size.Y - gap * 3))
					)
					local placed = S.udim2(world, ghost.Position)
					x, y = placed.X.Offset - gap, placed.Y.Offset + extent.Y + gap - DRAG.target
				end
				assert(limit).MaxSize = Vector2.new(math.max(1, math.min(DRAG.width, bounds.X - gap * 4)), math.huge)
				frame.Position = UDim2.fromOffset(
					math.clamp(x + gap, gap, math.max(gap, bounds.X - size.X - gap)),
					math.clamp(y + DRAG.target, gap, math.max(gap, bounds.Y - size.Y - gap))
				)
			end
			local function update(current: DragSession)
				local frame, text = statusPanel()
				local hint = if current.target
					then "Move"
					elseif current.mode == "armed" then "Choose a destination"
					else "Cannot drop here"
				if current.mode == "armed" then
					local kind = effective()
					hint ..= " · " .. (if kind == "Gamepad"
						then "A: drop · B: cancel"
						elseif kind == "Touch" then "Tap a destination"
						else "Enter: drop · Esc: cancel · Tab: destination")
				end
				if text.Text ~= hint then
					text.Text = hint
				end
				frame.Visible = current.mode == "armed" or current.target == nil
				place(current)
			end
			local function hover(current: DragSession, target: S.Node?)
				if current.target ~= target then
					outline.Enabled = false
					current.target = target
				end
				if target then
					outline.Enabled = true
					if not outline:HasTag(DRAG.accepted) then
						outline:AddTag(DRAG.accepted)
					end
				end
				update(current)
			end
			local function over(at: Point): S.Node?
				local corner = S.vector2(world, drop.AbsolutePosition)
				local size = S.vector2(world, drop.AbsoluteSize)
				return if drop.Visible == true
						and at.X >= corner.X
						and at.Y >= corner.Y
						and at.X <= corner.X + size.X
						and at.Y <= corner.Y + size.Y
					then drop
					else nil
			end
			local function syncDetectors()
				local allowed = pointing()
				for _, detector in detectors do
					detector.Enabled = allowed
				end
			end
			local function release(current: DragSession, accepted: boolean)
				local ghost = current.ghost
				if S.reduced(world) or ghost.Parent == nil then
					ghost:Destroy()
					return
				end
				if accepted then
					local scale = S.create(world, "UIScale", "UIScale", ghost)
					travels.start(Theme.motion.travel, function(progress: number)
						scale.Scale = 1 - progress
					end, function()
						ghost:Destroy()
					end)
					return
				end
				local tile = tiles[current.id]
				local corner = S.vector2(world, tile.AbsolutePosition)
				local anchor = S.vector2(world, ghost.AnchorPoint)
				local layer = S.vector2(world, screen.AbsolutePosition)
				local from = S.udim2(world, ghost.Position)
				local goalX = corner.X + anchor.X * current.size.X - layer.X
				local goalY = corner.Y + anchor.Y * current.size.Y - layer.Y
				local fromX, fromY = from.X.Offset, from.Y.Offset
				local motion = travels.start(Theme.motion.travel, function(progress: number)
					ghost.Position = UDim2.fromOffset(
						math.round(fromX + (goalX - fromX) * progress),
						math.round(fromY + (goalY - fromY) * progress)
					)
				end, function()
					returning[current.id] = nil
					ghost:Destroy()
				end)
				returning[current.id] = function()
					returning[current.id] = nil
					travels.cancel(motion)
					ghost:Destroy()
				end
			end
			local function finish(accepted: boolean)
				local current = session
				if current == nil then
					return
				end
				session = nil
				cancel.Enabled = false
				assert(panel).Visible = false
				outline.Enabled = false
				local tile = tiles[current.id]
				tile:RemoveTag(DRAG.held)
				if accepted then
					tile.Parent = if destinations[current.id] == "GridB" then gridB else gridA
				end
				release(current, accepted)
			end
			local function begin(id: number, mode: DragMode, press: Point?)
				if session then
					return
				end
				local stopReturn = returning[id]
				if stopReturn then
					stopReturn()
				end
				local tile = tiles[id]
				local corner = S.vector2(world, tile.AbsolutePosition)
				local extent = S.vector2(world, tile.AbsoluteSize)
				local size: Point = { X = extent.X, Y = extent.Y }
				local offset: Point = if press
					then { X = press.X - corner.X, Y = press.Y - corner.Y }
					else { X = size.X / 2, Y = size.Y / 2 }
				local origin: Point = { X = corner.X + size.X / 2, Y = corner.Y + size.Y / 2 }
				local layer = S.vector2(world, screen.AbsolutePosition)
				local frame = statusPanel()
				frame.Visible = true
				local ghost = assert(tile:Clone()) :: S.Node
				for _, descendant in ghost:GetDescendants() do
					local node = world.node(descendant)
					if node:IsA "GuiObject" then
						node.Interactable, node.Active, node.Selectable = false, false, false
					end
				end
				ghost.Interactable, ghost.Active, ghost.Selectable = false, false, false
				ghost.Name, ghost.ZIndex = "DragGhost", 1000
				ghost.AnchorPoint = Vector2.new(
					if size.X > 0 then math.clamp(offset.X / size.X, 0, 1) else 0.5,
					if size.Y > 0 then math.clamp(offset.Y / size.Y, 0, 1) else 0.5
				)
				ghost.Size = UDim2.fromOffset(size.X, size.Y)
				local at = press or origin
				ghost.Position = UDim2.fromOffset(at.X - layer.X, at.Y - layer.Y)
				ghost.Parent = screen
				tile:AddTag(DRAG.held)
				cancel.Enabled = true
				local current: DragSession =
					{ id = id, mode = mode, ghost = ghost, size = size, origin = origin, position = press }
				session = current
				update(current)
			end
			local function dropHeld()
				local current = session
				if current == nil then
					return
				end
				destinations[current.id] = "GridB"
				finish(true)
			end
			drop = S.button(world, transfer, "Drop", "Move here", function()
				local current = session
				if current and current.mode == "armed" then
					dropHeld()
				end
			end)
			outline = S.create(world, "UIStroke", "DropOutline", drop)
			outline.Enabled = false
			outline.Thickness = 1
			outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			outline.BorderStrokePosition = Enum.BorderStrokePosition.Inner
			cancel = S.action(
				world,
				screen,
				"DragCancel",
				250,
				{ Enum.KeyCode.Escape, Enum.KeyCode.ButtonB },
				function()
					finish(false)
				end
			)
			cancel.Enabled = false
			for _, id in ids do
				local tile = S.button(world, gridA, "Tile" .. id, `Tile {id}`, function()
					if pointerPress[id] then
						pointerPress[id] = nil
						return
					end
					begin(id, "armed", nil)
				end)
				tiles[id] = tile
				tile.InputBegan:Connect(function(value: unknown)
					local kind = (value :: { UserInputType: unknown }).UserInputType
					if kind == Enum.UserInputType.MouseButton1 or kind == Enum.UserInputType.Touch then
						pointerPress[id] = true
					end
				end)
				local detector = S.create(world, "UIDragDetector", "DragDetector", tile)
				detector.Archivable = false
				detector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane
				detector.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				detectors[id] = detector
				local signals = (detector :: unknown) :: Detector
				signals.DragStart:Connect(function(position: unknown)
					origins[id] = point(position)
				end)
				signals.DragContinue:Connect(function(position: unknown)
					local at, origin = point(position), origins[id]
					if
						session == nil
						and origin
						and math.sqrt((at.X - origin.X) ^ 2 + (at.Y - origin.Y) ^ 2) >= S.DRAG_THRESHOLD
					then
						begin(id, "pointer", origin)
					end
					local current = session
					if current and current.id == id and current.mode == "pointer" then
						current.position = at
						local layer = S.vector2(world, screen.AbsolutePosition)
						current.ghost.Position = UDim2.fromOffset(at.X - layer.X, at.Y - layer.Y)
						hover(current, over(at))
					end
				end)
				signals.DragEnd:Connect(function(position: unknown)
					origins[id], pointerPress[id] = nil, nil
					local current = session
					if current and current.id == id and current.mode == "pointer" then
						local at = point(position)
						current.position = at
						hover(current, over(at))
						if current.target then
							dropHeld()
						else
							finish(false)
						end
					end
				end)
			end
			syncDetectors()
			if input then
				local events = (input :: unknown) :: InputEvents
				local function changed()
					syncDetectors()
					local current = session
					if current then
						update(current)
					end
				end
				table.insert(watchers, events.LastInputTypeChanged:Connect(changed))
				for _, property in { "PreferredInput", "MouseEnabled", "TouchEnabled", "GamepadEnabled" } do
					table.insert(watchers, events:GetPropertyChangedSignal(property):Connect(changed))
				end
				local keys = input
				escape = keys.InputBegan:Connect(function(value: unknown)
					local code = (value :: { KeyCode: unknown }).KeyCode
					if code == Enum.KeyCode.Escape and session and keys:GetFocusedTextBox() == nil then
						finish(false)
					end
				end)
			end
			if gui then
				local service = (gui :: unknown) :: InputEvents
				table.insert(
					watchers,
					service:GetPropertyChangedSignal("SelectedObject"):Connect(function()
						local current = session
						if current and current.mode == "armed" then
							hover(current, if gui.SelectedObject == drop then drop else nil)
						end
					end)
				)
			end
		end)
		local keyboard = S.returnKey(world)
		return {
			step = function(index: number)
				local travel = S.motion(world, lane).travel
				if index > 40 then
					phase = "settled"
					S.settle(world, travel)
					return
				end
				local tile = math.ceil(index / 2)
				if index % 2 == 1 then
					phase = "held"
					S.settle(world, travel)
					S.fire(world, "Tile" .. tile, "Activated", keyboard)
				else
					phase = "dropped"
					S.fire(world, "Drop", "Activated", keyboard)
					completed = tile
				end
				world.frame()
			end,
			snapshot = function()
				local rows: { string } = {}
				local holding = if phase == "held" then completed + 1 else nil
				local hidden = 0
				for i = 1, 20 do
					local tile = S.find(world, "Tile" .. i)
					local home = tostring(assert(tile.Parent).Name)
					if home ~= (if i <= completed then "GridB" else "GridA") then
						error(
							`tile input did not complete the transfer: Tile{i} is in {home} after {completed} drops`,
							0
						)
					end
					table.insert(rows, tostring(tile.Text) .. ":" .. home)
				end
				local names: { string } = { "Transfer", "GridA", "GridB", "Drop" }
				local lines: { string } = {}
				for i = 1, 20 do
					local state = textState(world, "Tile" .. i)
					if state then
						hidden += 1
						table.insert(lines, state)
					else
						table.insert(names, "Tile" .. i)
					end
				end
				local ghosts = 0
				for _, node in world.target:GetDescendants() do
					if node.Name == "DragGhost" then
						ghosts += 1
					end
				end
				local ghost = world.target:FindFirstChild("DragGhost", true)
				if ghost then
					local scale = ghost:FindFirstChildWhichIsA "UIScale"
					local value: unknown = if scale then world.node(scale):GetStyled "Scale" else 1
					if type(value) == "number" and value > 0 and value < 1 then
						table.insert(lines, `DragGhost: shrinking text={tostring(world.node(ghost).Text)}`)
					else
						table.insert(names, "DragGhost")
					end
				end
				local status = world.target:FindFirstChild("DragStatus", true)
				if status and status:IsA "GuiObject" and status.Visible == true then
					table.insert(names, "DragStatus")
					table.insert(names, "DragStatusText")
				else
					table.insert(lines, "DragStatus: hidden")
				end
				local focused = S.selected(world)
				local focus = if focused then tostring(focused.Name) else "none"
				table.insert(
					rows,
					1,
					`phase={phase} holding={holding or "none"} held={hidden} ghosts={ghosts} sinks={S.sinks(world)} focus={focus}`
				)
				table.insert(rows, table.concat(lines, "\n"))
				table.insert(rows, S.observe(world, names))
				return table.concat(rows, "\n")
			end,
			stop = function()
				for _, watch in watchers do
					watch:Disconnect()
				end
				local listening = escape
				if listening then
					listening:Disconnect()
				end
				travels.stop()
				stop()
			end,
		}
	end,
})

return workloads
