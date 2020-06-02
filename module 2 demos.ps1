#region slide 14 objects
$connection = test-connection localhost
Get-Member -InputObject $connection
#endregion

#region slide 22 members and types
$file = Get-Item C:\Windows\notepad.exe
$file | get-member
#endregion

#region slide 27 gettype() and get member
(Get-Date).GetType()
Get-Member -InputObject (get-date)
#endregion

#region slide 35 automatic variables
1/0
$error[0]
$?
$null
$pshome
$true
$host
#endregion

#region slide 44 user defined variables
$1 = 1 
$test = "test variable"
New-Variable -Name test -Value "also works"
#constant variables
New-Variable -Name speedofsound -Value "331.2" -Option Constant 
$speedofsound = 5 #This should throw an error

#read-only variables
New-Variable -Name writeprotected -Value "haha can't change me" -Option ReadOnly
$writeprotected
$writeprotected = 5 # This should throw an error
Set-Variable -Name writeprotected -Value 5 -Force # Forcing it will work
$writeprotected 
#endregion

#region slide 52 strings, here strings, subexpressions
$service = Get-Service -Name AJRouter
Write-Output -InputObject "Found the service $service" # probably not what you want
Write-Output -InputObject "Found the service $($service.Name)" # better

$two = 2
Write-Output -InputObject "one plus one = $(1+1), two time 2 is $( 8/4+8-3*$two)"

# here string
$shortcutcsharp = @"
using System;
using System.IO;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
namespace desktop
{
    public class shortcut
    {
        public static void create(string description, string linkpath, string filename)
        {
            IShellLink link = (IShellLink)new ShellLink();
            link.SetDescription(description);
            link.SetPath(linkpath);
            IPersistFile file = (IPersistFile)link;
            string desktopPath = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
            file.Save(Path.Combine(desktopPath, filename), false);
        }
    }
    [ComImport]
    [Guid("00021401-0000-0000-C000-000000000046")]
    internal class ShellLink
    {
    }
    [ComImport]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [Guid("000214F9-0000-0000-C000-000000000046")]
    internal interface IShellLink
    {
        void GetPath([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszFile, int cchMaxPath, out IntPtr pfd, int fFlags);
        void GetIDList(out IntPtr ppidl);
        void SetIDList(IntPtr pidl);
        void GetDescription([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszName, int cchMaxName);
        void SetDescription([MarshalAs(UnmanagedType.LPWStr)] string pszName);
        void GetWorkingDirectory([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszDir, int cchMaxPath);
        void SetWorkingDirectory([MarshalAs(UnmanagedType.LPWStr)] string pszDir);
        void GetArguments([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszArgs, int cchMaxPath);
        void SetArguments([MarshalAs(UnmanagedType.LPWStr)] string pszArgs);
        void GetHotkey(out short pwHotkey);
        void SetHotkey(short wHotkey);
        void GetShowCmd(out int piShowCmd);
        void SetShowCmd(int iShowCmd);
        void GetIconLocation([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder pszIconPath, int cchIconPath, out int piIcon);
        void SetIconLocation([MarshalAs(UnmanagedType.LPWStr)] string pszIconPath, int iIcon);
        void SetRelativePath([MarshalAs(UnmanagedType.LPWStr)] string pszPathRel, int dwReserved);
        void Resolve(IntPtr hwnd, int fFlags);
        void SetPath([MarshalAs(UnmanagedType.LPWStr)] string pszFile);
    }
}
"@
Add-Type -TypeDefinition $shortcutcsharp -Language CSharp  
[desktop.shortcut]::create("description","c:\temp","shortcut.lnk")
#endregion

#region slide 61 type casting
1+1
[string]1+1
1+[string]1
12*20
[string]12*20

#weak casting
$date1 = "2018-1-1"
$date1 = [datetime]"2018-1-1"
$date1 = "John Luc"

#strong casting
[datetime]$date2 = "2018-1-1"
$date2 = "John Luc" 
#endregion

#region slide 65 static methods
[datetime]::Now
[datetime]::DaysInMonth(2018,5)
[datetime]::IsLeapYear(2018)
[System.Net.Dns]::GetHostAddresses("microsoft.com")
[System.Net.Dns]::GetHostByAddress("8.8.8.8")
#endregion

#region slide 70 typer operator
"192.168.0.1" -as [System.Net.IPAddress]
"192.168.0.1" -is [System.Net.IPAddress]
("192.168.0.1" -as [System.Net.IPAddress]) -is [system.net.ipaddress]
#endregion

#region slide 81
"backup`b`b out"
"This`nis`the`nnext`nline"
"If bios audio is on you would hear `a beep"
"Let's not move`rDelete everything before this point."
#endregion