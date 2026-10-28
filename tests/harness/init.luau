--!strict

local Bdd = require "../.lute/dependencies/verify/src/bdd"

return Bdd.surface {
	executor = "compose-tests",
	environment = { runtime = "lute" },
	capabilities = {},
	ambientSource = "compose-tests",
}
