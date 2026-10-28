--!strict

local Cases = require "./cases"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Verify = require "../../../.lute/dependencies/verify/src/core"

local SAMPLES = 10
local TIMEOUT_SECONDS = 600

local factory: Roblox.CaseEntryFactory = function(host)
	local cases: { Verify.NamedCase } = {}
	for _, case in Cases.cases() do
		if case.unsupported ~= nil then
			continue
		end
		local id = case.workload .. "/" .. case.lane
		table.insert(cases, {
			id = id,
			name = id,
			timeoutSeconds = TIMEOUT_SECONDS,
			run = function(context: Verify.Context)
				local result = case.run(SAMPLES)
				local timing: "observed" = "observed"
				context:measure(case.lane, id, {
					samples = result.samples,
					unit = "microseconds",
					context = { environment = "studio-client", signal = "luau-profiler", timing = timing },
				}, { unit = "microseconds", minimumSamples = SAMPLES, measureOnly = true })
				context:attach("snapshot.txt", "text/plain", result.snapshot)
			end,
		})
	end
	local environment: { [string]: string } = { runtime = host :: string }
	if host ~= "simulator" then
		local engine = Roblox.experienceHost.nativeEngine()
		environment.context = engine.context
		environment.version = engine.version
		environment.studio = tostring(engine.studio)
	end
	return {
		cases = cases,
		now = os.clock,
		options = { executor = host, capabilities = {}, environment = environment },
	}
end

return factory
