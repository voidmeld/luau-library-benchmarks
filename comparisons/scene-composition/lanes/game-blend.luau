--!strict

local Environment = require "../cost-model"
local Types = require "./types"
local Derived = require "./derived"

type Blend = {
	Computed: (...unknown) -> unknown,
	Throttled: (unknown) -> unknown,
	Shared: (unknown) -> unknown,
}

local function pack(...: unknown): { unknown }
	return { ... }
end

local function create(environment: Environment.Environment)
	local loadBlend: (string) -> Blend = environment.load
	local blend = loadBlend ".lute/dependencies/blend/src/blend/src/Shared/Blend/Blend.lua"
	local function map(binding: unknown, transform: (unknown) -> unknown): unknown
		return blend.Computed(binding, transform)
	end
	return function(scope: Types.Scope)
		local readers: { [unknown]: () -> unknown } = {}
		local function peek(binding: unknown): unknown
			local reader = readers[binding]
			if reader then
				return reader()
			end
			return (binding :: { Value: unknown }).Value
		end
		Derived.extend(scope, function(body)
			local dependencies: { unknown } = {}
			local indices: { [unknown]: number } = {}
			body(function(binding)
				if indices[binding] == nil then
					table.insert(dependencies, binding)
					indices[binding] = #dependencies
				end
				return peek(binding)
			end)
			local binding: unknown
			if #dependencies == 1 then
				binding = blend.Shared(blend.Computed(dependencies[1], function(value: unknown): unknown
					return body(function(): unknown
						return value
					end)
				end))
			else
				table.insert(dependencies, pack)
				local combined = blend.Computed(table.unpack(dependencies))
				binding = blend.Shared(blend.Computed(blend.Throttled(combined), function(latest: { unknown }): unknown
					return body(function(dependency)
						return latest[assert(indices[dependency])]
					end)
				end))
			end
			readers[binding] = function(): unknown
				return body(peek)
			end
			return binding
		end, peek, map)
	end
end

return { create = create }
