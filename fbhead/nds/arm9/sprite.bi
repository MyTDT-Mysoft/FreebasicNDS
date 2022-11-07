''
''
'' sprite -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_sprite_bi__
#define __arm9_sprite_bi__

#define ATTR0_NORMAL (0 shl 8)
#define ATTR0_ROTSCALE (1 shl 8)
#define ATTR0_DISABLED (2 shl 8)
#define ATTR0_ROTSCALE_DOUBLE (3 shl 8)
#define ATTR0_TYPE_NORMAL (0 shl 10)
#define ATTR0_TYPE_BLENDED (1 shl 10)
#define ATTR0_TYPE_WINDOWED (2 shl 10)
#define ATTR0_BMP (3 shl 10)
#define ATTR0_MOSAIC (1 shl 12)
#define ATTR0_COLOR_16 (0 shl 13)
#define ATTR0_COLOR_256 (1 shl 13)
#define ATTR0_SQUARE (0 shl 14)
#define ATTR0_WIDE (1 shl 14)
#define ATTR0_TALL (2 shl 14)
#define ATTR1_FLIP_X (1 shl 12)
#define ATTR1_FLIP_Y (1 shl 13)
#define ATTR1_SIZE_8 (0 shl 14)
#define ATTR1_SIZE_16 (1 shl 14)
#define ATTR1_SIZE_32 (2 shl 14)
#define ATTR1_SIZE_64 (3 shl 14)
#define OBJ_X(m)			((m)and &h01ff)
'// Atribute 2 consists of the following:
#define ATTR2_PRIORITY(n)     ((n) shl 10)
#define ATTR2_PALETTE(n)      ((n) shl 12)
#define ATTR2_ALPHA(n)		  ((n) shl 12)

enum ObjBlendMode
	OBJMODE_NORMAL
	OBJMODE_BLENDED
	OBJMODE_WINDOWED
	OBJMODE_BITMAP
end enum


enum ObjShape
	OBJSHAPE_SQUARE
	OBJSHAPE_WIDE
	OBJSHAPE_TALL
	OBJSHAPE_FORBIDDEN
end enum


enum ObjSize
	OBJSIZE_8
	OBJSIZE_16
	OBJSIZE_32
	OBJSIZE_64
end enum


enum ObjColMode
	OBJCOLOR_16
	OBJCOLOR_256
end enum


enum ObjPriority
	OBJPRIORITY_0
	OBJPRIORITY_1
	OBJPRIORITY_2
	OBJPRIORITY_3
end enum

type SpriteEntry
  union
    #if 0
    type
      type
        as u16 y :8
        union      
          type
            as u8 _R1_ :1
            as u8 isHidden :1 '/**< Sprite is hidden (isRotoscale cleared). */
            as u8	_R2_ :6
          end type
          type        
            as u8 isRotateScale		    :1 '	/**< Sprite uses affine parameters if set. */
            as u8 isSizeDouble		    :1 '	/**< Sprite bounds is doubled (isRotoscale set). */
            as ObjBlendMode blendMode	:2 '	/**< Sprite object mode. */
            as u8 isMosaic		      	:1 '	/**< Enables mosaic effect if set. */
            as ObjColMode colorMode	  :1 '	/**< Sprite color mode. */
            as ObjShape shape			    :2 '	/**< Sprite shape. */
          end type
        end union
      end type
      union
        type
          as u16 x		:9 '	/**< Sprite X position. */
          as u16 _R3_ :7 '
        end type
        type
          as u8 _R4_ :8
          union
            type
              as u8	_R5_  :4 '
              as u8 hFlip :1 ' /**< Flip sprite horizontally (isRotoscale cleared). */
              as u8 vFlip :1 ' /**< Flip sprite vertically (isRotoscale cleared).*/
              as u8 _R6_  :2 '
            end type
            type
              as u8               :1'
              as u8 rotationIndex :5' /**< Affine parameter number to use (isRotoscale set). */
              as ObjSize size     :2' /**< Sprite size. */
            end type
          end union
        end type
      end union
      type    
        as u16 gfxIndex					:10 '/**< Upper-left tile index. */
        as ObjPriority priority	:2	'/**< Sprite priority. */
        as u8 palette						:4 	'/**< Sprite palette to use in paletted color modes. */
      end type
      as u16 attribute3 '/* Unused! Four of those are used as a sprite rotation matrice */
    end type
    #endif
    type
      as uint16 attribute(3-1)
      as uint16 filler
    end type
  end union
end type

type pSpriteEntry as SpriteEntry ptr

type SpriteRotation
	filler1(0 to 3-1) as uint16
	hdx as int16
	filler2(0 to 3-1) as uint16
	vdx as int16
	filler3(0 to 3-1) as uint16
	hdy as int16
	filler4(0 to 3-1) as uint16
	vdy as int16
end type

type pSpriteRotation as SpriteRotation ptr

#define SPRITE_COUNT 128
#define MATRIX_COUNT 32

union OAMTable
	oamBuffer(0 to 128-1) as SpriteEntry
	matrixBuffer(0 to 32-1) as SpriteRotation
end union

enum SpriteSize
	SpriteSize_8x8 = (OBJSIZE_8 shl 14) or (OBJSHAPE_SQUARE shl 12) or (8*8 shr 5)
	SpriteSize_16x16 = (OBJSIZE_16 shl 14) or (OBJSHAPE_SQUARE shl 12) or (16*16 shr 5)
	SpriteSize_32x32 = (OBJSIZE_32 shl 14) or (OBJSHAPE_SQUARE shl 12) or (32*32 shr 5)
	SpriteSize_64x64 = (OBJSIZE_64 shl 14) or (OBJSHAPE_SQUARE shl 12) or (64*64 shr 5)
	SpriteSize_16x8 = (OBJSIZE_8 shl 14) or (OBJSHAPE_WIDE shl 12) or (16*8 shr 5)
	SpriteSize_32x8 = (OBJSIZE_16 shl 14) or (OBJSHAPE_WIDE shl 12) or (32*8 shr 5)
	SpriteSize_32x16 = (OBJSIZE_32 shl 14) or (OBJSHAPE_WIDE shl 12) or (32*16 shr 5)
	SpriteSize_64x32 = (OBJSIZE_64 shl 14) or (OBJSHAPE_WIDE shl 12) or (64*32 shr 5)
	SpriteSize_8x16 = (OBJSIZE_8 shl 14) or (OBJSHAPE_TALL shl 12) or (8*16 shr 5)
	SpriteSize_8x32 = (OBJSIZE_16 shl 14) or (OBJSHAPE_TALL shl 12) or (8*32 shr 5)
	SpriteSize_16x32 = (OBJSIZE_32 shl 14) or (OBJSHAPE_TALL shl 12) or (16*32 shr 5)
	SpriteSize_32x64 = (OBJSIZE_64 shl 14) or (OBJSHAPE_TALL shl 12) or (32*64 shr 5)
end enum


enum SpriteMapping
	SpriteMapping_1D_32 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_32 or (0 shl 28) or 0
	SpriteMapping_1D_64 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_64 or (1 shl 28) or 1
	SpriteMapping_1D_128 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_128 or (2 shl 28) or 2
	SpriteMapping_1D_256 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_256 or (3 shl 28) or 3
	SpriteMapping_2D = DISPLAY_SPR_2D or (4 shl 28)
	SpriteMapping_Bmp_1D_128 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_128 or DISPLAY_SPR_1D_BMP or DISPLAY_SPR_1D_BMP_SIZE_128 or (5 shl 28) or 2
	SpriteMapping_Bmp_1D_256 = DISPLAY_SPR_1D or DISPLAY_SPR_1D_SIZE_256 or DISPLAY_SPR_1D_BMP or DISPLAY_SPR_1D_BMP_SIZE_256 or (6 shl 28) or 3
	SpriteMapping_Bmp_2D_128 = DISPLAY_SPR_2D or DISPLAY_SPR_2D_BMP_128 or (7 shl 28) or 2
	SpriteMapping_Bmp_2D_256 = DISPLAY_SPR_2D or DISPLAY_SPR_2D_BMP_256 or (8 shl 28) or 3
end enum


enum SpriteColorFormat
	SpriteColorFormat_16Color = OBJCOLOR_16
	SpriteColorFormat_256Color = OBJCOLOR_256
	SpriteColorFormat_Bmp = OBJMODE_BITMAP
end enum


type AllocHeader
	nextFree as u16
	size as u16
end type

type OamState
  gfxOffsetStep as integer
  firstFree as s16
  allocBuffer as AllocHeader ptr
  allocBufferSize as s16
  union	
    as SpriteEntry ptr oamMemory
    as SpriteRotation ptr oamRotationMemory
  end union
  spriteMapping as SpriteMapping
end type

extern oamMain alias "oamMain" as OamState
extern oamSub alias "oamSub" as OamState

declare sub oamInit cdecl alias "oamInit" (byval oam as OamState ptr, byval mapping as SpriteMapping, byval extPalette as integer)
declare sub oamDisable cdecl alias "oamDisable" (byval oam as OamState ptr)
declare sub oamEnable cdecl alias "oamEnable" (byval oam as OamState ptr)
declare function oamGetGfxPtr cdecl alias "oamGetGfxPtr" (byval oam as OamState ptr, byval gfxOffsetIndex as integer) as u16 ptr
declare function oamAllocateGfx cdecl alias "oamAllocateGfx" (byval oam as OamState ptr, byval size as SpriteSize, byval colorFormat as SpriteColorFormat) as u16 ptr
declare sub oamFreeGfx cdecl alias "oamFreeGfx" (byval oam as OamState ptr, byval gfxOffset as any ptr)
'declare sub oamSetMosaic cdecl alias "oamSetMosaic" (byval dx as uinteger, byval dy as uinteger)
'declare sub oamSetMosaicSub cdecl alias "oamSetMosaicSub" (byval dx as uinteger, byval dy as uinteger)
declare sub oamSet cdecl alias "oamSet" (byval oam as OamState ptr, byval id as integer, byval x as integer, byval y as integer, byval priority as integer, byval palette_alpha as integer, byval size as SpriteSize, byval format as SpriteColorFormat, byval gfxOffset as any ptr, byval affineIndex as integer, byval sizeDouble as integer, byval hide as integer, byval hflip as integer, byval vflip as integer, byval mosaic as integer)
declare sub oamClear cdecl alias "oamClear" (byval oam as OamState ptr, byval start as integer, byval count as integer)
'declare sub oamClearSprite cdecl alias "oamClearSprite" (byval oam as OamState ptr, byval index as integer)
declare sub oamUpdate cdecl alias "oamUpdate" (byval oam as OamState ptr)
declare sub oamRotateScale cdecl alias "oamRotateScale" (byval oam as OamState ptr, byval rotId as integer, byval angle as integer, byval sx as integer, byval sy as integer)
'declare sub oamAffineTransformation cdecl alias "oamAffineTransformation" (byval oam as OamState ptr, byval rotId as integer, byval hdx as integer, byval hdy as integer, byval vdx as integer, byval vdy as integer)
declare function oamCountFragments cdecl alias "oamCountFragments" (byval oam as OamState ptr) as integer
declare sub oamAllocReset cdecl alias "oamAllocReset" (byval oam as OamState ptr)
declare function oamGfxPtrToOffset cdecl alias "oamGfxPtrToOffset" (byval oam as OamState ptr, byval offset as any ptr) as uinteger

#macro oamSetMosaic(uintdx,uintdy)
  sassert(uintdx < 16 andalso uintdy < 16,"Mosaic range must be 0 to 15")
  mosaicShadow = ( mosaicShadow and 0x00ff ) or ( uintdx shl 8 ) or ( uintdy shl 12 )
  REG_MOSAIC = mosaicShadow
#endmacro

#macro oamSetMosaicSub(uintdx,uintdy)
  sassert(uintdx < 16 andalso uintdy < 16,"Mosaic range must be 0 to 15")
  mosaicShadowSub = ( mosaicShadowSub and 0x00ff ) or ( uintdx shl 8 ) or ( uintdy shl 12 )
  REG_MOSAIC_SUB = mosaicShadowSub
#endmacro

#macro oamClearSprite(OamStateptroam, intindex)
  sassert(intindex >= 0 andalso intindex < SPRITE_COUNT, "oamClearSprite() index is out of bounds, must be 0-127")
  OamStateptroam->oamMemory(intindex).attribute(0) = ATTR0_DISABLED
#endmacro

#macro oamAffineTransformation(OamStateptroam, introtId, inthdx, inthdy, intvdx, intvdy)
	sassert(introtId >= 0 andalso introtId < 32, "oamAffineTransformation() rotId is out of bounds, must be 0-31")
	OamStateptroam->oamRotationMemory(introtId).hdx = inthdx
	OamStateptroam->oamRotationMemory(introtId).vdx = intvdx
	OamStateptroam->oamRotationMemory(introtId).hdy = inthdy
	OamStateptroam->oamRotationMemory(introtId).vdy = intvdy
#endmacro



#endif
