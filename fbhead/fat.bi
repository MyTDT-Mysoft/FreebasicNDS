''
''
'' fat -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __fat_bi__
#define __fat_bi__

#include "libfatversion.bi"
#include "nds/disc_io.bi"

'Initialise any inserted block-devices.
'Add the fat device driver to the devoptab, making it available for standard file functions.
'cacheSize: The number of pages to allocate for each inserted block-device
'setAsDefaultDevice: if true, make this the default device driver for file operations
declare function fatInit cdecl alias "fatInit" (byval cacheSize as uinteger, byval setAsDefaultDevice as integer) as integer

'Calls fatInit with setAsDefaultDevice = true and cacheSize optimised for the host system.
declare function fatInitDefault cdecl alias "fatInitDefault" () as integer

'Mount the device pointed to by interface, and set up a devoptab entry for it as "name:".
'You can then access the filesystem using "name:/".
'This will mount the active partition or the first valid partition on the disc, 
'and will use a cache size optimized for the host system.
declare function fatMountSimple cdecl alias "fatMountSimple" (byval name as zstring ptr, byval interface as DISC_INTERFACE ptr) as integer

'Mount the device pointed to by interface, and set up a devoptab entry for it as "name:".
'You can then access the filesystem using "name:/".
'If startSector = 0, it will mount the active partition of the first valid partition on
'the disc. Otherwise it will try to mount the partition starting at startSector.
'cacheSize specifies the number of pages to allocate for the cache.
'This will not startup the disc, so you need to call interface->startup(); first.
declare function fatMount cdecl alias "fatMount" (byval name as zstring ptr, byval interface as DISC_INTERFACE ptr, byval startSector as sec_t, byval cacheSize as uinteger, byval SectorsPerPage as uinteger) as integer

'Unmount the partition specified by name.
'If there are open files, it will attempt to synchronise them to disc.
declare sub fatUnmount cdecl alias "fatUnmount" (byval name as zstring ptr)

'Get Volume Label
declare sub fatGetVolumeLabel cdecl alias "fatGetVolumeLabel" (byval name as zstring ptr, label as zstring ptr)

'File attributes
const  ATTR_ARCHIVE   = &h20  'Archive
const  ATTR_DIRECTORY = &h10  'Directory
const  ATTR_VOLUME    = &h08  'Volume
const  ATTR_SYSTEM    = &h04  'System
const  ATTR_HIDDEN    = &h02  'Hidden
const  ATTR_READONLY  = &h01  'Read only

'Methods to modify DOS File Attributes
declare function FAT_getAttr cdecl alias "FAT_getAttr" (file as const zstring ptr) as integer
declare function FAT_setAttr cdecl alias "FAT_setAttr" (file as const zstring ptr, attr as integer ) as integer

#endif
