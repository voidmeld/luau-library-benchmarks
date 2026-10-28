--!strict

local Roact = require "@self/roact"
local Seam = require "@self/seam"
local Signals = require "@self/signals"
local ReactReflex = require "@self/react-reflex"
local FusionCharm = require "@self/fusion-charm"
local ReactUpstream = require "@self/react-upstream"

local Blend = require "@self/blend"
local Compose = require "@self/compose"
local Fusion = require "@self/fusion"
local React = require "@self/react"
local Vide = require "@self/vide"
local Workloads = require "@self/workloads"
local WorkloadTypes = require "@self/../workloads/types"
local WorkloadList = require "@self/../workloads"
local Environment = require "@self/../cost-model"
local Lock = require "@self/../../../dependencies.lock"

for _, workload in WorkloadList.all do
	workload.cases["compose-direct"] = workload.cases.compose
end
local composeLoad = Workloads.include("compose", Compose.create)

local function composeDirect(environment: Environment.Environment): { library: unknown, extras: WorkloadTypes.Extras }
	local session = Compose.session(environment)
	return { library = session.library, extras = { runtime = session.runtime } }
end

local function version(name: string): string
	for _, dependency in Lock.dependencies do
		if dependency.name == name then
			return assert(dependency.version)
		end
	end
	error("benchmark dependency is not locked: " .. name, 0)
end

return {
	{
		name = "compose",
		version = version "compose",
		what = "Compose cells, formulas, keyed, show and springs through the comparison driver",
		writesEveryValue = false,
		load = function(environment: Environment.Environment): { library: unknown, extras: WorkloadTypes.Extras }
			composeLoad(environment)
			local session = Compose.session(environment)
			return { library = session.library, extras = { runtime = session.runtime } }
		end,
	},
	{
		name = "compose-direct",
		version = version "compose",
		what = "Compose direct workload cases, the control for the comparison driver",
		writesEveryValue = false,
		load = composeDirect,
	},
	{
		name = "fusion",
		version = version "fusion",
		what = "Fusion scoped values and Instances",
		writesEveryValue = true,
		load = Workloads.include("fusion", function(environment)
			return Fusion.create(environment)
		end),
	},
	{
		name = "vide",
		version = version "vide",
		what = "Vide sources, values and scoped cleanup",
		writesEveryValue = false,
		load = Workloads.include("vide", Vide.create, Vide.unsupported),
	},
	{
		name = "react",
		version = version "react",
		what = "React bindings and ReactRoblox legacy roots",
		writesEveryValue = true,
		load = Workloads.include("react", function(environment)
			return React.create(environment)
		end),
	},
	{
		name = "react-usestate",
		version = version "react",
		what = "React with useState for the repeated-write workload",
		writesEveryValue = false,
		load = Workloads.include("react-usestate", React.createWithState, React.stateUnsupported),
	},
	{
		name = "blend",
		version = version "blend",
		what = "Blend states, observables and computed pairs",
		writesEveryValue = false,
		load = Workloads.include("blend", Blend.create),
	},
	{
		name = "roact",
		version = version "roact",
		what = "roact public APIs",
		writesEveryValue = true,
		load = Workloads.include("roact", Roact.create, Roact.unsupported),
	},
	{
		name = "seam",
		version = version "seam",
		what = "seam public APIs",
		writesEveryValue = false,
		load = Workloads.include("seam", Seam.create, Seam.unsupported),
	},
	{
		name = "signals",
		version = version "signals",
		what = "signals public APIs",
		writesEveryValue = false,
		load = Workloads.include("signals", Signals.create, Signals.unsupported),
	},
	{
		name = "react-reflex",
		version = version "reflex",
		what = "react-reflex public APIs",
		writesEveryValue = false,
		load = Workloads.include("react-reflex", ReactReflex.create),
	},
	{
		name = "fusion-charm",
		version = version "charm",
		what = "fusion-charm public APIs",
		writesEveryValue = false,
		load = Workloads.include("fusion-charm", FusionCharm.create),
	},
	{
		name = "react-upstream",
		version = version "react-upstream",
		what = "react-upstream public APIs",
		writesEveryValue = true,
		load = Workloads.include("react-upstream", ReactUpstream.create),
	},
}
