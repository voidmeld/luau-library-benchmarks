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

local function create(environment: Environment.Environment): Types.Driver
	local reflex: Reflex = environment.load ".lute/dependencies/reflex/src"
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
	return React.create(environment, state)
end

return { create = create }
