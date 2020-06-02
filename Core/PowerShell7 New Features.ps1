#region Foreach-Object -parallel
$logNames = 'Application','System','Windows PowerShell','Microsoft-Windows-Store/Operational'

Measure-Command {
    $logEntries = $logNames | ForEach-Object -Parallel {
        Get-WinEvent -LogName $_ -MaxEvents 10000
    } -ThrottleLimit 5
    $logEntries.Count
}

# non parallel
Measure-Command {
    $logEntries = $logNames | ForEach-Object {
        Get-WinEvent -LogName $_ -MaxEvents 10000
    }
    $logEntries.Count
}
#endregion

#region ternary operator
# compact if-else statements
$true ? "This is true" : "This is false"
#endregion

#region Pipeline chain operators
# using $? and $LASTEXITCODE to determine success -< works with external commands, too
Test-Path -Path doesnotexist.txt || "I would tun this if the path existed"
Test-Path -Path doesnotexist.txt && "The file does not exist"
#endregion

#region null colescing operators
# ?? and ??=
# ?? the left side if it's not $null. Otherwise Powershell evaluates the right side.

"Hello" ?? "You don't see me."
$null ?? "Now you do."

# ??= if left side is $null, Powershell assigns the right side to it
Remove-Variable -Name PWSHProcesses -Force -ErrorAction SilentlyContinue # make sure our test variable is gone
$PWSHProcesses ??= Get-Process -Name pwsh
Start-Process pwsh 
$PWSHProcesses ??= Get-Process -Name pwsh # assignment, does not display anything
$PWSHProcesses # still the same number of processes -> right side did not execute and assign on the second go
#endregion

#region error handling
1/0 # concise view is more focussed on error

$ErrorView = 'NormalView' # classic mode
1/0
$ErrorView = 'ConciseView' # back to PowerShell 7 default

Get-Error
Get-Error -Newest 3
$Error[0] | Get-Error # last error
#endregion

#region update check
$env:POWERSHELL_UPDATECHECK = 'LTS' # only notifies for new LTS releases
$env:POWERSHELL_UPDATECHECK = 'Off' # does not check for updates
$env:POWERSHELL_UPDATECHECK = 'Default' # or empty checks for GA and Preview updates depending on whoch pwsh version you run
#endregion

#region Import-Module compatibility mode
Get-Module -Name GroupPolicy -ListAvailable # empty on PowerShell 7 even if installed for Windows PowerShell 5.1
Import-Module -Name GroupPolicy -UseWindowsPowerShell # uses internal WinRM sesssion to Windows PowerShell 5.1 -> objects are deserialized! (no methods and disconnected from the original object)
Import-Module -Name GroupPolicy -SkipEditionCheck # force load a module natively, may have unexpected effects
#endregion

#region Out-Gridview is back!
Get-Process | Out-GridView -PassThru | Stop-Process -WhatIf
#endregion