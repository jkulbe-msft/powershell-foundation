#region slide 13 while loops
# forever loop
While ($true)
{
    Write-Host -ForegroundColor Yellow "Still True"
}
# Using a while loop that will never start:
While ($false)
{
    Write-Host -ForegroundColor Red "Never Run"
}
# waiting until a condition is met 
While (!(Test-Connection fakeserver -ErrorAction SilentlyContinue -count 1))
{
    Write-Host "Server still not Online!" -ForegroundColor Green
} 

# While loop with iteration:
# set up a counter variable first
$i = 0 
# While Statement followed by a Test that evaluates to True/False (Zero/Non-Zero).
While($i -lt 10)
{
    # Write our counter value to the screen.
    $i
    # Increment our Counter.
    $i++
} 
#endregion

#region slide 19 do while
# Even if the while statement fails the code will run once:
Do 
{
    Write-Host -ForegroundColor White "Your code will always run AT LEAST once."
} While ($false) 

# The Do-Until loop reverses the logic but still runs at least once:
Do 
{
    Write-Host -ForegroundColor Yellow "You won't have to Ctrl+C this because it will only run once."
} Until ($true) 
#endregion

#region slide 29 for and foreach
For($i = 0; $i -lt 10; $i++)
{
    # Write out counter to the screen
    $i
} 

# A simple foreach loop:
Foreach ($service in Get-Service)
{
    Write-Output -InputObject $service.name
} 

# Difference in speed between for and foreach with big arrays of data:
# With 1000 iterations "for" is slightly slower:
$array = 1..1000

write-output -InputObject "for time:"
(measure-command {
    For ($i=0 ; $i -lt $array.count ; $i++)
    {
        "Object $($i): value $($array[$i])"
    } 
}).TotalMilliseconds

write-output -InputObject "foreach time:"
(measure-command {
    foreach ($object in $array)
    {
        "Object $($array.IndexOf($object)) : value $object"
    }
}).TotalMilliseconds 

# With 10000 iterations for is really faster
$array = 1..10000

write-output -InputObject "for time:"
(measure-command {
    For ($i=0 ; $i -lt $array.count ; $i++)
    {
        "Object $($i): value $($array[$i])"
    } 
}).TotalMilliseconds

write-output -InputObject "foreach time:"
(measure-command {
    foreach ($object in $array)
    {
        "Object $($array.IndexOf($object)) : value $object"
    }
}).TotalMilliseconds 
#endregion

#region slide 39 if
If ($True) { Write-Host -ForegroundColor Green "SUCCESS!" }
If ($False) { Write-Host -ForegroundColor Green "SUCCESS!" }
If ($Null) { Write-Host -ForegroundColor Green "SUCCESS!" }
If (0) { Write-Host -ForegroundColor Green "SUCCESS!" }
If (5) { Write-Host -ForegroundColor Green "SUCCESS!" }
If ([void]5) { Write-Host -ForegroundColor Green "SUCCESS!" }
If (get-service) { Write-Host -ForegroundColor Green "SUCCESS!" } 

# Multiple IF statements:
$date = Get-Date
If (($date.DayOfWeek -eq "Sunday") -or ($date.DayOfWeek -eq "Saturday"))
{
    Write-Host -ForegroundColor Green "It's the WEEKEND!"
}
ElseIf ($date.DayOfWeek -eq "Monday")
{
    Write-Host -ForegroundColor Red "Oh No! Not Monday Again!"
}
ElseIf ($date.DayOfWeek -eq "Tuesday")
{
    Write-Host -ForegroundColor Yellow "Tuesday: At least it's not MONDAY!"
}
ElseIf ($date.DayOfWeek -eq "Wednesday")
{
    Write-Host -ForegroundColor Magenta "Halfway There!"
}
ElseIf ($date.DayOfWeek -eq "Thursday")
{
    Write-Host -ForegroundColor Cyan "One more Day!"
}
ElseIf ($date.DayOfWeek -eq "Friday")
{
    Write-Host -ForegroundColor Green "FFFFFFFRRRRRRRRRIIIIIIIDDDDDDDAAAAAAAYYYYYYY!"
} 

# A practical sample combined with the pipeline:
Get-Service |  select -First 15 | ForEach-Object `
{
    if ($_.StartType -eq "Automatic")
    {
        Write-Host -ForegroundColor Green "$($_.DisplayName) Starts Automatically"
    }
    ElseIf ($_.StartType -eq "Manual")
    {
        Write-Host -ForegroundColor Yellow "$($_.DisplayName) is Manually Started"
    }
    ElseIf ($_.StartType -eq "Disabled")
    {
        Write-Host -ForegroundColor Gray "$($_.DisplayName) is Disabled"
    }
} 

# Nested IF statements:
if ((Get-Date).Year -ge "2017")
{
    if ((Get-Date).DayOfWeek.ToString() -ne "Sunday")
    {
        if ((Get-Date).TimeOfDay -gt 0)
        {
            Write-Host "Hooray!"
        }    
    }
} 
#endregion

#region slide 46 switch
# Basic switch vs. If Else:
Switch($color)
{
    <# If ($color -eq "Cyan") #> 
                      "Cyan" {Write-Host "Cyan!" -ForegroundColor Cyan}
    <# If ($color -eq "Green") #> 
                      "Green" {Write-Host "Green" -ForegroundColor Green}
    # The Default Case is your Else statement which only executes if ALL other statements are false.
    <# if ($runcatch -eq $true -and $runcatch2 -eq $true) #> 
       Default {write-host "This will run instead" -ForegroundColor Green} 
}

# The exact equivalent while using if statements:
$runcatch = $false
$runcatch2 = $false
If ($color -eq "Cyan")
{
    Write-Host "Cyan!" -ForegroundColor Cyan
} else
{
    $runcatch = $true
}
If ($color -eq "Green")
{
    Write-Host "Green" -ForegroundColor Green
} else
{
    $runcatch2 = $true
}
if ($runcatch -eq $true -and $runcatch2 -eq $true)
{
    write-host "This will run instead" -ForegroundColor Green
} 

# A Switch will run all code blocks that pass the test:
$input = "One"
Switch ($input)
{
      "One" { Write-Host "$_" }
      "One" { Write-Host "$_" }
      "Two" { Write-Host "$_" } 
    "Three" { Write-Host "$_" }
      "One" { Write-Host "$_" }
} 
#endregion

#region slide 58 advanced switch
# wildcard
Switch -wildcard (Read-Host "What's your favorite Season?")
{
    "Fall" { Write-Host -ForegroundColor DarkYellow "$_" }
    "Winter" { Write-Host -ForegroundColor White "$_" }
    "Summer" { Write-Host -ForegroundColor Yellow "$_" }
    "Spring" { Write-Host -ForegroundColor Green "$_" }
    "*r*"    { Write-Host -ForegroundColor Magenta "There is a R in the season: $_" }
    Default  { Write-Error "The Season ($_) does not exist!" }
} 

# Switching an array with statements:
$files = Get-ChildItem -Recurse -Path C:\Windows\System32 -ErrorAction SilentlyContinue | select -first 350 -skip 150
Switch ($files)
{
    { $_.length -gt 1MB } { Write-Host -ForegroundColor DarkCyan "$($_.fullname) is greater than 1MB" }
    { $_.extension -eq ".exe" } { Write-Host -ForegroundColor Red "$($_.fullname) is an executable" }
    { $_.LastAccessTime -lt (Get-Date).AddYears(-1) } { Write-Host -ForegroundColor Yellow "$($_.fullname) hasn't been accessed in a year." }
    { $_.Attributes -match  "Directory" } { Write-Host -ForegroundColor Green "$($_.fullname) is a Directory" }
} 
#endregion

#region slide 64 flow control
# break
$array = "One", "Two", "Three"
Switch ($array)
{
      "One" { 
                Write-Host "$_" 
                Break
            }
      "Two" { 
                Write-Host "$_" 
                Break
            } 
    "Three" { 
                Write-Host "$_" 
                Break
            }
} 

# How continue only breaks the current iteration:
$array = "One", "Two", "Three"
Switch ($array)
{
      "One" { 
                Write-Host "$_" 
                Continue
            }
      "One" { 
                Write-Host "$_" 
                Continue
            }
      "Two" { 
                Write-Host "$_" 
                Continue
            } 
    "Three" { 
                Write-Host "$_" 
                Continue
            }
} 
#endregion

#region slide 71 creating arrays
# using @()
$array = @()
$array.gettype()
$array

# from multiple items
$array2 = "test","shoe",(Get-Partition),"54321"
$array2.gettype()
$array2

# from a command that returns a array
$array3 = get-service | Select-Object -First 5
$array3.gettype()
$array3

# Casting a result into an array
$array4 = get-service | Select-Object -First 1
$array4.gettype()
$array4

[array]$array5 = get-service | Select-Object -First 1
$array5.gettype()
$array5 
#endregion

#region slide 76
$array = (1..20)

# indexing into arrays
$array[1]
$array[1,2]
$array[-1]
$array[-1,-5]
$array[5..7]

# batched indexing in arrays:
$first = 0
$second = 4
$batchsize = 5
do
{
    Write-host -Object "new batch"
    $array[$first..$second]
    $first += $batchsize
    $second += $batchsize
}while ($first -lt $array.count) 
#endregion


#region slide 81 adding to arrays
# can't add an item to an array as it is fixed size!
$array = @()
$array.add("test") # error

# to add to an array you need to recreate the array
$array = @()
$array += "test"
$array += "ok"
$array += Get-PhysicalDisk
$array 

$a = @()
$a += 'test' # slow

$a = New-Object System.Collections.ArrayList
$a.Add('test') # faster

# Changing object items in an array
$array[0] = "New value"
$array.set(1,"Methode new value")
$array
#endregion

#region slide 97 hash tables
$hash = @{}
$Hash = @{Type='Pipe' ; Material='Copper' ; shape='Round' ; Size='Big'}   
$Hash

# Creating a Hash table, using ConvertFrom-StringData: (do this multiple times note the order is random)
$string = @"
Name = Waldo
Favorite game = Hide and seek
Shirt color = Red
Glasses = Yes
Gender = male
Favorite Quote = Where is waldo
1 = the number one 
"@ 
$waldo = ConvertFrom-StringData -StringData $string 
$waldo 

# Create a hash table using group object with the parameter "-ashashtable":
$Process_as_hashtable = Get-Process | Group-Object ProcessName -AsHashTable -AsString 
$Process_as_hashtable 
$Process_as_hashtable.svchost 
#endregion

#region slide 103 accesing hash tables
# using the previous Hash table $waldo 
# using array range index does not work
$waldo[2] # no output
$waldo[2..3] # no output

# referencing the keys 
$waldo.gender
$waldo["name"]
$waldo["1"] # Note 1 is a string

# View all keys of a hash table:
$waldo.Keys 

# View all values of a hash table:
$waldo.values 
#endregion

#region slide 108 modifying hash tables
# Adding a key value pair to a new hash table
$myhouse = @{}
$myhouse["hasadoor"] = $true
$myhouse.hasawindow = $false
$myhouse.Add("hasagarage",$false)
$myhouse

# Changing a value in a hashtable:
$myhouse.hasawindow = "i do hope so"
$myhouse["hasadoor"] = "Do you want me to climb thru the window??"
$myhouse

# Removing keys from a hash table:
$myhouse.remove("hasagarage")
$myhouse 
#endregion

#region slide 112 
# Adding a key value pair happens unorderd nor sorted:
$myhouse = @{}
$myhouse["hasadoor"] = $true
$myhouse.hasawindow = $false
$myhouse.Add("hasagarage",$false)
$myhouse["hasadoor1"] = $true
$myhouse.hasawindow1 = $false
$myhouse.Add("hasagarage1",$false)
$myhouse["hasadoor2"] = $true
$myhouse.hasawindow2 = $false
$myhouse.Add("hasagarage2",$false)
$myhouse # compare to order above

# Sorting the table only works if you use the enumeration method:
$myhouse | Sort-Object -Property name
$myhouse.keys | Sort-Object # the result is just a KeyCollection so you can`t see the value anymore.

$myhouse.GetEnumerator() | Sort-Object -Property name # sorts output only, hashtable remains the same

# If you want to keep the order when you add keys/values you need to declare it as ordered:
$myhouse = [ordered]@{}
$myhouse["hasadoor"] = $true
$myhouse.hasawindow = $false
$myhouse.Add("hasagarage",$false)
$myhouse["hasadoor1"] = $true
$myhouse.hasawindow1 = $false
$myhouse.Add("hasagarage1",$false)
$myhouse["hasadoor2"] = $true
$myhouse.hasawindow2 = $false
$myhouse.Add("hasagarage2",$false)
$myhouse 
#endregion

#region slide 120 hash table
# custom table using a hash table as the format for file size in KB or MB:
Get-ChildItem C:\Windows -File | Select-Object Name, @{Name="Size (kb)";Expression={($_.Length/1Kb)}} | Sort-Object -Property "Size (kb)" -Descending
Get-ChildItem C:\Windows -File | Select-Object Name, @{Name="Size (mb)";Expression={($_.Length/1mb)}} | Sort-Object -Property "Size (mb)" -Descending


# custom table using a hash table as the format for file size in MB and see the creation day instead of full date:
Get-ChildItem C:\Windows\System32\WindowsPowerShell -Recurse -File | Select-Object Name, @{Name="Size (mb)";Expression={($_.Length/1mb)}},@{Name="creation Day";Expression={($_.CreationTime.ToString("MM-dd-yyyy"))}} | Sort-Object -Property "Size (mb)" -Descending

#endregion