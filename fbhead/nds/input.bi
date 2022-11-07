''
''
'' input -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __input_bi__
#define __input_bi__

enum KEYPAD_BITS
	KEY_A      = vBIT( 0)
	KEY_B      = vBIT( 1)
	KEY_SELECT = vBIT( 2)
	KEY_START  = vBIT( 3)
	KEY_RIGHT  = vBIT( 4)
	KEY_LEFT   = vBIT( 5)
	KEY_UP     = vBIT( 6)
	KEY_DOWN   = vBIT( 7)
	KEY_R      = vBIT( 8)
	KEY_L      = vBIT( 9)
	KEY_X      = vBIT(10)
	KEY_Y      = vBIT(11)
	KEY_TOUCH  = vBIT(12)
	KEY_LID    = vBIT(13)
end enum

'Key input register.
'	On the ARM9, the hinge "button", the touch status, and the
'	X and Y buttons cannot be accessed directly.
#define	REG_KEYINPUT	cast_vuint16_ptr(&h04000130)

'Key input control register.
#define	REG_KEYCNT		cast_vuint16_ptr(&h04000132)

#endif
