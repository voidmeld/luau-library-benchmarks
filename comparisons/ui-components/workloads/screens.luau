--!strict

local Types = require "../types"
local S = require "./support"
type FrameProps = Types.Props
type FolderProps = Types.Props

type Player = { id: number, name: string, score: number, wins: number }
type Sort = { column: string, direction: "ascending" | "descending" }
type Controls = {
	indexOfKey: ((number) -> number?)?,
	offsetOf: ((number, ("center" | "end" | "start")?, number?) -> number)?,
	placementOf: ((number) -> Types.CollectionPlacement)?,
}

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "leaderboard-100",
	iterations = 6,
	what = "Sort 100 retained player rows by name, score and wins; replace every score after each sort.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
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
		local plainRows: { [number]: S.Node } = {}
		local plainScores: { [number]: S.Node } = {}
		local rows = initial
		local currentSort: Sort = { column = "name", direction = "ascending" }
		local function order()
			local ordered = table.clone(rows)
			local column = currentSort.column
			if column == "name" then
				table.sort(ordered, function(a: Player, b: Player)
					return a.name < b.name
				end)
			elseif column == "score" then
				table.sort(ordered, function(a: Player, b: Player)
					return a.score < b.score
				end)
			else
				table.sort(ordered, function(a: Player, b: Player)
					return a.wins < b.wins or (a.wins == b.wins and a.id < b.id)
				end)
			end
			for index, row in ordered do
				plainRows[row.id].LayoutOrder = index
			end
		end
		local columns: { Types.TableColumn<Player, number> } = {
			{
				id = "name",
				label = "Player",
				value = function(row: Player)
					return row.name
				end,
				width = 200,
				render = function(current: Types.ReadOnlyValue<Player>)
					return UI.Text("Name" .. current:peek().id) {
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
				render = function(current: Types.ReadOnlyValue<Player>)
					return UI.Text("Score" .. current:peek().id) {
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
				render = function(current: Types.ReadOnlyValue<Player>)
					return UI.Text("Wins" .. current:peek().id) {
						text = function(use: Types.Use)
							return tostring(use(current).wins)
						end,
					}
				end,
			},
		}
		local stop = S.mount(world, lane, function()
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
		end, function(screen)
			local root = S.stack(world, screen, "Leaderboard")
			local header = S.stack(world, root, "Header", true)
			for _, column in columns do
				local label, id = column.label, column.id
				assert(type(label) == "string" and type(id) == "string")
				S.button(world, header, id, label, function()
					currentSort = { column = id, direction = "ascending" }
					order()
				end)
			end
			local scroll = S.create(world, "ScrollingFrame", "Body", root, {
				Size = world.types.UDim2.fromOffset(640, 400),
				AutomaticCanvasSize = world.types.Enum.AutomaticSize.Y,
			})
			local items = S.stack(world, scroll, "Items")
			for _, row in rows do
				local node = S.stack(world, items, "Player" .. row.id, true)
				plainRows[row.id] = node
				S.text(world, node, "Name" .. row.id, row.name, true)
				plainScores[row.id] = S.text(world, node, "Score" .. row.id, tostring(row.score), true)
				S.text(world, node, "Wins" .. row.id, tostring(row.wins), true)
			end
			order()
		end)
		return {
			step = function(index: number)
				if index % 2 == 1 then
					local id = columns[math.ceil(index / 2)].id
					assert(type(id) == "string")
					currentSort = { column = id, direction = "ascending" }
					if lane == "facet" then
						assert(sort):set(currentSort)
					else
						order()
					end
				else
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
							S.setText(world, plainScores[row.id], tostring(row.score))
						end
						if currentSort.column == "score" then
							order()
						end
					end
				end
				world.frame()
			end,
			snapshot = function()
				local result: { string } = {}
				for id = 1, 100 do
					local position = if lane == "facet"
						then assert(controls.indexOfKey)(id)
						else plainRows[id].LayoutOrder
					table.insert(result, tostring(id) .. ":" .. tostring(position))
				end
				local names: { string } = {}
				for id = 1, 100 do
					table.insert(names, "Name" .. id)
					table.insert(names, "Score" .. id)
					table.insert(names, "Wins" .. id)
				end
				return table.concat(result, ",") .. "\n" .. S.snapshot(world, names)
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "theme-swap-200",
	iterations = 5,
	what = "Swap two neutral packages on 200 themed buttons. Both lanes build both themes in setup. Facet updates its StyleSheet tokens while plain relinks one of two prebuilt theme StyleSheets.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local Compose, Host = world.Compose, world.Host
		local first, second = world.Facet.themes.neutralPackage(), world.Facet.themes.neutralPackage()
		second.style.themes[1].colors.content = { r = 0.8, g = 0.9, b = 1 }
		local function freeze(value: unknown)
			if type(value) == "table" then
				local record = value :: { [unknown]: unknown }
				if not table.isfrozen(record) then
					for key, child in record do
						freeze(key)
						freeze(child)
					end
					table.freeze(record)
				end
			end
		end
		freeze(first)
		freeze(second)
		local theme = S.model(world, lane, first)
		if lane == "facet" then
			local holder = world.new "Folder"
			world.runtime.mount(function()
				return world.Facet.themes.createStyleSheet(world.runtime, second, { types = world.types })
			end, holder)()
			world.destroy(holder)
		end
		local UI = if lane == "facet"
			then world.Facet.controls(world.runtime, { types = world.types, theme = assert(theme) })
			else world.UI
		local sheet: Types.Node? = nil
		local link: S.Node? = nil
		local sheets: { Types.Node } = {}
		local stop = S.mount(world, lane, function()
			local children: { Types.Node } = {}
			for i = 1, 200 do
				table.insert(children, UI.Button("Themed" .. i) { label = `Action {i}`, onActivate = function() end })
			end
			sheet = world.Facet.themes.createStyleSheet(world.runtime, assert(theme), { types = world.types })
			local content: { Types.Child } = {
				sheet,
				Host.StyleLink { StyleSheet = Compose.static(sheet) },
				UI.Grid "Controls" { columns = 10, gap = 8, table.unpack(children) },
			}
			local props: FrameProps = { Name = "ThemedScreen", table.unpack(content) }
			return Host.Frame(props)
		end, function(screen)
			for _, package in { first, second } do
				world.runtime.mount(function()
					local made = world.Facet.themes.createStyleSheet(world.runtime, package, { types = world.types })
					table.insert(sheets, made)
					return made
				end, screen)
			end
			local made: S.Node = world.new "StyleLink"
			made.StyleSheet = sheets[1]
			made.Parent = screen
			link = made
			local root = S.grid(world, screen, "Controls", 10)
			for i = 1, 200 do
				S.button(world, root, "Themed" .. i, `Action {i}`, function() end)
			end
		end, true)
		return {
			step = function(index: number)
				local package = if index % 2 == 1 then second else first
				if lane == "facet" then
					assert(theme):set(package)
				else
					assert(link).StyleSheet = if package == first then sheets[1] else sheets[2]
				end
				world.frame(0.5)
			end,
			snapshot = function()
				if lane == "facet" then
					return tostring(assert(sheet):GetAttribute "FacetColor_content")
				end
				local linked = assert(link).StyleSheet
				for _, candidate in sheets do
					if candidate == linked then
						return tostring(candidate:GetAttribute "FacetColor_content")
					end
				end
				error "the plain lane links no theme StyleSheet"
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "heavy-screen-20-cycles",
	iterations = 20,
	what = "Mount and dispose 200 action controls and 200 text rows, 20 complete lifetimes.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local completed = 0
		return {
			step = function()
				local stop = S.mount(world, lane, function()
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
				end, function(screen)
					local root = S.create(world, "ScrollingFrame", "Heavy", screen, {
						Size = world.types.UDim2.fromOffset(640, 480),
						AutomaticCanvasSize = world.types.Enum.AutomaticSize.Y,
					})
					local content = S.stack(world, root, "Content")
					for i = 1, 200 do
						S.button(world, content, "Action" .. i, `Action {i}`, function() end)
						S.text(world, content, "Detail" .. i, `Detail {i}`)
					end
				end)
				assert(#S.find(world, "Heavy"):GetDescendants() >= 400)
				stop()
				completed += 1
			end,
			snapshot = function()
				return tostring(completed) .. ":" .. tostring(#world.target:GetChildren())
			end,
			stop = function() end,
		}
	end,
})

table.insert(workloads, {
	id = "tile-transfer-20",
	iterations = 20,
	what = "Pick up 20 tiles with keyboard activation and drop each into the second grid. Both lanes show a drag preview, a held state, a status hint and a cancel input context, and shrink the preview with the theme travel motion after the drop. Facet also installs pointer drop resolution.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI, Compose, Host = world.UI, world.Compose, world.Host
		local ids: { number } = {}
		for i = 1, 20 do
			table.insert(ids, i)
		end
		local targets: { [number]: Types.Value<Types.Node> } = {}
		local destinations: { [number]: string } = {}
		local plainTiles: { [number]: S.Node } = {}
		local gridB: S.Node? = nil
		local held: number? = nil
		local completed = 0
		local stop = S.mount(world, lane, function()
			local source = UI.Grid "GridA" { columns = 5, gap = 8 }
			local target = UI.Grid "GridB" { columns = 5, gap = 8 }
			local drop = UI.Button "Drop" { label = "Move here" }
			UI.dropTarget(drop, {
				onDrop = function(payload: unknown)
					assert(type(payload) == "number")
					targets[payload]:set(target)
					destinations[payload] = "GridB"
				end,
			})
			local content: { Types.Child } = {
				source,
				target,
				drop,
				Compose.keyed {
					from = function()
						return ids
					end,
					key = function(id: number)
						return id
					end,
					render = function(current: Types.ReadOnlyValue<number>)
						local id = current:peek()
						local parent: Types.Node = source
						targets[id] = Compose.cell(parent)
						destinations[id] = "GridA"
						local props: FolderProps = {
							Name = "TileOwner" .. id,
							Compose.portal(source, function(): { unknown }
								local tile = UI.Button("Tile" .. id) { label = `Tile {id}` }
								UI.draggable(tile, { payload = id })
								Compose.watch(function(use: Types.Use)
									tile.Parent = use(targets[id])
								end)
								return { tile }
							end),
						}
						return Host.Folder(props)
					end,
				},
			}
			local props: FrameProps = { Name = "Transfer", table.unpack(content) }
			return Host.Frame(props)
		end, function(screen)
			local Enum = world.types.Enum
			local source = S.grid(world, screen, "GridA", 5)
			gridB = S.grid(world, screen, "GridB", 5)
			local status = S.create(world, "Frame", "DragStatus", screen, {
				Size = world.types.UDim2.fromOffset(0, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
			})
			status.Visible = false
			status.ZIndex = 1001
			status.Position = world.types.UDim2.fromOffset(8, 8)
			local padding = S.create(world, "UIPadding", "UIPadding", status)
			for _, side in { "PaddingTop", "PaddingBottom", "PaddingLeft", "PaddingRight" } do
				padding[side] = world.types.UDim.new(0, 8)
			end
			local hint = S.text(world, status, "DragStatusText", "", nil, "")
			hint.ZIndex = 1002
			local ghost: S.Node? = nil
			local cancel: S.Node
			local function settle(id: number)
				local tile = plainTiles[id]
				tile:RemoveTag "facet-drag-held"
				assert(tile:FindFirstChild "Drag").Enabled = true
				cancel.Enabled = false
				status.Visible = false
				held = nil
			end
			local function pickUp(id: number)
				local tile = plainTiles[id]
				local preview = assert(tile:Clone()) :: S.Node
				preview.Name = "DragGhost"
				preview.Interactable, preview.Active, preview.Selectable = false, false, false
				preview.ZIndex = 1000
				preview.AnchorPoint = world.types.Vector2.new(0.5, 0.5)
				preview.Parent = screen
				ghost = preview
				S.tag(tile, "facet-drag-held")
				assert(tile:FindFirstChild "Drag").Enabled = false
				hint.Text = "Choose a destination · Enter: drop · Esc: cancel · Tab: destination"
				status.Visible = true
				cancel.Enabled = true
				held = id
			end
			cancel = S.inputs(world, screen, "FacetDragCancel", 2000, {
				{
					name = "DragCancel",
					keys = { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB },
					pressed = function()
						local id = held
						if id then
							settle(id)
							if ghost then
								ghost:Destroy()
								ghost = nil
							end
						end
					end,
				},
			})
			cancel.Enabled = false
			for i = 1, 20 do
				plainTiles[i] = S.button(world, source, "Tile" .. i, `Tile {i}`, function()
					pickUp(i)
				end)
				S.create(world, "UIDragDetector", "Drag", plainTiles[i])
				destinations[i] = "GridA"
			end
			S.button(world, screen, "Drop", "Move here", function()
				local id = assert(held)
				plainTiles[id].Parent = gridB
				destinations[id] = "GridB"
				settle(id)
				local landing = assert(ghost)
				ghost = nil
				local scale = S.create(world, "UIScale", "UIScale", landing)
				S.animate(world, scale, world.motion.travel, world.motion.travelEase, { Scale = 0 }, function()
					landing:Destroy()
				end)
			end)
		end)
		local keyboard =
			{ UserInputType = world.types.Enum.UserInputType.Keyboard, KeyCode = world.types.Enum.KeyCode.Return }
		return {
			step = function(index: number)
				S.fire(world, "Tile" .. index, "Activated", keyboard)
				S.fire(world, "Drop", "Activated", keyboard)
				completed = index
				world.frame()
			end,
			snapshot = function()
				local rows: { string } = {}
				for i = 1, 20 do
					local tile = S.find(world, "Tile" .. i)
					local home = tostring(assert(tile.Parent).Name)
					if home ~= (if i <= completed then "GridB" else "GridA") then
						error(
							`tile input did not complete the transfer: Tile{i} is in {home} after {completed} drops`,
							0
						)
					end
					table.insert(rows, tostring(tile.Text) .. ":" .. tostring(assert(tile.Parent).Name))
				end
				local ghosts = 0
				for _, node in world.target:GetDescendants() do
					if node.Name == "DragGhost" then
						ghosts += 1
					end
				end
				table.insert(rows, `held={S.tagged(world, "facet-drag-held")} ghosts={ghosts} sinks={S.sinks(world)}`)
				return table.concat(rows, "\n")
			end,
			stop = stop,
		}
	end,
})

return workloads
