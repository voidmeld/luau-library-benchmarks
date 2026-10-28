--!strict
--!nolint DeprecatedApi

type Player = unknown
type Connection = { Disconnect: (Connection) -> () }
type ProfilerService = {
	ClientStart: (ProfilerService, Player, number) -> (),
	ClientStop: (ProfilerService, Player) -> (),
	ClientRequestData: (ProfilerService, Player) -> (),
	OnNewData: { Connect: (unknown, (Player, string) -> ()) -> Connection },
}
type Function = { Source: string?, Name: string? }
type Node = { TotalDuration: number?, FunctionIds: { number }?, NodeIds: { number }? }
type Category = { Name: string, NodeId: number }
type Data = { Categories: { Category }, Nodes: { Node }, Functions: { Function } }
type HttpService = { JSONDecode: (HttpService, string) -> Data }
type Native = {
	game: {
		GetService: ((unknown, "ScriptProfilerService") -> ProfilerService)
			& ((unknown, "Players") -> { LocalPlayer: Player })
			& ((unknown, "HttpService") -> HttpService),
	},
	task: { wait: (number?) -> number },
}

local FREQUENCY = 10000
local native: Native = getfenv(0)
local service = native.game:GetService "ScriptProfilerService"
local player = native.game:GetService("Players").LocalPlayer
local http = native.game:GetService "HttpService"

local function start()
	service:ClientStart(player, FREQUENCY)
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
			if child ~= nil then
				if measured(data.Functions[functionId].Source, prefixes) then
					sum += child.TotalDuration or 0
				else
					visit(child)
				end
			end
		end
	end
	for _, category in data.Categories do
		if category.Name ~= "WaitingScripts" then
			local root = data.Nodes[category.NodeId]
			if root ~= nil then
				visit(root)
			end
		end
	end
	return sum
end

local function stop(prefixes: { string }): number
	service:ClientStop(player)
	local received: string? = nil
	local connection = service.OnNewData:Connect(function(_player: Player, json: string)
		received = json
	end)
	service:ClientRequestData(player)
	local waited = 0
	while received == nil do
		waited += native.task.wait()
		assert(waited < 30, "the script profiler returned no data")
	end
	connection:Disconnect()
	return total(http:JSONDecode(assert(received)), prefixes)
end

return { start = start, stop = stop, FREQUENCY = FREQUENCY }
