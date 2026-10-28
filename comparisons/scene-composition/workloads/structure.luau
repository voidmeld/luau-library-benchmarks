--!strict

local BareSupport = require "./bare-support"
local Types = require "./types"

local Core = require "../../../.lute/dependencies/compose/src/core"
local Environment = require "../cost-model"

type ComposeContext = Types.ComposeContext
type BareContext = Types.BareContext
type Workload = Types.Workload

local ROWS = 300

type Row = { id: number }

type KeyedState = {
	dispose: () -> (),
	list: Core.Value<{ Row }>,
	initial: { Row },
	changed: { Row },
	flip: boolean,
	runtime: Core.Runtime,
}
type KeyedBare = {
	frame: Environment.Instance,
	byId: { [number]: Environment.Instance },
	order: { number },
	apply: ({ Row }) -> (),
	initial: { Row },
	changed: { Row },
	flip: boolean,
}
type BranchState = { open: Core.Value<boolean>, dispose: () -> (), isOpen: boolean, runtime: Core.Runtime }
type BranchBare = {
	frame: Environment.Instance,
	header: Environment.Instance,
	footer: Environment.Instance,
	panel: Environment.Instance?,
	open: boolean,
}
type WindowState = {
	dispose: () -> (),
	viewport: Core.Value<{ offset: number, size: number }>,
	tick: number,
	runtime: Core.Runtime,
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
			compose = Types.compose {
				prepare = function(context: ComposeContext): KeyedState
					local Host = context.extras.runtime.constructors
					local initial = rows(ROWS)
					local changed = transform(initial)
					local list = context.library.cell(initial)
					local dispose = context.extras.runtime.mount(function()
						return Host.Frame {
							context.library.keyed {
								from = list,
								render = function(value: Core.ReadOnlyValue<Row>, index: Core.ReadOnlyValue<number>)
									return Host.TextLabel {

										Text = tostring(value:peek().id),
										LayoutOrder = function(use: Core.Use)
											return use(index)
										end,
									}
								end,
							},
						}
					end, context.container)
					return {
						dispose = dispose,
						list = list,
						initial = initial,
						changed = changed,
						flip = false,
						runtime = context.extras.runtime,
					}
				end,
				run = function(state: KeyedState, _context: ComposeContext)
					state.flip = not state.flip
					state.list:set(if state.flip then state.changed else state.initial)
					state.runtime:settle()
				end,
				snapshot = function(_state: KeyedState, context: ComposeContext): string
					return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
				end,
				release = function(state: KeyedState, _context: ComposeContext)
					state.dispose()
				end,
			},
			bare = Types.bare {
				prepare = function(context: BareContext): KeyedBare
					local Instance = BareSupport.instances(context)
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
				run = function(state: KeyedBare, _context: BareContext)
					state.flip = not state.flip
					state.apply(if state.flip then state.changed else state.initial)
				end,
				snapshot = function(_state: KeyedBare, context: BareContext): string
					return context.env.snapshot(context.container, { "Text", "LayoutOrder" }, "LayoutOrder")
				end,
				release = function(state: KeyedBare, _context: BareContext)
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

local keyedAppend = keyedWorkload(
	"keyed-append",
	"Keyed append",
	("Adds ten rows to the end of a keyed list of %d and takes them away again. Nothing already in the "):format(ROWS)
		.. "list should be created, destroyed, or moved.",
	function(initial: { Row }): { Row }
		local out = table.clone(initial)
		for _, row in rows(10, ROWS) do
			table.insert(out, row)
		end
		return out
	end
)

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

local keyedRemove = keyedWorkload(
	"keyed-remove",
	"Keyed removal from the middle",
	"Removes ten rows from the middle. Exactly ten nodes should be destroyed and none created.",
	function(initial: { Row }): { Row }
		local out = table.clone(initial)
		local middle = math.floor(#out / 2)
		for _ = 1, 10 do
			table.remove(out, middle)
		end
		return out
	end
)

local keyedReplace = keyedWorkload(
	"keyed-replace",
	"Keyed full replacement",
	"Replaces every row with a new one. This is the case where rebuilding really is correct, and it is "
		.. "here so the other keyed numbers have something to be compared against.",
	function(_initial: { Row }): { Row }
		return rows(ROWS, ROWS + 1000)
	end
)

local keyedReverse = keyedWorkload(
	"keyed-reverse",
	"Keyed reversal",
	"Reverses the list. The worst case for reordering: no run of rows keeps its relative order, so almost "
		.. "everything has to move. Nothing should be recreated.",
	function(initial: { Row }): { Row }
		local out = table.clone(initial)
		local count = #out
		for index = 1, count // 2 do
			out[index], out[count - index + 1] = out[count - index + 1], out[index]
		end
		return out
	end
)

local keyedRotate = keyedWorkload(
	"keyed-rotate",
	"Keyed rotation by one",
	"Moves the last row to the front. Every row is still in relative order except one, so a framework that "
		.. "reorders well moves one node and one that does not moves nearly all of them.",
	function(initial: { Row }): { Row }
		local out = table.clone(initial)
		table.insert(out, 1, assert(table.remove(out)))
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
		compose = Types.compose {
			prepare = function(context: ComposeContext): BranchState
				local Host = context.extras.runtime.constructors
				local open = context.library.cell(false)
				local dispose = context.extras.runtime.mount(function()
					return Host.Frame {
						Host.TextLabel { Text = "header" },
						context.library.show(function(use: Core.Use)
							return use(open)
						end, function()
							local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
							local children: { Core.Node } = createChildren(50)
							for index = 1, 50 do
								children[index] = Host.TextLabel { Text = "panel " .. tostring(index) }
							end
							return Host.Frame(children)
						end),
						Host.TextLabel { Text = "footer" },
					}
				end, context.container)
				return { open = open, dispose = dispose, isOpen = false, runtime = context.extras.runtime }
			end,
			run = function(state: BranchState, _context: ComposeContext)
				state.isOpen = not state.isOpen
				state.open:set(state.isOpen)
				state.runtime:settle()
			end,
			snapshot = function(_state: BranchState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: BranchState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): BranchBare
				local Instance = BareSupport.instances(context)
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
			run = function(state: BranchBare, context: BareContext)
				state.open = not state.open
				if state.open then
					local Instance = BareSupport.instances(context)
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
			snapshot = function(_state: BranchBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: BranchBare, _context: BareContext)
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
	keyedAppend,
	keyedPrepend,
	keyedInsert,
	keyedRemove,
	keyedReplace,
	keyedReverse,
	keyedRotate,
	keyedShuffle,
}
