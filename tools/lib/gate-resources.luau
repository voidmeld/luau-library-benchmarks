--!strict

local Lute = require "../../.lute/dependencies/verify/src/lute"

local function resolve(threads: number, memoryMiB: number, sources: number): number
	local memorySlots = math.max(1, math.floor((memoryMiB - 2048) / 2048))
	return Lute.corpus.workers(threads, nil, sources, 0, math.min(8, memorySlots))
end

return resolve
