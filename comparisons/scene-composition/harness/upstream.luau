--!strict

local fs = require "@std/fs"
local parser = require "@std/syntax/parser"
local luau = require "@lute/luau"
local Lock = require "../../../dependencies.lock"
local Environment = require "../cost-model"
local ComposeCore = require "../../../.lute/dependencies/compose/src/core"
local ComposeRoblox = require "../../../.lute/dependencies/compose/src/roblox"

type Module = { path: string }
export type Mode = "as-shipped" | "like-for-like"

local LIKE_FOR_LIKE_DIRECTIVE = "--!optimize 2\n"
local COMPOSE_ROOT = ".lute/dependencies/compose/src"
local boundary = luau.load(luau.compile "return ...", "benchmark-boundary")
local currentMode: Mode = "as-shipped"

local function setMode(mode: Mode)
	currentMode = mode
end

local function mode(): Mode
	return currentMode
end

local function compile(source: string): luau.Bytecode
	if currentMode == "like-for-like" then
		return luau.compile(LIKE_FOR_LIKE_DIRECTIVE .. source)
	end
	return luau.compile(source)
end

type Syntax = { [string]: unknown }

local SKIPPED_SYNTAX: { [string]: true } = { leadingTrivia = true, trailingTrivia = true, location = true }

local function globalName(node: unknown): string?
	if type(node) ~= "table" then
		return nil
	end
	local syntax = node :: Syntax
	if syntax.kind ~= "expr" or syntax.tag ~= "global" then
		return nil
	end
	local name = syntax.name
	if type(name) ~= "table" then
		return nil
	end
	local token = name :: Syntax
	local text = token.text
	return if type(text) == "string" then text else nil
end

local function globalsOf(source: string): ({ [string]: true }, { [string]: true })
	local reads: { [string]: true } = {}
	local writes: { [string]: true } = {}
	local function visit(node: Syntax)
		local read = globalName(node)
		if read then
			reads[read] = true
		end
		if node.kind == "stat" then
			local variables = node.variables
			local targets: { unknown }? = if node.tag == "assign" and type(variables) == "table"
				then variables :: { unknown }
				elseif node.tag == "compoundassign" then { node.variable }
				elseif node.tag == "function" then { node.name }
				else nil
			if targets then
				for _, target in targets do
					local written = globalName(target)
					if written then
						writes[written] = true
					end
				end
			end
		end
		for key, child in node do
			if type(child) == "table" and not (type(key) == "string" and SKIPPED_SYNTAX[key]) then
				visit(child :: Syntax)
			end
		end
	end
	local tree: unknown = parser.parse(source)
	if type(tree) == "table" then
		visit(tree :: Syntax)
	end
	return reads, writes
end

local luteGlobals: { [string]: { value: unknown } } = {}

local function luteGlobal(name: string): unknown
	local known = luteGlobals[name]
	if known == nil then
		known = { value = luau.load(luau.compile("return " .. name), "lute-global")() }
		luteGlobals[name] = known
	end
	return known.value
end

export type Loaded = { bytecode: luau.Bytecode, bound: { string }?, chunk: string }

local function bindingFor(source: string, globals: { [string]: unknown }): { string }
	local reads, writes = globalsOf(source)
	local names: { string } = {}
	for name in reads do
		if writes[name] or name == "script" or name == "require" or not rawequal(globals[name], luteGlobal(name)) then
			table.insert(names, name)
		end
	end
	for name in writes do
		if not reads[name] then
			table.insert(names, name)
		end
	end
	table.sort(names)
	return names
end

local function prepare(source: string, globals: { [string]: unknown }, chunk: string): Loaded
	local names = bindingFor(source, globals)
	if #names > 0 then
		local ok, bound = pcall(function(): luau.Bytecode
			local compiled = compile("local " .. table.concat(names, ", ") .. " = ...; " .. source)
			luau.load(compiled, chunk)
			return compiled
		end)
		if ok then
			return { bytecode = bound, bound = names, chunk = chunk }
		end
	end
	if #names == 0 then
		return { bytecode = compile(source), bound = {}, chunk = chunk }
	end
	return { bytecode = compile(source), bound = nil, chunk = chunk }
end

local function run(loaded: Loaded, globals: { [string]: unknown }): ...unknown
	local names = loaded.bound
	if names == nil then
		return luau.load(loaded.bytecode, loaded.chunk, globals)()
	end
	local values: { unknown } = table.create(#names)
	for index, name in names do
		values[index] = globals[name]
	end
	return luau.load(loaded.bytecode, loaded.chunk)(table.unpack(values, 1, #names))
end

local bytecode: { [string]: { [string]: Loaded } } = {}
local redirected: { [string]: string } = {}
local loaderLinks: { [string]: true } = {}
local nevermore: { [string]: string } = {}

local function normal(path: string): string
	local parts: { string } = {}
	for part in path:gmatch "[^/]+" do
		if part == ".." then
			assert(#parts > 0, "module path escapes the repository")
			table.remove(parts)
		elseif part ~= "." then
			table.insert(parts, part)
		end
	end
	return table.concat(parts, "/")
end

local function module(path: string): unknown
	return setmetatable({ path = path }, {
		__index = function(_self: unknown, key: string): unknown
			if key == "WaitForChild" or key == "FindFirstChild" then
				return function(_object: unknown, child: string): unknown
					return module(path .. "/" .. child)
				end
			elseif key == "FindFirstAncestor" then
				return function(): unknown
					return nil
				end
			elseif key == "GetFullName" then
				return function(): string
					return path
				end
			end
			return module(if key == "Parent" then path:match "^(.*)/[^/]+$" or "" else path .. "/" .. key)
		end,
	})
end

local function create(environment: Environment.Environment)
	local cache: { [string]: unknown } = {}
	local loaded: { [string]: boolean } = {}
	local paths: { [string]: string } = {}
	local allowed: { string } = {}
	for _, dependency in Lock.dependencies do
		for _, surface in dependency.surfaces do
			if surface.role == "benchmark" then
				table.insert(allowed, ".lute/dependencies/" .. dependency.name .. "/" .. surface.root)
			end
		end
	end
	local function resolve(path: string): string
		path = normal(path)
		local requested = path
		local present = false
		for _, suffix in { "", ".luau", ".lua", "/init.luau", "/init.lua" } do
			if fs.exists(path .. suffix) and fs.type(path .. suffix) == "file" then
				present = true
				break
			end
		end
		local package = path:match "/([^/]+)$"
		local packages: { [string]: string } = {
			React = "react-upstream/modules/react/src",
			ReactRoblox = "react-upstream/modules/react-roblox/src",
			ReactReconciler = "react-upstream/modules/react-reconciler/src",
			Scheduler = "react-upstream/modules/scheduler/src",
			Shared = "react-upstream/modules/shared/src",
			LuauPolyfill = "polyfill-upstream/modules/luau-polyfill/src",
			Promise = "promise-upstream/lib",
			Symbol = "symbol-upstream/src",
			Signals = "signals/modules/signals/src",
			SignalsExperimental = "signals/modules/signals-experimental/src",
			SignalsScheduler = "signals/modules/signals-scheduler/src",
			SignalsFlags = "signals/modules/signals-flags/src",
		}
		local mapped = if package then packages[package] else nil
		if package == "Promise" and path:find("/reflex/", 1, true) then
			mapped = "reflex-promise/lib"
		end
		if mapped and not present then
			path = ".lute/dependencies/" .. mapped
		elseif not present and path:find("/polyfill-upstream/", 1, true) and package then
			local names: { [string]: string } = {
				Boolean = "boolean",
				Collections = "collections",
				Console = "console",
				ES7Types = "es7-types",
				InstanceOf = "instance-of",
				Math = "math",
				Number = "number",
				String = "string",
				Timers = "timers",
			}
			if names[package] then
				path = ".lute/dependencies/polyfill-upstream/modules/" .. names[package] .. "/src"
			end
		end
		for _, candidate in { path, path .. ".luau", path .. ".lua", path .. "/init.luau", path .. "/init.lua" } do
			if fs.exists(candidate) and fs.type(candidate) == "file" then
				for _, root in allowed do
					if candidate == root or candidate:sub(1, #root + 1) == root .. "/" then
						if candidate:sub(1, #requested) ~= requested then
							redirected[requested] = candidate
						end
						return candidate
					end
				end
				error("module is outside the benchmark surfaces: " .. candidate, 0)
			end
		end
		error("benchmark module is absent: " .. path, 0)
	end
	local function scan(root: string)
		for _, entry in fs.listDirectory(root) do
			local path = root .. "/" .. entry.name
			if entry.type == "dir" then
				scan(path)
			elseif entry.name:match "%.lua[u]?$" and not entry.name:find(".spec.", 1, true) then
				local name = entry.name:gsub("%.lua[u]?$", "")
				assert(paths[name] == nil, "ambiguous Nevermore module " .. name)
				paths[name] = path
			end
		end
	end
	for _, root in allowed do
		if root:find("/blend/", 1, true) and fs.exists(root) then
			if fs.type(root) == "dir" then
				scan(root)
			else
				local name = root:match "([^/]+)%.lua$"
				if name then
					paths[name] = root
				end
			end
		end
	end
	for name, path in paths do
		nevermore[name] = path
	end
	local load: (string) -> unknown
	function load(request: string): unknown
		local path = resolve(request)
		if loaded[path] then
			return cache[path]
		end
		local globals = table.clone(environment.globals)
		local directory = assert(path:match "^(.*)/[^/]+$")
		local relative = if path:sub(1, #COMPOSE_ROOT + 1) == COMPOSE_ROOT .. "/" and path:match "/init%.luau$"
			then directory .. "/.."
			else directory
		globals.script = module(if path:match "/init%.lua[u]?$" then directory else path:gsub("%.lua[u]?$", ""))
		globals.require = function(target: string | Module): unknown
			if type(target) == "table" then
				if target.path:match "/loader$" then
					loaderLinks[target.path] = true
					return {
						load = function(_script: Module)
							return function(name: string): unknown
								return load((assert(paths[name], "Nevermore module is not locked: " .. name)))
							end
						end,
					}
				end
				return load(target.path)
			end
			if target:sub(1, 5) == "@pkg/" then
				local name = target:gsub("^@pkg/@jsdotlua/", ""):gsub("^@pkg/", "")
				if name == "symbol-luau" then
					return load ".lute/dependencies/symbol/src/init.lua"
				elseif name == "promise" then
					return load ".lute/dependencies/react-promise/lib/init.lua"
				end
				local root = if name == "react"
						or name == "react-roblox"
						or name == "react-reconciler"
						or name == "scheduler"
						or name == "shared"
					then "react"
					else "luau-polyfill"
				return load(".lute/dependencies/" .. root .. "/modules/" .. name .. "/src")
			elseif target:sub(1, 6) == "@self/" then
				return load(directory .. "/" .. target:sub(7))
			end
			return load(relative .. "/" .. target)
		end
		local compiledForMode = bytecode[currentMode]
		if compiledForMode == nil then
			compiledForMode = {}
			bytecode[currentMode] = compiledForMode
		end
		local named = (globals :: unknown) :: { [string]: unknown }
		local prepared = compiledForMode[path]
		if prepared == nil then
			prepared = prepare(fs.readFileToString(path), named, "@" .. path)
			compiledForMode[path] = prepared
		end
		local result: unknown = run(prepared, named)
		cache[path] = result
		loaded[path] = true
		return result
	end
	return {
		load = function(path: string)
			if currentMode == "as-shipped" and path == COMPOSE_ROOT .. "/core" then
				ComposeCore.__resetForTests()
				return boundary(ComposeCore)
			elseif currentMode == "as-shipped" and path == COMPOSE_ROOT .. "/roblox" then
				ComposeRoblox.__resetForTests()
				return boundary(ComposeRoblox)
			end
			return boundary(load(path))
		end,
	}
end

local function links(): ({ [string]: string }, { string }, { [string]: string })
	local loaders: { string } = {}
	for path in loaderLinks do
		table.insert(loaders, path)
	end
	table.sort(loaders)
	return table.clone(redirected), loaders, nevermore
end

local function fallbacks(): { string }
	local chunks: { string } = {}
	local compiled = bytecode[currentMode]
	if compiled ~= nil then
		for _, prepared in compiled do
			if prepared.bound == nil then
				table.insert(chunks, prepared.chunk)
			end
		end
	end
	table.sort(chunks)
	return chunks
end

return {
	create = create,
	fallbacks = fallbacks,
	links = links,
	prepare = prepare,
	run = run,
	compile = compile,
	mode = mode,
	setMode = setMode,
	callback = function(value: unknown): (...unknown) -> ()
		assert(type(value) == "function", "event handler must be a function")
		return boundary(value)
	end,
	entries = function(value: unknown): { [unknown]: unknown }
		assert(type(value) == "table", "children must be a table")
		return boundary(value)
	end,
}
