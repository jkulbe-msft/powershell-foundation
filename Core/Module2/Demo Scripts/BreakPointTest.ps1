$myInt = $null
<# Put a breakpoint here#>
$myInt = 1
<# Put a breakpoint here#>
$myInt = 2
<# Put a breakpoint here#>

function Use-Int {
    Param ($InputInt)

    $InputInt = $InputInt + 1

    return $InputInt
}
<# Put a breakpoint here#>
$val = Use-Int -InputInt $myInt

Write-Output $val