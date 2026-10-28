--!strict

local BareSupport = require "./bare-support"
local Types = require "./types"

local Core = require "../../../.lute/dependencies/compose/src/core"
local Environment = require "../cost-model"
type ComposeContext = Types.ComposeContext
type BareContext = Types.BareContext
type LeafState = { text: Core.Value<string>, dispose: () -> (), next: number, runtime: Core.Runtime }
type LeafBare = { made: { Environment.Instance }, live: Environment.Instance, next: number }
type FanoutState = { tint: Core.Value<string>, dispose: () -> (), next: number, runtime: Core.Runtime }
type RowsBare = { made: { Environment.Instance }, rows: { Environment.Instance }, next: number }
type CellsState = { cells: { Core.Value<string> }, dispose: () -> (), next: number, runtime: Core.Runtime }
type RepeatState = { value: Core.Value<number>, dispose: () -> (), base: number, runtime: Core.Runtime }
type RepeatBare = { made: { Environment.Instance }, label: Environment.Instance, base: number }
type Workload = Types.Workload

local LEAF_TREE = 500
local FANOUT = 300
local SOURCES = 300
local REPEATS = 500

local updateLeaf: Workload = {
	id = "update-leaf",
	title = "Single leaf property update",
	what = ("Changes the text of one label in a tree of %d. The interesting number is how many property "):format(
		LEAF_TREE
	) .. "writes it takes: the answer should be one.",
	samples = 30,
	iterations = 50,
	warmup = 5,
	cases = {
		compose = Types.compose {
			prepare = function(context: ComposeContext): LeafState
				local Host = context.extras.runtime.constructors
				local text = context.library.cell "value 0"
				local dispose = context.extras.runtime.mount(function()
					local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
					local children: { Core.Node } = createChildren(LEAF_TREE)
					for index = 1, LEAF_TREE do
						if index == 1 then
							children[index] = Host.TextLabel { Text = text }
						else
							children[index] = Host.TextLabel { Text = "static " .. tostring(index) }
						end
					end
					return Host.Frame(children)
				end, context.container)
				return { text = text, dispose = dispose, next = 0, runtime = context.extras.runtime }
			end,
			run = function(state: LeafState, _context: ComposeContext)
				state.next += 1
				state.text:set("value " .. tostring(state.next))
				state.runtime:settle()
			end,
			snapshot = function(_state: LeafState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: LeafState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): LeafBare
				local frame, made = BareSupport.buildList(context, LEAF_TREE, function(index: number): string
					return if index == 1 then "value 0" else "static " .. tostring(index)
				end)
				return { made = made, live = context.env.children(frame)[1], next = 0 }
			end,
			run = function(state: LeafBare, _context: BareContext)
				state.next += 1
				state.live.Text = "value " .. tostring(state.next)
			end,
			snapshot = function(_state: LeafBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: LeafBare, _context: BareContext)
				BareSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

local updateFanout: Workload = {
	id = "update-fanout",
	title = "One source driving a large fan-out",
	what = ("One value feeds a property on %d nodes at once. Measures how a framework dispatches to many "):format(
		FANOUT
	) .. "dependents, and confirms it writes exactly as many properties as changed.",
	samples = 25,
	iterations = 20,
	warmup = 5,
	cases = {
		compose = Types.compose {
			prepare = function(context: ComposeContext): FanoutState
				local Host = context.extras.runtime.constructors
				local tint = context.library.cell "tint 0"
				local dispose = context.extras.runtime.mount(function()
					local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
					local children: { Core.Node } = createChildren(FANOUT)
					for index = 1, FANOUT do
						children[index] = Host.TextLabel { Text = tint }
					end
					return Host.Frame(children)
				end, context.container)
				return { tint = tint, dispose = dispose, next = 0, runtime = context.extras.runtime }
			end,
			run = function(state: FanoutState, _context: ComposeContext)
				state.next += 1
				state.tint:set("tint " .. tostring(state.next))
				state.runtime:settle()
			end,
			snapshot = function(_state: FanoutState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: FanoutState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): RowsBare
				local frame, made = BareSupport.buildList(context, FANOUT, function(): string
					return "tint 0"
				end)
				return { made = made, rows = context.env.children(frame), next = 0 }
			end,
			run = function(state: RowsBare, _context: BareContext)
				state.next += 1
				local text = "tint " .. tostring(state.next)
				for _, row in state.rows do
					row.Text = text
				end
			end,
			snapshot = function(_state: RowsBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RowsBare, _context: BareContext)
				BareSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

local updateBatched: Workload = {
	id = "update-batched",
	title = "Many independent updates in one batch",
	what = ("%d independent sources, each driving its own node, all updated before anything is allowed to "):format(
		SOURCES
	) .. "observe them. Measures coalescing and confirms no node is written twice.",
	samples = 25,
	iterations = 20,
	warmup = 5,
	cases = {
		compose = Types.compose {
			prepare = function(context: ComposeContext): CellsState
				local Host = context.extras.runtime.constructors
				local createSetters: (number, Core.Value<string>?) -> { Core.Value<string> } = table.create
				local setters: { Core.Value<string> } = createSetters(SOURCES)
				local dispose = context.extras.runtime.mount(function()
					local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
					local children: { Core.Node } = createChildren(SOURCES)
					for index = 1, SOURCES do
						local value = context.library.cell "0"
						setters[index] = value
						children[index] = Host.TextLabel { Text = value }
					end
					return Host.Frame(children)
				end, context.container)
				return { cells = setters, dispose = dispose, next = 0, runtime = context.extras.runtime }
			end,
			run = function(state: CellsState, _context: ComposeContext)
				state.next += 1
				local next = tostring(state.next)
				state.runtime:batch(function()
					for _, cell in state.cells do
						cell:set(next)
					end
				end)
			end,
			snapshot = function(_state: CellsState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: CellsState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): RowsBare
				local frame, made = BareSupport.buildList(context, SOURCES, function(): string
					return "0"
				end)
				return { made = made, rows = context.env.children(frame), next = 0 }
			end,
			run = function(state: RowsBare, _context: BareContext)
				state.next += 1
				local text = tostring(state.next)
				for _, row in state.rows do
					row.Text = text
				end
			end,
			snapshot = function(_state: RowsBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RowsBare, _context: BareContext)
				BareSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

local updateRepeated: Workload = {
	id = "update-repeated",
	contract = "measures merging 500 writes into one host write, which Compose does by design",
	title = "Repeated writes to one source",
	what = ("Writes one source %d times inside a single batch. Only the last value should ever reach the "):format(
		REPEATS
	) .. "host, so the property-write count should be one however many writes happened.",
	samples = 25,
	iterations = 10,
	warmup = 5,
	cases = {
		compose = Types.compose {
			prepare = function(context: ComposeContext): RepeatState
				local Host = context.extras.runtime.constructors
				local value = context.library.cell(0)
				local dispose = context.extras.runtime.mount(function()
					return Host.Frame {
						Host.TextLabel {
							Text = function(use: Core.Use)
								return tostring(use(value))
							end,
						},
					}
				end, context.container)
				return { value = value, dispose = dispose, base = 0, runtime = context.extras.runtime }
			end,
			run = function(state: RepeatState, _context: ComposeContext)
				state.runtime:batch(function()
					for step = 1, REPEATS do
						state.value:set(state.base + step)
					end
				end)
				state.base += REPEATS
			end,
			snapshot = function(_state: RepeatState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RepeatState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): RepeatBare
				local frame, made = BareSupport.buildList(context, 1, function(): string
					return "0"
				end)
				return { made = made, label = context.env.children(frame)[1], base = 0 }
			end,
			run = function(state: RepeatBare, _context: BareContext)
				local final = state.base
				for step = 1, REPEATS do
					final = state.base + step
				end
				state.label.Text = tostring(final)
				state.base += REPEATS
			end,
			snapshot = function(_state: RepeatBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RepeatBare, _context: BareContext)
				BareSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

return {
	updateLeaf,
	updateFanout,
	updateBatched,
	updateRepeated,
}
