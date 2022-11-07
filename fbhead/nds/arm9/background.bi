''
''
'' background -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_background_bi__
#define __arm9_background_bi__

#include "nds/ndstypes.bi"
#include "nds/arm9/video.bi"
'#include "nds/arm9/sassert.h"
'#include "nds/memory.bi"
#include "nds/dma.bi"

#define BACKGROUND_TOP          (*cast(bg_attribute ptr,&h04000008))
#define BG_OFFSET 		(*cast(bg_scroll ptr,&h04000010))
#define BG_MAP_RAM(base)	cast(u16 ptr,((cuint(base)*&h800) + &h06000000))
#define BG_TILE_RAM(base)	cast(u16 ptr,((cuint(base)*&h4000) + &h06000000))
#define BG_BMP_RAM(base)	cast(u16 ptr,((cuint(base)*&h4000) + &h06000000))
#define CHAR_BASE_BLOCK(n)	(((n)*&h4000)+ &h06000000)
#define SCREEN_BASE_BLOCK(n)	(((n)*&h800) + &h06000000)
#define	BGCTRL			(cptr_vu16_ptr(&h4000008))
#define	REG_BG0CNT		(cast_vu16_ptr(&h4000008)
#define	REG_BG1CNT		(cast_vu16_ptr(&h400000A)
#define	REG_BG2CNT		(cast_vu16_ptr(&h400000C)
#define	REG_BG3CNT		(cast_vu16_ptr(&h400000E)
#define	REG_BGOFFSETS		(cptr_vu16_ptr(&h4000010))
#define	REG_BG0HOFS		(cast_vu16_ptr(&h4000010)
#define	REG_BG0VOFS		(cast_vu16_ptr(&h4000012)
#define	REG_BG1HOFS		(cast_vu16_ptr(&h4000014)
#define	REG_BG1VOFS		(cast_vu16_ptr(&h4000016)
#define	REG_BG2HOFS		(cast_vu16_ptr(&h4000018)
#define	REG_BG2VOFS		(cast_vu16_ptr(&h400001A)
#define	REG_BG3HOFS		(cast_vu16_ptr(&h400001C)
#define	REG_BG3VOFS		(cast_vu16_ptr(&h400001E)
#define	REG_BG2PA		(cast_vs16_ptr(&h4000020)
#define	REG_BG2PB		(cast_vs16_ptr(&h4000022)
#define	REG_BG2PC		(cast_vs16_ptr(&h4000024)
#define	REG_BG2PD		(cast_vs16_ptr(&h4000026)
#define	REG_BG2X		(cast_vs32_ptr(&h4000028)
#define	REG_BG2Y		(cast_vs32_ptr(&h400002C)
#define	REG_BG3PA		(cast_vs16_ptr(&h4000030)
#define	REG_BG3PB		(cast_vs16_ptr(&h4000032)
#define	REG_BG3PC		(cast_vs16_ptr(&h4000034)
#define	REG_BG3PD		(cast_vs16_ptr(&h4000036)
#define	REG_BG3X		(cast_vs32_ptr(&h4000038)
#define	REG_BG3Y		(cast_vs32_ptr(&h400003C)

#define BACKGROUND_SUB       (*cast(bg_attribute ptr,&h04001008))
#define BG_OFFSET_SUB (*cast(bg_scroll ptr,&h04001010))
#define BG_MAP_RAM_SUB(base)	cast(u16 ptr,(((base)*&h800) + &h06200000))
#define BG_TILE_RAM_SUB(base)	cast(u16 ptr,(((base)*&h4000) + &h06200000))
#define BG_BMP_RAM_SUB(base)	cast(u16 ptr,(((base)*&h4000) + &h06200000))
#define SCREEN_BASE_BLOCK_SUB(n) (((n)*0x800) + &h06200000)
#define	BGCTRL_SUB		(cptr_vu16_ptr(&h4001008)
#define	REG_BG0CNT_SUB		(cast_vu16_ptr(&h4001008)
#define	REG_BG1CNT_SUB		(cast_vu16_ptr(&h400100A)
#define	REG_BG2CNT_SUB		(cast_vu16_ptr(&h400100C)
#define	REG_BG3CNT_SUB		(cast_vu16_ptr(&h400100E)
#define	REG_BGOFFSETS_SUB	(cptr_vu16_ptr(&h4001010)
#define	REG_BG0HOFS_SUB		(cast_vu16_ptr(&h4001010)
#define	REG_BG0VOFS_SUB		(cast_vu16_ptr(&h4001012)
#define	REG_BG1HOFS_SUB		(cast_vu16_ptr(&h4001014)
#define	REG_BG1VOFS_SUB		(cast_vu16_ptr(&h4001016)
#define	REG_BG2HOFS_SUB		(cast_vu16_ptr(&h4001018)
#define	REG_BG2VOFS_SUB		(cast_vu16_ptr(&h400101A)
#define	REG_BG3HOFS_SUB		(cast_vu16_ptr(&h400101C)
#define	REG_BG3VOFS_SUB		(cast_vu16_ptr(&h400101E)
#define	REG_BG2PA_SUB		(cast_vs16_ptr(&h4001020)
#define	REG_BG2PB_SUB		(cast_vs16_ptr(&h4001022)
#define	REG_BG2PC_SUB		(cast_vs16_ptr(&h4001024)
#define	REG_BG2PD_SUB		(cast_vs16_ptr(&h4001026)
#define	REG_BG2X_SUB		(cast_vs32_ptr(&h4001028)
#define	REG_BG2Y_SUB		(cast_vs32_ptr(&h400102C)
#define	REG_BG3PA_SUB		(cast_vs16_ptr(&h4001030)
#define	REG_BG3PB_SUB		(cast_vs16_ptr(&h4001032)
#define	REG_BG3PC_SUB		(cast_vs16_ptr(&h4001034)
#define	REG_BG3PD_SUB		(cast_vs16_ptr(&h4001036)
#define	REG_BG3X_SUB		(cast_vs32_ptr(&h4001038)
#define	REG_BG3Y_SUB		(cast_vs32_ptr(&h400103C)

type bg_scroll
	x as u16
	y as u16
end type

'type bg_scroll as any

type bg_transform
	hdx as s16
	vdx as s16
	hdy as s16
	vdy as s16
	dx as s32
	dy as s32
end type

'type bg_transform as any

type bg_attribute
	control(0 to 4-1) as u16
	scroll(0 to 4-1) as bg_scroll
	bg2_rotation as bg_transform
	bg3_rotation as bg_transform
end type

'type bg_attribute as any

#define MAP_BASE_SHIFT 8
#define TILE_BASE_SHIFT 2

enum BackgroundControl
	BG_32x32 = (0 shl 14)
	BG_64x32 = (1 shl 14)
	BG_32x64 = (2 shl 14)
	BG_64x64 = (3 shl 14)
	BG_RS_16x16 = (0 shl 14)
	BG_RS_32x32 = (1 shl 14)
	BG_RS_64x64 = (2 shl 14)
	BG_RS_128x128 = (3 shl 14)
	BG_BMP8_128x128 = ((0 shl 14) or vBIT(7))
	BG_BMP8_256x256 = ((1 shl 14) or vBIT(7))
	BG_BMP8_512x256 = ((2 shl 14) or vBIT(7))
	BG_BMP8_512x512 = ((3 shl 14) or vBIT(7))
	BG_BMP8_1024x512 = vBIT(14)
	BG_BMP8_512x1024 = 0
	BG_BMP16_128x128 = ((0 shl 14) or vBIT(7) or vBIT(2))
	BG_BMP16_256x256 = ((1 shl 14) or vBIT(7) or vBIT(2))
	BG_BMP16_512x256 = ((2 shl 14) or vBIT(7) or vBIT(2))
	BG_BMP16_512x512 = ((3 shl 14) or vBIT(7) or vBIT(2))
	BG_MOSAIC_ON = (vBIT(6))
	BG_MOSAIC_OFF = (0)
	BG_PRIORITY_0 = (0)
	BG_PRIORITY_1 = (1)
	BG_PRIORITY_2 = (2)
	BG_PRIORITY_3 = (3)
	BG_WRAP_OFF = (0)
	BG_WRAP_ON = (1 shl 13)
	BG_PALETTE_SLOT0 = 0
	BG_PALETTE_SLOT1 = 0
	BG_PALETTE_SLOT2 = vBIT(13)
	BG_PALETTE_SLOT3 = vBIT(13)
	BG_COLOR_256 = &h80
	BG_COLOR_16 = &h00
end enum


type BgState
	angle as integer
	centerX as s32
	centerY as s32
	scaleX as s32
	scaleY as s32
	scrollX as s32
	scrollY as s32
	size as integer
	type as integer
	dirty as integer
end type

'type BgState as any

extern bgControl(0 to 8-1) alias "bgControl" as vuint16 ptr '
extern bgScrollTable(0 to 8-1) alias "bgScrollTable" as bg_scroll ptr
extern bgTransform(0 to 8-1) alias "bgTransform" as bg_transform ptr
extern bgState(0 to 8-1) alias "bgState" as BgState

enum BgType
	BgType_Text8bpp
	BgType_Text4bpp
	BgType_Rotation
	BgType_ExRotation
	BgType_Bmp8
	BgType_Bmp16
end enum


enum BgSize
	BgSize_R_128x128 = (0 shl 14)
	BgSize_R_256x256 = (1 shl 14)
	BgSize_R_512x512 = (2 shl 14)
	BgSize_R_1024x1024 = (3 shl 14)
	BgSize_T_256x256 = (0 shl 14) or (1 shl 16)
	BgSize_T_512x256 = (1 shl 14) or (1 shl 16)
	BgSize_T_256x512 = (2 shl 14) or (1 shl 16)
	BgSize_T_512x512 = (3 shl 14) or (1 shl 16)
	BgSize_ER_128x128 = (0 shl 14) or (2 shl 16)
	BgSize_ER_256x256 = (1 shl 14) or (2 shl 16)
	BgSize_ER_512x512 = (2 shl 14) or (2 shl 16)
	BgSize_ER_1024x1024 = (3 shl 14) or (2 shl 16)
	BgSize_B8_128x128 = ((0 shl 14) or vBIT(7) or (3 shl 16))
	BgSize_B8_256x256 = ((1 shl 14) or vBIT(7) or (3 shl 16))
	BgSize_B8_512x256 = ((2 shl 14) or vBIT(7) or (3 shl 16))
	BgSize_B8_512x512 = ((3 shl 14) or vBIT(7) or (3 shl 16))
	BgSize_B8_1024x512 = (1 shl 14) or (3 shl 16)
	BgSize_B8_512x1024 = (0) or (3 shl 16)
	BgSize_B16_128x128 = ((0 shl 14) or vBIT(7) or vBIT(2) or (4 shl 16))
	BgSize_B16_256x256 = ((1 shl 14) or vBIT(7) or vBIT(2) or (4 shl 16))
	BgSize_B16_512x256 = ((2 shl 14) or vBIT(7) or vBIT(2) or (4 shl 16))
	BgSize_B16_512x512 = ((3 shl 14) or vBIT(7) or vBIT(2) or (4 shl 16))
end enum


declare function bgIsText cdecl alias "bgIsText" (byval id as integer) as integer
declare function bgInit_call cdecl alias "bgInit_call" (byval layer as integer, byval type as BgType, byval size as BgSize, byval mapBase as integer, byval tileBase as integer) as integer
declare function bgInitSub_call cdecl alias "bgInitSub_call" (byval layer as integer, byval type as BgType, byval size as BgSize, byval mapBase as integer, byval tileBase as integer) as integer
declare sub bgUpdate cdecl alias "bgUpdate" ()

#macro bgSetRotate(int_id, int_angle)
   bgState(cast(integer,int_id)).angle = cast(integer,int_angle)
   bgState(cast(integer,int_id)).dirty = true
#endmacro

#macro bgRotate(int_id, int_angle)
  sassert(bgIsText(cast(integer,int_id)=0, "Cannot Rotate a Text Background")
  bgSetRotate(cast(integer,int_id), cast(integer,int_angle) + bgState(cast(integer,int_id)).angle)
#endmacro

#macro bgSet(int_id, int_angle, s32_sx, s32_sy, s32_scrollX, s32_scrollY, s32_rotCenterX, s32_rotCenterY)
  with bgState(cast(integer,int_id)
    .scaleX = cast(s32,s32_sx)
    .scaleY = cast(s32,s32_sy)
    .scrollX = cast(s32,s32_scrollX)
    .scrollY = cast(s32,s32_scrollY)
    .centerX = cast(s32,s32_rotCenterX)
    .centerY = cast(s32,s32_rotCenterY)
    .angle = cast(integer,int_angle)
    .dirty = true
  end with
#endmacro

#macro bgSetRotateScale(int_id, int_angle, s32_sx, s32_sy)
  with bgState(cast(integer,int_id))
    .scaleX = cast(s32,s32_sx)
    .scaleY = cast(s32,s32_sy)
    .angle = cast(integer,int_angle)
    .dirty = true
  end with
#endmacro

#macro bgSetScale(int_id, s32_sx, s32_sy)
  sassert(bgIsText(cast(integer,int_id))=0, "Cannot Scale a Text Background")
  with bgState(cast(integer,int_id))
    .scaleX = cast(s32,s32_sx)
    .scaleY = cast(s32,s32_sy)
    .dirty = true
  end with
#endmacro

#define bgInit bgInit__FB__INLINE__
function bgInit__FB__INLINE__(layer as integer,btype as BgType,bsize as BgSize,mapBase as integer,tileBase as integer) as integer
  sassert(layer >= 0 andalso layer <= 3, "Only layers 0 - 3 are supported")
  sassert(tileBase >= 0 andalso tileBase <= 15, "Background tile base is out of range")
  sassert(mapBase >=0 andalso mapBase <= 31, "Background Map Base is out of range")
  sassert(layer orelse video3DEnabled()=0, "Background 0 is currently being used for 3D display")
  sassert(layer > 1 orelse btype = BgType_Text8bpp orelse btype = BgType_Text4bpp, "Incorrect background type for mode")
  sassert((bsize <> BgSize_B8_512x1024 andalso bsize <> BgSize_B8_1024x512) orelse videoGetMode() = 6, "Incorrect background type for mode")
  sassert(tileBase = 0 orelse btype <> BgType_Bmp8, "Tile base is unused for bitmaps.  Can be offset using mapBase * 16KB")
  sassert((mapBase = 0 orelse btype <> BgType_Bmp8) orelse (bsize <> BgSize_B8_512x1024 andalso bsize <> BgSize_B8_1024x512), "Large Bitmaps cannot be offset")
  return bgInit_call(layer, btype, bsize, mapBase, tileBase)
end function

#define bgInitSub bgInitSub__FB__INLINE__
function bgInitSub__FB__INLINE__(layer as integer, btype as BgType, bsize as BgSize,mapBase as integer ,tileBase as integer ) as integer
  'sassert(layer >= 0 && layer <= 3, "Only layers 0 - 3 are supported")
  'sassert(tileBase >= 0 && tileBase <= 15, "Background tile base is out of range")
  'sassert(mapBase >=0 && mapBase <= 31, "Background Map Base is out of range")
  'sassert(layer > 1 || type == BgType_Text8bpp|| type == BgType_Text4bpp , "Incorrect background type for mode")
  'sassert(tileBase == 0 || type < BgType_Bmp8, "Tile base is unused for bitmaps.  Can be offset using mapBase * 16KB")
  'sassert((size != BgSize_B8_512x1024 && size != BgSize_B8_1024x512), "Sub Display has no large Bitmaps")
  return bgInitSub_call(layer, btype, bsize, mapBase, tileBase)
end function

#define bgSetControlBits bgSetControlBits__FB__INLINE__
function bgSetControlBits__FB__INLINE__(id as integer, ubits as u16) as vuint16 ptr
  sassert(id >= 0 andalso id <= 7, "bgSetControlBits(), id must be the number returned from bgInit or bgInitSub")
  *bgControl(id) or= ubits
  return cast(vuint16 ptr,bgControl(id))
end function

#define bgClearControlBits bgClearControlBits__FB__INLINE__
#macro bgClearControlBits__FB__INLINE__(int_id, u16_bits)
  sassert(id >= int_id andalso int_id <= 7, "bgClearControlBits(), id must be the number returned from bgInit or bgInitSub")
  *bgControl(id) and= not cast(u16,u16_bits)
#endmacro

#macro bgWrapOn(int_id)
  bgSetControlBits(cast(integer,int_id), vBIT(13))
#endmacro

#macro bgWrapOff(int_id)
  bgClearControlBits(cast(integer,int_id), vBIT(13))
#endmacro

#macro bgSetPriority(int_id, uint_priority)
  sassert(cast(uinteger,uint_priority) < 4, "Priority must be less than 4")
  *bgControl(cast(integer,int_id)) and= not 3
  *bgControl(cast(integer,int_id)) or= cast(uinteger,uint_priority)
#endmacro

#macro bgSetMapBase(int_id, uint_base)
  sassert(cast(uinteger,uint_base) <= 31, "Map base cannot exceed 31")
  *bgControl(cast(integer,int_id)) and= not (31 shl MAP_BASE_SHIFT)
  *bgControl(cast(integer,int_id)) or= cast(uinteger,uint_base) shl MAP_BASE_SHIFT
#endmacro

#macro bgSetTileBase(int_id, uint_base)
  sassert(cast(uinteger,uint_base) <= 15, "Tile base cannot exceed 15")
  *bgControl(cast(integer,int_id)) and= not (15 shl TILE_BASE_SHIFT)
  *bgControl(cast(integer,int_id)) or= cast(uinteger,uint_base) shl TILE_BASE_SHIFT
#endmacro

#macro bgSetScrollf(int_id, s32_x, s32_y)
  with bgState(cast(integer,int_id))
    .scrollX = cast(s32,s32_x)
    .scrollY = cast(s32,s32_y)
    .dirty = true
  end with
#endmacro

#macro bgSetScroll(int_id, int_x, int_y)
  bgSetScrollf(cast(integer,int_id), cast(integer,int_x) shl 8, cast(integer, int_y shl 8))
#endmacro

#macro bgMosaicEnable(int_id)
  *bgControl(cast(integer,int_id)) or= vBIT(6)
#endmacro

#macro bgMosaicDisable(int_id)
  *bgControl(cast(integer,int_id)) and= not vBIT(6)
#endmacro

#macro bgSetMosaic(uint_dx, uint_dy)
  sassert(cast(uinteger,uint_dx) < 16 andalso cast(uinteger,uint_dy) < 16, "Mosaic range is 0 to 15")
  mosaicShadow = ( mosaicShadow and &hff00) or (cast(uinteger,uint_dx) or (cast(uinteger,uint_dy) shl 4))
  REG_MOSAIC = mosaicShadow
#endmacro

#macro bgSetMosaicSub(uint_dx, uint_dy)
  sassert(cast(uinteger,uint_dx) < 16 andalso cast(uinteger,uint_dy) < 16, "Mosaic range is 0 to 15")
  mosaicShadowSub = ( mosaicShadowSub and &hff00) or (cast(uinteger,uint_dx) or (cast(uinteger,uint_dy) shl 4))
  REG_MOSAIC_SUB = mosaicShadowSub
#endmacro

#define bgGetPriority(int_id)	(*bgControl(cast(integer,int_id) and 3))
#define bgGetMapBase(int_id) ((*bgControl(cast(integer,int_id)) shr MAP_BASE_SHIFT) and 31)
#define bgGetTileBase(int_id) ((*bgControl(cast(integer,int_id)) shr TILE_BASE_SHIFT) and 15)
#define bgGetMapPtr(int_id) cast(u16 ptr,iif(cast(integer,int_id)<4),BG_MAP_RAM(bgGetMapBase(cast(integer,int_id))),BG_MAP_RAM_SUB(bgGetMapBase(cast(integer,int_id))))

#define bgGetGfxPtr bgGetGfxPtr__FB__INLINE__
function bgGetGfxPtr__FB__INLINE__(id as integer) as u16 ptr
  if (bgState(id).type < BgType_Bmp8) then
    return cast(u16 ptr,iif(id < 4,(BG_TILE_RAM(bgGetTileBase(id))),(BG_TILE_RAM_SUB(bgGetTileBase(id)))))
  else
    return cast(u16 ptr,iif(id < 4,(BG_GFX + &h2000 * (bgGetMapBase(id))),(BG_GFX_SUB + &h2000 * (bgGetMapBase(id)))))
  end if
end function

#macro bgScrollf(int_id, s32_dx, s32_dy)
bgSetScrollf(cast(integer,int_id), bgState(cast(integer,int_id)).scrollX + cast(s32,s32_dx, bgState(cast(integer,int_id)).scrollY + cast(s32,s32_dy))
#endmacro

#macro bgScroll(int_id, int_dx, int_dy)
  bgScrollf(cast(integer,int_id), cast(integer,int_dx) shl 8,cast(integer,int_dy) shl 8)
#endmacro

#macro bgShow(int_id)
  if(cast(integer,int_id) < 4)
    videoBgEnable(cast(integer,int_id))
  else
    videoBgEnableSub(cast(integer,int_id) and 3)
  end if
#endmacro

#macro bgHide(int_id)
  if(cast(integer,int_id) < 4)
    videoBgDisable(cast(integer,int_id))
  else
    videoBgDisableSub(cast(integer,int_id) and 3)
  end if
#endmacro

#macro bgSetCenterf(int_id, s32_x, s32_y)
  sassert(bgIsText(cast(integer,int_id))=0, "Text Backgrounds have no Center of Rotation")
  with bgState(cast(integer,int_id))
    .centerX = cast(s32,s32_x)
    .centerY = cast(s32,s32_y)
    .dirty = true
  end with
#endmacro

#macro bgSetCenter(int_id,int_x, int_y)
  bgSetCenterf(cast(integer,int_id), cast(integer,int_x) shl 8, cast(integer,int_y) shl 8)
#endmacro

#macro bgSetAffineMatrixScroll(int_id, int_hdx, int_vdx, int_hdy, int_vdy, int_scrollx, int_scrolly)
  sassert(bgIsText(cast(integer,int_id))=0, "Text Backgrounds have no affine matrix and scroll registers.")
  with *bgTransform(cast(integer,int_id))
    .hdx = cast(integer,int_hdx)
    .vdx = cast(integer,int_vdx)
    .hdy = cast(integer,int_hdy)
    .vdy = cast(integer,int_vdy)
    .dx = cast(integer,int_scrollx)
    .dy = cast(integer,int_scrolly)
  end with
  bgState(cast(integer,int_id)).dirty = false
#endmacro


#endif
