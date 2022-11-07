''
''
'' dynamicArray -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dynamicArray_bi__
#define __dynamicArray_bi__

type DynamicArray
	data as any ptr ptr
	cur_size as uinteger
end type

declare function DynamicArrayInit cdecl alias "DynamicArrayInit" (byval v as DynamicArray ptr, byval initialSize as uinteger) as any ptr
declare sub DynamicArrayDelete cdecl alias "DynamicArrayDelete" (byval v as DynamicArray ptr)
declare function DynamicArrayGet cdecl alias "DynamicArrayGet" (byval v as DynamicArray ptr, byval index as uinteger) as any ptr
declare function DynamicArraySet cdecl alias "DynamicArraySet" (byval v as DynamicArray ptr, byval index as uinteger, byval item as any ptr) as integer

#endif
