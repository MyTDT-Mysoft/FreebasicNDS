''
''
'' ndstypes -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __ndstypes_bi__
#define __ndstypes_bi__

'would need to implement those trough the preprocessor and as of extern variables?
#if 0 
  #define ITCM_CODE	__attribute__((section(".itcm"), long_call))
  
  #define DTCM_DATA	__attribute__((section(".dtcm")))
  #define DTCM_BSS	__attribute__((section(".sbss")))
  
  #define TWL_CODE	__attribute__((section(".twl")))
  #define TWL_DATA	__attribute__((section(".twl")))
  #define TWL_BSS		__attribute__((section(".twl_bss")))
  
  'aligns a struct (and other types?) to m, making sure that the size of the struct is a multiple of m.
  #define ALIGN(m)	__attribute__((aligned (m)))
  
  'packs a struct (and other types?) so it won't include padding bytes.
#endif
#define PACKED field=1
#define packed_struct PACKED

type bool as byte
type uint8 as ubyte
type uint16 as ushort
type uint32 as ulong
type uint64 as ulongint
type int8 as byte
type int16 as short
type int32 as long
type int64 as longint
type float32 as single
type float64 as double
'type vuint8 as uint8
'type vuint16 as uint16
'type vuint32 as uint32
'type vuint64 as uint64
'type vint8 as int8
'type vint16 as int16
'type vint32 as int32
'type vint64 as int64
type vfloat32 as float32
type vfloat64 as float64
type u8 as ubyte
type u16 as ushort
type u32 as ulong
type u64 as ulongint
type s8 as byte
type s16 as short
type s32 as long
type s64 as longint

type vuint8 as u8
type vuint16 as u16
type vuint32 as u32
type vuint64 as u64
type vint8 as s8
type vint16 as s16
type vint32 as s32
type vint64 as s64

type vu8 as vuint8
type vu16 as vuint16
type vu32 as vuint32
type vu64 as vuint64
type vs8 as vint8
type vs16 as vint16
type vs32 as vint32
type vs64 as vint64

#ifndef sec_t
type sec_t as uint32
#endif

const false = 0
const true = not false

type VoidFn as sub cdecl()
type IntFn as sub cdecl()
type fp as sub cdecl()

'alias FunAlias
#macro AddCast(FunName,FunAlias,FunType)
function FunName (p as FunType) as FunType
  dim as any ptr pp
  asm
    ldr r0, $p
    str r0, $pp
  end asm
  return pp
end function
#endmacro
AddCast( cast_vu8, "cast_vu8__FB__INLINE__", u8 ptr)
AddCast(cast_vu16,"cast_vu16__FB__INLINE__",u16 ptr)
AddCast(cast_vu32,"cast_vu32__FB__INLINE__",u32 ptr)
AddCast(cast_vu64,"cast_vu64__FB__INLINE__",u64 ptr)
AddCast( cast_vs8, "cast_vs8__FB__INLINE__", s8 ptr)
AddCast(cast_vs16,"cast_vs16__FB__INLINE__",s16 ptr)
AddCast(cast_vs32,"cast_vs32__FB__INLINE__",s32 ptr)
AddCast(cast_vs64,"cast_vs64__FB__INLINE__",s64 ptr)

#define cast_vu8_ptr(_p)     ( *cast_vu8(cast( u8 ptr,_p)))
#define cast_vu16_ptr(_p)    (*cast_vu16(cast(u16 ptr,_p)))
#define cast_vu32_ptr(_p)    (*cast_vu32(cast(u32 ptr,_p)))
#define cast_vu64_ptr(_p)    (*cast_vu64(cast(u64 ptr,_p)))
#define cast_vuint16_ptr(_p) (*cast_vu16(cast(u16 ptr,_p)))
#define cast_vuint32_ptr(_p) (*cast_vu32(cast(u32 ptr,_p)))
#define cast_vuint64_ptr(_p) (*cast_vu64(cast(u64 ptr,_p)))
#define cast_vs8_ptr(_p)     ( *cast_vs8(cast( s8 ptr,_p)))
#define cast_vs16_ptr(_p)    (*cast_vs16(cast(s16 ptr,_p)))
#define cast_vs32_ptr(_p)    (*cast_vs32(cast(s32 ptr,_p)))
#define cast_vs64_ptr(_p)    (*cast_vs64(cast(s64 ptr,_p)))
#define cast_vint8_ptr(_p)   ( *cast_vs8(cast( s8 ptr,_p)))
#define cast_vint16_ptr(_p)  (*cast_vs16(cast(s16 ptr,_p)))
#define cast_vint32_ptr(_p)  (*cast_vs32(cast(s32 ptr,_p)))
#define cast_vint64_ptr(_p)  (*cast_vs64(cast(s64 ptr,_p)))

#define cptr_vu8_ptr(_p)     ( cast_vu8(cast( u8 ptr,_p)))
#define cptr_vu16_ptr(_p)    (cast_vu16(cast(u16 ptr,_p)))
#define cptr_vu32_ptr(_p)    (cast_vu32(cast(u32 ptr,_p)))
#define cptr_vu64_ptr(_p)    (cast_vu64(cast(u64 ptr,_p)))
#define cptr_vuint16_ptr(_p) (cast_vu16(cast(u16 ptr,_p)))
#define cptr_vuint32_ptr(_p) (cast_vu32(cast(u32 ptr,_p)))
#define cptr_vuint64_ptr(_p) (cast_vu64(cast(u64 ptr,_p)))
#define cptr_vs8_ptr(_p)     ( cast_vs8(cast( s8 ptr,_p)))
#define cptr_vs16_ptr(_p)    (cast_vs16(cast(s16 ptr,_p)))
#define cptr_vs32_ptr(_p)    (cast_vs32(cast(s32 ptr,_p)))
#define cptr_vs64_ptr(_p)    (cast_vs64(cast(s64 ptr,_p)))
#define cptr_vint8_ptr(_p)   ( cast_vs8(cast( s8 ptr,_p)))
#define cptr_vint16_ptr(_p)  (cast_vs16(cast(s16 ptr,_p)))
#define cptr_vint32_ptr(_p)  (cast_vs32(cast(s32 ptr,_p)))
#define cptr_vint64_ptr(_p)  (cast_vs64(cast(s64 ptr,_p)))

#endif
