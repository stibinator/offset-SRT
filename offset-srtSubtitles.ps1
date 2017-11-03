<#
.SYNOPSIS
Adds an offset to the subtitle in an SRT file

.DESCRIPTION
Given an SRT file this script will add an offset to the subtitles in it

.OUTPUTS
null

.EXAMPLE
Offset-SRTSubtitles "foobar.srt" -Hours 1 -Minutes 14 -Seconds -3 -Frames 23 -framerate 30

.LINK
http://blob.pureandapplied.com.au
#>
Function Offset-SRTSubtitles
{
  [CmdletBinding()]
  Param
  (
    # Input SRT file, mandatory
    [Parameter(Mandatory=$True, ValueFromPipeLine=$True, Position=0)]
    $InputSRT,

    #Output SRT file, defaults to the input + "offset"
    $outputSRT,
    # Hours offset
    [int]
    $Hours =0,

    # Minutes offset
    [int]
    $Minutes = 0,

    # Seconds offset
    [int]
    $Seconds = 0,

    # Milliseconds offset
    [int]
    $Milliseconds = 0,

    # Frames offset
    [int]
    $Frames = 0,

    # Frame rate, default 25
    [int]
    $framerate = 25
  )

  $InputSRT = get-ChildItem $InputSRT #convert string to FS object
  # User has specified frames, so convert to Milliseconds
  if ($Frames){$Milliseconds = 1000 * ($framerate -as [int]) / ($Frames -as [int])}
  if (! ($outputSRT)){
    $outputSRT = join-path $InputSRT.directory $InputSRT.Name.Replace($InputSRT.extension, "_offset.srt")
  }
  # check for output conflicts
  if (test-path $outputSRT -ErrorAction SilentlyContinue){
    $y = Read-Host ("file {0} already exists - overWrite [y] / n" -f $outputSRT)
    if ($y -match "n"){
      return
    } else {
      rm $outputSRT
    }
  }
  # Time for the Hoo-Hah
  Get-Content $InputSRT|%{
    # match the time stamp part of the srt
    if ($_ -match "-->" ){$t=$_ -match "([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)"
    # turns out that the powershell dateTime object can be used for timecode
    $oldIn = get-date -hour $Matches[1] -Minute $Matches[2] -Second $Matches[3] -Millisecond $Matches[4]
    $oldOut = get-date -hour $Matches[5] -Minute $Matches[6] -Second $Matches[7] -Millisecond $Matches[8]
    # so we can do all the time calculations super easily
    $newIn = $oldIn.AddHours($Hours).AddMinutes($Minutes).AddSeconds($Seconds).AddMilliseconds($Milliseconds)
    $newOut = $oldOut.AddHours($Hours).AddMinutes($Minutes).AddSeconds($Seconds).AddMilliseconds($Milliseconds)
    #write output
    Add-Content $outputSRT ("{0}:{1:d2}:{2:d2},{3:d3} --> {4}:{5:d2}:{6:d2},{7:d3}" -f $newIn.hour, $newIn.Minute, $newIn.Second, $newIn.Millisecond, $newOut.hour, $newOut.Minute, $newOut.Second, $newOut.Millisecond) -Encoding UTF8
    } else { Add-Content $outputSRT $_ -Encoding UTF8 }
  }
}
