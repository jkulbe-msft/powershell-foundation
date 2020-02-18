function Do-Something {
    # hier fehlt noch die kommentarbasierte Hilfe :-)

    # CmdletBinding ist die u.a. Voraussetzung für Pipeline-Eingaben
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
        # für jeden einzelnen Dienst wird ein Objekt ausgegeben
        [pscustomobject]@{
        'ComputerName' = $env:computername
        'ServiceName' = $Service.name
        'NumberofDependentServices' = $Service.DependentServices.count
        'Date' = $now
        'LuckyNumber' = (Get-Random -Minimum 1 -Maximum 10)
        'Something' = $something }
    }
}