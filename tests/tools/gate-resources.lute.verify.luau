--!strict

local Test = require "../harness"
local resources = require "../../tools/lib/gate-resources"

local describe, it, expect = Test.describe, Test.it, Test.expect

describe("gate resources", function()
	it("test workers fit cores, available memory and the source count", function()
		expect(resources(4, 16384, 100)):toBe(4)
		expect(resources(12, 32768, 100)):toBe(8)
		expect(resources(8, 8192, 100)):toBe(3)
		expect(resources(4, 1024, 100)):toBe(1)
		expect(resources(4, 16384, 2)):toBe(2)
	end)
end)

return nil
