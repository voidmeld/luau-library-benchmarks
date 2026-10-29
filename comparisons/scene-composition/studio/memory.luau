--!strict

local Memory = require "../../../.lute/dependencies/verify/src/lute/memory"

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

local OPTIONS: Memory.Options = { cycles = 8, maxAllocations = 2500000, deadlineSeconds = 30 }
local SAMPLES = 3

local function measure<T>(spec: Spec<T>): { mounted: { number }, teardown: { number } }
	local mounted: { number }, teardown: { number } = {}, {}
	bound.measure(spec, OPTIONS)
	for _ = 1, SAMPLES do
		local result = bound.measure(spec, OPTIONS)
		table.insert(mounted, result.mountedRetainedKb)
		table.insert(teardown, result.teardownRetainedKb)
	end
	return { mounted = mounted, teardown = teardown }
end

return { METHOD = Memory.METHOD, SAMPLES = SAMPLES, measure = measure }
