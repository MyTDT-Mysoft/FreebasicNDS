#define ARM9

#include "crt.bi"
#include "nds.bi"

'//a simple sprite structure 
'//it is generally preferred to separate your game object
'//from OAM
type MySprite
  as u16 ptr gfx
  as SpriteSize size
  as SpriteColorFormat format
  as integer rotationIndex
  as integer paletteAlpha
  as integer x
  as integer y
end type 

  'dim shared as MySprite sprites(2) => { _
  '(0, SpriteSize_32x32, SpriteColorFormat_Bmp, 0, 15, 20, 15),      _
  '(0, SpriteSize_32x32, SpriteColorFormat_256Color, 0, 0, 20, 80),  _
  '(0, SpriteSize_32x32, SpriteColorFormat_16Color, 0, 1, 20, 136) } _

function main cdecl alias "main"() as integer
	
  '//three sprites of differing color format
  
  dim as MySprite sprites(2) => { _
  (0, SpriteSize_32x32, SpriteColorFormat_Bmp, 0, 15, 20, 15),      _
  (0, SpriteSize_32x32, SpriteColorFormat_256Color, 0, 0, 20, 80),  _
  (0, SpriteSize_32x32, SpriteColorFormat_16Color, 0, 1, 20, 136) } _
    
  videoSetModeSub(MODE_0_2D)
  
  consoleDemoInit()
  
  '//initialize the sub sprite engine with 1D mapping 128 byte boundary
  '//and no external palette support
  oamInit(@oamSub, SpriteMapping_Bmp_1D_128, false)  
  
  vramSetBankD(VRAM_D_SUB_SPRITE)
  
  '//allocate some space for the sprite graphics
  for i as integer = 0 to 2
    sprites(i).gfx = oamAllocateGfx(@oamSub, sprites(i).size, sprites(i).format)
  next i 
  
  '//ugly positional printf
  printf(!"\x1b[1;1HDirect Bitmap:")
  printf(!"\x1b[9;1H256 color:")
  printf(!"\x1b[16;1H16 color:\n")
  
  '//fill bmp sprite with the color red
  dmaFillHalfWords(ARGB16(1,31,0,0), sprites(0).gfx, 32*32*2)
  
  '//fill the 256 color sprite with index 1 (2 pixels at a time)
  dmaFillHalfWords((1 shl 8) or 1, sprites(1).gfx, 32*32)
  
  '//fill the 16 color sprite with index 1 (4 pixels at a time)
  dmaFillHalfWords((1 shl 12) or (1 shl 8) or (1 shl 4) or 1, sprites(2).gfx, 32*32 \ 2)
  
  '//set index 1 to blue...this will be the 256 color sprite
  SPRITE_PALETTE_SUB[1]  = RGB15(0,31,0)
  
  '//set index 17 to green...this will be the 16 color sprite
  SPRITE_PALETTE_SUB[16 + 1]  = RGB15(0,0,31)
  
  dim as integer angle = 0
  
  do
    for i as integer = 0 to 2
      oamSet(                     _ '
      @oamSub,                    _ 'sub display 
      i,                          _ 'oam entry to set
      sprites(i).x, sprites(i).y, _ 'position 
      0,                          _ 'priority
      sprites(i).paletteAlpha,    _ 'palette for 16 color sprite or alpha for bmp sprite
      sprites(i).size,            _ '
      sprites(i).format,          _ '
      sprites(i).gfx,             _ '
      sprites(i).rotationIndex,   _ '
      true,                       _ 'double the size of rotated sprites
      false,                      _ 'don't hide the sprite
      false, false,               _ 'vflip, hflip
      false )                       'apply mosaic
    next I
    oamRotateScale(@oamSub, 0, angle, (1 shl 8), (1 shl 8))
    
	  angle += 63
    
    swiWaitForVBlank()
    
    '//send the updates to the hardware
    oamUpdate(@oamSub)
  loop
  
  return 0
end function

'end extern