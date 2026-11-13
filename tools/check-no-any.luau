--!strict
local Checks = require "../.lute/dependencies/verify/src/checks"
local Config = require "./checks-config"
local Finish = require "./lib/check-result"

local LANE = "a lane recovers its own library value from the shared Source and Scope types, which erase it"
local NATIVE = "Studio reads native engine values on timed paths, where a checked accessor adds work to the measurement"
local NODE = "a workload reads Instance members as the shared Node type, which adds typed signals"
local COST = "the cost-model typeof runs inside timed library loops"
local WITHHELD =
	"the plain lane world omits the library fields that the shared World type declares and raises when a plain path reads one"

local BOUNDARY: { [string]: string } = {
	["comparisons/scene-composition/cost-model/init.luau"] = COST,
	["comparisons/scene-composition/lanes/compose.luau"] = LANE,
	["comparisons/scene-composition/lanes/derived.luau"] = LANE,
	["comparisons/scene-composition/lanes/fusion.luau"] = LANE,
	["comparisons/scene-composition/lanes/game-blend.luau"] = LANE,
	["comparisons/scene-composition/lanes/game-roact.luau"] = LANE,
	["comparisons/scene-composition/lanes/joined.luau"] = LANE,
	["comparisons/scene-composition/lanes/memo.luau"] = LANE,
	["comparisons/scene-composition/lanes/plain-rows.luau"] = LANE,
	["comparisons/scene-composition/lanes/react-reflex.luau"] = LANE,
	["comparisons/scene-composition/lanes/seam.luau"] = LANE,
	["comparisons/scene-composition/lanes/signals.luau"] = LANE,
	["comparisons/scene-composition/lanes/vide.luau"] = LANE,
	["comparisons/scene-composition/studio/engine.luau"] = NATIVE,
	["comparisons/ui-components/studio/input.luau"] = NATIVE,
	["comparisons/ui-components/studio/world.luau"] = NATIVE,
	["comparisons/ui-components/headless.luau"] = NODE,
	["comparisons/ui-components/library-free.luau"] = WITHHELD,
	["comparisons/ui-components/workloads/inputs.luau"] = NODE,
	["comparisons/ui-components/workloads/modals.luau"] = NODE,
	["comparisons/ui-components/workloads/native-motion.luau"] = NODE,
	["comparisons/ui-components/workloads/preferences.luau"] = NODE,
	["comparisons/ui-components/workloads/screens.luau"] = NODE,
	["comparisons/ui-components/workloads/support.luau"] = NODE,
	["comparisons/ui-components/workloads/surfaces.luau"] = NODE,
	["comparisons/ui-components/workloads/traversal.luau"] = NODE,
}

local findings: { string } = {}
for _, finding in Checks.noAny(Config.noAny) do
	local path = string.match(finding, "^(.-):%d+: type casts are forbidden$")
	if path == nil or BOUNDARY[path] == nil then
		table.insert(findings, finding)
	end
end
Finish("check-no-any", findings)
