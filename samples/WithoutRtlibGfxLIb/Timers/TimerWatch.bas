#define ARM9

#include "crt.bi"
#include "nds.bi"
 
'//the speed of the timer when using ClockDivider_1024
#define TIMER_SPEED (BUS_CLOCK/1024)

enum TimerStates
	timerState_Stop
	timerState_Pause
	timerState_Running
end enum


function main alias "main" () as integer

	consoleDemoInit()

	dim as uinteger ticks = 0
	dim as TimerStates state = timerState_Stop
	dim as uinteger down = keysDown()

	while((down and KEY_START)=0)	
		swiWaitForVBlank()
		consoleClear()
		scanKeys()
		down = keysDown()

		if state = timerState_Running then		
			ticks += timerElapsed(0)
		end if

		if (down and KEY_A) then		
			if state = timerState_Stop then			
				timerStart(0, ClockDivider_1024, 0, null)
				state = timerState_Running
			elseif (state = timerState_Pause) then			
				timerUnpause(0)
				state = timerState_Running		
			elseif (state = timerState_Running) then			
				'ticks = timerPause(0)
				state = timerState_Pause
			end if		
		elseif(down and KEY_B) then		
			timerStop(0)
			ticks = 0
      state = timerState_Stop
		end if

		iprintf(!"Press A to start and pause the \ntimer, B to clear the timer \nand start to quit the program.\n\n")
		iprintf(!"ticks:  %u\n", ticks)
		iprintf(!"second: %u:%u\n", ticks\TIMER_SPEED, ((ticks mod TIMER_SPEED)*1000)\TIMER_SPEED)
	wend

	if(state <> timerState_Stop) then	
		timerStop(0)
	end if

	return 0
end function
