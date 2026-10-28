--!strict

local BareSupport = require "./bare-support"
local Types = require "./types"

local Core = require "../../../.lute/dependencies/compose/src/core"
local Environment = require "../cost-model"
type ComposeContext = Types.ComposeContext
type BareContext = Types.BareContext
type WorldState = {
	dispose: () -> (),
	tide: Core.Value<number>,
	daylight: Core.Value<boolean>,
	tick: number,
	runtime: Core.Runtime,
}
type WorldBare = {
	made: { Environment.Instance },
	parts: { Environment.Instance },
	Vector3: Environment.Vector3Factory,
	tick: number,
}
type Empty = {}
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
		compose = Types.compose {
			prepare = function(context: ComposeContext): WorldState
				local Compose = context.library
				local Host = context.extras.runtime.constructors
				local Vector3 = context.env.globals.Vector3
				local tide = Compose.cell(0)
				local daylight = Compose.cell(true)

				local dispose = context.extras.runtime.mount(function()
					local createChildren: (number, Core.Node?) -> { Core.Node } = table.create
					local children: { Core.Node } = createChildren(PROPS)
					for index = 1, PROPS do
						children[index] = Host.Part {
							Name = "prop" .. tostring(index),
							Position = function(use: Core.Use)
								return Vector3.new(index, use(tide), 0)
							end,
							Transparency = function(use: Core.Use)
								return if use(daylight) then 0 else 0.5
							end,
						}
					end
					return Host.Model(children)
				end, context.container)

				return {
					dispose = dispose,
					tide = tide,
					daylight = daylight,
					tick = 0,
					runtime = context.extras.runtime,
				}
			end,
			run = function(state: WorldState, _context: ComposeContext)
				state.tick += 1
				local tick = state.tick
				state.runtime:batch(function()
					state.tide:set(tick)
					state.daylight:set(tick % 2 == 0)
				end)
			end,
			snapshot = function(_state: WorldState, context: ComposeContext): string
				return context.env.snapshot(context.container, { "Name", "Position", "Transparency" })
			end,
			release = function(state: WorldState, _context: ComposeContext)
				state.dispose()
			end,
		},
		bare = Types.bare {
			prepare = function(context: BareContext): WorldBare
				local Instance = BareSupport.instances(context)
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
			run = function(state: WorldBare, _context: BareContext)
				state.tick += 1
				local tide = state.tick
				local transparency = if state.tick % 2 == 0 then 0 else 0.5
				local Vector3 = state.Vector3
				for index, part in state.parts do
					part.Position = Vector3.new(index, tide, 0)
					part.Transparency = transparency
				end
			end,
			snapshot = function(_state: WorldBare, context: BareContext): string
				return context.env.snapshot(context.container, { "Name", "Position", "Transparency" })
			end,
			release = function(state: WorldBare, _context: BareContext)
				BareSupport.destroyAll(state.made)
			end,
		},
	},
	unsupported = {},
}

return {
	scene3d,
}
