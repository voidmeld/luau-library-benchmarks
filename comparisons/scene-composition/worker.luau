--!strict

local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Lute = require "../../.lute/dependencies/verify/src/lute"
local Verify = require "../../.lute/dependencies/verify/src/core"
local Frameworks = require "./harness/frameworks"
local Upstream = require "./harness/upstream"
local Lifecycle = require "./lifecycle"
local Report = require "./report"
local Suites = require "./suites"
local Workloads = require "./workloads"

Lute.worker {
	load = function(request: string): unknown
		local requestedMode, rest = request:match "^(like%-for%-like)/(.+)$"
		Upstream.setMode(if requestedMode ~= nil then "like-for-like" else "as-shipped")
		local locator = rest or request
		local parsedLane, parsedId, parsedName = locator:match "^(%w+):([^:]+):?(.*)$"
		local lane = assert(parsedLane, "invalid framework comparison locator")
		local id = assert(parsedId, "invalid framework comparison locator")
		local name = assert(parsedName, "invalid framework comparison locator")
		local frameworks = Frameworks.available()
		local workload: Workloads.Workload? = nil
		for _, candidate in Workloads.all do
			if candidate.id == id then
				workload = candidate
				break
			end
		end
		local subject = assert(workload, "unknown comparison workload " .. id)
		return function(harness: Verify.Harness)
			harness:suite(id, function()
				if lane == "parity" then
					harness:case("trees, intermediate states, identity and disposal agree", function(context)
						local problem = Lifecycle.parity(subject, frameworks)
						local fallbacks = Upstream.fallbacks()
						if #fallbacks > 0 then
							context:attach("loader-fallbacks.txt", "text/plain", table.concat(fallbacks, "\n"))
						end
						assert(problem == nil, problem)
					end)
				elseif lane == "timing" then
					local offset = tonumber(name) or 0
					for _, entry in Suites.entries { filter = id, offset = offset } do
						if entry.id ~= id then
							continue
						end
						local collection = entry.collection
						collection.calibrationAttempts = 3
						local definition = Benchmark.collection(collection)
						local run = assert(definition.run)
						definition.run = function(context)
							Suites.prime(collection)
							run(context)
						end
						harness:case("timing", definition)
					end
				elseif lane == "memory" then
					for _, framework in frameworks do
						if framework.name ~= name then
							continue
						end
						harness:case("retained Luau heap", function(context)
							Lifecycle.memory(subject, framework)
							local mounted: { number }, teardown: { number } = {}, {}
							for index = 1, 3 do
								local result = Lifecycle.memory(subject, framework)
								context:attach(
									"sample-" .. tostring(index) .. ".json",
									"application/json",
									Lute.encode(result)
								)
								table.insert(mounted, result.mountedRetainedKb)
								table.insert(teardown, result.teardownRetainedKb)
							end
							local counters = Lifecycle.work(subject, framework)
							for _, metric in Report.WORK do
								local count = metric.read(counters)
								context:measure(name, id .. "/" .. name .. "/work/" .. metric.name, {
									samples = { count, count, count },
									unit = "count",
									context = { environment = "cost-model", signal = metric.name, timing = "observed" },
								}, { unit = "count", minimumSamples = 3, measureOnly = true })
							end
							for _, metric in
								{ { name = "mounted", samples = mounted }, { name = "teardown", samples = teardown } }
							do
								context:measure(name, id .. "/" .. name .. "/memory/" .. metric.name, {
									samples = metric.samples,
									unit = "KiB",
									context = {
										environment = Lute.memory.METHOD,
										signal = metric.name,
										timing = "observed",
									},
								}, { unit = "KiB", minimumSamples = 3, measureOnly = true })
							end
						end)
					end
				else
					error("unknown comparison lane " .. lane, 0)
				end
			end)
		end
	end,
}
