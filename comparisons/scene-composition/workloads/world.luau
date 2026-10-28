--!strict

local PlainSupport = require "./plain-support"
local Types = require "./types"

local Environment = require "../cost-model"
type PlainContext = Types.PlainContext
type WorldPlain = {
	made: { Environment.Instance },
	parts: { Environment.Instance },
	Vector3: Environment.Vector3Factory,
	tick: number,
}
type Workload = Types.Workload

local PROPS = 150

local scene3d: Workload = {
	id = "scene-3d",
	title = "3D scene with reactive transforms and visibility",
	what = ("%d world props whose position, rotation-free transform, and visibility all follow one "):format(PROPS)
		.. "advancing world value. Measures datatype property churn rather than text, and confirms a "
		.. "hidden prop costs nothing to keep hidden.",
	samples = 20,
	iterations = 20,
	warmup = 5,
	cases = {
		plain = Types.plain {
			prepare = function(context: PlainContext): WorldPlain
				local Instance = PlainSupport.instances(context)
				local Vector3 = context.env.globals.Vector3
				local model = Instance.new "Model"
				local createMade: (number, Environment.Instance?) -> { Environment.Instance } = table.create
				local made: { Environment.Instance } = createMade(PROPS + 1)
				made[1] = model
				local createParts: (number, Environment.Instance?) -> { Environment.Instance } = table.create
				local parts: { Environment.Instance } = createParts(PROPS)
				for index = 1, PROPS do
					local part = Instance.new "Part"
					part.Name = "prop" .. tostring(index)
					part.Position = Vector3.new(index, 0, 0)
					part.Transparency = 0
					part.Parent = model
					made[index + 1] = part
					parts[index] = part
				end
				model.Parent = context.container
				return { made = made, parts = parts, Vector3 = Vector3, tick = 0 }
			end,
			run = function(state: WorldPlain, _context: PlainContext)
				state.tick += 1
				local tide = state.tick
				local transparency = if state.tick % 2 == 0 then 0 else 0.5
				local Vector3 = state.Vector3
				for index, part in state.parts do
					part.Position = Vector3.new(index, tide, 0)
					part.Transparency = transparency
				end
			end,
			snapshot = function(_state: WorldPlain, context: PlainContext): string
				return context.env.snapshot(context.container, { "Name", "Position", "Transparency" })
			end,
			release = function(state: WorldPlain, _context: PlainContext)
				PlainSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

return {
	scene3d,
}
