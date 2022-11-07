''
''
'' mm_types -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __mm_types_bi__
#define __mm_types_bi__

type mm_word as uinteger
type mm_hword as ushort
type mm_byte as ubyte
type mm_sfxhand as ushort
type mm_bool as ubyte
type mm_addr as any ptr
type mm_reg as any ptr

enum mm_mode_enum
	MM_MODE_A
	MM_MODE_B
	MM_MODE_C
end enum


enum mm_stream_formats
	MM_STREAM_8BIT_MONO = &h0
	MM_STREAM_8BIT_STEREO = &h1
	MM_STREAM_16BIT_MONO = &h2
	MM_STREAM_16BIT_STEREO = &h3
end enum

type mm_callback as function cdecl(byval as mm_word, byval as mm_word) as mm_word
type mm_stream_func as function cdecl(byval as mm_word, byval as mm_addr, byval as mm_stream_formats) as mm_word

enum mm_reverbflags
	MMRF_MEMORY = &h01
	MMRF_DELAY = &h02
	MMRF_RATE = &h04
	MMRF_FEEDBACK = &h08
	MMRF_PANNING = &h10
	MMRF_LEFT = &h20
	MMRF_RIGHT = &h40
	MMRF_BOTH = &h60
	MMRF_INVERSEPAN = &h80
	MMRF_NODRYLEFT = &h100
	MMRF_NODRYRIGHT = &h200
	MMRF_8BITLEFT = &h400
	MMRF_16BITLEFT = &h800
	MMRF_8BITRIGHT = &h1000
	MMRF_16BITRIGHT = &h2000
	MMRF_DRYLEFT = &h4000
	MMRF_DRYRIGHT = &h8000
end enum


enum mm_reverbch
	MMRC_LEFT = 1
	MMRC_RIGHT = 2
	MMRC_BOTH = 3
end enum


type mmreverbcfg
	flags as mm_word
	memory as mm_addr
	delay as mm_hword
	rate as mm_hword
	feedback as mm_hword
	panning as mm_byte
end type

type mm_reverb_cfg as mmreverbcfg

enum mm_pmode
	MM_PLAY_LOOP
	MM_PLAY_ONCE
end enum


enum mm_mixmode
	MM_MIX_8KHZ
	MM_MIX_10KHZ
	MM_MIX_13KHZ
	MM_MIX_16KHZ
	MM_MIX_18KHZ
	MM_MIX_21KHZ
	MM_MIX_27KHZ
	MM_MIX_31KHZ
end enum


enum mm_stream_timer
	MM_TIMER0
	MM_TIMER1
	MM_TIMER2
	MM_TIMER3
end enum


type t_mmdssample
	loop_start as mm_word	
	union
	  loop_length as mm_word
   	  length as mm_word
	end union
	format as mm_byte
	repeat_mode as mm_byte
	base_rate as mm_hword
	data as mm_addr
end type

type mm_ds_sample as t_mmdssample

type t_mmsoundeffect
	union 
 	  as mm_word id
	  as mm_ds_sample ptr sample
	end union
	rate as mm_hword
	handle as mm_sfxhand
	volume as mm_byte
	panning as mm_byte
end type

type mm_sound_effect as t_mmsoundeffect

type t_mmgbasystem
	mixing_mode as mm_mixmode
	mod_channel_count as mm_word
	mix_channel_count as mm_word
	module_channels as mm_addr
	active_channels as mm_addr
	mixing_channels as mm_addr
	mixing_memory as mm_addr
	wave_memory as mm_addr
	soundbank as mm_addr
end type

type mm_gba_system as t_mmgbasystem

type t_mmdssystem
	mod_count as mm_word
	samp_count as mm_word
	mem_bank as mm_word ptr
	fifo_channel as mm_word
end type

type mm_ds_system as t_mmdssystem

type t_mmstream
	sampling_rate as mm_word
	buffer_length as mm_word
	callback as mm_stream_func
	format as mm_word
	timer as mm_word
	manual as mm_bool
end type

type mm_stream as t_mmstream

type t_mmlayer
	tick as mm_byte
	row as mm_byte
	position as mm_byte
	nrows as mm_byte
	global_volume as mm_byte
	speed as mm_byte
	active as mm_byte
	bpm as mm_byte
end type

type mm_modlayer as t_mmlayer

type tmm_voice
	source as mm_addr
	length as mm_word
	loop_start as mm_hword
	timer as mm_hword
	flags as mm_byte
	format as mm_byte
	repeat as mm_byte
	volume as mm_byte
	divider as mm_byte
	panning as mm_byte
	index as mm_byte
	reserved(0 to 1-1) as mm_byte
end type

type mm_voice as tmm_voice

enum 
	MMVF_FREQ = 2
	MMVF_VOLUME = 4
	MMVF_PANNING = 8
	MMVF_SOURCE = 16
	MMVF_STOP = 32
end enum

#endif
