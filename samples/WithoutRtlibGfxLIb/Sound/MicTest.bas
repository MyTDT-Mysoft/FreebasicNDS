#define ARM9

#include "crt.bi"
#include "nds.bi"

'//the record sample rate
const sample_rate = 22050

'//buffer to hold sound data for playback
dim shared as u16 ptr sound_buffer = 0

'//buffer which is written to by the arm7
dim shared as u16 ptr mic_buffer = 0

'//the length of the current data
dim shared as u32 data_length = 0

'//enough hold 5 seconds of 16bit audio
dim shared as u32 sound_buffer_size = sample_rate * 2 * 5

'//the mic buffer sent to the arm7 is a double buffer
'//every time it is half full the arm7 signals us so we can read the
'//data.  I want the buffer to swap about once per frame so i chose a
'//buffer size large enough to hold two frames of 16bit mic data
dim shared as u32 mic_buffer_size = (sample_rate * 2) / (1000/30)

'//mic stream handler
sub micHandler cdecl (buffer as any ptr, buffsize as integer)
	if sound_buffer=0 orelse (data_length > sound_buffer_size) then
    exit sub
  end if
		
	DC_InvalidateRange(buffer, buffsize)

	dmaCopy(buffer,cast(u8 ptr,sound_buffer) + data_length, buffsize)
	
	data_length += (buffsize)

	iprintf(".")
	
end sub

sub record()
	data_length = 0
	soundMicRecord(mic_buffer, mic_buffer_size, MicFormat_12Bit, sample_rate, @micHandler)
end sub

sub play()
	soundMicOff()
	soundEnable()
	iprintf(!"\ndata length: %i\n", data_length)
	soundPlaySample(sound_buffer, SoundFormat_16Bit, data_length, sample_rate, 127, 64, false, 0)
end sub

function main cdecl alias "main" () as integer
	dim as integer key
	dim as integer recording = false

  #define iifs(peva,psta,pstb) *cast(zstring ptr,iif(peva,@psta,@pstb))

	sound_buffer = cast(u16 ptr,malloc(sound_buffer_size))
	mic_buffer = cast(u16 ptr,malloc(mic_buffer_size))

	consoleDemoInit()

	iprintf(!"Press A to record / play\n")

	do
	
		scanKeys()
		key = keysDown()

		if (key and KEY_A) then		
			if recording then play() else record()
			recording = not recording
			iprintf(!"%s\n", iif(recording,@"recording",@"playing"))
		end if

		swiWaitForVBlank()

	loop
  
  return 0

end function
