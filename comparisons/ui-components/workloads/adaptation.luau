--!strict

local Types = require "../types"
local Roblox = require "../../../.lute/dependencies/verify/src/roblox"
local S = require "./support"
local Theme = require "./plain-theme"

local workloads: { Types.Workload } = {}
local LAYOUT_FRAMES = 2
local SETTLE_FRAMES = 30
local POP_FRAMES = 2
local POP = "hud-region-pop"
local REST = "hud-region-rest"

local HUB = {
	"HubViewport",
	"HubLayout",
	"Subject",
	"Body",
	"Title",
	"Caption",
	"HubTasks",
	"Objective",
	"HubActions",
	"HubAction1",
	"HubAction2",
	"HubAction3",
	"HubAction4",
	"HubAction5",
	"HubAction6",
}

local FORMS = {
	{ name = "RichStatus", label = "RichLabel", width = 600, text = "Health 100 | Ammo 30 | Shield 50" },
	{ name = "CompactStatus", label = "CompactLabel", width = 200, text = "100 / 30 / 50" },
}

local STATUS = { "AdaptiveHUD", "Status", "RichStatus", "RichLabel", "CompactStatus", "CompactLabel" }

local function hug(world: Types.Engine, parent: S.Node, name: string): S.Node
	return S.create(world, "Frame", name, parent, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = world.types.UDim2.new(),
		AutomaticSize = world.types.Enum.AutomaticSize.XY,
	})
end

table.insert(workloads, {
	id = "phone-rotation-hub",
	iterations = 20,
	what = "Rotate a retained hub between 390 by 844 and 844 by 390 layout units. Turn its subject, task list and action column without remounting the controls.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local root: S.Node? = nil
		local stop = S.mount(world, lane, function()
			local Host, UI = world.Host, world.UI
			local viewport = Host.Frame { Name = "HubViewport", Size = world.types.UDim2.fromOffset(390, 844) }
			root = viewport
			local environment = UI.environment(viewport)
			local actions: { Types.Node } = {}
			for i = 1, 6 do
				table.insert(actions, UI.Button("HubAction" .. i) { label = `Task {i}`, onActivate = function() end })
			end
			local stack = UI.AdaptiveStack "HubLayout" {
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
			stack.Parent = viewport
			return viewport
		end, function(screen)
			local viewport =
				S.create(world, "Frame", "HubViewport", screen, { Size = world.types.UDim2.fromOffset(390, 844) })
			root = viewport
			local hub = S.stack(world, viewport, "HubLayout", false, { gap = 8 })
			local layout = assert(hub:FindFirstChild "Layout")
			local subject = S.create(world, "Frame", "Subject", hub, { Size = world.types.UDim2.fromOffset(240, 200) })
			S.tag(subject, Theme.tags.panel, Theme.tags.flush)
			local body = S.stack(world, subject, "Body", false, { fill = true, gap = Theme.card.gap })
			S.cardText(world, body, "Title", "Outpost", "label", Theme.card.inset, 0)
			S.tag(S.cardText(world, body, "Caption", "Level 12", "caption", 0, Theme.card.inset), Theme.tags.secondary)
			local tasks = S.stack(world, hub, "HubTasks", false, { width = 260, height = 120 })
			S.fill(world, S.text(world, tasks, "Objective", "Complete three tasks"))
			local actions = S.stack(world, hub, "HubActions", false, { width = 240, gap = 8 })
			for i = 1, 6 do
				S.button(world, actions, "HubAction" .. i, `Task {i}`, function() end)
			end
			local function orient()
				local size = S.vector2(world, viewport.AbsoluteSize)
				layout.FillDirection = if size.X > size.Y
					then world.types.Enum.FillDirection.Horizontal
					else world.types.Enum.FillDirection.Vertical
			end
			viewport:GetPropertyChangedSignal("AbsoluteSize"):Connect(orient)
			orient()
		end)
		local viewport = assert(root)
		world.pin(viewport, 390, 844)
		local retained: { S.Node } = {}
		for i = 1, 6 do
			retained[i] = S.find(world, "HubAction" .. i)
		end
		return {
			step = function(index: number)
				world.pin(viewport, if index % 2 == 1 then 844 else 390, if index % 2 == 1 then 390 else 844)
				S.frames(world, LAYOUT_FRAMES)
			end,
			snapshot = function()
				for i, node in retained do
					assert(node == S.find(world, "HubAction" .. i), "rotation replaced a retained action")
				end
				return S.observe(world, HUB)
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "hud-composition-step-down",
	iterations = 20,
	what = "Resize a HUD from 800 to 400 layout units. Keep rich and compact status forms mounted, choose the richest form that fits, pop the new form in and restore the rich form on expansion.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local forms: { S.Node } = {}
		local root: S.Node? = nil
		local region: S.Node? = nil
		local resting: Roblox.Connection? = nil
		local stop = S.mount(world, lane, function()
			local Host, UI = world.Host, world.UI
			for index, form in FORMS do
				forms[index] = Host.Frame {
					Name = form.name,
					Size = world.types.UDim2.fromOffset(form.width, 64),
					UI.Text(form.label) { text = form.text },
				}
			end
			region = UI.Region "Status" { zone = "top", rank = 1, reveal = false, forms[1], forms[2] }
			root = UI.Composition "AdaptiveHUD" {
				topbar = false,
				gap = 8,
				padding = 0,
				assert(region),
				Size = world.types.UDim2.fromOffset(800, 480),
			}
			return assert(root)
		end, function(screen, sheet)
			local styles = assert(sheet)
			Theme.rule(world, styles, "." .. POP, { Scale = 1 }, "pop")
			Theme.rule(world, styles, `.{POP}.{REST}`, { Scale = Theme.pop.rest }, "instant")
			local hud = S.blank(world, "AdaptiveHUD", screen, world.types.UDim2.fromOffset(800, 480))
			root = hud
			local zone = S.stack(world, hud, "TopZone", true, { gap = 8 })
			zone.AnchorPoint = world.types.Vector2.new(0.5, 0)
			zone.Position = world.types.UDim2.fromScale(0.5, 0)
			zone.ZIndex = 2
			local flow = assert(zone:FindFirstChild "Layout")
			flow.Wraps = true
			flow.HorizontalAlignment = world.types.Enum.HorizontalAlignment.Center
			flow.ItemLineAlignment = world.types.Enum.ItemLineAlignment.Start
			local status = hug(world, zone, "Status")
			region = status
			local pop = S.create(world, "UIScale", "Pop", status)
			pop:AddTag(POP)
			local holders: { S.Node } = {}
			for index, form in FORMS do
				local holder = hug(world, status, "Form" .. index)
				holder.Visible = index == 1
				holders[index] = holder
				local frame =
					S.create(world, "Frame", form.name, holder, { Size = world.types.UDim2.fromOffset(form.width, 64) })
				S.fill(world, S.text(world, frame, form.label, form.text))
				forms[index] = frame
			end
			local selected = 1
			local function popIn()
				if S.reduced(world) then
					return
				end
				pop:AddTag(REST)
				if resting then
					resting:Disconnect()
				end
				resting = world.heartbeat:Once(function()
					resting = nil
					pop:RemoveTag(REST)
				end)
			end
			hud:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				local room = S.vector2(world, hud.AbsoluteSize).X
				local scale: unknown = pop:GetStyled "Scale"
				local factor = if type(scale) == "number" and scale > 0 then scale else 1
				local chosen = #forms
				for index, frame in forms do
					if S.vector2(world, frame.AbsoluteSize).X / factor <= room then
						chosen = index
						break
					end
				end
				if chosen ~= selected then
					holders[selected].Visible = false
					holders[chosen].Visible = true
					selected = chosen
					popIn()
				end
			end)
		end)
		local viewport = assert(root)
		local status = assert(region)
		local popping: { unknown } = {}
		local zones: S.Node? = nil
		if not world.layout then
			for index, form in forms do
				world.pin(form, FORMS[index].width, 64)
			end
			if lane == "facet" then
				zones = world.node(assert(viewport:FindFirstChild("Zones", true)))
			end
		end
		local function resize(width: number)
			world.pin(viewport, width, 480)
			if zones then
				world.pin(zones, width, 480)
			end
			S.frames(world, POP_FRAMES, S.FRAME)
			popping[1], popping[2] = status.AbsolutePosition, status.AbsoluteSize
			S.frames(world, SETTLE_FRAMES - POP_FRAMES, S.FRAME)
		end
		resize(800)
		return {
			step = function(index: number)
				resize(if index % 2 == 1 then 400 else 800)
			end,
			snapshot = function()
				for _, form in forms do
					assert(form:IsDescendantOf(assert(region)), "HUD form was replaced")
				end
				local settled = S.observe(world, STATUS)
				if not S.simulated(world) then
					return settled
				end
				local at, size = S.vector2(world, popping[1]), S.vector2(world, popping[2])
				return `{settled}\npopping={string.format("%.2f,%.2f %.2fx%.2f", at.X, at.Y, size.X, size.Y)}`
			end,
			stop = function()
				if resting then
					resting:Disconnect()
					resting = nil
				end
				stop()
			end,
		}
	end,
})

return workloads
