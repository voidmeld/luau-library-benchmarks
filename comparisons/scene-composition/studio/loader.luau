--!strict
--!nolint DeprecatedApi

type Module = { Parent: Module, FindFirstChild: (Module, string) -> Module? }
type Native = { require: (Module) -> unknown }

local RELEASES: { [string]: string } = {
	[".lute/dependencies/react/modules/react/src"] = ".lute/releases/react-lua/React",
	[".lute/dependencies/react/modules/react-roblox/src"] = ".lute/releases/react-lua/ReactRoblox",
}

local native: Native = getfenv(0)
local here: { script: Module } = getfenv(1)
local mount = here.script.Parent.Parent.Parent.Parent

local function find(path: string): Module
	local logical = (RELEASES[path] or path):gsub("%.luau?$", ""):gsub("/init$", "")
	local current = mount
	for part in logical:gmatch "[^/]+" do
		current = assert(current:FindFirstChild(part), "benchmark module is not mounted: " .. path)
	end
	return current
end

local function load<T>(path: string): T
	local loaded: T = native.require(find(path)) :: T
	return loaded
end

return { load = load, find = find, RELEASES = RELEASES }
