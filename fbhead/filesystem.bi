''
''
'' filesystem -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __filesystem_bi__
#define __filesystem_bi__

declare function nitroFSInit cdecl alias "nitroFSInit" (ppzroot as zstring ptr ptr) as integer

#endif
