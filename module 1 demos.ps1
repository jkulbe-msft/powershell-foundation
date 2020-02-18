#region slide 19 PS Readline
Get-Process -Name "PowerShell"
Get-PSReadLineKeyHandler
# open 2nd shell, show command history, CTRL+Z to undo
Get-Pro # -> Ctrl+Space
Get-Process # -> then Ctrl+Space
Get-History - # -> then Ctrl+Space

Get-history
Invoke-history -id 1
r 1 # short version
#endregion

#region slide 38 ISE features
New-IseSnippet -Title "Hello World" -Description "A simple Hello World snippet" -Text 'Write-Host "Hello World!"' -CaretOffset 12 -Force
Get-IseSnippet
#endregion

#region slide 58 Get-Command
Get-Command -Verb Invoke # based on verb
Get-Command -Noun Service 
Get-Command -Name *et*net* # wildcard
Get-Command -Module Az # based on module
Get-Command -CommandType Application # external commands, functions

Show-command
Show-command -Name Get-Command
#endregion

#region slide 71 Cmdlet syntax
Get-ChildItem
Get-ChildItem -Path C:\Windows -Filter *.exe # cmdlet, parameter, argument
Get-ChildItem -Path C:\Windows -Filter *.exe -Recurse # switch parameter
#endregion

#region slide 74 Parameter sets, positional vs. named parameters
Get-Command -Name Get-Command -Syntax
Get-Command -Name Get-Service -Syntax

Get-Service # no parameters
Get-Service -ComputerName localhostù,ùlocalhost # optional, can be multiple strings
Get-Service -DependentServices # optional, switch
 
Get-Command Get-Service -Syntax # look at last parameter set
Get-Service -InputObject "" # -dis <TAB> does not work. Intellisense knows about sets.
#endregion

#region slide 83 common parameters
function show-demo
{
    [CmdletBinding()]
    param()
    $divider = 0
    Write-output -InputObject "This is default text - You just entered the function"
    Write-Verbose -Message "You enabled the verbose stream, starting a divide operation"
    Write-debug -Message "You enabled the debug stream - trying to divide by $divider"
    10/$divider  
}

show-demo
show-demo -verbose
show-demo -debug
show-demo -verbose -debug 

show-demo -ErrorAction SilentlyContinue 
show-demo -ErrorAction Continue 
#endregion

#region slide 87 risk mitigation
Get-service | stop-service -whatif
get-service -name (Read-Host -Prompt "What service should stop:") | stop-service -whatif 
Get-service | stop-service -confirm
#endregion

#region slide 95 command termination
Get-service ; get-process; get-childitem
"
This is line
Con
Tin
Uation
"
#endregion

#region slide 101 built-in aliases
Get-Alias
Get-Alias -Definition Get-ChildItem
#endregion

#region slide 107 user defined aliases
New-Alias -Name GS -Value Get-Service
GS
gsv | % {spsv $_ -wi} # please don't do this in scripts
#endregion