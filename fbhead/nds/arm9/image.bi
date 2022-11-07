''
''
'' image -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __image_bi__
#define __image_bi__

type RGB_24
	r as ubyte
	g as ubyte
	b as ubyte
end type

union imageunion
  as u8 ptr data8
  as u16 ptr data16
  as u32 ptr  data32
end union

type sImage
  height as short
  width as short
  bpp as integer
  palette as ushort ptr
  image as imageunion
end type

type psImage as sImage ptr

declare sub image24to16 cdecl alias "image24to16" (byval img as sImage ptr)
declare sub image8to16 cdecl alias "image8to16" (byval img as sImage ptr)
declare sub image8to16trans cdecl alias "image8to16trans" (byval img as sImage ptr, byval transparentColor as u8)
declare sub imageDestroy_ cdecl alias "imageDestroy" (byval img as sImage ptr)
declare sub imageTileData cdecl alias "imageTileData" (byval img as sImage ptr)

#endif
