--!strict

local Test = require "../harness"
local Benchmark = require "../../.lute/dependencies/verify/src/benchmark"
local Verify = require "../../.lute/dependencies/verify/src/core"
local Frameworks = require "../../comparisons/scene-composition/harness/frameworks"
local Report = require "../../comparisons/scene-composition/report"
local Workloads = require "../../comparisons/scene-composition/workloads"
local WorkloadTypes = require "../../comparisons/scene-composition/workloads/types"
local Environment = require "../../comparisons/scene-composition/cost-model"
local Lock = require "../../dependencies.lock"
local Upstream = require "../../comparisons/scene-composition/harness/upstream"
local luau = require "@lute/luau"
local Suites = require "../../comparisons/scene-composition/suites"
local ComposeCore = require "../../.lute/dependencies/compose/src/core"

local describe, it, expect = Test.describe, Test.it, Test.expect

local function framework(name: string): Frameworks.Framework
	return {
		name = name,
		version = "fixture",
		what = "report fixture",
		load = function(): Frameworks.Loaded
			return { library = nil, extras = {} }
		end,
	}
end

local function subject(id: string?): Workloads.Workload
	local case: Workloads.Case = {
		prepare = function(): WorkloadTypes.State
			return {
				run = function() end,
				snapshot = function(): string
					return ""
				end,
				release = function() end,
			}
		end,
		run = function() end,
		snapshot = function(): string
			return ""
		end,
		release = function() end,
	}
	return {
		id = id or "fixture",
		title = "fixture",
		what = "report fixture",
		samples = 2,
		iterations = 10,
		warmup = 0,
		cases = { compose = case, other = case },
		unsupported = { absent = "No primitive | no substitute" },
	}
end

local function stored(...: string): Benchmark.Stored
	local ids: { string } = if select("#", ...) > 0 then { ... } else { "fixture" }
	local measurements: { Benchmark.StoredMeasurement } = {}
	for _, metric in
		{
			{ name = "compose", unit = "microseconds", value = 10 },
			{ name = "other", unit = "microseconds", value = 20 },
			{ name = "compose/memory/mounted", unit = "KiB", value = 100 },
			{ name = "other/memory/mounted", unit = "KiB", value = 50 },
			{ name = "compose/memory/teardown", unit = "KiB", value = 0 },
			{ name = "other/memory/teardown", unit = "KiB", value = 1 },
			{ name = "compose/work/writes", unit = "count", value = 30 },
			{ name = "other/work/writes", unit = "count", value = 40 },
			{ name = "compose/work/created", unit = "count", value = 0 },
			{ name = "other/work/created", unit = "count", value = 2 },
			{ name = "compose/work/connections", unit = "count", value = 0 },
			{ name = "other/work/connections", unit = "count", value = 3 },
			{ name = "compose/work/deferred", unit = "count", value = 0 },
			{ name = "other/work/deferred", unit = "count", value = 4 },
		}
	do
		for _, id in ids do
			table.insert(measurements, {
				name = id .. "/" .. metric.name,
				unit = metric.unit,
				environment = "fixture",
				samples = { metric.value, metric.value },
			})
		end
	end
	return { schemaVersion = 1, name = "fixture", measurements = measurements }
end

describe("framework comparison", function()
	it("comparison summary reports medians, Compose ratios, and explicit unsupported reasons", function()
		local markdown, complete = Report.markdown(
			stored(),
			{ subject() },
			{ framework "compose", framework "other", framework "absent" }
		)
		expect(complete):toBe(true)
		expect(markdown):toContain "| other | 20.000 | 2.00x | 50.000 | 0.50x | 1.000 | 40 | 2 | 3 | 4 |"
		expect(markdown):toContain "unsupported: No primitive \\| no substitute"
		expect(Report.median { 4, 1, 3, 2 }):toBe(2.5)
	end)

	it("comparison summary rejects missing supported measurements and handles zero heap baselines", function()
		local run = stored()
		table.remove(run.measurements)
		local markdown, complete = Report.markdown(run, { subject() }, { framework "compose", framework "other" })
		expect(complete):toBe(false)
		expect(markdown):toContain "missing evidence"
		local zero = stored()
		zero.measurements[3].samples = { 0, 0 }
		local rendered, hasEvidence = Report.markdown(zero, { subject() }, { framework "compose", framework "other" })
		expect(hasEvidence):toBe(true)
		expect(rendered):toContain "n/a (zero baseline)"
	end)

	it("summary counts every selected workload", function()
		local markdown, complete = Report.markdown(
			stored("fixture", "second"),
			{ subject(), subject "second" },
			{ framework "compose", framework "other", framework "absent" }
		)
		expect(complete):toBe(true)
		expect(markdown):toContain "| second | 10 | other | 20.000 | 2.00x |"
		expect(markdown):toContain "uses the 2 selected workloads"
		expect(markdown):toContain "| other | 2 | 2 | 2.00x |"
		expect(markdown):toContain "| absent | 0 | 0 | — |"
	end)

	it("comparison runs every documented lane in its published order", function()
		local names: { string } = {}
		for _, candidate in Frameworks.available() do
			table.insert(names, candidate.name)
		end
		expect(table.concat(names, ",")):toBe "plain,compose,compose-direct,fusion,vide,react,blend,roact,seam,signals,react-reflex,fusion-charm,react-upstream"
	end)

	it("every library lane classifies every runtime workload and pins benchmark-only sources", function()
		local names: { [string]: string } = {
			compose = "compose",
			["compose-direct"] = "compose",
			fusion = "fusion",
			vide = "vide",
			react = "react",
			blend = "blend",
			roact = "roact",
			seam = "seam",
			signals = "signals",
			["react-reflex"] = "reflex",
			["fusion-charm"] = "charm",
			["react-upstream"] = "react-upstream",
		}
		local seen: { [string]: boolean } = {}
		for _, candidate in Frameworks.available() do
			local dependencyName = names[candidate.name]
			if not dependencyName then
				continue
			end
			seen[candidate.name] = true
			local found = false
			for _, dependency in Lock.dependencies do
				if dependency.name == dependencyName then
					found = true
					expect(#dependency.commit):toBe(40)
					expect(#dependency.tree):toBe(40)
					expect(dependency.rights):toBe "MIT"
					for _, surface in dependency.surfaces do
						expect(surface.role):toBe "benchmark"
					end
				end
			end
			expect(found):toBe(true)
			expect(#Workloads.all):toBe(22)
			for _, workload in Workloads.all do
				local implemented = workload.cases[candidate.name] ~= nil
				local reasons: { [string]: string } = workload.unsupported or {}
				local reason = reasons[candidate.name]
				expect(implemented ~= (reason ~= nil)):toBe(true)
				if reason then
					expect(#reason > 20):toBe(true)
				end
			end
		end
		for name in names do
			expect(seen[name]):toBe(true)
		end
	end)

	it("comparison as-shipped mode adds no directive and like-for-like mode compiles at level 2", function()
		local source = "local function inlined() return debug.info(1, 'n') end local name = inlined() return name"
		expect(luau.load(Upstream.compile(source), "probe", { debug = debug })()):toBe "inlined"
		Upstream.setMode "like-for-like"
		local optimized = luau.load(Upstream.compile(source), "probe", { debug = debug })()
		Upstream.setMode "as-shipped"
		expect(optimized).never:toBe "inlined"
	end)

	it("runs library files in the Lute environment with their cost-model globals bound", function()
		local globals = (Environment.create().globals :: unknown) :: { [string]: unknown }
		local loaded = Upstream.prepare(
			"sharedHelper = function() return Instance end\nreturn function() return sharedHelper(), math.floor(2.5), script end",
			globals,
			"probe"
		)
		local bound = assert(loaded.bound)
		expect(table.find(bound, "Instance") ~= nil):toBe(true)
		expect(table.find(bound, "sharedHelper") ~= nil):toBe(true)
		expect(table.find(bound, "script") ~= nil):toBe(true)
		expect(table.find(bound, "math")):toBeNil()
		local reader = Upstream.run(loaded, globals) :: () -> (unknown, number, unknown)
		local instance, floored, script = reader()
		expect(instance):toBe(globals.Instance)
		expect(floored):toBe(2)
		expect(script):toBe(globals.script)
		expect(debug.info(reader, "l")):toBe(2)
		expect(luau.load(luau.compile "return sharedHelper", "other")()):toBeNil()

		local fallback =
			Upstream.prepare("type function Echo(t) print(t) return t end\nreturn Instance, print", globals, "typed")
		expect(fallback.bound):toBeNil()
		local instanceAgain, printer = Upstream.run(fallback, globals)
		expect(instanceAgain):toBe(globals.Instance)
		expect(printer):toBe(globals.print)
	end)

	it("comparison lanes load once per process and Compose loads as it ships", function()
		local compose: Frameworks.Framework? = nil
		for _, candidate in Frameworks.available() do
			if candidate.name == "compose" then
				compose = candidate
			end
		end
		local lane = assert(compose)
		local first = Frameworks.open(lane)
		local second = Frameworks.open(lane)
		expect(second.environment):toBe(first.environment)
		expect(second.loaded.library):toBe(first.loaded.library)
		expect(first.loaded.library):toBe(ComposeCore)
		Frameworks.close(lane)
		expect(Frameworks.open(lane).environment == first.environment):toBe(false)
		Frameworks.close(lane)
		Upstream.setMode "like-for-like"
		local equalTerms = Frameworks.open(lane).loaded.library
		Frameworks.close(lane)
		Upstream.setMode "as-shipped"
		expect(equalTerms == ComposeCore):toBe(false)
	end)

	it("comparison timing workers rotate lane order by their offset", function()
		local function first(offset: number): string
			local entries = Suites.entries { filter = "update-leaf", offset = offset }
			return entries[1].collection.benchmarks[1].name
		end
		expect(first(0)):toBe "update-leaf/plain"
		expect(first(1)):toBe "update-leaf/compose"
	end)

	it("comparison host models native vector defaults and ancestry", function()
		local environment = Environment.create()
		local container = environment.container()
		local parent = environment.globals.Instance.new "Frame"
		local part = environment.globals.Instance.new "Part"
		expect(environment.globals.typeof(part.Position)):toBe "Vector3"
		parent.Parent = container
		part.Parent = parent
		expect(part:IsDescendantOf(environment.globals.game)):toBe(true)
		local changes = 0
		local connection = environment.signal(part, "AncestryChanged"):Connect(function()
			changes += 1
		end)
		part.Parent = parent
		expect(changes):toBe(0)
		part.Parent = container
		expect(changes):toBe(1)
		part.Parent = nil
		expect(part:IsDescendantOf(environment.globals.game)):toBe(false)
		connection:Disconnect()
		parent:Destroy()
		part:Destroy()
		container:Destroy()
		expect(environment.liveConnections()):toBe(0)
		expect(environment.liveInstances()):toBe(1)
	end)

	it("discloses every loader fallback that a parity worker attaches", function()
		local harness = Verify.createHarness { now = os.clock }
		harness:case("first", function(context)
			context:attach("loader-fallbacks.txt", "text/plain", "@b.luau\n@a.luau")
		end)
		harness:case("second", function(context)
			context:attach("loader-fallbacks.txt", "text/plain", "@a.luau")
		end)
		local disclosed = Report.fallbacks(harness:run { executor = "fixture" })
		expect(disclosed):toContain "- `a.luau`\n- `b.luau`"
		local none = Verify.createHarness { now = os.clock }
		none:case("clean", function() end)
		expect(Report.fallbacks(none:run { executor = "fixture" })):toContain "No file used the fallback."
	end)

	it("calibration rejection keeps raw measurements but cannot supply comparison values", function()
		local harness = Verify.createHarness { now = os.clock }
		local function measure(context: Verify.Context, name: string)
			context:measure("fixture", name, {
				samples = { 1, 2 },
				unit = "microseconds",
				context = { environment = "fixture", signal = name, timing = "observed" },
			}, { unit = "microseconds", minimumSamples = 2, measureOnly = true })
		end
		harness:case("accepted", function(context)
			measure(context, "accepted")
		end)
		harness:case("rejected", function(context)
			measure(context, "rejected")
			context:unsupported "CPU reference drift"
		end)
		local report = harness:run { executor = "fixture" }
		expect(report.unsupported):toBe(1)
		expect(#Benchmark.storeReport("raw", report).measurements):toBe(2)
		local accepted = Report.store("qualified", report)
		expect(#accepted.measurements):toBe(1)
		expect(accepted.measurements[1].name):toBe "accepted"
	end)
end)

return nil
