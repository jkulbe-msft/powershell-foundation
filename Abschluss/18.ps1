function Get-SmallFile
{
<#
.Synopsis
   Finds small files in a specified folder
.DESCRIPTION
   This function finds files smaller than a specific size in a specified folder.
   You'll get a few statistics on every folder examined.
   You may enter the folder path directly or through the pipeline (see Get-Help).
   Inaccessible folders are skipped without notification.
.PARAMETER Path
   The folder path you want to examine.
.PARAMETER FullName
   An alias for the parameter Path. Introduced so ValueFromPipelineByProperty works.
.PARAMETER MaxSize
    The maximum file size in byte to examine. The functions ignores files larger than that size.
.EXAMPLE
   Get-SmallFile -MaxSize 100000 -Path C:\Windows
.EXAMPLE
   'C:\Windows' | Get-SmallFile -MaxSize 100000
.EXAMPLE
   Get-Item -Path C:\Windows | Get-SmallFile -MaxSize 100000
.EXAMPLE
   Get-ChildItem -Directory -Path C:\Windows | Get-SmallFile -MaxSize 100000
.NOTES
   Thanks to all participants of the "PowerShell Foundation Skills" class.
#>
    [CmdletBinding()]
    param(
    [Parameter(ValueFromPipeline=$true,
               ValueFromPipelineByPropertyName=$true)]
    [Alias("FullName")]
    [string]$Path,

    [int]$MaxSize)

    BEGIN {
           $Today = Get-Date
    }

    PROCESS {
       # -lt should have been -le :-)
        $MeasuredFiles = Get-ChildItem -Path $Path -File -ErrorAction SilentlyContinue |
            Where-Object -FilterScript { $_.Length -le $MaxSize } |
            Measure-Object -Property Length -Sum -Average

        [pscustomobject]@{
        'Path' = $Path
        'MaxSize' = $MaxSize
        'FileSizeSum' = $MeasuredFiles.Sum
        # the rounding wasn't mathematically correct
        'FileSizeAvg' = [math]::Round($MeasuredFiles.Average, 1, [System.MidpointRounding]::AwayFromZero)
        'Date' = $Today
        'DaysUntilChristmas' = ((Get-Date -Month 12 -Day 24) - $Today).Days
        'GUID' = [guid]::NewGuid()
        }
    }
}

Get-ChildItem -Directory -Path C:\Windows | Get-SmallFile -MaxSize 100000 | Format-Table