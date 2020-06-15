# created using New-Fixture -Path HelloWorld -Name HelloWorld in the parent path

BeforeAll {
    . $PSCommandPath.Replace('.Tests.ps1','.ps1') # this dot-sources the test file
}
# mind the {} brace position. Braces MUST open on the same line as the keyword (keywords are functions expecting a scriptblock paramater - no line breaks)
Describe "HelloWorld" {
    It "says 'Hello World'" {
        HelloWorld | Should -Be "Hello World"
    }
}
