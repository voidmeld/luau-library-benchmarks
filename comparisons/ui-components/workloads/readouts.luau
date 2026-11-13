--!strict

local Types = require "../types"
local S = require "./support"
local Theme = require "./plain-theme"
type FolderProps = Types.Props

local workloads: { Types.Workload } = {}

local function workspaceOf(world: Types.Engine): S.Node
	local game = world.target:FindFirstAncestorOfClass "DataModel"
	local found = if game then game:FindFirstChildOfClass "Workspace" else nil
	return world.node(found or world.target)
end

local function anchorAt(world: Types.Engine, index: number): unknown
	return world.types.Vector3.new(((index - 1) % 10) * 6, 4 + math.floor((index - 1) / 10) * 4, 0)
end

local MENU = { "Menu", "Title", "Play", "Inventory", "Shop", "Settings", "Credits", "Exit", "Footer" }

table.insert(workloads, {
	id = "main-menu-cold",
	iterations = 1,
	what = "Install the theme StyleSheet and mount a surface with a title, six actions and a footer; runtime and control-factory setup is excluded.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local labels = { "Play", "Inventory", "Shop", "Settings", "Credits", "Exit" }
		local stop: () -> () = function() end
		return {
			step = function()
				stop = S.mount(world, lane, function()
					local UI = world.UI
					local children: { Types.Node } = { UI.Text "Title" { text = "Outpost", textRole = "title" } }
					for _, label in labels do
						table.insert(children, UI.Button(label) { label = label, onActivate = function() end })
					end
					table.insert(children, UI.Text "Footer" { text = "Season 4" })
					return UI.VStack "Menu" { width = 640, gap = 8, surface = "surface", table.unpack(children) }
				end, function(screen)
					local root =
						S.stack(world, screen, "Menu", false, { width = 640, gap = 8, surface = Theme.tags.surface })
					S.fill(world, S.text(world, root, "Title", "Outpost", nil, "title"))
					for _, label in labels do
						S.button(world, root, label, label, function() end)
					end
					S.fill(world, S.text(world, root, "Footer", "Season 4"))
				end)
			end,
			snapshot = function()
				if #world.target:GetChildren() == 0 then
					return "unmounted"
				end
				return S.observe(world, MENU)
			end,
			stop = function()
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "hud-60-frames",
	iterations = 60,
	what = "Update health fill, ammo, currency and timer once per simulated frame.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local health, ammo, coins, timer =
			S.model(world, lane, 1), S.model(world, lane, "30"), S.model(world, lane, "0"), S.model(world, lane, "0:00")
		local plainFill: S.Node? = nil
		local plainAmmo: S.Node? = nil
		local plainCoins: S.Node? = nil
		local plainTimer: S.Node? = nil
		local stop = S.mount(world, lane, function()
			local UI = world.UI
			return UI.HStack "HUD" {
				width = 640,
				gap = 8,
				UI.ProgressView "Health" { value = assert(health) },
				UI.Text "Ammo" { text = assert(ammo) },
				UI.Text "Coins" { text = assert(coins) },
				UI.Text "Timer" { text = assert(timer) },
			}
		end, function(screen)
			local root = S.stack(world, screen, "HUD", true, { width = 640, gap = 8 })
			plainFill = S.progress(world, root, "Health", 1)
			plainAmmo = S.text(world, root, "Ammo", "30", true)
			plainCoins = S.text(world, root, "Coins", "0", true)
			plainTimer = S.text(world, root, "Timer", "0:00", true)
		end)
		return {
			step = function(frame: number)
				local h, a, c, t =
					1 - frame % 100 / 100,
					tostring(30 - frame % 30),
					tostring(frame * 5),
					string.format("%d:%02d", math.floor(frame / 60), frame % 60)
				if lane == "facet" then
					assert(health):set(h)
					assert(ammo):set(a)
					assert(coins):set(c)
					assert(timer):set(t)
				else
					assert(plainFill).Size = world.types.UDim2.fromScale(h, 1)
					S.setText(world, assert(plainAmmo), a)
					S.setText(world, assert(plainCoins), c)
					S.setText(world, assert(plainTimer), t)
				end
				world.frame()
			end,
			snapshot = function()
				return S.observe(world, { "HUD", "Health", "Track", "Fill1", "Ammo", "Coins", "Timer" })
					.. "\nHealth:"
					.. S.fraction(world, "Health")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "world-markers-50",
	iterations = 100,
	what = "Update the labels of 50 native BillboardGui markers in the player's GUI, adorned to anchored Parts in the Workspace.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local values: { Types.Value<string> } = {}
		local names: { string } = {}
		local nodes: { S.Node } = {}
		local placed: { S.Node } = {}
		local anchored: { S.Node } = {}
		local observed: { string } = { "Marker1" }
		local space = workspaceOf(world)
		for i = 1, 50 do
			if lane == "facet" then
				table.insert(values, world.Compose.cell("Target " .. i))
			end
			table.insert(names, "MarkerLabel" .. i)
			table.insert(observed, "MarkerLabel" .. i)
		end
		local stop = S.mount(world, lane, function()
			local UI, Compose, Host = world.UI, world.Compose, world.Host
			local anchors: { unknown } = {}
			local layers: { unknown } = {}
			local surfaces: { unknown } = {}
			for i, value in values do
				local anchor = Host.Part {
					Name = "Anchor" .. i,
					Anchored = true,
					Position = anchorAt(world, i),
				}
				local layer = Host.BillboardGui {
					Name = "Marker" .. i,
					Adornee = Compose.static(anchor),
					Size = world.types.UDim2.fromOffset(120, 32),
				}
				anchors[i], layers[i], anchored[i] = anchor, layer, anchor
				table.insert(placed, layer)
				surfaces[i] = UI.worldSurface(layer, function()
					return UI.Text(names[i]) { text = value }
				end)
			end
			local props: FolderProps = {
				Name = "Markers",
				Compose.portal(space, function(): { unknown }
					return anchors
				end),
				Compose.portal(world.target, function(): { unknown }
					return layers
				end),
				table.unpack(surfaces),
			}
			return Host.Folder(props)
		end, function(_screen, sheet)
			local styles = assert(sheet)
			for i, name in names do
				local anchor = S.create(world, "Part", "Anchor" .. i, nil, { Anchored = true })
				anchor.Position = anchorAt(world, i)
				anchor.Parent = space
				anchored[i] = anchor
				local billboard = S.create(
					world,
					"BillboardGui",
					"Marker" .. i,
					nil,
					{ Adornee = anchor, Size = world.types.UDim2.fromOffset(120, 32) }
				)
				Theme.link(world, billboard, styles)
				table.insert(nodes, S.text(world, billboard, name, "Target " .. i, true))
				billboard.Parent = world.target
				table.insert(placed, anchor)
				table.insert(placed, billboard)
			end
		end)
		return {
			step = function(frame: number)
				for i = 1, 50 do
					local label = `Target {i}: {frame}m`
					if lane == "facet" then
						values[i]:set(label)
					else
						S.setText(world, nodes[i], label)
					end
				end
			end,
			snapshot = function()
				for i = 1, 50 do
					local layer = S.find(world, "Marker" .. i)
					local anchor = anchored[i]
					assert(
						layer:IsA "BillboardGui"
							and layer:FindFirstAncestorWhichIsA "LayerCollector" == nil
							and layer.Adornee == anchor
							and anchor:IsA "BasePart"
							and anchor.Parent == space,
						"a marker must be a top-level BillboardGui adorned to a Part in the Workspace"
					)
				end
				return S.observe(world, observed)
			end,
			stop = function()
				stop()
				for _, node in placed do
					node:Destroy()
				end
				table.clear(placed)
			end,
		}
	end,
})

return workloads
