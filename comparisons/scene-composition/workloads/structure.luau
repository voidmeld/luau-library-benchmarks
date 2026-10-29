--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Environment = require "../cost-model"

type PlainContext = Types.PlainContext
type Workload = Types.Workload

local ROWS = 300

type Row = { id: number }

type KeyedPlain = {
	frame: Environment.Instance,
	byId: { [number]: Environment.Instance },
	order: { number },
	apply: ({ Row }) -> (),
	initial: { Row },
	changed: { Row },
	flip: boolean,
}
type BranchPlain = {
	frame: Environment.Instance,
	header: Environment.Instance,
	footer: Environment.Instance,
	panel: Environment.Instance?,
	open: boolean,
}

local function rows(count: number, offset: number?): { Row }
	local start = if offset ~= nil then offset else 0
	local createList: (number, Row?) -> { Row } = table.create
	local list: { Row } = createList(count)
	for index = 1, count do
		list[index] = { id = start + index }
	end
	return list
end

local function shuffled(list: { Row }): { Row }
	local out = table.clone(list)
	local seed = 12345
	for index = #out, 2, -1 do
		seed = (seed * 1103515245 + 12345) % 2147483648
		local pick = (seed % index) + 1
		out[index], out[pick] = out[pick], out[index]
	end
	return out
end

local function keyedWorkload(
	id: string,
	title: string,
	what: string,
	transform: (initial: { Row }) -> { Row }
): Workload
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
					local initial = rows(ROWS)
					local changed = transform(initial)

					local frame = Instance.new "Frame"
					frame.Parent = context.container

					local byId: { [number]: Environment.Instance } = {}
					local order: { number } = {}

					local function apply(list: { Row })
						local wanted: { [number]: number } = {}
						for index, row in list do
							wanted[row.id] = index
						end

						for index = #order, 1, -1 do
							local id = order[index]
							if wanted[id] == nil then
								byId[id]:Destroy()
								byId[id] = nil
								table.remove(order, index)
							end
						end

						for index, row in list do
							local node = byId[row.id]
							if node == nil then
								node = Instance.new "TextLabel"
								node.Text = tostring(row.id)
								node.LayoutOrder = index
								node.Parent = frame
								byId[row.id] = node
								table.insert(order, row.id)
							elseif node.LayoutOrder ~= index then
								node.LayoutOrder = index
							end
						end
					end

					apply(initial)
					return {
						frame = frame,
						byId = byId,
						order = order,
						apply = apply,
						initial = initial,
						changed = changed,
						flip = false,
					}
				end,
				run = function(state: KeyedPlain, _context: PlainContext)
					state.flip = not state.flip
					state.apply(if state.flip then state.changed else state.initial)
				end,
				snapshot = function(_state: KeyedPlain, context: PlainContext): string
					return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
				end,
				release = function(state: KeyedPlain, _context: PlainContext)
					for _, id in state.order do
						state.byId[id]:Destroy()
					end
					state.frame:Destroy()
				end,
			},
		},
		unsupported = {},
	}
end

local keyedPrepend = keyedWorkload(
	"keyed-prepend",
	"Keyed prepend",
	("Adds ten rows to the front of a keyed list of %d. The rows behind them must keep their identity, "):format(ROWS)
		.. "which is the difference between prepending and rebuilding.",
	function(initial: { Row }): { Row }
		local out = rows(10, ROWS + 100)
		for _, row in initial do
			table.insert(out, row)
		end
		return out
	end
)

local keyedInsert = keyedWorkload(
	"keyed-insert",
	"Keyed insert into the middle",
	"Inserts ten rows into the middle of the list. Neighbours should not move.",
	function(initial: { Row }): { Row }
		local out = table.clone(initial)
		local middle = math.floor(#out / 2)
		for offset, row in rows(10, ROWS + 200) do
			table.insert(out, middle + offset, row)
		end
		return out
	end
)

local keyedShuffle = keyedWorkload(
	"keyed-shuffle",
	"Keyed shuffle",
	"Applies a fixed pseudorandom permutation. Fixed seed, so every framework sees the same one.",
	function(initial: { Row }): { Row }
		return shuffled(initial)
	end
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
				local panelValue: Environment.Instance? = nil
				return {
					frame = frame,
					header = header,
					footer = footer,
					panel = panelValue,
					open = false,
				}
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
