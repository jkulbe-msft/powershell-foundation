function Get-SmallFile
{
    param($Path, $MaxSize)

    $MeasuredFiles = Get-ChildItem -Path $path -File | 
        Where-Object -FilterScript { $_.Length -lt $MaxSize } | 
        Measure-Object -Property Length -Sum -Average
        
    [pscustomobject]@{
    'Path' = $Path
    'MaxSize' = $MaxSize
    'FileSizeSum' = $MeasuredFiles.Sum
    'FileSizeAvg' = $MeasuredFiles.Average
    }
}

Get-SmallFile -Path C:\Windows -MaxSize 100000