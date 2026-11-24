--!strict

local fs = require "@std/fs"
local luau = require "@lute/luau"
local Finish = require "./lib/check-result"
local Sources = require "../comparisons/sources"

local record, text = Sources.record, Sources.text

local function load(path: string): unknown
	return luau.load(luau.compile(fs.readFileToString(path)), path)()
end

local manifest = record(record(load "pkg.luau", "pkg.luau").package, "pkg.luau package")
local declared = record(manifest.dependencies, "pkg.luau dependencies")
local lock = record(load "pkg.lock.luau", "pkg.lock.luau")
local lockedKeys = record(lock.dependencies, "pkg.lock.luau dependencies")
local lockedPackages = record(lock.packages, "pkg.lock.luau packages")
local config = record(load ".config.luau", ".config.luau")
local aliases = record(record(config.luau, ".config.luau luau").aliases, ".config.luau aliases")

local findings: { string } = {}
local function fail(message: string)
	table.insert(findings, message)
end

for name, value in declared do
	local spec = record(value, "pkg.luau dependency " .. name)
	local key = lockedKeys[name]
	if type(key) ~= "string" then
		fail(("pkg.lock.luau does not lock %s; run lute pkg install --vendor"):format(name))
		continue
	end
	local locked = lockedPackages[key]
	if
		type(locked) ~= "table"
		or text(record(locked, key).rev, key .. " rev") ~= text(spec.rev, name .. " rev")
		or text(record(locked, key).source, key .. " source") ~= text(spec.source, name .. " source")
	then
		fail(("pkg.lock.luau entry %s does not match pkg.luau; run lute pkg install --vendor"):format(key))
	end
	local expected = "./.lpm/" .. key
	if aliases[name] ~= expected then
		fail((".config.luau alias %s must be %s"):format(name, expected))
	end
	if not fs.exists(".lpm/" .. key .. "/LICENSE") then
		fail((".lpm/%s is absent or has no LICENSE; run lute pkg install --vendor"):format(key))
	end
end
for name in lockedKeys do
	if declared[name] == nil then
		fail(("pkg.lock.luau locks %s, which pkg.luau does not declare"):format(name))
	end
end
if fs.exists ".lpm" then
	for _, entry in fs.listDirectory ".lpm" do
		local name = string.match(entry.name, "^([^@]+)@")
		if name == nil or lockedKeys[name] ~= entry.name then
			fail((".lpm/%s is not a locked package; run lute pkg install --vendor"):format(entry.name))
		end
	end
end

Finish("check-packages", findings)
