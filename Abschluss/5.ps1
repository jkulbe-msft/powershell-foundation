function Get-SmallFile
{
    param($Path)

    Get-ChildItem -Path $path -File | 
        Where-Object -FilterScript { $_.Length -lt 100000 } | 
        Measure-Object -Property Length -Sum    
}

Get-SmallFile -Path C:\Windows