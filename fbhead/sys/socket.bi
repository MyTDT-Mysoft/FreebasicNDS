''
''
'' socket -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __socket_bi__
#define __socket_bi__

#define SOL_SOCKET &hfff
#define SOL_TCP 6
#define PF_UNSPEC 0
#define PF_INET 2
#define PF_INET6 10
#define AF_UNSPEC 0
#define AF_INET 2
#define AF_INET6 10
#define SOCK_STREAM 1
#define SOCK_DGRAM 2
#define FIONBIO 1
#define FIONREAD 2
#define SOCKET_ERROR -1
#define MSG_WAITALL &h40000000
#define MSG_TRUNC &h20000000
#define MSG_PEEK &h10000000
#define MSG_OOB &h08000000
#define MSG_EOR &h04000000
#define MSG_DONTROUTE &h02000000
#define MSG_CTRUNC &h01000000
#define SHUT_RD 1
#define SHUT_WR 2
#define SHUT_RDWR 3
#define SO_DEBUG &h0001
#define SO_ACCEPTCONN &h0002
#define SO_REUSEADDR &h0004
#define SO_KEEPALIVE &h0008
#define SO_DONTROUTE &h0010
#define SO_BROADCAST &h0020
#define SO_USELOOPBACK &h0040
#define SO_LINGER &h0080
#define SO_DONTLINGER cast(integer,not SO_LINGER)
#define SO_OOBINLINE &h0100
#define SO_REUSEPORT &h0200
#define SO_SNDBUF &h1001
#define SO_RCVBUF &h1002
#define SO_SNDLOWAT &h1003
#define SO_RCVLOWAT &h1004
#define SO_SNDTIMEO &h1005
#define SO_RCVTIMEO &h1006
#define SO_ERROR &h1007
#define SO_TYPE &h1008

type sockaddr
	sa_family as ushort
	sa_data as zstring * 14
end type

declare function ssocket cdecl alias "socket" (byval domain as integer, byval type as integer, byval protocol as integer) as integer
declare function sbind cdecl alias "bind" (byval socket as integer, byval addr as sockaddr ptr, byval addr_len as integer) as integer
declare function sconnect cdecl alias "connect" (byval socket as integer, byval addr as sockaddr ptr, byval addr_len as integer) as integer
declare function ssend cdecl alias "send" (byval socket as integer, byval data as any ptr, byval sendlength as integer, byval flags as integer) as integer
declare function srecv cdecl alias "recv" (byval socket as integer, byval data as any ptr, byval recvlength as integer, byval flags as integer) as integer
declare function ssendto cdecl alias "sendto" (byval socket as integer, byval data as any ptr, byval sendlength as integer, byval flags as integer, byval addr as sockaddr ptr, byval addr_len as integer) as integer
declare function srecvfrom cdecl alias "recvfrom" (byval socket as integer, byval data as any ptr, byval recvlength as integer, byval flags as integer, byval addr as sockaddr ptr, byval addr_len as integer ptr) as integer
declare function slisten cdecl alias "listen" (byval socket as integer, byval max_connections as integer) as integer
declare function saccept cdecl alias "accept" (byval socket as integer, byval addr as sockaddr ptr, byval addr_len as integer ptr) as integer
declare function sshutdown cdecl alias "shutdown" (byval socket as integer, byval shutdown_type as integer) as integer
declare function sclosesocket cdecl alias "closesocket" (byval socket as integer) as integer
declare function sioctl cdecl alias "ioctl" (byval socket as integer, byval cmd as integer, byval arg as any ptr) as integer
declare function ssetsockopt cdecl alias "setsockopt" (byval socket as integer, byval level as integer, byval option_name as integer, byval data as any ptr, byval data_len as integer) as integer
declare function sgetsockopt cdecl alias "getsockopt" (byval socket as integer, byval level as integer, byval option_name as integer, byval data as any ptr, byval data_len as integer ptr) as integer
declare function sgetpeername cdecl alias "getpeername" (byval socket as integer, byval addr as sockaddr ptr, byval addr_len as integer ptr) as integer
declare function sgetsockname cdecl alias "getsockname" (byval socket as integer, byval addr as sockaddr ptr, byval addr_len as integer ptr) as integer
declare function sgethostname cdecl alias "gethostname" (byval name as zstring ptr, byval len as size_t) as integer
declare function ssethostname cdecl alias "sethostname" (byval name as zstring ptr, byval len as size_t) as integer
declare function shtons cdecl alias "htons" (byval num as ushort) as ushort
declare function shtonl cdecl alias "htonl" (byval num as uinteger) as uinteger
declare function sselect cdecl alias "select" (byval nfds as integer, byval readfds as integer ptr, byval writefds as integer ptr, byval errorfds as integer ptr, byval timeout as any ptr) as integer

#endif
