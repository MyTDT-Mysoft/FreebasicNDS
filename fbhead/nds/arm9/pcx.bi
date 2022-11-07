''
''
'' pcx -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __pcx_bi__
#define __pcx_bi__

type PCXHeader field=1
	manufacturer as byte
	version as byte
	encoding as byte
	bitsPerPixel as byte
	xmin as short
	ymin as short
	xmax as short
	ymax as short
	hres as short
	vres as short
	palette16 as zstring * 48
	reserved as byte
	colorPlanes as byte
	bytesPerLine as short
	paletteYype as short
	filler as zstring * 58
end type

type pPCXHeader as PCXHeader ptr

declare function loadPCX cdecl alias "loadPCX" (byval pcx as ubyte ptr, byval image as sImage ptr) as integer

#endif
