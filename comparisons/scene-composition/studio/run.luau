--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local Lute = require "../../../.lute/dependencies/verify/src/lute"
local Verify = require "../../../.lute/dependencies/verify/src/core"
local sha256 = require "../../../.lute/dependencies/verify/src/lute/hash"
local Frameworks = require "../harness/frameworks"
local Upstream = require "../harness/upstream"
local Lock = require "../../../dependencies.lock"
local Report = require "./report"

local HARNESS = "comparisons/scene-composition"
local ENTRY = HARNESS .. "/studio/entry.luau"
local NEVERMORE = ".lute/links/nevermore"
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

local function expression(path: string): string
	return Lute.place.moduleExpression(path)
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
	verbatim[logical(ENTRY)] = nil
	verbatim["dependencies.lock"] = fs.readFileToString "dependencies.lock.luau"
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
	local redirected, loaders, names = Upstream.links()
	for requested, target in redirected do
		verbatim[requested] = "return require(" .. expression(logical(target)) .. ")\n"
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
			("\t[%q] = function()\n\t\treturn %s\n\tend,"):format(name, expression(logical(names[name])))
		)
	end
	verbatim[NEVERMORE] = "local modules = {\n"
		.. table.concat(entries, "\n")
		.. "\n}\nreturn {\n\tload = function()\n\t\treturn function(name)\n\t\t\treturn require(modules[name]())\n\t\tend\n\tend,\n}\n"
	for _, loader in loaders do
		verbatim[loader] = "return require(" .. expression(NEVERMORE) .. ")\n"
	end
	return verbatim
end

local function main(): number
	local out = "build/scene-composition-studio"
	local caseIds: { string } = {}
	local index = 2
	while index <= #process.args do
		local option = process.args[index]
		if option == "--out" then
			index += 1
			out = assert(process.args[index], "missing value for --out")
		elseif option == "--case" then
			index += 1
			table.insert(caseIds, (assert(process.args[index], "missing value for --case")))
		else
			error(
				"usage: lute run comparisons/scene-composition/studio/run.luau [--out directory] [--case workload/lane]...",
				0
			)
		end
		index += 1
	end
	local synced = process.run { "lute", "run", "tools/sync-dependencies.luau", "--check" }
	assert(synced.ok, synced.stdout .. synced.stderr .. "\nRun lute run tools/sync-dependencies.luau")
	local result = Lute.platform.run {
		host = "studio",
		entry = ENTRY,
		frameworkDirectory = ".lute/dependencies/verify",
		verbatim = verbatimModules(),
		context = "Client",
		caseIds = if #caseIds > 0 then caseIds else nil,
		deadlineSeconds = 14400,
	}
	if not fs.exists(out) then
		fs.createDirectory(out, { makeParents = true })
	end
	fs.writeStringToFile(out .. "/report.json", Lute.encode(result.report))
	local markdown = Report.markdown(result.report, Report.machine())
	fs.writeStringToFile(out .. "/studio.md", markdown)
	print(Verify.format(result.report))
	print("studio: wrote " .. out .. "/studio.md")
	return if result.report.passed == result.report.total then 0 else 1
end

process.exit(main())
