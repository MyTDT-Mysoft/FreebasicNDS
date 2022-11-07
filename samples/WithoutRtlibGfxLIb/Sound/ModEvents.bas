#define ARM9

#include "crt.bi"
#include "nds.bi"
#include "maxmod9.bi"

const MOD_EXAMPLE2 =0
const MSL_NSONGS = 1
const MSL_NSAMPS = 6
const MSL_BANKSIZE = 7

DeclareResource(mmsolution_bin) ' _bin // _bin_end // _bin_size

'// a simple sprite structure
type MySprite
  as u16 ptr gfx
  as SpriteSize size
  as SpriteColorFormat format
  as integer rotationIndex
  as integer paletteAlpha
  as integer x
  as integer y
  as integer dy
end type

'// create 5 sprites, one for each song event used
dim shared as MySprite sprites(...) = { _
(0, SpriteSize_16x16, SpriteColorFormat_256Color, 0, 0, 20, 96, 0), _
(0, SpriteSize_16x16, SpriteColorFormat_256Color, 0, 0, 70, 96, 0), _
(0, SpriteSize_16x16, SpriteColorFormat_256Color, 0, 0, 120, 96, 0), _
(0, SpriteSize_16x16, SpriteColorFormat_256Color, 0, 0, 170, 96, 0), _
(0, SpriteSize_16x16, SpriteColorFormat_256Color, 0, 0, 220, 96, 0)	}


'//---------------------------------------------------------------------------------
'// callback function to handle song events
'//---------------------------------------------------------------------------------
function myEventHandler cdecl ( msg as mm_word, param as mm_word ) as mm_word
  
	select case msg
	case MMCB_SONGMESSAGE:	'// process song messages
  if param=1 then sprites(0).dy = -8
  if param=2 then sprites(1).dy = -8
  if param=3 then sprites(2).dy = -8
  if param=4 then sprites(3).dy = -8
  if param=5 then sprites(4).dy = -8		
case MMCB_SONGFINISHED:	'// process song finish message 
'rem nada??
end select

return 0

end function


'//---------------------------------------------------------------------------------
'//---------------------------------------------------------------------------------
function main cdecl alias "main" () as integer
  
	dim as integer i = 0
	
	videoSetMode(MODE_0_2D)
	videoSetModeSub(0)   '// not using subscreen
  
	lcdMainOnBottom()
	
	'//initialize the sprite engine with 1D mapping 128 byte boundary
	'//and no external palette support
	oamInit(@oamMain, SpriteMapping_1D_32, false)
  
	vramSetBankA(VRAM_A_MAIN_SPRITE)
	
	for i = 0 to (5-1)  
		'//allocate some space for the sprite graphics
		sprites(i).gfx = oamAllocateGfx(@oamMain, sprites(i).size, sprites(i).format)
		'//fill each sprite with a different index (2 pixels at a time)
		dmaFillHalfWords( ((i+1) shl 8) or (i+1), sprites(i).gfx, 32*32)
  next i
  
	'//set indexes to different colours
	SPRITE_PALETTE[1] = RGB15(31,0,0)
	SPRITE_PALETTE[2] = RGB15(0,31,0)
	SPRITE_PALETTE[3] = RGB15(0,0,31)
	SPRITE_PALETTE[4] = RGB15(31,0,31)
	SPRITE_PALETTE[5] = RGB15(0,31,31)
  
	'// initialise maxmod using default settings, and enable interface for soundbank that is loaded into memory
	mmInitDefaultMem( cast(mm_addr,mmsolution_bin) )
  
	'// setup maxmod to use the song event handler
	mmSetEventHandler( @myEventHandler )
	
	'// load song
	'// values for this function are in the solution header
	mmLoad( MOD_EXAMPLE2 )
  
	'// start song playing
	mmStart( MOD_EXAMPLE2, MM_PLAY_LOOP )
  
	do
    for i = 0 to (5-1)		
			'// constantly increase the sprite's y velocity
			sprites(i).dy += 1      
			'// update the sprite's y position with its y velocity
			sprites(i).y += sprites(i).dy      
			'// clamp the sprite's y position
			if sprites(i).y<72 then sprites(i).y = 72
			if sprites(i).y>96 then sprites(i).y = 96
      
			oamSet(	@oamMain, 			  _ '//main graphics engine context
      i,           				      _ '//oam index (0 to 127)  
      sprites(i).x,				      _ '//x and y pixel location of the sprite
      sprites(i).y, 	          _		
      0,							          _ '//priority, lower renders last (on top)
      sprites(i).paletteAlpha,  _ '	//palette index 
      sprites(i).size,          _ '
      sprites(i).format,        _ '
      sprites(i).gfx,				    _ '//pointer to the loaded graphics
      sprites(i).rotationIndex,	_ '//sprite rotation data  
      false,						        _ '//double the size when rotating?
      false,			              _ '//hide the sprite?
      false, false,             _ '//vflip, hflip
      false )	                    '//apply mosaic
    next i
    
		swiWaitForVBlank()
		
		'//send the updates to the hardware
		oamUpdate(@oamMain)
  loop
  
	return 0
end function


