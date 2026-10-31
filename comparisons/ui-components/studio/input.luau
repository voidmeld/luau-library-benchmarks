--!strict

local Types = require "../types"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local Datatypes = require "../../../.lute/dependencies/verify/src/roblox/datatypes"

export type Virtual = {
	SendMousePosition: (Virtual, unknown) -> (),
	SendMouseButton: (Virtual, unknown, unknown, boolean, number) -> (),
	SendKey: (Virtual, boolean, unknown, boolean) -> (),
}
export type Services = {
	virtual: Virtual,
	gui: Types.Node,
	input: Types.Node?,
	inset: () -> (number, number),
	frame: () -> (),
	types: Datatypes.Library,
}

return function(services: Services)
	local virtual, gui, types = services.virtual, services.gui, services.types
	local emulated: { [unknown]: unknown } = {
		[types.Enum.KeyCode.DPadDown] = types.Enum.KeyCode.Three,
		[types.Enum.KeyCode.DPadLeft] = types.Enum.KeyCode.Two,
		[types.Enum.KeyCode.DPadRight] = types.Enum.KeyCode.Four,
	}
	local function point(object: Roblox.Instance): (number, number)
		local at = object.AbsolutePosition :: { X: number, Y: number }
		local size = object.AbsoluteSize :: { X: number, Y: number }
		local x, y = services.inset()
		assert(size.X > 0 and size.Y > 0, "input target has no measured area: " .. tostring(object.Name))
		return at.X + size.X / 2 + x, at.Y + size.Y / 2 + y
	end
	local function move(x: number, y: number)
		virtual:SendMousePosition(types.Vector2.new(x, y))
		services.frame()
	end
	local function mouse(x: number, y: number, down: boolean)
		virtual:SendMouseButton(types.Vector2.new(x, y), types.Enum.UserInputType.MouseButton1, down, 1)
		services.frame()
	end
	local function key(code: unknown)
		local physical = emulated[code] or code
		local name = tostring(code)
		local gamepad = string.find(name, "DPad", 1, true) ~= nil or string.find(name, "Button", 1, true) ~= nil
		local received = false
		local input = if gamepad then services.input else nil
		local connection = if input
			then (input.InputBegan :: Roblox.Signal<unknown>):Connect(function(event: unknown)
				local facts = event :: { KeyCode: unknown, UserInputType: unknown }
				if facts.KeyCode == code and facts.UserInputType == types.Enum.UserInputType.Gamepad1 then
					received = true
				end
			end)
			else nil
		local ok, problem = pcall(function()
			virtual:SendKey(true, physical, false)
			services.frame()
			virtual:SendKey(false, physical, false)
			services.frame()
		end)
		if connection then
			connection:Disconnect()
		end
		assert(ok, tostring(problem))
		assert(input == nil or received, "native input did not deliver " .. tostring(code))
	end
	local function reveal(object: Roblox.Instance)
		local parent = object.Parent
		while parent do
			if parent:IsA "ScrollingFrame" then
				local at = object.AbsolutePosition :: { X: number, Y: number }
				local origin = parent.AbsolutePosition :: { X: number, Y: number }
				local canvas = parent.CanvasPosition :: { X: number, Y: number }
				parent.CanvasPosition = types.Vector2.new(canvas.X, math.max(0, canvas.Y + at.Y - origin.Y))
				services.frame()
			end
			parent = parent.Parent
		end
	end
	return {
		key = key,
		drag = function(source: Types.Node, target: Types.Node)
			reveal(source)
			local x, y = point(source)
			local toX, toY = point(target)
			move(x, y)
			mouse(x, y, true)
			for index = 1, 8 do
				move(x + (toX - x) * index / 8, y + (toY - y) * index / 8)
			end
			mouse(toX, toY, false)
		end,
		fire = function(object: Roblox.Instance, event: string, ...: unknown)
			if event == "Focused" and object:IsA "TextBox" then
				(object.CaptureFocus :: (Roblox.Instance) -> ())(object)
				return
			end
			assert(event == "Activated" and object:IsA "GuiButton", "unsupported native input event " .. event)
			reveal(object)
			local input = ...
			local facts = if type(input) == "table" then input :: { UserInputType: unknown, KeyCode: unknown? } else nil
			if
				facts
				and (
					facts.UserInputType == types.Enum.UserInputType.Gamepad1
					or facts.UserInputType == types.Enum.UserInputType.Keyboard
				)
			then
				gui.SelectedObject = object
				services.frame()
				services.frame()
				key(facts.KeyCode or types.Enum.KeyCode.Return)
			else
				local x, y = point(object)
				move(x, y)
				mouse(x, y, true)
				mouse(x, y, false)
			end
		end,
		poke = function(object: Roblox.Instance, property: string, value: unknown)
			assert(property == "GuiState", "unsupported native input property " .. property)
			local x, y = point(object)
			if value == types.Enum.GuiState.Hover then
				move(x, y)
			elseif value == types.Enum.GuiState.Press then
				mouse(x, y, true)
			elseif value == types.Enum.GuiState.Idle then
				mouse(x, y, false)
				move(1, 1)
			else
				error("unsupported GuiState", 0)
			end
			assert(object.GuiState == value, "native input did not reach " .. tostring(object.Name))
		end,
	}
end
