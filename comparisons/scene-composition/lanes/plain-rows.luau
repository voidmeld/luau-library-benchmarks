--!strict
--!native

local Environment = require "../cost-model"
local Types = require "./types"

type Instance = Environment.Instance
type Row = {
	text: string,
	selected: boolean,
	position: number,
	frame: Instance?,
	label: Instance?,
	select: Environment.Connection?,
	remove: Environment.Connection?,
}
type Cell<T> = { current: T, apply: ((T) -> ())? }

local function unused(): never
	error("plain row driver only supports row workloads", 0)
end

local function unmount(row: Row)
	assert(row.select):Disconnect()
	assert(row.remove):Disconnect()
	assert(row.frame):Destroy()
	row.frame, row.label, row.select, row.remove = nil, nil, nil, nil
end

local function create(environment: Environment.Environment): Types.Driver
	local Instance = environment.globals.Instance
	local signal = environment.signal
	local attach: { [unknown]: (Instance) -> () } = {}
	local cleanups: { () -> () } = {}

	local function mountRow(model: Types.ModelRow, row: Row, index: number, parent: Instance)
		local frame = Instance.new "Frame"
		frame.LayoutOrder = index
		frame.BackgroundTransparency = if row.selected then 0 else 1
		local id = Instance.new "TextLabel"
		id.Text = tostring(model.id)
		id.LayoutOrder = 1
		id.Parent = frame
		local label = Instance.new "TextLabel"
		label.Text = row.text
		label.LayoutOrder = 2
		label.Parent = frame
		local select = Instance.new "TextButton"
		select.Text = "select"
		select.LayoutOrder = 3
		select.Parent = frame
		local remove = Instance.new "TextButton"
		remove.Text = "remove"
		remove.LayoutOrder = 4
		remove.Parent = frame
		row.select = signal(select, "Activated"):Connect(model.select :: (...unknown) -> ())
		row.remove = signal(remove, "Activated"):Connect(model.remove :: (...unknown) -> ())
		row.position = index
		row.frame = frame
		row.label = label
		frame.Parent = parent
	end

	local scope: Types.Scope = {
		rowState = function(initial: string): Types.RowState
			local row: Row = {
				text = initial,
				selected = false,
				position = 0,
				frame = nil,
				label = nil,
				select = nil,
				remove = nil,
			}
			return {
				label = {
					binding = row,
					read = unused,
					write = function(text: string)
						if row.text == text then
							return
						end
						row.text = text
						local label = row.label
						if label then
							label.Text = text
						end
					end,
					bind = unused,
				},
				selected = {
					binding = row,
					read = unused,
					write = function(selected: boolean)
						if row.selected == selected then
							return
						end
						row.selected = selected
						local frame = row.frame
						if frame then
							frame.BackgroundTransparency = if selected then 0 else 1
						end
					end,
					bind = unused,
				},
				highlight = nil,
			}
		end,
		value = function<T>(initial: T): Types.Source<T>
			local cell: Cell<T> = { current = initial }
			return {
				binding = cell,
				read = function(): T
					return cell.current
				end,
				write = function(next: T)
					if cell.current == next then
						return
					end
					cell.current = next
					local apply = cell.apply
					if apply then
						apply(next)
					end
				end,
				bind = unused,
			}
		end,
		node = function(class: string, properties: Types.Properties, children: { unknown }?): unknown
			local instance = Instance.new(class)
			for key, property in properties do
				assert(type(key) == "string", "plain row driver sets only named properties")
				instance[key] = property
			end
			if children then
				for _, child in children do
					local rows = attach[child]
					if rows then
						attach[child] = nil
						rows(instance)
					else
						environment.instance(child).Parent = instance
					end
				end
			end
			return instance
		end,
		rows = function(list: Types.Source<{ Types.ModelRow }>): unknown
			local cell = list.binding :: Cell<{ Types.ModelRow }>
			local marker = {}
			attach[marker] = function(parent: Instance)
				local byId: { [number]: Row } = {}
				local order: { number } = {}
				local count = 0
				local function apply(models: { Types.ModelRow })
					for index, model in models do
						local id = model.id
						if order[index] == id then
							continue
						end
						order[index] = id
						local row = byId[id]
						if row == nil then
							local made = model.label.binding :: Row
							byId[id] = made
							mountRow(model, made, index, parent)
							count += 1
						elseif row.position ~= index then
							row.position = index
							assert(row.frame).LayoutOrder = index
						end
					end
					for index = #order, #models + 1, -1 do
						order[index] = nil
					end
					if count ~= #models then
						local wanted: { [number]: boolean } = {}
						for _, model in models do
							wanted[model.id] = true
						end
						for id, row in byId do
							if not wanted[id] then
								unmount(row)
								byId[id] = nil
								count -= 1
							end
						end
					end
				end
				cell.apply = apply
				apply(cell.current)
				table.insert(cleanups, function()
					cell.apply = nil
					for _, row in byId do
						unmount(row)
					end
					table.clear(byId)
					table.clear(order)
					count = 0
				end)
			end
			return marker
		end,
		keyed = unused,
		branch = unused,
		event = unused,
		counterState = unused,
		spring = unused,
	}
	return {
		mount = function(container: Environment.Instance, build: (Types.Scope) -> unknown): () -> ()
			local owned: { () -> () } = {}
			cleanups = owned
			local root = environment.instance(build(scope))
			root.Parent = container
			return function()
				for index = #owned, 1, -1 do
					owned[index]()
				end
				table.clear(owned)
				root:Destroy()
			end
		end,
		batch = function(run: () -> ())
			run()
			environment.drain()
		end,
	}
end

return { create = create }
