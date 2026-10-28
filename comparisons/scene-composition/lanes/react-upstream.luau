--!strict

local React = require "./react"
local Environment = require "../cost-model"
local Types = require "./types"

local function create(environment: Environment.Environment): Types.Driver
	return React.create(environment, nil, "react-upstream")
end

return { create = create }
