''
''
'' netdb -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __netdb_bi__
#define __netdb_bi__

type hostent
	h_name      as zstring ptr
	h_aliases   as byte ptr ptr
	h_addrtype  as integer
	h_length    as integer
	h_addr_list as byte ptr ptr
end type

declare function gethostbyname cdecl alias "gethostbyname" (byval name as zstring ptr) as hostent ptr

#endif
