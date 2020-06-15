# created using New-Fixture -Path HelloWorld -Name HelloWorld in the parent path

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut" # this dot-sources the test file (sut = "System under test")

# mind the {} brace position. Braces MUST open on the same line as the keyword (keywords are functions expecting a scriptblock paramater - no line breaks)
Describe "HelloWorld" {
    It "says 'Hello World'" {
        HelloWorld | Should -Be "Hello World"
    }
}
