#define ARM9

#include "crt.bi"
#include "nds.bi"

sub waitfor(keys as integer)
	scanKeys()
	while (keysDown() and keys) = 0	
		swiWaitForVBlank()
		scanKeys()
	wend
end sub

dim shared as integer channel = 0
dim shared as integer play = true

'//this function will be called by the timer.
sub timerCallBack cdecl ()
	if play then
		soundPause(channel)
	else
		soundResume(channel)    
  end if
	play = not play  
end sub

function main alias "main" () as integer
	
  soundEnable()
	channel = soundPlayPSG(DutyCycle_50, 10000, 64, 64)

	'//calls the timerCallBack function 5 times per second.
	timerStart(0, ClockDivider_1, TIMER_FREQ(4), @timerCallBack)
  
	waitfor(KEY_A)

	return 0
  
end function
