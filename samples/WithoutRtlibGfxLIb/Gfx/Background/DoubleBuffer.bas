#define ARM9

#include "crt.bi"
#include "nds.bi"

function main cdecl alias "main"() as integer
  
  '//set the mode for 2 text layers and two extended background layers
	videoSetMode(MODE_5_2D)

	'//set the first two banks as background memory and the third as sub background memory
	'//D is not used..if you need a bigger background then you will need to map
	'//more vram banks consecutivly (VRAM A-D are all 0x20000 bytes in size)
	vramSetPrimaryBanks(	VRAM_A_MAIN_BG_0x06000000, _
  VRAM_B_MAIN_BG_0x06020000, VRAM_C_SUB_BG , VRAM_D_LCD)

	consoleDemoInit()

	printf(!"\n\n\tHello DS devers\n")
	printf(!"\twww.drunkencoders.com\n")
	printf(!"\tdouble buffer demo")

	dim as integer bg = bgInit(3, BgType_Bmp16, BgSize_B16_256x256, 0,0)

	dim as u16 colorMask = &h1F
	dim as u16 ptr backBuffer = cast(u16 ptr,bgGetGfxPtr(bg)) + 256*256

	do	
		'//draw a box (60,60,196,136)
    for iy as integer = 60 to (196-60)-1
      for ix as integer = 60 to (256-60)-1			
        backBuffer[iy * 256 + ix] = (rand() and colorMask) or vBIT(15)
      next ix
    next iy

		swiWaitForVBlank()

		'//swap the back buffer to the current buffer
		backBuffer = cast(u16 ptr,bgGetGfxPtr(bg))

		'//swap the current buffer by changing the base. Each base
		'//represents 16KB of offset and each screen is 256x256x2 (128KB)
		'//this requires a map base seperation of 8 (could get away with smaller
		'//as the screen is really only showing 256x192 (96KB or map base 6)
		if (bgGetMapBase(bg) = 8) then		
			bgSetMapBase(bg, 0)
		else		
			bgSetMapBase(bg, 8)
		end if
		colorMask xor= &h3FF
    
	loop
  
	return 0
  
end function
