#1
#$start = nslookup -q=TXT cluedo.13thdivision.nl 1.1.1.1
$start = Resolve-DnsName -Name "cluedo.13thdivision.nl" -Type TXT
$start

#2
$rules = 1..5 | ForEach-Object { (Resolve-DnsName -Name "rule$_.cluedo.13thdivision.nl" -Type TXT).strings }
$rules

#3
(Resolve-DnsName -Name start.cluedo.13thdivision.nl -Type TXT).strings
#4
function Show-CluedoRule {
    1..5 | ForEach-Object { (Resolve-DnsName -Name "rule$_.cluedo.13thdivision.nl" -Type TXT).strings }
}
Show-CluedoRule

function Show-CluedoRecord {
    <#
.SYNOPSIS
    displays a TXT record belonging to the Cluedo Powershell game
.DESCRIPTION
    displays a TXT record belonging to the Cluedo Powershell game at cluedo.13thdivision.nl
.EXAMPLE
    Another example of how to use this cmdlet
#>
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string]
        $Record
    )

    process {
            (Resolve-DnsName -Name "$record.cluedo.13thdivision.nl" -Type TXT).strings
    }
}

$rooms = Show-CluedoRecord -Record rooms
"These are the rooms: $rooms"
$rooms | ForEach-Object -Begin { $hints=@{} } -Process { $hints.Add($_,$(Show-CluedoRecord -Record $_)) }
$hints | Format-List

$clues = @{}
$temp = [int[]]$((22,33,44,12 | Measure-Object -Sum).sum)
$temp += $temp[0]
$clues.Add('Kitchen',$temp)
Clear-Variable temp

$hints.masterbedroom -match '(\d{3})\?(\d{3})\?(\d{3})'
$Matches.Remove(0)
$clues.Add('Masterbedroom',$($Matches.Values | Sort-Object -Descending))

$crime = @{ Murderscene = 'Bathroom'}

$clues.Add('Toilet',107)
($hints.toilet -match '.+\?(\w+\?\w+\?\w+)') 
$PotentialMurderweapons = $Matches[1] -split '\?' 
$PotentialMurderweapons | ForEach-Object { 
        "$_`: $(Show-CluedoRecord -Record "$_.toilet")"
        }
if(($PotentialMurderweapons[0]).Length -eq 10 ) { $crime.Add('Murderweapon',$($PotentialMurderweapons[0])) }
if(($PotentialMurderweapons[1]).Length -eq 11 ) { $crime.Add('Murderweapon',$($PotentialMurderweapons[1])) }
if((($PotentialMurderweapons[2] | Measure-Object -Character).characters) -eq 9 ) { $crime.Add('Murderweapon',$($PotentialMurderweapons[2])) }

$WebClient = New-Object System.Net.WebClient
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
$temp = $WebClient.DownloadString('https://clue.livingroom.cluedo.13thdivision.nl/wp-content/cluedo/clue.html')
$pattern = [regex]::new('\d{2}')
$Clues.Add('LivingRoom',$pattern.Matches($temp).value)

# add toilet number for bathroom clue
$temp = ($rooms | Sort-Object -Descending)[1..3] | foreach-object { $clues.$_ }
$temp += $clues.Toilet
$crime.add('Murderer',$(($temp | foreach {[char][int]$_}) -join ''))

$crime