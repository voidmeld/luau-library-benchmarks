--!strict

local Denylist = require "../.lute/dependencies/verify/src/checks/denylist"
export type Rule = Denylist.Rule

local productMaterial: { Rule } = {
	{ pattern = "rbxassetid://", why = "product asset identifier" },
	{ pattern = "rbxthumb://", why = "product asset identifier" },
	{ pattern = "%f[%w_]placeId%s*=%s*[1-9]", why = "product place identifier" },
	{ pattern = "%f[%w_]universeId%s*=%s*[1-9]", why = "product universe identifier" },
}

return {
	leakage = productMaterial,
	selfPath = "tools/checks-policy.luau",
}
