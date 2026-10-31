--!strict

local Memory = require "../../../.lute/dependencies/verify/src/lute/memory"
local Settings = require "../../memory-settings"

export type Spec<T> = Memory.Spec<T>
export type Result = Memory.Result

local function witness(): Memory.Witness
	local weak: { token: {}? } = { token = {} }
	return setmetatable(weak, { __mode = "v" })
end

local bound = Memory.create {
	now = os.clock,
	heap = gcinfo,
	witness = witness,
	pressure = function()
		local scratch = buffer.create(8192)
		assert(buffer.len(scratch) == 8192, "memory pressure allocation failed")
	end,
}

local OPTIONS: Memory.Options =
	{ cycles = Settings.cycles, maxAllocations = Settings.maxAllocations, deadlineSeconds = 30 }
local SAMPLES = Settings.studioSamples
local MINIMUM = Settings.studioMinimumSamples
local BUDGET = Settings.studioBudgetSeconds

local function measure<T>(make: () -> (Spec<T>, () -> ())): { mounted: { number }, teardown: { number } }
	local function sample(): Memory.Result
		local spec, dispose = make()
		local ok, result = pcall(bound.measure, spec, OPTIONS)
		dispose()
		if not ok then
			error(result, 0)
		end
		return result
	end
	local mounted: { number }, teardown: { number } = {}, {}
	sample()
	local started = os.clock()
	for _ = 1, SAMPLES do
		local result = sample()
		table.insert(mounted, result.mountedRetainedKb)
		table.insert(teardown, result.teardownRetainedKb)
		if #mounted >= MINIMUM and os.clock() - started > BUDGET then
			break
		end
	end
	return { mounted = mounted, teardown = teardown }
end

return { METHOD = Memory.METHOD, SAMPLES = SAMPLES, MINIMUM = MINIMUM, measure = measure }
