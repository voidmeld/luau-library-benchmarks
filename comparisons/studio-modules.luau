--!strict

local Sources = require "./sources"

local function segments(path: string): { string }
	local parts: { string } = {}
	for part in path:gmatch "[^/]+" do
		table.insert(parts, part)
	end
	return parts
end

local function relative(from: string, to: string): string
	local origin, target = segments(from), segments(to)
	local shared = 0
	while shared < #origin - 1 and shared < #target and origin[shared + 1] == target[shared + 1] do
		shared += 1
	end
	local expression = "script" .. string.rep(".Parent", #origin - shared)
	for index = shared + 1, #target do
		expression ..= (":FindFirstChild(%q)"):format(target[index])
	end
	return expression
end

local function logical(path: string): string
	return (path:gsub("%.luau?$", ""):gsub("/init$", ""))
end

local function resolveAliases(verbatim: { [string]: string })
	local packages: { [string]: string } = {}
	for _, source in Sources.all do
		if source.package then
			packages[source.name] = source.root
		end
	end
	for path, source in verbatim do
		local function replace(target: string): string
			local alias, rest = string.match(target, "^([%w_%-]+)/(.+)$")
			local root = if alias ~= nil then packages[alias] else nil
			if root == nil or rest == nil then
				return 'require "@' .. target .. '"'
			end
			return "require(" .. relative(path, logical(root .. "/" .. rest)) .. ")"
		end
		local rewritten = source:gsub('require%s*"@([^"]+)"', replace)
		rewritten = rewritten:gsub('require%s*%(%s*"@([^"]+)"%s*%)', replace)
		verbatim[path] = rewritten
	end
end

return table.freeze {
	relative = relative,
	resolveAliases = resolveAliases,
}
