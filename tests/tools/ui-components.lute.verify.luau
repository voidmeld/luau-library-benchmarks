--!strict

local Test = require "../harness"
local Headless = require "../../comparisons/ui-components/headless"
local Types = require "../../comparisons/ui-components/types"
local Workloads = require "../../comparisons/ui-components/workloads"
local Checkpoints = require "../../comparisons/ui-components/checkpoints"
local Input = require "../../comparisons/ui-components/studio/input"
local Settle = require "../../comparisons/ui-components/studio/settle"
local Unsupported = require "../../comparisons/ui-components/studio/unsupported"
local S = require "../../comparisons/ui-components/workloads/support"
local Theme = require "../../comparisons/ui-components/workloads/plain-theme"
local Report = require "../../comparisons/ui-components/report"
local Shards = require "../../comparisons/studio-shards"
local Values = require "../../.lute/dependencies/verify/src/roblox/ui-values"
local Roblox = require "../../.lute/dependencies/verify/src/roblox"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function workload(id: string): Types.Workload
	for _, candidate in Workloads.all do
		if candidate.id == id then
			return candidate
		end
	end
	error("missing workload " .. id, 0)
end

local function inputFixture(delivery: string?)
	local world = Headless.create()
	local button = world.new "TextButton"
	button.Name = "Target"
	world.pin(button, 100, 40)
	world.poke(button, "AbsolutePosition", world.types.Vector2.new(10, 20))
	local gui = world.new "GuiService"
	local events: { string } = {}
	local frames = 0
	local held = false
	local virtual: Input.Virtual = {
		SendMousePosition = function(_self: Input.Virtual, position: unknown)
			local at = Values.vector(position)
			local x, y = at.X, at.Y
			table.insert(events, `move:{x}:{y}`)
			world.poke(
				button,
				"GuiState",
				if x < 13
					then world.types.Enum.GuiState.Idle
					elseif held then world.types.Enum.GuiState.Press
					else world.types.Enum.GuiState.Hover
			)
		end,
		SendMouseButton = function(
			_self: Input.Virtual,
			position: unknown,
			kind: unknown,
			down: boolean,
			count: number
		)
			local at = Values.vector(position)
			local x, y = at.X, at.Y
			expect(kind == world.types.Enum.UserInputType.MouseButton1):toBe(true)
			expect(count):toBe(1)
			expect(down == held):toBe(false)
			table.insert(events, `mouse:{x}:{y}:{kind}:{down}:{count}`)
			held = down
			world.poke(
				button,
				"GuiState",
				if down then world.types.Enum.GuiState.Press else world.types.Enum.GuiState.Hover
			)
		end,
		SendKey = function(_self: Input.Virtual, down: boolean, code: unknown, repeatKey: boolean)
			table.insert(events, `key:{down}:{code}:{repeatKey}`)
			if down and delivery and delivery ~= "none" then
				local delivered = if delivery == "gamepad" and code == world.types.Enum.KeyCode.Four
					then world.types.Enum.KeyCode.DPadRight
					else code
				local facts = {
					KeyCode = delivered,
					UserInputType = if delivery == "gamepad"
						then world.types.Enum.UserInputType.Gamepad1
						else world.types.Enum.UserInputType.Keyboard,
				}
				world.fire(assert(world.inputService), "InputBegan", facts, false)
			end
		end,
	}
	local driver = Input {
		virtual = virtual,
		gui = gui,
		input = if delivery then world.inputService else nil,
		types = world.types,
		inset = function(): (number, number)
			return 3, 36
		end,
		frame = function()
			frames += 1
		end,
	}
	return {
		world = world,
		button = button,
		gui = gui,
		driver = driver,
		events = events,
		frames = function(): number
			return frames
		end,
		stop = function()
			button:Destroy()
			gui:Destroy()
			world.dispose()
		end,
	}
end

describe("ui components", function()
	it("reports disclose loader fallbacks without splitting the measurement table", function()
		local row: Report.Row = {
			workload = "fixture",
			iterations = 1,
			lane = "plain",
			microseconds = 1,
			lowest = 1,
			highest = 1,
			mountedKb = 1,
			teardownKb = 0,
			writes = 1,
			created = 1,
		}
		local markdown = Report.markdown({ row }, "harness", "facet", {}, { "fixture.luau" })
		expect(markdown):toContain "Loader fallbacks: fixture.luau."
		expect(markdown):toContain "| --- | ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |\n| fixture |"
	end)

	it("native activation uses measured geometry, the inset and a complete mouse pair", function()
		local fixture = inputFixture()
		fixture.driver.fire(fixture.button, "Activated")
		expect(table.concat(fixture.events, "|")):toBe "move:63:76|mouse:63:76:Enum.UserInputType.MouseButton1:true:1|mouse:63:76:Enum.UserInputType.MouseButton1:false:1"
		expect(fixture.frames()):toBe(3)
		fixture.stop()
	end)

	it("keyboard activation selects the actual control and releases the requested key", function()
		local fixture = inputFixture "keyboard"
		fixture.driver.fire(fixture.button, "Activated", {
			UserInputType = fixture.world.types.Enum.UserInputType.Keyboard,
			KeyCode = fixture.world.types.Enum.KeyCode.Return,
		})
		expect(fixture.gui.SelectedObject == fixture.button):toBe(true)
		expect(#fixture.events):toBe(2)
		expect(fixture.events[1]):toContain "key:true:Enum.KeyCode.Return:false"
		expect(fixture.events[2]):toContain "key:false:Enum.KeyCode.Return:false"
		expect(fixture.frames()):toBe(4)
		fixture.stop()
	end)

	it("keyboard keys leave delivery to the workload result because an input sink can consume them", function()
		local fixture = inputFixture "none"
		local before = fixture.world.census().connections
		local ok = pcall(fixture.driver.key, fixture.world.types.Enum.KeyCode.Return)
		expect(ok):toBe(true)
		expect(fixture.world.census().connections):toBe(before)
		fixture.stop()
	end)

	it("native feedback visits Hover, Press and Idle and checks delivered state", function()
		local fixture = inputFixture()
		for _, state in
			{
				fixture.world.types.Enum.GuiState.Hover,
				fixture.world.types.Enum.GuiState.Press,
				fixture.world.types.Enum.GuiState.Idle,
			}
		do
			fixture.driver.poke(fixture.button, "GuiState", state)
			expect(fixture.button.GuiState == state):toBe(true)
		end
		expect(fixture.events[#fixture.events]):toBe "move:1:1"
		fixture.stop()
	end)

	it("gamepad input requires delivered Gamepad1 events and releases its observer", function()
		for _, delivery in { "none", "keyboard", "gamepad" } do
			local fixture = inputFixture(delivery)
			local before = fixture.world.census().connections
			local ok = pcall(fixture.driver.key, fixture.world.types.Enum.KeyCode.DPadRight)
			expect(ok):toBe(delivery == "gamepad")
			expect(fixture.events[1]):toContain "Enum.KeyCode.Four"
			expect(fixture.events[2]):toBe "key:false:Enum.KeyCode.Four:false"
			expect(fixture.world.census().connections):toBe(before)
			fixture.stop()
		end
	end)

	it("native drag moves through intermediate positions before release", function()
		local fixture = inputFixture()
		local target = fixture.world.new "TextLabel"
		fixture.world.pin(target, 100, 40)
		fixture.world.poke(target, "AbsolutePosition", fixture.world.types.Vector2.new(10, 196))
		fixture.driver.drag(fixture.button, target)
		expect(#fixture.events):toBe(11)
		expect(fixture.events[1]):toBe "move:63:76"
		expect(fixture.events[2]):toBe "mouse:63:76:Enum.UserInputType.MouseButton1:true:1"
		expect(fixture.events[10]):toBe "move:63:252"
		expect(fixture.events[11]):toBe "mouse:63:252:Enum.UserInputType.MouseButton1:false:1"
		target:Destroy()
		fixture.stop()
	end)

	it("native input rejects an unmeasured target and unsupported event or property", function()
		local fixture = inputFixture()
		fixture.world.pin(fixture.button, 0, 0)
		local area = pcall(fixture.driver.fire, fixture.button, "Activated")
		local event = pcall(fixture.driver.fire, fixture.button, "DragEnd")
		local property = pcall(fixture.driver.poke, fixture.button, "AbsoluteSize", fixture.world.types.Vector2.zero)
		expect(area):toBe(false)
		expect(event):toBe(false)
		expect(property):toBe(false)
		expect(#fixture.events):toBe(0)
		fixture.stop()
	end)

	it("settling waits the requested real duration and always advances one frame", function()
		local now, frames = 0, 0
		local settle = Settle(function(): number
			return now
		end, function()
			now += 0.1
			frames += 1
		end)
		settle(0.25)
		expect(frames):toBe(3)
		settle()
		expect(frames):toBe(4)
	end)

	it("Studio parity rejects different intermediate states with equal final states", function()
		local ok = pcall(
			Checkpoints.match,
			"fixture",
			{ "closed", "open", "closed" },
			{ "closed", "missing", "closed" }
		)
		expect(ok):toBe(false)
		local count = pcall(Checkpoints.match, "fixture", { "closed" }, { "closed", "closed" })
		expect(count):toBe(false)
	end)

	it("checkpoint failure releases the scene and world", function()
		local world = Headless.create()
		local stopped, disposed = false, false
		local dispose = world.dispose
		world.dispose = function()
			disposed = true
			dispose()
		end
		local broken: Types.Workload = {
			id = "broken",
			iterations = 1,
			what = "checkpoint cleanup fixture",
			prepare = function(): Types.Scene
				return {
					step = function()
						error("fixture step failed", 0)
					end,
					snapshot = function(): string
						return "mounted"
					end,
					stop = function()
						stopped = true
					end,
				}
			end,
		}
		local ok = pcall(function()
			Checkpoints.collect(broken, world, "plain")
		end)
		expect(ok):toBe(false)
		expect(stopped):toBe(true)
		expect(disposed):toBe(true)
	end)

	it(
		"plain keyboard activation follows selection, ignores disabled controls and text editing, and cleans up",
		function()
			local world = Headless.create { lane = "plain" }
			local gui = world.new "GuiService"
			world.guiService = gui
			local before = world.census()
			local calls = 0
			local stop = S.mount(world, "plain", function(): Types.Node
				error("plain fixture entered Facet", 0)
			end, function(screen)
				S.button(world, screen, "KeyboardTarget", "Activate", function()
					calls += 1
				end)
				S.create(world, "TextBox", "Field", screen)
			end)
			local button = S.find(world, "KeyboardTarget")
			local context = S.find(world, "PlainKeyboardActivation")
			local action = assert(context:FindFirstChild "Activate")
			local keys: { string } = {}
			for _, binding in action:GetChildren() do
				table.insert(keys, tostring(binding.KeyCode))
			end
			table.sort(keys)
			expect(context.Priority):toBe(5000)
			expect(table.concat(keys, ",")):toBe "Enum.KeyCode.Return,Enum.KeyCode.Space"
			gui.SelectedObject = button
			expect(context.Enabled):toBe(true)
			expect(S.observe(world, {})):toBe "selected=KeyboardTarget\ninputs=5000:Return+Space"
			world.fire(action, "Pressed")
			expect(calls):toBe(1)
			local field = S.find(world, "Field")
			field:CaptureFocus()
			world.fire(action, "Pressed")
			expect(calls):toBe(1)
			field:ReleaseFocus()
			button.Interactable = false
			world.fire(action, "Pressed")
			expect(calls):toBe(1)
			stop()
			expect(world.census().live):toBe(before.live)
			expect(world.census().connections):toBe(before.connections)
			gui:Destroy()
			world.dispose()
		end
	)

	it("the plain lane world raises when a plain path reads a library field", function()
		local world = Headless.create { lane = "plain" }
		local reads: { () -> unknown } = {
			function(): unknown
				return world.Facet
			end,
			function(): unknown
				return world.Compose
			end,
			function(): unknown
				return world.runtime
			end,
			function(): unknown
				return world.Host
			end,
			function(): unknown
				return world.UI
			end,
			function(): unknown
				return world.motion
			end,
		}
		for _, read in reads do
			expect(pcall(read)):toBe(false)
		end
		expect(world.key == nil and world.drag == nil and world.guiService == nil):toBe(true)
		world.dispose()
		local facet = Headless.create { lane = "facet" }
		expect(facet.UI ~= nil and facet.Compose ~= nil and facet.motion.dialog.enter > 0):toBe(true)
		facet.dispose()
	end)

	it("the plain theme paints controls with its own StyleSheet and neutral values", function()
		local world = Headless.create { native = true, lane = "plain" }
		local before = world.census()
		local extra: Types.Node? = nil
		local stop = S.mount(world, "plain", function(): Types.Node
			error("plain fixture entered Facet", 0)
		end, function(screen, sheet)
			S.text(world, screen, "Note", "Hello", nil, "caption")
			S.button(world, screen, "Go", "Go", function() end)
			extra = Theme.rule(world, assert(sheet), ".pl-extra", { TextColor3 = Theme.token "accent" })
		end)
		for _ = 1, 30 do
			world.frame()
		end
		local sheet = assert(S.find(world, "Comparison"):FindFirstChildWhichIsA "StyleSheet")
		local highest = 0
		for _, rule in sheet:GetChildren() do
			expect(string.find(tostring(rule.Selector), "facet", 1, true)):toBe(nil)
			local priority = rule.Priority
			if type(priority) == "number" and rule ~= extra then
				highest = math.max(highest, priority)
			end
		end
		local added = assert(extra)
		local priority = added.Priority
		expect(type(priority) == "number" and priority > highest):toBe(true)
		expect(added:GetPropertyTransitions().TextColor3):toBe "$motionNormal"
		expect(S.observe(world, { "Note" })):toContain "Note: shown text=Hello ink=158,165,182 alpha=0.000 size=14.0 font=BuilderSans/Regular/Normal bgAlpha=1.000"
		world.poke(S.find(world, "Go"), "GuiState", world.types.Enum.GuiState.Hover)
		world.frame(Theme.paint.hover + 0.05)
		expect(S.observe(world, { "Go" })):toContain "Go: shown text=Go ink=236,239,245 alpha=0.000 size=18.0 font=BuilderSans/Regular/Normal bgAlpha=0.000 bg=49,54,69"
		stop()
		world.frame()
		expect(world.census().live):toBe(before.live)
		expect(world.census().connections):toBe(before.connections)
		world.dispose()
	end)

	it("plain readout reservations reset when native typography changes", function()
		local world = Headless.create()
		local label = S.text(world, world.target, "Readout", "a\u{e9}1", true)
		label.TextSize = 28
		local constraint = assert(label:FindFirstChildWhichIsA "UISizeConstraint")
		S.setText(world, label, "123")
		expect(S.vector2(world, constraint.MinSize).X):toBe(56)
		label.TextSize = 14
		expect(S.vector2(world, constraint.MinSize).X):toBe(0)
		S.setText(world, label, "a\u{e9}1")
		S.setText(world, label, "123")
		expect(S.vector2(world, constraint.MinSize).X):toBe(28)
		label:Destroy()
		world.dispose()
	end)

	it("inventory parity rejects an activation that does not reach either lane", function()
		local subject = workload "inventory-500"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create { lane = lane }
			world.fire = function() end
			local scene = subject.prepare(world, lane)
			scene.step(1)
			local ok = pcall(scene.snapshot)
			expect(ok):toBe(false)
			scene.stop()
			world.dispose()
		end
	end)

	it("short toast expiry keeps one-shot expiry and teardown in both lanes", function()
		local subject = workload "toast-stream-4"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create { lane = lane }
			world.toastDuration = 0.05
			local before = world.census()
			local scene = subject.prepare(world, lane)
			scene.step(1)
			expect(scene.snapshot()):toContain "Reward 1"
			scene.step(2)
			expect(scene.snapshot()):toBe "\nsnackbar=0"
			scene.stop()
			world.dispose()
			expect(world.census().live <= before.live):toBe(true)
			expect(world.census().connections <= before.connections):toBe(true)
		end
	end)

	it("headless native selection is enabled only for the grid walk", function()
		for _, subject in Workloads.all do
			local enabled = subject.nativeSelection == true
			expect(enabled):toBe(subject.id == "gamepad-grid-6x6")
		end
		local world = Headless.create()
		expect(world.key == nil and world.guiService == nil):toBe(true)
		world.dispose()
	end)

	it("headless D-pad input moves native selection through every grid cell in both lanes", function()
		local subject = workload "gamepad-grid-6x6"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create { native = true, gamepad = subject.nativeSelection, lane = lane }
			local before = world.census()
			local scene = subject.prepare(world, lane)
			for _ = 1, Headless.SETTLE_FRAMES do
				world.frame()
			end
			local gui = assert(world.guiService)
			local delivered = 0
			local connection = assert(world.inputService).InputBegan:Connect(function(value: unknown)
				local event = Roblox.assertInstance(value)
				expect(event.UserInputType == world.types.Enum.UserInputType.Gamepad1):toBe(true)
				delivered += 1
			end)
			expect(string.match(scene.snapshot(), "^[^\n]*")):toBe "1"
			local expected = 1
			for index = 1, subject.iterations do
				local previous = gui.SelectedObject
				scene.step(index)
				expected += if (index - 1) % 6 == 5 then 6 elseif math.floor((index - 1) / 6) % 2 == 0 then 1 else -1
				expect(string.match(scene.snapshot(), "^[^\n]*")):toBe(tostring(expected))
				expect(gui.SelectedObject ~= nil and gui.SelectedObject ~= previous):toBe(true)
			end
			expect(delivered):toBe(subject.iterations)
			connection:Disconnect()
			scene.stop()
			expect(world.census().live):toBe(before.live)
			expect(world.census().connections):toBe(before.connections)
			world.dispose()
		end
	end)

	it("grid parity rejects dropped D-pad input in both lanes", function()
		local subject = workload "gamepad-grid-6x6"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create { native = true, gamepad = subject.nativeSelection, lane = lane }
			local scene = subject.prepare(world, lane)
			world.key = function() end
			scene.step(1)
			expect(pcall(scene.snapshot)):toBe(false)
			scene.stop()
			world.dispose()
		end
	end)

	it("all workloads have a Studio path and the eight game tasks are registered", function()
		expect(next(Unsupported) == nil):toBe(true)
		for _, id in
			{
				"gamepad-grid-6x6",
				"input-type-switch-20",
				"phone-rotation-hub",
				"text-size-preference-50",
				"localized-text-swap-50",
				"hud-composition-step-down",
				"drag-reorder-100",
				"modal-on-modal",
			}
		do
			expect(workload(id).iterations > 0):toBe(true)
		end
	end)
end)

describe("Studio batch plan", function()
	it("runs an isolated workload alone in the last batch", function()
		local groups = {
			{ workload = "gamepad-grid-6x6", ids = { "gamepad-grid-6x6/plain", "gamepad-grid-6x6/facet" } },
			{ workload = "drag-reorder-100", ids = { "drag-reorder-100/plain", "drag-reorder-100/facet" } },
			{ workload = "hud-60-frames", ids = { "hud-60-frames/plain", "hud-60-frames/facet" } },
		}
		local batches = Shards.plan(groups, {}, 2, { "gamepad-grid-6x6" })
		expect(#batches):toBe(3)
		expect(table.concat(batches[3], ",")):toBe "gamepad-grid-6x6/plain,gamepad-grid-6x6/facet"
		for index = 1, 2 do
			for _, id in batches[index] do
				expect(id:find("gamepad", 1, true)):toBe(nil)
			end
		end
	end)
end)

return nil
