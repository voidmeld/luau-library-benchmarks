--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Gate = require "../../.lute/dependencies/verify/src/gate"
local Lute = require "../../.lute/dependencies/verify/src/lute"
local Verify = require "../../.lute/dependencies/verify/src/core"
local Frameworks = require "./harness/frameworks"
local Upstream = require "./harness/upstream"
local Report = require "./report"
local Suites = require "./suites"
local Workloads = require "./workloads"
local Lock = require "../../dependencies.lock"

local function main(): number
	local out = "build/scene-composition-comparison"
	local filter: string? = nil
	local verify = false
	local mode: Upstream.Mode = "like-for-like"
	local index = 2
	while index <= #process.args do
		local option = process.args[index]
		if option == "--verify" then
			verify = true
		elseif option == "--mode" then
			index += 1
			local value = process.args[index]
			if value == "as-shipped" or value == "like-for-like" then
				mode = value
			else
				error("--mode must be as-shipped or like-for-like", 0)
			end
		elseif option == "--out" or option == "--filter" then
			index += 1
			local value = assert(process.args[index], "missing value for " .. option)
			if option == "--out" then
				out = value
			else
				filter = value
			end
		else
			error(
				"usage: lute run comparisons/scene-composition/compare.luau [--verify] [--mode like-for-like|as-shipped] [--filter text] [--out directory]",
				0
			)
		end
		index += 1
	end
	local synced = process.run { "lute", "run", "tools/sync-dependencies.luau", "--check" }
	assert(synced.ok, synced.stdout .. synced.stderr .. "\nRun lute run tools/sync-dependencies.luau")
	Upstream.setMode(mode)
	local prefix = if mode == "like-for-like" then "like-for-like/" else ""
	local frameworks = Frameworks.available()
	local entries = Suites.entries { filter = filter }
	assert(#entries > 0, "no comparison workload matches")
	local selected: { Workloads.Workload } = {}
	for _, workload in Workloads.all do
		if filter == nil or workload.id:find(filter, 1, true) then
			table.insert(selected, workload)
		end
	end
	local producers: { Gate.ProducerDraft } = {}
	for position, entry in entries do
		local parity: Gate.ProducerDraft = {
			id = "parity-" .. entry.id,
			kind = "tests",
			worker = "comparisons/scene-composition/worker.luau",
			locators = { prefix .. "parity:" .. entry.id },
			tier = "parity",
			why = "observable trees, intermediate states, retained identity and teardown agree",
		}
		table.insert(producers, parity)
		if verify then
			continue
		end
		Benchmark.checkCollection(entry.collection)
		local timing: Gate.ProducerDraft = {
			id = "timing-" .. entry.id,
			kind = "tests",
			worker = "comparisons/scene-composition/worker.luau",
			locators = { prefix .. "timing:" .. entry.id .. ":" .. tostring(position - 1) },
			exclusive = true,
			after = { "parity-" .. entry.id },
			tier = "timing",
			why = "rotated framework samples with the common CPU reference",
		}
		table.insert(producers, timing)
		for _, framework in frameworks do
			local supported = false
			for _, workload in selected do
				if workload.id == entry.id then
					supported = workload.cases[framework.name] ~= nil
					break
				end
			end
			if not supported then
				continue
			end
			local memory: Gate.ProducerDraft = {
				id = "memory-" .. entry.id .. "-" .. framework.name,
				kind = "tests",
				worker = "comparisons/scene-composition/worker.luau",
				locators = { prefix .. "memory:" .. entry.id .. ":" .. framework.name },
				exclusive = true,
				after = { "parity-" .. entry.id },
				tier = "memory",
				why = "three mounted and teardown heap lifecycles in an isolated worker",
			}
			table.insert(producers, memory)
		end
	end
	fs.createDirectory(out, { makeParents = true })
	local function git(arguments: { string }): string
		local argv = { "git" }
		for _, argument in arguments do
			table.insert(argv, argument)
		end
		local result = process.run(argv)
		assert(result.ok, result.stderr)
		return (result.stdout:gsub("%s+$", ""))
	end
	local commit = git { "rev-parse", "HEAD" }
	fs.writeStringToFile(out .. "/context.json", Lute.encode {
		commit = commit,
		tree = git { "rev-parse", "HEAD^{tree}" },
		status = git { "status", "--porcelain" },
		environment = Suites.identity(),
		command = process.args,
		concurrency = "exclusive timing and memory workers",
		mode = mode,
		runtime = process.run({ "lute", "--version" }).stdout,
		dependencies = Lock,
	} .. "\n")
	local outcome = Lute.gate.run(
		Gate.define { id = "scene-composition-comparison", producers = producers },
		{ directory = out .. "/gate" }
	)
	print(Verify.format(outcome.execution.report))
	fs.writeStringToFile(out .. "/report.json", Lute.encode(outcome.execution.report) .. "\n")
	local complete = true
	if not verify then
		local stored = Report.store(commit, outcome.execution.report)
		fs.writeStringToFile(out .. "/stored.json", Lute.encode(stored) .. "\n")
		local tableMarkdown, hasEvidence = Report.markdown(stored, selected, frameworks)
		local verdict = outcome.acceptance.verdict
		local status = if verdict == "release"
			then "All parity and measurement checks passed."
			else `Some checks did not pass (Verify verdict \`{verdict}\`).`
		local markdown = "Comparison mode: **"
			.. mode
			.. "**. "
			.. status
			.. " Only passed measurements appear below. Rejected calibration and other failures remain in the raw report.\n\n"
			.. tableMarkdown
			.. Report.fallbacks(outcome.execution.report)
		complete = hasEvidence
		fs.writeStringToFile(out .. "/comparison.md", markdown)
		local summary = process.env.GITHUB_STEP_SUMMARY
		if summary then
			local previous = if fs.exists(summary) then fs.readFileToString(summary) else ""
			fs.writeStringToFile(summary, previous .. markdown)
		end
	end
	print(Report.fallbacks(outcome.execution.report))
	print("comparison: " .. outcome.acceptance.verdict .. "; evidence in " .. out)
	return if outcome.acceptance.releasable and complete then 0 else 1
end

local code = main()
if code ~= 0 then
	process.exit(code)
end
return nil
