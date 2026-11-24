--!strict

local Lock = require "../dependencies.lock"

local function record(value: unknown, label: string): { [string]: unknown }
	if type(value) ~= "table" then
		error(label .. " must be a table", 0)
	end
	local result: { [string]: unknown } = {}
	for key, entry in value do
		if type(key) == "string" then
			result[key] = entry
		end
	end
	return result
end

local function text(value: unknown, label: string): string
	if type(value) ~= "string" then
		error(label .. " must be a string", 0)
	end
	return value
end

local PackageLock = record(require "../pkg.lock", "pkg.lock.luau")
local lockedKeys = record(PackageLock.dependencies, "pkg.lock.luau dependencies")
local lockedPackages = record(PackageLock.packages, "pkg.lock.luau packages")

export type Source = {
	read name: string,
	read version: string,
	read repository: string,
	read commit: string,
	read tree: string?,
	read rights: string,
	read notices: { read [number]: string },
	read surfaces: { read [number]: string },
	read root: string,
	read package: boolean,
}

type Package = {
	read name: string,
	read notices: { read [number]: string },
	read surfaces: { read [number]: string },
}

local PACKAGES: { Package } = {
	{ name = "verify", notices = { "LICENSE" }, surfaces = {} },
	{ name = "compose", notices = { "LICENSE" }, surfaces = { "src/core", "src/roblox" } },
	{ name = "facet", notices = { "LICENSE", "THIRD_PARTY_NOTICES.md" }, surfaces = { "src" } },
}

local function version(rev: string): string
	if string.match(rev, "^%x+$") ~= nil and #rev == 40 then
		return string.sub(rev, 1, 7)
	end
	return rev
end

local all: { Source } = {}
local byName: { [string]: Source } = {}

local function add(source: Source)
	assert(byName[source.name] == nil, "a source is declared twice: " .. source.name)
	byName[source.name] = source
	table.insert(all, source)
end

for _, package in PACKAGES do
	local key = text(lockedKeys[package.name], "the pkg.lock.luau key of " .. package.name)
	local locked = record(lockedPackages[key], "pkg.lock.luau package " .. key)
	local rev = text(locked.rev, key .. " rev")
	local repository = text(locked.source, key .. " source")
	add {
		name = package.name,
		version = version(rev),
		repository = repository,
		commit = rev,
		tree = nil,
		rights = "MIT",
		notices = package.notices,
		surfaces = package.surfaces,
		root = ".lpm/" .. key,
		package = true,
	}
end

for _, dependency in Lock.dependencies do
	add {
		name = dependency.name,
		version = dependency.version,
		repository = dependency.repository,
		commit = dependency.commit,
		tree = dependency.tree,
		rights = dependency.rights,
		notices = dependency.notices,
		surfaces = dependency.surfaces,
		root = ".lute/dependencies/" .. dependency.name,
		package = false,
	}
end

local measured: { Source } = {}
for _, source in all do
	if #source.surfaces > 0 then
		table.insert(measured, source)
	end
end

local function find(name: string): Source
	local source = byName[name]
	if source == nil then
		error("benchmark source is not locked: " .. name, 0)
	end
	return source
end

return table.freeze {
	record = record,
	text = text,
	all = table.freeze(all),
	measured = table.freeze(measured),
	find = find,
	root = function(name: string): string
		return find(name).root
	end,
}
