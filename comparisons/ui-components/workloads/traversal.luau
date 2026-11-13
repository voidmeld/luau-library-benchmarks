--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"

type Point = { X: number, Y: number }
type Dragged = { DragStart: Roblox.Signal<unknown>, DragContinue: Roblox.Signal<unknown> }

local function rowCell(
	world: Types.Engine,
	parent: S.Node,
	index: number,
	size: unknown,
	position: unknown
): (S.Node, S.Node, S.Node)
	local UDim2 = world.types.UDim2
	local row = S.blank(world, tostring(index), parent, size)
	row.Position = position
	local content = S.blank(world, "Content", row, UDim2.fromScale(1, 1))
	local hit = S.create(world, "TextButton", "RowHit", content, {
		Text = "",
		BackgroundTransparency = 1,
		Selectable = true,
		Size = UDim2.fromScale(1, 1),
	})
	hit.AnchorPoint = world.types.Vector2.new(0.5, 0.5)
	hit.Position = UDim2.fromScale(0.5, 0.5)
	return row, content, hit
end

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "gamepad-grid-6x6",
	iterations = 35,
	nativeSelection = true,
	what = "Walk all 36 retained cells of a six by six grid in a snake path. Both hosts send D-pad keys through their input host and check native selection. Facet uses VirtualGrid with its focus scope; plain uses transparent selectable hit buttons over text cells. Both hold Home, End, page and direction keys in priority 200 InputContexts while the grid holds selection.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		type Focus = {
			current: Types.ReadOnlyValue<number?>?,
			focus: ((number) -> boolean)?,
			move: ((string) -> number?)?,
		}
		local focus: Focus = {}
		local data: { number } = {}
		local columns, count, size, gap, edge, viewport = 6, 36, 44, 8, 4, 360
		local width = (viewport - 2 * edge - (columns - 1) * gap) / columns
		local rows: { S.Node } = {}
		local hits: { S.Node } = {}
		local cleanups: { () -> () } = {}
		local focusFirst: () -> () = function() end
		local current, expected = 1, 1
		for i = 1, count do
			table.insert(data, i)
		end
		local mounted = S.mount(world, lane, function()
			return world.UI.VirtualGrid "SelectionGrid" {
				from = data,
				key = function(value: number)
					return value
				end,
				columns = columns,
				itemSize = size,
				gap = gap,
				mode = "all",
				measure = false,
				focus = focus,
				initialFocus = 1,
				autoFocus = true,
				onActivate = function() end,
				Size = world.types.UDim2.fromOffset(viewport, viewport),
				render = function(value: Types.ReadOnlyValue<number>)
					return world.UI.Text("GridCell" .. value:peek()) { text = `Cell {value:peek()}` }
				end,
			}
		end, function(screen)
			local Enum, UDim2 = world.types.Enum, world.types.UDim2
			local grid = S.create(world, "ScrollingFrame", "SelectionGrid", nil, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = true,
				ClipsDescendants = true,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.None,
				Size = UDim2.fromOffset(viewport, viewport),
				CanvasSize = UDim2.fromOffset(0, math.ceil(count / columns) * (size + gap) - gap + 2 * edge),
			})
			grid.SelectionGroup = true
			grid.ScrollBarThickness = 6
			local items = S.blank(world, "Items", grid, UDim2.fromScale(1, 1))
			S.padding(world, items, edge, edge)
			for i = 1, count do
				local column, line = (i - 1) % columns, (i - 1) // columns
				local row, content, hit = rowCell(
					world,
					items,
					i,
					UDim2.fromOffset(width, size),
					UDim2.fromOffset(column * (width + gap), line * (size + gap))
				)
				row.LayoutOrder = i
				S.fill(world, S.text(world, content, "GridCell" .. i, `Cell {i}`))
				rows[i], hits[i] = row, hit
			end
			local gui = world.guiService
			local function select(index: number)
				local target = hits[math.clamp(index, 1, count)]
				if gui and gui.SelectedObject ~= target then
					gui.SelectedObject = target
				end
			end
			local function at(): number?
				local selected = S.selected(world)
				for index, hit in hits do
					if hit == selected then
						return index
					end
				end
				return nil
			end
			local function move(step: number, across: boolean)
				local index = at()
				if index == nil then
					return
				end
				local column = (index - 1) % columns
				if across and (column + step < 0 or column + step >= columns) then
					return
				end
				local target = index + (if across then step else step * columns)
				if target >= 1 and target <= count then
					select(target)
				end
			end
			local function page(step: number)
				local index = at()
				if index == nil then
					return
				end
				local reach = math.max(viewport, size)
				local target = index
				local probe = index + step * columns
				while probe >= 1 and probe <= count do
					local distance = math.abs((probe - 1) // columns - (index - 1) // columns) * (size + gap) + size
					if distance > reach then
						break
					end
					target = probe
					probe += step * columns
				end
				select(target)
			end
			local KeyCode = Enum.KeyCode
			local function bind(name: string, keys: { unknown }, pressed: () -> ()): S.Node
				return S.action(world, screen, name, 200, keys, pressed)
			end
			local contexts = {
				bind("CollectionLeft", { KeyCode.Left, KeyCode.DPadLeft }, function()
					move(-1, true)
				end),
				bind("CollectionRight", { KeyCode.Right, KeyCode.DPadRight }, function()
					move(1, true)
				end),
				bind("CollectionUp", { KeyCode.Up, KeyCode.DPadUp }, function()
					move(-1, false)
				end),
				bind("CollectionDown", { KeyCode.Down, KeyCode.DPadDown }, function()
					move(1, false)
				end),
				bind("CollectionPageDown", { KeyCode.PageDown, KeyCode.ButtonR2 }, function()
					page(1)
				end),
				bind("CollectionPageUp", { KeyCode.PageUp, KeyCode.ButtonL2 }, function()
					page(-1)
				end),
				bind("CollectionFirst", { KeyCode.Home }, function()
					select(1)
				end),
				bind("CollectionLast", { KeyCode.End }, function()
					select(count)
				end),
			}
			local enabled: boolean? = nil
			local function sync()
				local inside = at() ~= nil
				if inside == enabled then
					return
				end
				enabled = inside
				for _, context in contexts do
					context.Enabled = inside
				end
			end
			if gui then
				local previous = gui.SelectedObject
				local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(sync)
				table.insert(cleanups, function()
					connection:Disconnect()
					if gui.SelectedObject ~= nil and at() ~= nil then
						gui.SelectedObject = previous
					end
				end)
			end
			sync()
			grid.Parent = screen
			focusFirst = function()
				select(1)
			end
		end)
		focusFirst()
		world.pin(S.find(world, "SelectionGrid"), viewport, viewport)
		if world.key then
			world.key(world.types.Enum.KeyCode.DPadLeft)
		end
		if lane == "facet" then
			for i = 1, count do
				rows[i] = world.node(assert(S.find(world, "GridCell" .. i):FindFirstAncestor(tostring(i))))
			end
		end
		local function stop()
			for index = #cleanups, 1, -1 do
				cleanups[index]()
			end
			mounted()
		end
		local function landed(): number?
			local selected = S.selected(world)
			if selected == nil then
				return nil
			end
			for index, row in rows do
				if selected:IsDescendantOf(row) then
					return index
				end
			end
			return nil
		end
		return {
			step = function(index: number)
				local position = (index - 1) % columns
				local line = (index - 1) // columns
				local down = position == columns - 1
				local right = line % 2 == 0
				local direction = if down then "down" elseif right then "right" else "left"
				expected += if down then columns elseif right then 1 else -1
				if world.key then
					world.key(
						world.types.Enum.KeyCode[if down then "DPadDown" elseif right then "DPadRight" else "DPadLeft"]
					)
				elseif lane == "facet" then
					assert(focus.move)(direction)
				else
					current += if down then columns elseif right then 1 else -1
				end
				world.frame()
			end,
			snapshot = function()
				local selected = if lane == "facet" then assert(focus.current):peek() else current
				if world.key then
					local native = landed()
					assert(
						native ~= nil and (lane == "plain" or native == selected),
						"native selection left the focused grid cell"
					)
					selected = native
				end
				assert(selected == expected, "directional input did not reach the expected grid cell")
				return `{selected}\n{S.observe(world, { "SelectionGrid", "Items", "GridCell1", "GridCell" .. expected })}`
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "drag-reorder-100",
	iterations = 40,
	what = "Drag the first of 100 retained rows after the fifth row, 20 times: odd steps press and move past the 6-pixel threshold, even steps drop. Facet uses VirtualList reorderable and onReorder; plain uses a UIDragDetector per row, a divider drop line, a drag ghost, a priority 400 cancel InputContext and the theme snappy spring for row travel, plus keyboard pick-up, move, drop and cancel. Headless worlds fire the row detector after checking that it is enabled; Studio drags with the real mouse.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local rows: { number } = {}
		local count, size, viewport, width = 100, 44, 440, 400
		for i = 1, count do
			table.insert(rows, i)
		end
		local source = S.model(world, lane, rows)
		local nodes: { S.Node } = {}
		local detectors: { S.Node } = {}
		local controls: { indexOfKey: ((number) -> number?)? } = {}
		local cleanups: { () -> () } = {}
		local function reorder(keys: { number }, slot: number)
			assert(#keys == 1, "this task moves one row")
			local updated = table.clone(rows)
			local from = assert(table.find(updated, keys[1]))
			table.remove(updated, from)
			table.insert(updated, slot + 1, keys[1])
			rows = updated
			if lane == "facet" then
				assert(source):set(updated)
			end
		end
		local mounted = S.mount(world, lane, function()
			return world.UI.VirtualList "ReorderList" {
				from = assert(source),
				key = function(id: number)
					return id
				end,
				mode = "all",
				itemSize = size,
				gap = 0,
				measure = false,
				reorderable = true,
				onReorder = reorder,
				controls = controls,
				Size = world.types.UDim2.fromOffset(width, viewport),
				render = function(current: Types.ReadOnlyValue<number>)
					return world.UI.Text("ReorderRow" .. current:peek()) {
						text = `Task {current:peek()}`,
						Size = world.types.UDim2.fromScale(1, 1),
						AutomaticSize = world.types.Enum.AutomaticSize.None,
					}
				end,
			}
		end, function(screen, sheet)
			local Enum, UDim2 = world.types.Enum, world.types.UDim2
			Theme.dividers(world, sheet)
			local list = S.create(world, "ScrollingFrame", "ReorderList", nil, {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Selectable = true,
				ClipsDescendants = true,
				ScrollingDirection = Enum.ScrollingDirection.Y,
				AutomaticCanvasSize = Enum.AutomaticSize.None,
				Size = UDim2.fromOffset(width, viewport),
				CanvasSize = UDim2.fromOffset(0, count * size),
			})
			list.SelectionGroup = true
			list.ScrollBarThickness = 6
			local items = S.blank(world, "Items", list, UDim2.fromScale(1, 1))
			local feedback = S.blank(world, "ReorderFeedback", list, UDim2.fromScale(1, 1))
			feedback.ZIndex = 1000
			local frames: { [number]: S.Node } = {}
			local hits: { [number]: S.Node } = {}
			local motion: { [number]: { position: number, velocity: number, target: number, reference: number, moving: boolean } } =
				{}
			local glide = S.spring(Theme.motion.springs.snappy)
			local ticking: Roblox.Connection? = nil
			local function halt()
				if ticking then
					ticking:Disconnect()
					ticking = nil
				end
			end
			local function publish(id: number)
				frames[id].Position = UDim2.fromOffset(0, motion[id].position)
			end
			local function tick(delta: number)
				local busy = false
				for id, state in motion do
					if state.moving then
						if glide(state, delta) then
							state.moving = false
						else
							busy = true
						end
						publish(id)
					end
				end
				if not busy then
					halt()
				end
			end
			local function travel(order: { number })
				for index, id in order do
					local state = motion[id]
					local target = (index - 1) * size
					if state.target ~= target then
						state.target, state.reference = target, state.position
						if not state.moving then
							state.moving, state.velocity = true, 0
						end
					end
				end
				if ticking == nil then
					for _, state in motion do
						if state.moving then
							ticking = world.heartbeat:Connect(tick)
							break
						end
					end
				end
			end
			type Move = {
				id: number,
				slot: number,
				remaining: { number },
				keyboard: boolean,
				line: S.Node,
				ghost: S.Node,
			}
			local moving: Move? = nil
			local function visual(move: Move): { number }
				local order = table.clone(move.remaining)
				table.insert(order, move.slot + 1, move.id)
				return order
			end
			local contexts: { [string]: S.Node } = {}
			local function sync()
				local selected = S.selected(world)
				local focused = selected ~= nil and selected:IsDescendantOf(items)
				local move = moving
				contexts.CollectionUp.Enabled = focused and move == nil
				contexts.CollectionDown.Enabled = focused and move == nil
				contexts.CollectionFirst.Enabled = focused and move == nil
				contexts.CollectionLast.Enabled = focused and move == nil
				contexts.CollectionPickUp.Enabled = focused and move == nil
				contexts.ReorderUp.Enabled = move ~= nil and move.keyboard
				contexts.ReorderDown.Enabled = move ~= nil and move.keyboard
				contexts.ReorderDrop.Enabled = move ~= nil and move.keyboard
				contexts.ReorderCancel.Enabled = move ~= nil
			end
			local function place(move: Move)
				local candidate = move.remaining[move.slot + 1]
				local index = if candidate then assert(table.find(rows, candidate)) else #rows
				local offset = (index - 1) * size + (if candidate then 0 else size)
				move.line.Position = UDim2.fromOffset(0, offset - S.vector2(world, list.CanvasPosition).Y)
				travel(visual(move))
			end
			local function begin(id: number, keyboard: boolean)
				if moving ~= nil then
					return
				end
				local remaining = table.clone(rows)
				local from = assert(table.find(remaining, id))
				table.remove(remaining, from)
				local line = S.create(world, "Frame", "DropLine", nil, { Size = UDim2.new(1, 0, 0, 2) })
				line:AddTag(Theme.tags.divider)
				line.ZIndex = 1000
				line.Parent = feedback
				local ghost = S.blank(
					world,
					"DragGhost",
					nil,
					UDim2.fromOffset(S.vector2(world, frames[id].AbsoluteSize).X, size)
				)
				ghost.ZIndex = 1001
				ghost.Visible = not keyboard
				local copy = world.node(assert(nodes[id]:Clone()))
				for _, child in copy:GetChildren() do
					child:Destroy()
				end
				copy.Parent = ghost
				ghost.Parent = screen
				nodes[id].Visible = keyboard
				moving =
					{ id = id, slot = from - 1, remaining = remaining, keyboard = keyboard, line = line, ghost = ghost }
				place(assert(moving))
				sync()
			end
			local function finish(commit: boolean)
				local move = moving
				if move == nil then
					return
				end
				moving = nil
				nodes[move.id].Visible = true
				move.line:Destroy()
				move.ghost:Destroy()
				if commit then
					reorder({ move.id }, move.slot)
				end
				travel(rows)
				sync()
			end
			local function slotAt(position: Point, move: Move): number
				local offset = position.Y
					- S.vector2(world, list.AbsolutePosition).Y
					+ S.vector2(world, list.CanvasPosition).Y
				local slot, low, high = 0, 1, #move.remaining
				while low <= high do
					local middle = (low + high) // 2
					local index = assert(table.find(rows, move.remaining[middle]))
					if offset >= (index - 1) * size + size / 2 then
						slot, low = middle, middle + 1
					else
						high = middle - 1
					end
				end
				return slot
			end
			local function follow(position: Point)
				local move = moving
				if move == nil then
					return
				end
				move.ghost.Position = UDim2.fromOffset(position.X, position.Y)
				local slot = slotAt(position, move)
				if slot ~= move.slot then
					move.slot = slot
				end
				place(move)
			end
			local function step(delta: number)
				local move = moving
				if move then
					move.slot = math.clamp(move.slot + delta, 0, #move.remaining)
					place(move)
				end
			end
			local function focusedRow(): number?
				local selected = S.selected(world)
				for id, hit in hits do
					if hit == selected then
						return id
					end
				end
				return nil
			end
			local function select(index: number)
				local gui = world.guiService
				local id = rows[math.clamp(index, 1, #rows)]
				if gui and id then
					gui.SelectedObject = hits[id]
				end
			end
			local function bind(name: string, keys: { unknown }, priority: number, pressed: () -> ())
				contexts[name] = S.action(world, screen, name, priority, keys, pressed)
			end
			bind("CollectionUp", { Enum.KeyCode.Up, Enum.KeyCode.DPadUp }, 200, function()
				local id = focusedRow()
				if id then
					select(assert(table.find(rows, id)) - 1)
				end
			end)
			bind("CollectionDown", { Enum.KeyCode.Down, Enum.KeyCode.DPadDown }, 200, function()
				local id = focusedRow()
				if id then
					select(assert(table.find(rows, id)) + 1)
				end
			end)
			bind("CollectionFirst", { Enum.KeyCode.Home }, 200, function()
				select(1)
			end)
			bind("CollectionLast", { Enum.KeyCode.End }, 200, function()
				select(#rows)
			end)
			bind("CollectionPickUp", { Enum.KeyCode.Return, Enum.KeyCode.ButtonA }, 400, function()
				local id = focusedRow()
				if id then
					begin(id, true)
				end
			end)
			bind("ReorderUp", { Enum.KeyCode.Up, Enum.KeyCode.DPadUp }, 400, function()
				step(-1)
			end)
			bind("ReorderDown", { Enum.KeyCode.Down, Enum.KeyCode.DPadDown }, 400, function()
				step(1)
			end)
			bind("ReorderDrop", { Enum.KeyCode.Return, Enum.KeyCode.ButtonA }, 400, function()
				finish(true)
			end)
			bind("ReorderCancel", { Enum.KeyCode.Escape, Enum.KeyCode.ButtonB }, 400, function()
				finish(false)
			end)
			for i = 1, count do
				local frame, content, hit =
					rowCell(world, items, i, UDim2.new(1, 0, 0, size), UDim2.fromOffset(0, (i - 1) * size))
				local row = S.text(world, content, "ReorderRow" .. i, `Task {i}`)
				row.Size = UDim2.fromScale(1, 1)
				row.AutomaticSize = Enum.AutomaticSize.None
				local detector = S.create(world, "UIDragDetector", "RowDrag", hit)
				detector.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
				detector.DragStyle = Enum.UIDragDetectorDragStyle.TranslatePlane
				frames[i], hits[i], nodes[i], detectors[i] = frame, hit, row, detector
				motion[i] =
					{ position = (i - 1) * size, velocity = 0, target = (i - 1) * size, reference = 0, moving = false }
				local origin: Point? = nil
				local dragged = false
				local function continue(position: Point)
					local start = origin
					if start and moving == nil then
						local dx, dy = position.X - start.X, position.Y - start.Y
						if math.sqrt(dx * dx + dy * dy) >= S.DRAG_THRESHOLD and math.abs(dy) >= math.abs(dx) then
							dragged = true
							begin(i, false)
						end
					end
					local move = moving
					if move and move.id == i and not move.keyboard then
						follow(position)
					end
				end
				local signals = (detector :: unknown) :: Dragged
				signals.DragStart:Connect(function(position: unknown)
					origin, dragged = S.vector2(world, position), false
				end)
				signals.DragContinue:Connect(function(position: unknown)
					continue(S.vector2(world, position))
				end)
				local ended = (detector :: unknown) :: { DragEnd: Roblox.Signal<unknown> }
				ended.DragEnd:Connect(function(position: unknown)
					if position ~= nil and origin ~= nil and not dragged then
						continue(S.vector2(world, position))
					end
					origin = nil
					local move = moving
					if move and move.id == i and not move.keyboard then
						finish(true)
					end
				end)
			end
			local gui = world.guiService
			if gui then
				local connection = gui:GetPropertyChangedSignal("SelectedObject"):Connect(sync)
				table.insert(cleanups, function()
					connection:Disconnect()
				end)
			end
			table.insert(cleanups, function()
				finish(false)
				halt()
			end)
			sync()
			list.Parent = screen
		end)
		local list = S.find(world, "ReorderList")
		world.pin(list, width, viewport)
		if lane == "facet" then
			for i = 1, count do
				nodes[i] = S.find(world, "ReorderRow" .. i)
				detectors[i] = world.node(assert(nodes[i]:FindFirstChildWhichIsA("UIDragDetector", true)))
			end
		end
		if world.aim then
			world.aim()
		end
		local retained = table.clone(nodes)
		local expected = table.clone(rows)
		local function stop()
			for index = #cleanups, 1, -1 do
				cleanups[index]()
			end
			mounted()
		end
		return {
			step = function(index: number)
				local drop = index % 2 == 0
				local drag = world.drag
				local id = rows[1]
				if drag then
					if not drop then
						drag(nodes[id], list, { X = 200, Y = 4 * size + 22 })
						local moving = assert(table.remove(expected, 1))
						table.insert(expected, 5, moving)
					end
				else
					local detector = detectors[id]
					assert(detector.Enabled == true, "the row drag detector is disabled")
					local to = world.types.Vector2.new(20, 4 * size + 22)
					if drop then
						world.fire(detector, "DragEnd", to)
						local moving = assert(table.remove(expected, 1))
						table.insert(expected, 5, moving)
					else
						world.fire(detector, "DragStart", world.types.Vector2.new(20, 22))
						world.fire(detector, "DragContinue", to)
					end
				end
				if drop then
					S.settle(world, 0.45)
				else
					world.frame()
				end
			end,
			snapshot = function()
				local result: { string } = {}
				for index, id in expected do
					if rows[index] ~= id then
						error(
							`drag did not commit the expected insertion slot: expected {table.concat(
								expected,
								",",
								1,
								6
							)} got {table.concat(rows, ",", 1, 6)}`,
							0
						)
					end
					local position = if lane == "facet" then assert(controls.indexOfKey)(id) else table.find(rows, id)
					assert(
						position == index and nodes[id] == retained[id] and nodes[id].Parent ~= nil,
						"reorder changed row identity or placement"
					)
					table.insert(result, tostring(id))
				end
				local names = { "ReorderList", "DropLine" }
				for i = 1, 6 do
					table.insert(names, "ReorderRow" .. i)
				end
				return table.concat(result, ",") .. "\n" .. S.observe(world, names)
			end,
			stop = stop,
		}
	end,
})

return workloads
