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

