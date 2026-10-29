--!strict

local Types = require "../types"
local S = require "./support"

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "phone-rotation-hub",
	iterations = 20,
	what = "Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local root: S.Node? = nil
		local stack: S.Node? = nil
		local layout: S.Node? = nil
		local stop = S.mount(world, lane, function()
			local Host, UI = world.Host, world.UI
			local viewport = Host.Frame { Name = "HubViewport", Size = world.types.UDim2.fromOffset(390, 844) }
			root = viewport
			local environment = UI.environment(viewport)
			local actions: { Types.Node } = {}
			for i = 1, 6 do
				table.insert(actions, UI.Button("HubAction" .. i) { label = `Task {i}`, onActivate = function() end })
			end
			stack = UI.AdaptiveStack "HubLayout" {
				axis = function(use: Types.Use)
					return if use(environment.isLandscape) then "x" else "y"
				end,
				gap = 8,
				UI.Card "Subject" {
					title = "Outpost",
					caption = "Level 12",
					Size = world.types.UDim2.fromOffset(240, 200),
					AutomaticSize = world.types.Enum.AutomaticSize.None,
				},
				UI.VStack "HubTasks" { width = 260, height = 120, UI.Text "Objective" { text = "Complete three tasks" } },
				UI.VStack "HubActions" { width = 240, gap = 8, table.unpack(actions) },
			}
			assert(stack).Parent = viewport
			return viewport
		end, function(screen)
			local viewport =
				S.create(world, "Frame", "HubViewport", screen, { Size = world.types.UDim2.fromOffset(390, 844) })
			root = viewport
			stack = S.stack(world, viewport, "HubLayout")
			assert(stack).Size = world.types.UDim2.fromScale(1, 0)
			assert(stack).AutomaticSize = world.types.Enum.AutomaticSize.Y
			layout = world.node(assert(assert(stack):FindFirstChild "Layout"))
			local subject = S.stack(world, assert(stack), "Subject")
			subject.Size = world.types.UDim2.fromOffset(240, 200)
			S.tag(subject, "facet-panel", "facet-card-body")
			S.text(world, subject, "Title", "Outpost", nil, "label")
			local caption = S.text(world, subject, "Caption", "Level 12", nil, "caption")
			S.tag(caption, "facet-secondary")
			local tasks = S.stack(world, assert(stack), "HubTasks")
			tasks.Size = world.types.UDim2.fromOffset(260, 120)
			S.text(world, tasks, "Objective", "Complete three tasks")
			local actions = S.stack(world, assert(stack), "HubActions")
			actions.Size = world.types.UDim2.fromOffset(240, 304)
			for i = 1, 6 do
				S.button(world, actions, "HubAction" .. i, `Task {i}`, function() end)
			end
			viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local size = S.vector2(world, viewport.AbsoluteSize)
				assert(layout).FillDirection = if size.X > size.Y
					then world.types.Enum.FillDirection.Horizontal
					else world.types.Enum.FillDirection.Vertical
			end)
		end)
		local viewport = assert(root)
		world.pin(viewport, 390, 844)
		local retained: { S.Node } = {}
		for i = 1, 6 do
			retained[i] = S.find(world, "HubAction" .. i)
		end
		if layout == nil then
			layout = world.node(assert(assert(stack):FindFirstChildWhichIsA "UIListLayout"))
		end
		return {
			step = function(index: number)
				world.pin(viewport, if index % 2 == 1 then 844 else 390, if index % 2 == 1 then 390 else 844)
				world.frame()
			end,
			snapshot = function()
				for i, node in retained do
					assert(node == S.find(world, "HubAction" .. i), "rotation replaced a retained action")
				end
				return tostring(assert(layout).FillDirection)
					.. "\n"
					.. S.snapshot(world, { "Objective", "HubAction1", "HubAction6" })
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "hud-composition-step-down",
	iterations = 20,
	what = "Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the form that fits and restore the rich form on expansion.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local forms: { S.Node } = {}
		local root: S.Node? = nil
		local region: S.Node? = nil
		local stop = S.mount(world, lane, function()
			local Host, UI = world.Host, world.UI
			forms[1] = Host.Frame {
				Name = "RichStatus",
				Size = world.types.UDim2.fromOffset(600, 64),
				UI.Text { text = "Health 100 | Ammo 30 | Shield 50" },
			}
			forms[2] = Host.Frame {
				Name = "CompactStatus",
				Size = world.types.UDim2.fromOffset(200, 64),
				UI.Text { text = "100 / 30 / 50" },
			}
			region = UI.Region "Status" { zone = "top", rank = 1, reveal = false, forms[1], forms[2] }
			root = UI.Composition "AdaptiveHUD" {
				topbar = false,
				gap = 8,
				padding = 0,
				assert(region),
				Size = world.types.UDim2.fromOffset(800, 480),
			}
			return assert(root)
		end, function(screen)
			root = S.create(world, "Frame", "AdaptiveHUD", screen, { Size = world.types.UDim2.fromOffset(800, 480) })
			region = S.create(world, "Frame", "Status", assert(root))
			for index, width in { 600, 200 } do
				local form = S.create(
					world,
					"Frame",
					"Form" .. index,
					assert(region),
					{ Size = world.types.UDim2.fromOffset(width, 64) }
				)
				forms[index] = form
				S.text(
					world,
					form,
					if index == 1 then "RichStatus" else "CompactStatus",
					if index == 1 then "Health 100 | Ammo 30 | Shield 50" else "100 / 30 / 50"
				)
				form.Visible = index == 1
			end
			assert(region):SetAttribute("FacetForm", 1)
			assert(root):GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local width = S.vector2(world, assert(root).AbsoluteSize).X
				local selected = if width >= 600 then 1 else 2
				for index, form in forms do
					form.Visible = index == selected
				end
				assert(region):SetAttribute("FacetForm", selected)
			end)
		end)
		for index, form in forms do
			world.pin(form, if index == 1 then 600 else 200, 64)
		end
		local viewport = assert(root)
		local zones = if lane == "facet" then world.node(assert(viewport:FindFirstChild "Zones")) else viewport
		local function resize(width: number)
			world.pin(viewport, width, 480)
			if zones ~= viewport and world.key == nil then
				world.pin(zones, width, 480)
			end
			for _ = 1, 30 do
				world.frame()
			end
		end
		resize(800)
		return {
			step = function(index: number)
				resize(if index % 2 == 1 then 400 else 800)
			end,
			snapshot = function()
				local selected = assert(region):GetAttribute "FacetForm"
				local shown: { string } = {}
				for index = 1, 2 do
					local holder = assert(assert(region):FindFirstChild("Form" .. index))
					assert(forms[index]:IsDescendantOf(assert(region)), "HUD form was replaced")
					table.insert(shown, tostring(holder.Visible))
				end
				return tostring(selected) .. ":" .. table.concat(shown, ",")
			end,
			stop = stop,
		}
	end,
})

return workloads
