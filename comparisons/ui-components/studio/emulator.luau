--!strict

local process = require "@lute/process"
local system = require "@lute/system"

local WATCH = [[
Add-Type -AssemblyName UIAutomationClient, UIAutomationTypes
Add-Type -Namespace Native -Name Pointer -MemberDefinition @'
[DllImport("user32.dll")] public static extern bool SetCursorPos(int x, int y);
[DllImport("user32.dll")] public static extern void mouse_event(uint flags, uint dx, uint dy, uint data, System.UIntPtr extra);
[DllImport("user32.dll")] public static extern bool SetForegroundWindow(System.IntPtr window);
'@
$A = [System.Windows.Automation.AutomationElement]
$T = [System.Windows.Automation.TreeScope]
function Item($name) {
	New-Object System.Windows.Automation.AndCondition(
		(New-Object System.Windows.Automation.PropertyCondition($A::ControlTypeProperty, [System.Windows.Automation.ControlType]::MenuItem)),
		(New-Object System.Windows.Automation.PropertyCondition($A::NameProperty, $name)))
}
function Click($element) {
	$bounds = $element.Current.BoundingRectangle
	[Native.Pointer]::SetCursorPos([int]($bounds.X + $bounds.Width / 2), [int]($bounds.Y + $bounds.Height / 2)) | Out-Null
	Start-Sleep -Milliseconds 100
	[Native.Pointer]::mouse_event(2, 0, 0, 0, [System.UIntPtr]::Zero)
	[Native.Pointer]::mouse_event(4, 0, 0, 0, [System.UIntPtr]::Zero)
	Start-Sleep -Milliseconds 400
}
function Emulator($studio) {
	$owned = New-Object System.Windows.Automation.PropertyCondition($A::ProcessIdProperty, $studio.Id)
	foreach ($window in $A::RootElement.FindAll($T::Children, $owned)) {
		$found = $window.FindFirst($T::Descendants, (Item 'Controller Emulator'))
		if ($found) { return $found }
	}
	return $null
}
function Open($studio) {
	[Native.Pointer]::SetForegroundWindow($studio.MainWindowHandle) | Out-Null
	$test = $A::FromHandle($studio.MainWindowHandle).FindFirst($T::Descendants, (Item 'Test'))
	if (-not $test) { return $false }
	Click $test
	$entry = Emulator $studio
	if (-not $entry) { Click $test; return $false }
	$toggle = [System.Windows.Automation.TogglePattern]::Pattern
	if ($entry.GetCurrentPattern($toggle).Current.ToggleState -eq 'On') { Click $test; return $true }
	Click $entry
	Click $test
	$entry = Emulator $studio
	$open = $entry -and $entry.GetCurrentPattern($toggle).Current.ToggleState -eq 'On'
	Click $test
	return $open
}
$parent = [int]$env:UI_COMPONENTS_EMULATOR_PARENT
$done = @{}
while (Get-Process -Id $parent -ErrorAction SilentlyContinue) {
	foreach ($studio in Get-Process RobloxStudioBeta -ErrorAction SilentlyContinue) {
		if ($done[$studio.Id] -or $studio.MainWindowHandle -eq 0 -or $studio.MainWindowTitle -notlike '*Verify-*.rbxlx*') { continue }
		try { if (Open $studio) { $done[$studio.Id] = $true } } catch {}
	}
	Start-Sleep -Milliseconds 250
}
]]

local function start()
	if system.os ~= "windows" and system.os ~= "Windows_NT" then
		return
	end
	local env = table.clone(process.env)
	env.UI_COMPONENTS_EMULATOR_PARENT = tostring(process.pid())
	env.UI_COMPONENTS_EMULATOR_WATCH = WATCH
	local started = process.run({
		"powershell",
		"-NoProfile",
		"-Command",
		"Start-Process powershell -WindowStyle Hidden -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-Command','Invoke-Expression $env:UI_COMPONENTS_EMULATOR_WATCH'",
	}, { env = env })
	assert(started.ok, "could not start the Controller Emulator watcher: " .. started.stderr)
end

return { start = start, WORKLOAD = "gamepad-grid-6x6" }
