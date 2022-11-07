''
''
'' trig_lut -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __ARM9_trig_lut_bi__
#define __ARM9_trig_lut_bi__

#define DEGREES_IN_CIRCLE (1 shl 15)
#define fixedToInt(n, bits) (cast(integer,(n) shr (bits)))
#define intToFixed(n, bits) (cast(integer,(n) shl (bits)))
#define floatToFixed(n, bits) (cast(integer,(n) * cast(single,(1 shl (bits)))))
#define fixedToFloat(n, bits) ((cast(single,(n)) / cast(single,(1 shl (bits))))
#define floorFixed(n, bits) (cast(integer,(n) and not(((1 shl (bits)) - 1))))
#define degreesToAngle(degrees) ((degrees) * DEGREES_IN_CIRCLE \ 360)
#define angleToDegrees(angle)   ((angle) * 360 / DEGREES_IN_CIRCLE)

declare function sinLerp cdecl alias "sinLerp" (byval angle as s16) as s16
declare function cosLerp cdecl alias "cosLerp" (byval angle as s16) as s16
declare function tanLerp cdecl alias "tanLerp" (byval angle as s16) as s32
declare function asinLerp cdecl alias "asinLerp" (byval par as s16) as s16
declare function acosLerp cdecl alias "acosLerp" (byval par as s16) as s16

#endif
