--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local system = require "@lute/system"

local DEPENDENCY_CACHE = ".lute/dependencies/verify"
local DIRECTORY = ".lute/tmp/benchmarks-gate"

local SOURCE_TREES = {
	"dependencies.lock.luau",
	"lint.config.luau",
	"comparisons",
	"tests",
	"tools",
}

local TYPED_TREES = SOURCE_TREES

local USAGE =
	"usage: lute run tools/gate.luau [--only producer]... [--tier name]... [--case id]... [--file spec]... [--name text] [--rerun] [--explain id] [--list]"
local flags: { string } = {}
for position = 2, #process.args do
	table.insert(flags, process.args[position])
end

for _, target in SOURCE_TREES do
	if not fs.exists(target) then
		print(("gate: requires missing target %s"):format(target))
		process.exit(1)
	end
end

local complete = #flags == 0
if complete then
	local status = process.run { "git", "status", "--porcelain" }
	if not status.ok or string.match(status.stdout, "%S") ~= nil then
		print "gate: full candidate requires a clean committed HEAD; use focused checks while editing, then commit locally before the full gate and push"
		process.exit(1)
	end
end
if not fs.exists(DEPENDENCY_CACHE) and not process.run({ "lute", "run", "tools/sync-dependencies.luau" }).ok then
	print "gate: the dependency cache could not be created; run lute run tools/sync-dependencies.luau"
	process.exit(1)
end

local Gate = require "../.lute/dependencies/verify/src/gate"
local Lute = require "../.lute/dependencies/verify/src/lute"
local resources = require "./lib/gate-resources"
local Manifest = require "../tests/manifest"

local specs = table.clone(Manifest)
assert(#specs > 0, "the test manifest names no specification")
local processLimit = math.max(1, system.threadCount())

local function check(id: string, why: string, argv: { string }, targets: { string }?, tier: string?): Gate.ProducerDraft
	local full = table.clone(argv)
	if targets ~= nil then
		table.move(targets, 1, #targets, #full + 1, full)
	end
	return { id = id, kind = "command", argv = full, why = why, tier = tier or "fast" }
end

local function script(id: string, why: string, path: string, ...: string): Gate.ProducerDraft
	return check(id, why, { "lute", "run", path, ... })
end

local function slow(producer: Gate.ProducerDraft): Gate.ProducerDraft
	producer.deadlineSeconds = 1800
	producer.exclusive = true
	return producer
end

local ANALYZE = { "luau-lsp", "analyze", "--platform=standard", "--base-luaurc=.luaurc" }
local SOLVER_V2 = table.clone(ANALYZE)
table.insert(SOLVER_V2, 3, "--flag:LuauSolverV2=true")
for _, argv in { ANALYZE, SOLVER_V2 } do
	table.insert(argv, "--ignore=**/.lute/**")
	table.insert(argv, "--ignore=**/build/**")
end

local COMPARE = "comparisons/roblox-ui/compare.luau"

local draft: Gate.Draft = {
	id = "benchmarks-gate",
	producers = {
		script(
			"dependencies",
			"every pinned library and tool dependency resolves at its exact committed identity",
			"tools/sync-dependencies.luau"
		),
		check("format", "source is formatted exactly as stylua.toml specifies", { "stylua", "--check" }, SOURCE_TREES),
		script("type-policy", "strict maintained Luau has no explicit any", "tools/check-no-any.luau"),
		script(
			"spec-style",
			"specifications declare compact describe, it and expect bindings once",
			"tools/check-spec-style.luau"
		),
		script(
			"comments",
			"source contains only permitted tool directives, never explanatory comments",
			"tools/check-code-comments.luau"
		),
		check(
			"lint",
			"no lint findings under the policy in lint.config.luau",
			{ "lute", "lint", "--verbose", "-c", "lint.config.luau" },
			SOURCE_TREES
		),
		check(
			"types",
			"every harness, adapter, test, tool and configuration type-checks strictly under the old type solver",
			ANALYZE,
			TYPED_TREES
		),
		check(
			"types-solver-v2",
			"the same trees type-check strictly under the new type solver",
			SOLVER_V2,
			TYPED_TREES
		),
		script(
			"test-manifest",
			"the committed run manifest is the corpus on disk, so what runs is a reviewed artefact",
			"tools/check-test-manifest.luau"
		),
		{
			id = "tests",
			kind = "tests",
			worker = "tests/worker.luau",
			locators = specs,
			isolate = true,
			workers = resources(processLimit, system.totalMemory(), #specs),
			sourceDeadlineSeconds = 600,
			tier = "fast",
			why = "harness, loader, report, cost-model and dependency tooling specifications pass",
			deadlineSeconds = 1800,
		},
		slow(
			script(
				"parity",
				"every lane builds the same trees, intermediate states, retained identity and teardown in as-shipped mode",
				COMPARE,
				"--verify",
				"--out",
				"build/gate/parity"
			)
		),
		slow(
			script(
				"parity-like-for-like",
				"every lane passes the same parity checks when all lanes load through the shared loader",
				COMPARE,
				"--verify",
				"--mode",
				"like-for-like",
				"--out",
				"build/gate/parity-like-for-like"
			)
		),
		check("verify-check", "every specification satisfies the Verify consumer rules", {
			"lute",
			"run",
			".lute/dependencies/verify/tools/verify-check.luau",
			"--ruleset",
			"generic",
			"tests",
		}),
		script(
			"provenance",
			"no foreign source tree, no dependency descriptor, and the licence inventory is complete",
			"tools/check-provenance.luau"
		),
		script(
			"leakage",
			"no product asset or place identifier appears in this repository",
			"tools/check-leakage.luau"
		),
		{
			id = "clean-clone",
			exclusive = true,
			kind = "command",
			argv = { "lute", "run", "tools/check-clean-clone.luau" },
			why = "a fresh clone of HEAD syncs, checks and passes parity with no working-tree state",
			tier = "slow",
			deadlineSeconds = 1800,
		},
	},
	policy = {
		concurrency = math.min(3, processLimit),
		commandDeadlineSeconds = 900,
		deadlineSeconds = 3600,
	},
}

local exitCode = Lute.gate.cli(draft, flags, {
	usage = USAGE,
	options = {
		directory = DIRECTORY,
		processLimit = processLimit,
		capabilities = {},
	},
})
if exitCode ~= 0 then
	process.exit(exitCode)
end
