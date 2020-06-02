$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Write-Servicestatus" {
    Context "Unit Test to see if we're looking at services and exporting files at all, without actually looking at services or writing files" {
        Mock Get-Service {[pscustomobject]@{Name='Service1';Status='Running'}} -Verifiable
        Mock Export-CSV {} -Verifiable
        Write-Servicestatus -Outfile "Testdrive:\result.csv"
        
        It "Should call verifiable mocks defined above" {
            Assert-VerifiableMock
        }
        It "Should only export a file once" {
            Assert-MockCalled Export-CSV -Times 1 -Exactly
        }
        It "Should call Export-CSV wih Parameter Outfile" {
            Assert-MockCalled Export-CSV -Parameterfilter { $path -eq "Testdrive:\result.csv"}
        }
    }
    Context "File-related tests" {      
        Write-Servicestatus -Outfile "Testdrive:\result.csv"
        $file = Get-Item "Testdrive:\result.csv"
        It "Writes a CSV file" {
            $file | Should -Exist
        }
        It "Contains at least one running service" {
            ((Import-CSV $file).status -Match "Running").count | Should -BeGreaterOrEqual 1
        }
    }
}