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

[Environment]::UserName
[Environment]::MachineName # $env:computername only available on Windows
[IO.Path]::GetTempPath()
[IO.Path]::DirectorySeparatorChar

[Environment]::SetEnvironmentVariable('MyMachineVar','MyValue','Machine')
#endregion

#region path
Join-Path -Path '.\MyFolder\MySubFolder' -ChildPath 'MyFile' # manages correct path separators on all platforms
#endregion

#region case sensitivity
$env:Path # works on Windows, empty on MacOS/Linux
$env:PATH # this works, mind case-sensitivity

$MyHashTable = @{ 'FirstName' = 'John';'LastName'='Smith'}
$MyHashTable['firstname'] # returns nothing on Linux/MacOS, keys are case-sensitive
$MyHashTable['FirstName'] # works as expected
$myhashtable['FirstName'] # also works, variable names are not case sensitive 
#endregion