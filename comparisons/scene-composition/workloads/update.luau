--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Environment = require "../cost-model"
type PlainContext = Types.PlainContext
type LeafPlain = { made: { Environment.Instance }, live: Environment.Instance, next: number }
type RowsPlain = { made: { Environment.Instance }, rows: { Environment.Instance }, next: number }
type RepeatPlain = { made: { Environment.Instance }, label: Environment.Instance, base: number }
type Workload = Types.Workload

local LEAF_TREE = 500
local SOURCES = 300
local REPEATS = 500

local updateLeaf: Workload = {
	id = "update-leaf",
	title = "Single leaf property update",
	what = ("Changes the text of one label in a tree of %d. The interesting number is how many property "):format(
		LEAF_TREE
	) .. "writes it takes: the answer should be one.",
	samples = 30,
	iterations = 20,
	warmup = 5,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): LeafPlain
				local frame, made = PlainSupport.buildList(context, LEAF_TREE, function(index: number): string
					return if index == 1 then "value 0" else "static " .. tostring(index)
				end)
				return { made = made, live = context.env.children(frame)[1], next = 0 }
			end,
			run = function(state: LeafPlain, _context: PlainContext)
				state.next += 1
				state.live.Text = "value " .. tostring(state.next)
			end,
			snapshot = function(_state: LeafPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: LeafPlain, _context: PlainContext)
				PlainSupport.destroyAll(state.made)
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
		plain = Types.plain {
			prepare = function(context: PlainContext): RowsPlain
				local frame, made = PlainSupport.buildList(context, SOURCES, function(): string
					return "0"
				end)
				return { made = made, rows = context.env.children(frame), next = 0 }
			end,
			run = function(state: RowsPlain, _context: PlainContext)
				state.next += 1
				local text = tostring(state.next)
				for _, row in state.rows do
					row.Text = text
				end
			end,
			snapshot = function(_state: RowsPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RowsPlain, _context: PlainContext)
				PlainSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

local updateRepeated: Workload = {
	id = "update-repeated",
	title = "Repeated writes to one source",
	what = ("Writes one source %d times inside a single batch. Only the last value should ever reach the "):format(
		REPEATS
	) .. "host, so the property-write count should be one however many writes happened.",
	samples = 25,
	iterations = 10,
	warmup = 5,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): RepeatPlain
				local frame, made = PlainSupport.buildList(context, 1, function(): string
					return "0"
				end)
				return { made = made, label = context.env.children(frame)[1], base = 0 }
			end,
			run = function(state: RepeatPlain, _context: PlainContext)
				local final = state.base
				for step = 1, REPEATS do
					final = state.base + step
				end
				state.label.Text = tostring(final)
				state.base += REPEATS
			end,
			snapshot = function(_state: RepeatPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Text" })
			end,
			release = function(state: RepeatPlain, _context: PlainContext)
				PlainSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

return {
	updateLeaf,
	updateBatched,
	updateRepeated,
}
