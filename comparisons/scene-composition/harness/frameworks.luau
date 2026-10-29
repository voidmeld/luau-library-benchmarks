--!strict

local Environment = require "../cost-model"
local Upstream = require "./upstream"

type Extras = {}

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

local function open(framework: Framework, cold: boolean?): Opened
	local existing = sessions[framework.name]
	if existing ~= nil and not cold then
		return existing
	end
	local environment = Environment.create()
	local loader = Upstream.create(environment)
	environment.load = function<T>(path: string): T
		return loader.load(path)
	end
	environment.callback = Upstream.callback
	environment.entries = Upstream.entries
	local opened: Opened = {
		environment = environment,
		loaded = if cold then { library = nil, extras = {} } else framework.load(environment),
	}
	if not cold then
		sessions[framework.name] = opened
	end
	environment.drain()
	return opened
end

local function close(framework: Framework)
	local opened = sessions[framework.name]
	if opened then
		require("../lanes/workloads").close(opened.environment)
		require("../lanes/compose").close(opened.environment)
	end
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
	require("../lanes/workloads").configure(Upstream.mode())
	return result
end

return {
	available = available,
	open = open,
	close = close,
}
