''
''
'' dirent -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dirent_bi__
#define __dirent_bi__

#include once "dir.bi"
#include once "syslimits.bi"

#define	DT_UNKNOWN	 0
#define	DT_FIFO		 1
#define	DT_CHR		 2
#define	DT_DIR		 4
#define	DT_BLK		 6
#define	DT_REG		 8
#define	DT_LNK		10
#define	DT_SOCK		12
#define	DT_WHT		14

type dirent
	d_ino  as ino_t
  d_type as ubyte
	d_name as zstring * NAME_MAX+1
end type

type DIR
	position as integer
	dirData as DIR_ITER ptr
	fileData as dirent
end type

declare function closedir cdecl alias "closedir" (byval dirp as DIR ptr) as integer
declare function opendir cdecl alias "opendir" (byval dirname as zstring ptr) as DIR ptr
declare function readdir cdecl alias "readdir" (byval dirp as DIR ptr) as dirent ptr
declare function readdir_r cdecl alias "readdir_r" (byval dirp as DIR ptr, byval entry as dirent ptr, byval result as dirent ptr ptr) as integer
declare sub rewinddir cdecl alias "rewinddir" (byval dirp as DIR ptr)
declare sub seekdir cdecl alias "seekdir" (byval dirp as DIR ptr, byval loc as integer)
declare function telldir cdecl alias "telldir" (byval dirp as DIR ptr) as integer

#endif
