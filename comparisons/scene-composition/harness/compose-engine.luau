--!strict

local ComposeRoblox = require "../../../.lute/dependencies/compose/src/roblox"
local Environment = require "../cost-model"
local Engine = require "../../../.lute/dependencies/compose/src/roblox/engine"

local function engineFor(environment: Environment.Environment): ComposeRoblox.Engine
	local globals = environment.globals
	local instances = globals.Instance
	local heartbeat: ComposeRoblox.Signal<number> = {
		Connect = function(_self: ComposeRoblox.Signal<number>, handler: (number) -> ()): ComposeRoblox.Connection
			return environment.heartbeat:Connect(function(delta: unknown)
				assert(type(delta) == "number")
				handler(delta)
			end)
		end,
	}

	return {
		new = function(className: string)
			return instances.new(className)
		end,
		heartbeat = heartbeat,
		clock = globals.os.clock,
		typeName = globals.typeof,
		destroy = function(object: unknown)
			environment.instance(object):Destroy()
		end,
		propertyChanged = function(object: unknown, property: string)
			return environment.instance(object):GetPropertyChangedSignal(property)
		end,
		datatypes = {
			Vector2 = globals.Vector2.new,
			Vector3 = globals.Vector3.new,
			Color3 = globals.Color3.new,
			UDim = globals.UDim.new,
			UDim2 = globals.UDim2.new,
			CFrame = function(position: Engine.Vector3, _rotation: { number })
				return globals.CFrame.new(globals.Vector3.new(position.X, position.Y, position.Z))
			end,
		},
		readCFrame = function(value: Engine.CFrame): (number, number, number, { number })
			local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = value:GetComponents()
			return x, y, z, { r00, r01, r02, r10, r11, r12, r20, r21, r22 }
		end,
	}
end

return {
	engineFor = engineFor,
}
