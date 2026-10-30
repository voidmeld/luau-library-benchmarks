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
local Report = require "../../comparisons/ui-components/report"

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
			local at = position :: { X: number, Y: number }
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
			local at = position :: { X: number, Y: number }
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

	it("plain Return activation follows selection, ignores disabled controls and cleans up", function()
		local world = Headless.create()
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
		end)
		local button = S.find(world, "KeyboardTarget")
		local context = S.find(world, "PlainKeyboardActivation")
		local action = assert(context:FindFirstChild "Activate")
		gui.SelectedObject = button
		expect(context.Enabled):toBe(true)
		world.fire(action, "Pressed")
		expect(calls):toBe(1)
		button.Interactable = false
		world.fire(action, "Pressed")
		expect(calls):toBe(1)
		stop()
		expect(world.census().live):toBe(before.live)
		expect(world.census().connections):toBe(before.connections)
		gui:Destroy()
		world.dispose()
	end)

	it("plain readout reservations reset when native typography changes", function()
		local world = Headless.create()
		local label = S.text(world, world.target, "Readout", "123", true)
		label.TextSize = 28
		local constraint = assert(label:FindFirstChildWhichIsA "UISizeConstraint")
		expect(S.vector2(world, constraint.MinSize).X):toBe(42)
		label.TextSize = 14
		expect(S.vector2(world, constraint.MinSize).X):toBe(21)
		label:Destroy()
		world.dispose()
	end)

	it("inventory parity rejects an activation that does not reach either lane", function()
		local subject = workload "inventory-500"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create()
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
		local subject = workload "toast-stream-20"
		local lanes: { Types.Lane } = { "plain", "facet" }
		for _, lane in lanes do
			assert(lane == "plain" or lane == "facet")
			local world = Headless.create()
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

return nil
