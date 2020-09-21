#region detection
$IsCoreCLR
$IsLinux
$IsMacOS
$IsWindows

$PSVersionTable
$PSVersionTable.Platform
#endregion

#region environment variables
Get-ChildItem env: # works, but better use .Net classes
$env:MYVARIABLE = "Hello" # works, but better use .Net classes
[Environment]::SetEnvironmentVariable('MYVARIABLE','Hello')
[Environment]::GetEnvironmentVariable('MYVARIABLE')
[Environment]::GetEnvironmentVariable('MyVariable') # emptyon Linux, environment variables are case sensitive 
[Environment]::SetEnvironmentVariable('MyMachineVar','MyValue','Machine') # only works on Windows

[Environment]::UserName
[Environment]::MachineName # $env:computername only available on Windows
[Environment]::NewLine
[IO.Path]::GetTempPath()
[IO.Path]::DirectorySeparatorChar
[IO.Path]::PathSeparator # the separator in the PATH environment variable, different between Windows and Linux
[System.IO.Path]::Combine('Azure:', '*', 'ResourceGroups', '*')

#region path
Join-Path -Path '.\MyFolder\MySubFolder' -ChildPath 'MyFile' # manages correct path separators on all platforms, including pre-existing slshes
#endregion

#region case sensitivity
$env:Path # works on Windows, empty on MacOS/Linux
$env:PATH # this works, mind case-sensitivity

# unexpected hash table case sensitivity is now fixed in .Net Core. See https://github.com/PowerShell/PowerShell/issues/7761
# $MyHashTable = @{ 'FirstName' = 'John';'LastName'='Smith'}
# $MyHashTable['firstname'] # returns nothing on Linux/MacOS, keys are case-sensitive
# $MyHashTable['FirstName'] # works as expected
# $myhashtable['FirstName'] # also works, variable names are not case sensitive 
#endregion
