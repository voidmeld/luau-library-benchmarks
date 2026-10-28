--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local State = require "./state"
local Fusion = require "./fusion"

type Atom<T> = (() -> T) & ((T) -> T)
type Charm = {
	atom: <T>(T) -> Atom<T>,
	subscribe: <T>(Atom<T>, (T) -> ()) -> () -> (),
	batch: (() -> ()) -> (),
}

local function create(environment: Environment.Environment): Types.Driver
	local loadCharm: (string) -> Charm = environment.load
	local charm = loadCharm ".lute/dependencies/charm/packages/charm/src"
	local state: State.State = {
		value = function<T>(initial: T, emit: (T) -> ()): State.Cell<T>
			local atom = charm.atom(initial)
			local disconnect = charm.subscribe(atom, emit)
			return {
				read = function(): T
					return atom()
				end,
				write = function(next: T)
					atom(next)
				end,
				release = disconnect,
			}
		end,
		batch = charm.batch,
	}
	return Fusion.create(environment, state)
end

return { create = create }
