#include once "sys/socket.bi"
#include once "netinet/in.bi"
#include once "netdb.bi"
#include once "dswifi9.bi"

type socket as integer
const TCP_NODELAY = &h0001
#define INVALID_SOCKET cuint(-1)
enum
  IPPROTO_TCP =   6
  IPPROTO_UDP =  17
  IPPROTO_RAW = 255
end enum
#ifndef timeval
type timeval
	tv_sec as integer
	tv_usec as integer
end type
#endif


'':::::
function hStart( byval verhigh as integer = 2, byval verlow as integer = 0 ) as integer
	'if Wifi_CheckInit() then
  '  'printf !"ARM7 not ready?\n"
  '  Wifi_DisableWifi()
  '  sleep 100,1
  '  Wifi_EnableWifi()
  '  sleep 100,1
  'end if
  return Wifi_InitDefault(WFC_CONNECT)  
	verhigh=2:verlow=0
end function

'':::::
function hShutdown( ) as integer

	return Wifi_DisconnectAP( )
	
end function
':::::

function hResolve(byval hostname as zstring ptr) as integer
	dim ia as in_addr
	dim hostentry as hostent ptr

	'' check if it's an ip address
	ia.S_addr = inet_addr( hostname )
	if ( cint(ia.S_addr) = INADDR_NONE ) then
		
		'' if not, assume it's a name, resolve it
		hostentry = gethostbyname( hostname )
		if ( hostentry = 0 ) then
			exit function
		end if
		
		function = *cptr( integer ptr, *hostentry->h_addr_list )
		
	else
	
		'' just return the address
		function = ia.S_addr
	
	end if
	
end function

'':::::
#define hOpenUDP() hOpen( IPPROTO_UDP )
function hOpen( byval proto as integer = IPPROTO_TCP ) as SOCKET  
  dim ts as SOCKET    
  dim as uinteger SockType = SOCK_STREAM
  if proto <> IPPROTO_TCP then SockType = SOCK_DGRAM
  ts = SSocket( AF_INET, SockType, 0 ) 'proto )
  if( ts = NULL ) then
		return NULL
	end if
	function = ts
	
end function

'':::::
function hConnect overload (s as SOCKET, ip as integer, port as integer ) as integer
	dim sa as sockaddr_in

	sa.sin_port			= shtons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= ip
  
  var iNoDelay = true, iWaterSz = 1
  ssetsockopt(s,SOL_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))  
  ssetsockopt(s,SOL_SOCKET,SO_SNDLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  ssetsockopt(s,SOL_SOCKET,SO_RCVLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))  
  function = sconnect( s, cptr( SOCKADDR ptr, @sa ), sizeof(sockaddr_in) ) <> SOCKET_ERROR
  
end function
function hConnect overload (s as SOCKET, ip as integer, port as integer, byref LocalIP as integer,byref LocalPort as integer) as integer
	dim sa as sockaddr_in

	sa.sin_port			= shtons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= ip  
  
  var iNoDelay = true, iWaterSz = 1
  ssetsockopt(s,SOL_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))  
  ssetsockopt(s,SOL_SOCKET,SO_SNDLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  ssetsockopt(s,SOL_SOCKET,SO_RCVLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))  
	var iResu = sconnect( s, cptr( SOCKADDR PTR, @sa ), sizeof(sockaddr_in) ) <> SOCKET_ERROR  
  
  if iResu then
    var iAddrSz =  sizeof( sockaddr_in )
    sgetsockname(s, cptr( SOCKADDR ptr, @sa ), @iAddrSz)
    LocalIP = sa.sin_addr.S_addr
    LocalPort = shtons(sa.sin_port)
  end if
  return iResu
  'LocalIP = sa.sin_addr.S_addr
  'LocalPort = shtons(sa.sin_port)
	
end function

'':::::
#define hBindUDP hBind
function hBind( byval s as SOCKET, byval port as integer, iIP as integer = INADDR_ANY ) as integer
	dim sa as sockaddr_in

	sa.sin_port			= shtons( port )
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= iIP
	
	function = sbind( s, cptr( any ptr ptr, @sa ), sizeof( sa ) ) <> SOCKET_ERROR
	
end function

#if 0
'':::::
function hListen( byval s as SOCKET, byval timeout as integer = SOMAXCONN ) as integer
	
	function = listen( s, timeout ) <> SOCKET_ERROR
	
end function
#endif

#if 0
'':::::
function hAccept overload ( byval s as SOCKET, byval sa as sockaddr_in ptr ) as SOCKET
	dim salen as integer 
	
	salen = sizeof( sockaddr_in )
	var iSock = saccept( s, cptr( sockaddr_in ptr, sa ), @salen )
  var iNoDelay = true, iWaterSz = 1
  ssetsockopt(iSock,SOL_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))  
  ssetsockopt(iSock,SOL_SOCKET,SO_SNDLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  ssetsockopt(iSock,SOL_SOCKET,SO_RCVLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))   
  return iSock

end function	
#endif

#if 0
'':::::
function hAccept( byval s as SOCKET, byref pIP as integer, byref pPORT as integer ) as SOCKET
  dim sa as sockaddr_in
	dim salen as integer = sizeof( sockaddr_in )
	var iSock = saccept( s, cptr( sockaddr_in ptr, sa ), @salen )
  var iNoDelay = true, iWaterSz = 1
  ssetsockopt(iSock,SOL_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))
  ssetsockopt(iSock,SOL_SOCKET,SO_SNDLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  ssetsockopt(iSock,SOL_SOCKET,SO_RCVLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  pIP = sa.sin_addr.S_addr
  pPORT = shtons(sa.sin_port)  
  return iSock

end function	
#endif

#if 0
'':::::
function hAccept( byval s as SOCKET ) as SOCKET  
  
  dim sa as sockaddr_in, salen as integer = sizeof( sockaddr_in )
	var iSock = saccept( s, cptr( sockaddr_in ptr, @sa ), @salen ) 
  var iNoDelay = true, iWaterSz = 1
  ssetsockopt(iSock,SOL_TCP,TCP_NODELAY,cast(any ptr,@iNoDelay),sizeof(iNoDelay))
  ssetsockopt(iSock,SOL_SOCKET,SO_SNDLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  ssetsockopt(iSock,SOL_SOCKET,SO_RCVLOWAT,cast(any ptr,@iWaterSz),sizeof(iWaterSz))
  return iSock
  
end function	
#endif

'':::::
#define hCloseUDP hClose
function hClose( byval s as SOCKET ) as integer
	sshutdown( s, 2 )	
	return sclosesocket( s )	
end function

'':::::
function hSend( byval s as SOCKET, byval buffer as zstring ptr, byval bytes as integer ) as integer

    function = ssend( s, buffer, bytes, 0 )
    
end function

'':::::
function hSendUDP( s as SOCKET, IP as ulong, Port as long, buffer as zstring ptr, bytes as long ) as integer  
  
  dim sa as sockaddr_in
	sa.sin_port			= shtons(port)
	sa.sin_family		= AF_INET
	sa.sin_addr.S_addr	= IP
  
  return sSendTo(s,buffer,bytes,null,cast(any ptr,@sa),len(sa))
end function

'':::::
function hReceive( byval s as SOCKET, byval buffer as zstring ptr, byval bytes as integer ) as integer

    function = srecv( s, buffer, bytes, 0 )
    
end function

'':::::
function hReceiveUDP( s as SOCKET,  byref pIP as long, byref pPORT as long , buffer as zstring ptr, bytes as long ) as integer    
  dim sa as sockaddr_in
  dim as integer cliAddrLen=sizeof(sockaddr_in)
  function = sRecvFrom(s,buffer,bytes,null,cast(any ptr,@sa),@cliAddrLen)
  pIP = sa.sin_addr.S_addr
  pPORT = shtons(sa.sin_port)  
end function

#if 0
'':::::
function hIPtoString( byval ip as integer ) as string
	dim ia as in_addr	
	ia.S_addr = ip	
	return  *inet_ntoa( ia )
end function
#endif

'':::::

#if 0
  'dim as uinteger NonBlocking = 1
  'sioctl( s , FIONBIO , @NonBlocking )
  'function = (sSend( s , @NonBlocking , 0 , 0 ) = 0)
  'NonBlocking = 0
  'sioctl( s , FIONBIO , @NonBlocking )
  
  'dim as integer NonBlocking = 1
  'sioctl( s , FIONBIO , @NonBlocking )
  'function = (sRecv( s , @NonBlocking , 0 , 0 ) = 0)
  'NonBlocking = 0
  'sioctl( s , FIONBIO , @NonBlocking )
#endif

function hSelect( s as SOCKET, CheckForWrite as integer = 0 , iDelayMS as integer = 0 ) as integer  
  if CheckForWrite then    
    if iDelayMS then
      var dTime = timer
      do
        var iToWrite = 0
        sioctl( s , 3, @iToWrite) 'FIONWRITE
        if iToWrite=0 then return -1
        sleep 1,1
      loop while (abs(timer-dTime)*1000) < iDelayMS
      return 0
    end if
    var iToWrite = 0
    sioctl( s , 3, @iToWrite) 'FIONWRITE
    return iToWrite = 0
    
  else
    if iDelayMS then
      var dTime = timer
      do
        var iToRead = -1
        sioctl( s , FIONREAD, @iToRead)
        if iToRead > 0 then return -1
        sleep 1,1        
      loop while (abs(timer-dTime)*1000) < iDelayMS
      return 0
    end if
    var iToRead = -1
    sioctl( s , FIONREAD, @iToRead)
    return iToRead > 0    
  end if
end function
function hSelectUDP( s as SOCKET, CheckForWrite as integer = 0, iDelayMS as integer = 0) as integer
  if CheckForWrite then
    dim as uinteger NonBlocking = 1
    sioctl( s , FIONBIO , @NonBlocking )
    'function = (sSendTo( s , @NonBlocking , 0 , 0 , 0 , 0 ) = 0)
    function = -1
    NonBlocking = 0
    sioctl( s , FIONBIO , @NonBlocking )
  else
    if iDelayMS then
      var dTime = timer , iToRead = -1      
      do
        sioctl( s , FIONREAD, @iToRead)
        if iToRead > 0 then return -1
        sleep 1,1
      loop while (abs(timer-dTime)*1000) < iDelayMS      
    else
      dim as uinteger NonBlocking = 1, iToRead = -1
      'sioctl( s , FIONBIO , @NonBlocking )
      sioctl( s , FIONREAD, @iToRead)
      function = iToRead > 0
      'NonBlocking = 0
      'sioctl( s , FIONBIO , @NonBlocking )
    end if
  end if
end function
#if 0
  function hSockInfo cdecl (ss as SOCKET, byref LocalIP as long, byref LocalPort as long ) as integer
    dim sa as sockaddr_in = any
    var iAddrSz =  sizeof( sockaddr_in )
    function = (sgetsockname(ss, cptr( PSOCKADDR, @sa ), @iAddrSz)=0)
    LocalIP = sa.sin_addr.S_addr
    LocalPort = htons(sa.sin_port)
  end function
#endif

#ifdef hReliableUDP
  type RelSockHdr 
    bMagic      as ubyte
    bCount      as ubyte
    iLen        as ushort
  end type    
  type ReliableSocketStruct
    dwMagic     as ulong
    hSock       as SOCKET
    bSend       as ubyte
    bSends      as ubyte
    bRecv       as ubyte
    bRecvS      as ubyte
    bConn    :1 as ubyte
    bDidRecv :1 as ubyte    
    bError   :1 as ubyte
    bReserved   as ubyte
    iPort       as ushort
    iIp         as ulong
    pSList(255) as any ptr
    pRList(255) as any ptr
  end type
  type ReliableSocket as ReliableSocketStruct ptr
  const cRelMagic = cvl("RUDP")
  function hOpenRDP cdecl () as ReliableSocket
    var pSock = cptr(ReliableSocket, calloc(sizeof(ReliableSocketStruct),1))
    pSock->dwMagic = cRelMagic
    pSock->hSock   = hOpenUDP()
    if pSock->hSock=0 then free(pSock): return 0
    return pSock
  end function
  function hCloseRDP cdecl (pSock as ReliableSocket) as long
    if pSock->dwMagic <> cRelMagic then return 0
    pSock->dwMagic = 0
    hCloseUDP(pSock->hSock)
    for N as integer = 0 to 255
      if pSock->pSList(N) then free( pSock->pSList(N) ):pSock->pSList(N)=0
      if pSock->pRList(N) then free( pSock->pRList(N) ):pSock->pRList(N)=0
    next N
    free(pSock)
    return 1
  end function  
  function hConnectRDP cdecl ( pSock as ReliableSocket, IP as long, Port as long ) as long
    if pSock->dwMagic <> cRelMagic then return 0 'bad magic
    if IP=0 or Port=0 then return 0
    if pSock->iIP or pSock->iPort then return 0
    pSock->iIP = IP : pSock->iPort = Port
    return 1
  end function
  function hBindRDP cdecl ( pSock as ReliableSocket , byval port as long , iIP as ulong = INADDR_ANY ) as integer
    if pSock->dwMagic <> cRelMagic then return 0 'bad magic
    return hBindUDP( pSock->hSock, port , iIP )
  end function
  function hSendRDP cdecl ( pSock as ReliableSocket, buffer as zstring ptr, bytes as long ) as long
    if pSock->dwMagic <> cRelMagic then return -1 'bad magic
    if pSock->iPort = 0 or pSock->iIP = 0 then return -1 'not connected
    if pSock->pSList(pSock->bSend) then 
      puts("no more slots")
      return -1 'no more slots
    end if
    var iSz = bytes+sizeof(RelSockHdr), pBuf = malloc(iSz)
    if pBuf = 0 then return -1 'out of memory
    pSock->pSList(pSock->bSend) = pBuf
    with *cptr(RelSockHdr ptr,pBuf)
      .bMagic = not (pSock->bSend)
      .bCount = pSock->bSend
      .iLen   = bytes
    end with
    memcpy(cptr(RelSockHdr ptr,pBuf)+1,buffer,bytes)    
    
    var iResu = hSendUDP( pSock->hSock , pSock->iIP , pSock->iPort , pBuf , iSz )
    'var iResu2 = hSendUDP( pSock->hSock , pSock->iIP , pSock->iPort , pBuf , iSz )
    'if iResu <= 0 then iResu=iResu2
    'iResu2 = hSendUDP( pSock->hSock , pSock->iIP , pSock->iPort , pBuf , iSz )
    'if iResu <= 0 then iResu=iResu2
    
    if iResu <> iSz then 
      pSock->pSList(pSock->bSend) = 0
      free(pBuf): return iif(iSz>0,iSz-sizeof(RelSockHdr),iSz) 'failed to send    
    end if
    
    pSock->pSList(pSock->bSend) = 0 'TODO: just zero on ACK
    pSock->bSend = (pSock->bSend+1) and 255
    free(pBuf) 'free for now as not resending
    return iSz-sizeof(RelSockHdr)      
  end function
  function hSelectRDP cdecl ( pSock as ReliableSocket , CheckForWrite as long = 0, iTimeoutMS as long = 0) as long
    'puts("SelectRDP")
    if pSock->dwMagic <> cRelMagic then return -1 'bad magic
    if pSock->iPort = 0 or pSock->iIP = 0 then return -1 'not connected
    'puts("Magic and connection fine.")
    if CheckForWrite then      
      'puts("checking for write!")
      'dim as double TMR = timer TODO: wait on send requires recv?
      var iCan = hSelectUDP( pSock->hSock , 1 )
      if pSock->bSends < 127 andalso iCan then return 1
      puts("not ready?")
      return 0      
    end if
    'puts("checking for read")
    for N as integer = 128 to 128+63
      var iN = (pSock->bRecv+N) and 255
      if pSock->pRList( iN ) = pSock then pSock->pRList( iN ) = 0
    next N
    if pSock->pRList( pSock->bRecv ) andalso pSock->pRList( pSock->bRecv )<>pSock then return 1
    'puts("need to fetch packet!")
    dim as double TMR = timer
    do
      var iMS = cint(int((timer-TMR)*1000))
      if iMS > iTimeoutMS then iMS = iTimeoutMS
      do
        'puts("Wait packet...")
        if hSelectUDP( pSock->hSock , 0 )=0 then exit do
        static as zstring*65536 zTemp = any
        dim as long iIP, iPort
        'puts("Receive packet...")
        var iResu = hReceiveUDP( pSock->hSock , iIP , iPort , zTemp , 65536 )
        'printf(!"Packet bytes=%i from %s:%i\n",iResu,hIpToString(iIP),iPort)
        if iResu <= 0 then 
          puts("socket receive failed.")
          'sleep
          pSock->bError = 1: return iResu
        end if
        'puts("received.")
        if iResu < sizeof(RelSockHdr) then 
          puts("socket received packet smaller than header... ignoring")
          sleep
          exit do
        end if        
        if iIP <> pSock->iIP or iPort <> pSock->iPort then 
          puts("socket received packet from wrong origin")
          sleep
          exit do
        end if        
        var h = cptr(RelSockHdr ptr,@zTemp)
        'printf(!"Magic=%i Num=%i Length=%i\n",h->bMagic,h->bCount,h->iLen)
        if h->bMagic <> cubyte(not (h->bCount)) then 
          puts("magic/checksum failed")
          sleep
          exit do
        end if        
        if h->iLen <> (iResu-sizeof(RelSockHdr)) then 
          puts("length is incorrect")
          exit do
        end if
        'printf(!"length is correct. (%i bytes)\n",iResu-sizeof(RelSockHdr))
        if pSock->bDidRecv = 0 then 
          'puts("First packet received... use its counter")
          pSock->bDidRecv=1 : pSock->bRecv = h->bCount-1
        end if
        'printf(!"CurCount=%i RecvCount=%i\n",pSock->bRecv,h->bCount)
        #if 0
          if abs(h->bCount-cubyte(pSock->bRecv))>127 then        
            puts("old packet received...")
            sleep
            exit do
          end if        
        #endif
        if pSock->pRList(h->bCount) then 
          'puts("packet received was already sent.")          
          exit do
        end if        
        var pBuf = malloc(iResu)
        if pBuf = 0 then pSock->bError = 1: return -1
        'puts("allocation for packet went fine")
        pSock->pRList(h->bCount) = pBuf
        memcpy( pBuf , @zTemp , iResu )
        'puts("packet stored on buffer")        
        dim as ubyte bActual = pSock->bRecv+1 
        pSock->bRecvS += 1
        
        pSock->bRecv=bActual: return 1
        'if (bActual = h->bCount) then pSock->bRecv=bActual: return 1
        
        puts("packet received but was not on correct order... retry?")
        if (pSock->bRecvS > 64) then
          puts("Too much packets received without ACK")
          sleep
        end if
        exit do
      loop
      if iMS >= iTimeoutMS then return 0
    loop
  end function  
  function hReceiveRDP cdecl ( pSock as ReliableSocket, buffer as zstring ptr , bytes as long ) as long
    if pSock->dwMagic <> cRelMagic then return -1 'bad magic
    if pSock->iPort = 0 or pSock->iIP = 0 then return -1 'not connected
    while pSock->pRList( pSock->bRecv )=0 or pSock->pRList( pSock->bRecv )=pSock
      if hSelectRDP( pSock , 0 , 65535 ) < 0 then return -1
    wend    
    var pBuf = pSock->pRList( pSock->bRecv )
    with *cptr(RelSockHdr ptr,pBuf)
      if .iLen < bytes then bytes = .iLen            
    end with
    
    memcpy( buffer , cptr(RelSockHdr ptr,pBuf)+1 , bytes )
    pSock->bRecvS -= 1
    free(pBuf): pSock->pRList( pSock->bRecv )=pSock
    'pSock->bRecv = (pSock->bRecv+1) and 255
    return bytes    
    
  end function
#endif
