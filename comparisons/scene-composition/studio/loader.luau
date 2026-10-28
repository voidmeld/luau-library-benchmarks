--!strict
--!nolint DeprecatedApi

type Module = {
	Name: string,
	Parent: Module?,
	FindFirstChild: (Module, string) -> Module?,
	Clone: (Module) -> Module,
	Destroy: (Module) -> (),
}
type Native = {
	require: (Module) -> unknown,
	Instance: { new: (string) -> Module },
	game: { GetService: (unknown, "ReplicatedStorage") -> Module },
}
export type Loader = { load: <T>(path: string) -> T, prefix: string, release: () -> () }

local RELEASES: { [string]: string } = {
	[".lute/dependencies/react/modules/react/src"] = ".lute/releases/react-lua/React",
	[".lute/dependencies/react/modules/react-roblox/src"] = ".lute/releases/react-lua/ReactRoblox",
}

local native: Native = getfenv(0)
local here: { script: Module } = getfenv(1)
local studio = assert(here.script.Parent)
local mount = assert(assert(assert(studio.Parent).Parent).Parent)
local created = 0

local function create(): Loader
	created += 1
	local holder = native.Instance.new "Folder"
	holder.Name = "BenchmarkCase" .. created
	local packages = assert(mount:FindFirstChild ".lute", "library tree is not mounted"):Clone()
	packages.Parent = holder
	holder.Parent = native.game:GetService "ReplicatedStorage"
	local function find(path: string): Module
		local logical = (RELEASES[path] or path):gsub("%.luau?$", ""):gsub("/init$", "")
		local current = holder
		for part in logical:gmatch "[^/]+" do
			current = assert(current:FindFirstChild(part), "benchmark module is not mounted: " .. path)
		end
		return current
	end
	return {
		load = function<T>(path: string): T
			local loaded: T = native.require(find(path)) :: T
			return loaded
		end,
		prefix = "ReplicatedStorage." .. holder.Name .. ".",
		release = function()
			holder:Destroy()
		end,
	}
end

return { create = create, RELEASES = RELEASES }
