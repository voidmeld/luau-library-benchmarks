--!strict

local Roblox = require "@verify/src/roblox"
local Verify = require "@verify/src/core"

export type CaseEntryFactory = Roblox.CaseEntryFactory
export type NamedCase = Verify.NamedCase
export type Context = Verify.Context

return table.freeze {
	Roblox = Roblox,
}
