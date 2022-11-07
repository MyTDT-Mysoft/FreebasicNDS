''
''
'' console -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_console_bi__
#define __arm9_console_bi__

#include once "nds/ndstypes.bi"
#include once "nds/arm9/background.bi"

type ConsolePrint as function cdecl(byval as any ptr, byval as byte) as integer

type ConsoleFont
	gfx as u16 ptr
	pal as u16 ptr
	numColors as u16
	bpp as u8
	asciiOffset as u16
	numChars as u16
	convertSingleColor as integer
end type

'dim ConsoleFont as ConsoleFont 'type ConsoleFont as any

type PrintConsole
	font as ConsoleFont
	fontBgMap as u16 ptr
	fontBgGfx as u16 ptr
	mapBase as u8
	gfxBase as u8
	bgLayer as u8
	bgId as integer
	cursorX as integer
	cursorY as integer
	prevCursorX as integer
	prevCursorY as integer
	consoleWidth as integer
	consoleHeight as integer
	windowX as integer
	windowY as integer
	windowWidth as integer
	windowHeight as integer
	tabSize as integer
	fontCharOffset as u16
	fontCurPal as u16
	PrintChar as ConsolePrint
	consoleInitialised as integer
	loadGraphics as integer
end type

'type PrintConsole as any

enum DebugDevice
	DebugDevice_NULL = &h0
	DebugDevice_NOCASH = &h1
	DebugDevice_CONSOLE = &h02
end enum


declare sub consoleSetFont cdecl alias "consoleSetFont" (byval console as PrintConsole ptr, byval font as ConsoleFont ptr)
declare sub consoleSetWindow cdecl alias "consoleSetWindow" (byval console as PrintConsole ptr, byval x as integer, byval y as integer, byval width as integer, byval height as integer)
declare function consoleGetDefault cdecl alias "consoleGetDefault" () as PrintConsole ptr
declare function consoleSelect cdecl alias "consoleSelect" (byval console as PrintConsole ptr) as PrintConsole ptr
declare function consoleInit cdecl alias "consoleInit" (byval console as PrintConsole ptr, byval layer as integer, byval type as BgType, byval size as BgSize, byval mapBase as integer, byval tileBase as integer, byval mainDisplay as integer, byval loadGraphics as integer) as PrintConsole ptr
declare function consoleDemoInit cdecl alias "consoleDemoInit" () as PrintConsole ptr
declare sub consoleClear cdecl alias "consoleClear" ()
declare sub consoleDebugInit cdecl alias "consoleDebugInit" (byval device as DebugDevice)

#endif
