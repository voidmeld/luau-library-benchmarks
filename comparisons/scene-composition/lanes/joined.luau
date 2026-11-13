--!strict
--!native

local Types = require "./types"
local Derived = require "./derived"

type Binding = { getValue: (Binding) -> unknown, map: (Binding, (unknown) -> unknown) -> Binding }

local function extend(scope: Types.Scope, join: (unknown) -> unknown)
	Derived.extend(scope, function(compute: ((unknown) -> unknown) -> unknown): unknown
		local inputs: { Binding } = {}
		compute(function(binding: unknown): unknown
			local input = binding :: Binding
			table.insert(inputs, input)
			return input:getValue()
		end)
		return (join(inputs) :: Binding):map(function(values: unknown): unknown
			local list = values :: { unknown }
			local cursor = 0
			return compute(function(): unknown
				cursor += 1
				return list[cursor]
			end)
		end)
	end, function(binding: unknown): unknown
		return (binding :: Binding):getValue()
	end, function(binding: unknown, transform: (unknown) -> unknown): unknown
		return (binding :: Binding):map(transform)
	end)
end

return { extend = extend }
