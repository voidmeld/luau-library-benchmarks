--!strict

local Types = require "../types"
local S = require "./support"
type BillboardProps = Types.Props
type FolderProps = Types.Props

local workloads: { Types.Workload } = {}

table.insert(workloads, {
	id = "main-menu-cold",
	iterations = 1,
	what = "Mount a background, title, six actions and footer; runtime and control-factory setup is excluded.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local labels = { "Play", "Inventory", "Shop", "Settings", "Credits", "Exit" }
		local stop: () -> () = function() end
		return {
			step = function()
				stop = S.mount(world, lane, function()
					local children: { Types.Node } = { UI.Text "Title" { text = "Outpost", textRole = "title" } }
					for _, label in labels do
						table.insert(children, UI.Button(label) { label = label, onActivate = function() end })
					end
					table.insert(children, UI.Text "Footer" { text = "Season 4" })
					return UI.VStack "Menu" { width = 640, gap = 8, surface = "surface", table.unpack(children) }
				end, function(screen)
					local root = S.stack(world, screen, "Menu")
					root.BackgroundTransparency = 0
					S.text(world, root, "Title", "Outpost", nil, "title")
					for _, label in labels do
						S.button(world, root, label, label, function() end)
					end
					S.text(world, root, "Footer", "Season 4")
				end)
			end,
			snapshot = function()
				if #world.target:GetChildren() == 0 then
					return "unmounted"
				end
				return S.snapshot(
					world,
					{ "Title", "Play", "Inventory", "Shop", "Settings", "Credits", "Exit", "Footer" }
				)
			end,
			stop = function()
				stop()
			end,
		}
	end,
})

table.insert(workloads, {
	id = "hud-600-frames",
	iterations = 600,
	what = "Update health fill, ammo, currency and timer once per simulated frame.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI = world.UI
		local health, ammo, coins, timer =
			S.model(world, lane, 1), S.model(world, lane, "30"), S.model(world, lane, "0"), S.model(world, lane, "0:00")
		local plainFill: S.Node? = nil
		local plainAmmo: S.Node? = nil
		local plainCoins: S.Node? = nil
		local plainTimer: S.Node? = nil
		local stop = S.mount(world, lane, function()
			return UI.HStack "HUD" {
				width = 640,
				gap = 8,
				UI.ProgressView "Health" { value = assert(health) },
				UI.Text "Ammo" { text = assert(ammo) },
				UI.Text "Coins" { text = assert(coins) },
				UI.Text "Timer" { text = assert(timer) },
			}
		end, function(screen)
			local root = S.stack(world, screen, "HUD", true)
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
				return S.snapshot(world, { "Ammo", "Coins", "Timer" }) .. "\nHealth:" .. S.fraction(world, "Health")
			end,
			stop = stop,
		}
	end,
})

table.insert(workloads, {
	id = "world-markers-50",
	iterations = 100,
	what = "Update the labels of 50 native BillboardGui markers anchored to Parts.",
	prepare = function(world: Types.World, lane: Types.Lane): Types.Scene
		local UI, Compose, Host = world.UI, world.Compose, world.Host
		local values: { Types.Value<string> } = {}
		local names: { string } = {}
		local nodes: { S.Node } = {}
		for i = 1, 50 do
			if lane == "facet" then
				table.insert(values, Compose.cell("Target " .. i))
			end
			table.insert(names, "MarkerLabel" .. i)
		end
		local stop = S.mount(world, lane, function()
			local children: { Types.Node } = {}
			for i, value in values do
				local anchor = Host.Part { Name = "Anchor" .. i, Anchored = true }
				table.insert(children, anchor)
				local props: BillboardProps = {
					Name = "Marker" .. i,
					Adornee = Compose.static(anchor),
					Size = world.types.UDim2.fromOffset(120, 32),
					UI.Text(names[i]) { text = value },
				}
				table.insert(children, Host.BillboardGui(props))
			end
			local props: FolderProps = { Name = "Markers", table.unpack(children) }
			return Host.Folder(props)
		end, function(screen)
			local root = S.create(world, "Folder", "Markers", screen)
			for i, name in names do
				local anchor = S.create(world, "Part", "Anchor" .. i, root, { Anchored = true })
				local billboard = S.create(
					world,
					"BillboardGui",
					"Marker" .. i,
					root,
					{ Adornee = anchor, Size = world.types.UDim2.fromOffset(120, 32) }
				)
				table.insert(nodes, S.text(world, billboard, name, "Target " .. i, true))
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
				return S.snapshot(world, names)
			end,
			stop = stop,
		}
	end,
})

return workloads
