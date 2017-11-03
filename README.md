This is a script to add a constant offset to all the subtitles in an SRT file

To run it open a powershell window (windows-R and type powershell.exe), then type
`cd` <the folder you saved the script into, eg: 
  `cd c:\users\stib\downloads\`
then type
  `import-module offset-srtSubtitles.ps1`
then use the script thus:
  `Offset-SRTSubtitles 'c:\path\to\mySRTFile.srt' -outputSRT "c:\path\to\newSRTfile.srt" -Hours 1 -Minutes 2 -Seconds -3 -Frames 2`

The inputSRT is the first parameter, it is the path to your source srt. outputSRT can be specified, or it will be based on the input file with the tag \_offset on the end of the name, eg **inputsrt_offset.srt**
Other parameters are

 `-Hours` - the hours offset. Don't specify any offsets that are 0. Offsets can be positive or negative integers
 `-Minutes` - the minutes offset
 `-Seconds` - you get the idea
 `-Milliseconds` or `-Frames` If `-Frames` is specified, `-Milliseconds` is ignored
 `-Framerate` - only needed if `-Frames` is specified, default is 25  
