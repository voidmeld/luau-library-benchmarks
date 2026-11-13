--!strict
--!nolint DeprecatedApi

local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../../.lute/dependencies/verify/src/roblox/datatypes"
local Types = require "../types"
local Motion = require "../motion"
local Input = require "./input"
local Settle = require "./settle"
local LibraryFree = require "../library-free"

type Frame = { Wait: (Frame) -> number }
type Point = { X: number, Y: number }
type Native = {
	game: {
		GetService: ((unknown, "RunService") -> { PreRender: Frame, Heartbeat: Frame & Roblox.Signal<number> })
			& ((unknown, "Players") -> { LocalPlayer: Roblox.Instance? })
			& ((unknown, "GuiService") -> Types.Node & { GetGuiInset: (Types.Node) -> Point })
			& ((
				unknown,
				"UserInputService"
			) -> Types.Node & { CreateVirtualInput: (unknown) -> Input.Virtual })
			& ((unknown, string) -> Roblox.Instance),
	},
	Instance: { new: (string) -> Roblox.Instance },
	task: { spawn: (() -> ()) -> unknown },
}

local native: Native = getfenv(0)
local library: Datatypes.Library = getfenv(0)
local RunService = native.game:GetService "RunService"
local Players = native.game:GetService "Players"
local PreRender: Frame = RunService.PreRender
local Heartbeat: Frame = RunService.Heartbeat
local heartbeat: Roblox.Signal<number> = RunService.Heartbeat

local function node(object: Roblox.Instance): Types.Node
	return object :: Types.Node
end

local INPUT_SECONDS = 1 / 60

local frame = Settle(os.clock, function()
	PreRender:Wait()
	Heartbeat:Wait()
end)

local function create(Facet: Types.Facet?): Types.World
	local player = assert(Players.LocalPlayer, "the Studio run needs a client")
	local gui = assert(player:FindFirstChildOfClass "PlayerGui", "the client has no PlayerGui")
	local target = node(native.Instance.new "Folder")
	target.Name = "UiComponents"
	target.Parent = gui
	local guiService = native.game:GetService "GuiService"
	local userInput = native.game:GetService "UserInputService"
	local input = Input {
		virtual = userInput:CreateVirtualInput(),
		gui = guiService,
		input = node(native.game:GetService "UserInputService"),
		root = target,
		types = library,
		frame = function()
			frame(INPUT_SECONDS)
		end,
		inset = function(): (number, number)
			local inset = guiService.GetGuiInset(guiService)
			return inset.X, inset.Y
		end,
	}
	local camera = native.game:GetService "Workspace" :: Roblox.Instance & { CurrentCamera: { ViewportSize: Point } }
	local viewport = camera.CurrentCamera.ViewportSize
	input.park(viewport.X - 2, viewport.Y - 2)
	local release: () -> () = function() end
	local fields: Types.Engine = {
		types = library,
		layout = true,
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
			release()
			assert(#target:GetChildren() == 0, "the workload left mounted nodes")
			target:Destroy()
		end,
	}
	if Facet == nil then
		return LibraryFree.libraryFree(fields)
	end
	local runtime = Facet.Roblox.createRuntime(nil)
	local root = Facet.Compose.createRootOwner(function()
		runtime.adopt(target)
	end, runtime.reactor)
	release = function()
		root.dispose()
		runtime:dispose()
	end
	return LibraryFree.withLibrary(fields, {
		Facet = Facet,
		Compose = Facet.Compose,
		runtime = runtime,
		Host = runtime.constructors,
		UI = Facet.controls(runtime, nil),
		motion = Motion(Facet),
	})
end

return { create = create, frame = frame }
