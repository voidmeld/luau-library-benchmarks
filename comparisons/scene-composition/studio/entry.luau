--!strict

local Cases = require "./cases"
local Memory = require "./memory"
local Settings = require "../../memory-settings"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Verify = require "../../../.lute/dependencies/verify/src/core"

local SAMPLES = 5

local function digest(text: string): string
	local first, second = 2166136261, 5381
	for index = 1, #text do
		local byte = string.byte(text, index)
		first = bit32.bxor(first, byte) * 16777619 % 4294967296
		second = (second * 33 + byte) % 4294967296
	end
	return ("%08x%08x:%d"):format(first, second, #text)
end
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
				}, { unit = "microseconds", minimumSamples = Settings.studioTimingMinimum, measureOnly = true })
				for _, metric in
					{ { name = "mounted", samples = result.mounted }, { name = "teardown", samples = result.teardown } }
				do
					context:measure(case.lane, id .. "/memory/" .. metric.name, {
						samples = metric.samples,
						unit = "KiB",
						context = { environment = Memory.METHOD, signal = metric.name, timing = timing },
					}, { unit = "KiB", minimumSamples = Memory.MINIMUM, measureOnly = true })
				end
				context:attach("snapshot.txt", "text/plain", digest(result.snapshot))
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
