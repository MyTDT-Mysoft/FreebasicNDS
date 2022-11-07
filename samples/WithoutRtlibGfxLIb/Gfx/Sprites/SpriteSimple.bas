#define ARM9

#include "crt.bi"
#include "nds.bi"

function main cdecl alias "main"() as integer
  
	dim as integer i = 0
	dim as touchPosition touch
  
	videoSetMode(MODE_0_2D)
	videoSetModeSub(MODE_0_2D)
  
	vramSetBankA(VRAM_A_MAIN_SPRITE)
	vramSetBankD(VRAM_D_SUB_SPRITE)
  
	oamInit(@oamMain, SpriteMapping_1D_32, false)
	oamInit(@oamSub, SpriteMapping_1D_32, false)
  
	dim as u16 ptr gfx = oamAllocateGfx(@oamMain, SpriteSize_16x16, SpriteColorFormat_256Color)
	dim as u16 ptr  gfxSub = oamAllocateGfx(@oamSub, SpriteSize_16x16, SpriteColorFormat_256Color)
  
	for I = 0 to (16*16/2)-1	
		gfx[i] = 1 or (1 shl 8)
		gfxSub[i] = 1 or (1 shl 8)
  next I
  
	SPRITE_PALETTE[1] = RGB15(31,0,0)
	SPRITE_PALETTE_SUB[1] = RGB15(0,31,0)
  
	do
    
		scanKeys()
    
		if (keysHeld() and KEY_TOUCH) then touchRead(@touch)
    
		oamSet(@oamMain,              _ '//main graphics engine context
    0,                          _ '//oam index (0 to 127)  
    touch.px, touch.py,         _ '//x and y pixle location of the sprite
    0,                          _ '//priority, lower renders last (on top)
    0,					                _ '//this is the palette index if multiple palettes or the alpha value if bmp sprite	
    SpriteSize_16x16,           _ '
    SpriteColorFormat_256Color, _ '
    gfx,                        _ ' //pointer to the loaded graphics
    -1,                         _ '//sprite rotation data  
    false,                      _ '//double the size when rotating?
    false,			                _ '//hide the sprite?
    false, false,               _ '//vflip, hflip
    false	)                     _ '//apply mosaic
    
		oamSet(@oamSub,0,touch.px,touch.py,0,0,SpriteSize_16x16, _
    SpriteColorFormat_256Color,gfxSub,-1,false,false,false,false,false )
    
    swiWaitForVBlank()
		
		oamUpdate(@oamMain)
		oamUpdate(@oamSub)
    
  loop
  
	return 0
  
end function
