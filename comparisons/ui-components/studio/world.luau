--!strict
--!nolint DeprecatedApi

local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../../.lute/dependencies/verify/src/roblox/datatypes"
local Types = require "../types"
local Motion = require "../motion"

type Frame = { Wait: (Frame) -> number }
type Native = {
	game: { GetService: (unknown, string) -> Roblox.Instance },
	Instance: { new: (string) -> Roblox.Instance },
	task: { spawn: (() -> ()) -> unknown },
}

local native: Native = getfenv(0)
local library: Datatypes.Library = getfenv(0)
local RunService = native.game:GetService "RunService"
local Players = native.game:GetService "Players"
local PreRender: Frame = RunService.PreRender :: Frame
local Heartbeat: Frame = RunService.Heartbeat :: Frame
local heartbeat: Roblox.Signal<number> = RunService.Heartbeat :: Roblox.Signal<number>

local function node(object: Roblox.Instance): Types.Node
	return object :: Types.Node
end

local function frame()
	PreRender:Wait()
	Heartbeat:Wait()
end

local function create(Facet: Types.Facet): Types.World
	local player = assert(Players.LocalPlayer :: Roblox.Instance?, "the Studio run needs a client")
	local gui = assert(player:FindFirstChildOfClass "PlayerGui", "the client has no PlayerGui")
	local target = node(native.Instance.new "Folder")
	target.Name = "UiComponents"
	target.Parent = gui
	local runtime = Facet.Roblox.createRuntime(nil)
	local root = Facet.Compose.createRootOwner(function()
		runtime.adopt(target)
	end, runtime.reactor)
	return {
		Facet = Facet,
		Compose = Facet.Compose,
		runtime = runtime,
		Host = runtime.constructors,
		UI = Facet.controls(runtime, nil),
		types = library,
		motion = Motion(Facet),
		target = target,
		textService = node(native.game:GetService "TextService"),
		guiService = node(native.game:GetService "GuiService"),
		heartbeat = heartbeat,
		new = function(className: string): Types.Node
			return node(native.Instance.new(className))
		end,
		node = node,
		destroy = function(object: Types.Node)
			object:Destroy()
		end,
		frame = function(_seconds: number?)
			frame()
		end,
		spawn = function(callback: () -> ())
			native.task.spawn(callback)
		end,
		pin = function(object: Roblox.Instance, width: number, height: number)
			object.Size = library.UDim2.fromOffset(width, height)
		end,
		poke = function(_object: Roblox.Instance, key: string, _value: unknown)
			error("a script cannot set the engine property " .. key, 0)
		end,
		fire = function(object: Roblox.Instance, event: string, ...: unknown)
			if event == "Focused" and object:IsA "TextBox" then
				local capture = object.CaptureFocus :: (Roblox.Instance) -> ()
				capture(object)
				return
			end
			error("a script cannot fire the engine event " .. event, 0)
		end,
		dispose = function()
			root.dispose()
			runtime:dispose()
			assert(#target:GetChildren() == 0, "the workload left mounted nodes")
			target:Destroy()
		end,
	}
end

return { create = create, frame = frame }
