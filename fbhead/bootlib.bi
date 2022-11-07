''
''
'' bootlib -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __bootlib_bi__
#define __bootlib_bi__

#define LOAD_DEFAULT_NDS 0
#define BOOTLIB_VERSION "1.2"

#ifdef ARM9
declare sub bootnds cdecl alias "bootnds" (filename as zstring ptr)
#endif


#ifdef ARM7
declare sub bootndsCheck cdecl alias "bootndsCheck" ()
#endif


#endif
