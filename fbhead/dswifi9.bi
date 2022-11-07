''
''
'' dswifi9 -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dswifi9_bi__
#define __dswifi9_bi__

#include "dswifi_version.bi"

#define WIFIINIT_OPTION_USELED &h0002
#define WIFIINIT_OPTION_USEHEAP_128 &h0000
#define WIFIINIT_OPTION_USEHEAP_64 &h1000
#define WIFIINIT_OPTION_USEHEAP_256 &h2000
#define WIFIINIT_OPTION_USEHEAP_512 &h3000
#define WIFIINIT_OPTION_USECUSTOMALLOC &h4000
#define WIFIINIT_OPTION_HEAPMASK &hF000
#define WFLAG_PACKET_DATA &h0001
#define WFLAG_PACKET_MGT &h0002
#define WFLAG_PACKET_BEACON &h0004
#define WFLAG_PACKET_CTRL &h0008
#define WFLAG_PACKET_ALL &hFFFF
#define WFLAG_APDATA_ADHOC &h0001
#define WFLAG_APDATA_WEP &h0002
#define WFLAG_APDATA_WPA &h0004
#define WFLAG_APDATA_COMPATIBLE &h0008
#define WFLAG_APDATA_EXTCOMPATIBLE &h0010
#define WFLAG_APDATA_SHORTPREAMBLE &h0020
#define WFLAG_APDATA_ACTIVE &h8000

#define WFC_CONNECT	true
#define INIT_ONLY	false

enum WIFI_RETURN
	WIFI_RETURN_OK = 0
	WIFI_RETURN_LOCKFAILED = 1
	WIFI_RETURN_ERROR = 2
	WIFI_RETURN_PARAMERROR = 3
end enum

enum WIFI_STATS
	WSTAT_RXQUEUEDPACKETS
	WSTAT_TXQUEUEDPACKETS
	WSTAT_RXQUEUEDBYTES
	WSTAT_TXQUEUEDBYTES
	WSTAT_RXQUEUEDLOST
	WSTAT_TXQUEUEDREJECTED
	WSTAT_RXPACKETS
	WSTAT_RXBYTES
	WSTAT_RXDATABYTES
	WSTAT_TXPACKETS
	WSTAT_TXBYTES
	WSTAT_TXDATABYTES
	WSTAT_HW_1B0
	WSTAT_HW_1B1
	WSTAT_HW_1B2
	WSTAT_HW_1B3
	WSTAT_HW_1B4
	WSTAT_HW_1B5
	WSTAT_HW_1B6
	WSTAT_HW_1B7
	WSTAT_HW_1B8
	WSTAT_HW_1B9
	WSTAT_HW_1BA
	WSTAT_HW_1BB
	WSTAT_HW_1BC
	WSTAT_HW_1BD
	WSTAT_HW_1BE
	WSTAT_HW_1BF
	WSTAT_HW_1C0
	WSTAT_HW_1C1
	WSTAT_HW_1C4
	WSTAT_HW_1C5
	WSTAT_HW_1D0
	WSTAT_HW_1D1
	WSTAT_HW_1D2
	WSTAT_HW_1D3
	WSTAT_HW_1D4
	WSTAT_HW_1D5
	WSTAT_HW_1D6
	WSTAT_HW_1D7
	WSTAT_HW_1D8
	WSTAT_HW_1D9
	WSTAT_HW_1DA
	WSTAT_HW_1DB
	WSTAT_HW_1DC
	WSTAT_HW_1DD
	WSTAT_HW_1DE
	WSTAT_HW_1DF
	NUM_WIFI_STATS
end enum

enum WIFI_MODE
	WIFIMODE_DISABLED
	WIFIMODE_NORMAL
	WIFIMODE_SCAN
	WIFIMODE_ASSOCIATE
	WIFIMODE_ASSOCIATED
	WIFIMODE_DISASSOCIATE
	WIFIMODE_CANNOTASSOCIATE
end enum

enum WIFI_AUTHLEVEL
	WIFI_AUTHLEVEL_DISCONNECTED
	WIFI_AUTHLEVEL_AUTHENTICATED
	WIFI_AUTHLEVEL_ASSOCIATED
	WIFI_AUTHLEVEL_DEASSOCIATED
end enum

enum WIFIGETDATA
	WIFIGETDATA_MACADDRESS
	WIFIGETDATA_NUMWFCAPS
	MAX_WIFIGETDATA
end enum

enum WEPMODES
	WEPMODE_NONE = 0
	WEPMODE_40BIT = 1
	WEPMODE_128BIT = 2
end enum

enum WIFI_ASSOCSTATUS2
	ASSOCSTATUS_DISCONNECTED
	ASSOCSTATUS_SEARCHING
	ASSOCSTATUS_AUTHENTICATING
	ASSOCSTATUS_ASSOCIATING
	ASSOCSTATUS_ACQUIRINGDHCP
	ASSOCSTATUS_ASSOCIATED
	ASSOCSTATUS_CANNOTCONNECT
end enum

' **** fixme!! ****
extern ASSOCSTATUS_STRINGS alias "ASSOCSTATUS_STRINGS" as zstring ptr  

type WIFI_TXHEADER
	enable_flags as u16
	unknown as u16
	countup as u16
	beaconfreq as u16
	tx_rate as u16
	tx_length as u16
end type


type WIFI_RXHEADER
	a as u16
	b as u16
	c as u16
	d as u16
	byteLength as u16
	rssi_ as u16
end type

type WIFI_ACCESSPOINT
	ssid as zstring * 33
	ssid_len as byte
	bssid(0 to 6-1) as u8
	macaddr(0 to 6-1) as u8
	maxrate as u16
	timectr as u32
	rssi as u16
	flags as u16
	spinlock as u32
	channel as u8
	rssi_past(0 to 8-1) as u8
	base_rates(0 to 16-1) as u8
end type

type WifiPacketHandler as sub cdecl(byval as integer, byval as integer)
type WifiSyncHandler as sub cdecl()

declare function Wifi_Init cdecl alias "Wifi_Init" (byval initflags as integer) as uinteger
declare function Wifi_CheckInit cdecl alias "Wifi_CheckInit" () as integer
declare sub Wifi_DisableWifi cdecl alias "Wifi_DisableWifi" ()
declare sub Wifi_EnableWifi cdecl alias "Wifi_EnableWifi" ()
declare sub Wifi_SetPromiscuousMode cdecl alias "Wifi_SetPromiscuousMode" (byval enable as integer)
declare sub Wifi_ScanMode cdecl alias "Wifi_ScanMode" ()
declare sub Wifi_SetChannel cdecl alias "Wifi_SetChannel" (byval channel as integer)
declare function Wifi_GetNumAP cdecl alias "Wifi_GetNumAP" () as integer
declare function Wifi_GetAPData cdecl alias "Wifi_GetAPData" (byval apnum as integer, byval apdata as Wifi_AccessPoint ptr) as integer
declare function Wifi_FindMatchingAP cdecl alias "Wifi_FindMatchingAP" (byval numaps as integer, byval apdata as Wifi_AccessPoint ptr, byval match_dest as Wifi_AccessPoint ptr) as integer
declare function Wifi_ConnectAP cdecl alias "Wifi_ConnectAP" (byval apdata as Wifi_AccessPoint ptr, byval wepmode as integer, byval wepkeyid as integer, byval wepkey as ubyte ptr) as integer
declare sub Wifi_AutoConnect cdecl alias "Wifi_AutoConnect" ()
declare function Wifi_AssocStatus cdecl alias "Wifi_AssocStatus" () as integer
declare function Wifi_DisconnectAP cdecl alias "Wifi_DisconnectAP" () as integer
declare sub Wifi_Timer cdecl alias "Wifi_Timer" (byval num_ms as integer)
declare function Wifi_GetIP cdecl alias "Wifi_GetIP" () as uinteger
declare function Wifi_GetIPInfo cdecl alias "Wifi_GetIPInfo" (byval pGateway as in_addr ptr, byval pSnmask as in_addr ptr, byval pDns1 as in_addr ptr, byval pDns2 as in_addr ptr) as in_addr
declare sub Wifi_SetIP cdecl alias "Wifi_SetIP" (byval IPaddr as uinteger, byval gateway as uinteger, byval subnetmask as uinteger, byval dns1 as uinteger, byval dns2 as uinteger)
declare function Wifi_GetData cdecl alias "Wifi_GetData" (byval datatype as integer, byval bufferlen as integer, byval buffer as ubyte ptr) as integer
declare function Wifi_GetStats cdecl alias "Wifi_GetStats" (byval statnum as integer) as u32
declare function Wifi_RawTxFrame cdecl alias "Wifi_RawTxFrame" (byval datalen as ushort, byval rate as ushort, byval data as ushort ptr) as integer
declare sub Wifi_RawSetPacketHandler cdecl alias "Wifi_RawSetPacketHandler" (byval wphfunc as WifiPacketHandler)
declare function Wifi_RxRawReadPacket cdecl alias "Wifi_RxRawReadPacket" (byval packetID as integer, byval readlength as integer, byval data as ushort ptr) as integer
declare sub Wifi_Update cdecl alias "Wifi_Update" ()
declare sub Wifi_Sync cdecl alias "Wifi_Sync" ()
declare sub Wifi_SetSyncHandler cdecl alias "Wifi_SetSyncHandler" (byval sh as WifiSyncHandler)
declare function Wifi_InitDefault cdecl alias "Wifi_InitDefault" (byval useFirmwareSettings as integer) as integer

#endif
