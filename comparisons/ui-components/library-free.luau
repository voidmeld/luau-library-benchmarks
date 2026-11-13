--!strict

local Types = require "./types"

local FIELDS: { [string]: boolean } = {
	Facet = true,
	Compose = true,
	runtime = true,
	Host = true,
	UI = true,
	motion = true,
}

local function withheld(_world: unknown, key: unknown): nil
	if type(key) == "string" and FIELDS[key] then
		error(`the plain lane read world.{key}; plain workloads must not use a library`, 2)
	end
	return nil
end

local WITHHELD = { __index = withheld }

local function libraryFree<T>(fields: T): T & Types.Library
	local value: unknown = fields
	if type(value) == "table" then
		setmetatable(value, WITHHELD)
	end
	return (fields :: unknown) :: T & Types.Library
end

local function withLibrary<T>(fields: T, library: Types.Library): T & Types.Library
	local record = (fields :: unknown) :: { [string]: unknown }
	record.Facet = library.Facet
	record.Compose = library.Compose
	record.runtime = library.runtime
	record.Host = library.Host
	record.UI = library.UI
	record.motion = library.motion
	return (fields :: unknown) :: T & Types.Library
end

return { libraryFree = libraryFree, withLibrary = withLibrary, FIELDS = table.freeze(table.clone(FIELDS)) }
