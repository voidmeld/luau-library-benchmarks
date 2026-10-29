--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Derived = require "./derived"

type Observable = { Subscribe: (Observable, (unknown) -> ()) -> unknown }
type Blend = {
	Computed: (...unknown) -> unknown,
	Throttled: (unknown) -> unknown,
	Shared: (unknown) -> unknown,
	toPropertyObservable: (unknown) -> Observable,
}
local function create(environment: Environment.Environment)
	local loadBlend: (string) -> Blend = environment.load
	local blend = loadBlend ".lute/dependencies/blend/src/blend/src/Shared/Blend/Blend.lua"
	return function(scope: Types.Scope, own: (unknown) -> ())
		local values: { [unknown]: unknown } = {}
		local function peek(binding: unknown): unknown
			if values[binding] ~= nil then
				return values[binding]
			end
			return (binding :: { Value: unknown }).Value
		end
		Derived.extend(scope, function(body)
			local dependencies: { unknown } = {}
			local indices: { [unknown]: number } = {}
			local initial = body(function(binding)
				if indices[binding] == nil then
					table.insert(dependencies, binding)
					indices[binding] = #dependencies
				end
				return peek(binding)
			end)
			table.insert(dependencies, function(...: unknown): unknown
				return { ... }
			end)
			local combined = blend.Computed(table.unpack(dependencies))
			local binding =
				blend.Shared(blend.Computed(blend.Throttled(combined), function(latest: { unknown }): unknown
					return body(function(dependency)
						return latest[assert(indices[dependency])]
					end)
				end))
			values[binding] = initial
			own(blend.toPropertyObservable(binding):Subscribe(function(value)
				values[binding] = value
			end))
			return binding
		end, peek)
	end
end

return { create = create }
