--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Environment = require "../cost-model"

type PlainContext = Types.PlainContext
type EventsState = { fired: number }
type Spring = { node: Environment.Instance, position: number, velocity: number, target: number }
type AnimatedPlain = { made: { Environment.Instance }, springs: { Spring }, frame: Environment.Instance }
type PanelPlain = {
	frame: Environment.Instance,
	hp: Environment.Instance,
	mp: Environment.Instance,
	byId: { [number]: Environment.Instance },
	count: number,
	tick: number,
}
type Workload = Types.Workload

local HANDLERS = 200
local ANIMATED = 200
local PANEL_ROWS = 40

local BADGE_POOL: { { id: number } } = {}
for index = 1, PANEL_ROWS + 1 do
	BADGE_POOL[index] = { id = index }
end

local function badgePrefix(count: number): { { id: number } }
	local createList: (number, { id: number }?) -> { { id: number } } = table.create
	local list: { { id: number } } = createList(count)
	table.move(BADGE_POOL, 1, count, 1, list)
	return list
end
local CYCLES = 30
local SETTLE_FRAMES = 300

local function settledSnapshot(context: { env: Environment.Environment, container: Environment.Instance }): string
	for _ = 1, SETTLE_FRAMES do
		context.env.step(1 / 60)
	end
	return context.env.snapshot(context.container, { "LayoutOrder" })
end

local events: Workload = {
	id = "events",
	title = "Event connection, dispatch, and release",
	what = ("Connects a handler to each of %d buttons, fires every one, and releases them. The connection "):format(
		HANDLERS
	) .. "counters prove nothing is left attached.",
	samples = 20,
	iterations = 5,
	warmup = 3,
	cases = {
		plain = Types.plain {
			prepare = function(_context: PlainContext): EventsState
				return { fired = 0 }
			end,
			run = function(state: EventsState, context: PlainContext)
				local Instance = PlainSupport.instances(context)
				local frame = Instance.new "Frame"
				local createMade: (number, Environment.Instance?) -> { Environment.Instance } = table.create
				local made: { Environment.Instance } = createMade(HANDLERS + 1)
				local createConnections: (number, Environment.Connection?) -> { Environment.Connection } = table.create
				local connections: { Environment.Connection } = createConnections(HANDLERS)
				made[1] = frame
				for index = 1, HANDLERS do
					local button = Instance.new "TextButton"
					button.Text = "b" .. tostring(index)
					connections[index] = context.env.signal(button, "Activated"):Connect(function()
						state.fired += 1
					end)
					button.Parent = frame
					made[index + 1] = button
				end
				frame.Parent = context.container
				local observe = context.observe
				if observe ~= nil then
					observe(context.env.snapshot(context.container, { "Text" }))
				end

				for index = 2, #made do
					context.env.fire(made[index], "Activated")
				end

				for index = #connections, 1, -1 do
					connections[index]:Disconnect()
				end
				PlainSupport.destroyAll(made)
			end,
			snapshot = function(_state: EventsState, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(_state: EventsState, _context: PlainContext) end,
		},
	},
	unsupported = {},
}

local animateMany: Workload = {
	id = "animate-many",
	title = "Hundreds of simultaneous animated values",
	what = ("Retargets %d springs and steps 30 frames. Measures per-frame animation cost, and the property "):format(
		ANIMATED
	) .. "counters show how much of it reaches the host.",
	samples = 12,
	iterations = 1,
	warmup = 3,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): AnimatedPlain
				local Instance = PlainSupport.instances(context)
				local frame = Instance.new "Frame"
				local createMade: (number, Environment.Instance?) -> { Environment.Instance } = table.create
				local made: { Environment.Instance } = createMade(ANIMATED + 1)
				made[1] = frame
				local createSprings: (number, Spring?) -> { Spring } = table.create
				local springs: { Spring } = createSprings(ANIMATED)
				for index = 1, ANIMATED do
					local node = Instance.new "Frame"
					node.LayoutOrder = index
					node.Parent = frame
					made[index + 1] = node
					springs[index] = { node = node, position = index, velocity = 0, target = index }
				end
				frame.Parent = context.container
				return { made = made, springs = springs, frame = frame }
			end,
			run = function(state: AnimatedPlain, context: PlainContext)
				for _, spring in state.springs do
					local order = spring.node.LayoutOrder
					assert(type(order) == "number")
					spring.target = 100 + order
				end

				local frequency = 2 * math.pi / 0.3
				local stiffness = frequency * frequency
				local drag = 2 * frequency
				local fixed = 1 / 120

				for _ = 1, 30 do
					local remaining = 1 / 60
					while remaining > 0 do
						local h = if remaining > fixed then fixed else remaining
						remaining -= h
						for _, spring in state.springs do
							local offset = spring.position - spring.target
							local acceleration = -stiffness * offset - drag * spring.velocity
							spring.velocity += acceleration * h
							spring.position += spring.velocity * h
						end
					end
					for _, spring in state.springs do
						spring.node.LayoutOrder = math.round(spring.position)
					end
					context.env.step(1 / 60)
				end
			end,
			snapshot = function(_state: AnimatedPlain, context: PlainContext): string
				return settledSnapshot(context)
			end,
			release = function(state: AnimatedPlain, _context: PlainContext)
				PlainSupport.destroyAll(state.made)
			end,
		},
	},
}

local panel: Workload = {
	id = "status-panel",
	title = "Status panel with rapidly changing values",
	what = ("A level bar, a reserve bar, and %d badge rows, updated together each frame the way a live dashboard "):format(
		PANEL_ROWS
	) .. "updates them. The composite case: collections, bindings, and batching at once.",
	samples = 20,
	iterations = 20,
	warmup = 5,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): PanelPlain
				local Instance = PlainSupport.instances(context)
				local frame = Instance.new "Frame"
				local hp = Instance.new "TextLabel"
				hp.Text = "hp 100"
				hp.Parent = frame
				local mp = Instance.new "TextLabel"
				mp.Text = "mp 50"
				mp.Parent = frame
				frame.Parent = context.container
				local byIdValue: { [number]: Environment.Instance } = {}
				return {
					frame = frame,
					hp = hp,
					mp = mp,
					byId = byIdValue,
					count = 0,
					tick = 0,
				}
			end,
			run = function(state: PanelPlain, context: PlainContext)
				local Instance = PlainSupport.instances(context)
				state.tick += 1
				local wanted = (state.tick % PANEL_ROWS) + 1

				state.hp.Text = "hp " .. tostring(100 - (state.tick % 100))
				state.mp.Text = "mp " .. tostring((state.tick * 3) % 100)

				for index = state.count + 1, wanted do
					local row = Instance.new "TextLabel"
					row.Text = tostring(index)
					row.LayoutOrder = index
					row.Parent = state.frame
					state.byId[index] = row
				end
				for index = state.count, wanted + 1, -1 do
					state.byId[index]:Destroy()
					state.byId[index] = nil
				end
				state.count = wanted
			end,
			snapshot = function(_state: PanelPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
			end,
			release = function(state: PanelPlain, _context: PlainContext)
				for index = state.count, 1, -1 do
					state.byId[index]:Destroy()
				end
				state.mp:Destroy()
				state.hp:Destroy()
				state.frame:Destroy()
			end,
		},
	},
	unsupported = {},
}

local mountCycles: Workload = {
	id = "mount-cycles",
	title = "Repeated mount and unmount cycles",
	what = ("Builds and tears down a 60-node tree %d times. `leakedInstances` and `leakedConnections` in "):format(
		CYCLES
	) .. "the raw samples are the point: both must be zero.",
	samples = 12,
	iterations = 1,
	warmup = 3,
	cases = {
		plain = Types.plain {
			prepare = function(_context: PlainContext): {}
				return {}
			end,
			run = function(_state: {}, context: PlainContext)
				local Instance = PlainSupport.instances(context)
				for _ = 1, CYCLES do
					local frame = Instance.new "Frame"
					local createMade: (number, Environment.Instance?) -> { Environment.Instance } = table.create
					local made: { Environment.Instance } = createMade(61)
					local createConnections: (number, Environment.Connection?) -> { Environment.Connection } =
						table.create
					local connections: { Environment.Connection } = createConnections(60)
					made[1] = frame
					for index = 1, 60 do
						local button = Instance.new "TextButton"
						button.Text = "n" .. tostring(index)
						connections[index] = context.env.signal(button, "Activated"):Connect(function() end)
						button.Parent = frame
						made[index + 1] = button
					end
					frame.Parent = context.container
					local observe = context.observe
					if observe ~= nil then
						observe(context.env.snapshot(context.container, { "Text" }))
					end
					for index = #connections, 1, -1 do
						connections[index]:Disconnect()
					end
					PlainSupport.destroyAll(made)
				end
			end,
			snapshot = function(_state: {}, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(_state: {}, _context: PlainContext) end,
		},
	},
	unsupported = {},
}

return {
	events,
	animateMany,
	panel,
	mountCycles,
}
