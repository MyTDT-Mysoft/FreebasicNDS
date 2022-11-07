''
''
'' sound -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_sound_bi__
#define __arm9_sound_bi__

#include "nds/ndstypes.bi"

type MicCallback as sub cdecl(byval as any ptr, byval as integer)

enum SoundFormat
	SoundFormat_16Bit = 1
	SoundFormat_8Bit = 0
	SoundFormat_PSG = 3
	SoundFormat_ADPCM = 2
end enum


enum MicFormat
	MicFormat_8Bit = 1
	MicFormat_12Bit = 0
end enum


enum DutyCycle
	DutyCycle_0 = 7
	DutyCycle_12 = 0
	DutyCycle_25 = 1
	DutyCycle_37 = 2
	DutyCycle_50 = 3
	DutyCycle_62 = 4
	DutyCycle_75 = 5
	DutyCycle_87 = 6
end enum


declare sub soundEnable cdecl alias "soundEnable" ()
declare sub soundDisable cdecl alias "soundDisable" ()
declare function soundPlaySample cdecl alias "soundPlaySample" (byval data as any ptr, byval format as SoundFormat, byval dataSize as u32, byval freq as u16, byval volume as u8, byval pan as u8, byval loop as integer, byval loopPoint as u16) as integer
declare function soundPlayPSG cdecl alias "soundPlayPSG" (byval cycle as DutyCycle, byval freq as u16, byval volume as u8, byval pan as u8) as integer
declare function soundPlayNoise cdecl alias "soundPlayNoise" (byval freq as u16, byval volume as u8, byval pan as u8) as integer
declare sub soundPause cdecl alias "soundPause" (byval soundId as integer)
declare sub soundSetWaveDuty cdecl alias "soundSetWaveDuty" (byval soundId as integer, byval cycle as DutyCycle)
declare sub soundKill cdecl alias "soundKill" (byval soundId as integer)
declare sub soundResume cdecl alias "soundResume" (byval soundId as integer)
declare sub soundSetVolume cdecl alias "soundSetVolume" (byval soundId as integer, byval volume as u8)
declare sub soundSetPan cdecl alias "soundSetPan" (byval soundId as integer, byval pan as u8)
declare sub soundSetFreq cdecl alias "soundSetFreq" (byval soundId as integer, byval freq as u16)
declare function soundMicRecord cdecl alias "soundMicRecord" (byval buffer as any ptr, byval bufferLength as u32, byval format as MicFormat, byval freq as integer, byval callback as MicCallback) as integer
declare sub soundMicOff cdecl alias "soundMicOff" ()

#endif
