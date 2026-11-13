--!strict

local Types = require "./types"

type NativeUse = (unknown) -> unknown
type Create = ((NativeUse) -> unknown) -> unknown
export type Map = (unknown, (unknown) -> unknown) -> unknown

local function extend(scope: Types.Scope, create: Create, peek: (unknown) -> unknown, map: Map?)
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
			bind = function(transform: (T) -> unknown): unknown
				if map then
					return map(binding, transform :: (unknown) -> unknown)
				end
				return create(function(read: NativeUse): unknown
					return transform(read(binding) :: T)
				end)
			end,
		}
	end
	scope.computed = computed
end

return { extend = extend }
