--!strict
--!nolint DeprecatedApi

local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../../.lute/dependencies/verify/src/roblox/datatypes"
local Types = require "../types"
local Motion = require "../motion"
local Input = require "./input"
local Settle = require "./settle"

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

local INPUT_SECONDS = 1 / 60

local frame = Settle(os.clock, function()
	PreRender:Wait()
	Heartbeat:Wait()
end)

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
	local guiService = node(native.game:GetService "GuiService")
	local input = Input {
		virtual = (
			(native.game:GetService "UserInputService" :: unknown) :: { CreateVirtualInput: (unknown) -> Input.Virtual }
		):CreateVirtualInput(),
		gui = guiService,
		input = node(native.game:GetService "UserInputService"),
		types = library,
		frame = function()
			frame(INPUT_SECONDS)
		end,
		inset = function(): (number, number)
			local inset = (guiService.GetGuiInset :: (Types.Node) -> { X: number, Y: number })(guiService)
			return inset.X, inset.Y
		end,
	}
	return {
		Facet = Facet,
		Compose = Facet.Compose,
		runtime = runtime,
		Host = runtime.constructors,
		UI = Facet.controls(runtime, nil),
		types = library,
		motion = Motion(Facet),
		toastDuration = 0.05,
		target = target,
		textService = node(native.game:GetService "TextService"),
		guiService = guiService,
		inputService = node(native.game:GetService "UserInputService"),
		tweenService = node(native.game:GetService "TweenService"),
		key = input.key,
		drag = input.drag,
		aim = input.aim,
		heartbeat = heartbeat,
		new = function(className: string): Types.Node
			return node(native.Instance.new(className))
		end,
		node = node,
		destroy = function(object: Types.Node)
			object:Destroy()
		end,
		frame = frame,
		spawn = function(callback: () -> ())
			native.task.spawn(callback)
		end,
		pin = function(object: Roblox.Instance, width: number, height: number)
			object.Size = library.UDim2.fromOffset(width, height)
		end,
		poke = input.poke,
		fire = input.fire,
		dispose = function()
			root.dispose()
			runtime:dispose()
			assert(#target:GetChildren() == 0, "the workload left mounted nodes")
			target:Destroy()
		end,
	}
end

return { create = create, frame = frame }
