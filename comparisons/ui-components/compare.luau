--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local system = require "@lute/system"
local Lute = require "../../.lute/dependencies/verify/src/lute"
local Lock = require "../../dependencies.lock"
local Workloads = require "./workloads"
local Parity = require "./parity"
local Measure = require "./measure"
local Report = require "./report"
local Headless = require "./headless"

local USAGE = "usage: lute run comparisons/ui-components/compare.luau [--verify] [--filter text] [--out directory]"

local function git(arguments: { string }): string
	local argv = { "git" }
	for _, argument in arguments do
		table.insert(argv, argument)
	end
	local result = process.run(argv)
	return if result.ok then (result.stdout:gsub("%s+$", "")) else "unknown"
end

local function facetCommit(): string
	for _, dependency in Lock.dependencies do
		if dependency.name == "facet" then
			return dependency.commit
		end
	end
	error("the lock has no facet dependency", 0)
end

local function main(): number
	local out = "build/ui-components-comparison"
	local filter: string? = nil
	local verify = false
	local index = 2
	while index <= #process.args do
		local option = process.args[index]
		if option == "--verify" then
			verify = true
		elseif option == "--out" or option == "--filter" then
			index += 1
			local value = assert(process.args[index], "missing value for " .. option)
			if option == "--out" then
				out = value
			else
				filter = value
			end
		else
			error(USAGE, 0)
		end
		index += 1
	end
	fs.createDirectory(out, { makeParents = true })
	local selected: { Workloads.Workload } = {}
	for _, workload in Workloads.all do
		if filter == nil or workload.id:find(filter, 1, true) ~= nil then
			table.insert(selected, workload)
		end
	end
	assert(#selected > 0, "no workload matches the filter")
	local failures: { { workload: string, problem: string } } = {}
	for _, workload in selected do
		local ok, problem = pcall(Parity, workload)
		print(("parity: %s %s"):format(if ok then "passed" else "failed", workload.id))
		if not ok then
			print(tostring(problem))
			table.insert(failures, { workload = workload.id, problem = tostring(problem) })
		end
	end
	fs.writeStringToFile(
		out .. "/parity.json",
		Lute.encode { passed = #selected - #failures, failures = failures, loaderFallbacks = Headless.fallbacks() }
			.. "\n"
	)
	if #failures > 0 then
		print(("parity: %d of %d workloads failed"):format(#failures, #selected))
		return 1
	end
	print(("parity: %d workloads passed"):format(#selected))
	if verify then
		return 0
	end
	local revision = git { "rev-parse", "HEAD" }
	local cpus = system.cpus()
	local rows: { Report.Row } = {}
	local descriptions: { Report.Description } = {}
	local evidence: { Measure.Evidence } = {}
	local function save(complete: boolean)
		fs.writeStringToFile(out .. "/report.json", Lute.encode {
			schema = "ui-components/1",
			complete = complete,
			revision = revision,
			status = git { "status", "--porcelain" },
			environment = {
				os = system.os,
				architecture = system.arch,
				threads = system.threadCount(),
				cpu = if #cpus > 0 then cpus[1].model else "unknown",
			},
			facet = facetCommit(),
			loaderFallbacks = Headless.fallbacks(),
			measurements = evidence,
			rows = rows,
		} .. "\n")
	end
	save(false)
	for position, workload in selected do
		print("measure: " .. workload.id)
		local measured = Measure(workload, position)
		table.insert(evidence, measured)
		if measured.problem ~= nil then
			save(false)
			print("measure: invalid measurement: " .. measured.problem)
			return 1
		end
		for _, row in measured.rows do
			table.insert(rows, row)
		end
		table.insert(descriptions, { id = workload.id, what = workload.what })
		save(false)
	end
	save(true)
	local markdown = Report.markdown(rows, revision, facetCommit(), descriptions, Headless.fallbacks())
	fs.writeStringToFile(out .. "/comparison.md", markdown)
	local summary = process.env.GITHUB_STEP_SUMMARY
	if summary ~= nil then
		fs.writeStringToFile(summary, (if fs.exists(summary) then fs.readFileToString(summary) else "") .. markdown)
	end
	print(("measure: %d workloads; reports in %s"):format(#selected, out))
	return 0
end

process.exit(main())
