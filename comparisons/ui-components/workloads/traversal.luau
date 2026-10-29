--!strict

local Types = require "../types"
local S = require "./support"

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "gamepad-grid-6x6",
	iterations = 35,
	what = "Walk all 36 retained cells of a six by six grid in a snake path. Headless uses the public focus move API; Studio sends directional keys through the native input pipeline.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		type Focus = {
			current: Types.ReadOnlyValue<number?>?,
			focus: ((number) -> boolean)?,
			move: ((string) -> number?)?,
		}
		local focus: Focus = {}
		local data: { number } = {}
		local buttons: { S.Node } = {}
		local current, expected = 1, 1
		for i = 1, 36 do
			table.insert(data, i)
		end
		local stop = S.mount(world, lane, function()
			return world.UI.VirtualGrid "SelectionGrid" {
				from = data,
				key = function(value: number)
					return value
				end,
				columns = 6,
				itemSize = 44,
				gap = 8,
				mode = "all",
				measure = false,
				focus = focus,
				initialFocus = 1,
				autoFocus = true,
				onActivate = function() end,
				Size = world.types.UDim2.fromOffset(360, 360),
				render = function(value: Types.ReadOnlyValue<number>)
					return world.UI.Text("GridCell" .. value:peek()) { text = `Cell {value:peek()}` }
				end,
			}
		end, function(screen)
			local grid = S.grid(world, screen, "SelectionGrid", 6)
			grid.Size = world.types.UDim2.fromOffset(360, 360)
			assert(grid:FindFirstChild "Layout").CellSize = world.types.UDim2.fromOffset((360 - 5 * 8) / 6, 44)
			for i = 1, 36 do
				buttons[i] = S.button(world, grid, "GridCell" .. i, `Cell {i}`, function() end)
				buttons[i].LayoutOrder = i
			end
		end)
		world.pin(S.find(world, "SelectionGrid"), 360, 360)
		if lane == "facet" then
			assert(focus.focus)(1)
			for i = 1, 36 do
				local label = S.find(world, "GridCell" .. i)
				local row = assert(label:FindFirstAncestor(tostring(i)))
				buttons[i] = world.node(assert(row:FindFirstChild("RowHit", true)))
			end
		end
		local restore = S.focus(world, buttons[1])
		return {
			step = function(index: number)
				local position = (index - 1) % 6
				local row = math.floor((index - 1) / 6)
				local down = position == 5
				local right = row % 2 == 0
				local direction = if down then "down" elseif right then "right" else "left"
				expected += if down then 6 elseif right then 1 else -1
				if world.key then
					world.key(
						world.types.Enum.KeyCode[if down then "DPadDown" elseif right then "DPadRight" else "DPadLeft"]
					)
				elseif lane == "facet" then
					assert(focus.move)(direction)
				else
					current += if down then 6 elseif right then 1 else -1
				end
				world.frame()
			end,
			snapshot = function()
				local selected = if lane == "facet" then assert(focus.current):peek() else current
				if lane == "plain" and world.key then
					local native = assert(world.guiService).SelectedObject
					selected = nil
					for index, button in buttons do
						if button == native then
							selected = index
						end
					end
				end
				assert(selected == expected, "directional input did not reach the expected grid cell")
				return tostring(selected)
			end,
			stop = function()
				restore()
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "drag-reorder-100",
	iterations = 20,
	what = "Drag the first of 100 retained rows after the fifth row, 20 times. Facet uses VirtualList reorderable and onReorder; plain uses a native UIDragDetector and insertion indicator.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local rows: { number } = {}
		for i = 1, 100 do
			table.insert(rows, i)
		end
		local source = S.model(world, lane, rows)
		local nodes: { S.Node } = {}
		local detectors: { S.Node } = {}
		local controls: { indexOfKey: ((number) -> number?)? } = {}
		local function reorder(keys: { number }, slot: number)
			assert(#keys == 1, "this task moves one row")
			local updated = table.clone(rows)
			local from = assert(table.find(updated, keys[1]))
			table.remove(updated, from)
			table.insert(updated, slot + 1, keys[1])
			rows = updated
			if lane == "facet" then
				assert(source):set(updated)
			else
				for index, id in rows do
					nodes[id].LayoutOrder = index
				end
			end
		end
		local stop = S.mount(world, lane, function()
			return world.UI.VirtualList "ReorderList" {
				from = assert(source),
				key = function(id: number)
					return id
				end,
				mode = "all",
				itemSize = 44,
				gap = 0,
				measure = false,
				reorderable = true,
				onReorder = reorder,
				controls = controls,
				Size = world.types.UDim2.fromOffset(400, 440),
				render = function(current: Types.ReadOnlyValue<number>)
					return world.UI.Text("ReorderRow" .. current:peek()) {
						text = `Task {current:peek()}`,
						Size = world.types.UDim2.fromScale(1, 1),
						AutomaticSize = world.types.Enum.AutomaticSize.None,
					}
				end,
			}
		end, function(screen)
			local scroll = S.create(
				world,
				"ScrollingFrame",
				"ReorderList",
				screen,
				{ Size = world.types.UDim2.fromOffset(400, 440), CanvasSize = world.types.UDim2.fromOffset(0, 4400) }
			)
			local content = S.stack(world, scroll, "Rows")
			assert(content:FindFirstChild "Layout").Padding = world.types.UDim.new(0, 0)
			content.Size = world.types.UDim2.fromOffset(400, 4400)
			local indicator =
				S.create(world, "Frame", "Insertion", scroll, { Size = world.types.UDim2.fromOffset(400, 2) })
			indicator.Visible = false
			indicator.ZIndex = 10
			for i = 1, 100 do
				local row = S.text(world, content, "ReorderRow" .. i, `Task {i}`)
				row.Size = world.types.UDim2.fromOffset(400, 44)
				row.AutomaticSize = world.types.Enum.AutomaticSize.None
				row.LayoutOrder = i
				nodes[i] = row
				local detector = S.create(world, "UIDragDetector", "RowDrag", row)
				detector.ResponseStyle = world.types.Enum.UIDragDetectorResponseStyle.CustomOffset
				detectors[i] = detector
				local slot = 0
				local function move(position: unknown)
					local point = S.vector2(world, position)
					local at = S.vector2(world, scroll.AbsolutePosition)
					local canvas = S.vector2(world, scroll.CanvasPosition)
					slot = math.clamp(math.floor((point.Y - at.Y + canvas.Y) / 44), 0, 99)
					indicator.Visible = true
					indicator.Position = world.types.UDim2.fromOffset(0, slot * 44 - canvas.Y)
				end
				local signal = (detector :: unknown) :: {
					DragStart: { Connect: (unknown, (unknown) -> ()) -> unknown },
					DragContinue: { Connect: (unknown, (unknown) -> ()) -> unknown },
				}
				signal.DragStart:Connect(move)
				signal.DragContinue:Connect(move)
				detector.DragEnd:Connect(function()
					indicator.Visible = false
					reorder({ i }, slot)
				end)
			end
		end)
		local list = S.find(world, "ReorderList")
		world.pin(list, 400, 440)
		if lane == "facet" then
			for i = 1, 100 do
				nodes[i] = S.find(world, "ReorderRow" .. i)
				detectors[i] = world.node(assert(assert(nodes[i].Parent):FindFirstChild("FacetCollectionDrag", true)))
			end
		end
		local retained = table.clone(nodes)
		local expected = table.clone(rows)
		return {
			step = function()
				local id = rows[1]
				local moving = assert(table.remove(expected, 1))
				table.insert(expected, 5, moving)
				if world.drag then
					world.drag(nodes[id], nodes[rows[5]])
				else
					local from = world.types.Vector2.new(20, 22)
					local to = world.types.Vector2.new(20, 198)
					world.fire(detectors[id], "DragStart", from)
					world.fire(detectors[id], "DragContinue", to)
					world.fire(detectors[id], "DragEnd", to)
				end
				world.frame()
			end,
			snapshot = function()
				local result: { string } = {}
				for index, id in expected do
					assert(rows[index] == id, "drag did not commit the expected insertion slot")
					local position = if lane == "facet" then assert(controls.indexOfKey)(id) else nodes[id].LayoutOrder
					assert(
						position == index and nodes[id] == retained[id] and nodes[id].Parent ~= nil,
						"reorder changed row identity or placement"
					)
					table.insert(result, tostring(id))
				end
				return table.concat(result, ",")
			end,
			stop = stop,
		}
	end,
})

return workloads
