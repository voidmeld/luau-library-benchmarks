--!strict

local Types = require "./types"

return function(Facet: Types.Facet): Types.Motion
	local metrics = Facet.themes.neutralPackage().metrics.motion
	local durations = assert(metrics.durations)
	local easing = assert(metrics.easing)
	return {
		dialog = assert(metrics.dialog),
		toast = assert(metrics.toast),
		radial = assert(metrics.radial),
		travel = assert(durations.travel),
		present = assert(easing.present),
		travelEase = assert(easing.travel),
	}
end
