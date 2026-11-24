--!strict

local Test = require "../harness"
local fs = require "@std/fs"
local process = require "@lute/process"

local describe, it, expect = Test.describe, Test.it, Test.expect

local STAGE = "build/dependency-source-spec"
local NAME = "fixture"
local REPOSITORY = "https://github.com/example/fixture.git"

local function trim(value: string): string
	return string.match(value, "^%s*(.-)%s*$") or ""
end

local function isolatedEnvironment(): { [string]: string }
	local out: { [string]: string } = {}
	for name, value in process.env do
		if
			name ~= "BENCHMARK_DEPENDENCY_SOURCE_ROOT"
			and name ~= "GIT_CONFIG_COUNT"
			and string.match(name, "^GIT_CONFIG_KEY_%d+$") == nil
			and string.match(name, "^GIT_CONFIG_VALUE_%d+$") == nil
		then
			out[name] = value
		end
	end
	out.GIT_CONFIG_COUNT = "0"
	return out
end

local function run(argv: { string }, cwd: string, environment: { [string]: string }?): (boolean, string)
	local result = process.run(argv, { cwd = cwd, env = environment })
	return result.ok, result.stdout .. result.stderr
end

local function gitWithEnvironment(path: string, environment: { [string]: string }, ...: string): string
	local argv = { "git", "-C", path }
	for index = 1, select("#", ...) do
		table.insert(argv, (select(index, ...)))
	end
	local ok, output = run(argv, process.cwd(), environment)
	if not ok then
		error("dependency source fixture: git failed: " .. output, 0)
	end
	return trim(output)
end

local function git(path: string, ...: string): string
	return gitWithEnvironment(path, isolatedEnvironment(), ...)
end

local function writeLock(commit: string, tree: string, notices: string?)
	local source = ([=[--!strict

return {
	schemaVersion = 2,
	dependencies = {
		{
			name = %q,
			repository = %q,
			commit = %q,
			tree = %q,
			rights = "MIT",
			notices = { %s },
			surfaces = { "src" },
		},
	},
}
]=]):format(NAME, REPOSITORY, commit, tree, notices or '"LICENSE"')
	fs.writeStringToFile(STAGE .. "/harness/dependencies.lock.luau", source)
end

local function fixture(): (string, string, string)
	process.run { "rm", "-rf", STAGE }
	fs.createDirectory(STAGE .. "/harness/tools", { makeParents = true })
	fs.createDirectory(STAGE .. "/sources/" .. NAME .. "/src", { makeParents = true })
	fs.writeStringToFile(
		STAGE .. "/harness/tools/sync-dependencies.luau",
		fs.readFileToString "tools/sync-dependencies.luau"
	)
	local source = STAGE .. "/sources/" .. NAME
	fs.writeStringToFile(source .. "/src/init.luau", "return table.freeze {}\n")
	fs.writeStringToFile(source .. "/LICENSE", "MIT fixture notice\n")
	local initialized = process.run { "git", "init", "--quiet", source }
	if not initialized.ok then
		error("dependency source fixture: git init failed", 0)
	end
	git(source, "config", "user.name", "Fixture")
	git(source, "config", "user.email", "fixture@users.noreply.github.com")
	git(source, "add", "src/init.luau", "LICENSE")
	git(source, "commit", "--quiet", "-m", "Fixture")
	git(source, "remote", "add", "origin", REPOSITORY)

	local commit = git(source, "rev-parse", "HEAD")
	local tree = git(source, "rev-parse", "HEAD^{tree}")
	writeLock(commit, tree)
	return source, commit, tree
end

local function environment(sourceRoot: string): { [string]: string }
	local out = isolatedEnvironment()
	out.BENCHMARK_DEPENDENCY_SOURCE_ROOT = process.cwd() .. "/" .. sourceRoot
	out.GIT_ALLOW_PROTOCOL = "file"
	return out
end

local function sync(sourceRoot: string): (boolean, string)
	return run(
		{ "lute", "run", "tools/sync-dependencies.luau" },
		process.cwd() .. "/" .. STAGE .. "/harness",
		environment(sourceRoot)
	)
end

local function syncThroughRewrite(source: string): (boolean, string, { [string]: string })
	local absoluteSource = process.cwd() .. "/" .. source
	local out = isolatedEnvironment()
	out.GIT_ALLOW_PROTOCOL = "file"
	out.GIT_CONFIG_COUNT = "1"
	out.GIT_CONFIG_KEY_0 = "url.file://" .. absoluteSource .. ".insteadOf"
	out.GIT_CONFIG_VALUE_0 = REPOSITORY
	local ok, output = run(
		{ "env", "-u", "BENCHMARK_DEPENDENCY_SOURCE_ROOT", "lute", "run", "tools/sync-dependencies.luau" },
		process.cwd() .. "/" .. STAGE .. "/harness",
		out
	)
	return ok, output, out
end

describe("configured dependency source", function()
	Test.afterEach(function()
		process.run { "rm", "-rf", STAGE }
	end)

	it("clones an exact verified local checkout without reaching its remote", function()
		local _, commit, tree = fixture()
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(true)
		expect(output):toContain(NAME .. " at " .. commit)

		local cached = STAGE .. "/harness/.lute/dependencies/" .. NAME
		expect(git(cached, "rev-parse", "HEAD")):toBe(commit)
		expect(git(cached, "rev-parse", "HEAD^{tree}")):toBe(tree)
		expect(git(cached, "remote", "get-url", "origin")):toBe(REPOSITORY)
		expect(git(cached, "status", "--porcelain")):toBe ""
	end)

	it("keeps canonical repository identity while Git rewrites only the clone transport", function()
		local source, commit, tree = fixture()
		local ok, output, rewriteEnvironment = syncThroughRewrite(source)
		if not ok then
			error(output, 0)
		end
		expect(ok):toBe(true)
		expect(output):toContain(NAME .. " at " .. commit)

		local cached = STAGE .. "/harness/.lute/dependencies/" .. NAME
		expect(git(cached, "rev-parse", "HEAD")):toBe(commit)
		expect(git(cached, "rev-parse", "HEAD^{tree}")):toBe(tree)
		expect(git(cached, "config", "--local", "--get", "remote.origin.url")):toBe(REPOSITORY)
		expect(gitWithEnvironment(cached, rewriteEnvironment, "remote", "get-url", "origin")):toBe(
			"file://" .. process.cwd() .. "/" .. source
		)
	end)

	it("fails closed when the configured source is absent", function()
		fixture()
		fs.createDirectory(STAGE .. "/empty", { makeParents = true })
		local ok, output = sync(STAGE .. "/empty")
		expect(ok):toBe(false)
		expect(output):toContain "configured local source"
		expect(output):toContain "is absent"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/" .. NAME)):toBe(false)
	end)

	it("fails closed when the configured source is dirty", function()
		local source = fixture()
		fs.writeStringToFile(source .. "/untracked.luau", "return nil\n")
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "cached checkout is dirty"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/" .. NAME)):toBe(false)
	end)

	it("fails closed when the configured source has the wrong repository identity", function()
		local source = fixture()
		git(source, "remote", "set-url", "origin", "https://github.com/example/not-fixture.git")
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "repository is"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/" .. NAME)):toBe(false)
	end)

	it("fails closed when the configured source has the wrong tree", function()
		local _, commit = fixture()
		writeLock(commit, string.rep("0", 40))
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "tree is"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/" .. NAME)):toBe(false)
	end)

	it("sparsely checks out only the measured roots and license notices", function()
		local source = fixture()
		fs.writeStringToFile(source .. "/outside.txt", "not measured\n")
		git(source, "add", "outside.txt")
		git(source, "commit", "--quiet", "-m", "Outside fixture")
		writeLock(git(source, "rev-parse", "HEAD"), git(source, "rev-parse", "HEAD^{tree}"))
		local ok, output = sync(STAGE .. "/sources")
		if not ok then
			error(output, 0)
		end
		local cached = STAGE .. "/harness/.lute/dependencies/" .. NAME
		expect(fs.exists(cached .. "/src/init.luau")):toBe(true)
		expect(fs.exists(cached .. "/LICENSE")):toBe(true)
		expect(fs.exists(cached .. "/outside.txt")):toBe(false)
		expect(git(cached, "status", "--porcelain")):toBe ""
	end)

	it("rejects a notice that the locked commit does not hold", function()
		local _, commit, tree = fixture()
		writeLock(commit, tree, '"LICENSE", "NOTICE"')
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "NOTICE is absent"
	end)

	it("rejects a library with no license notice", function()
		local _, commit, tree = fixture()
		writeLock(commit, tree, "")
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "notices must name the license notice"
	end)
end)

return nil
