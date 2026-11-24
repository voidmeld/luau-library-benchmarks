--!strict
--!nolint DeprecatedApi

type Function = { Source: string?, Name: string?, Line: number? }
type Node = { TotalDuration: number?, FunctionIds: { number }?, NodeIds: { number }? }
type Category = { Name: string, NodeId: number }
type Data = { Categories: { Category }, Nodes: { Node }, Functions: { Function } }
type HttpService = { JSONDecode: (HttpService, string) -> Data }
type Broker = {
	Invoke: ((Broker, "start", number) -> boolean) & ((Broker, "stop") -> string?),
}
type Storage = { WaitForChild: (Storage, string, number) -> Broker? }
type Native = {
	game: {
		GetService: ((unknown, "HttpService") -> HttpService) & ((unknown, "ReplicatedStorage") -> Storage),
	},
}

local FREQUENCY = 10000
local RESOLUTION = 1000000 / FREQUENCY
local SELF = "ReplicatedStorage.VerifyModules.comparisons.scene-composition.studio.profile"
local RUNNER = "VerifyRunner"
local native: Native = getfenv(0)
local http = native.game:GetService "HttpService"
local broker: Broker? = nil

local function profiler(): Broker
	if broker == nil then
		broker = native.game:GetService("ReplicatedStorage"):WaitForChild("LuauLibraryBenchmarksProfiler", 10)
	end
	return assert(broker, "the profiler plugin is not installed; run the Studio comparison through its run.luau")
end

local function start()
	profiler():Invoke("start", FREQUENCY)
end

local function measured(source: string?, prefixes: { string }): boolean
	if source == nil then
		return false
	end
	for _, prefix in prefixes do
		if source:sub(1, #prefix) == prefix then
			return true
		end
	end
	return false
end

local function runner(entry: Function): boolean
	return entry.Source == nil and entry.Name == RUNNER
end

local function spawned(entry: Function, underRunner: boolean): boolean
	return underRunner and entry.Source == "[C]"
end

local function library(source: string?): string?
	if source == nil then
		return nil
	end
	return source:match "%.%.lute%.dependencies%.([^%.]+)" or source:match "%.%.lute%.releases%.([^%.]+)"
end

local function excluded(source: string?, foreign: { [string]: boolean }?): boolean
	if source ~= nil and source:sub(1, #SELF) == SELF then
		return true
	end
	local root = library(source)
	return foreign ~= nil and root ~= nil and foreign[root] == true
end

local function total(data: Data, prefixes: { string }, foreign: { [string]: boolean }?): number
	local sum = 0
	local function visit(node: Node, underRunner: boolean)
		local functions: { number } = node.FunctionIds or {}
		local children: { number } = node.NodeIds or {}
		for index, functionId in functions do
			local child = data.Nodes[children[index]]
			local entry = data.Functions[functionId]
			local source = entry.Source
			if child ~= nil and not excluded(source, foreign) then
				if measured(source, prefixes) or spawned(entry, underRunner) then
					sum += child.TotalDuration or 0
				else
					visit(child, runner(entry))
				end
			end
		end
	end
	for _, category in data.Categories do
		local root = data.Nodes[category.NodeId]
		if root ~= nil then
			visit(root, false)
		end
	end
	return sum
end

local last: Data? = nil

local function stop(prefixes: { string }, foreign: { [string]: boolean }?): number
	local json = assert(profiler():Invoke "stop", "the script profiler returned no data")
	local data = http:JSONDecode(json)
	last = data
	return total(data, prefixes, foreign)
end

local function breakdown(prefixes: { string }, foreign: { [string]: boolean }?): string
	local data = last
	if data == nil then
		return "no profile"
	end
	local lines: { string } = { ("counted %.0f us"):format(total(data, prefixes, foreign)) }
	for _, category in data.Categories do
		local root = data.Nodes[category.NodeId]
		if root == nil then
			continue
		end
		table.insert(lines, ("category %s total %.0f us"):format(category.Name, root.TotalDuration or 0))
		type Entry = { source: string, duration: number }
		local entries: { Entry } = {}
		local functions: { number } = root.FunctionIds or {}
		local children: { number } = root.NodeIds or {}
		for index, functionId in functions do
			local child = data.Nodes[children[index]]
			local entry = data.Functions[functionId]
			if child ~= nil then
				table.insert(entries, {
					source = (entry.Source or "?") .. ":" .. (entry.Name or "?"),
					duration = child.TotalDuration or 0,
				})
			end
		end
		table.sort(entries, function(left: Entry, right: Entry): boolean
			return left.duration > right.duration
		end)
		for index = 1, math.min(#entries, 12) do
			table.insert(lines, ("  %.0f us %s"):format(entries[index].duration, entries[index].source))
		end
	end
	local own: { [string]: number } = {}
	local seen: { [number]: true } = {}
	local callers: { [string]: { [string]: number } } = {}
	local function visit(node: Node, inside: boolean, parent: string, underRunner: boolean)
		local functions: { number } = node.FunctionIds or {}
		local children: { number } = node.NodeIds or {}
		for index, functionId in functions do
			local child = data.Nodes[children[index]]
			local entry = data.Functions[functionId]
			if child == nil or seen[children[index]] or excluded(entry.Source, foreign) then
				continue
			end
			seen[children[index]] = true
			local counted = inside or measured(entry.Source, prefixes) or spawned(entry, underRunner)
			if counted then
				local rest = child.TotalDuration or 0
				for _, grandchild in child.NodeIds or {} do
					local below = data.Nodes[grandchild]
					rest -= if below ~= nil then below.TotalDuration or 0 else 0
				end
				local key = (entry.Source or "?") .. ":" .. (entry.Name or "?")
				own[key] = (own[key] or 0) + rest
				if entry.Source == "[C]" then
					local from = callers[key] or {}
					callers[key] = from
					from[parent] = (from[parent] or 0) + rest
				end
			end
			visit(
				child,
				counted,
				(entry.Source or "?") .. ":" .. (entry.Name or "?") .. ":" .. tostring(entry.Line or "?"),
				runner(entry)
			)
		end
	end
	for _, category in data.Categories do
		local root = data.Nodes[category.NodeId]
		if root ~= nil then
			visit(root, false, category.Name, false)
		end
	end
	type Own = { source: string, duration: number }
	local ranked: { Own } = {}
	for source, duration in own do
		table.insert(ranked, { source = source, duration = duration })
	end
	table.sort(ranked, function(left: Own, right: Own): boolean
		return left.duration > right.duration
	end)
	table.insert(lines, "self time")
	for index = 1, math.min(#ranked, 30) do
		table.insert(lines, ("  %.0f us %s"):format(ranked[index].duration, ranked[index].source))
	end
	table.insert(lines, "engine call sites")
	local shown = 0
	for _, entry in ranked do
		local from = callers[entry.source]
		if from == nil then
			continue
		end
		shown += 1
		if shown > 5 then
			break
		end
		local sites: { Own } = {}
		for source, duration in from do
			table.insert(sites, { source = source, duration = duration })
		end
		table.sort(sites, function(left: Own, right: Own): boolean
			return left.duration > right.duration
		end)
		table.insert(lines, "  " .. entry.source)
		for index = 1, math.min(#sites, 5) do
			table.insert(lines, ("    %.0f us from %s"):format(sites[index].duration, sites[index].source))
		end
	end
	return table.concat(lines, "\n")
end

return { start = start, stop = stop, breakdown = breakdown, FREQUENCY = FREQUENCY, RESOLUTION = RESOLUTION }
