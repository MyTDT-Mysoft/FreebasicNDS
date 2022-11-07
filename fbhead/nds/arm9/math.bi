''
''
'' math -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __math_bi__
#define __math_bi__

#define REG_DIVCNT          (cast_vu16_ptr(&h04000280))
#define REG_DIV_NUMER       (cast_vs64_ptr(&h04000290))
#define REG_DIV_NUMER_L     (cast_vs32_ptr(&h04000290))
#define REG_DIV_NUMER_H     (cast_vs32_ptr(&h04000294))
#define REG_DIV_DENOM       (cast_vs64_ptr(&h04000298))
#define REG_DIV_DENOM_L     (cast_vs32_ptr(&h04000298))
#define REG_DIV_DENOM_H     (cast_vs32_ptr(&h0400029C))
#define REG_DIV_RESULT      (cast_vs64_ptr(&h040002A0))
#define REG_DIV_RESULT_L    (cast_vs32_ptr(&h040002A0))
#define REG_DIV_RESULT_H    (cast_vs32_ptr(&h040002A4))
#define REG_DIVREM_RESULT	  (cast_vs64_ptr(&h040002A8))
#define REG_DIVREM_RESULT_L	(cast_vs32_ptr(&h040002A8))
#define REG_DIVREM_RESULT_H	(cast_vs32_ptr(&h040002AC))

#define REG_SQRTCNT         (cast_vu16_ptr(&h040002B0))
#define REG_SQRT_PARAM      (cast_vs64_ptr(&h040002B8))
#define REG_SQRT_PARAM_L    (cast_vs32_ptr(&h040002B8))
#define REG_SQRT_PARAM_H    (cast_vs32_ptr(&h040002BC))
#define REG_SQRT_RESULT     (cast_vu32_ptr(&h040002B4))


#define DIV_64_64 2
#define DIV_64_32 1
#define DIV_32_32 0
#define DIV_BUSY (1 shl 15)
#define SQRT_64 1
#define SQRT_32 0
#define SQRT_BUSY (1 shl 15)

#macro WaitWhile(MyCond) 
while (MyCond)
  DoNothing()
Wend
#endmacro

#if 0
#define inttof32(n)          ((n) * (1 shl 12))
#define f32toint(n)          ((n) / (1 shl 12))
#define floattof32(n)        cint((n) * (1 shl 12))
#define f32tofloat(n)        ((csng(n)) / csng((1 shl 12)))
#endif


function divf32 cdecl alias "divf32__FB__INLINE__" (num as int32,den as int32) as int32
  REG_DIVCNT = DIV_64_32    
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  REG_DIV_NUMER = cast(int64,num) shl 12
  REG_DIV_DENOM_L = den
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  return (REG_DIV_RESULT_L)
end function 

function mulf32 cdecl alias "mulf32__FB__INLINE__" (a as int32 ,b as int32) as int32
  return cast(int32,(cast(longint,a) * cast(longint,b)) shr 12)
end function

function sqrtf32 cdecl alias "sqrtf32__FB__INLINE__" (a as int32) as int32
  REG_SQRTCNT = SQRT_64
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  REG_SQRT_PARAM = (cast(int64,a)) shl 12
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  return REG_SQRT_RESULT
end function

function div32 cdecl alias "div32__FB__INLINE__" (num as int32,den as int32) as int32
  REG_DIVCNT = DIV_32_32
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  REG_DIV_NUMER_L = num
  REG_DIV_DENOM_L = den
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  return (REG_DIV_RESULT_L)
end function

function mod32 cdecl alias "mod32__FB__INLINE__" (num as int32,den as int32) as int32
  REG_DIVCNT = DIV_32_32
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  REG_DIV_NUMER_L = num
  REG_DIV_DENOM_L = den
  Waitwhile(REG_DIVCNT and DIV_BUSY)
  return (REG_DIVREM_RESULT_L)
end function

function div64 cdecl alias "div64__FB__INLINE__" (num as int64,den as int32) as int32
  REG_DIVCNT = DIV_64_32
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  REG_DIV_NUMER = num
  REG_DIV_DENOM_L = den
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  return (REG_DIV_RESULT_L)
end function

function mod64 cdecl alias "mod64__FB__INLINE__" (num as int64,den as int32) as int32
  REG_DIVCNT = DIV_64_32
  WaitWhile(REG_DIVCNT and DIV_BUSY)
  REG_DIV_NUMER = num
  REG_DIV_DENOM_L = den
  Waitwhile(REG_DIVCNT and DIV_BUSY)
  return (REG_DIVREM_RESULT_L)
end function

function sqrt32 cdecl alias "sqrt32__FB__INLINE__" (a as integer) as u32
  REG_SQRTCNT = SQRT_32
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  REG_SQRT_PARAM_L = a
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  return REG_SQRT_RESULT
end function

function sqrt64 cdecl alias "sqrt64__FB__INLINE__" (a as longint) as u32
  REG_SQRTCNT = SQRT_64
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  REG_SQRT_PARAM = a
  WaitWhile(REG_SQRTCNT and SQRT_BUSY)
  return REG_SQRT_RESULT
end function

sub crossf32 cdecl alias "crossf32__FB__INLINE__" (a as int32 ptr,b as int32 ptr,result as int32 ptr)
  result[0] = mulf32(a[1], b[2]) - mulf32(b[1], a[2])
  result[1] = mulf32(a[2], b[0]) - mulf32(b[2], a[0])
  result[2] = mulf32(a[0], b[1]) - mulf32(b[0], a[1])
end sub

function dotf32 cdecl alias "dotf32__FB__INLINE__" (a as int32 ptr,b as int32 ptr) as integer
 return mulf32(a[0], b[0]) + mulf32(a[1], b[1]) + mulf32(a[2], b[2])
end function

sub normalizef32 cdecl alias "normalizef32__FB__INLINE__" (a as int32 ptr)
  '// magnitude = sqrt ( Ax^2 + Ay^2 + Az^2 )
  dim as int32 magnitude = sqrtf32( mulf32(a[0], a[0]) + mulf32(a[1], a[1]) + mulf32(a[2], a[2]) )
  a[0] = divf32(a[0], magnitude)
  a[1] = divf32(a[1], magnitude)
  a[2] = divf32(a[2], magnitude)
end sub


#endif
