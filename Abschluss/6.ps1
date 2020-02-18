function Get-SmallFile
{
    param($Path, $MaxSize)

    Get-ChildItem -Path $path -File | 
        Where-Object -FilterScript { $_.Length -lt $MaxSize } | 
        Measure-Object -Property Length -Sum    
}

Get-SmallFile -Path C:\Windows -MaxSize 100000