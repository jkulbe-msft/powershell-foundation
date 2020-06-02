Function Restart-SpecificComputer {
    <#
    .Synopsis
       Restart specified computers.
    .DESCRIPTION
       Function to restart a specific individual or list of computers. 
    .EXAMPLE
       Restart-SpecificComputer -ComputerNeeded localhost
       This will restart the localhost.
    .EXAMPLE
       Restart-SpecificComputer -ComputerNeeded RemotePC
       This will restart the 'RemotePC' computer. 
    .NOTES
       Version 1.0
    #>
        [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
        Param ($ComputerNeeded)
    
        {
            if ($pscmdlet.ShouldProcess("$ComputerNeeded", "restarting computer"))
            {
                    Restart-Computer $ComputerNeeded
            }
        }
    }