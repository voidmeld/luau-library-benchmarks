--!strict

local fs = require "@std/fs"
local process = require "@std/process"
local task = require "@std/task"
local Lute = require "../.lute/dependencies/verify/src/lute"
local Verify = require "../.lute/dependencies/verify/src/core"

export type Group = { workload: string, ids: { string } }
export type Options = {
	script: string,
	out: string,
	count: number,
	groups: { Group },
	weights: string?,
	record: string?,
	staggerSeconds: number?,
	sequential: boolean?,
	id: string,
}

local function readWeights(path: string?): { [string]: number }
	if path == nil or not fs.exists(path) then
		return {}
	end
	local decoded = Lute.parse(fs.readFileToString(path))
	local weights: { [string]: number } = {}
	if type(decoded) == "table" then
		for key, value in decoded :: { [unknown]: unknown } do
			if type(key) == "string" and type(value) == "number" then
				weights[key] = value
			end
		end
	end
	return weights
end

local function plan(groups: { Group }, weights: { [string]: number }, count: number): { { string } }
	local known, total = 0, 0
	for _, group in groups do
		for _, id in group.ids do
			if weights[id] then
				known += 1
				total += weights[id]
			end
		end
	end
	local fallback = if known > 0 then total / known else 1
	type Weighted = { group: Group, weight: number }
	local weighted: { Weighted } = {}
	for _, group in groups do
		local weight = 0
		for _, id in group.ids do
			weight += weights[id] or fallback
		end
		table.insert(weighted, { group = group, weight = weight })
	end
	table.sort(weighted, function(a: Weighted, b: Weighted): boolean
		if a.weight ~= b.weight then
			return a.weight > b.weight
		end
		return a.group.workload < b.group.workload
	end)
	local shards: { { string } } = {}
	local loads: { number } = {}
	for index = 1, count do
		shards[index] = {}
		loads[index] = 0
	end
	for _, entry in weighted do
		local lightest = 1
		for index = 2, count do
			if loads[index] < loads[lightest] then
				lightest = index
			end
		end
		loads[lightest] += entry.weight
		for _, id in entry.group.ids do
			table.insert(shards[lightest], id)
		end
	end
	local result: { { string } } = {}
	for _, ids in shards do
		if #ids > 0 then
			table.insert(result, ids)
		end
	end
	return result
end

local function run(options: Options): Verify.Report
	local shards = plan(options.groups, readWeights(options.weights), options.count)
	local stagger = options.staggerSeconds or 20
	local remaining = #shards
	local outputs: { string } = {}
	for index, ids in shards do
		local directory = ("%s/shard-%d"):format(options.out, index)
		outputs[index] = directory
		local argv = { "lute", "run", options.script, "--out", directory }
		for _, id in ids do
			table.insert(argv, "--case")
			table.insert(argv, id)
		end
		local function launch()
			local started = os.time()
			local ran = process.run(argv)
			print(("studio: shard %d finished (exit %d) in %d s"):format(index, ran.exitcode, os.time() - started))
			if not ran.ok then
				print(ran.stdout .. ran.stderr)
			end
			remaining -= 1
		end
		if options.sequential and fs.exists(directory .. "/report.json") then
			print(("studio: shard %d of %d already has a report"):format(index, #shards))
			remaining -= 1
		elseif options.sequential then
			print(("studio: shard %d of %d runs %d case(s)"):format(index, #shards, #ids))
			launch()
		else
			print(("studio: shard %d of %d runs %d case(s)"):format(index, #shards, #ids))
			task.spawn(launch)
			if index < #shards then
				task.wait(stagger)
			end
		end
	end
	while remaining > 0 do
		task.wait(1)
	end
	local reports: { Verify.Report } = {}
	for index, directory in outputs do
		local path = directory .. "/report.json"
		assert(fs.exists(path), ("shard %d wrote no report"):format(index))
		table.insert(reports, Verify.decode(Lute.parse(fs.readFileToString(path))))
	end
	local report = Verify.merge(reports, options.id, { shards = tostring(#reports) })
	if options.record then
		local recorded = readWeights(options.record)
		for _, result in report.results do
			if result.status == "passed" then
				recorded[result.id] = result.durationMicros
			end
		end
		fs.writeStringToFile(options.record, Lute.encode(recorded) .. "\n")
	end
	return report
end

return { plan = plan, run = run }
