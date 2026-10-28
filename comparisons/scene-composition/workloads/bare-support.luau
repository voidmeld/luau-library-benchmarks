--!strict

local Environment = require "../cost-model"

type Context = { env: Environment.Environment, container: Environment.Instance }

local function instances(context: Context): Environment.InstanceFactory
	return context.env.globals.Instance
end

local function destroyAll(nodes: { Environment.Instance })
	for index = #nodes, 1, -1 do
		local node = nodes[index]
		if node ~= nil then
			node:Destroy()
			nodes[index] = nil
		end
	end
end

local function buildList(
	context: Context,
	count: number,
	text: (index: number) -> string
): (Environment.Instance, { Environment.Instance })
	local Instance = instances(context)
	local createMade: (number, Environment.Instance?) -> { Environment.Instance } = table.create
	local made: { Environment.Instance } = createMade(count + 1)
	local frame = Instance.new "Frame"
	made[1] = frame
	for index = 1, count do
		local label = Instance.new "TextLabel"
		label.Text = text(index)
		label.Parent = frame
		made[index + 1] = label
	end
	frame.Parent = context.container
	return frame, made
end

return {
	instances = instances,
	destroyAll = destroyAll,
	buildList = buildList,
}
