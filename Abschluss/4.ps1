function Get-SmallFile
{
    Get-ChildItem -Path C:\Windows -File | 
        Where-Object -FilterScript { $_.Length -lt 100000 } | 
        Measure-Object -Property Length -Sum    
}

Get-SmallFile