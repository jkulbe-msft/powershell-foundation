#region slide 11 script blocks
$scriptblock = {Write-output -inputobject "This output comes from a scriptblock"}
Get-command -ParameterType scriptblock

Set-PSReadlineKeyHandler -Chord Shift+Ctrl+B -ScriptBlock $scriptblock
Get-PSReadLineKeyHandler
#endregion

#region slide 18 functions
# simple
function run-simplefunction
{
    write-output "A function in its most simple form"
}
# full
Function run-fullfunction
{
    <#
    .SYNOPSIS
        Template Version 0.1
    .DESCRIPTION
        Template Version 0.1 for powershell scripts
    .EXAMPLE
        .\Filename.ps1 -Param1

        Example Discription
    .EXAMPLE
        .\Filename.ps1 -Param1 -Param2

        Example 2 Discription 2
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        Output from this cmdlet (if any)
    .NOTES
        -----------------------------------------------------------------------------------------------------------------------------------
        Function name : asamplefunction
        Authors       : Martijn (Scriptkiddie) van Geffen
        Version       : 0.1
        dependancies  : None
        -----------------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------------------------------------------
        Version Changes:
        Date: (dd-MM-YYYY)    Version:     Changed By:           Info:
        05-01-2017            V0.1         Martijn van Geffen    Initial script
        -----------------------------------------------------------------------------------------------------------------------------------
    .COMPONENT
        The component this cmdlet belongs to
    .ROLE
        The role this cmdlet belongs to
    .FUNCTIONALITY
        The functionality that best describes this cmdlet
    #>

    [CmdletBinding(DefaultParameterSetName='Parameter Set 1',
                PositionalBinding=$false,
                HelpUri = 'http://www.microsoft.com/',
                ConfirmImpact='Medium')]
    [OutputType([String])]

    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true,
                    ValueFromRemainingArguments=$false,
                    Position=0,
                    ParameterSetName='Parameter Set 1')]
        [ValidateNotNullOrEmpty()]
        [ValidateSet("demo1", "demo2", "demo3")]
        [Alias("input")]
        [string]$Param1

    )

    write-output "A $Param1 function in its most simple form"
}
#endregion

#region slide 26 native OS remoting
# Show all commands that support native OS remoting:
Get-Command -ParameterName ComputerName

Test-connection -computer dc
#endregion

#region slide 36 Powershell remoting

# Show the remote listener sessions:
Get-PSSessionConfiguration

# Create new persistent sessions:
$sessions = New-PSSession -ComputerName DC, MS
Invoke-Command -Session $sessions -ScriptBlock {$hostname = (get-wmiobject win32_computersystem).name ;"Hello world from $hostname"}
#endregion

#region slide 46 providers and drives
Get-PSDrive

cd cert:
Get-ChildItem
cd currentuser
Get-ChildItem
cd TrustedPublisher
Get-Childitem

cd HKcu:
Get-ChildItem
#endregion

#region slide 52 PS drives

#Create a new PS drive for the registry:
New-PSDrive -Name Regclasses -PSProvider Registry -Root HKEY_CLASSES_ROOT
#Create a new PS drive for a folder on c:
New-PSDrive -Name Z -PSProvider FileSystem -Root c:\windows\system32

#Removing the drives again:
Remove-PSDrive -Name Z
Remove-PSDrive -Name Regclasses

#endregion

#region slide 63 itemproperty
# The difference between item and properties when browsing datastores:
Cd "hklm:\SOFTWARE\Microsoft\FilePicker"
#   followed by DIR    -> No output
Get-ChildItem -path "hklm:\SOFTWARE\Microsoft\FilePicker"
#   -> No output
Get-item
#   -> while in the location still prompts for name
Get-ItemProperty -Path "hklm:\SOFTWARE\Microsoft\FilePicker"
#     -> should work
Get-ItemPropertyvalue -Path "hklm:\SOFTWARE\Microsoft\FilePicker" -Name "AsyncWindowBehaviorDisabled"
#      -> should work but only displays 1 value or the "name" parameter must be used with multiple values
Get-item -Path  "hklm:\SOFTWARE\Microsoft\FilePicker"
#   -> should work  displays most data

# Working with properties:
new-item -Path HKCU:\ -Name Powershell
New-ItemProperty -Path HKCU:\Powershell  -Name registry1 -Value "NCC-1701"
New-ItemProperty -Path HKCU:\Powershell  -Name registry2 -Value "NCC-74656"
set-ItemProperty -Path HKCU:\Powershell  -Name registry1 -Value "NCC-1701-D"
Rename-ItemProperty -Path HKCU:\Powershell -Name registry1 -NewName Ship1
Rename-ItemProperty -Path HKCU:\Powershell -Name registry2 -NewName Ship2
new-item -Path HKCU:\ -Name "Intrepid"
new-item -Path HKCU:\ -Name "Galaxy"
Copy-ItemProperty -Path HKCU:\Powershell -Destination HKCU:\Intrepid -Name Ship2
Move-ItemProperty -Path HKCU:\Powershell -Destination HKCU:\Galaxy -name Ship1
Remove-ItemProperty -Path HKCU:\Galaxy -Name Ship1
Remove-Item -Path HKCU:\Galaxy
Remove-Item -Path HKCU:\Intrepid

#endregion

#region slide 67 content
Get-Date | Set-Content -path "c:\temp\date.csv"
"This was today" | add-Content -path "c:\temp\date.csv"
Get-Content -path "c:\temp\date.csv"
Clear-Content -path "c:\temp\date.csv"
Get-Content -path "c:\temp\date.csv"
#endregion

#region slide 74 path

$systemfolder = "\system32\\"
$windows = "c:\windows\"
($windows+$systemfolder)

# The command Test-path & Join-path:
Test-Path -path ($windows+$systemfolder)
Join-Path -Path $windows -ChildPath $systemfolder -Resolve

# The command split-path:
Split-Path -path ($windows+$systemfolder) -Parent
Split-Path -path ($windows+$systemfolder) -Leaf

#endregion

#region slide 82 scripts
# https://gallery.technet.microsoft.com/Copy-logs-from-a-set-of-f00ce645

# grab all exe files from the windows dir on remote hosts and copy them to the local host:
cd 'C:\temp'
.\copylogs.ps1 -servers "localhost" -uncpath "\c$\windows\*" -include "*.exe"
#endregion

#region slide 90 executionpolicy
# Display current policy:
Get-ExecutionPolicy -List

# Set policy to restricted:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
# Try to run the script from the previous demo

# Set policy to unrestricted:
Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
# Try to run the script from the previous demo

#endregion

#region  slide 96 starting scripts
# Start script with full path:
C:\temp\copylogs.ps1

# Start script dot notation from current path
.\copylogs.ps1

# Using Invoke command
& "C:\temp\copylogs.ps1"

# Using start-process
Start-Process powershell -ArgumentList "C:\temp\copylogs.ps1"

# Using the mouse
# Right click the script and select run with PowerShell

#endregion

#region slide 101
# create certificate
makecert -n "CN=MyRoot" -a sha1 -eku 1.3.6.1.5.5.7.3.3 -r -sv root.pvk root.cer -ss Root -sr localMachine
makecert -pe -n "CN=MyCertificate" -ss MY -a sha1 -eku 1.3.6.1.5.5.7.3.3 -iv root.pvk -c root.cer
gci cert:\CurrentUser\My -codesigning

# sign script
$cert = @(gci cert:\currentuser\my -codesigning)[0]
Set-AuthenticodeSignature myscript.ps1 $cert
#endregion

#region slide 113 param and requires statements
# param block see copylogs.ps1 script
# enter requires statement at the top, then rerun the script as non-admin
#Requires -RunAsAdministrator


#endregion