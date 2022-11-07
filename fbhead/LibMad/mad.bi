''
''
'' mad -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __mad_bi__
#define __mad_bi__

#define SIZEOF_INT 4
#define SIZEOF_LONG 4
#define SIZEOF_LONG_LONG 8
#define __MAD_VERSION_MAJOR__ 0
#define __MAD_VERSION_MINOR__ 15
#define __MAD_VERSION_PATCH__ 1
#define __MAD_VERSION_EXTRA__ " (beta)"
#define __MAD_VERSION__ "0.15.1 (beta)"
#define __MAD_PUBLISHYEAR__ "2000-2004"
#define __MAD_AUTHOR__ "Underbit Technologies, Inc."
#define __MAD_EMAIL__ "info@underbit.com"
extern mad_versionREF alias "mad_version" as ubyte
#define mad_version (*cptr(zstring ptr,@mad_versionREF))
extern mad_copyrightREF alias "mad_copyright" as ubyte
#define mad_copyright (*cptr(zstring ptr,@mad_copyrightREF))
extern mad_authorREF alias "mad_author" as ubyte
#define mad_author (*cptr(zstring ptr,@mad_authorREF))
extern mad_buildREF alias "mad_build" as ubyte
#define mad_build (*cptr(zstring ptr,@mad_buildREF))

type mad_fixed_t as integer
type mad_fixed64hi_t as integer
type mad_fixed64lo_t as uinteger
type mad_sample_t as mad_fixed_t

#define MAD_F_FRACBITS 28
#define MAD_F_SCALEBITS 28

declare function mad_f_abs cdecl alias "mad_f_abs" (byval as mad_fixed_t) as mad_fixed_t
declare function mad_f_div cdecl alias "mad_f_div" (byval as mad_fixed_t, byval as mad_fixed_t) as mad_fixed_t

type mad_bitptr
	byte as ubyte ptr
	cache as ushort
	left as ushort
end type

declare sub mad_bit_init cdecl alias "mad_bit_init" (byval as mad_bitptr ptr, byval as ubyte ptr)
declare function mad_bit_length cdecl alias "mad_bit_length" (byval as mad_bitptr ptr, byval as mad_bitptr ptr) as uinteger
declare function mad_bit_nextbyte cdecl alias "mad_bit_nextbyte" (byval as mad_bitptr ptr) as ubyte ptr
declare sub mad_bit_skip cdecl alias "mad_bit_skip" (byval as mad_bitptr ptr, byval as uinteger)
declare function mad_bit_read cdecl alias "mad_bit_read" (byval as mad_bitptr ptr, byval as uinteger) as uinteger
declare sub mad_bit_write cdecl alias "mad_bit_write" (byval as mad_bitptr ptr, byval as uinteger, byval as uinteger)
declare function mad_bit_crc cdecl alias "mad_bit_crc" (byval as mad_bitptr, byval as uinteger, byval as ushort) as ushort

type mad_timer_t
	seconds as integer
	fraction as uinteger
end type
extern mad_timer_zero alias "mad_timer_zero" as mad_timer_t

#define MAD_TIMER_RESOLUTION 352800000UL

enum mad_units
	MAD_UNITS_HOURS = -2
	MAD_UNITS_MINUTES = -1
	MAD_UNITS_SECONDS = 0
	MAD_UNITS_DECISECONDS = 10
	MAD_UNITS_CENTISECONDS = 100
	MAD_UNITS_MILLISECONDS = 1000
	MAD_UNITS_8000_HZ = 8000
	MAD_UNITS_11025_HZ = 11025
	MAD_UNITS_12000_HZ = 12000
	MAD_UNITS_16000_HZ = 16000
	MAD_UNITS_22050_HZ = 22050
	MAD_UNITS_24000_HZ = 24000
	MAD_UNITS_32000_HZ = 32000
	MAD_UNITS_44100_HZ = 44100
	MAD_UNITS_48000_HZ = 48000
	MAD_UNITS_24_FPS = 24
	MAD_UNITS_25_FPS = 25
	MAD_UNITS_30_FPS = 30
	MAD_UNITS_48_FPS = 48
	MAD_UNITS_50_FPS = 50
	MAD_UNITS_60_FPS = 60
	MAD_UNITS_75_FPS = 75
	MAD_UNITS_23_976_FPS = -24
	MAD_UNITS_24_975_FPS = -25
	MAD_UNITS_29_97_FPS = -30
	MAD_UNITS_47_952_FPS = -48
	MAD_UNITS_49_95_FPS = -50
	MAD_UNITS_59_94_FPS = -60
end enum

declare function mad_timer_compare cdecl alias "mad_timer_compare" (byval as mad_timer_t, byval as mad_timer_t) as integer
declare sub mad_timer_negate cdecl alias "mad_timer_negate" (byval as mad_timer_t ptr)
declare function mad_timer_abs cdecl alias "mad_timer_abs" (byval as mad_timer_t) as mad_timer_t
declare sub mad_timer_set cdecl alias "mad_timer_set" (byval as mad_timer_t ptr, byval as uinteger, byval as uinteger, byval as uinteger)
declare sub mad_timer_add cdecl alias "mad_timer_add" (byval as mad_timer_t ptr, byval as mad_timer_t)
declare sub mad_timer_multiply cdecl alias "mad_timer_multiply" (byval as mad_timer_t ptr, byval as integer)
declare function mad_timer_count cdecl alias "mad_timer_count" (byval as mad_timer_t, byval as mad_units) as integer
declare function mad_timer_fraction cdecl alias "mad_timer_fraction" (byval as mad_timer_t, byval as uinteger) as uinteger
declare sub mad_timer_string cdecl alias "mad_timer_string" (byval as mad_timer_t, byval as zstring ptr, byval as zstring ptr, byval as mad_units, byval as mad_units, byval as uinteger)

#define MAD_BUFFER_GUARD 8
#define MAD_BUFFER_MDLEN (511+2048+8)

enum mad_error
	MAD_ERROR_NONE = &h0000
	MAD_ERROR_BUFLEN = &h0001
	MAD_ERROR_BUFPTR = &h0002
	MAD_ERROR_NOMEM = &h0031
	MAD_ERROR_LOSTSYNC = &h0101
	MAD_ERROR_BADLAYER = &h0102
	MAD_ERROR_BADBITRATE = &h0103
	MAD_ERROR_BADSAMPLERATE = &h0104
	MAD_ERROR_BADEMPHASIS = &h0105
	MAD_ERROR_BADCRC = &h0201
	MAD_ERROR_BADBITALLOC = &h0211
	MAD_ERROR_BADSCALEFACTOR = &h0221
	MAD_ERROR_BADMODE = &h0222
	MAD_ERROR_BADFRAMELEN = &h0231
	MAD_ERROR_BADBIGVALUES = &h0232
	MAD_ERROR_BADBLOCKTYPE = &h0233
	MAD_ERROR_BADSCFSI = &h0234
	MAD_ERROR_BADDATAPTR = &h0235
	MAD_ERROR_BADPART3LEN = &h0236
	MAD_ERROR_BADHUFFTABLE = &h0237
	MAD_ERROR_BADHUFFDATA = &h0238
	MAD_ERROR_BADSTEREO = &h0239
end enum

type mad_stream
	buffer as ubyte ptr
	bufend as ubyte ptr
	skiplen as uinteger
	sync as integer
	freerate as uinteger
	this_frame as ubyte ptr
	next_frame as ubyte ptr
	ptr as mad_bitptr
	anc_ptr as mad_bitptr
	anc_bitlen as uinteger
	main_data as ubyte ptr ptr
	md_len as uinteger
	options as integer
	error as mad_error
end type

enum 
	MAD_OPTION_IGNORECRC = &h0001
	MAD_OPTION_HALFSAMPLERATE = &h0002
end enum

declare sub mad_stream_init cdecl alias "mad_stream_init" (byval as mad_stream ptr)
declare sub mad_stream_finish cdecl alias "mad_stream_finish" (byval as mad_stream ptr)
declare sub mad_stream_buffer cdecl alias "mad_stream_buffer" (byval as mad_stream ptr, byval as ubyte ptr, byval as uinteger)
declare sub mad_stream_skip cdecl alias "mad_stream_skip" (byval as mad_stream ptr, byval as uinteger)
declare function mad_stream_sync cdecl alias "mad_stream_sync" (byval as mad_stream ptr) as integer
declare function mad_stream_errorstr cdecl alias "mad_stream_errorstr" (byval as mad_stream ptr) as zstring ptr

enum mad_layer
	MAD_LAYER_I = 1
	MAD_LAYER_II = 2
	MAD_LAYER_III = 3
end enum

enum mad_mode
	MAD_MODE_SINGLE_CHANNEL = 0
	MAD_MODE_DUAL_CHANNEL = 1
	MAD_MODE_JOINT_STEREO = 2
	MAD_MODE_STEREO = 3
end enum

enum mad_emphasis
	MAD_EMPHASIS_NONE = 0
	MAD_EMPHASIS_50_15_US = 1
	MAD_EMPHASIS_CCITT_J_17 = 3
	MAD_EMPHASIS_RESERVED = 2
end enum

type mad_header
	layer as mad_layer
	mode as mad_mode
	mode_extension as integer
	emphasis as mad_emphasis
	bitrate as uinteger
	samplerate as uinteger
	crc_check as ushort
	crc_target as ushort
	flags as integer
	private_bits as integer
	duration as mad_timer_t
end type

type mad_frame
	header as mad_header
	options as integer
	sbsample(0 to 2-1, 0 to 36-1, 0 to 32-1) as mad_fixed_t
	overlap as mad_fixed_t ptr ptr ptr ptr ptr ptr ptr
end type

enum 
	MAD_FLAG_NPRIVATE_III = &h0007
	MAD_FLAG_INCOMPLETE = &h0008
	MAD_FLAG_PROTECTION = &h0010
	MAD_FLAG_COPYRIGHT = &h0020
	MAD_FLAG_ORIGINAL = &h0040
	MAD_FLAG_PADDING = &h0080
	MAD_FLAG_I_STEREO = &h0100
	MAD_FLAG_MS_STEREO = &h0200
	MAD_FLAG_FREEFORMAT = &h0400
	MAD_FLAG_LSF_EXT = &h1000
	MAD_FLAG_MC_EXT = &h2000
	MAD_FLAG_MPEG_2_5_EXT = &h4000
end enum

enum 
	MAD_PRIVATE_HEADER = &h0100
	MAD_PRIVATE_III = &h001f
end enum

declare sub mad_header_init cdecl alias "mad_header_init" (byval as mad_header ptr)
declare function mad_header_decode cdecl alias "mad_header_decode" (byval as mad_header ptr, byval as mad_stream ptr) as integer
declare sub mad_frame_init cdecl alias "mad_frame_init" (byval as mad_frame ptr)
declare sub mad_frame_finish cdecl alias "mad_frame_finish" (byval as mad_frame ptr)
declare function mad_frame_decode cdecl alias "mad_frame_decode" (byval as mad_frame ptr, byval as mad_stream ptr) as integer
declare sub mad_frame_mute cdecl alias "mad_frame_mute" (byval as mad_frame ptr)

type mad_pcm
	samplerate as uinteger
	channels as ushort
	length as ushort
	samples(0 to 2-1, 0 to 1152-1) as mad_fixed_t ptr
end type

type mad_synth
	filter(0 to 2-1, 0 to 2-1, 0 to 2-1, 0 to 16-1, 0 to 8-1) as mad_fixed_t ptr
	phase as uinteger
	pcm as mad_pcm
end type

enum 
	MAD_PCM_CHANNEL_SINGLE = 0
end enum

enum 
	MAD_PCM_CHANNEL_DUAL_1 = 0
	MAD_PCM_CHANNEL_DUAL_2 = 1
end enum

enum 
	MAD_PCM_CHANNEL_STEREO_LEFT = 0
	MAD_PCM_CHANNEL_STEREO_RIGHT = 1
end enum

declare sub mad_synth_init cdecl alias "mad_synth_init" (byval as mad_synth ptr)
declare sub mad_synth_mute cdecl alias "mad_synth_mute" (byval as mad_synth ptr)
declare sub mad_synth_frame cdecl alias "mad_synth_frame" (byval as mad_synth ptr, byval as mad_frame ptr)

enum mad_decoder_mode
	MAD_DECODER_MODE_SYNC = 0
	MAD_DECODER_MODE_ASYNC
end enum

enum mad_flow
	MAD_FLOW_CONTINUE = &h0000
	MAD_FLOW_STOP = &h0010
	MAD_FLOW_BREAK = &h0011
	MAD_FLOW_IGNORE = &h0020
end enum

type mad_decoder__NESTED__sync
	stream as mad_stream
	frame as mad_frame
	synth as mad_synth
end type

type mad_decoder__NESTED__async
	pid as integer
	in as integer
	out as integer
end type

type mad_decoder
	mode as mad_decoder_mode
	options as integer
	cb_data as any ptr
	input_func as function cdecl(byval as any ptr, byval as mad_stream ptr) as mad_flow
	header_func as function cdecl(byval as any ptr, byval as mad_header ptr) as mad_flow
	filter_func as function cdecl(byval as any ptr, byval as mad_stream ptr, byval as mad_frame ptr) as mad_flow
	output_func as function cdecl(byval as any ptr, byval as mad_header ptr, byval as mad_pcm ptr) as mad_flow
	error_func as function cdecl(byval as any ptr, byval as mad_stream ptr, byval as mad_frame ptr) as mad_flow
	message_func as function cdecl(byval as any ptr, byval as any ptr, byval as uinteger ptr) as mad_flow
	sync as mad_decoder__NESTED__sync ptr
	async as mad_decoder__NESTED__async
end type

declare sub mad_decoder_init cdecl alias "mad_decoder_init" (byval as mad_decoder ptr, byval as any ptr, byval as function cdecl(byval as any ptr, byval as mad_stream ptr) as mad_flow, byval as function cdecl(byval as any ptr, byval as mad_header ptr) as mad_flow, byval as function cdecl(byval as any ptr, byval as mad_stream ptr, byval as mad_frame ptr) as mad_flow, byval as function cdecl(byval as any ptr, byval as mad_header ptr, byval as mad_pcm ptr) as mad_flow, byval as function cdecl(byval as any ptr, byval as mad_stream ptr, byval as mad_frame ptr) as mad_flow, byval as function cdecl(byval as any ptr, byval as any ptr, byval as uinteger ptr) as mad_flow)
declare function mad_decoder_finish cdecl alias "mad_decoder_finish" (byval as mad_decoder ptr) as integer
declare function mad_decoder_run cdecl alias "mad_decoder_run" (byval as mad_decoder ptr, byval as mad_decoder_mode) as integer
declare function mad_decoder_message cdecl alias "mad_decoder_message" (byval as mad_decoder ptr, byval as any ptr, byval as uinteger ptr) as integer

#endif
