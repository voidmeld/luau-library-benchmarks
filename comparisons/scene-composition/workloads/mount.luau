--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Environment = require "../cost-model"

type PlainContext = Types.PlainContext
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
