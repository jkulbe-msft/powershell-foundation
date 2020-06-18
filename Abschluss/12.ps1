function Get-SmallFile
{
    param($Path, $MaxSize)

    $MeasuredFiles = Get-ChildItem -Path $path -File |
        Where-Object -FilterScript { $_.Length -lt $MaxSize } |
        Measure-Object -Property Length -Sum -Average

    $Today = Get-Date

    [pscustomobject]@{
    'Path' = $Path
    'MaxSize' = $MaxSize
    'FileSizeSum' = $MeasuredFiles.Sum
    'FileSizeAvg' = [math]::Round($MeasuredFiles.Average, 1, [System.MidpointRounding]::AwayFromZero)
    'Date' = $Today
    'DaysUntilChristmas' = ((Get-Date -Month 12 -Day 24) - $Today).Days
    'GUID' = [guid]::NewGuid()
    }
}

Get-SmallFile -Path C:\Windows -MaxSize 100000