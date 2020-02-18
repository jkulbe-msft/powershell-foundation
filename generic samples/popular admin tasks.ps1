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