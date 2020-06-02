
<#
https://blogs.msdn.microsoft.com/kebab/2013/06/09/an-introduction-to-error-handling-in-powershell
http://www.informit.com/articles/article.aspx?p=729515&seqNum=5
https://www.gngrninja.com/script-ninja/2016/6/5/powershell-getting-started-part-11-error-handling

https://docs.microsoft.com/en-us/powershell/scripting/core-powershell/ise/how-to-debug-scripts-in-windows-powershell-ise?view=powershell-6

#>


$Error

$Error[0]
$error[0].InvocationInfo # where did the error happen?
$error[0].Exception.Message # human-readable error message

#external commands
$LASTEXITCODE