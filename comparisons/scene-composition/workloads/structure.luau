--!strict
--!native

local PlainSupport = require "./plain-support"
local Shared = require "./shared"
local Types = require "./types"

local Environment = require "../cost-model"

type PlainContext = Types.PlainContext
type Workload = Types.Workload

type KeyedPlain = {
	labels: Shared.Labels,
	initial: { Shared.Row },
	changed: { Shared.Row },
	flip: boolean,
}
type BranchPlain = {
	frame: Environment.Instance,
	header: Environment.Instance,
	footer: Environment.Instance,
	panel: Environment.Instance?,
	open: boolean,
}

local function keyedWorkload(id: string, title: string, what: string): Workload
	return {
		id = id,
		title = title,
		what = what,
		samples = 25,
		iterations = 10,
		warmup = 5,
		cases = {
			plain = Types.plain {
				prepare = function(context: PlainContext): KeyedPlain
					local Instance = PlainSupport.instances(context)
					local initial, changed = Shared.keyedLists(id)
					local frame = Instance.new "Frame"
					frame.Parent = context.container
					local labels = Shared.labels(frame)
					Shared.applyLabels(labels, Instance, initial)
					return { labels = labels, initial = initial, changed = changed, flip = false }
				end,
				run = function(state: KeyedPlain, context: PlainContext)
					state.flip = not state.flip
					Shared.applyLabels(
						state.labels,
						PlainSupport.instances(context),
						if state.flip then state.changed else state.initial
					)
				end,
				snapshot = function(_state: KeyedPlain, context: PlainContext): string
					return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
				end,
				release = function(state: KeyedPlain, _context: PlainContext)
					Shared.releaseLabels(state.labels)
				end,
			},
		},
		unsupported = {},
	}
end

local keyedPrepend = keyedWorkload(
	"keyed-prepend",
	"Keyed prepend",
	("Adds ten rows to the front of a keyed list of %d. The rows behind them must keep their identity, "):format(
		Shared.KEYED_ROWS
	) .. "which is the difference between prepending and rebuilding."
)

local keyedInsert = keyedWorkload(
	"keyed-insert",
	"Keyed insert into the middle",
	"Inserts ten rows into the middle of the list. Neighbours should not move."
)

local keyedShuffle = keyedWorkload(
	"keyed-shuffle",
	"Keyed shuffle",
	"Applies a fixed pseudorandom permutation. Fixed seed, so every framework sees the same one."
)

local branchSwap: Workload = {
	id = "branch-swap",
	title = "Conditional branch swap",
	what = "Toggles a 50-node subtree in and out. Measures the cost of mounting and unmounting a branch, "
		.. "and confirms the surrounding tree is untouched.",
	samples = 25,
	iterations = 20,
	warmup = 5,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): BranchPlain
				local Instance = PlainSupport.instances(context)
				local frame = Instance.new "Frame"
				local header = Instance.new "TextLabel"
				header.Text = "header"
				header.Parent = frame
				local footer = Instance.new "TextLabel"
				footer.Text = "footer"
				footer.Parent = frame
				frame.Parent = context.container
				return { frame = frame, header = header, footer = footer, panel = nil, open = false }
			end,
			run = function(state: BranchPlain, context: PlainContext)
				state.open = not state.open
				if state.open then
					local Instance = PlainSupport.instances(context)
					local panel = Instance.new "Frame"
					for index = 1, 50 do
						local label = Instance.new "TextLabel"
						label.Text = "panel " .. tostring(index)
						label.Parent = panel
					end
					panel.Parent = state.frame
					state.panel = panel
				else
					assert(state.panel):Destroy()
					state.panel = nil
				end
			end,
			snapshot = function(_state: BranchPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: BranchPlain, _context: PlainContext)
				if state.panel ~= nil then
					state.panel:Destroy()
				end
				state.footer:Destroy()
				state.header:Destroy()
				state.frame:Destroy()
			end,
		},
	},
	unsupported = {},
}

return {
	branchSwap,
	keyedPrepend,
	keyedInsert,
	keyedShuffle,
}
