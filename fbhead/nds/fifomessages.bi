#ifndef FIFOMESSAGE_H
#define FIFOMESSAGE_H

#include "ndstypes.h"
#include "nds/touch.bi

'/* internal fifo messages utilized by libnds. */

enum FifoMessageType
	SOUND_PLAY_MESSAGE = &h1234
	SOUND_PSG_MESSAGE
	SOUND_NOISE_MESSAGE
	MIC_RECORD_MESSAGE
	MIC_BUFFER_FULL_MESSAGE
	SYS_INPUT_MESSAGE
	SYS_SD_READ_SECTORS
	SYS_SD_WRITE_SECTORS
  SDMMC_NAND_READ_SECTORS
	SDMMC_NAND_WRITE_SECTORS
end enum

type FifoMessage 'align 4 isnt enforced already???
  type as u16;
	union
		type SoundPlay
			as const any ptr* data
			as u32 dataSize
			as u16 loopPoint
			as u16 freq
			as u8 volume
			as u8 pan
			as _bool loop
			as u8 format
			as u8 channel
		end type
		type SoundPsg
			as u16 freq
			as u8 dutyCycle
			as u8 volume
			as u8 pan
			as u8 channel
		end type
		type MicRecord
			as any ptr buffer
			as u32 bufferLength
			as u16 freq
			as u8 format
		end type
		type MicBufferFull
			as any ptr buffer
			as u32 length
		end type
		type SystemInput
			as touchPosition touch
			as u16 keys
		end type		
		type sdParams
			as any ptr buffer
			u32 startsector
			u32	numsectors
		end type
    type blockParams
			as any ptr buffer
			as u32 address
			as u32 length
		end type
	end union
end type

#endif
