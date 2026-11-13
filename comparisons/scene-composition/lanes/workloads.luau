--!strict

local Environment = require "../cost-model"
local Workloads = require "../workloads"
local WorkloadTypes = require "../workloads/types"
local Types = require "./types"
local GameUI = require "../workloads/game-ui"
local GameReact = require "./game-react"
local GameRoact = require "./game-roact"
local ReactReflex = require "./react-reflex"
local Lists = require "../workloads/large-lists"
local Shared = require "../workloads/shared"

type State = {
	run: () -> (),
	release: () -> (),
	keys: { string },
	sortBy: string?,
	settle: boolean,
}
type Factory = (Environment.Environment) -> Types.Driver
export type Workaround = { workloads: { [string]: boolean }, note: string, factory: Factory }

local coldCompose: Workloads.Case? = nil
local loadedDrivers: { [Environment.Environment]: Types.Driver } = {}
setmetatable(loadedDrivers, { __mode = "k" })
local releases: { (Environment.Environment) -> () } = {}

local function close(environment: Environment.Environment)
	loadedDrivers[environment] = nil
	for _, release in releases do
		release(environment)
	end
end

local function configure(mode: string)
	for _, workload in Workloads.all do
		if workload.id == "library-load" then
			local cases: { [string]: Workloads.Case } = {}
			for name, case in workload.cases do
				if name ~= "compose" then
					cases[name] = case
				end
			end
			local reasons: { [string]: string } = {}
			if mode == "as-shipped" then
				reasons.compose =
					"Lute require caches native Compose modules for the worker. A fresh native module cache is not available per sample in as-shipped mode. Use like-for-like for library-load."
			else
				cases.compose = assert(coldCompose)
			end
			workload.cases = cases
			workload.unsupported = reasons
		end
	end
end

local SETTLE_FRAMES = 300

local function prepare(id: string, context: Workloads.Context, driver: Types.Driver): State
	local environment = context.env
	local container = context.container
	local function labels(scope: Types.Scope, count: number, text: (number) -> unknown): unknown
		local children: { unknown } = {}
		for index = 1, count do
			children[index] = scope.node("TextLabel", { Text = text(index) })
		end
		return scope.node("Frame", {}, children)
	end
	local state: State = { run = function() end, release = function() end, keys = { "Text" }, settle = false }
	if id == "events" then
		local fired = 0
		state.keys = { "Text", "Size", "Position" }
		state.run = function()
			local dispose = driver.mount(container, function(scope: Types.Scope): unknown
				local children: { unknown } = {}
				for index = 1, 10 do
					children[index] = scope.node("TextButton", {
						Text = "b" .. tostring(index),
						Size = environment.globals.UDim2.fromOffset(40, 40),
						Position = environment.globals.UDim2.fromOffset((index - 1) * 44, 0),
						[scope.event "Activated"] = function()
							fired += 1
						end,
					})
				end
				return scope.node("Frame", {}, children)
			end)
			environment.drain()
			local observe = context.observe
			if observe ~= nil then
				observe(environment.snapshot(container, state.keys))
			end
			local before = fired
			for _, button in environment.children(environment.children(container)[1]) do
				environment.fire(button, "Activated")
			end
			assert(fired - before == 10, "event handlers did not all run")
			dispose()
		end
		return state
	end
	local tick = 0
	local dispose = driver.mount(container, function(scope: Types.Scope): unknown
		if id == "animate-many" then
			local target = scope.value(0)
			state.keys = { "LayoutOrder" }
			state.settle = true
			state.run = function()
				driver.batch(function()
					target.write(Shared.ANIMATE_TARGET)
				end)
				for frame = 1, Shared.ANIMATE_FRAMES do
					environment.step(1 / 60)
					if frame == Shared.ANIMATE_CHECK and context.observe ~= nil then
						Shared.checkMidway(environment, container)
					end
				end
			end
			local children: { unknown } = {}
			for index = 1, Shared.ANIMATED do
				children[index] = scope.node("Frame", { LayoutOrder = scope.spring(target, index) })
			end
			return scope.node("Frame", {}, children)
		elseif id:match "^update%-" then
			local total = if id == "update-leaf" then 500 elseif id == "update-repeated" then 1 else 300
			local sources: { Types.Source<string> } = {}
			local repeatedWrite: ((number) -> ())? = nil
			local shared = if id == "update-leaf" then scope.value "value 0" else nil
			state.run = function()
				tick += 1
				driver.batch(function()
					if id == "update-repeated" then
						local write = assert(repeatedWrite)
						local base = (tick - 1) * 500
						for step = 1, 500 do
							write(base + step)
						end
					elseif id == "update-batched" then
						local nextText = tostring(tick)
						for _, source in sources do
							source.write(nextText)
						end
					else
						assert(shared).write("value " .. tostring(tick))
					end
				end)
			end
			if id == "update-repeated" then
				local text = scope.counterState(0)
				repeatedWrite = text.write
				return scope.node("Frame", {}, { text.node })
			end
			return labels(scope, total, function(index: number): unknown
				if id == "update-batched" or id == "update-repeated" then
					local source = scope.value "0"
					sources[index] = source
					return source.binding
				elseif index == 1 then
					return assert(shared).binding
				end
				return "static " .. tostring(index)
			end)
		elseif id:match "^keyed%-" then
			local initial, alternate = Shared.keyedLists(id)
			local list = scope.value(initial)
			state.keys = { "Text", "LayoutOrder" }
			state.sortBy = "LayoutOrder"
			state.run = function()
				tick += 1
				driver.batch(function()
					list.write(if tick % 2 == 1 then alternate else initial)
				end)
			end
			return scope.node("Frame", {}, { scope.keyed(list) })
		elseif id == "branch-swap" then
			local open = scope.value(false)
			state.run = function()
				tick += 1
				driver.batch(function()
					open.write(tick % 2 == 1)
				end)
			end
			return scope.node("Frame", {}, {
				scope.node("TextLabel", { Text = "header" }),
				scope.branch(open, function(inner: Types.Scope): unknown
					return labels(inner, 50, function(index: number): unknown
						return "panel " .. tostring(index)
					end)
				end),
				scope.node("TextLabel", { Text = "footer" }),
			})
		elseif id == "status-panel" then
			local hp, mp = scope.value(100), scope.value(50)
			local lists = Shared.badgeLists()
			local badges = scope.value(lists[1])
			state.keys = { "Text", "LayoutOrder" }
			state.sortBy = "LayoutOrder"
			state.run = function()
				tick += 1
				driver.batch(function()
					hp.write(100 - tick % 100)
					mp.write((tick * 3) % 100)
					badges.write(Shared.badgesAt(lists, tick))
				end)
			end
			return scope.node("Frame", {}, {
				scope.node(
					"TextLabel",
					{ Text = hp.bind(function(value: number): unknown
						return "hp " .. tostring(value)
					end) }
				),
				scope.node(
					"TextLabel",
					{ Text = mp.bind(function(value: number): unknown
						return "mp " .. tostring(value)
					end) }
				),
				scope.keyed(badges),
			})
		elseif id == "scene-3d" then
			local tide, daylight = scope.value(0), scope.value(true)
			state.keys = { "Name", "Position", "Transparency" }
			state.run = function()
				tick += 1
				driver.batch(function()
					tide.write(tick)
					daylight.write(tick % 2 == 0)
				end)
			end
			local children: { unknown } = {}
			for index = 1, 150 do
				children[index] = scope.node("Part", {
					Name = "prop" .. tostring(index),
					Position = tide.bind(function(value: number): unknown
						return environment.globals.Vector3.new(index, value, 0)
					end),
					Transparency = daylight.bind(function(value: boolean): unknown
						return if value then 0 else 0.5
					end),
				})
			end
			return scope.node("Model", {}, children)
		end
		error("comparison workload is not implemented: " .. id, 0)
	end)
	state.release = dispose
	return state
end

local function caseFor(id: string, factory: Factory): Workloads.Case
	return {
		prepare = function(context: Workloads.Context): WorkloadTypes.State
			local driver = factory(context.env)
			local state = prepare(id, context, driver)
			return {
				run = state.run,
				snapshot = function(): string
					if state.settle then
						for _ = 1, SETTLE_FRAMES do
							context.env.step(1 / 60)
						end
					end
					return context.env.snapshot(context.container, state.keys, state.sortBy)
				end,
				release = state.release,
			}
		end,
		run = function(state: WorkloadTypes.State)
			state.run()
		end,
		snapshot = function(state: WorkloadTypes.State): string
			return state.snapshot()
		end,
		release = function(state: WorkloadTypes.State)
			state.release()
		end,
	}
end

local BINDING_WORKLOADS: { [string]: boolean } = {
	["hud-per-frame"] = true,
	["theme-propagation"] = true,
	["form-validation"] = true,
	["teardown-under-load"] = true,
	["open-close-retention"] = true,
}

local function cached(make: Factory): Factory
	local made: { [Environment.Environment]: Types.Driver } = {}
	setmetatable(made, { __mode = "k" })
	table.insert(releases, function(environment: Environment.Environment)
		made[environment] = nil
	end)
	return function(environment: Environment.Environment): Types.Driver
		local driver = made[environment]
		if driver == nil then
			driver = make(environment)
			made[environment] = driver
		end
		return driver
	end
end

local function include(name: string, factory: Factory, unsupported: ((string) -> string?)?, workaround: Workaround?)
	local react = name == "react" or name == "react-upstream" or name == "react-reflex"
	local drivers: { [Environment.Environment]: Types.Driver } = {}
	setmetatable(drivers, { __mode = "k" })
	table.insert(releases, function(environment: Environment.Environment)
		drivers[environment] = nil
	end)
	local function take(environment: Environment.Environment): Types.Driver
		return assert(drivers[environment], "framework must be loaded before preparation")
	end
	local takeWorkaround = if workaround then cached(workaround.factory) else take
	local takeGame = take
	if name == "react-reflex" then
		takeGame = cached(function(environment: Environment.Environment): Types.Driver
			return ReactReflex.create(environment, true)
		end)
	elseif react then
		takeGame = cached(function(environment: Environment.Environment): Types.Driver
			return GameReact.create(environment, nil, name)
		end)
	elseif name == "roact" then
		takeGame = cached(GameRoact.create)
	end
	for _, workload in Workloads.all do
		local id = workload.id
		local reasons = workload.unsupported or {}
		workload.unsupported = reasons
		local reason = if unsupported then unsupported(id) else nil
		local adapted = workaround ~= nil and workaround.workloads[id] == true
		local own = if adapted then takeWorkaround else take
		if reason then
			reasons[name] = reason
		elseif id == "animate-many" and react then
			reasons[name] =
				"React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures."
		else
			if adapted then
				local notes = workload.workarounds or {}
				workload.workarounds = notes
				notes[name] = assert(workaround).note
			end
			if id == "library-load" then
				workload.cases[name] = Lists.caseFor(id, factory)
				if name == "compose" then
					coldCompose = workload.cases[name]
				end
			elseif id:match "^rows%-" then
				workload.cases[name] = Lists.caseFor(id, own)
			elseif GameUI.contains(id) then
				workload.cases[name] = GameUI.caseFor(
					id,
					if BINDING_WORKLOADS[id] then take elseif adapted then takeWorkaround else takeGame,
					not react and name ~= "roact"
				)
			else
				workload.cases[name] = caseFor(id, own)
			end
		end
	end
	return function(environment: Environment.Environment): { library: unknown, extras: WorkloadTypes.Extras }
		local driver = drivers[environment]
		if driver == nil then
			driver = factory(environment)
			drivers[environment] = driver
		end
		loadedDrivers[environment] = driver
		return { library = driver, extras = {} }
	end
end

local function loadedDriver(environment: Environment.Environment): Types.Driver?
	return loadedDrivers[environment]
end

return { include = include, configure = configure, close = close, loadedDriver = loadedDriver }
