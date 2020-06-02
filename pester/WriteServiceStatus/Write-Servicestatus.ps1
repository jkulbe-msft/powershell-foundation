function Write-Servicestatus {
    param (
        $OutFile
    )
     Get-Service | Select-Object -Property Name,Status | Export-Csv $OutFile -NoTypeInformation -Force
}
