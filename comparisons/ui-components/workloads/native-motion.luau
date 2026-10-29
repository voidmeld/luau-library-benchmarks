--!strict

local Types = require "../types"
local S = require "./support"

return {
	{
		id = "button-native-scale-50",
		iterations = 20,
		what = "Toggle a geometry state tag on 50 button faces. Both lanes use the same native StyleRule Scale transitions on an inner UIScale, with a stable hit target.",
		prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
			local buttons: { S.Node } = {}
			local scales: { S.Node } = {}
			local pressed = false
			local duration = 0.15
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
							world.UI.Text { text = `Action {i}` },
						},
					}
					S.tag(button, "bench-native-scale")
					buttons[i], scales[i] = button, scale
					table.insert(children, button)
				end
				return world.UI.Grid "NativeActions" { columns = 5, gap = 8, table.unpack(children) }
			end, function(screen)
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
					S.text(world, face, "Label", `Action {i}`)
					buttons[i], scales[i] = button, scale
				end
			end)
			local sheet = world.node(assert(S.find(world, "Comparison"):FindFirstChildWhichIsA "StyleSheet"))
			type Rule = {
				SetProperties: (Rule, { [string]: unknown }) -> (),
				SetPropertyTransitions: (Rule, { [string]: unknown }) -> (),
				GetProperties: (Rule) -> { [string]: unknown },
			}
			local rules: { Rule } = {}
			local info = world.types.TweenInfo.new(
				duration,
				world.types.Enum.EasingStyle.Cubic,
				world.types.Enum.EasingDirection.Out
			)
			for index, selector in
				{ ".bench-native-scale >> #FaceScale", ".bench-native-scale.bench-pressed >> #FaceScale" }
			do
				local rule = S.create(world, "StyleRule", "NativeScale" .. index, sheet)
				rule.Selector = selector
				local native = (rule :: unknown) :: Rule
				native:SetProperties { Scale = if index == 1 then 1 else 0.94 }
				native:SetPropertyTransitions { Scale = info }
				rules[index] = native
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
					world.frame(duration + 0.05)
				end,
				snapshot = function()
					local target = rules[if pressed then 2 else 1]:GetProperties().Scale
					for index, button in buttons do
						assert(button:HasTag "bench-pressed" == pressed, "native motion state differs")
						if world.key then
							type Styled = { GetStyled: (Styled, string) -> unknown }
							local scale = ((scales[index] :: unknown) :: Styled):GetStyled "Scale"
							assert(
								type(scale) == "number"
									and type(target) == "number"
									and math.abs(scale - target) < 0.001,
								"native geometry transition did not settle"
							)
						end
					end
					return `{pressed}:{target}:{#buttons}`
				end,
				stop = stop,
			}
		end,
	},
} :: { Types.Workload }
