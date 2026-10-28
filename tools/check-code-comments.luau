--!strict
local Checks = require "../.lute/dependencies/verify/src/checks"
local Config = require "./checks-config"
local Finish = require "./lib/check-result"
local process = require "@std/process"
local config = table.clone(Config.comments)
if #process.args > 1 then
	assert(#process.args == 2 and process.args[2] == "--write", "expected no arguments or --write")
	config.write = true
end
Finish("check-code-comments", Checks.comments(config))
