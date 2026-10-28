--!strict

local Test = require "../harness"
local fs = require "@std/fs"
local process = require "@lute/process"

local describe, it, expect = Test.describe, Test.it, Test.expect

local STAGE = "build/dependency-source-spec"
local REPOSITORY = "https://github.com/voidmeld/verify.git"

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

local function writeLock(commit: string, tree: string)
	local source = ([=[--!strict

return {
	schemaVersion = 1,
	dependencies = {
		{
			name = "verify",
			repository = %q,
			commit = %q,
			tree = %q,
			rights = "MIT",
			surfaces = { { root = "src", role = "verification" } },
		},
	},
}
]=]):format(REPOSITORY, commit, tree)
	fs.writeStringToFile(STAGE .. "/harness/dependencies.lock.luau", source)
end

local function fixture(): (string, string, string)
	process.run { "rm", "-rf", STAGE }
	fs.createDirectory(STAGE .. "/harness/tools", { makeParents = true })
	fs.createDirectory(STAGE .. "/sources/verify/src", { makeParents = true })
	fs.writeStringToFile(
		STAGE .. "/harness/tools/sync-dependencies.luau",
		fs.readFileToString "tools/sync-dependencies.luau"
	)
	fs.writeStringToFile(STAGE .. "/sources/verify/src/init.luau", "return table.freeze {}\n")

	local source = STAGE .. "/sources/verify"
	local initialized = process.run { "git", "init", "--quiet", source }
	if not initialized.ok then
		error("dependency source fixture: git init failed", 0)
	end
	git(source, "config", "user.name", "voidmeld")
	git(source, "config", "user.email", "158495725+voidmeld@users.noreply.github.com")
	git(source, "add", "src/init.luau")
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
		expect(output):toContain("verify at " .. commit)

		local cached = STAGE .. "/harness/.lute/dependencies/verify"
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
		expect(output):toContain("verify at " .. commit)

		local cached = STAGE .. "/harness/.lute/dependencies/verify"
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
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/verify")):toBe(false)
	end)

	it("fails closed when the configured source is dirty", function()
		local source = fixture()
		fs.writeStringToFile(source .. "/untracked.luau", "return nil\n")
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "cached checkout is dirty"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/verify")):toBe(false)
	end)

	it("fails closed when the configured source has the wrong repository identity", function()
		local source = fixture()
		git(source, "remote", "set-url", "origin", "https://github.com/voidmeld/not-verify.git")
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "repository is"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/verify")):toBe(false)
	end)

	it("fails closed when the configured source has the wrong tree", function()
		local _, commit = fixture()
		writeLock(commit, string.rep("0", 40))
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "does not match the lock"
		expect(output):toContain "tree is"
		expect(fs.exists(STAGE .. "/harness/.lute/dependencies/verify")):toBe(false)
	end)

	it("sparsely checks out only the consumed files and notices of a benchmark dependency", function()
		local source = fixture()
		fs.writeStringToFile(source .. "/outside.txt", "not consumed\n")
		fs.writeStringToFile(source .. "/LICENSE", string.rep("MIT fixture notice\n", 3))
		git(source, "add", "outside.txt", "LICENSE")
		git(source, "commit", "--quiet", "-m", "Benchmark fixture")
		writeLock(git(source, "rev-parse", "HEAD"), git(source, "rev-parse", "HEAD^{tree}"))
		local lockPath = STAGE .. "/harness/dependencies.lock.luau"
		local lock = fs.readFileToString(lockPath):gsub('role = "verification"', 'role = "benchmark"')
		lock = lock:gsub('rights = "MIT",', 'rights = "MIT",\n\t\t\tnotices = { "LICENSE" },')
		fs.writeStringToFile(lockPath, lock)
		local ok, output = sync(STAGE .. "/sources")
		if not ok then
			error(output, 0)
		end
		local cached = STAGE .. "/harness/.lute/dependencies/verify"
		expect(fs.exists(cached .. "/src/init.luau")):toBe(true)
		expect(fs.exists(cached .. "/LICENSE")):toBe(true)
		expect(fs.exists(cached .. "/outside.txt")):toBe(false)
		expect(git(cached, "status", "--porcelain")):toBe ""
	end)

	it("accepts an external HTTPS benchmark repository and rejects missing notices", function()
		local source = fixture()
		local external = "https://github.com/example/benchmark.git"
		git(source, "remote", "set-url", "origin", external)
		local lockPath = STAGE .. "/harness/dependencies.lock.luau"
		local lock = fs.readFileToString(lockPath):gsub(REPOSITORY:gsub("([^%w])", "%%%1"), external)
		lock = lock:gsub('rights = "MIT",', 'rights = "MIT",\n\t\t\tnotices = { "LICENSE" },')
		fs.writeStringToFile(lockPath, lock)
		local ok, output = sync(STAGE .. "/sources")
		expect(ok):toBe(false)
		expect(output):toContain "LICENSE is absent"
	end)
end)

return nil
