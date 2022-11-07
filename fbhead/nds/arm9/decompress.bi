''
''
'' decompress -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __decompress_bi__
#define __decompress_bi__

enum DecompressType
	LZ77
	LZ77Vram
	HUFF
	RLE
	RLEVram
end enum


declare sub decompress cdecl alias "decompress" (byval data as any ptr, byval dst as any ptr, byval type as DecompressType)
declare sub decompressStream cdecl alias "decompressStream" (byval data as any ptr, byval dst as any ptr, byval type as DecompressType, byval readCB as getByteCallback, byval getHeaderCB as getHeaderCallback)

#endif
