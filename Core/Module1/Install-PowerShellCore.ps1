[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$uri = 'https://github.com/PowerShell/PowerShell/releases/download/v7.0.0/PowerShell-7.0.0-win-x64.msi'
$outFile = $uri.Split("/")[-1]
New-Item -Path C:\Temp -Type Directory
Invoke-WebRequest -Uri $uri -OutFile "C:\Temp\$outFile" -UseBasicParsing -Verbose
Set-Location C:\Temp
Start-Process -FilePath $outFile -ArgumentList "/qn" -Wait