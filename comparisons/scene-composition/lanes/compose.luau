--!strict

local ComposeEngine = require "../harness/compose-engine"
local Environment = require "../cost-model"
local Core = require "../../../.lute/dependencies/compose/src/core"
local Roblox = require "../../../.lute/dependencies/compose/src/roblox"
local Types = require "./types"
local Derived = require "./derived"

type Compose = typeof(Core)
export type Session = { library: Compose, runtime: Core.Runtime }

local sessions: { [Environment.Environment]: Session } = {}
setmetatable(sessions, { __mode = "k" })

local function session(environment: Environment.Environment): Session
	local existing = sessions[environment]
	if existing ~= nil then
		return existing
	end
	local loadLibrary: (string) -> Compose = environment.load
	local library = loadLibrary ".lute/dependencies/compose/src/core"
	local loadAdapter: (string) -> typeof(Roblox) = environment.load
	local adapter = loadAdapter ".lute/dependencies/compose/src/roblox"
	local opened: Session = {
		library = library,
		runtime = adapter.createRuntime(ComposeEngine.engineFor(environment)),
	}
	sessions[environment] = opened
	return opened
end

local function create(environment: Environment.Environment): Types.Driver
	local opened = session(environment)
	local compose = opened.library
	local runtime = opened.runtime
	local Host = runtime.constructors
	local scope: Types.Scope
	local function value<T>(initial: T): Types.Source<T>
		local cell = compose.cell(initial)
		return {
			binding = cell,
			read = function(): T
				return cell:peek()
			end,
			write = function(next: T)
				cell:set(next)
			end,
			bind = function(map: (T) -> unknown): unknown
				return compose.map(cell, map)
			end,
		}
	end
	local function node(class: string, properties: Types.Properties, children: { unknown }?): unknown
		local props = table.clone(properties)
		if children then
			for index, child in children do
				props[index] = child
			end
		end
		return Host[class](props :: Core.Props)
	end
	scope = {
		value = value,
		node = node,
		event = function(name: string): unknown
			return compose.event(name)
		end,
		counterState = function(initial: number): Types.CounterState
			local source = value(initial)
			return {
				node = node("TextLabel", {
					Text = source.bind(function(current: number): unknown
						return tostring(current)
					end),
				}),
				write = source.write,
			}
		end,
		keyed = function(list: Types.Source<{ Types.Row }>): unknown
			return compose.keyed {
				from = list.binding :: Core.Value<{ Types.Row }>,
				render = function(row: Core.ReadOnlyValue<Types.Row>, index: Core.ReadOnlyValue<number>)
					return Host.TextLabel {
						Text = tostring(row:peek().id),
						LayoutOrder = index,
					}
				end,
			}
		end,
		branch = function(open: Types.Source<boolean>, build: (Types.Scope) -> unknown): unknown
			local visible = open.binding :: Core.Value<boolean>
			return compose.show(function(use: Core.Use): boolean
				return use(visible)
			end, function()
				return build(scope) :: Core.Node
			end)
		end,
		spring = function(target: Types.Source<number>, offset: number): unknown
			local goal = target.binding :: Core.Value<number>
			local moved = runtime.spring(function(use: Core.Use): number
				return use(goal) + offset
			end, { period = 0.3, damping = 1 })
			return function(use: Core.Use): number
				return math.round(use(moved))
			end
		end,
	} :: Types.Scope
	Derived.extend(scope, function(body)
		return compose.formula(function(use: Core.Use)
			return body(function(binding)
				return use(binding :: Core.ReadOnlyValue<unknown>)
			end)
		end)
	end, function(binding)
		return (binding :: Core.ReadOnlyValue<unknown>):peek()
	end)
	local theme = compose.createContext(nil :: Types.Source<string>?)
	scope.provideTheme = function(value: Types.Source<string>, build: () -> unknown): unknown
		return theme.provide(value, build)
	end
	scope.themeText = function(): unknown
		return assert(theme.read()).binding
	end
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local dispose = runtime.mount(function()
				return build(scope) :: Core.Node
			end, container)
			return dispose
		end,
		batch = function(run: () -> ())
			runtime:batch(run)
			environment.drain()
		end,
	}
end

return { create = create, session = session }
