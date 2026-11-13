--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"

local PROBE_FRAMES = 3
local OBSERVED = { "NativeActions", "NativeAction1", "Face", "Label", "NativeAction50" }

local function scaleOf(node: S.Node): number
	local value: unknown = node:GetStyled "Scale"
	assert(type(value) == "number", "FaceScale needs a styled Scale")
	return value
end

local workloads: { Types.Workload } = {
	{
		id = "button-native-scale-50",
		iterations = 6,
		what = "Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.",
		prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
			local buttons: { S.Node } = {}
			local scales: { S.Node } = {}
			local rules: { S.Node } = {}
			local pressed = false
			local moving = { 1, 1 }
			local stop = S.mount(world, lane, function()
				local children: { Types.Node } = {}
				for i = 1, 50 do
					local scale = world.Host.UIScale { Name = "FaceScale" }
					local button = world.UI.Button("NativeAction" .. i) {
						label = "",
						onActivate = function() end,
						world.Host.Frame {
							Name = "Face",
							Size = world.types.UDim2.fromScale(1, 1),
							BackgroundTransparency = 1,
							scale,
							world.UI.Text "Label" { text = `Action {i}` },
						},
					}
					S.tag(button, "bench-native-scale")
					buttons[i], scales[i] = button, scale
					table.insert(children, button)
				end
				return world.UI.Grid "NativeActions" { columns = 5, gap = 8, table.unpack(children) }
			end, function(screen, sheet)
				local styles = assert(sheet)
				rules[1] = Theme.rule(world, styles, ".bench-native-scale >> #FaceScale", { Scale = 1 }, "pop")
				rules[2] = Theme.rule(
					world,
					styles,
					".bench-native-scale.bench-pressed >> #FaceScale",
					{ Scale = Theme.pop.rest },
					"pop"
				)
				local root = S.grid(world, screen, "NativeActions", 5)
				for i = 1, 50 do
					local button = S.button(world, root, "NativeAction" .. i, "", function() end)
					S.tag(button, "bench-native-scale")
					local face = S.create(
						world,
						"Frame",
						"Face",
						button,
						{ Size = world.types.UDim2.fromScale(1, 1), BackgroundTransparency = 1 }
					)
					local scale = S.create(world, "UIScale", "FaceScale", face)
					S.fill(world, S.text(world, face, "Label", `Action {i}`))
					buttons[i], scales[i] = button, scale
				end
			end)
			if lane == "facet" then
				local sheet = world.node(assert(S.find(world, "Comparison"):FindFirstChildWhichIsA "StyleSheet"))
				local info = world.types.TweenInfo.new(
					Theme.pop.seconds,
					world.types.Enum.EasingStyle.Cubic,
					world.types.Enum.EasingDirection.Out
				)
				for index, selector in
					{ ".bench-native-scale >> #FaceScale", ".bench-native-scale.bench-pressed >> #FaceScale" }
				do
					local rule = S.create(world, "StyleRule", "NativeScale" .. index, sheet)
					rule.Selector = selector
					rule.Priority = 10000 + index
					rule:SetProperties { Scale = if index == 1 then 1 else Theme.pop.rest }
					rule:SetPropertyTransitions { Scale = info }
					rules[index] = rule
				end
			end
			return {
				step = function(index: number)
					pressed = index % 2 == 1
					for _, button in buttons do
						if pressed then
							button:AddTag "bench-pressed"
						else
							button:RemoveTag "bench-pressed"
						end
					end
					S.frames(world, PROBE_FRAMES, S.FRAME)
					moving[1], moving[2] = scaleOf(scales[1]), scaleOf(scales[#scales])
					S.settle(world, Theme.pop.seconds)
				end,
				snapshot = function()
					local target = rules[if pressed then 2 else 1]:GetProperties().Scale
					assert(type(target) == "number", "the scale rule needs a numeric goal")
					for index, button in buttons do
						assert(button:HasTag "bench-pressed" == pressed, "native motion state differs")
						assert(
							math.abs(scaleOf(scales[index]) - target) < 0.001,
							"native geometry transition did not settle"
						)
					end
					local settled = `{pressed}:{target}:{#buttons}\n{S.observe(world, OBSERVED)}`
					return if S.simulated(world)
						then `{settled}\nmoving={string.format("%.4f,%.4f", moving[1], moving[2])}`
						else settled
				end,
				stop = stop,
			}
		end,
	},
}

return workloads
