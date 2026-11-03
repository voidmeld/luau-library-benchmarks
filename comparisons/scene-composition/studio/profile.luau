--!strict
--!nolint DeprecatedApi

type Function = { Source: string?, Name: string? }
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

local function total(data: Data, prefixes: { string }): number
	local sum = 0
	local function visit(node: Node)
		local functions: { number } = node.FunctionIds or {}
		local children: { number } = node.NodeIds or {}
		for index, functionId in functions do
			local child = data.Nodes[children[index]]
			local source = data.Functions[functionId].Source
			if child ~= nil and not (source ~= nil and source:sub(1, #SELF) == SELF) then
				if measured(source, prefixes) then
					sum += child.TotalDuration or 0
				else
					visit(child)
				end
			end
		end
	end
	for _, category in data.Categories do
		local root = data.Nodes[category.NodeId]
		if root ~= nil then
			visit(root)
		end
	end
	return sum
end

local function stop(prefixes: { string }): number
	local json = assert(profiler():Invoke "stop", "the script profiler returned no data")
	return total(http:JSONDecode(json), prefixes)
end

return { start = start, stop = stop, FREQUENCY = FREQUENCY, RESOLUTION = RESOLUTION }
