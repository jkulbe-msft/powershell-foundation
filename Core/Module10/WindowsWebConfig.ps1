Configuration WindowsWebConfig {
    Param($DomainJoinCredential,$ComputerName)
    Import-DscResource -ModuleName ComputerManagementDSC,PSDesiredStateConfiguration
    Node $ComputerName {
        Computer DomainJoin {
            Name = $ComputerName
            DomainName = 'contoso.com'
            Credential = $DomainJoinCredential
        }
        WindowsFeature WebServer {
            Ensure = "Present"
            Name = "Web-Server"
            DependsOn = '[Computer]DomainJoin'
        }
        File WebSiteFiles {
            Ensure = "Present"
            DestinationPath = "C:\inetpub\wwwroot"
            SourcePath = "C:\Temp\index.html"
            DependsOn = '[WindowsFeature]WebServer'
        }
    }
}
$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName = "*"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        },
        @{
            NodeName = "WINWEB"
        }
    )
}
$Credential = Get-Credential
WindowsWebConfig -ComputerName WINWEB -DomainJoinCredential $Credential -ConfigurationData $ConfigurationData