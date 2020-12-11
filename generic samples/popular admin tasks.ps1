#region SMB
Get-SmbShare
Get-SmbShare | Sort-Object –Property Description

Get-Volume
Get-Volume | Sort-Object –Property SizeRemaining

Get-Hotfix
Get-Hotfix | Sort-Object –Property installedon
#endregion

#region AD
# new OU and users
New-ADOrganizationalUnit –Path 'DC=Contoso,DC=local' –Name Personnel

Import-CSV -Path C:\PShell\Labs\Contoso-UserImport.csv | 
Foreach-Object {
New-ADUser -Path "OU=$($_.Department),OU=Personnel,DC=Contoso,DC=local" `
    -Name $_.Name –GivenName $_.FirstName
}

# ADSISeracher
$ADSISearcher = [adsisearcher]'(objectClass=*)'
$ADSISearcher = [adsisearcher]::new()
$ADSISearcher = New-Object -TypeName System.DirectoryServices.DirectorySearcher

$ADSISearcher.FindOne()

$ADSISearcher.SearchRoot = "OU=MySubOU,OU=MyOU,DC=contoso,DC=com"
$ADSISearcher.SearchScope = 'Base' # 'OneLevel','SubTree'
$ADSISearcher.SizeLimit = 25 # default = 0 -> uses default server limit (1000)

$ADSISearcher.FindAll()
#endregion

#region AD cmdlets
Get-ADUser -Filter * -SearchBase "OU=MySubOU,OU=MyOU,DC=contoso,DC=com"
Get-ADComputer -Filter "OperatingSystem -like 'Windows*'" -Properties OperatingSystem | 
    Group-Object -Property operatingsystem | 
    Sort-Object -Property name
#endregion

# region sites
[System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
[System.DirectoryServices.ActiveDirectory.ActiveDirectorySite]::GetComputerSite().Name
#endregion

#region event log
Get-EventLog -List
# newer
Get-WinEvent -ListLog * 

Get-EventLog -Logname System –EntryType Error | Select-Object -First 10
Get-Eventlog -LogName System –newest 1000 | Group-Object -Property EntryType
Get-EventLog -LogName System -InstanceId 7001
Get-EventLog -LogName System -Message "*Group Policy*"

Get-WinEvent -FilterHashtable @{logname="System";Level=4;ID=7001}
(Get-WinEvent -FilterHashtable @{ProviderName="Microsoft-Windows-Winlogon";Level=4;ID=7001}).Message

New-EventLog -LogName 'My Event Log' -Source 'MySource1','MySource2' 
$params = @{
    LogName = 'My Event Log'
    Source = 'MySource1'
    EntryType = 'Error'
    EventId = 400
    Message = 'This is not really a meaningful error message from MySource1'
}
Write-EventLog @params
#endregion

#region registry
New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT

New-Item –Path HKCU:\Software –Name FileArchiveScript
New-ItemProperty –Path HKCU:\Software\FileArchiveScript –Name LastExecutionDate -Value (Get-Date).AddDays(-1).ToShortDateString()
$lastExecutionDate = (Get-ItemPropertyValue –Path HKCU:\Software\FileArchiveScript –Name lastExecutionDate)
Set-ItemProperty –Path HKCU:\Software\FileArchiveScript –Name lastExecutionDate –Value (Get-Date).ToShortDateString()

#endregion

#region ACLs
[System.Enum]::getnames([System.Security.AccessControl.FileSystemRights])
Get-Acl C:\Windows | Format-List -Property *
Get-Acl C:\Windows | Get-Member

#copy permissions
Get-Acl -Path C:\Source | Set-Acl -Path C:\Target

#set permissions
$Account = New-Object System.Security.Principal.Ntaccount ('CONTOSO\MyAccount')
$Acl = Get-Acl C:\Target
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule('CONTOSO\MyAccount','FullControl','Allow')
$Acl.PurgeAccessRules($Account) # remove all access entries for user
$Acl.SetAccessRule($AccessRule)
$Acl.SetAccessRuleProtection($true,$false) # remove inheritance, remove inherited permissions
$Acl.SetOwner($Account)
$Acl | Set-Acl C:\Target

#endregion

#region temp file

New-TemporaryFile
# old style PS <5
$TempFile = [System.IO.Path]::GetTempFileName()
#new
$TempFile = New-TemporaryFile
#endregion

#region XML
$xml = [xml](Get-Content -Path C:\Temp\test.xml)

# https://michlstechblog.info/blog/powershell-some-basic-xml-handling-with-powershell-and-net/
# Create a new XML File with config root node
[System.XML.XMLDocument]$oXMLDocument=New-Object System.XML.XMLDocument
# New Node
[System.XML.XMLElement]$oXMLRoot=$oXMLDocument.CreateElement("config")
# Append as child to an existing node
$oXMLDocument.appendChild($oXMLRoot)
# Add a Attribute
$oXMLRoot.SetAttribute("description","Config file for testing")
[System.XML.XMLElement]$oXMLSystem=$oXMLRoot.appendChild($oXMLDocument.CreateElement("system"))
$oXMLSystem.SetAttribute("description","Document Management")
# Save File
$oXMLDocument.Save("c:\temp\config.xml")

$oXMLDocument = [xml]@'
<config description="Config file for testing">
    <system description="Document Management">
        <document authorFirstName="Kirk" authorSurname="Author1" date="20130503 01:15:43" description="Document Hammet" index="3">C:\temp\doc0001.txt</document>
        <document authorFirstName="Lars" authorSurname="Author5" date="20130503 10:05:42" description="Document Ulrich" index="4">C:\temp\doc0002.txt</document>
        <document authorFirstName="Cliff" authorSurname="Author5" date="20130612 11:54:33" description="Document Burton"  index="6">C:\temp\doc0051.txt</document>
        <document authorFirstName="Jason" authorSurname="Author2" date="20130806 04:02:41" description="Document Newsted"  index="1">C:\temp\doc0041.txt</document>
        <document authorFirstName="Robert" authorSurname="Smith" date="20131202 07:12:03" description="Document Trujillo"  index="2">C:\temp\doc0012.txt</document>
        <document authorFirstName="James" authorSurname="Smith" date="20130211 09:05:59" description="Document Hetfield"  index="5">C:\temp\doc0003.txt</document>
    </system>
</config>
'@

# Load and query
#$oXMLDocument=New-Object System.XML.XMLDocument
#$oXMLDocument.Load("c:\temp\config.xml")
# Accessing a node/attribute
$oXMLDocument.config.description
$oXMLDocument.config.system.document
# Get all documents from Author "Smith"
$oXMLDocument.selectNodes("config/system/document[@authorSurname=""Smith""]")
# Get all documents from Author "Smith" with date February 2013, XPATH Query relative to document root, http://msdn.microsoft.com/en-US/library/ms256086.aspx
$oXMLDocument.selectNodes("config/system/document[@authorSurname=""Smith"" and starts-with(@date,""201302"")]")

#endregion

#region remote modules

Get-ADUser -Filter * # error, command not available on workstation
$session = New-PSSession -ComputerName Lab1DC1
Invoke-Command -Session $session -ScriptBlock {Import-Module ActiveDirectory}
Get-ADUser -Filter * # still not available
Import-PSSession $session -DisableNameChecking -ErrorAction SilentlyContinue
Get-ADUser -Filter * # now we have a new command :-)
Remove-PSSession -Session $session
Get-ADUser -Filter * # and it's gone

$session = New-PSSession -ComputerName Lab1DC1
Invoke-Command -Session $session -ScriptBlock {Import-Module ActiveDirectory}
Import-PSSession $session -DisableNameChecking -ErrorAction SilentlyContinue -Prefix MyCommand
Get-MyCommandADUser -Filter * # with custom prefix
Get-Help Get-MyCommandADUser # Get-Help works, content shows the original name
Remove-PSSession -Session $session

# Exchange 
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<ServerFQDN>/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session
Get-Mailbox
Remove-PSSession $Session

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://<ServerFQDN>/PowerShell/ -Authentication Kerberos -Credential $UserCredential
Import-PSSession $Session -Prefix EX
Get-EXMailbox
Remove-PSSession $Session
#endregion

#region default parameter values
$PSDefaultParameterValues = @{'New*:WhatIf'=$true}
#endregion

#region special folders
[System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::CommonDesktopDirectory)
#endregion

#region certificates
#region self-signed cert for Microsof Graph
# see https://itfordummies.net/2020/11/29/microsoft-graph-api-powershell-azuread-app/
$DisplayName = "Microsoft Graph PowerShell Client Credentials"
$NotAfter = $(Get-Date).AddYears(2)
$cert = New-SelfSignedCertificate -CertStoreLocation cert:\currentuser\my -DnsName graph.microsoft.com -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter $NotAfter -FriendlyName $DisplayName
$password = "Intune123!!"
# Export .cer file
Export-Certificate -Cert "cert:\currentuser\my\$($cert.Thumbprint)" -FilePath "c:\temp\$DisplayName.cer"
# Export .pfx file
Export-PfxCertificate -Cert "cert:\currentuser\my\$($cert.Thumbprint)" -FilePath "c:\temp\$DisplayName.pfx" -Password ($password | ConvertTo-SecureString -Force -AsPlainText)

#connect
$TenantId = 'b1c384d8-6b6b-40ad-b32f-8f54a16c54be'
$ClientId = '60a21d98-e198-489a-91d9-ca62e879bc06' #app id
$CertificateThumbprint = Get-ChildItem -Path cert:\currentuser\my | Where-Object -FilterScript {$_.Issuer -eq 'CN=graph.microsoft.com'} | Select-Object -ExpandProperty Thumbprint
Connect-MgGraph -ClientId $ClientId -TenantId $TenantId -CertificateThumbprint $CertificateThumbprint
$Devices = Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/devices/'
$Devices.value
#endregion

#region
# connect using another method using the same cert as above
# Powershell Graph API https://adamtheautomator.com/microsoft-graph-api-powershell/
$TenantName = 'falukorvlab1.onmicrosoft.com'
$AppId = '60a21d98-e198-489a-91d9-ca62e879bc06'
$Certificate = Get-ChildItem -Path cert:\currentuser\my | Where-Object -FilterScript {$_.Issuer -eq 'CN=graph.microsoft.com'}
$Scope = "https://graph.microsoft.com/.default"

# Create base64 hash of certificate
$CertificateBase64Hash = [System.Convert]::ToBase64String($Certificate.GetCertHash())

# Create JWT timestamp for expiration
$StartDate = (Get-Date "1970-01-01T00:00:00Z" ).ToUniversalTime()
$JWTExpirationTimeSpan = (New-TimeSpan -Start $StartDate -End (Get-Date).ToUniversalTime().AddMinutes(2)).TotalSeconds
$JWTExpiration = [math]::Round($JWTExpirationTimeSpan,0)

# Create JWT validity start timestamp
$NotBeforeExpirationTimeSpan = (New-TimeSpan -Start $StartDate -End ((Get-Date).ToUniversalTime())).TotalSeconds
$NotBefore = [math]::Round($NotBeforeExpirationTimeSpan,0)

# Create JWT header
$JWTHeader = @{
    alg = "RS256"
    typ = "JWT"
    # Use the CertificateBase64Hash and replace/strip to match web encoding of base64
    x5t = $CertificateBase64Hash -replace '\+','-' -replace '/','_' -replace '='
}

# Create JWT payload
$JWTPayLoad = @{
    # What endpoint is allowed to use this JWT
    aud = "https://login.microsoftonline.com/$TenantName/oauth2/token"

    # Expiration timestamp
    exp = $JWTExpiration

    # Issuer = your application
    iss = $AppId

    # JWT ID: random guid
    jti = [guid]::NewGuid()

    # Not to be used before
    nbf = $NotBefore

    # JWT Subject
    sub = $AppId
}

# Convert header and payload to base64
$JWTHeaderToByte = [System.Text.Encoding]::UTF8.GetBytes(($JWTHeader | ConvertTo-Json))
$EncodedHeader = [System.Convert]::ToBase64String($JWTHeaderToByte)

$JWTPayLoadToByte =  [System.Text.Encoding]::UTF8.GetBytes(($JWTPayload | ConvertTo-Json))
$EncodedPayload = [System.Convert]::ToBase64String($JWTPayLoadToByte)

# Join header and Payload with "." to create a valid (unsigned) JWT
$JWT = $EncodedHeader + "." + $EncodedPayload

# Get the private key object of your certificate
$PrivateKey = $Certificate.PrivateKey

# Define RSA signature and hashing algorithm
$RSAPadding = [Security.Cryptography.RSASignaturePadding]::Pkcs1
$HashAlgorithm = [Security.Cryptography.HashAlgorithmName]::SHA256

# Create a signature of the JWT
$Signature = [Convert]::ToBase64String(
    $PrivateKey.SignData([System.Text.Encoding]::UTF8.GetBytes($JWT),$HashAlgorithm,$RSAPadding)
) -replace '\+','-' -replace '/','_' -replace '='

# Join the signature to the JWT with "."
$JWT = $JWT + "." + $Signature

# Create a hash with body parameters
$Body = @{
    client_id = $AppId
    client_assertion = $JWT
    client_assertion_type = "urn:ietf:params:oauth:client-assertion-type:jwt-bearer"
    scope = $Scope
    grant_type = "client_credentials"

}

$Url = "https://login.microsoftonline.com/$TenantName/oauth2/v2.0/token"

# Use the self-generated JWT as Authorization
$Header = @{
    Authorization = "Bearer $JWT"
}

# Splat the parameters for Invoke-Restmethod for cleaner code
$PostSplat = @{
    ContentType = 'application/x-www-form-urlencoded'
    Method = 'POST'
    Body = $Body
    Uri = $Url
    Headers = $Header
}
#get token
$Request = Invoke-RestMethod @PostSplat

$Header = @{
    Authorization = "$($Request.token_type) $($Request.access_token)"
}

$Uri = "https://graph.microsoft.com/v1.0/devices"

# Fetch all security alerts
$DevicesRequest = Invoke-RestMethod -Uri $Uri -Headers $Header -Method Get -ContentType "application/json"

$Devices = $DevicesRequest.Value
$Devices
#endregion

#region local admin group
Get-CimInstance -Query "Select * From Win32_Group Where LocalAccount = TRUE And SID = 'S-1-5-32-544'"
#endregion

#endregion