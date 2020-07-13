#region boolean

# unexpected behaviour
0 -eq $false # OK
1 -eq $true # OK
2 -eq $true # appears wrong but is technically correct because object on the left determines type
[int]2 -eq [int]$true

$true -eq 2 #intended behaviour
# left-most object actually causes this to happen:
[bool]$true -eq [bool]2

###

[bool]"Hello" # OK
[bool]"False" # unexpected. Non-empty strings are true, just like in other languages.
[System.Convert]::ToBoolean("False") # use this instead
#endregion

#region Arrays

# add to arrays
$a = @()
$a += 'test' # slow
$a.Add('test') # error, array is fixed size

$a = New-Object System.Collections.ArrayList
$a.Add('test') # faster

#remove from arrays
$a = New-Object System.Collections.ArrayList
$a.Add('test')
$a.Add(2)
$a.Remove('test')

# Changing object items in an array
$array[0] = "New value"
$array.set(1,"Method new value")
$array
#endregion

#region hashtables
$HashTable = @{
        FirstName = 'Jan'
        LastName = 'Kulbe'
}
$HashTable.Add('Job','PFE')
$HashTable.Add('Job','X-Wing pilot') # you already have a job

$HashTable.Remove('Job')
$HashTable.Add('Job','X-Wing pilot')

$HashTable.Keys
$HashTable.Values
$HashTable.ContainsKey('Job')

$HashTable['FirstName']
$Hashtable.Firstname
$HashTable['FirstName','Job']

# iterating through a hashtable
$HashTable.Keys | ForEach-Object {
    "The value for key $_ is $($HashTable[$_])."
} 

$HashTable.GetEnumerator() | ForEach-Object {
    "The value for key $($_.Key) is $($_.Value)."
} 

# calculated properties
Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length,@{Label='SizeKB';Expression={[math]::round($_.Length/1KB)}}

# splatting
$params = @{
    LogName      = "application"
    Newest       = 10
    EntryType    = "Warning"}
Get-EventLog @Params

# custom objects - for PS 5+ better use pscustomobject

$Services = Get-Service
foreach ($service in $services)
{$props = @{
    'ComputerName' = $env:computername
    'ServiceName' = $Service.name
    'NumberofDependentServices' = $Service.DependentServices.count
    'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10) }

$object = New-Object -TypeName PSObject -Property $props
Write-Output $object}

#pscustomobject
function Get-Customobject {
    $Services = Get-Service
    $now = Get-Date
    foreach ($service in $services)
        {
            [pscustomobject]@{
            'ComputerName' = $env:computername 
            'ServiceName' = $Service.name
            'NumberofDependentServices' = $Service.DependentServices.count
            'Date' = $now
            'DayOfWeek' = $now.DayOfWeek
            'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10) }
        }
    }
#endregion

#region constructors
([type]"Net.Sockets.TCPClient").GetConstructors() | ForEach-Object {$_.GetParameters()} | Select-Object Name,ParameterType
#endregion