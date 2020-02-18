function Get-SmallFile
{
    [CmdletBinding()]
    param(
    [Parameter(ValueFromPipeline=$true)]
    $Path,

    $MaxSize)

    $MeasuredFiles = Get-ChildItem -Path $path -File |
        Where-Object -FilterScript { $_.Length -lt $MaxSize } |
        Measure-Object -Property Length -Sum -Average

    $Today = Get-Date

    [pscustomobject]@{
    'Path' = $Path
    'MaxSize' = $MaxSize
    'FileSizeSum' = $MeasuredFiles.Sum
    'FileSizeAvg' = [math]::Round($MeasuredFiles.Average, 1)
    'Date' = $Today
    'DaysUntilChristmas' = ((Get-Date -Month 12 -Day 24) - $Today).Days
    'GUID' = [guid]::NewGuid()
    }
}

'C:\Windows' | Get-SmallFile -MaxSize 100000

get-help get-smallfile -ShowWindow