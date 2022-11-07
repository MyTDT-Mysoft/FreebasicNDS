''
''
'' keyboard -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_keyboard_bi__
#define __arm9_keyboard_bi__

type KeyChangeCallback as sub cdecl(byval as integer)

enum KeyboardState
	Lower = 0
	Upper = 1
	Numeric = 2
	Reduced = 3
end enum


type KeyMap
	mapDataPressed as u16 ptr
	mapDataReleased as u16 ptr
	keymap as integer ptr
	width as integer
	height as integer
end type

type Keyboard
	background as integer
	keyboardOnSub as integer
	offset_x as integer
	offset_y as integer
	grid_width as integer
	grid_height as integer
	state as KeyboardState
	shifted as integer
	visible as integer
	mappings(0 to 4-1) as KeyMap ptr
	tiles as u16 ptr
	tileLen as u32
	palette as u16 ptr
	paletteLen as u32
	mapBase as integer
	tileBase as integer
	tileOffset as integer
	scrollSpeed as u32
	OnKeyPressed as KeyChangeCallback
	OnKeyReleased as KeyChangeCallback
end type

enum Keys
	NOKEY = -1
	DVK_FOLD = -23
	DVK_TAB = 9
	DVK_BACKSPACE = 8
	DVK_CAPS = -15
	DVK_SHIFT = -14
	DVK_SPACE = 32
	DVK_MENU = -5
	DVK_ENTER = 10
	DVK_CTRL = -16
	DVK_UP = -17
	DVK_RIGHT = -18
	DVK_DOWN = -19
	DVK_LEFT = -20
	DVK_ALT = -26
end enum


declare function keyboardGetDefault cdecl alias "keyboardGetDefault" () as Keyboard ptr
declare function keyboardInit cdecl alias "keyboardInit" (byval keyboard as Keyboard ptr, byval layer as integer, byval type as BgType, byval size as BgSize, byval mapBase as integer, byval tileBase as integer, byval mainDisplay as integer, byval loadGraphics as integer) as Keyboard ptr
declare function keyboardDemoInit cdecl alias "keyboardDemoInit" () as Keyboard ptr
declare sub keyboardShow cdecl alias "keyboardShow" ()
declare sub keyboardHide cdecl alias "keyboardHide" ()
declare function keyboardGetKey cdecl alias "keyboardGetKey" (byval x as integer, byval y as integer) as integer
declare sub keyboardGetString cdecl alias "keyboardGetString" (byval buffer as zstring ptr, byval maxLen as integer)
declare function keyboardGetChar cdecl alias "keyboardGetChar" () as integer
declare function keyboardUpdate cdecl alias "keyboardUpdate" () as integer

#endif
