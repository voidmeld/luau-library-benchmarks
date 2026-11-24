--!strict

local Bdd = require "@verify/src/bdd"

return Bdd.surface {
	executor = "compose-tests",
	environment = { runtime = "lute" },
	capabilities = {},
	ambientSource = "compose-tests",
}
