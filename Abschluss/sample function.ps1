function Do-Something {
    # insert some proper comment based help here :-)
    # about_Comment_Based_Help

    # CmdletBinding is a prerequisite for pipeline input and other nice things
    # about_Functions_Advanced 
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true)]
        $Something
    )
    # the BEGIN section runs once no matter how many objects are on the pipeline
    BEGIN {
            $now = Get-Date
    }
    # the begin/process/end blocks are technically not required unless you pipe in more than one object
    # see  about_functions_advanced_methods, section "process"
    PROCESS {
        $Services = Get-Service

        foreach ($service in $services)
        {
            # return one object for every service
            [pscustomobject]@{
            'ComputerName' = $env:computername
            'ServiceName' = $Service.name
            'NumberofDependentServices' = $Service.DependentServices.count
            'Date' = $now
            'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10)
            'Something' = $something }
        }
    }
    # the END section runs once at the end no matter how many objects are passed in on the pipeline  
    END {
        # nothing here
    }
}