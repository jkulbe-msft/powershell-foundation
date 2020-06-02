Write-Output "This is a simple demo of how to run a script in VS Code"

Get-ChildItem -Path .\

$process = Get-Process -Name Code | Measure

if ($process -ne $null) {
    Write-Output "VS Code is running"
}
else {
    Write "VS Code is not running"
}