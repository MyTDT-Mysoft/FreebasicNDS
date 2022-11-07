''
''
'' input -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_input_bi__
#define __arm9_input_bi__

#include "nds/touch.bi"
#include "nds/input.bi"

declare sub scanKeys cdecl alias "scanKeys" ()
declare function keysCurrent cdecl alias "keysCurrent" () as uint32
declare function keysHeld cdecl alias "keysHeld" () as uint32
declare function keysDown cdecl alias "keysDown" () as uint32
declare function keysDownRepeat cdecl alias "keysDownRepeat" () as uint32
declare sub keysSetRepeat cdecl alias "keysSetRepeat" (byval setDelay as u8, byval setRepeat as u8)
declare function keysUp cdecl alias "keysUp" () as uint32
declare function touchReadXY cdecl alias "touchReadXY" () as touchPosition
declare sub touchRead cdecl alias "touchRead" (byval data as touchPosition ptr)

#endif
