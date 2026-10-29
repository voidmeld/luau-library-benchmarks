--!strict

local Types = require "./types"

local function state(scope: Types.Scope, initial: string): Types.RowState
	local selected = scope.value(false)
	return {
		label = scope.value(initial),
		selected = selected,
		highlight = selected.bind(function(current: boolean): unknown
			return if current then 0 else 1
		end),
	}
end

local function node(scope: Types.Scope, row: Types.ModelRow, position: unknown): unknown
	return scope.node("Frame", {
		LayoutOrder = position,
		BackgroundTransparency = row.highlight,
	}, {
		scope.node("TextLabel", { Text = tostring(row.id), LayoutOrder = 1 }),
		scope.node("TextLabel", { Text = row.label.binding, LayoutOrder = 2 }),
		scope.node("TextButton", { Text = "select", LayoutOrder = 3, [scope.event "Activated"] = row.select }),
		scope.node("TextButton", { Text = "remove", LayoutOrder = 4, [scope.event "Activated"] = row.remove }),
	})
end

return { node = node, state = state }
