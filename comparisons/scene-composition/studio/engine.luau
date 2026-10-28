--!strict
--!nolint DeprecatedApi

local Environment = require "../cost-model"

type Instance = Environment.Instance
type Signal = Environment.Signal

type NativeSignal = Signal & { Wait: (NativeSignal) -> number }
type RunService = { Heartbeat: NativeSignal }
type Player = { PlayerGui: Instance }
type Players = { LocalPlayer: Player }
type Native = {
	game: { GetService: ((unknown, "RunService") -> RunService) & ((unknown, "Players") -> Players) },
	Instance: Environment.InstanceFactory,
	typeof: (unknown) -> string,
}

local native: Native = getfenv(0)
local globals: Environment.Globals = getfenv(0)
local RunService = native.game:GetService "RunService"
local Players = native.game:GetService "Players"

local function frame()
	RunService.Heartbeat:Wait()
end

local function drain()
	frame()
end

local function render(value: unknown): string
	if type(value) == "string" then
		return ("%q"):format(value)
	elseif type(value) == "number" then
		return ("%.4f"):format(value)
	end
	return native.typeof(value) .. "(" .. tostring(value) .. ")"
end

local function sortValue(object: Instance, key: string): string | number
	local value = object[key]
	if type(value) == "number" or type(value) == "string" then
		return value
	end
	return 0
end

local function snapshot(object: Instance, keys: { string }?, sortBy: string?): string
	local wanted: { string } = if keys ~= nil then table.clone(keys) else {}
	table.sort(wanted)
	local lines: { string } = {}
	local function walk(current: Instance, depth: number)
		local rendered: { string } = {}
		for _, key in wanted do
			local ok, value = pcall(function(): unknown
				return current[key]
			end)
			if ok and value ~= nil then
				table.insert(rendered, ("%s=%s"):format(key, render(value)))
			end
		end
		table.insert(lines, ("%s%s{%s}"):format(string.rep(" ", depth), current.ClassName, table.concat(rendered, ",")))
		local children = current:GetChildren()
		if sortBy ~= nil then
			local key = sortBy
			table.sort(children, function(left: Instance, right: Instance): boolean
				local leftKey, rightKey = sortValue(left, key), sortValue(right, key)
				if leftKey == rightKey then
					return left.Name < right.Name
				elseif type(leftKey) == "number" and type(rightKey) == "number" then
					return leftKey < rightKey
				end
				return tostring(leftKey) < tostring(rightKey)
			end)
		end
		for _, child in children do
			walk(child, depth + 1)
		end
	end
	walk(object, 0)
	return table.concat(lines, "\n")
end

local function create(load: <T>(path: string) -> T): Environment.Environment
	return {
		globals = globals,
		heartbeat = RunService.Heartbeat,
		container = function(): Instance
			local gui = native.Instance.new "ScreenGui"
			gui.Name = "Benchmark"
			gui.ResetOnSpawn = false
			gui.Parent = Players.LocalPlayer.PlayerGui
			return gui
		end,
		step = function(_delta: number)
			frame()
		end,
		drain = drain,
		counters = function(): Environment.Counters
			return Environment.zeroCounters()
		end,
		resetCounters = function() end,
		liveInstances = function(): number
			return 0
		end,
		liveConnections = function(): number
			return 0
		end,
		snapshot = snapshot,
		fire = function(_object: Instance, event: string)
			error("a script cannot fire the engine event " .. event, 0)
		end,
		diagnostics = function(): { string }
			return {}
		end,
		get = function(object: Instance, key: string): unknown
			return object[key]
		end,
		children = function(object: Instance): { Instance }
			return object:GetChildren()
		end,
		instance = function(value: unknown): Instance
			assert(native.typeof(value) == "Instance", "expected an Instance")
			local object: Instance = value :: Instance
			return object
		end,
		signal = function(object: Instance, event: string): Signal
			local signal: Signal = object[event] :: Signal
			return signal
		end,
		load = load,
		callback = function(value: unknown): (...unknown) -> ()
			assert(type(value) == "function", "event handler must be a function")
			local handler: (...unknown) -> () = value :: (...unknown) -> ()
			return handler
		end,
		entries = function(value: unknown): { [unknown]: unknown }
			assert(type(value) == "table", "children must be a table")
			local entries: { [unknown]: unknown } = value :: { [unknown]: unknown }
			return entries
		end,
	}
end

return { create = create, frame = frame, drain = drain }
