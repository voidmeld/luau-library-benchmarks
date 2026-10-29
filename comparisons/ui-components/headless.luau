--!strict

local Lute = require "../../.lute/dependencies/verify/src/lute"
local Roblox = require "../../.lute/dependencies/verify/src/roblox"
local Upstream = require "../scene-composition/harness/upstream"
local Types = require "./types"
local Motion = require "./motion"

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
		for name, value in (types :: unknown) :: { [string]: unknown } do
			globals[name] = value
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

local function create(): Headless
	local Facet = facet()
	local environment: Roblox.Environment
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
		ui = {
			measureBounds = false,
			measureText = false,
			selection = "ignore",
			requirePlayerGui = false,
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
		if object:IsA "GuiBase2d" then
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
		UI = Facet.controls(runtime, { types = types, services = { TextService = textService } }),
		types = types,
		motion = Motion(Facet),
		target = target,
		textService = textService,
		guiService = nil,
		inputService = inputService,
		heartbeat = environment.heartbeat,
		new = new,
		node = node,
		destroy = function(object: Types.Node)
			object:Destroy()
		end,
		frame = function(delta: number?)
			elapsed += delta or 1 / 60
			environment.heartbeat:Fire(delta or 1 / 60)
		end,
		spawn = function(callback: () -> ())
			callback()
		end,
		pin = function(object: Roblox.Instance, width: number, height: number)
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
		end,
		census = function(): Census
			local accounting = bridge.accounting()
			return { live = accounting.objects, connections = accounting.connections }
		end,
		observe = bridge.observe,
	}
end

return { create = create, facet = facet, types = types, fallbacks = Upstream.fallbacks, SETTLE_FRAMES = 30 }
