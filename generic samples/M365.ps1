#region Teams
Import-Module MicrosoftTeams
Connect-MicrosoftTeams

# Skype for Business Online cmdlets
$Session = New-CsOnlineSession
Import-PSSession $Session
Get-Command -Module (Get-Module -Name tmp*)
#endregion

#region Exchange Online v2
Import-Module ExchangeOnlineManagement
# connect with MFA
Connect-ExchangeOnline
Disconnect-ExchangeOnline
# connect with modern auth, no MFA
$UserCredential = Get-Credential
Connect-ExchangeOnline -Credential $UserCredential
Disconnect-ExchangeOnline
# connect with inline credential, no MFA, PS7 only
Connect-ExchangeOnline -InlineCredential
# connect with SSO, PS7 only
Connect-ExchangeOnline -UserPrincipalName navin@contoso.onmicrosoft.com
# connect with device logon (no browser available), PS7 only
Connect-ExchangeOnline -Device
#endregion

# enable Unified Group template for sensitivity labels
Import-Module azureadpreview
Connect-AzureAD
$Template = Get-AzureADDirectorySettingTemplate | Where {$_.DisplayName -eq "Group.Unified"}
if (!($Setting=Get-AzureADDirectorySetting|Where {$_.TemplateId -eq $Template.Id})) {$Setting = $Template.CreateDirectorySetting()}
$Setting["EnableMIPLabels"] = "True"
$Setting.Values
# next lines for new tenants
$SettingId = (New-AzureADDirectorySetting -DirectorySetting $Setting).id
Set-AzureADDirectorySetting -Id $SettingId -DirectorySetting $Setting
# tenants with existing settings
Set-AzureADDirectorySetting -Id $Setting.Id -DirectorySetting $Setting

