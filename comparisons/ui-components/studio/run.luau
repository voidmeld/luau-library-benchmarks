--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local Lute = require "../../../.lute/dependencies/verify/src/lute"
local Verify = require "../../../.lute/dependencies/verify/src/core"
local Machine = require "../../scene-composition/studio/report"
local Report = require "./report"
local Shards = require "../../studio-shards"
local Workloads = require "../workloads"
local UNSUPPORTED = require "./unsupported"

local HARNESS = "comparisons/ui-components"
local ENTRY = HARNESS .. "/studio/entry.luau"
local SHARED = {
	"comparisons/scene-composition/studio/loader.luau",
	"comparisons/scene-composition/studio/profile.luau",
	"comparisons/scene-composition/studio/memory.luau",
	"comparisons/memory-settings.luau",
	".lute/dependencies/verify/src/lute/memory.luau",
}
local FACET = ".lute/dependencies/facet/src"

local function logical(path: string): string
	return (path:gsub("%.luau?$", ""):gsub("/init$", ""))
end

local function mount(verbatim: { [string]: string }, path: string)
	if fs.type(path) == "file" then
		if path:match "%.luau?$" then
			verbatim[logical(path)] = fs.readFileToString(path)
		end
		return
	end
	for _, entry in fs.listDirectory(path) do
		mount(verbatim, path .. "/" .. entry.name)
	end
end

local function verbatimModules(): { [string]: string }
	local verbatim: { [string]: string } = {}
	mount(verbatim, HARNESS)
	verbatim[logical(ENTRY)] = nil
	for _, path in SHARED do
		mount(verbatim, path)
	end
	mount(verbatim, FACET)
	return verbatim
end

local function groups(): { Shards.Group }
	local result: { Shards.Group } = {}
	for _, workload in Workloads.all do
		if UNSUPPORTED[workload.id] == nil then
			table.insert(result, { workload = workload.id, ids = { workload.id .. "/plain", workload.id .. "/facet" } })
		end
	end
	return result
end

local function main(): number
	local out = "build/ui-components-studio"
	local caseIds: { string } = {}
	local shards = 1
	local weights: string? = "comparisons/ui-components/studio-weights.json"
	local record: string? = nil
	local index = 2
	while index <= #process.args do
		local option = process.args[index]
		if option == "--out" then
			index += 1
			out = assert(process.args[index], "missing value for --out")
		elseif option == "--case" then
			index += 1
			table.insert(caseIds, (assert(process.args[index], "missing value for --case")))
		elseif option == "--shards" then
			index += 1
			shards = assert(tonumber(process.args[index]), "--shards needs a count")
		elseif option == "--weights" then
			index += 1
			weights = assert(process.args[index], "missing value for --weights")
		elseif option == "--record-weights" then
			index += 1
			record = assert(process.args[index], "missing value for --record-weights")
		else
			error(
				"usage: lute run comparisons/ui-components/studio/run.luau [--out directory] [--case workload/lane]... [--shards count] [--weights path] [--record-weights path]",
				0
			)
		end
		index += 1
	end
	local synced = process.run { "lute", "run", "tools/sync-dependencies.luau", "--check" }
	assert(synced.ok, synced.stdout .. synced.stderr .. "\nRun lute run tools/sync-dependencies.luau")
	local status = process.run { "git", "status", "--porcelain" }
	assert(
		status.ok and string.match(status.stdout, "%S") == nil,
		"the Studio comparison requires a clean committed HEAD"
	)
	local report: Verify.Report
	if shards > 1 and #caseIds == 0 then
		report = Shards.run {
			script = "comparisons/ui-components/studio/run.luau",
			out = out,
			count = shards,
			groups = groups(),
			weights = weights,
			record = record,
			id = "ui-components-studio",
		}
	else
		if not fs.exists(out) then
			fs.createDirectory(out, { makeParents = true })
		end
		report = Lute.platform.run({
			host = "studio",
			progressFile = out .. "/progress.jsonl",
			entry = ENTRY,
			frameworkDirectory = ".lute/dependencies/verify",
			verbatim = verbatimModules(),
			context = "Client",
			caseIds = if #caseIds > 0 then caseIds else nil,
			deadlineSeconds = 14400,
		}).report
	end
	if not fs.exists(out) then
		fs.createDirectory(out, { makeParents = true })
	end
	fs.writeStringToFile(out .. "/report.json", Lute.encode(report))
	fs.writeStringToFile(out .. "/studio.md", Report.markdown(report, Machine.machine()))
	print(Verify.format(report))
	print("studio: wrote " .. out .. "/studio.md")
	return if report.passed == report.total then 0 else 1
end

process.exit(main())
