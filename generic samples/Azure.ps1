#region proxy
$proxyUri = New-Object -Type System.Uri("http://<proxy>:<port>")
[System.Net.WebRequest]::DefaultWebProxy = New-Object -Type System.Net.WebProxy($proxyUri, $true)

[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
#endregion

#region logon
Connect-AzAccount
Get-AzContext
Get-AzSubscription
Set-AzContext -Subscription "My Subscription"
#endregion

#region limit AzureAD group creation
Connect-AzureAD
New-AzureADGroup -DisplayName "GroupCreators" -SecurityEnabled:$true -MailEnabled:$false -MailNickName "GroupCreators"
Get-AzureADGroup -SearchString "GroupCreators" | Add-AzureADGroupMember -RefObjectId (Get-AzureADUser -SearchString "John Doe").ObjectId
$Setting = Get-AzureADDirectorySetting -Id (Get-AzureADDirectorySetting | where -Property DisplayName -Value "Group.Unified" -EQ).id
$Setting["EnableGroupCreation"] = "False"
$Setting["GroupCreationAllowedGroupId"] = (Get-AzureADGroup -SearchString "GroupCreators").objectid
Set-AzureADDirectorySetting -Id $Setting.Id -DirectorySetting $Setting
#endregion