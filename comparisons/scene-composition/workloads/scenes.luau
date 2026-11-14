--!strict
--!native

local PlainSupport = require "./plain-support"
local Shared = require "./shared"
local Types = require "./types"

local Environment = require "../cost-model"

type PlainContext = Types.PlainContext
type EventsState = { fired: number }
type Spring = {
	node: Environment.Instance,
	position: number,
	velocity: number,
	target: number,
	reference: number,
	shown: number,
	moving: boolean,
}
type AnimatedPlain = {
	frame: Environment.Instance,
	springs: { Spring },
	moving: number,
	connection: Environment.Connection?,
}
type PanelPlain = {
	hp: Environment.Instance,
	mp: Environment.Instance,
	badges: Shared.Labels,
	lists: { { Shared.Row } },
	tick: number,
}
type Workload = Types.Workload

local HANDLERS = 10
local BUTTON = 40
local EVENT_KEYS = { "Text", "Size", "Position" }

local PERIOD = 0.3
local DAMPING = 1
local FREQUENCY = 2 * math.pi / PERIOD
local STIFFNESS = FREQUENCY * FREQUENCY
local DRAG = 2 * DAMPING * FREQUENCY
local STEP = 1 / 120
local TOLERANCE = 1e-4

local function advance(state: AnimatedPlain, delta: number)
	for _, spring in state.springs do
		if not spring.moving then
			continue
		end
		local position, velocity, target = spring.position, spring.velocity, spring.target
		local remaining = delta
		while remaining > 0 do
			local h = if remaining > STEP then STEP else remaining
			remaining -= h
			velocity += (-STIFFNESS * (position - target) - DRAG * velocity) * h
			position += velocity * h
		end
		local tolerance = math.max(math.abs(spring.reference - target) * TOLERANCE, TOLERANCE)
		if math.abs(position - target) <= tolerance and math.abs(velocity) * STEP <= tolerance then
			position, velocity = target, 0
			spring.moving = false
			state.moving -= 1
		end
		spring.position, spring.velocity = position, velocity
		local order = math.round(position)
		if order ~= spring.shown then
			spring.shown = order
			spring.node.LayoutOrder = order
		end
	end
	local connection = state.connection
	if state.moving == 0 and connection ~= nil then
		connection:Disconnect()
		state.connection = nil
	end
end

local function retarget(state: AnimatedPlain, goal: number, environment: Environment.Environment)
	for index, spring in state.springs do
		local target = goal + index
		if spring.target ~= target then
			spring.target = target
			spring.reference = spring.position
			if not spring.moving then
				spring.moving = true
				state.moving += 1
			end
		end
	end
	if state.moving > 0 and state.connection == nil then
		state.connection = environment.heartbeat:Connect(function(delta: unknown)
			assert(type(delta) == "number", "heartbeat must pass a frame delta")
			advance(state, delta)
		end)
	end
end

local events: Workload = {
	id = "events",
	title = "Event connection, dispatch, and release",
	what = ("Connects a handler to each of %d buttons, clicks every one, and releases them. The connection "):format(
		HANDLERS
	) .. "counters prove nothing is left attached. Studio sends each click through VirtualInput.",
	samples = 20,
	iterations = 1,
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
					button.Size = context.env.globals.UDim2.fromOffset(BUTTON, BUTTON)
					button.Position = context.env.globals.UDim2.fromOffset((index - 1) * (BUTTON + 4), 0)
					connections[index] = context.env.signal(button, "Activated"):Connect(function()
						state.fired += 1
					end)
					button.Parent = frame
					made[index + 1] = button
				end
				frame.Parent = context.container
				local observe = context.observe
				if observe ~= nil then
					observe(context.env.snapshot(context.container, EVENT_KEYS))
				end

				local before = state.fired
				for index = 2, #made do
					context.env.fire(made[index], "Activated")
				end
				assert(state.fired - before == HANDLERS, "event handlers did not all run")

				for index = #connections, 1, -1 do
					connections[index]:Disconnect()
				end
				PlainSupport.destroyAll(made)
				context.env.drain()
			end,
			snapshot = function(_state: EventsState, context: PlainContext): string
				return context.env.snapshot(context.container, EVENT_KEYS)
			end,
			release = function(_state: EventsState, _context: PlainContext) end,
		},
	},
	unsupported = {},
}

local animateMany: Workload = {
	id = "animate-many",
	title = "Hundreds of simultaneous animated values",
	what = ("Retargets %d springs and steps %d frames. Measures per-frame animation cost, and the property "):format(
		Shared.ANIMATED,
		Shared.ANIMATE_FRAMES
	) .. "counters show how much of it reaches the host.",
	samples = 12,
	iterations = 1,
	warmup = 3,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): AnimatedPlain
				local Instance = PlainSupport.instances(context)
				local frame = Instance.new "Frame"
				local createSprings: (number, Spring?) -> { Spring } = table.create
				local springs: { Spring } = createSprings(Shared.ANIMATED)
				for index = 1, Shared.ANIMATED do
					local node = Instance.new "Frame"
					node.LayoutOrder = index
					node.Parent = frame
					springs[index] = {
						node = node,
						position = index,
						velocity = 0,
						target = index,
						reference = index,
						shown = index,
						moving = false,
					}
				end
				frame.Parent = context.container
				return { frame = frame, springs = springs, moving = 0 }
			end,
			run = function(state: AnimatedPlain, context: PlainContext)
				retarget(state, Shared.ANIMATE_TARGET, context.env)
				for frame = 1, Shared.ANIMATE_FRAMES do
					context.env.step(1 / 60)
					if frame == Shared.ANIMATE_CHECK and context.observe ~= nil then
						Shared.checkMidway(context.env, context.container)
					end
				end
				context.env.drain()
			end,
			snapshot = function(_state: AnimatedPlain, context: PlainContext): string
				Shared.settle(context.env)
				return context.env.snapshot(context.container, { "LayoutOrder" })
			end,
			release = function(state: AnimatedPlain, _context: PlainContext)
				local connection = state.connection
				if connection ~= nil then
					connection:Disconnect()
					state.connection = nil
				end
				state.frame:Destroy()
			end,
		},
	},
}

local panel: Workload = {
	id = "status-panel",
	title = "Status panel with rapidly changing values",
	what = ("A level bar, a reserve bar, and %d badge rows, updated together each frame the way a live dashboard "):format(
		Shared.BADGES
	) .. "updates them. The composite case: collections, bindings, and batching at once.",
	samples = 20,
	iterations = 10,
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
				local lists = Shared.badgeLists()
				local badges = Shared.labels(frame)
				Shared.applyLabels(badges, Instance, lists[1])
				frame.Parent = context.container
				return { hp = hp, mp = mp, badges = badges, lists = lists, tick = 0 }
			end,
			run = function(state: PanelPlain, context: PlainContext)
				state.tick += 1
				local tick = state.tick
				state.hp.Text = "hp " .. tostring(100 - (tick % 100))
				state.mp.Text = "mp " .. tostring((tick * 3) % 100)
				Shared.applyLabels(state.badges, PlainSupport.instances(context), Shared.badgesAt(state.lists, tick))
				context.env.drain()
			end,
			snapshot = function(_state: PanelPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
			end,
			release = function(state: PanelPlain, _context: PlainContext)
				Shared.releaseLabels(state.badges)
			end,
		},
	},
	unsupported = {},
}

return {
	events,
	animateMany,
	panel,
}
