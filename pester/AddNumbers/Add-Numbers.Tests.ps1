$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Add-Numbers" {  
    # run commands to initilaize tests here - deprecated for Pester v5
    BeforeEach {
        # runs before each It test
        # also available nested inside contexts, these run in addition to Descrbe BeforeEach/AfterEach
    }
    AfterEach {
        # runs after each It test
        # also available inside contexts
    }
    Context "This context separates test groups" {
        It "adds two numbers" {
            Add-Numbers -FirstNumber 1 -SecondNumber 2 | Should -Be 3
            Add-Numbers -FirstNumber 2 -SecondNumber 1 | Should -Be 3
        }
    }
    Context "Type-related tests" {
        It "returns an int value" {
            Add-Numbers -FirstNumber 1 -SecondNumber 2 | Should -BeOfType int
        }
        It "throws an error when adding strings" {
            { Add-Numbers -FirstNumber "A" -SecondNumber 2 } | Should -Throw 'Cannot convert value "A" to type "System.Int32".'
            { Add-Numbers -FirstNumber 1 -SecondNumber "B" } | Should -Throw 'Cannot convert value "B" to type "System.Int32".'
        }
    }
}
