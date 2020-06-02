

Function Get-DiskUsage {
    $diskUsage = ((df) -split "`n") -notmatch "FileSystem"
    $pattern = "(?<FileSystem>.+)\s+(?<Blocks>\d{1,})\s+(?<Used>\d{1,})\s+(?<Available>\d{1,})\s+(?<Percentage>\d{1,}%)\s(?<MountPoint>.+)"
    $outputArray = @()
    foreach ($line in $diskUsage.Split("`n")) {
        $line -match $pattern | Out-Null
        $obj = [PSCustomObject]@{
            FileSystem = $Matches.FileSystem
            Block      = $Matches.Blocks / 1KB
            Used       = $Matches.Used / 1KB
            Available  = $Matches.Available / 1KB
            Percentage = $Matches.Percentage
            MountPoint = $Matches.MountPoint
        }
        $outputArray += $obj
    }
    $outputArray
}

Get-DiskUsage | Format-Table
