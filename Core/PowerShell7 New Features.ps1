#region Foreach-Object -parallel
$logNames = 'Application','System','Windows PowerShell','Microsoft-Windows-Store/Operational'

# all versions: non-parallel
Measure-Command {
    $logEntries = $logNames | ForEach-Object {
        Get-WinEvent -LogName $_ -MaxEvents 10000
    }
    $logEntries.Count
}

# NEW: parallel
Measure-Command {
    $logEntries = $logNames | ForEach-Object -Parallel {
        Get-WinEvent -LogName $_ -MaxEvents 10000
    } -ThrottleLimit 5
    $logEntries.Count
}
#endregion

#region ternary operator
# old way: if-else statements
if ($true) {
    "This is true"
} else {
    "This is false"
}

# same thing in the new way
$true ? "This is true" : "This is false"
#endregion

#region Pipeline chain operators
# using $? and $LASTEXITCODE to determine success -< works with external commands, too
1/0 || "The last operation was an error"
1/0 && "The last operation was a success!" # nope, no output
#endregion

#region null coalescing operators
# ?? and ??=
# ?? returns the left side if it's not $null. Otherwise Powershell evaluates the right side.

"Hello" ?? "You don't see me."
$null ?? "Now you do."

# ??= if left side is $null, Powershell assigns the right side to it
Remove-Variable -Name PWSHProcesses -Force -ErrorAction SilentlyContinue # make sure our test variable is gone
$PWSHProcesses ??= Get-Process -Name pwsh
Start-Process pwsh # let's start a new PowerShell process
$PWSHProcesses ??= Get-Process -Name pwsh # assignment, does not display anything
$PWSHProcesses # still the same number of processes -> right side did not execute and assign anything on the second go
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

#region PowerShell 7.1 supports TLS 1.3
Invoke-RestMethod -Uri 'https://whatever.com' -SslProtocol Tls13
#endregion

#region Get-Random can shuffle a list
"A","B","C" | Get-Random -Shuffle
#endregion

#region PowerShell 7.1 PSReadLine can predict commands from history
Set-PSReadLineOption -PredictionSource History
#endregion