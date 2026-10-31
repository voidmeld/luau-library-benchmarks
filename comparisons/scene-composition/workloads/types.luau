--!strict

local Environment = require "../cost-model"

export type Extras = {}

export type Context<L = unknown, E = Extras> = {
	env: Environment.Environment,
	library: L,
	extras: E,
	container: Environment.Instance,
	observe: ((string) -> ())?,
	collect: (() -> ())?,
}

export type PlainContext = Context<Environment.Globals, {}>

export type State = {
	checkWork: ((Environment.Counters) -> ())?,
	moduleInstances: number?,
	moduleConnections: number?,
	run: () -> (),
	snapshot: () -> string,
	release: () -> (),
}

type ErasedContext = Context<unknown, Extras>

export type Case<S = State, C = ErasedContext> = {
	prepare: (context: C) -> S,
	run: (state: S, context: C) -> (),
	snapshot: (state: S, context: C) -> string,
	release: (state: S, context: C) -> (),
}

export type Workload = {
	id: string,
	title: string,
	what: string,
	samples: number,
	iterations: number,
	warmup: number,
	cases: { [string]: Case },
	unsupported: { [string]: string }?,
	workarounds: { [string]: string }?,
}

local function pack<S, C>(case: Case<S, C>, convert: (Context) -> C): Case
	return {
		prepare = function(context: Context): State
			local typed = convert(context)
			local state = case.prepare(typed)
			return {
				run = function()
					case.run(state, typed)
				end,
				snapshot = function(): string
					return case.snapshot(state, typed)
				end,
				release = function()
					case.release(state, typed)
				end,
			}
		end,
		run = function(state: State, _context: Context)
			state.run()
		end,
		snapshot = function(state: State, _context: Context): string
			return state.snapshot()
		end,
		release = function(state: State, _context: Context)
			state.release()
		end,
	}
end

local function plain<S>(case: Case<S, PlainContext>): Case
	return pack(case, function(context: Context): PlainContext
		return {
			env = context.env,
			library = context.env.globals,
			extras = {},
			container = context.container,
			observe = context.observe,
		}
	end)
end

return { plain = plain }
