''
''
'' bios -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __bios_bi__
#define __bios_bi__

#include "nds\ndstypes.bi"

#define COPY_MODE_HWORD		(0)
#define COPY_MODE_WORD		vBIT(26)
#define COPY_MODE_COPY		(0)
#define COPY_MODE_FILL		vBIT(24)

type getHeaderCallback as function cdecl(byval as u8 ptr, byval as u16 ptr, byval as u32) as integer
type getResultCallback as function cdecl(byval as u8 ptr) as integer
type getByteCallback as function cdecl(byval as u8 ptr) as u8


type DecompressionStream field=1
	getSize as getHeaderCallback
	getResult as getResultCallback
	readByte as getByteCallback
end type
type TDecompressionStream as DecompressionStream

type UnpackStruct field=1
	sourceSize as uint16
	sourceWidth as uint8
	destWidth as uint8
	dataOffset as uint32
end type

type TUnpackStruct as UnpackStruct
type PUnpackStruct as UnpackStruct ptr

declare sub swiSoftReset cdecl alias "swiSoftReset" ()
declare sub swiDelay cdecl alias "swiDelay" (byval duration as uint32)
declare function swiDivide cdecl alias "swiDivide" (byval numerator as integer, byval divisor as integer) as integer
declare function swiRemainder cdecl alias "swiRemainder" (byval numerator as integer, byval divisor as integer) as integer
declare sub swiDivMod cdecl alias "swiDivMod" (byval numerator as integer, byval divisor as integer, byval result as integer ptr, byval remainder as integer ptr)

#define COPY_MODE_HWORD (0)
#define COPY_MODE_COPY (0)

declare sub swiCopy cdecl alias "swiCopy" (byval source as any ptr, byval dest as any ptr, byval flags as integer)
declare sub swiFastCopy cdecl alias "swiFastCopy" (byval source as any ptr, byval dest as any ptr, byval flags as integer)
declare function swiSqrt cdecl alias "swiSqrt" (byval value as integer) as integer
declare function swiCRC16 cdecl alias "swiCRC16" (byval crc as uint16, byval data as any ptr, byval size as uint32) as uint16
declare function swiIsDebugger cdecl alias "swiIsDebugger" () as integer
declare sub swiUnpackBits cdecl alias "swiUnpackBits" (byval source as uint8 ptr, byval destination as uint32 ptr, byval params as PUnpackStruct)
declare sub swiDecompressLZSSWram cdecl alias "swiDecompressLZSSWram" (byval source as any ptr, byval destination as any ptr)
declare function swiDecompressLZSSVram cdecl alias "swiDecompressLZSSVram" (byval source as any ptr, byval destination as any ptr, byval toGetSize as uint32, byval __stream as TDecompressionStream ptr) as integer
declare function swiDecompressLZSSVramNTR cdecl alias "swiDecompressLZSSVramNTR" (byval source as any ptr, byval destination as any ptr, byval toGetSize as uint32, byval __stream as TDecompressionStream ptr) as integer
declare function swiDecompressLZSSVramTWL cdecl alias "swiDecompressLZSSVramTWL" (byval source as any ptr, byval destination as any ptr, byval toGetSize as uint32, byval __stream as TDecompressionStream ptr) as integer
declare function swiDecompressHuffman cdecl alias "swiDecompressHuffman" (byval source as any ptr, byval destination as any ptr, byval toGetSize as uint32, byval __stream as TDecompressionStream ptr) as integer
declare sub swiDecompressRLEWram cdecl alias "swiDecompressRLEWram" (byval source as any ptr, byval destination as any ptr)
declare function swiDecompressRLEVram cdecl alias "swiDecompressRLEVram" (byval source as any ptr, byval destination as any ptr, byval toGetSize as uint32, byval __stream as TDecompressionStream ptr) as integer

#endif
