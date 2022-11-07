''
''
'' dswifi7 -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dswifi7_bi__
#define __dswifi7_bi__

#include "dswifi_version.bi"

type WifiSyncHandler as sub cdecl(byval as )

declare sub Read_Flash cdecl alias "Read_Flash" (byval address as integer, byval destination as zstring ptr, byval length as integer)
declare function PowerChip_ReadWrite cdecl alias "PowerChip_ReadWrite" (byval cmd as integer, byval data as integer) as integer
declare sub Wifi_Interrupt cdecl alias "Wifi_Interrupt" ()
declare sub Wifi_Update cdecl alias "Wifi_Update" ()
declare sub Wifi_Init cdecl alias "Wifi_Init" (byval WifiData as uinteger)
declare sub Wifi_Deinit cdecl alias "Wifi_Deinit" ()
declare sub Wifi_Sync cdecl alias "Wifi_Sync" ()
declare sub Wifi_SetSyncHandler cdecl alias "Wifi_SetSyncHandler" (byval sh as WifiSyncHandler)
declare sub installWifiFIFO cdecl alias "installWifiFIFO" ()

#endif
