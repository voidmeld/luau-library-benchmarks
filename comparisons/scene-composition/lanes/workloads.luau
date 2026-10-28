--!strict

local Environment = require "../cost-model"
local Workloads = require "../workloads"
local WorkloadTypes = require "../workloads/types"
local Types = require "./types"

type State = {
	run: () -> (),
	release: () -> (),
	keys: { string },
	sortBy: string?,
	settle: boolean,
}
type Factory = (Environment.Environment) -> Types.Driver

local function rows(count: number, offset: number?): { Types.Row }
	local result: { Types.Row } = {}
	for index = 1, count do
		result[index] = { id = index + (offset or 0) }
	end
	return result
end

local function changed(id: string, initial: { Types.Row }): { Types.Row }
	local result = table.clone(initial)
	if id == "keyed-replace" then
		return rows(300, 1300)
	elseif id == "keyed-remove" then
		for _ = 1, 10 do
			table.remove(result, 150)
		end
	elseif id == "keyed-reverse" then
		for index = 1, 150 do
			result[index], result[301 - index] = result[301 - index], result[index]
		end
	elseif id == "keyed-rotate" then
		local last = table.remove(result)
		assert(last ~= nil)
		table.insert(result, 1, last)
	elseif id == "keyed-shuffle" then
		local seed = 12345
		for index = #result, 2, -1 do
			seed = (seed * 1103515245 + 12345) % 2147483648
			local pick = (seed % index) + 1
			result[index], result[pick] = result[pick], result[index]
		end
	else
		local offset = if id == "keyed-prepend" then 400 elseif id == "keyed-insert" then 500 else 300
		for index, row in rows(10, offset) do
			if id == "keyed-prepend" then
				table.insert(result, index, row)
			elseif id == "keyed-insert" then
				table.insert(result, 150 + index, row)
			else
				table.insert(result, row)
			end
		end
	end
	return result
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
	local count = tonumber(id:match "^cold%-mount%-(%d+)$")
	if count or id == "mount-dispose" or id == "mount-cycles" or id == "events" then
		local disposers: { () -> () } = {}
		local fired = 0
		state.run = function()
			for _ = 1, if id == "mount-cycles" then 30 else 1 do
				local dispose = driver.mount(container, function(scope: Types.Scope): unknown
					if id == "events" or id == "mount-cycles" then
						local children: { unknown } = {}
						for index = 1, if id == "mount-cycles" then 60 else 200 do
							children[index] = scope.node("TextButton", {
								Text = (if id == "mount-cycles" then "n" else "b") .. tostring(index),
								[scope.event "Activated"] = function()
									fired += 1
								end,
							})
						end
						return scope.node("Frame", {}, children)
					end
					return labels(scope, count or 200, function(index: number): unknown
						return "row " .. tostring(index)
					end)
				end)
				environment.drain()
				local observe = context.observe
				if observe ~= nil and not count then
					observe(environment.snapshot(container, state.keys))
				end
				if id == "events" then
					local before = fired
					for _, button in environment.children(environment.children(container)[1]) do
						environment.fire(button, "Activated")
					end
					assert(fired - before == 200, "event handlers did not all run")
				end
				if count then
					table.insert(disposers, dispose)
				else
					dispose()
				end
			end
		end
		state.release = function()
			for index = #disposers, 1, -1 do
				disposers[index]()
			end
			table.clear(disposers)
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
					target.write(100)
				end)
				for _ = 1, 30 do
					environment.step(1 / 60)
				end
			end
			local children: { unknown } = {}
			for index = 1, 200 do
				children[index] = scope.node("Frame", { LayoutOrder = scope.spring(target, index) })
			end
			return scope.node("Frame", {}, children)
		elseif id:match "^update%-" then
			local total = if id == "update-leaf" then 500 elseif id == "update-repeated" then 1 else 300
			local sources: { Types.Source<string> } = {}
			local repeatedWrite: ((number) -> ())? = nil
			local shared = if id == "update-fanout" or id == "update-leaf"
				then scope.value(if id == "update-fanout" then "tint 0" else "value 0")
				else nil
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
						assert(shared).write((if id == "update-fanout" then "tint " else "value ") .. tostring(tick))
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
				elseif id == "update-fanout" or index == 1 then
					return assert(shared).binding
				end
				return "static " .. tostring(index)
			end)
		elseif id:match "^keyed%-" then
			local initial = rows(300)
			local alternate = changed(id, initial)
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
			local badges = scope.value(rows(0))
			local pool = rows(40)
			state.keys = { "Text", "LayoutOrder" }
			state.sortBy = "LayoutOrder"
			state.run = function()
				tick += 1
				local nextRows: { Types.Row } = {}
				table.move(pool, 1, (tick % 40) + 1, 1, nextRows)
				driver.batch(function()
					hp.write(100 - tick % 100)
					mp.write((tick * 3) % 100)
					badges.write(nextRows)
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

local function include(name: string, factory: Factory, unsupported: ((string) -> string?)?)
	local drivers: { [Environment.Environment]: Types.Driver } = {}
	setmetatable(drivers, { __mode = "k" })
	local function take(environment: Environment.Environment): Types.Driver
		return assert(drivers[environment], "framework must be loaded before preparation")
	end
	for _, workload in Workloads.all do
		local reasons = workload.unsupported or {}
		workload.unsupported = reasons
		local reason = if unsupported then unsupported(workload.id) else nil
		local react = name == "react" or name == "react-upstream" or name == "react-reflex"
		local fusion = name == "fusion" or name == "fusion-charm"
		if reason then
			reasons[name] = reason
		elseif workload.id == "animate-many" and react then
			reasons[name] =
				"React and ReactRoblox do not include a spring. Adding an animation library would change what this lane measures."
		elseif
			fusion
			and (
				workload.id == "keyed-append"
				or workload.id == "keyed-prepend"
				or workload.id == "keyed-insert"
				or workload.id == "keyed-remove"
			)
		then
			reasons[name] =
				"At the pinned release, ForPairs can give a removed key's scope to a retained key, so a retained row does not keep its Instance. These workloads check retained Instance identity."
		else
			workload.cases[name] = caseFor(workload.id, take)
		end
	end
	return function(environment: Environment.Environment): { library: unknown, extras: WorkloadTypes.Extras }
		local driver = drivers[environment]
		if driver == nil then
			driver = factory(environment)
			drivers[environment] = driver
		end
		return { library = driver, extras = {} }
	end
end

return { include = include }
