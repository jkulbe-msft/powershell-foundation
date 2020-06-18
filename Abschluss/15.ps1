function Get-SmallFile
{
    [CmdletBinding()]
    param(
    [Parameter(ValueFromPipeline=$true,
    ValueFromPipelineByPropertyName=$true)]
    [Alias("FullName")]
    [string]$Path,
    $MaxSize)

    BEGIN {
        $Today = Get-Date
    }

    PROCESS{
        $MeasuredFiles = Get-ChildItem -Path $Path -File |
            Where-Object -FilterScript { $_.Length -lt $MaxSize } |
            Measure-Object -Property Length -Sum -Average

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
}

Get-Item -Path C:\Windows | Get-SmallFile -MaxSize 100000

# die alten Varianten sollen immer noch gehen

# Get-SmallFile -MaxSize 100000 -Path C:\Windows
# 'C:\Windows' | Get-SmallFile -MaxSize 100000