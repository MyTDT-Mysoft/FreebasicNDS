#define ARM9

#include "crt.bi"
#include "nds.bi"

DeclareResource(fblogo_bin)
DeclareResource(palette_bin)

function main cdecl alias "main"() as integer

	videoSetMode(MODE_5_2D )

	vramSetBankA(VRAM_A_MAIN_BG)

	consoleDemoInit()

	dim as integer bg3 = bgInit(3, BgType_Bmp8, BgSize_B8_256x256, 0,0)

	dmaCopy(@fblogo_bin, bgGetGfxPtr(bg3), 256*256)
	dmaCopy(@palette_bin, BG_PALETTE, 256*2)
  
	dim as s16 angle = 0

	'// the screen origin is at the rotation center...so scroll to the rotation
	'// center + a small 32 pixle offset so our image is centered
	dim as s16 scrollX = 128
	dim as s16 scrollY = 128

	'//scale is fixed point
	dim as s16 scaleX = 1 shl 8
	dim as s16 scaleY = 1 shl 8

	'//this is the screen pixel that the image will rotate about
	dim as s16 rcX = 128
	dim as s16 rcY = 96

	do
		'// Print status

		iprintf(!"\n\n\tHello FB for DS devers\n")
		iprintf(!"\twww.freebasic.net\n")
		iprintf(!"\tBG Rotation demo\n\n")    

		iprintf(!"Angle %3d(actual) %3d(deg)\n", angle, (angle * 360) \ (1 shl 15))
		iprintf(!"Scroll  X: %4d Y: %4d\n", scrollX, scrollY)
		iprintf(!"Rot center X: %4d Y: %4d\n", rcX, rcY)
		iprintf(!"Scale X: %4d Y: %4d\n", scaleX, scaleY)

		scanKeys()
		dim as u32 keys = keysHeld()

		if ( keys and KEY_L )      then angle+=20
		if ( keys and KEY_R )      then angle-=20
		if ( keys and KEY_LEFT )   then scrollX+=1
		if ( keys and KEY_RIGHT )  then scrollX-=1
		if ( keys and KEY_UP )     then scrollY+=1
		if ( keys and KEY_DOWN )   then scrollY-=1
		if ( keys and KEY_A )      then scaleX+=1
		if ( keys and KEY_B )      then scaleX-=1
		if ( keys and KEY_START )  then rcX+=1
		if ( keys and KEY_SELECT ) then rcY+=1
		if ( keys and KEY_X )      then scaleY+=1
		if ( keys and KEY_Y )      then scaleY-=1

		swiWaitForVBlank()

		bgSetCenter(bg3, rcX, rcY)
		bgSetRotateScale(bg3, angle, scaleX, scaleY)
		bgSetScroll(bg3, scrollX, scrollY)
		bgUpdate()

		'// clear the console screen (ansi escape sequence)
		iprintf(!"\x1b[2J")

	loop
 
	return 0
  
end function
