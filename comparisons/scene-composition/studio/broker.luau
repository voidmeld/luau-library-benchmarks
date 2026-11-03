--!strict

local fs = require "@std/fs"
local process = require "@lute/process"
local system = require "@lute/system"

local NAME = "LuauLibraryBenchmarksProfiler.lua"
local SOURCE = [[
local RunService = game:GetService("RunService")
if not (RunService:IsRunning() and RunService:IsClient()) then
	return
end
local service = game:GetService("ScriptProfilerService")
local player = game:GetService("Players").LocalPlayer
local broker = Instance.new("BindableFunction")
broker.Name = "LuauLibraryBenchmarksProfiler"
broker.OnInvoke = function(operation, frequency)
	if operation == "start" then
		service:ClientStart(player, frequency)
		return true
	elseif operation == "stop" then
		service:ClientStop(player)
		local received
		local connection = service.OnNewData:Connect(function(_, json)
			received = json
		end)
		service:ClientRequestData(player)
		local waited = 0
		while received == nil and waited < 30 do
			waited += task.wait()
		end
		connection:Disconnect()
		return received
	end
	error("unknown profiler operation: " .. tostring(operation))
end
broker.Parent = game:GetService("ReplicatedStorage")
]]

local function directory(): string
	if system.os == "windows" or system.os == "Windows_NT" then
		return assert(process.env.LOCALAPPDATA, "LOCALAPPDATA is not set") .. "/Roblox/Plugins"
	end
	return assert(process.env.HOME, "HOME is not set") .. "/Documents/Roblox/Plugins"
end

local function install()
	local path = directory()
	if not fs.exists(path) then
		fs.createDirectory(path, { makeParents = true })
	end
	local file = path .. "/" .. NAME
	if not fs.exists(file) or fs.readFileToString(file) ~= SOURCE then
		fs.writeStringToFile(file, SOURCE)
	end
end

return { install = install, NAME = NAME }
