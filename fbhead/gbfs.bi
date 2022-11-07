''
''
'' gbfs -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __gbfs_bi__
#define __gbfs_bi__

type GBFS_FILE
	magic as zstring * 16
	total_len as u32
	dir_off as u16
	dir_nmemb as u16
	reserved as zstring * 8
end type

type GBFS_FILE as any

type GBFS_ENTRY
	name as zstring * 24
	len as u32
	data_offset as u32
end type

type GBFS_ENTRY as any

declare sub gbfs_search_range cdecl alias "gbfs_search_range" (byval gbfs_1st_limit as u32, byval gbfs_2nd_start as u32, byval gbfs_2nd_limit as u32, byval gbfs_stride as u32)
declare function find_first_gbfs_file cdecl alias "find_first_gbfs_file" (byval start as any ptr) as GBFS_FILE ptr
declare function skip_gbfs_file cdecl alias "skip_gbfs_file" (byval file as GBFS_FILE ptr) as any ptr
declare function gbfs_get_obj cdecl alias "gbfs_get_obj" (byval file as GBFS_FILE ptr, byval name as zstring ptr, byval len as u32 ptr) as any ptr
declare function gbfs_get_nth_obj cdecl alias "gbfs_get_nth_obj" (byval file as GBFS_FILE ptr, byval n as size_t, byval name as zstring ptr, byval len as u32 ptr) as any ptr
declare function gbfs_copy_obj cdecl alias "gbfs_copy_obj" (byval dst as any ptr, byval file as GBFS_FILE ptr, byval name as zstring ptr) as any ptr
declare function gbfs_count_objs cdecl alias "gbfs_count_objs" (byval file as GBFS_FILE ptr) as size_t

#endif
