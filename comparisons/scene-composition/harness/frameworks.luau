--!strict

local ComposeCore = require "../../../.lute/dependencies/compose/src/core"
local Environment = require "../cost-model"

type Extras = { runtime: ComposeCore.Runtime? }

export type Loaded<L = unknown, E = Extras> = {
	library: L,
	extras: E,
}

export type Framework = {
	name: string,
	version: string,
	what: string,
	writesEveryValue: boolean?,
	load: (environment: Environment.Environment) -> Loaded,
}

export type Opened = {
	environment: Environment.Environment,
	loaded: Loaded,
}

local PLAIN: Framework = {
	name = "plain",
	version = "n/a",
	what = "no framework: plain imperative Luau against the same cost-model environment",
	load = function(environment: Environment.Environment): Loaded
		return { library = environment.globals, extras = {} }
	end,
}

local sessions: { [string]: Opened } = {}

local function open(framework: Framework): Opened
	local existing = sessions[framework.name]
	if existing ~= nil then
		return existing
	end
	local environment = Environment.create()
	local opened: Opened = { environment = environment, loaded = framework.load(environment) }
	sessions[framework.name] = opened
	environment.drain()
	return opened
end

local function close(framework: Framework)
	sessions[framework.name] = nil
end

local function available(): { Framework }
	local result: { Framework } = { PLAIN }
	for _, entry in require "../lanes" do
		table.insert(result, {
			name = entry.name,
			version = entry.version,
			what = entry.what,
			writesEveryValue = entry.writesEveryValue,
			load = entry.load,
		})
	end
	return result
end

return {
	available = available,
	open = open,
	close = close,
}
