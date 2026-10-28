--!strict

local Engine = require "../../.lute/dependencies/compose/src/roblox/engine"

export type Counters = {
	instancesCreated: number,
	instancesDestroyed: number,
	propertyWrites: number,
	propertyReads: number,
	parentChanges: number,
	connectionsMade: number,
	connectionsBroken: number,
	eventsFired: number,
	tasksDeferred: number,
}

export type Connection = Engine.Connection
type StoredConnection = Connection & {
	Connected: boolean,
	disconnect: (Connection) -> (),
	__handler: (...unknown) -> (),
	__datatype: string,
}
export type Signal<A... = ...unknown> = Engine.Signal<A...>
type StoredSignal = Signal & {
	Once: (Signal, (...unknown) -> ()) -> Connection,
	__fire: (unknown, ...unknown) -> (),
	__sever: (unknown) -> (),
	__datatype: string,
}
export type Instance = {
	[string]: unknown,
	ClassName: string,
	Name: string,
	Parent: unknown,
	Destroy: (Engine.Instance) -> (),
	Clone: (Instance) -> Instance,
	GetChildren: (Instance) -> { Instance },
	GetDescendants: (Instance) -> { Instance },
	FindFirstChild: (Instance, string) -> Instance?,
	GetFullName: (Instance) -> string,
	GetTags: (Instance) -> { string },
	AddTag: (Instance, string) -> (),
	RemoveTag: (Instance, string) -> (),
	HasTag: (Instance, string) -> boolean,
	ClearAllChildren: (Instance) -> (),
	IsA: (Instance, string) -> boolean,
	IsDescendantOf: (Instance, unknown) -> boolean,
	GetPropertyChangedSignal: (Engine.Instance, string) -> Signal<()>,
	GetAttribute: (Instance, string) -> unknown,
	SetAttribute: (Engine.Instance, string, unknown) -> (),
}
export type InstanceFactory = { new: (string, Instance?) -> Instance }
export type Vector2Value = { X: number, Y: number, Magnitude: number }
export type Vector3Value = { X: number, Y: number, Z: number, Magnitude: number, Position: nil? }
export type Color3Value = { R: number, G: number, B: number, Time: nil?, __datatype: string?, [number]: ColorKeypoint }
export type UDimValue = { Scale: number, Offset: number }
export type UDim2Value = { X: UDimValue, Y: UDimValue }
export type CFrameValue = {
	Position: Vector3Value,
	p: Vector3Value,
	X: number,
	Y: number,
	Z: number,
	Rotation: { number },
	GetComponents: (Engine.CFrame) -> ...number,
}
export type NumberRangeValue = { Min: number, Max: number }
export type NumberKeypoint = { Time: number, Value: number, Envelope: number }
export type NumberSequenceValue = { Keypoints: { NumberKeypoint } }
export type ColorKeypoint = { Time: number, Value: Color3Value, R: nil?, __datatype: string?, [number]: ColorKeypoint }
type ColorKeypoints = { [number]: ColorKeypoint, Time: nil?, R: nil? }
export type ColorSequenceValue = { Keypoints: { ColorKeypoint } }
export type RectValue = { Min: Vector2Value, Max: Vector2Value }
export type RayValue = { Origin: Vector3Value, Direction: Vector3Value }
export type PhysicalPropertiesValue = {
	Density: number,
	Friction: number,
	Elasticity: number,
	FrictionWeight: number,
	ElasticityWeight: number,
}
export type Int2Value = { X: number, Y: number }
export type Int3Value = { X: number, Y: number, Z: number }
export type Region3Value = { Min: Vector3Value, Max: Vector3Value }
export type Region3int16Value = { Min: Int3Value, Max: Int3Value }
export type DateTimeValue = { UnixTimestampMillis: number }
export type EnumItem = { Name: string, EnumType: string, Value: number }
export type Vector2Factory = {
	new: (number?, number?) -> Vector2Value,
	zero: Vector2Value,
	one: Vector2Value,
	xAxis: Vector2Value,
	yAxis: Vector2Value,
}
export type Vector3Factory = {
	new: (number?, number?, number?) -> Vector3Value,
	zero: Vector3Value,
	one: Vector3Value,
	xAxis: Vector3Value,
	yAxis: Vector3Value,
	zAxis: Vector3Value,
}
export type RunService = {
	Heartbeat: Signal<number>,
	RenderStepped: Signal<number>,
	PreRender: Signal<number>,
	PostSimulation: Signal<number>,
	IsClient: () -> boolean,
	IsServer: () -> boolean,
	IsRunning: () -> boolean,
	IsStudio: () -> boolean,
	BindToRenderStep: (RunService, string, number, (...unknown) -> ()) -> (),
	UnbindFromRenderStep: (RunService, string) -> (),
}
export type Globals = {
	[string]: unknown,
	Instance: InstanceFactory,
	game: { GetService: (unknown, string) -> unknown, IsLoaded: () -> boolean },
	workspace: unknown,
	Vector2: Vector2Factory,
	Vector3: Vector3Factory,
	Color3: {
		new: (number?, number?, number?) -> Color3Value,
		fromRGB: (number?, number?, number?) -> Color3Value,
		fromHSV: (number, number, number) -> Color3Value,
	},
	UDim: { new: (number?, number?) -> UDimValue },
	UDim2: {
		new: (number?, number?, number?, number?) -> UDim2Value,
		fromScale: (number?, number?) -> UDim2Value,
		fromOffset: (number?, number?) -> UDim2Value,
	},
	CFrame: { new: (number | Vector3Value, number?, number?) -> CFrameValue, identity: CFrameValue },
	NumberRange: { new: (number, number?) -> NumberRangeValue },
	NumberSequenceKeypoint: { new: (number, number, number?) -> NumberKeypoint },
	NumberSequence: { new: (number | { NumberKeypoint }, number?) -> NumberSequenceValue },
	ColorSequenceKeypoint: { new: (number, Color3Value) -> ColorKeypoint },
	ColorSequence: { new: (Color3Value | ColorKeypoint | ColorKeypoints, Color3Value?) -> ColorSequenceValue },
	Rect: { new: (number | Vector2Value, number | Vector2Value?, number?, number?) -> RectValue },
	Ray: { new: (Vector3Value, Vector3Value) -> RayValue },
	PhysicalProperties: { new: (number, number?, number?, number?, number?) -> PhysicalPropertiesValue },
	Region3: { new: (Vector3Value, Vector3Value) -> Region3Value },
	Region3int16: { new: (Int3Value, Int3Value) -> Region3int16Value },
	Vector2int16: { new: (number?, number?) -> Int2Value },
	Vector3int16: { new: (number?, number?, number?) -> Int3Value },
	DateTime: { fromUnixTimestampMillis: (number) -> DateTimeValue, fromUnixTimestamp: (number) -> DateTimeValue },

	Enum: { [string]: { [string]: EnumItem } },
	typeof: (unknown) -> string,
	os: { clock: () -> number, time: () -> number, date: typeof(os.date) },
	task: {
		defer: <A...>((A...) -> (), A...) -> (),
		delay: <A...>(number, (A...) -> (), A...) -> (),
		spawn: <A...>((A...) -> () | thread, A...) -> (),
		cancel: (thread) -> (),
		wait: (number?) -> number,
		synchronize: () -> (),
		desynchronize: () -> (),
	},
}
export type Environment = {
	globals: Globals,
	heartbeat: Signal,
	container: () -> Instance,
	step: (number) -> (),
	drain: () -> (),
	counters: () -> Counters,
	resetCounters: () -> (),
	liveInstances: () -> number,
	liveConnections: () -> number,
	snapshot: (Instance, { string }?, string?) -> string,
	fire: (Instance, string, ...unknown) -> (),
	diagnostics: () -> { string },
	get: (Instance, string) -> unknown,
	children: (Instance) -> { Instance },
	instance: (unknown) -> Instance,
	signal: (Instance, string) -> Signal,
}
type State = {
	className: string,
	properties: { [string]: unknown },
	children: { Instance },
	parent: Instance?,
	events: { [string]: StoredSignal },
	changed: { [string]: StoredSignal },
	attributes: { [string]: unknown },
	tags: { [string]: true },
	destroyed: boolean,
}

type LookupMeta = { __index: unknown?, __tostring: unknown? }

local function dictionaryMeta<K, V>(object: { [K]: V }, meta: LookupMeta)
	setmetatable(object, meta)
end

local function serviceMeta(object: { GetService: (unknown, string) -> unknown }, meta: LookupMeta)
	setmetatable(object, meta)
end

local function tableFields(value: unknown): { [string]: unknown }
	assert(type(value) == "table")
	return value :: { [string]: unknown }
end

local function zeroCounters(): Counters
	return {
		instancesCreated = 0,
		instancesDestroyed = 0,
		propertyWrites = 0,
		propertyReads = 0,
		parentChanges = 0,
		connectionsMade = 0,
		connectionsBroken = 0,
		eventsFired = 0,
		tasksDeferred = 0,
	}
end

local CLASS_PROPERTIES: { [string]: { [string]: unknown } } = {
	Folder = { Name = "Folder" },
	Frame = {
		Name = "Frame",
		Visible = true,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		ZIndex = 1,
		Active = false,
		ClipsDescendants = false,
	},
	TextLabel = {
		Name = "TextLabel",
		Text = "",
		Visible = true,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		ZIndex = 1,
		TextTransparency = 0,
		RichText = false,
	},
	TextButton = {
		Name = "TextButton",
		Text = "",
		Visible = true,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		ZIndex = 1,
		AutoButtonColor = true,
	},
	ImageLabel = {
		Name = "ImageLabel",
		Image = "",
		Visible = true,
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		LayoutOrder = 0,
		ZIndex = 1,
	},
	ScreenGui = { Name = "ScreenGui", Enabled = true, ResetOnSpawn = true, DisplayOrder = 0 },
	BillboardGui = {
		Name = "BillboardGui",
		Enabled = true,
		AlwaysOnTop = false,
		LightInfluence = 0,
		MaxDistance = math.huge,
		ResetOnSpawn = true,
	},
	UIListLayout = { Name = "UIListLayout", Padding = 0 },
	Part = { Name = "Part", Transparency = 0, Anchored = false, CanCollide = true, Position = 0 },
	MeshPart = { Name = "MeshPart", Transparency = 0, Anchored = false, CanCollide = true, Position = 0 },
	Attachment = { Name = "Attachment", Visible = false, Position = 0 },
	Highlight = { Name = "Highlight", Enabled = true, FillTransparency = 0, OutlineTransparency = 0 },
	ParticleEmitter = { Name = "ParticleEmitter", Enabled = false, Rate = 0, Lifetime = 1 },
	Model = { Name = "Model", Transparency = 0 },
	Configuration = { Name = "Configuration" },
}

local CLASS_EVENTS: { [string]: { string } } = {
	Folder = { "ChildAdded", "ChildRemoved" },
	Frame = { "InputBegan", "InputEnded", "MouseEnter", "MouseLeave", "ChildAdded", "ChildRemoved" },
	TextLabel = { "InputBegan", "ChildAdded", "ChildRemoved" },
	TextButton = { "Activated", "MouseButton1Click", "InputBegan", "ChildAdded", "ChildRemoved" },
	ImageLabel = { "InputBegan", "ChildAdded", "ChildRemoved" },
	ScreenGui = { "ChildAdded", "ChildRemoved" },
	BillboardGui = { "ChildAdded", "ChildRemoved" },
	UIListLayout = {},
	Part = { "Touched", "TouchEnded", "ChildAdded", "ChildRemoved" },
	MeshPart = { "Touched", "TouchEnded", "ChildAdded", "ChildRemoved" },
	Attachment = { "ChildAdded", "ChildRemoved" },
	Highlight = { "ChildAdded", "ChildRemoved" },
	ParticleEmitter = { "ChildAdded", "ChildRemoved" },
	Model = { "ChildAdded", "ChildRemoved" },
	Configuration = { "ChildAdded", "ChildRemoved" },
}

type Handler = (...unknown) -> ()

local function create(): Environment
	local counters = zeroCounters()
	local liveInstanceCount = 0
	local liveConnectionCount = 0
	type Deferred = { fn: Handler, arguments: { n: number, [number]: unknown } }
	type Delayed = { at: number, fn: Handler, arguments: { n: number, [number]: unknown } }
	local deferred: { Deferred } = {}
	local delayed: { Delayed } = {}
	local clock = 0
	local clockReads = 0

	local function makeSignal(): StoredSignal
		local handlers: { Handler } = {}
		local connections: { StoredConnection } = {}
		local signal = { __datatype = "RBXScriptSignal" }

		local function release(connection: StoredConnection)
			if not connection.Connected then
				return
			end
			connection.Connected = false
			counters.connectionsBroken += 1
			liveConnectionCount -= 1
			for index, candidate in handlers do
				if candidate == connection.__handler then
					table.remove(handlers, index)
					break
				end
			end
			for index, candidate in connections do
				if candidate == connection then
					table.remove(connections, index)
					break
				end
			end
		end

		function signal.Connect(_self: Signal, handler: Handler): Connection
			table.insert(handlers, handler)
			counters.connectionsMade += 1
			liveConnectionCount += 1
			local connection: StoredConnection
			local function disconnect(_self: Connection)
				release(connection)
			end
			connection = {
				Connected = true,
				__handler = handler,
				__datatype = "RBXScriptConnection",
				Disconnect = disconnect,
				disconnect = disconnect,
			}
			table.insert(connections, connection)
			return connection
		end

		signal.Once = signal.Connect

		function signal.__fire(_self: unknown, ...: unknown)
			counters.eventsFired += 1
			for _, handler in table.clone(handlers) do
				handler(...)
			end
		end

		function signal.__sever(_self: unknown)
			for _, connection in table.clone(connections) do
				release(connection)
			end
		end

		return signal
	end

	local states: { [unknown]: State } = {}
	local roots: { [unknown]: boolean } = {}
	local gameIdentity: unknown = nil
	local vector3Default: unknown = nil
	setmetatable(states, { __mode = "k" })
	local instances: { [unknown]: Instance } = {}
	setmetatable(instances, { __mode = "kv" })
	local instanceIndex: (object: Instance, key: string) -> unknown
	local instanceNewIndex: (object: Instance, key: string, value: unknown) -> ()

	local function stateOf(object: Instance): State
		return states[object]
	end

	local function newInstance(className: string): Instance
		local defaults = CLASS_PROPERTIES[className]
		if defaults == nil then
			error(("Unable to create an Instance of type %q"):format(className), 0)
		end
		counters.instancesCreated += 1
		liveInstanceCount += 1

		local events: { [string]: StoredSignal } = {}
		for _, event in CLASS_EVENTS[className] do
			events[event] = makeSignal()
		end

		events.Destroying = makeSignal()
		events.AncestryChanged = makeSignal()

		local proxy = newproxy(true)
		local object: Instance = proxy
		instances[object] = object
		local properties = table.clone(defaults)
		if properties.Position ~= nil then
			properties.Position = vector3Default
		end
		states[object] = {
			className = className,
			properties = properties,
			children = {},
			parent = nil,
			events = events,
			changed = {},
			attributes = {},
			tags = {},
			destroyed = false,
		}

		local objectMeta = getmetatable(proxy)
		objectMeta.__index = instanceIndex
		objectMeta.__newindex = instanceNewIndex
		objectMeta.__tostring = function(self: Instance): string
			local name = states[self].properties.Name
			assert(type(name) == "string")
			return name
		end
		return object
	end

	local function detach(object: Instance)
		local state = stateOf(object)
		local parent = state.parent
		if parent == nil then
			return
		end
		local siblings = stateOf(parent).children
		for index, candidate in siblings do
			if candidate == object then
				table.remove(siblings, index)
				break
			end
		end
		state.parent = nil
	end

	local destroyInstance: (object: Instance) -> ()
	function destroyInstance(object: Instance)
		local state = stateOf(object)
		if state.destroyed then
			return
		end
		state.destroyed = true
		counters.instancesDestroyed += 1
		liveInstanceCount -= 1

		local destroying = state.events.Destroying
		if destroying ~= nil then
			destroying:__fire(object)
		end
		detach(object)
		for _, child in table.clone(state.children) do
			destroyInstance(child)
		end
		state.children = {}
		for _, signal in state.events do
			signal:__sever()
		end
		for _, signal in state.changed do
			signal:__sever()
		end
	end

	function instanceIndex(object: Instance, key: string): unknown
		local state = stateOf(object)
		if key == "ClassName" then
			return state.className
		elseif key == "Parent" then
			return state.parent
		elseif key == "IsDescendantOf" then
			return function(self: Instance, ancestor: unknown): boolean
				local current = stateOf(self).parent
				while current do
					if current == ancestor or (roots[current] and ancestor == gameIdentity) then
						return true
					end
					current = stateOf(current).parent
				end
				return false
			end
		elseif key == "Destroy" then
			return destroyInstance
		elseif key == "Clone" then
			return function(self: Instance): Instance
				local copy = newInstance(stateOf(self).className)
				for property, value in stateOf(self).properties do
					stateOf(copy).properties[property] = value
				end
				return copy
			end
		elseif key == "GetChildren" then
			return function(self: Instance): { Instance }
				return table.clone(stateOf(self).children)
			end
		elseif key == "GetDescendants" then
			return function(self: Instance): { Instance }
				local found: { Instance } = {}
				local function walk(current: Instance)
					for _, child in stateOf(current).children do
						table.insert(found, child)
						walk(child)
					end
				end
				walk(self)
				return found
			end
		elseif key == "FindFirstChild" then
			return function(self: Instance, name: string): unknown?
				for _, child in stateOf(self).children do
					if stateOf(child).properties.Name == name then
						return child
					end
				end
				return nil
			end
		elseif key == "GetFullName" then
			return function(self: Instance): string
				local parts: { string } = {}
				local current: Instance? = self
				while current ~= nil do
					table.insert(parts, 1, tostring(stateOf(current).properties.Name))
					current = stateOf(current).parent
				end
				return table.concat(parts, ".")
			end
		elseif key == "GetTags" then
			return function(self: Instance): { string }
				local tags: { string } = {}
				for tag in stateOf(self).tags do
					table.insert(tags, tag)
				end
				table.sort(tags)
				return tags
			end
		elseif key == "AddTag" then
			return function(self: Instance, tag: string)
				stateOf(self).tags[tag] = true
			end
		elseif key == "RemoveTag" then
			return function(self: Instance, tag: string)
				stateOf(self).tags[tag] = nil
			end
		elseif key == "HasTag" then
			return function(self: Instance, tag: string): boolean
				return stateOf(self).tags[tag] == true
			end
		elseif key == "ClearAllChildren" then
			return function(self: Instance)
				for _, child in table.clone(stateOf(self).children) do
					destroyInstance(child)
				end
			end
		elseif key == "IsA" then
			return function(self: Instance, className: string): boolean
				return stateOf(self).className == className
			end
		elseif key == "GetPropertyChangedSignal" then
			return function(self: Instance, property: string): Signal
				local own = stateOf(self)
				local existing = own.changed[property]
				if existing == nil then
					existing = makeSignal()
					own.changed[property] = existing
				end
				return existing
			end
		elseif key == "GetAttribute" then
			return function(self: Instance, name: string): unknown
				return stateOf(self).attributes[name]
			end
		elseif key == "SetAttribute" then
			return function(self: Instance, name: string, value: unknown)
				stateOf(self).attributes[name] = value
			end
		end
		local event = state.events[key]
		if event ~= nil then
			return event
		end
		counters.propertyReads += 1
		return state.properties[key]
	end

	function instanceNewIndex(object: Instance, key: string, value: unknown)
		local state = stateOf(object)

		if key == "Parent" then
			if state.destroyed then
				if value == nil then
					return
				end
				error("The Parent property of a destroyed Instance is locked", 0)
			end
			counters.parentChanges += 1
			if state.parent == instances[value] then
				return
			end
			detach(object)
			state.parent = instances[value]
			if value ~= nil then
				table.insert(stateOf(instances[value]).children, object)
			end
			local function changed(current: Instance)
				stateOf(current).events.AncestryChanged:__fire(current, stateOf(current).parent)
				for _, child in stateOf(current).children do
					changed(child)
				end
			end
			changed(object)
			return
		end
		if state.events[key] ~= nil then
			error(("%s.%s is an event and cannot be assigned"):format(state.className, key), 0)
		end
		if state.destroyed then
			counters.propertyWrites += 1
			state.properties[key] = value
			return
		end
		counters.propertyWrites += 1
		local previous = state.properties[key]
		state.properties[key] = value
		if previous ~= value then
			local signal = state.changed[key]
			if signal ~= nil then
				signal:__fire()
			end
		end
	end

	type Operators = { __add: unknown?, __sub: unknown?, __mul: unknown?, __div: unknown?, __unm: unknown? }

	local function decorate(name: string, fields: { __datatype: string? }, operators: Operators?)
		fields.__datatype = name
		local meta: { [string]: unknown } = {
			__eq = function(left: { [string]: unknown }, right: { [string]: unknown }): boolean
				for key, value in left do
					if key ~= "__datatype" and right[key] ~= value then
						return false
					end
				end
				return true
			end,
			__tostring = function(): string
				return name
			end,
		}
		if operators ~= nil then
			meta.__add = operators.__add
			meta.__sub = operators.__sub
			meta.__mul = operators.__mul
			meta.__div = operators.__div
			meta.__unm = operators.__unm
		end
		setmetatable(fields, meta)
	end

	local function tagged<T>(name: string, fields: T & { __datatype: string? }, operators: Operators?): T
		decorate(name, fields, operators)
		return fields
	end

	local Vector2 = {}
	local Vector3 = {}
	local UDim = {}
	local UDim2 = {}

	local function scale2(value: Vector2Value, factor: number): Vector2Value
		return Vector2.new(value.X * factor, value.Y * factor)
	end
	function Vector2.new(x: number?, y: number?): Vector2Value
		local vx, vy = x or 0, y or 0
		return tagged("Vector2", { X = vx, Y = vy, Magnitude = math.sqrt(vx * vx + vy * vy) }, {
			__add = function(a: Vector2Value, b: Vector2Value): Vector2Value
				return Vector2.new(a.X + b.X, a.Y + b.Y)
			end,
			__sub = function(a: Vector2Value, b: Vector2Value): Vector2Value
				return Vector2.new(a.X - b.X, a.Y - b.Y)
			end,
			__mul = function(a: Vector2Value | number, b: Vector2Value | number): Vector2Value
				if type(b) == "number" then
					assert(type(a) == "table")
					return scale2(a, b)
				end
				if type(a) == "number" then
					return scale2(b, a)
				end
				return Vector2.new(a.X * b.X, a.Y * b.Y)
			end,
			__div = function(a: Vector2Value, b: Vector2Value | number): Vector2Value
				if type(b) == "number" then
					return scale2(a, 1 / b)
				end
				return Vector2.new(a.X / b.X, a.Y / b.Y)
			end,
			__unm = function(a: Vector2Value): Vector2Value
				return Vector2.new(-a.X, -a.Y)
			end,
		})
	end
	Vector2.zero = Vector2.new(0, 0)
	Vector2.one = Vector2.new(1, 1)
	Vector2.xAxis = Vector2.new(1, 0)
	Vector2.yAxis = Vector2.new(0, 1)

	local function scale3(value: Vector3Value, factor: number): Vector3Value
		return Vector3.new(value.X * factor, value.Y * factor, value.Z * factor)
	end
	function Vector3.new(x: number?, y: number?, z: number?): Vector3Value
		local vx, vy, vz = x or 0, y or 0, z or 0
		return tagged("Vector3", {
			X = vx,
			Y = vy,
			Z = vz,
			Position = nil,
			Magnitude = math.sqrt(vx * vx + vy * vy + vz * vz),
		}, {
			__add = function(a: Vector3Value, b: Vector3Value): Vector3Value
				return Vector3.new(a.X + b.X, a.Y + b.Y, a.Z + b.Z)
			end,
			__sub = function(a: Vector3Value, b: Vector3Value): Vector3Value
				return Vector3.new(a.X - b.X, a.Y - b.Y, a.Z - b.Z)
			end,
			__mul = function(a: Vector3Value | number, b: Vector3Value | number): Vector3Value
				if type(b) == "number" then
					assert(type(a) == "table")
					return scale3(a, b)
				end
				if type(a) == "number" then
					return scale3(b, a)
				end
				return Vector3.new(a.X * b.X, a.Y * b.Y, a.Z * b.Z)
			end,
			__div = function(a: Vector3Value, b: Vector3Value | number): Vector3Value
				if type(b) == "number" then
					return scale3(a, 1 / b)
				end
				return Vector3.new(a.X / b.X, a.Y / b.Y, a.Z / b.Z)
			end,
			__unm = function(a: Vector3Value): Vector3Value
				return Vector3.new(-a.X, -a.Y, -a.Z)
			end,
		})
	end
	Vector3.zero = Vector3.new(0, 0, 0)
	Vector3.one = Vector3.new(1, 1, 1)
	Vector3.xAxis = Vector3.new(1, 0, 0)
	Vector3.yAxis = Vector3.new(0, 1, 0)
	Vector3.zAxis = Vector3.new(0, 0, 1)

	local NumberRange = {}
	function NumberRange.new(minimum: number, maximum: number?)
		return tagged("NumberRange", { Min = minimum, Max = if maximum ~= nil then maximum else minimum })
	end

	local NumberSequenceKeypoint = {}
	function NumberSequenceKeypoint.new(time: number, value: number, envelope: number?)
		return tagged("NumberSequenceKeypoint", { Time = time, Value = value, Envelope = envelope or 0 })
	end

	local NumberSequence = {}
	function NumberSequence.new(first: number | { NumberKeypoint }, second: number?): NumberSequenceValue
		local keypoints: { NumberKeypoint }
		if type(first) == "table" then
			keypoints = first
		elseif second ~= nil then
			keypoints = {
				NumberSequenceKeypoint.new(0, first),
				NumberSequenceKeypoint.new(1, second),
			}
		else
			keypoints = { NumberSequenceKeypoint.new(0, first), NumberSequenceKeypoint.new(1, first) }
		end
		return tagged("NumberSequence", { Keypoints = keypoints })
	end

	local ColorSequenceKeypoint = {}
	function ColorSequenceKeypoint.new(time: number, value: Color3Value): ColorKeypoint
		local fields: ColorKeypoint = { Time = time, Value = value, R = nil }
		return tagged("ColorSequenceKeypoint", fields)
	end

	local ColorSequence = {}
	function ColorSequence.new(
		first: Color3Value | ColorKeypoint | ColorKeypoints,
		second: Color3Value?
	): ColorSequenceValue
		local keypoints: { ColorKeypoint }
		if first.Time ~= nil then
			keypoints = { first }
		elseif first.R ~= nil then
			local last = if second ~= nil then second else first
			keypoints = {
				ColorSequenceKeypoint.new(0, first),
				ColorSequenceKeypoint.new(1, last),
			}
		else
			keypoints = first
		end
		return tagged("ColorSequence", { Keypoints = keypoints })
	end

	local Rect = {}
	function Rect.new(
		minX: number | Vector2Value,
		minY: number | Vector2Value?,
		maxX: number?,
		maxY: number?
	): { Min: Vector2Value, Max: Vector2Value }
		if type(minX) == "table" then
			assert(type(minY) == "table")
			return tagged("Rect", { Min = minX, Max = minY })
		end
		assert(type(minY) ~= "table")
		return tagged("Rect", {
			Min = Vector2.new(minX, minY),
			Max = Vector2.new(maxX, maxY),
		})
	end

	local Ray = {}
	function Ray.new(origin: Vector3Value, direction: Vector3Value): RayValue
		return tagged("Ray", { Origin = origin, Direction = direction })
	end

	local PhysicalProperties = {}
	function PhysicalProperties.new(
		density: number,
		friction: number?,
		elasticity: number?,
		frictionWeight: number?,
		elasticityWeight: number?
	)
		return tagged("PhysicalProperties", {
			Density = density,
			Friction = friction or 0,
			Elasticity = elasticity or 0,
			FrictionWeight = frictionWeight or 1,
			ElasticityWeight = elasticityWeight or 1,
		})
	end

	local Region3 = {}
	function Region3.new(minimum: Vector3Value, maximum: Vector3Value): Region3Value
		return tagged("Region3", { CFrame = nil, Size = nil, Min = minimum, Max = maximum })
	end

	local Region3int16 = {}
	function Region3int16.new(minimum: Int3Value, maximum: Int3Value): Region3int16Value
		return tagged("Region3int16", { Min = minimum, Max = maximum })
	end

	local Vector2int16 = {}
	function Vector2int16.new(x: number?, y: number?)
		return tagged("Vector2int16", { X = math.floor(x or 0), Y = math.floor(y or 0) })
	end

	local Vector3int16 = {}
	function Vector3int16.new(x: number?, y: number?, z: number?)
		return tagged("Vector3int16", { X = math.floor(x or 0), Y = math.floor(y or 0), Z = math.floor(z or 0) })
	end

	local DateTime = {}
	function DateTime.fromUnixTimestampMillis(millis: number)
		return tagged("DateTime", { UnixTimestampMillis = millis })
	end
	function DateTime.fromUnixTimestamp(seconds: number)
		return DateTime.fromUnixTimestampMillis(seconds * 1000)
	end

	local Color3 = {}
	function Color3.new(r: number?, g: number?, b: number?): Color3Value
		local fields: Color3Value = { R = r or 0, G = g or 0, B = b or 0, Time = nil }
		return tagged("Color3", fields)
	end
	function Color3.fromRGB(r: number?, g: number?, b: number?)
		return Color3.new((r or 0) / 255, (g or 0) / 255, (b or 0) / 255)
	end
	function Color3.fromHSV(h: number, s: number, v: number)
		local c = v * s
		local x = c * (1 - math.abs((h * 6) % 2 - 1))
		local m = v - c
		return Color3.new(c + m, x + m, m)
	end

	function UDim.new(scale: number?, offset: number?): UDimValue
		return tagged("UDim", { Scale = scale or 0, Offset = offset or 0 }, {
			__add = function(a: UDimValue, b: UDimValue): UDimValue
				return UDim.new(a.Scale + b.Scale, a.Offset + b.Offset)
			end,
			__sub = function(a: UDimValue, b: UDimValue): UDimValue
				return UDim.new(a.Scale - b.Scale, a.Offset - b.Offset)
			end,
			__unm = function(a: UDimValue): UDimValue
				return UDim.new(-a.Scale, -a.Offset)
			end,
		})
	end

	function UDim2.new(xs: number?, xo: number?, ys: number?, yo: number?): UDim2Value
		return tagged("UDim2", { X = UDim.new(xs, xo), Y = UDim.new(ys, yo) }, {
			__add = function(a: UDim2Value, b: UDim2Value): UDim2Value
				return UDim2.new(
					a.X.Scale + b.X.Scale,
					a.X.Offset + b.X.Offset,
					a.Y.Scale + b.Y.Scale,
					a.Y.Offset + b.Y.Offset
				)
			end,
			__sub = function(a: UDim2Value, b: UDim2Value): UDim2Value
				return UDim2.new(
					a.X.Scale - b.X.Scale,
					a.X.Offset - b.X.Offset,
					a.Y.Scale - b.Y.Scale,
					a.Y.Offset - b.Y.Offset
				)
			end,
			__unm = function(a: UDim2Value): UDim2Value
				return UDim2.new(-a.X.Scale, -a.X.Offset, -a.Y.Scale, -a.Y.Offset)
			end,
		})
	end
	function UDim2.fromScale(x: number?, y: number?): UDim2Value
		return UDim2.new(x, 0, y, 0)
	end
	function UDim2.fromOffset(x: number?, y: number?): UDim2Value
		return UDim2.new(0, x, 0, y)
	end

	local CFrame = {}
	local frames: { [unknown]: CFrameValue } = {}
	setmetatable(frames, { __mode = "kv" })
	function CFrame.new(x: number | Vector3Value, y: number?, z: number?): CFrameValue
		local position = if type(x) == "table" then x else Vector3.new(x, y, z)
		local frame: CFrameValue = tagged("CFrame", {
			Position = position,
			p = position,
			X = position.X,
			Y = position.Y,
			Z = position.Z,
			Rotation = { 1, 0, 0, 0, 1, 0, 0, 0, 1 },
			GetComponents = function(self: Engine.CFrame): ...number
				local current = frames[self]
				return current.Position.X, current.Position.Y, current.Position.Z, table.unpack(current.Rotation, 1, 9)
			end,
		}, {
			__mul = function(a: CFrameValue, b: CFrameValue | Vector3Value): CFrameValue | Vector3Value
				local other = b.Position
				if other ~= nil then
					return CFrame.new(
						Vector3.new(a.Position.X + other.X, a.Position.Y + other.Y, a.Position.Z + other.Z)
					)
				end
				return Vector3.new(a.Position.X + b.X, a.Position.Y + b.Y, a.Position.Z + b.Z)
			end,
		})
		frames[frame] = frame
		return frame
	end
	CFrame.identity = CFrame.new(0, 0, 0)

	local enumItems: { [string]: { [string]: EnumItem } } = {}
	local function enumFor(enumName: string): { [string]: EnumItem }
		local existing = enumItems[enumName]
		if existing ~= nil then
			return existing
		end
		local items: { [string]: EnumItem } = {}
		local enum: { [string]: EnumItem } = {}
		dictionaryMeta(enum, {
			__index = function(_: unknown, itemName: string): EnumItem
				local item = items[itemName]
				if item == nil then
					item = tagged("EnumItem", { Name = itemName, EnumType = enumName, Value = 0 })
					items[itemName] = item
				end
				return item
			end,
			__tostring = function(): string
				return "Enum." .. enumName
			end,
		})
		enumItems[enumName] = enum
		return enum
	end

	local Enum: { [string]: { [string]: EnumItem } } = {}
	dictionaryMeta(Enum, {
		__index = function(_: unknown, enumName: string): { [string]: EnumItem }
			return enumFor(enumName)
		end,
		__tostring = function(): string
			return "Enums"
		end,
	})

	local function typeName(value: unknown): string
		local kind = typeof(value)
		if kind == "userdata" then
			if states[value] ~= nil then
				return "Instance"
			end
			return "userdata"
		end
		if kind ~= "table" then
			return kind
		end
		local datatype = rawget(tableFields(value), "__datatype")
		if datatype ~= nil then
			assert(type(datatype) == "string")
			return datatype
		end
		return "table"
	end

	vector3Default = Vector3.zero
	local heartbeat = makeSignal()
	local renderStepped = makeSignal()
	local runService = {
		Heartbeat = heartbeat,
		RenderStepped = renderStepped,
		PostSimulation = heartbeat,
		PreRender = renderStepped,
		IsClient = function(): boolean
			return true
		end,
		IsServer = function(): boolean
			return false
		end,
		IsRunning = function(): boolean
			return true
		end,
		IsStudio = function(): boolean
			return false
		end,
	}

	type RenderBinding = { id: string, priority: number, fn: Handler }
	local renderBindings: { RenderBinding } = {}
	function runService.BindToRenderStep(_self: Instance, id: string, priority: number, fn: Handler)
		table.insert(renderBindings, { id = id, priority = priority, fn = fn })
		table.sort(renderBindings, function(left: RenderBinding, right: RenderBinding): boolean
			if left.priority ~= right.priority then
				return left.priority < right.priority
			end
			return left.id < right.id
		end)
	end
	function runService.UnbindFromRenderStep(_self: Instance, id: string)
		for index, binding in renderBindings do
			if binding.id == id then
				table.remove(renderBindings, index)
				return
			end
		end
	end

	local guidCounter = 0
	local httpService = {
		GenerateGUID = function(_self: Instance, wrapped: boolean?): string
			guidCounter += 1
			local guid = ("%08x-0000-4000-8000-%012x"):format(guidCounter, guidCounter)
			return if wrapped == false then guid else "{" .. guid .. "}"
		end,
		JSONEncode = function(_self: Instance, value: unknown): string
			return tostring(value)
		end,
		JSONDecode = function(_self: Instance, _text: string): unknown
			return {}
		end,
	}

	local collectionService = {
		AddTag = function(_self: Instance, instance: Instance, tag: string)
			stateOf(instance).tags[tag] = true
		end,
		RemoveTag = function(_self: Instance, instance: Instance, tag: string)
			stateOf(instance).tags[tag] = nil
		end,
		HasTag = function(_self: Instance, instance: Instance, tag: string): boolean
			return stateOf(instance).tags[tag] == true
		end,
		GetTags = function(_self: Instance, instance: Instance): { string }
			local tags: { string } = {}
			for tag in stateOf(instance).tags do
				table.insert(tags, tag)
			end
			table.sort(tags)
			return tags
		end,
		GetTagged = function(_self: Instance, _tag: string): { Instance }
			return {}
		end,
	}

	local guiService = {
		TopbarInset = nil,
		GetGuiInset = function(): (Vector2Value, Vector2Value)
			return Vector2.new(0, 36), Vector2.new(0, 0)
		end,
		GetPropertyChangedSignal = function(_self: Instance, _property: string): Signal
			return {
				Connect = function()
					return { Disconnect = function() end, Connected = true }
				end,
			}
		end,
	}

	local services: { [string]: unknown } = {
		RunService = runService,
		HttpService = httpService,
		CollectionService = collectionService,
		GuiService = guiService,
	}
	local dataModel = {
		IsLoaded = function(): boolean
			return true
		end,
		GetService = function(_self: unknown, name: string): unknown
			local existing = services[name]
			if existing == nil then
				existing = newInstance "Folder"
				services[name] = existing
			end
			return existing
		end,
	}
	gameIdentity = dataModel
	serviceMeta(dataModel, {
		__index = function(_: unknown, key: string): unknown
			return services[key]
		end,
	})

	local pack = (table.pack :: unknown) :: <A...>(A...) -> { [number]: unknown, n: number }
	local task = {
		defer = function<A...>(fn: (A...) -> (), ...: A...)
			counters.tasksDeferred += 1
			table.insert(deferred, { fn = (fn :: unknown) :: Handler, arguments = pack(...) })
		end,
		delay = function<A...>(seconds: number, fn: (A...) -> (), ...: A...)
			counters.tasksDeferred += 1
			table.insert(delayed, { at = clock + seconds, fn = (fn :: unknown) :: Handler, arguments = pack(...) })
		end,
		spawn = function<A...>(fn: ((A...) -> ()) | thread, ...: A...)
			if type(fn) == "thread" then
				coroutine.resume(fn, ...)
			else
				fn(...)
			end
		end,
		cancel = function(_thread: thread) end,
		wait = function(_seconds: number?): number
			return 0
		end,
		synchronize = function() end,
		desynchronize = function() end,
	}

	local function drain()
		local passes = 0
		while #deferred > 0 do
			passes += 1
			if passes > 10000 then
				error("benchmark environment: deferred work did not settle", 0)
			end
			local batch = deferred
			deferred = {}
			for _, entry in batch do
				entry.fn(table.unpack(entry.arguments, 1, entry.arguments.n))
			end
		end
	end

	local function step(delta: number)
		clock += delta
		local due: { Delayed } = {}
		local remaining: { Delayed } = {}
		for _, entry in delayed do
			if entry.at <= clock then
				table.insert(due, entry)
			else
				table.insert(remaining, entry)
			end
		end
		delayed = remaining
		table.sort(due, function(left: Delayed, right: Delayed): boolean
			return left.at < right.at
		end)
		for _, entry in due do
			entry.fn(table.unpack(entry.arguments, 1, entry.arguments.n))
		end

		for _, binding in table.clone(renderBindings) do
			binding.fn(delta)
		end
		renderStepped:__fire(delta)
		heartbeat:__fire(delta)
		drain()
	end

	local diagnostics: { string } = {}
	local function record(...: unknown)
		local parts: { string } = {}
		for index = 1, select("#", ...) do
			table.insert(parts, tostring((select(index, ...))))
		end
		table.insert(diagnostics, table.concat(parts, "\t"))
	end

	local globals: Globals = {
		assert = assert,
		bit32 = bit32,
		buffer = buffer,
		coroutine = coroutine,
		error = error,
		getmetatable = getmetatable,
		ipairs = ipairs,
		math = math,
		newproxy = newproxy,
		next = next,
		pairs = pairs,
		pcall = pcall,
		print = record,
		warn = record,
		rawequal = rawequal,
		rawget = rawget,
		rawlen = rawlen,
		rawset = rawset,
		select = select,
		setmetatable = setmetatable,
		string = string,
		table = table,
		tonumber = tonumber,
		tostring = tostring,
		type = type,
		unpack = unpack,
		utf8 = utf8,
		vector = vector,
		xpcall = xpcall,
		_G = {},

		os = {
			clock = function(): number
				clockReads += 1
				return clock + clockReads * 1e-9
			end,
			time = function(): number
				return math.floor(clock)
			end,
			date = os.date,
		},
		debug = {
			info = debug.info,
			traceback = debug.traceback,
			profilebegin = function(_label: string) end,
			profileend = function() end,
			setmemorycategory = function(_label: string) end,
			resetmemorycategory = function() end,
			getmemorycategory = function(): string
				return "cost-model"
			end,
		},

		game = dataModel,
		workspace = dataModel:GetService "Workspace",
		Instance = {
			new = function(className: string, parent: Instance?): Instance
				local object = newInstance(className)
				if parent ~= nil then
					object.Parent = parent
				end
				return object
			end,
		},
		typeof = typeName,
		task = task,
		Vector2 = Vector2,
		Vector3 = Vector3,
		Color3 = Color3,
		UDim = UDim,
		UDim2 = UDim2,
		CFrame = CFrame,
		NumberRange = NumberRange,
		NumberSequence = NumberSequence,
		NumberSequenceKeypoint = NumberSequenceKeypoint,
		ColorSequence = ColorSequence,
		ColorSequenceKeypoint = ColorSequenceKeypoint,
		Rect = Rect,
		Ray = Ray,
		Region3 = Region3,
		Region3int16 = Region3int16,
		Vector2int16 = Vector2int16,
		Vector3int16 = Vector3int16,
		PhysicalProperties = PhysicalProperties,
		DateTime = DateTime,
		Enum = Enum,
	}

	local renderValue: (value: unknown, depth: number) -> string
	function renderValue(value: unknown, depth: number): string
		if type(value) == "string" then
			return ("%q"):format(value)
		end
		if type(value) ~= "table" or depth > 3 then
			return tostring(value)
		end
		local dictionary = tableFields(value)
		local datatype = rawget(dictionary, "__datatype")
		if datatype == nil then
			return tostring(value)
		end
		local fields: { string } = {}
		for key in dictionary do
			if key ~= "__datatype" then
				table.insert(fields, key)
			end
		end
		table.sort(fields)
		local parts: { string } = {}
		for _, key in fields do
			local field = dictionary[key]
			if type(field) ~= "function" then
				table.insert(parts, ("%s=%s"):format(key, renderValue(field, depth + 1)))
			end
		end
		return ("%s(%s)"):format(tostring(datatype), table.concat(parts, ","))
	end

	local function snapshot(object: Instance, keys: { string }?, sortBy: string?): string
		local wanted: { string }
		if keys ~= nil then
			wanted = table.clone(keys)
			table.sort(wanted)
		else
			wanted = {}
		end

		local lines: { string } = {}
		local function walk(current: Instance, depth: number)
			local state = stateOf(current)
			local rendered: { string } = {}
			for _, key in wanted do
				local value = state.properties[key]
				if value ~= nil then
					table.insert(rendered, ("%s=%s"):format(key, renderValue(value, 0)))
				end
			end
			table.insert(
				lines,
				("%s%s{%s}"):format(string.rep(" ", depth), state.className, table.concat(rendered, ","))
			)
			local children = state.children
			if sortBy ~= nil then
				children = table.clone(children)
				local sortKey = sortBy
				table.sort(children, function(left: Instance, right: Instance): boolean
					local leftKey = states[left].properties[sortKey]
					local rightKey = states[right].properties[sortKey]
					if leftKey == rightKey then
						return tostring(states[left].properties.Name) < tostring(states[right].properties.Name)
					end
					local sortableLeft = leftKey or 0
					local sortableRight = rightKey or 0
					if type(sortableLeft) == "string" and type(sortableRight) == "string" then
						return sortableLeft < sortableRight
					elseif type(sortableLeft) == "number" and type(sortableRight) == "number" then
						return sortableLeft < sortableRight
					end
					error("benchmark environment: snapshot keys must both be numbers or strings", 0)
				end)
			end
			for _, child in children do
				walk(child, depth + 1)
			end
		end
		walk(object, 0)
		return table.concat(lines, "\n")
	end

	return {
		globals = globals,
		heartbeat = heartbeat,
		container = function(): Instance
			local container = newInstance "Folder"
			roots[container] = true
			return container
		end,
		step = step,
		drain = drain,
		counters = function(): Counters
			return table.clone(counters)
		end,
		resetCounters = function()
			counters = zeroCounters()
		end,
		liveInstances = function(): number
			return liveInstanceCount
		end,
		liveConnections = function(): number
			return liveConnectionCount
		end,
		snapshot = snapshot,
		diagnostics = function(): { string }
			return table.clone(diagnostics)
		end,
		fire = function(object: Instance, event: string, ...: unknown)
			local signal = stateOf(object).events[event]
			if signal == nil then
				error(("%s has no event %q"):format(stateOf(object).className, event), 0)
			end
			signal:__fire(...)
		end,
		get = function(object: Instance, key: string): unknown
			return stateOf(object).properties[key]
		end,
		children = function(object: Instance): { Instance }
			return table.clone(stateOf(object).children)
		end,
		instance = function(value: unknown): Instance
			return assert(instances[value])
		end,
		signal = function(object: Instance, event: string): Signal
			return stateOf(object).events[event]
		end,
	}
end

return {
	create = create,
	zeroCounters = zeroCounters,
}
