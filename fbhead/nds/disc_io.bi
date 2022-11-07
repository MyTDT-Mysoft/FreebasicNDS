''
''
'' disc_io -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __disc_io_bi__
#define __disc_io_bi__

#define FEATURE_MEDIUM_CANREAD  &h00000001
#define FEATURE_MEDIUM_CANWRITE &h00000002
#define FEATURE_SLOT_GBA        &h00000010
#define FEATURE_SLOT_NDS        &h00000020
#define DEVICE_TYPE_DSI_SD asc("i") or (asc("_") shl 8) or (asc("S" shl 16) or (asc("D") shl 24)

#ifndef sec_t
type sec_t as uinteger 'uint32_t
#endif

type FN_MEDIUM_STARTUP as function cdecl() as integer
type FN_MEDIUM_ISINSERTED as function cdecl() as integer
type FN_MEDIUM_READSECTORS as function cdecl (as sec_t,as sec_t,as any ptr) as integer
type FN_MEDIUM_WRITESECTORS as function cdecl (as sec_t,as sec_t,as any ptr) as integer
type FN_MEDIUM_CLEARSTATUS as function cdecl() as integer
type FN_MEDIUM_SHUTDOWN as function cdecl() as integer

type DISC_INTERFACE_STRUCT
	ioType as uinteger
	features as uinteger
	startup as FN_MEDIUM_STARTUP
	isInserted as FN_MEDIUM_ISINSERTED
	readSectors as FN_MEDIUM_READSECTORS
	writeSectors as FN_MEDIUM_WRITESECTORS
	clearStatus as FN_MEDIUM_CLEARSTATUS
	shutdown as FN_MEDIUM_SHUTDOWN
end type

type DISC_INTERFACE as DISC_INTERFACE_STRUCT
extern __io_dsisd alias "__io_dsisd" as DISC_INTERFACE

#endif
