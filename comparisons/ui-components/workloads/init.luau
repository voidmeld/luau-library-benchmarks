--!strict

local Types = require "./types"

export type Workload = Types.Workload

local all: { Types.Workload } = {}
for _, group in
	{
		require "@self/readouts",
		require "@self/collections",
		require "@self/inputs",
		require "@self/surfaces",
		require "@self/screens",
		require "@self/preferences",
		require "@self/adaptation",
		require "@self/traversal",
		require "@self/modals",
		require "@self/native-motion",
	}
do
	for _, workload in group do
		table.insert(all, workload)
	end
end

return { all = all }
