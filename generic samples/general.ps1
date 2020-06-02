#region encoding
$PSDefaultParameterValues['*:Encoding'] = 'utf8'
#endregion


#region PSReadline

# list console keyboard shortcuts
Get-PSReadLineKeyHandler
Get-PSReadLineOption
#endregion

#region aliases
# please don't use aliases in scripts
gsv | % {spsv $_ -wi}

# which aliases point to a particular command?
Get-Alias -Definition Get-Childitem

#endregion

#region select-object
Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length

Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length,Empty
Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length,Empty | Get-Member
Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length,@{Label='MyProperty';Expression={'XXX'}}
Get-ChildItem C:\Windows -File | Select-Object -Property Name,Length,@{Label='SizeKB';Expression={[math]::round($_.Length/1KB)}}

Get-ChildItem C:\Windows -File | Select-Object -First 2
"a","a","b" | Select-Object -Unique

# Expandproperty

# Group

#endregion



#region formatting

# -f
'This {0} a test to {1} works.' -f 'is','show how the formatting operator'

'Today is {0}' -f $(Get-Date)
'The time is {0:t}' -f $(Get-Date)
'The day of the week is {0:dddd}' -f $(Get-Date)
'The current month and year is {0:M-yyyy}' -f [datetime]::now
'Pi rounded to three digits is {0:f3}' -f [math]::PI
'The price is {0:C}' -f 100

try {
    1/0
}
catch {
    'The error exception was: {0}. The error happened here: {1}' -f $Error[0].exception.Message, $Error[0].invocationinfo.positionmessage
}

#endregion

#region here-strings

<#Option 1: Inline code execution:

$string = @"
[Options]
ProductID=$($ConfigManProductKey)
SiteCode=$($Site.Code)
SiteName=$($Site.Description)

"@
Benefits:
-	Clearer separation between variables and text
-	Able to access properties (or call commands)

Option 2: Format String

$string = @'
[Options]
Setting1=$sys$for
Setting2=$sys$foo
Setting3=$sys${0}
Setting4=$sys${1}

'@ -f $foo, $bar.Name
Benefits:
-	Clearer separation between logic and code
-	Ability to format input further (not shown here)
-	Insert into HERE strings with disabled content interpretation (single-quotes). This makes it possible to define here-strings without the hassle of escaping lots of $ characters (if present) and still insert content into it

#>

#endregion

#region code signing
$codeSignCert = New-SelfSignedCertificate -Subject "My code signing certificate" -Type CodeSigningCert -CertStoreLocation Cert:\LocalMachine\My
Move-Item -Path $codeSignCert.PSPath -Destination 'Cert:\LocalMachine\Root'
Set-AuthenticodeSignature -Certificate $codeSignCert -FilePath myscript.ps1
#endregion