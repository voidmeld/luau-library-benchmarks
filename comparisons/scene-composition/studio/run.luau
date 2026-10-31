--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local Lute = require "../../../.lute/dependencies/verify/src/lute"
local Verify = require "../../../.lute/dependencies/verify/src/core"
local sha256 = require "../../../.lute/dependencies/verify/src/lute/hash"
local Frameworks = require "../harness/frameworks"
local Upstream = require "../harness/upstream"
local Environment = require "../cost-model"
local Lock = require "../../../dependencies.lock"
local Report = require "./report"
local Shards = require "../../studio-shards"
local Lanes = require "../lanes"
local Workloads = require "../workloads"
local UNSUPPORTED = require "./unsupported"

local HARNESS = "comparisons/scene-composition"
local ENTRY = HARNESS .. "/studio/entry.luau"
local NEVERMORE = ".lute/links/nevermore"
local MEMORY = ".lute/dependencies/verify/src/lute/memory"
local RELEASE = {
	name = "react-lua",
	url = "https://github.com/jsdotlua/react-lua/releases/download/v17.2.1/react-lua.rbxm",
	sha256 = "bd2d1f9cc041ec22a962a7b64f48738ff1aed3f07755628f499ef95c9881d73f",
	mount = ".lute/releases/react-lua",
}
local SKIPPED_PARTS = { "/__tests__/", "/.spec.", ".spec.lua", ".spec.luau", ".story.lua", ".story.luau" }

local function logical(path: string): string
	return (path:gsub("%.luau?$", ""):gsub("/init$", ""))
end

local function segments(path: string): { string }
	local parts: { string } = {}
	for part in path:gmatch "[^/]+" do
		table.insert(parts, part)
	end
	return parts
end

local function relative(from: string, to: string): string
	local origin, target = segments(from), segments(to)
	local shared = 0
	while shared < #origin - 1 and shared < #target and origin[shared + 1] == target[shared + 1] do
		shared += 1
	end
	local expression = "script" .. string.rep(".Parent", #origin - shared)
	for index = shared + 1, #target do
		expression ..= (":FindFirstChild(%q)"):format(target[index])
	end
	return expression
end

local function skipped(path: string): boolean
	for _, part in SKIPPED_PARTS do
		if path:find(part, 1, true) then
			return true
		end
	end
	return false
end

local function mount(verbatim: { [string]: string }, path: string)
	if fs.type(path) == "file" then
		if path:match "%.luau?$" and not skipped(path) then
			verbatim[logical(path)] = fs.readFileToString(path)
		end
		return
	end
	for _, entry in fs.listDirectory(path) do
		mount(verbatim, path .. "/" .. entry.name)
	end
end

local function run(argv: { string }, what: string)
	local result = process.run(argv)
	assert(result.ok, what .. " failed: " .. result.stdout .. result.stderr)
end

local function release(verbatim: { [string]: string })
	local directory = ".lute/releases"
	if not fs.exists(directory) then
		fs.createDirectory(directory)
	end
	local model = directory .. "/" .. RELEASE.name .. ".rbxm"
	if not fs.exists(model) or sha256(fs.readFileToString(model)) ~= RELEASE.sha256 then
		run({ "curl", "-sSfL", "-o", model, RELEASE.url }, "release download")
	end
	assert(sha256(fs.readFileToString(model)) == RELEASE.sha256, "release model hash differs from the pin")
	local project = directory .. "/" .. RELEASE.name .. ".project.json"
	fs.writeStringToFile(project, '{"name":"' .. RELEASE.name .. '","tree":{"$path":"' .. RELEASE.name .. '.rbxm"}}')
	local xml = directory .. "/" .. RELEASE.name .. ".rbxmx"
	run({ "rojo", "build", project, "-o", xml }, "release conversion")
	local function visit(item: Lute.ModelInstance, path: string)
		local source = item.properties.Source
		if item.className == "ModuleScript" and source ~= nil then
			verbatim[path] = source.value
		end
		for _, child in item.children do
			visit(child, path .. "/" .. child.name)
		end
	end
	for _, root in Lute.model.read(fs.readFileToString(xml)) do
		for _, child in root.children do
			visit(child, RELEASE.mount .. "/" .. child.name)
		end
	end
end

local function verbatimModules(): { [string]: string }
	local verbatim: { [string]: string } = {}
	mount(verbatim, HARNESS)
	mount(verbatim, "comparisons/memory-settings.luau")
	verbatim[logical(ENTRY)] = nil
	verbatim["dependencies.lock"] = fs.readFileToString "dependencies.lock.luau"
	verbatim[MEMORY] = fs.readFileToString(MEMORY .. ".luau")
	for _, dependency in Lock.dependencies do
		for _, surface in dependency.surfaces do
			if surface.role == "benchmark" then
				mount(verbatim, ".lute/dependencies/" .. dependency.name .. "/" .. surface.root)
			end
		end
	end
	release(verbatim)
	Upstream.setMode "like-for-like"
	for _, framework in Frameworks.available() do
		Frameworks.open(framework)
	end
	local traced = Upstream.links()
	local directories: { [string]: true } = {}
	for requested in traced do
		directories[assert(requested:match "^(.*)/[^/]+$")] = true
	end
	for _, dependency in Lock.dependencies do
		local modules = ".lute/dependencies/" .. dependency.name .. "/modules"
		if fs.exists(modules) and fs.type(modules) == "dir" then
			for _, entry in fs.listDirectory(modules) do
				if entry.type == "dir" then
					directories[modules .. "/" .. entry.name] = true
				end
			end
		end
	end
	local probe = Upstream.create(Environment.create()).probe
	for directory in directories do
		for _, name in Upstream.packageNames() do
			probe(directory .. "/" .. name)
		end
	end
	local redirected, loaders, names = Upstream.links()
	for requested, target in redirected do
		verbatim[requested] = "return require(" .. relative(requested, logical(target)) .. ")\n"
	end
	local entries: { string } = {}
	local sorted: { string } = {}
	for name in names do
		table.insert(sorted, name)
	end
	table.sort(sorted)
	for _, name in sorted do
		table.insert(
			entries,
			("\t[%q] = function()\n\t\treturn %s\n\tend,"):format(name, relative(NEVERMORE, logical(names[name])))
		)
	end
	verbatim[NEVERMORE] = "local modules = {\n"
		.. table.concat(entries, "\n")
		.. "\n}\nreturn {\n\tload = function()\n\t\treturn function(name)\n\t\t\treturn require(modules[name]())\n\t\tend\n\tend,\n}\n"
	local blend = ".lute/dependencies/blend"
	local function nevermoreDirectories(path: string)
		local hasModule = false
		for _, entry in fs.listDirectory(path) do
			if entry.type == "dir" then
				nevermoreDirectories(path .. "/" .. entry.name)
			elseif entry.name:match "%.lua$" then
				hasModule = true
			end
		end
		if hasModule and verbatim[path .. "/loader"] == nil then
			table.insert(loaders, path .. "/loader")
		end
	end
	nevermoreDirectories(blend)
	for _, loader in loaders do
		verbatim[loader] = "return require(" .. relative(loader, NEVERMORE) .. ")\n"
	end
	return verbatim
end

local function groups(): { Shards.Group }
	local result: { Shards.Group } = {}
	for _, workload in Workloads.all do
		if UNSUPPORTED[workload.id] == nil then
			local ids: { string } = {}
			local names = { "plain" }
			for _, lane in Lanes do
				table.insert(names, lane.name)
			end
			for _, lane in names do
				if workload.cases[lane] ~= nil then
					table.insert(ids, workload.id .. "/" .. lane)
				end
			end
			table.insert(result, { workload = workload.id, ids = ids })
		end
	end
	return result
end

local function main(): number
	local out = "build/scene-composition-studio"
	local caseIds: { string } = {}
	local shards = 1
	local batches = 6
	local weights: string? = "comparisons/scene-composition/studio-weights.json"
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
		elseif option == "--batches" then
			index += 1
			batches = assert(tonumber(process.args[index]), "--batches needs a count")
		elseif option == "--weights" then
			index += 1
			weights = assert(process.args[index], "missing value for --weights")
		elseif option == "--record-weights" then
			index += 1
			record = assert(process.args[index], "missing value for --record-weights")
		else
			error(
				"usage: lute run comparisons/scene-composition/studio/run.luau [--out directory] [--case workload/lane]... [--shards count | --batches count] [--weights path] [--record-weights path]",
				0
			)
		end
		index += 1
	end
	local synced = process.run { "lute", "run", "tools/sync-dependencies.luau", "--check" }
	assert(synced.ok, synced.stdout .. synced.stderr .. "\nRun lute run tools/sync-dependencies.luau")
	local report: Verify.Report
	local sequential = shards == 1 and batches > 1
	if (shards > 1 or sequential) and #caseIds == 0 then
		report = Shards.run {
			script = "comparisons/scene-composition/studio/run.luau",
			out = out,
			count = if sequential then batches else shards,
			sequential = sequential,
			groups = groups(),
			weights = weights,
			record = record,
			id = "scene-composition-studio",
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
	local markdown = Report.markdown(report, Report.machine())
	fs.writeStringToFile(out .. "/studio.md", markdown)
	print(Verify.format(report))
	print("studio: wrote " .. out .. "/studio.md")
	return if report.passed == report.total then 0 else 1
end

process.exit(main())
