Configuration LinuxWebConfig {
    Param($ComputerName)
    Import-DSCResource -ModuleName PSDesiredStateConfiguration,nx
    Node $ComputerName {   
        nxPackage Apache {
            PackageManager = 'Apt'
            Ensure = 'Present'
            Name = 'apache2'
        }
        nxFile webfiles {
            SourcePath = "/tmp/index.html"
            DestinationPath = "/var/www/html/index.html"
            Ensure = 'Present'
            Force = $true
            DependsOn = '[nxPackage]Apache'
        }
    }
}
LinuxWebConfig -ComputerName 10.0.0.20