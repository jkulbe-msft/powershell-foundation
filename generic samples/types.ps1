# list type accelerators
[PSObject].Assembly.GetType("System.Management.Automation.TypeAccelerators")::Get

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

# speed test array vs. array list

function Measure-ArrayTime {
    param([int]$count)

    $ArrayTime = (Measure-command  {
        $Array = @()
        1..$count | ForEach-Object {
            $Array += "Hello World"
        }
    }).TotalMilliseconds

    $ArrayListTime = (Measure-command  {
        
        $Array = New-Object System.Collections.ArrayList
        1..$count | ForEach-Object {
            $Array.Add("Hello World")
        }

    }).TotalMilliseconds

    [PSCustomObject]@{
        Count = $count
        ArrayTimeMilliSeconds = $ArrayTime
        ArrayListTimeMilliSeconds = $ArrayListTime
    }
}
#endregion

#region hashtables
$HashTable = @{
        FirstName = 'Jan'
        LastName = 'Kulbe'
}
$HashTable.Add('Job','Customer Engineer')
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
function Get-CustomObject {
    $Services = Get-Service
    $now = Get-Date
    foreach ($service in $services)
        {
            [pscustomobject]@{
            PSTypeName = 'My.CustomObject'
            ComputerName = $env:computername 
            ServiceName = $Service.name
            NumberofDependentServices = $Service.DependentServices.count
            Date = $now
            DayOfWeek = $now.DayOfWeek
            LuckyNumber = (Get-Random -Minimum 1 -Maximum 10) }
        }
    }

Get-CustomObject
Get-CustomObject | Get-Member
# https://docs.microsoft.com/en-us/powershell/scripting/learn/deep-dives/everything-about-pscustomobject?view=powershell-7
$TypeData = @{
    TypeName = 'My.CustomObject'
    DefaultDisplayPropertySet = 'ServiceName','LuckyNumber'
}
Update-TypeData @TypeData
Get-CustomObject
#endregion

#region custom type and add-member
$myobject = [PSCustomObject]@{
    Number = '3.141592'
}
$myObject.PSObject.TypeNames.Insert(0,"My.Object")
$myobject | Add-Member -TypeName MyPi
$myobject | Add-Member -NotePropertyName MyNoteProperty -NotePropertyValue 'MyNotePropertyValue'
$myobject | Add-Member -MemberType AliasProperty -Name Pi -Value Number
$myobject | Add-Member -MemberType ScriptProperty -Name RoundedNumber -Value {[math]::round($this.Number,2, [System.MidpointRounding]::AwayFromZero)}
#endregion

#region classes

Enum TVTechnology {
    CRT = 1
    LCD = 2
    Plasma = 3
    OLED = 4
}

Enum TVInput {
    SCART = 1
    HDMI = 2
    VGA = 4
}

class TV {
    # properties
    [string]$Make
    [string]$Model
    [int]$ScreenSize
    [bool]$IsOn = $false
    [int]$CurrentChannel
    [TVTechnology]$Technology = 2
    [int]$Input
    # methods
    [void]TogglePower(){
        $this.IsOn = -not $this.IsOn
    }
    [int]ChannelUp(){
        $this.CurrentChannel++
        return $this.CurrentChannel
    }
    [int]ChannelDown(){
        $this.CurrentChannel--
        return $this.CurrentChannel
    }
    [void]SetChannel([int]$Channel) {
        $this.CurrentChannel = $Channel
    }
    # static method
    static [bool]IsLarge([int]$ScreenSize) {
        if ($ScreenSize -ge 55) {return $true} else {return $false}
    }
    # constructors
    TV ([string]$Make,[string]$Model,[int]$ScreenSize){
        $this.Make = $Make
        $this.Model = $Model
        $this.ScreenSize = $ScreenSize
        $this.CurrentChannel = Get-Random -Minimum 1 -Maximum 99
    }
    TV ([string]$Make,[string]$Model,[int]$ScreenSize,$Technology){
        $this.Make = $Make
        $this.Model = $Model
        $this.ScreenSize = $ScreenSize
        $this.CurrentChannel = Get-Random -Minimum 1 -Maximum 99
        $this.Technology = $Technology
    }
}

$TV = [TV]::new('Contoso','FlixMaster 2000',55,'OLED')
$TV2 = [TV]::new('Contoso','Plasmastar',65,[TVTechnology]::Plasma)
[TV]::IsLarge(65)

$TV.Input = [TVInput]::HDMI -bor [TVInput]::VGA -bor [TVInput]::SCART # add connectors
$TV.Input = $TV.Input -bxor [TVInput]::SCART # remove SCART
$TV.Input -band [TVInput]::HDMI # does my TV have an HDMI connector?
$TV.Input -band [TVInput]::SCART # does my TV have a SCART connector?

#endregion

#region constructors
([type]"Net.Sockets.TCPClient").GetConstructors() | ForEach-Object {$_.GetParameters()} | Select-Object Name,ParameterType
#endregion