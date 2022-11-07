''
''
'' cache -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __cache_bi__
#define __cache_bi__

declare sub IC_InvalidateAll cdecl alias "IC_InvalidateAll" ()
declare sub IC_InvalidateRange cdecl alias "IC_InvalidateRange" (byval base as any ptr, byval size as u32)
declare sub DC_FlushAll cdecl alias "DC_FlushAll" ()
declare sub DC_FlushRange cdecl alias "DC_FlushRange" (byval base as any ptr, byval size as u32)
declare sub DC_InvalidateAll cdecl alias "DC_InvalidateAll" ()
declare sub DC_InvalidateRange cdecl alias "DC_InvalidateRange" (byval base as any ptr, byval size as u32)

#endif
