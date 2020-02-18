function Get-SmallFile
{
    param($Path, $MaxSize)

    $MeasuredFiles = Get-ChildItem -Path $path -File | 
        Where-Object -FilterScript { $_.Length -lt $MaxSize } | 
        Measure-Object -Property Length -Sum 
        
    [pscustomobject]@{
    'Path' = $Path
    'MaxSize' = $MaxSize
    'FileSizeSum' = $MeasuredFiles.Sum
    }
}

Get-SmallFile -Path C:\Windows -MaxSize 100000