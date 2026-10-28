--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Core = require "../../../.lute/dependencies/compose/src/core"
local Environment = require "../cost-model"

type ComposeContext = Types.ComposeContext
type PlainContext = Types.PlainContext
type MountState = { disposers: { () -> () } }
type MountPlain = { made: { { Environment.Instance } } }
type Workload = Types.Workload

local function labelText(index: number): string
	return "row " .. tostring(index)
end

local function coldMount(count: number): Workload
	return {
		id = ("cold-mount-%d"):format(count),
		title = ("Cold construction of %d nodes"):format(count),
		what = ("Builds a frame containing %d text labels from nothing. Measures per-node construction cost."):format(
			count
		),
		samples = if count >= 10000 then 8 else 20,
		iterations = 1,
		warmup = 3,
		cases = {
			compose = Types.compose {
				prepare = function(_context: ComposeContext): MountState
					return { disposers = {} }
				end,
				run = function(state: MountState, context: ComposeContext)
					local Host = context.extras.runtime.constructors
					local dispose = context.extras.runtime.mount(function()
						local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
						local children: { Core.Node } = createChildren(count)
						for index = 1, count do
							children[index] = Host.TextLabel { Text = labelText(index) }
						end
						return Host.Frame(children)
					end, context.container)
					table.insert(state.disposers, dispose)
				end,
				snapshot = function(_state: MountState, context: ComposeContext): string
					return context.env.snapshot(context.container, { "Text" })
				end,
				release = function(state: MountState, _context: ComposeContext)
					for index = #state.disposers, 1, -1 do
						state.disposers[index]()
					end
				end,
			},
			plain = Types.plain {
				prepare = function(_context: PlainContext): MountPlain
					return { made = {} }
				end,
				run = function(state: MountPlain, context: PlainContext)
					local _frame, made = PlainSupport.buildList(context, count, labelText)
					table.insert(state.made, made)
				end,
				snapshot = function(_state: MountPlain, context: PlainContext): string
					return context.env.snapshot(context.container, { "Text" })
				end,
				release = function(state: MountPlain, _context: PlainContext)
					for index = #state.made, 1, -1 do
						PlainSupport.destroyAll(state.made[index])
						state.made[index] = nil
					end
				end,
			},
		},
		unsupported = {},
	}
end

local mountDispose: Workload = {
	id = "mount-dispose",
	title = "Warm mount and complete disposal",
	what = "Builds a 200-node tree and tears it down again, in one timed operation. Measures the round trip, "
		.. "and the release counters prove the teardown was complete.",
	samples = 20,
	iterations = 5,
	warmup = 3,
	cases = {
		compose = Types.compose {
			prepare = function(_context: ComposeContext): {}
				return {}
			end,
			run = function(_state: {}, context: ComposeContext)
				local Host = context.extras.runtime.constructors
				local dispose = context.extras.runtime.mount(function()
					local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
					local children: { Core.Node } = createChildren(200)
					for index = 1, 200 do
						children[index] = Host.TextLabel { Text = labelText(index) }
					end
					return Host.Frame(children)
				end, context.container)
				local observe = context.observe
				if observe ~= nil then
					observe(context.env.snapshot(context.container, { "Text" }))
				end
				dispose()
			end,
			snapshot = function(_state: {}, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(_state: {}, _context: ComposeContext) end,
		},
		plain = Types.plain {
			prepare = function(_context: PlainContext): {}
				return {}
			end,
			run = function(_state: {}, context: PlainContext)
				local _frame, made = PlainSupport.buildList(context, 200, labelText)
				local observe = context.observe
				if observe ~= nil then
					observe(context.env.snapshot(context.container, { "Text" }))
				end
				PlainSupport.destroyAll(made)
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
	coldMount(100),
	coldMount(1000),
	coldMount(10000),
	mountDispose,
}
