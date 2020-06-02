function MyTestFunction {
    Param(
        [ValidateNotNullOrEmpty()]
        $Name)
    if ($Name) {
        Write-Output "Hello $Name"
    }
    else {
        Write-Output "Hello World"
    }
}

Describe "All Tests" {
    It "Should Output Hello World if Name parameter is not supplied" {
        MyTestFunction | Should Be "Hello World"
    }
    It "Should output a name if name is supplied" {
        MyTestFunction -Name User | Should Be "Hello User"
    }
    It "Should throw if name is null" {
        {MyTestFunction -Name $null} | Should Throw
    }
}