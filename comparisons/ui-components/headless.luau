--!strict

local Lute = require "../../.lute/dependencies/verify/src/lute"
local Roblox = require "../../.lute/dependencies/verify/src/roblox"
local Upstream = require "../scene-composition/harness/upstream"
local Types = require "./types"
local Motion = require "./motion"
local Input = require "./studio/input"

export type Census = { live: number, connections: number }
export type Headless = Types.World & {
	census: () -> Census,
	observe: (listener: (event: Roblox.EnvironmentEvent) -> ()) -> Roblox.Connection,
}

local FACET = ".lute/dependencies/facet/src"

local snapshot = Lute.fixture.load()
local library = Roblox.reflectionSnapshot.library(snapshot)
local types = table.clone(library)
types.typeof = Roblox.typeName
local Vector2 = library.Vector2

local loaded: Types.Facet? = nil

local function facet(): Types.Facet
	if loaded == nil then
		Upstream.setMode "like-for-like"
		local globals = Upstream.luteEnvironment()
		for name, value in Upstream.entries(types) do
			if type(name) == "string" then
				globals[name] = value
			end
		end
		globals.typeof = Roblox.typeName
		globals.getfenv = function(): { [string]: unknown }
			return globals
		end
		local loader = Upstream.isolated(globals)
		local load: (string) -> Types.Facet = loader.load
		loaded = load(FACET)
	end
	return assert(loaded)
end

type Entry = { Key: string, Source: string, Values: { [string]: string } }

local localization: { [unknown]: { Entry } } = {}
setmetatable(localization, { __mode = "k" })

local function unpressed(): boolean
	return false
end

local function none(): { unknown }
	return {}
end

local function blank(): string
	return ""
end

local function format(object: unknown, locale: string, key: string, arguments: { [string]: unknown }): string
	for _, entry in assert(localization[object]) do
		if entry.Key == key then
			return (
				string.gsub(entry.Values[locale] or entry.Source, "{([%w_]+)}", function(name: string): string
					return tostring(arguments[name])
				end)
			)
		end
	end
	error("Unknown localization key: " .. key)
end

local localizationMethods: { [string]: unknown } = {
	SetEntries = function(object: unknown, entries: { Entry })
		localization[object] = entries
	end,
	GetTranslator = function(object: unknown, locale: string)
		return {
			FormatByKey = function(_self: unknown, key: string, arguments: { [string]: unknown }): string
				return format(object, locale, key, arguments)
			end,
		}
	end,
}
local inputMethods: { [string]: unknown } = {
	GetMouseLocation = function()
		return Vector2.new(-1, -1)
	end,
	IsKeyDown = unpressed,
	IsMouseButtonPressed = unpressed,
	IsGamepadButtonDown = unpressed,
	GetKeysPressed = none,
	GetMouseButtonsPressed = none,
	GetNavigationGamepads = none,
	GetConnectedGamepads = none,
	GetGamepadState = none,
	GetImageForKeyCode = blank,
	GetStringForKeyCode = blank,
	GetLastInputType = function()
		return library.Enum.UserInputType.None
	end,
}
local actionMethods: { [string]: unknown } = { GetState = unpressed }
local hitMethods: { [string]: unknown } = { GetGuiObjectsAtPosition = none }
local guiProperties: { [string]: unknown } = {
	PreferredTransparency = 1,
	GuiNavigationEnabled = true,
	AutoSelectGuiEnabled = true,
	TouchControlsEnabled = true,
}
local guiMethods: { [string]: unknown } = {
	GetGuiInset = function()
		return Vector2.zero, Vector2.zero
	end,
	GetInsetArea = function()
		error("the headless world has no measured inset area", 0)
	end,
}
local inputProperties: { [string]: unknown } = {
	PreferredInput = library.Enum.PreferredInput.KeyboardAndMouse,
	MouseEnabled = true,
	KeyboardEnabled = true,
	TouchEnabled = false,
	GamepadEnabled = false,
}
local classes: { [string]: Roblox.EnvironmentClass } = {
	LocalizationTable = { methods = localizationMethods },
	UserInputService = { methods = inputMethods, properties = inputProperties },
	InputAction = { methods = actionMethods },
	BasePlayerGui = { methods = hitMethods },
	LayerCollector = { methods = hitMethods },
	GuiService = { properties = guiProperties, methods = guiMethods },
}

local function defaultProperty(_className: string, key: string): unknown
	return if key == "AbsoluteSize"
			or key == "AbsolutePosition"
			or key == "AbsoluteContentSize"
		then Vector2.zero
		else nil
end

local function node(object: Roblox.Instance): Types.Node
	return object :: Types.Node
end

local function fits(): boolean
	return true
end

local function create(nativeSelection: boolean?): Headless
	local Facet = facet()
	local environment: Roblox.Environment
	local roots: { Roblox.Instance } = {}
	local computed: { [string]: ((Roblox.Instance) -> unknown) | { get: (Roblox.Instance) -> unknown, writable: boolean? } } =
		{}
	for _, class in { "TextLabel", "TextButton", "TextBox" } do
		computed[class .. ".TextFits"] = { get = fits, writable = true }
	end
	local bridge = Lute.fixture.bridge(snapshot, {
		classes = classes,
		defaultProperty = defaultProperty,
		handlerErrors = "raise",
		functionDoubles = true,
		undeclaredReads = "nil",
		undeclaredWrites = false,
		computed = computed,
		layout = if nativeSelection
			then {
				roots = function()
					return roots
				end,
				viewport = function()
					return { X = 800, Y = 600 }
				end,
			}
			else nil,
		ui = {
			measureBounds = if nativeSelection then nil else false,
			measureText = false,
			selection = if nativeSelection then "native" else "ignore",
			requirePlayerGui = nativeSelection == true,
			methods = {
				["Instance.GetStyled"] = function(object: Roblox.Instance, property: string): unknown
					return object[property]
				end,
				["Instance.GetStyledPropertyChangedSignal"] = function(object: Roblox.Instance, property: string)
					return object:GetPropertyChangedSignal(property)
				end,
				["UIPageLayout.JumpTo"] = function(object: Roblox.Instance, page: unknown)
					environment.poke(object, "CurrentPage", page)
				end,
			},
		},
	})
	environment = bridge.environment
	environment.onClone(function(_original: Roblox.Instance, copy: Roblox.Instance)
		if copy:IsA "ViewportFrame" then
			environment.poke(copy, "CurrentCamera", nil)
		end
	end)
	local function create(className: string): Roblox.Instance
		local object = environment.createEngineInstance(className)
		if not nativeSelection and object:IsA "GuiBase2d" then
			environment.poke(object, "AbsoluteSize", Vector2.zero)
			environment.poke(object, "AbsolutePosition", Vector2.zero)
		end
		return object
	end
	local function new(className: string): Types.Node
		return node(create(className))
	end
	local engine = table.clone(bridge.engine)
	engine.new = function(className: string)
		local made: unknown = create(className)
		return made :: typeof(bridge.engine.new(className))
	end
	local elapsed = 0
	engine.clock = function(): number
		return elapsed
	end
	local runtime = Facet.Roblox.createRuntime(engine)
	local target = new "Folder"
	local textService = new "TextService"
	local inputService = new "UserInputService"
	local guiService: Types.Node? = nil
	local input: { close: () -> () }? = nil
	local dataModel: Types.Node? = nil
	local key: ((unknown) -> ())? = nil
	local function frame(delta: number?)
		local seconds = delta or 1 / 60
		elapsed += seconds
		if nativeSelection then
			environment.step(seconds)
			assert(bridge.layout).step()
		else
			environment.heartbeat:Fire(seconds)
		end
	end
	if nativeSelection then
		local game = new "DataModel"
		dataModel = game
		local playerGui = new "PlayerGui"
		playerGui.Parent = game
		target.Parent = playerGui
		inputService.Parent = game
		guiService = new "GuiService"
		guiService.Parent = game
		table.insert(roots, playerGui)
		environment.poke(inputService, "GamepadEnabled", false)
		local host = Roblox.inputHost.simulated(environment, {
			playerGui = playerGui,
			inputService = inputService,
			layout = assert(bridge.layout),
			inset = function()
				return { X = 0, Y = 0 }
			end,
			library = library,
			activationWindowSeconds = 0.5,
			virtualController = true,
			read = assert(bridge.ui).styled,
		})
		input = host
		environment.method(inputService, "GetGamepadState")(inputService, library.Enum.UserInputType.Gamepad1)
		local driver = Input {
			virtual = {
				SendKey = function(_self: Input.Virtual, down: boolean, code: unknown, _repeat: boolean)
					local name = string.match(tostring(code), "Enum.KeyCode.(.+)")
					host.key { code = assert(name, "expected a KeyCode"), down = down }
				end,
				SendMousePosition = function()
					error("selection input does not send pointer movement", 0)
				end,
				SendMouseButton = function()
					error("selection input does not send pointer buttons", 0)
				end,
			},
			gui = guiService,
			input = inputService,
			types = library,
			inset = function(): (number, number)
				return 0, 0
			end,
			frame = function()
				frame()
			end,
		}
		key = driver.key
		local sheet = new "StyleSheet"
		local rule = new "StyleRule"
		rule.Selector = "Frame"
		environment.method(rule, "SetProperties")(rule, { BackgroundTransparency = 1 })
		rule.Parent = sheet
		local link = new "StyleLink"
		link.StyleSheet = sheet
		local probe = new "Frame"
		sheet.Parent, link.Parent, probe.Parent = target, target, target
		assert(bridge.ui).styled(probe, "BackgroundTransparency")
		probe:Destroy()
		link:Destroy()
		sheet:Destroy()
		assert(bridge.layout).step()
	end
	environment.fake("TextService.GetTextBoundsAsync", function(_service: Roblox.Instance, params: Roblox.Instance)
		local text: unknown, size: unknown = params.Text, params.Size
		assert(type(text) == "string" and type(size) == "number")
		return Vector2.new(#text * size * 0.5, size)
	end)
	local root = Facet.Compose.createRootOwner(function()
		runtime.adopt(target)
	end, runtime.reactor)
	return {
		Facet = Facet,
		Compose = Facet.Compose,
		runtime = runtime,
		Host = runtime.constructors,
		UI = Facet.controls(runtime, {
			types = types,
			services = {
				TextService = textService,
				GuiService = guiService,
				UserInputService = if nativeSelection then inputService else nil,
			},
		}),
		types = types,
		motion = Motion(Facet),
		target = target,
		textService = textService,
		guiService = guiService,
		inputService = inputService,
		key = key,
		heartbeat = environment.heartbeat,
		new = new,
		node = node,
		destroy = function(object: Types.Node)
			object:Destroy()
		end,
		frame = frame,
		spawn = function(callback: () -> ())
			callback()
		end,
		pin = function(object: Roblox.Instance, width: number, height: number)
			if nativeSelection then
				object.Size = library.UDim2.fromOffset(width, height)
				assert(bridge.layout).step()
				return
			end
			environment.poke(object, "AbsoluteSize", Vector2.new(width, height))
			if object:IsA "ScrollingFrame" then
				environment.poke(object, "AbsoluteWindowSize", Vector2.new(width, height))
			end
		end,
		poke = environment.poke,
		fire = environment.fire,
		dispose = function()
			root.dispose()
			runtime:dispose()
			assert(#target:GetChildren() == 0, "the workload left mounted nodes")
			if input then
				input.close()
			end
			if dataModel then
				dataModel:Destroy()
				bridge.close()
			end
		end,
		census = function(): Census
			local accounting = bridge.accounting()
			return { live = accounting.objects, connections = accounting.connections }
		end,
		observe = bridge.observe,
	}
end

return { create = create, facet = facet, types = types, fallbacks = Upstream.fallbacks, SETTLE_FRAMES = 30 }
