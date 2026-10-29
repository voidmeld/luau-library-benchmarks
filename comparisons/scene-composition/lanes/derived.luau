--!strict

local Types = require "./types"

type NativeUse = (unknown) -> unknown
type Create = ((NativeUse) -> unknown) -> unknown

local function extend(scope: Types.Scope, create: Create, peek: (unknown) -> unknown)
	local function computed<T>(body: (Types.Use) -> T): Types.Source<T>
		local binding = create(function(read: NativeUse): unknown
			return body(function<U>(source: Types.Source<U>): U
				return read(source.binding) :: U
			end)
		end)
		return {
			binding = binding,
			read = function(): T
				return peek(binding) :: T
			end,
			write = function()
				error("A derived value is read-only", 0)
			end,
			bind = function(map: (T) -> unknown): unknown
				return create(function(read: NativeUse): unknown
					return map(read(binding) :: T)
				end)
			end,
		}
	end
	scope.computed = (computed :: unknown) :: Types.Compute?
end

return { extend = extend }
