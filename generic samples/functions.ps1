#region simple function
function run-simplefunction
{
    write-output "A function in its most simple form"
}
#endregion

#region more advanced funtion

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
    [Alias(asf)]
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
        [ValidateSet("demo1", "demo3", "demo3")]
        [Alias("input")]
        [string]$Param1

    )

    write-output "A $Param1 function in its most simple form"
}


#region output as PSObject

$Services = Get-Service
foreach ($service in $services)
{[pscustomobject]@{
    'ComputerName' = $env:computername
    'ServiceName' = $Service.name
    'NumberofDependentServices' = $Service.DependentServices.count
    'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10) }
}
# $object = New-Object –TypeName PSObject –Property $props
# Write-Output $object}
#| Export-Csv -Path $resultfile -NoTypeInformation -Encoding UTF8

# do-something
#function
function Do-Something {
    param(
        $something
    )

    $Services = Get-Service
    $now = Get-Date
    foreach ($service in $services)
    {
        [pscustomobject]@{
        'ComputerName' = $env:computername
        'ServiceName' = $Service.name
        'NumberofDependentServices' = $Service.DependentServices.count
        'Date' = $now
        'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10)
        'Something' = $something }
    }
}

# with cmdletbinding

#function
function Do-Something {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $Something
    )

    $Services = Get-Service
    $now = Get-Date
    foreach ($service in $services)
    {
        [pscustomobject]@{
        'ComputerName' = $env:computername
        'ServiceName' = $Service.name
        'NumberofDependentServices' = $Service.DependentServices.count
        'Date' = $now
        'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10)
        'Something' = $something }
    }
}
#endregion

#region PSBoundParameters
# https://powershell-guru.com/powershell-best-practice-19-check-parameters-with-psboundparameters/
function Get-Something
{
  Param
  (
       [switch]$Verbose
  )
   # Bad
   if ($Verbose)
   { Do-Something }
   # Good (Alternative 1)
   if ($PSBoundParameters['Verbose'])
   { Do-Something }
   # Good (Alternative 2)
   if ($PSBoundParameters.ContainsKey('Verbose'))
   { Do-Something }
   # Good (Alternative 3)
    switch ($PSBoundParameters.Keys)
   {
        'Verbose' { Do-Something }
   }
}
#endregion