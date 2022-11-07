''
''
'' dir -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dir_bi__
#define __dir_bi__

#include once "stat.bi"

type DIR_ITER
	device as integer
	dirStruct as any ptr
end type

declare function diropen cdecl alias "diropen" (byval path as zstring ptr) as DIR_ITER ptr
declare function dirreset cdecl alias "dirreset" (byval dirState as DIR_ITER ptr) as integer
declare function dirnext cdecl alias "dirnext" (byval dirState as DIR_ITER ptr, byval filename as zstring ptr, byval filestat as stat ptr) as integer
declare function dirclose cdecl alias "dirclose" (byval dirState as DIR_ITER ptr) as integer

#endif
