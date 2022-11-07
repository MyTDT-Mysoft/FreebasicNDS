''
''
'' fifocommon -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __fifocommon_bi__
#define __fifocommon_bi__

enum FifoChannels
	FIFO_PM       =  0 ''fifo channel reserved for power management.
	FIFO_SOUND    =  1 ''for sound access.
	FIFO_SYSTEM   =  2 ''for system functions.
	FIFO_MAXMOD   =  3 ''for the maxmod library.
	FIFO_DSWIFI   =  4 ''for the dswifi library.
	FIFO_SDMMC    =  5 ''for dsi sdmmc control.
  FIFO_FIRMWARE =  6 ''for firmware access.
	FIFO_RSVD_01  =  7 ''FIFO_RSVD_02
	FIFO_USER_01  =  8 ''available for users.
	FIFO_USER_02  =  9 ''available for users.
	FIFO_USER_03  = 10 ''available for users.
	FIFO_USER_04  = 11 ''available for users.
	FIFO_USER_05  = 12 ''available for users.
	FIFO_USER_06  = 13 ''available for users.
	FIFO_USER_07  = 14 ''available for users.
	FIFO_USER_08  = 15 ''available for users.
end enum

'' Enum values for the fifo sound commands.
enum FifoSoundCommand
	SOUND_SET_PAN        =  0 shl 20
	SOUND_SET_VOLUME     =  1 shl 20
	SOUND_SET_FREQ       =  2 shl 20
	SOUND_SET_WAVEDUTY   =  3 shl 20
	SOUND_MASTER_ENABLE  =  4 shl 20
	SOUND_MASTER_DISABLE =  5 shl 20
	SOUND_PAUSE          =  6 shl 20
	SOUND_RESUME         =  7 shl 20
	SOUND_KILL           =  8 shl 20
	SOUND_SET_MASTER_VOL =  9 shl 20
	MIC_STOP             = 10 shl 20
end enum

'' Enum values for the fifo system commands.
enum FifoSystemCommands
	SYS_REQ_TOUCH
	SYS_REQ_KEYS
	SYS_REQ_TIME
	SYS_SET_TIME
	SYS_HAVE_SD
	SYS_SD_START
	SYS_SD_IS_INSERTED
	SYS_SD_STOP
end enum

enum FifoSdmmcCommands
	SDMMC_HAVE_SD
	SDMMC_SD_START
	SDMMC_SD_IS_INSERTED
	SDMMC_SD_STOP
	SDMMC_NAND_START
	SDMMC_NAND_STOP
	SDMMC_NAND_SIZE
end enum

enum FifoFirmwareCommands
	FW_READ
	FW_WRITE
end enum

'' Enum values for the fifo power management commands.
enum FifoPMCommands
	PM_REQ_ON            = (1 shl 16)
	PM_REQ_OFF           = (2 shl 16)
	PM_REQ_LED           = (3 shl 16)
	PM_REQ_SLEEP         = (4 shl 16)
	PM_REQ_SLEEP_DISABLE = (5 shl 16)
	PM_REQ_SLEEP_ENABLE  = (6 shl 16)
	PM_REQ_BATTERY       = (7 shl 16)
	PM_REQ_SLOT1_DISABLE = (8 shl 16)
	PM_REQ_SLOT1_ENABLE  = (9 shl 16)
end enum

'' Enum values for the fifo wifi commands.
enum FifoWifiCommands
	WIFI_ENABLE
	WIFI_DISABLE
	WIFI_SYNC
	WIFI_STARTUP
end enum

enum PM_LedBlinkMode
	PM_LED_ON    = 0 'shl 4??
	PM_LED_SLEEP = 1
	PM_LED_BLINK = 3
end enum

type FifoAddressHandlerFunc as sub cdecl(byval as any ptr, byval as any ptr)
type FifoValue32HandlerFunc as sub cdecl(byval as u32, byval as any ptr)
type FifoDatamsgHandlerFunc as sub cdecl(byval as integer, byval as any ptr)

declare function fifoInit cdecl alias "fifoInit" () as integer
declare function fifoSendAddress cdecl alias "fifoSendAddress" (byval channel as integer, byval address as any ptr) as integer
declare function fifoSendValue32 cdecl alias "fifoSendValue32" (byval channel as integer, byval value32 as u32) as integer
declare function fifoSendDatamsg cdecl alias "fifoSendDatamsg" (byval channel as integer, byval num_bytes as integer, byval data_array as u8 ptr) as integer
declare function fifoSetAddressHandler cdecl alias "fifoSetAddressHandler" (byval channel as integer, byval newhandler as FifoAddressHandlerFunc, byval userdata as any ptr) as integer
declare function fifoSetValue32Handler cdecl alias "fifoSetValue32Handler" (byval channel as integer, byval newhandler as FifoValue32HandlerFunc, byval userdata as any ptr) as integer
declare function fifoSetDatamsgHandler cdecl alias "fifoSetDatamsgHandler" (byval channel as integer, byval newhandler as FifoDatamsgHandlerFunc, byval userdata as any ptr) as integer
declare function fifoCheckAddress cdecl alias "fifoCheckAddress" (byval channel as integer) as integer
declare function fifoCheckValue32 cdecl alias "fifoCheckValue32" (byval channel as integer) as integer
declare function fifoCheckDatamsg cdecl alias "fifoCheckDatamsg" (byval channel as integer) as integer
declare function fifoCheckDatamsgLength cdecl alias "fifoCheckDatamsgLength" (byval channel as integer) as integer
declare function fifoGetAddress cdecl alias "fifoGetAddress" (byval channel as integer) as any ptr
declare function fifoGetValue32 cdecl alias "fifoGetValue32" (byval channel as integer) as u32
declare function fifoGetDatamsg cdecl alias "fifoGetDatamsg" (byval channel as integer, byval buffersize as integer, byval destbuffer as u8 ptr) as integer

sub fifoWaitValue32 cdecl alias "fifoWaitValue32__FB__INLINE__" (channel as integer)
	while (0=fifoCheckValue32(channel)) : swiIntrWait(1,IRQ_FIFO_NOT_EMPTY) : wend
end sub

#endif
