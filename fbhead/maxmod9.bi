''
''
'' maxmod9 -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __maxmod9_bi__
#define __maxmod9_bi__

#inclib "mm9"

#include "mm_types.bi"

declare sub mmInitDefault cdecl alias "mmInitDefault" (byval soundbank_file as zstring ptr)
declare sub mmInitDefaultMem cdecl alias "mmInitDefaultMem" (byval soundbank as mm_addr)
declare sub mmInit cdecl alias "mmInit" (byval system as mm_ds_system ptr)
declare sub mmSelectMode cdecl alias "mmSelectMode" (byval mode as mm_mode_enum)
declare sub mmLoad cdecl alias "mmLoad" (byval module_ID as mm_word)
declare sub mmUnload cdecl alias "mmUnload" (byval module_ID as mm_word)
declare sub mmLoadEffect cdecl alias "mmLoadEffect" (byval sample_ID as mm_word)
declare sub mmUnloadEffect cdecl alias "mmUnloadEffect" (byval sample_ID as mm_word)
declare sub mmLockChannels cdecl alias "mmLockChannels" (byval bitmask as mm_word)
declare sub mmUnlockChannels cdecl alias "mmUnlockChannels" (byval bitmask as mm_word)
declare sub mmSetEventHandler cdecl alias "mmSetEventHandler" (byval handler as mm_callback)
declare sub mmSoundBankInMemory cdecl alias "mmSoundBankInMemory" (byval address as mm_addr)
declare sub mmSoundBankInFiles cdecl alias "mmSoundBankInFiles" (byval filename as zstring ptr)
declare sub mmSetCustomSoundBankHandler cdecl alias "mmSetCustomSoundBankHandler" (byval p_loader as mm_callback)
declare sub mmStart cdecl alias "mmStart" (byval module_ID as mm_word, byval mode as mm_pmode)
declare sub mmPause cdecl alias "mmPause" ()
declare sub mmResume cdecl alias "mmResume" ()
declare sub mmStop cdecl alias "mmStop" ()
declare sub mmPosition cdecl alias "mmPosition" (byval position as mm_word)
declare sub mmJingle cdecl alias "mmJingle" (byval module_ID as mm_word)
declare sub mmSetModuleVolume cdecl alias "mmSetModuleVolume" (byval volume as mm_word)
declare sub mmSetJingleVolume cdecl alias "mmSetJingleVolume" (byval volume as mm_word)
declare sub mmSetModuleTempo cdecl alias "mmSetModuleTempo" (byval tempo as mm_word)
declare sub mmSetModulePitch cdecl alias "mmSetModulePitch" (byval pitch as mm_word)
declare function mmActive cdecl alias "mmActive" () as mm_bool
declare function mmEffect cdecl alias "mmEffect" (byval sample_ID as mm_word) as mm_sfxhand
declare function mmEffectEx cdecl alias "mmEffectEx" (byval sound as mm_sound_effect ptr) as mm_sfxhand
declare sub mmEffectVolume cdecl alias "mmEffectVolume" (byval handle as mm_sfxhand, byval volume as mm_word)
declare sub mmEffectPanning cdecl alias "mmEffectPanning" (byval handle as mm_sfxhand, byval panning as mm_byte)
declare sub mmEffectRate cdecl alias "mmEffectRate" (byval handle as mm_sfxhand, byval rate as mm_word)
declare sub mmEffectScaleRate cdecl alias "mmEffectScaleRate" (byval handle as mm_sfxhand, byval factor as mm_word)
declare sub mmEffectCancel cdecl alias "mmEffectCancel" (byval handle as mm_sfxhand)
declare sub mmEffectRelease cdecl alias "mmEffectRelease" (byval handle as mm_sfxhand)
declare function mmEffectExt cdecl alias "mmEffectExt" (byval sound as mm_sound_effect ptr, byval sample as mm_ds_sample ptr) as mm_sfxhand
declare sub mmSetEffectsVolume cdecl alias "mmSetEffectsVolume" (byval volume as mm_word)
declare sub mmEffectCancelAll cdecl alias "mmEffectCancelAll" ()
declare sub mmStreamOpen cdecl alias "mmStreamOpen" (byval stream as mm_stream ptr)
declare sub mmStreamUpdate cdecl alias "mmStreamUpdate" ()
declare sub mmStreamClose cdecl alias "mmStreamClose" ()
declare function mmStreamGetPosition cdecl alias "mmStreamGetPosition" () as mm_word
declare sub mmReverbEnable cdecl alias "mmReverbEnable" ()
declare sub mmReverbConfigure cdecl alias "mmReverbConfigure" (byval config as mm_reverb_cfg ptr)
declare sub mmReverbStart cdecl alias "mmReverbStart" (byval channels as mm_reverbch)
declare sub mmReverbStop cdecl alias "mmReverbStop" (byval channels as mm_reverbch)
declare sub mmReverbDisable cdecl alias "mmReverbDisable" ()

#define MMCB_SONGREQUEST &h1A
#define MMCB_SAMPREQUEST &h1B
#define MMCB_DELETESONG &h1C
#define MMCB_DELETESAMPLE &h1D
#define MMCB_SONGMESSAGE &h2A
#define MMCB_SONGFINISHED &h2B

#define SampleSize(mulsz) ((((sampling_rate * delay * mulsz) / 1000) + 3) and (not 3)) / 4
#define mmReverbBufferSize(bit_depth,sampling_rate,delay) iif(bit_deph=16,SampleSize(2),SampleSize(1))
#undef SampleSize

#endif
