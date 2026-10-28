--!strict

local INPUT =
	"A script cannot fire GuiButton.Activated or set GuiState. Real input would measure the input pipeline, not the controls."

return {
	["inventory-100"] = INPUT,
	["inventory-500"] = INPUT,
	["button-feedback-50"] = INPUT,
	["dialog-50-cycles"] = INPUT,
	["tabs-5-100-switches"] = INPUT,
	["radial-50-cycles"] = INPUT,
	["tile-transfer-20"] = INPUT,
	["toast-stream-100"] = "Each sample waits about five minutes of real time for 50 toasts to expire.",
} :: { [string]: string }
