#region Emoji function
function 🤣 {'LOL'}
function 😄 (${🙄}, ${🤨}){${🙄}+${🤨}}
#endregion

#region speech
Add-Type -AssemblyName System.Speech
$speech = New-Object System.Speech.Synthesis.SpeechSynthesizer
#endregion

# type conversion madness
# https://madwithpowershell.blogspot.com/2018/03/leveraging-dynamic-type-conversion-in.html
$__="$(@{})";$__[-((!@()+!@())*(!@()+!@())*(!@()+!@())+(!@()+!!@()))]+$__[-(!@()+!!@())]+$__[-(!@()+!@())]+$__[-(!@()+!@())]+$__[(!@()+!@())*(!@()+!@())*(!@()+!@())]

# moin
77,111,105,110 | ForEach-Object -Begin {$ausgabe=$null} -Process {$ausgabe += [char]$_} -End {$ausgabe}
77,111,105,110 | ForEach-Object { Write-Host ([char]$_) -NoNewline}


<#

Well … as a permanently sadistic evil prankster, I sure have my favorite challenge:

Fred's evil Object Challenge 1) "The greatest storage consumers"
Search your user profile and find
- The five file-extensions that in sum are the greatest storage consumers
- For each of those extensions, find the six largest files
- (optional)Sort them by the month they were last accessed in

Limitations:
- Your code during development may only be executed in PowerShell.exe (no ISE or VSCode or other smart-alec editor should help you). Storing Snippets in plain notepad is legal.
- You may not search in the internet for help
- You may not ask human beings for help
- You may not use commands that are not part of the default powershell
- Your solution may not use `foreach` loops, though it may use `ForEach-Object`, if so desired.
- Your solution should not use more than two variable assignments (less is better)


Other than fun like that, you may want to take a look at the "PSKoans" module

From: Sean Kearney
Sent: Tuesday, October 30, 2018 17:25
To: Michael J. Lyons (XBOX) <mlyons@microsoft.com>; Chad Cox <Chad.Cox@microsoft.com>; PowerShell Discussions <pshtalk@microsoft.com>
Subject: RE: looking for fun PS Scenarios

Hex clock
https://gallery.technet.microsoft.com/scriptcenter/Windows-PowerShell-23ed0697

New Years Countdown
https://gallery.technet.microsoft.com/scriptcenter/New-Years-Countdown-Script-32cc1b45

Generate Random Passwords (A variant on one Joel “Jaykul” Bennett created on Poshcode.org)
https://gallery.technet.microsoft.com/scriptcenter/d34e94fc-9c06-4499-bcf7-4491f2e4abf8

PowerShell Binary Clock
https://gallery.technet.microsoft.com/scriptcenter/d3e6f740-ded4-420a-968b-dc81cbb67b84

Or here’s just something fun and silly….. Using $Host to move the cursor around the screen and randomly drop things in there

Or if you want to do a “Burn in the CPU” test… one of my early early scripts that was a variant from BsonPosh and the community.  The PowerShell Christmas Tree
https://ye110wbeard.wordpress.com/2009/12/18/powershell-–-oh-christmas-tree-oh-christmas-tree-–-one-more-change/

Just think “Fun and stupid” like “Print your name on the screen 10 times”  (Basic loop)

http://www.secretgeek.net/slackathon

#>

function Clock {
    [xml]$XAML = @'
    <Window xmlns='http://schemas.microsoft.com/winfx/2006/xaml/presentation'
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        xmlns:system="clr-namespace:System;assembly=mscorlib"
        WindowStyle='None' AllowsTransparency='True'
        Topmost='True' Background="Transparent"  ShowInTaskbar='False'
        SizeToContent='WidthAndHeight' WindowStartupLocation='CenterOwner' >
       <Window.Resources>
          <system:String x:Key="Time">12:34.56</system:String>
       </Window.Resources>

        <Grid Height="2.2in">
            <Grid.ColumnDefinitions>
                <ColumnDefinition/>
            </Grid.ColumnDefinitions>
            <Label Name="Clock" Grid.Column="2" Content="{DynamicResource Time}" FontFamily="Impact, Arial" FontWeight="800" FontSize="1in" >
                <Label.Foreground>
                    <LinearGradientBrush>
                       <GradientStop Color="Red" Offset="1"/>
                       <GradientStop Color="Orange" Offset="0.85"/>
                       <GradientStop Color="Yellow" Offset="0.7"/>
                       <GradientStop Color="Green" Offset="0.55"/>
                       <GradientStop Color="Blue" Offset="0.4"/>
                       <GradientStop Color="Indigo" Offset="0.2"/>
                       <GradientStop Color="Violet" Offset="0"/>
                    </LinearGradientBrush>
                </Label.Foreground>
            </Label>
        </Grid>
    </Window>
'@

    Add-Type -Assembly PresentationFramework
    Add-Type -Assembly PresentationCore

    $clock = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader ($XAML)))

    ## Create a script block which will update the UI
     $counter = 0;
     $updateBlock = {
        # Update the clock
        $clock.Resources["Time"] = [DateTime]::Now.ToString("T")
     }
    ## Hook up some event handlers
    $clock.Add_SourceInitialized( {
        ## Before the window's even displayed ...
        ## We'll create a timer
        $timer = new-object System.Windows.Threading.DispatcherTimer
        ## Which will fire 4 times every second
        $timer.Interval = [TimeSpan]"0:0:0.25"
        ## And will invoke the $updateBlock
        $timer.Add_Tick( $updateBlock )
        ## Now start the timer running
        $timer.Start()
        if( $timer.IsEnabled ) {
           Write-Host "Clock is running. Don't forget: RIGHT-CLICK to close it."
        } else {
           $clock.Close()
           Write-Error "Timer didn't start"
        }
     } )
    $clock.Add_MouseLeftButtonDown( {
       $_.Handled = $true
        $clock.DragMove() # WPF Magic!
     } )
     $clock.Add_MouseRightButtonDown( {
       $_.Handled = $true
        try {$timer.Stop()} catch {}  # we'd like to stop that timer now, thanks.
        $clock.Close() # and close the windows
     } )
    ## Lets go ahead and invoke that update block
    &$updateBlock
    ## And then show the window
    $clock.ShowDialog()
}

# Rick
iex (New-Object Net.WebClient).DownloadString("http://bit.ly/e0Mw9w")

#region Powershell Cluedo
# "challenge: Can you solve the powershell Cluedo" 
# "use only powershell to solve the puzzle" 
# "at the end the script should be run solo" 
# "and display the actions and the resolution"
# "Sample: ( dont use NSlookup in your code)"
$start = nslookup -q=TXT cluedo.13thdivision.nl 
write-output -InputObject $start
#endregion

#region Martijn's stopwatch challenge - Hide everything :) :( :)

#region explain what to do

"`n`nChallenge: Can you create a stopwatch clock without using get-date or [System.Diagnostics.Process]`n"
 
 "`t1: Use loops to create a stopwatch it does not need to be accurate"
 "`t2: Format the clock in 24 H format 00:00:00"
 "`t3: Add a time skew to show the second -> minute swap @ 59 sec and @ 59 min and @ 23 Hours"
 "`t4: Make it awsome by adding voice :) `n"


"Sample:"

#endregion explain what to do

#region main script

function start-stopwatch
{
    #region Initialision code
    [int32]$second = 0
    [int32]$minute = 0
    [int32]$hour = 0

    #region make it cool
    $voice =New-Object -ComObject SAPI.spvoice
    $voice.voice = ($voice.GetVoices())[1]
    $null = $voice.Speak("Testing testing testing, 1 , 2 , 3 , ehh ehmm , here we go")
    $null = $voice.Speak("Hi i am a stopwatch let me tell you the time")
    #endregion make it cool

    #endregion Initialision code
    
    #region hide
    do 
    {
    #endregion hide

        #clear itterative variable
        $clock = $null

        #region code for seconds
        $second++
        if ( $second -eq 60 )
        {
            $second = 0
            $minute++
        }
        #region Speeding ahead
        if ( $second -eq 4 )
        {
            write-output -inputobject "Speeding ahead for this demo"
            $second = 59
            #region make it cool
            $null = $voice.Speak("Speeding ahead for this demo")
            #endregion make it cool
        
        }
        #endregion Speeding ahead
        #endregion code for seconds

        #region code for minutes
        if ( $minute -eq 60 )
        {
            $minute = 0
            $hour++
        }

        #region Speeding ahead
        if ( $minute -eq 2 -and $second -eq 2 )
        {
            write-output -inputobject "Speeding ahead for this demo"
            $second = 59
            $minute = 59
            #region make it cool
            $null = $voice.Speak("Speeding ahead for this demo")
            #endregion make it cool        
        }
        #endregion Speeding ahead
        #endregion code for minutes

        #region code for hours
        if ( $hour -eq 24 )
        {
            $second = 0
            $minute = 0
            $hour = 0
        }

        #region Speeding ahead
        if ( $hour -eq 2 -and $minute -eq 2 -and $second -eq 2)
        {
            write-output -inputobject "Speeding ahead for this demo"
            $second = 59
            $minute = 59
            $hour = 23
            #region make it cool
            $null = $voice.Speak("Speeding ahead for this demo")
            #endregion make it cool        
        }
        #endregion Speeding ahead
        #endregion code for hours

        #region code for output
        $clock = "$($hour.tostring("00")):$($minute.tostring("00")):$($second.tostring("00"))"
        Write-Output -InputObject $clock
        
        #region make it cool
        $null = $voice.Speak($clock)
        #endregion make it cool

        #endregion code for output
    
    #region hide
    }While
    (
        $true
    )
    #endregion hide
}

start-stopwatch

#endregion main script

#endregion Hide everything :) :( :)

