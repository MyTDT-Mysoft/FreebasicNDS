''
''
'' exceptions -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_exceptions_bi__
#define __arm9_exceptions_bi__

extern exceptionCPTR alias "exceptionC" as VoidFn
#define exceptionC (@exceptionCPTR)
extern exceptionStack alias "exceptionStack" as u32
extern exceptionRegistersPTR alias "exceptionRegisters" as s32
#define exceptionRegisters (@exceptionRegistersPTR)

declare sub enterException cdecl alias "enterException" ()
declare sub setExceptionHandler cdecl alias "setExceptionHandler" (byval handler as VoidFn)
declare sub defaultExceptionHandler cdecl alias "defaultExceptionHandler" ()
declare function getCPSR cdecl alias "getCPSR" () as u32

#endif
