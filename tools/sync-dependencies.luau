--!strict

local fs = require "@std/fs"
local process = require "@lute/process"

type Dependency = {
	read name: string,
	read repository: string,
	read commit: string,
	read tree: string,
	read rights: string,
	read notices: { read [number]: string },
	read surfaces: { read [number]: string },
}

type Lock = {
	read schemaVersion: number,
	read dependencies: { read [number]: Dependency },
}

local CACHE_ROOT = ".lute/dependencies"
local LOCAL_SOURCE_ROOT = "BENCHMARK_DEPENDENCY_SOURCE_ROOT"
local REVIEWED_RIGHTS: { [string]: true } = {
	MIT = true,
}
local lock: Lock = require "../dependencies.lock"

local function sparseCheckout(dependency: Dependency, path: string): string?
	local sparse = { "git", "-C", path, "sparse-checkout", "set", "--no-cone" }
	for _, surface in dependency.surfaces do
		table.insert(sparse, "/" .. surface)
	end
	for _, notice in dependency.notices do
		table.insert(sparse, "/" .. notice)
	end
	if not process.run(sparse).ok then
		return "benchmark sparse checkout could not be configured"
	end
	return nil
end

local function trim(value: string): string
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function git(path: string, arguments: { string }): (boolean, string)
	local argv = { "git", "-C", path }
	for _, argument in arguments do
		table.insert(argv, argument)
	end
	local result = process.run(argv)
	return result.ok, trim(result.stdout)
end

local function validateDefinition(dependency: Dependency): string?
	if string.match(dependency.name, "^[a-z][a-z0-9%-]*$") == nil then
		return "name must match ^[a-z][a-z0-9%-]*$"
	end
	if string.match(dependency.repository, "^https://github%.com/[%w_%-]+/[%w_%.%-]+%.git$") == nil then
		return "repository must name an HTTPS GitHub repository without credentials"
	end
	if
		string.match(
			dependency.commit,
			"^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$"
		) == nil
	then
		return "commit must be a full 40-character object id"
	end
	if
		string.match(
			dependency.tree,
			"^%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x%x$"
		) == nil
	then
		return "tree must be a full 40-character object id"
	end
	if REVIEWED_RIGHTS[dependency.rights] ~= true then
		return "rights must name a reviewed license status"
	end
	if #dependency.surfaces == 0 then
		return "surfaces must name at least one measured root"
	end
	local seenRoots: { [string]: boolean } = {}
	for _, root in dependency.surfaces do
		if root == "" or string.sub(root, 1, 1) == "/" or string.find(root, "..", 1, true) ~= nil then
			return "surface roots must be repository-relative paths without traversal"
		end
		if seenRoots[root] then
			return "a measured root may be listed only once"
		end
		seenRoots[root] = true
	end
	if #dependency.notices == 0 then
		return "notices must name the license notice of the library"
	end
	for _, notice in dependency.notices do
		if notice == "" or notice:sub(1, 1) == "/" or notice:find("..", 1, true) then
			return "notice paths must be repository-relative without traversal"
		end
	end
	return nil
end

local function findings(dependency: Dependency, path: string): { string }
	local out: { string } = {}
	local function check(label: string, arguments: { string }, expected: string)
		local ok, actual = git(path, arguments)
		if not ok then
			table.insert(out, label .. " could not be read")
		elseif actual ~= expected then
			table.insert(out, ("%s is %s, expected %s"):format(label, actual, expected))
		end
	end
	check("commit", { "rev-parse", "HEAD" }, dependency.commit)
	check("tree", { "rev-parse", "HEAD^{tree}" }, dependency.tree)
	check("repository", { "config", "--local", "--get", "remote.origin.url" }, dependency.repository)
	local statusOk, status = git(path, { "status", "--porcelain" })
	if not statusOk then
		table.insert(out, "working-tree state could not be read")
	elseif status ~= "" then
		table.insert(out, "cached checkout is dirty")
	end
	for _, root in dependency.surfaces do
		if not fs.exists(path .. "/" .. root) then
			table.insert(out, root .. " is absent")
		end
	end
	for _, notice in dependency.notices do
		if not fs.exists(path .. "/" .. notice) then
			table.insert(out, notice .. " is absent")
		end
	end
	return out
end

local function configuredLocalSource(dependency: Dependency): (string?, string?)
	local root = process.env[LOCAL_SOURCE_ROOT]
	if root == nil then
		return nil, nil
	end
	if root == "" then
		return nil, LOCAL_SOURCE_ROOT .. " is empty"
	end
	local source = root .. "/" .. dependency.name
	if not fs.exists(source) then
		return nil, ("configured local source %s is absent"):format(source)
	end
	local problems = findings(dependency, source)
	if #problems > 0 then
		return nil,
			("configured local source %s does not match the lock: %s"):format(source, table.concat(problems, "; "))
	end
	return source, nil
end

local function clone(dependency: Dependency, destination: string): string?
	local configuredSource, sourceProblem = configuredLocalSource(dependency)
	if sourceProblem ~= nil then
		return sourceProblem
	end
	local source: string = configuredSource or dependency.repository
	local cloned = process.run { "git", "clone", "--quiet", "--no-checkout", "--filter=blob:none", source, destination }
	if not cloned.ok then
		return "clone failed; check repository availability and access"
	end
	local sparseProblem = sparseCheckout(dependency, destination)
	if sparseProblem then
		return sparseProblem
	end
	local checkedOut = process.run {
		"git",
		"-C",
		destination,
		"checkout",
		"--quiet",
		"--detach",
		dependency.commit,
	}
	if not checkedOut.ok then
		return "the locked commit is not reachable from the repository"
	end
	local canonical = process.run {
		"git",
		"-C",
		destination,
		"remote",
		"set-url",
		"origin",
		dependency.repository,
	}
	if not canonical.ok then
		return "the cache remote could not be canonicalized"
	end
	local problems = findings(dependency, destination)
	if #problems > 0 then
		return table.concat(problems, "; ")
	end
	return nil
end

local function sync(dependency: Dependency, checkOnly: boolean): string?
	local target = CACHE_ROOT .. "/" .. dependency.name
	if fs.exists(target) and #findings(dependency, target) == 0 then
		if not checkOnly then
			return sparseCheckout(dependency, target)
		end
		return nil
	end
	if checkOnly then
		return "cache is absent or does not match the lock; run lute run tools/sync-dependencies.luau"
	end

	fs.createDirectory(CACHE_ROOT, { makeParents = true })
	local temporary = CACHE_ROOT .. "/." .. dependency.name .. "-" .. tostring(process.pid())
	if fs.exists(temporary) then
		fs.removeDirectory(temporary, { recursive = true })
	end
	local problem = clone(dependency, temporary)
	if problem ~= nil then
		if fs.exists(temporary) then
			fs.removeDirectory(temporary, { recursive = true })
		end
		return problem
	end

	if fs.exists(target) then
		if #findings(dependency, target) == 0 then
			fs.removeDirectory(temporary, { recursive = true })
			return nil
		end
		fs.removeDirectory(target, { recursive = true })
	end
	fs.move(temporary, target)
	return nil
end

local function validateRepositoryShape(seen: { [string]: boolean }): string?
	if fs.exists "vendor" then
		return "vendor/ is forbidden; measured libraries belong in the ignored dependency cache"
	end
	if not fs.exists(CACHE_ROOT) then
		return nil
	end
	for _, entry in fs.listDirectory(CACHE_ROOT) do
		if string.sub(entry.name, 1, 1) ~= "." and not seen[entry.name] then
			return CACHE_ROOT .. "/" .. entry.name .. " is not declared by dependencies.lock.luau"
		end
	end
	return nil
end

local function main(): number
	local checkOnly = false
	for index = 2, #process.args do
		if process.args[index] == "--check" then
			checkOnly = true
		else
			print(("sync-dependencies: unrecognized argument %q"):format(process.args[index]))
			return 1
		end
	end
	if lock.schemaVersion ~= 2 then
		print "sync-dependencies: dependencies.lock.luau must use schema version 2"
		return 1
	end
	local seen: { [string]: boolean } = {}
	if #lock.dependencies == 0 then
		print "sync-dependencies: the lock contains no dependency"
		return 1
	end
	for _, dependency in lock.dependencies do
		if seen[dependency.name] then
			print("sync-dependencies: duplicate dependency " .. dependency.name)
			return 1
		end
		seen[dependency.name] = true
		local invalid = validateDefinition(dependency)
		if invalid ~= nil then
			print(("sync-dependencies: %s: %s"):format(dependency.name, invalid))
			return 1
		end
		local problem = sync(dependency, checkOnly)
		if problem ~= nil then
			print(("sync-dependencies: %s: %s"):format(dependency.name, problem))
			return 1
		end
		print(("sync-dependencies: %s at %s"):format(dependency.name, dependency.commit))
	end
	local shapeProblem = validateRepositoryShape(seen)
	if shapeProblem ~= nil then
		print("sync-dependencies: " .. shapeProblem)
		return 1
	end
	return 0
end

local code = main()
if code ~= 0 then
	process.exit(code)
end
return nil
