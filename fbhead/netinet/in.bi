''
''
'' in -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __in_bi__
#define __in_bi__

#include "sys/socket.bi"

#define INADDR_ANY &h00000000
#define INADDR_BROADCAST &hFFFFFFFF
#define INADDR_NONE &hFFFFFFFF

type in_addr
	s_addr as uinteger
end type

type sockaddr_in
	sin_family as ushort
	sin_port as ushort
	sin_addr as in_addr
	sin_zero(0 to 8-1) as ubyte
end type

declare function inet_addr cdecl alias "inet_addr" (byval cp as zstring ptr) as uinteger
declare function inet_aton cdecl alias "inet_aton" (byval cp as zstring ptr, byval inp as in_addr ptr) as integer
declare function inet_ntoa cdecl alias "inet_ntoa" (byval in as in_addr) as zstring ptr

#endif
