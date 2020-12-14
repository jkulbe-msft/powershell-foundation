#region slide 12 comparison
# Simple samples:
20 -ge 10
5 -lt 6
7 -le 2

# Hard samples:
[int]9 -eq [string]"9"
"nine" -eq 9
$true -eq "True"
$false -eq "False"
$false -eq [bool]"False"
$false -eq ([System.Convert]::ToBoolean("False")) # use this instead
"" -eq $not_existing_variable
$true -eq 42
42 -eq $true

#endregion

#region slide 21 advanded operators
# Like and not like:
$files = Get-ChildItem C:\Windows -File
$files.name -like "*.exe"
$files.name -like "[a-z]???pad.exe"    # -> Notepad.exe
$files.name -notlike "*.[a-z][o][g]"   #  -> NOT any type of logfile ending on OG

# Match "� Advanced regex will be in the PowerShell tool building course. Regex101.com can be used for  live testing although syntax might deviate a little for some PowerShell equivalents
"192.176.42.5" -match "176" #    -> Match 176 as numbers
"192.176.42.5" -match "\d"  #   -> Match digits# -> Match IPv4 address

#Contains:
"1","2","3","4","5" -contains "two"
"1","2","3","4","5" -contains 0
"apple",$true,"x","�pear" -contains "true"
(get-service) -contains "WSearch"
(get-service).name -notcontains "WSearch"
#endregion

#region slide 26 logical operators
# Simple:
2 -lt 5 -and 7 -lt 1
2 -lt 5 -or 7 -lt 1
2 -lt 5 -or 7 -lt 1
!(2 -lt 5 -Xor 7 -lt 1)

# More advanced:
"pear" -like "*r*" -and "Apple" -ceq "apple"
$true -eq "True" -XOR $false -eq "False"
#endregion

#region slide 34 numeric byte multipliers
1024 -eq 1kb
5 * 1tb
464863 / 1mb
#endregion

#region slide 47 basic pipeline
# Viewing the advanced properties of all network adapters:
Get-NetAdapter | Get-NetAdapterAdvancedProperty

# View content of all INI files in the windows dir:
Get-ChildItem -path C:\Windows -File -Filter *.ini | Get-Content

# Creating and removing 5 new local groups: (Run as admin)
1..5 | New-Localgroup
1..5 | ForEach-Object {Remove-LocalGroup -Name $_}

# Creating 5 new local groups and adding administrators group as member: (Run as admin)
1..5 | New-Localgroup | ForEach-Object -process {Add-LocalGroupMember -Member administrators -Group $_}
Get-LocalGroupMember -Group 1
1..5 | ForEach-Object -process {Remove-LocalGroup -Name $_}

# Demonstrate that the pipeline uses optimization: (Run as admin)
measure-command {
    1..300 | 
    New-Localgroup | 
    ForEach-Object -process {Add-LocalGroupMember -Member administrators -Group $_ ;$_} | 
    ForEach-Object -process {Remove-LocalGroup -Name $_}
}

measure-command {
    foreach ( $number in 1..300)
    {
        New-Localgroup -Name $number
        Add-LocalGroupMember -Member administrators -Group $number
        Remove-LocalGroup -Name $number
    }
}
#endregion

#region slide 55 objects on the pipeline
# Use sort-object to sort the last write time of files:
Get-ChildItem -Path c:\windows -File | Sort-Object -Property LastWriteTime

# Viewing Unique event types using sort-object sort them ascending or descending:
Get-EventLog -LogName Application -Newest 500 | Sort-Object -Property EntryType -Unique
Get-EventLog -LogName Application -Newest 500 | Sort-Object -Property EntryType -Unique -Descending

# As unique only shows single object group object can be used to display a group of all types. The information will remain in the output object.
Get-EventLog -LogName Application -Newest 500 | Group-Object -Property entrytype

# View the information of a grouped object:
$group = Get-EventLog -LogName Application -Newest 500 | Group-Object -Property entrytype
$group[1].group

# Using Measure-object to measure lines, words and characters of a file:
Get-Content -path C:\windows\system.ini | Measure-Object -Line -Word -Character

# Using measure-object to work with file count and file sizes in byte :
get-childitem -path C:\windows\System32 -file |  Measure-Object
get-childitem -path C:\windows\System32 -file |  Measure-Object -Property length -Sum
get-childitem -path C:\windows\System32 -file |  Measure-Object -Property length -Sum -Maximum -Minimum -Average

# Using measure-object to measure free space from WMI:
Get-WMIObject win32_LogicalDisk | Measure-Object -Property freespace -Sum

# Using compare-object to view the difference in folders. Note Compare-object only takes pipeline input on the "referenceobject"� parameter!!
$programfiles = Get-ChildItem -Path 'C:\Program Files\'
Get-ChildItem -Path 'C:\Program Files (x86)\' | Compare-Object -ReferenceObject $programfiles -Property name
#endregion

#region slide 70 format cmdlets
Get-ChildItem -Path C:\Windows\ -File | Sort-Object -Property name | ft
Get-ChildItem -Path C:\Windows\ -File | Group-Object -Property name | ft
#endregion

#region slide 80 export cmdlets
# Export operating system data to csv:
Get-WmiObject win32_operatingsystem | Export-Csv -Path c:\temp\osinfo.csv

# View the data and note the object type is added in first row. This can be omitted by using the "notypeinformation" parameter if the csv is used outside of powershell
notepad C:\temp\osinfo.csv
Get-WmiObject win32_operatingsystem | Export-Csv -Path c:\temp\osinfo.csv -NoTypeInformation

# Import the data again into a variable:
$importeddata = import-csv -Path C:\temp\osinfo.csv
$importeddata

# Not every machine has the same delimiter setup in the region settings of a PC. You can use "culture" or "delimiter" parameters to control this:
Get-WmiObject win32_operatingsystem | Export-Csv -Path c:\temp\osinfo.csv -NoTypeInformation -UseCulture
Get-WmiObject win32_operatingsystem | Export-Csv -Path c:\temp\osinfo.csv -NoTypeInformation -Delimiter "`t"

# Exporting multi dimensional arrays or special advanced classes won't work in CSV format as the data gets lost in serialization. Look at "RequiredServices" and "DependentServices".
# The data is lost on import:
Get-Service | Export-Csv -Path c:\temp\services.csv
Import-Csv -Path c:\temp\services.csv

# We can use Export-Clixml to correctly serialize the data and also specify the depth of the serialization:
Get-Service | Export-Clixml -Path c:\temp\services.xml -Depth 1
notepad c:\temp\services.xml
$services = Import-Clixml -Path c:\temp\services.xml
$services
$services | Get-Member # note deserialized type and absence of methods
#endregion

#region slide 88 out cmdlets
# Use get-service to display the out-gridview. Show you can sort, add filters and scroll:
get-service | Out-GridView

# By using "passthru" parameter anything that is selected will now be returned. You can chain them together. (Select multiple items every time)
get-service | Out-GridView -PassThru
get-service | Out-GridView -PassThru | Sort-Object -Property name | Out-GridView -PassThru | Group-Object -Property status

# Suppressing output can be done sending it to out-null, although assigning it to a variable or explicit declare the output as void class is faster:
"this is silent text" # no, it's not :-)
"this is silent text" | out-null
measure-command {for($i=1;$i-lt 10000;$i++){"this is silent text" | out-null}}
measure-command {for($i=1;$i-lt 10000;$i++){$null = "this is silent text"}}
measure-command {for($i=1;$i-lt 10000;$i++){[void]"this is silent text"}}

# Out-string can be used to from string classes of the output in either concatenated blocks or individual lines:
$concatenated = Get-Process | Out-String
$concatenated[0]
$lines = Get-Process | Out-String -Stream
$lines[0]
$lines[1]
$lines[2]
$lines[3]
$lines[4]
#endregion

#region slide 94 pipeline variables
# Show the $_ from PS2 and the $PSitem from PS 3+. Due note that PSitem is not often used as most prefer $_
Get-Process | ForEach-Object -Process {$_}
Get-Process | ForEach-Object -Process {$psitem}

# You can also assign your own variable name:
Get-Process -PipelineVariable myownveryclearvariablename | ForEach-Object -Process {$myownveryclearvariablename}
#endregion

#region slide 102 foreach-object and where-object
# Using foreach-object is required if the second pipe element does not contain a command
get-service -Name *app* | $_.displayname #error
get-service -Name *app* | foreach-object {$_.displayname}

# Foreach-object actually uses the parameter -process
get-service -Name *app* | foreach-object -process {$_.displayname}

# Filtering with Where object. Note it only check if the result is True or False. Any non NULL value is true
Get-service | Where-Object -FilterScript {$false}
Get-service | Where-Object -FilterScript {$true}
Get-service | Where-Object -FilterScript {1+1}
Get-service | Where-Object -FilterScript {$null}

# Practical sample with where-object
Get-ChildItem -path c:\windows -filter *.ini |`
    Where-Object -filterscript {$_.length -lt 10kb} |`
    Sort-Object -property Length |`
    Format-Table -property name, length

# Simplified syntax
get-process | where id -lt 1000
Get-LocalUser | where lastlogon
Get-NetAdapter | where ConnectorPresent

# Compound conditions break when using simplified syntax
Get-ChildItem | where Length -gt 100 -and name -eq "Temp" #error
Get-ChildItem | Where-Object { $_.Length -gt 100 -and $_.name -eq "Temp" }
#endregion

#region slide 112 begin, processs, end
# Using other functions that replace $_ with there own version can case issues:
function My-Function
{
    Begin
    {
        Write-output -InputObject ('Start $_ = ' + "$_")
    }
    Process
    {
    $iteration = $_
        Try
        {
            Write-output -InputObject ('Start in try $_ = ' + "$_")
            10/0
        }
        catch
        {
            Write-host -InputObject ('In catch $_ = ' + "$_") -f red
            Write-host -InputObject ('In catch $iteration = ' + "$iteration") -f Green
        }
        Write-output -InputObject ('After catch $_ = ' + "$_")
        Write-output -InputObject ('After catch $iteration = ' + "$iteration")
    }
    End
    {
        Write-output -InputObject ('End $_ = ' + "$_")
    }
}
#endregion

#region alide 130 arithmetic functions
# The default mathematical functions:
10-5
5+8
8/2
5*10
"test system" * 10
10 * "test system" # Will break

# Modulo , It can solve shifting problem like exchange database placement:
1..20 | Foreach-object -Process { $_%4 }

# Bitwise shift shifts all bits x numbers to left or right:
8 -shr 1 # 00008000 -> 00000800   ->  4
8 -shl 1 # 00008000 -> 00080000   -> 16
#endregion

#region slide 136 assignment operators
# The default assignment operators:
$value = 10
$value
$value += 10
$value
$value -= 10
$value
$value *= 10
$value
$value /= 10
$value
$value %= 2
$value

# Multiple ways to assign +1
$value++
++$value
$value += 1
$value = $value + 1

# Unary pre and post processing:
$1 = 5
$1
write-output -InputObject (++$1)
$1
write-output -InputObject ($1++)
$1
#endregion

#region slide 146 split, join, replace
# Using the unary split operator :
-split "1","2","on my shoe","3","4","on,the,3th,door" # only the first string gets split
-split "on,the,door" # won't work no spaces
-split "on my shoe"

# Using the binary split operator :
"1","2","on my shoe","3","4","on,the,3th,door" -split ","
"1","2","on my shoe","3","4","on,the,3th,door" -split "\d" # Regex split on digits

# Using the unary join operator :
-join "1","2","on my shoe","3","4","on,the,3th,door" # Again only the first string
-join ("1","2","on my shoe","3","4","on,the,3th,door")

# Using the binary join operator :
"1","2","on my shoe","3","4","on,the,3th,door" -join "&"
"1","2","on my shoe","3","4","on,the,3th,door" -join [char]1337

# Using Replace operator:
"1","2","on my shoe","3","4","on,the,3th,door" -replace "," # works on every object not specifying the replace with just removes the found match
"1","2","on my shoe","3","4","on,the,3th,door" -replace "\d","{this_was_a_digit}" # regex replace
"1","2","on my shoe","3","4","on,the,3th,door" -replace "[mh]","?" # regex replace
#endregion

#region slide 156
# Formatting with numbers:
"If you borrow {0:c2}`
, and the exchange rate is {1:p1}`
, you have to pay {2:n2} Euro"`
 -f 11.3387,0.15234567,13.06558401

# More digits: Add a thousand separator and decimal point
"{0:#,#.####}" -f 836482.837298563298

# Formatting with time:
"{0:dd}-{0:MM}-{0:yyyy}" -f (get-date)
#region
