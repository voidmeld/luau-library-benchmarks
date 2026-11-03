--!strict

local Types = require "./types"

type Slot = { class: unknown, props: Types.Properties, children: { unknown }?, element: unknown }
type Derived = { sources: { number }, values: { unknown }, result: unknown }
type Row = { order: number, element: unknown }

export type Memo = {
	begin: () -> (),
	clear: () -> (),
	source: (unknown, unknown) -> (),
	node: (unknown, Types.Properties, { unknown }?) -> unknown,
	computed: <T>((Types.Use) -> T) -> T,
	row: (number, number) -> unknown,
}

local function sameProps(left: Types.Properties, right: Types.Properties): boolean
	for key, value in left do
		if right[key] ~= value then
			return false
		end
	end
	for key in right do
		if left[key] == nil then
			return false
		end
	end
	return true
end

local function sameChildren(left: { unknown }?, right: { unknown }?): boolean
	if left == nil or right == nil then
		return left == right
	end
	if #left ~= #right then
		return false
	end
	for index, child in left do
		if right[index] ~= child then
			return false
		end
	end
	return true
end

local function create(
	createElement: (unknown, Types.Properties, { unknown }?) -> unknown,
	createRow: (number, number) -> unknown
): Memo
	local slots: { Slot } = {}
	local derived: { Derived } = {}
	local rows: { [number]: Row } = {}
	local indices: { [unknown]: number } = {}
	local values: { unknown } = {}
	local nodeCursor, derivedCursor, sourceCursor = 0, 0, 0
	return {
		begin = function()
			nodeCursor, derivedCursor, sourceCursor = 0, 0, 0
			table.clear(indices)
		end,
		clear = function()
			table.clear(slots)
			table.clear(derived)
			table.clear(rows)
			table.clear(indices)
			table.clear(values)
		end,
		source = function(source: unknown, value: unknown)
			sourceCursor += 1
			indices[source] = sourceCursor
			values[sourceCursor] = value
		end,
		node = function(class: unknown, props: Types.Properties, children: { unknown }?): unknown
			nodeCursor += 1
			local slot = slots[nodeCursor]
			if
				slot
				and slot.class == class
				and sameProps(slot.props, props)
				and sameChildren(slot.children, children)
			then
				return slot.element
			end
			local element = createElement(class, props, children)
			slots[nodeCursor] = { class = class, props = props, children = children, element = element }
			return element
		end,
		computed = function<T>(body: (Types.Use) -> T): T
			derivedCursor += 1
			local previous = derived[derivedCursor]
			if previous then
				local current = true
				for index, source in previous.sources do
					if values[source] ~= previous.values[index] then
						current = false
						break
					end
				end
				if current then
					return previous.result :: T
				end
			end
			local read: { number } = {}
			local seen: { unknown } = {}
			local result = body(function<U>(source: Types.Source<U>): U
				local value = source.read()
				local index = indices[source]
				if index then
					table.insert(read, index)
					table.insert(seen, value)
				end
				return value
			end)
			derived[derivedCursor] = { sources = read, values = seen, result = result }
			return result
		end,
		row = function(id: number, order: number): unknown
			local previous = rows[id]
			if previous and previous.order == order then
				return previous.element
			end
			local element = createRow(id, order)
			rows[id] = { order = order, element = element }
			return element
		end,
	}
end

return { create = create }
