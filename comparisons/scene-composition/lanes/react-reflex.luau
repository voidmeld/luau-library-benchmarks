--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"
local React = require "./react"

type Cells = { [number]: unknown }
type Producer = {
	getState: (Producer) -> Cells,
	subscribe: (Producer, (Cells) -> unknown, (unknown) -> ()) -> () -> (),
	flush: (Producer) -> (),
	set: (number, unknown) -> (),
	remove: (number) -> (),
}
type Reflex = {
	createProducer: (
		Cells,
		{
			set: (Cells, number, unknown) -> Cells,
			remove: (Cells, number) -> Cells,
		}
	) -> Producer,
}

local function create(environment: Environment.Environment, game: boolean?): Types.Driver
	local loadReflex: (string) -> Reflex = environment.load
	local reflex = loadReflex ".lute/dependencies/reflex/src"
	local producer = reflex.createProducer({}, {
		set = function(cells: Cells, key: number, value: unknown): Cells
			local nextCells = table.clone(cells)
			nextCells[key] = value
			return nextCells
		end,
		remove = function(cells: Cells, key: number): Cells
			local nextCells = table.clone(cells)
			nextCells[key] = nil
			return nextCells
		end,
	})
	local nextKey = 0
	local state: State.State = {
		value = function<T>(initial: T, emit: (T) -> ()): State.Cell<T>
			nextKey += 1
			local key = nextKey
			producer.set(key, initial)
			producer:flush()
			local function select(cells: Cells): unknown
				return cells[key]
			end
			local disconnect = producer:subscribe(select, function(next: unknown)
				emit(next :: T)
			end)
			return {
				read = function(): T
					return producer:getState()[key] :: T
				end,
				write = function(next: T)
					producer.set(key, next)
				end,
				release = function()
					disconnect()
					producer.remove(key)
					producer:flush()
				end,
			}
		end,
		batch = function(run: () -> ())
			run()
			producer:flush()
		end,
	}
	return React.create(environment, state, nil, game)
end

type RowProducer = {
	getState: (RowProducer) -> Cells,
	subscribe: (RowProducer, (Cells) -> unknown, (unknown) -> ()) -> () -> (),
	flush: (RowProducer) -> (),
	patch: (Cells) -> (),
	resetState: (RowProducer) -> (),
}

local function createRows(environment: Environment.Environment): Types.Driver
	local loadReflex: (string) -> { createProducer: (Cells, { patch: (Cells, Cells) -> Cells }) -> RowProducer } =
		environment.load
	local reflex = loadReflex ".lute/dependencies/reflex/src"
	local producer = reflex.createProducer({}, {
		patch = function(cells: Cells, updates: Cells): Cells
			local result = table.clone(cells)
			for key, value in updates do
				result[key] = value
			end
			return result
		end,
	})
	local pending: Cells = {}
	local nextKey = 0
	local function flush()
		if next(pending) ~= nil then
			producer.patch(pending)
			pending = {}
		end
		producer:flush()
	end
	local state: State.State = {
		value = function<T>(initial: T, emit: (T) -> ()): State.Cell<T>
			nextKey += 1
			local key = nextKey
			pending[key] = initial
			local function select(cells: Cells): unknown
				return if cells[key] == nil then initial else cells[key]
			end
			local disconnect = producer:subscribe(select, function(current: unknown)
				emit(current :: T)
			end)
			return {
				read = function(): T
					return (if pending[key] ~= nil then pending[key] else select(producer:getState())) :: T
				end,
				write = function(current: T)
					pending[key] = current
				end,
				release = disconnect,
			}
		end,
		batch = function(run: () -> ())
			run()
			flush()
		end,
	}
	local driver = React.create(environment, state)
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local dispose = driver.mount(container, build)
			flush()
			environment.drain()
			return function()
				dispose()
				pending = {}
				nextKey = 0
				producer:resetState()
				producer:flush()
			end
		end,
		batch = driver.batch,
	}
end

return { create = create, createRows = createRows }
