#region slide 13 general help
Get-Help -Name Get-Command
Get-Help -Name Get-Command -Examples
Get-Help -Name Get-Command -Detailed
Get-Help -Name Get-Command -Full
Get-Help -Name Get-Command -Online
Get-Help -Name Get-Command -ShowWindow
Get-Help -Name Get-Command -Parameter syntax
#endregion

#region slide 20 Get-Help
# in ISE
get-help about_ # then F1 on result
# in CLI
Get-Help 'about_Split' -ShowWindow
#endregion

#region slide 38 comment based help
#from a function
cd 'C:\temp'
. .\get-dc-V1.3.ps1
Get-Help Get-DC -Full

#from a script
cd 'C:\temp'
Get-Help .\DMARCv2.3\Create-DMARCreport.ps1 -ShowWindow
#endregion