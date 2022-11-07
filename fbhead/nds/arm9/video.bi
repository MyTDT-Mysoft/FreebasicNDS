''
''
'' video -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __arm9_video_bi__
#define __arm9_video_bi__
extern mosaicShadow alias "mosaicShadow" as u16
extern mosaicShadowSub alias "mosaicShadowSub" as u16

#define RGB15(r,g,b)  ((r) or ((g) shl 5) or ((b) shl 10))
#define RGB5(r,g,b)  ((r) or ((g) shl 5) or ((b) shl 10))
#define RGB8(r,g,b)  (((r) shr 3) or (((g) shr 3) shl 5) or (((b) shr 3) shl 10) or &h8000 )
#define ARGB16(a, r, g, b) ( ((a) shl 15) or (r) or ((g) shl 5) or ((b) shl 10))

#define SCREEN_HEIGHT 192
#define SCREEN_WIDTH 256

#define VRAM_CR			cast_vu32_ptr(&h04000240)
#define VRAM_A_CR		cast_vu8_ptr( &h04000240)
#define VRAM_B_CR		cast_vu8_ptr( &h04000241)
#define VRAM_C_CR		cast_vu8_ptr( &h04000242)
#define VRAM_D_CR		cast_vu8_ptr( &h04000243)
#define VRAM_EFG_CR		cast_vu32_ptr(&h04000244)
#define VRAM_E_CR		cast_vu8_ptr( &h04000244)
#define VRAM_F_CR		cast_vu8_ptr( &h04000245)
#define VRAM_G_CR		cast_vu8_ptr( &h04000246)
#define WRAM_CR			cast_vu8_ptr( &h04000247)
#define VRAM_H_CR		cast_vu8_ptr( &h04000248)
#define VRAM_I_CR		cast_vu8_ptr( &h04000249)
#define BG_PALETTE              cptr_vu16_ptr(&h05000000)
#define BG_PALETTE_SUB          cptr_vu16_ptr(&h05000400)
#define SPRITE_PALETTE          cptr_vu16_ptr(&h05000200)
#define SPRITE_PALETTE_SUB      cptr_vu16_ptr(&h05000600)
#define BG_GFX			cast(u16 ptr, &h6000000)
#define BG_GFX_SUB		cast(u16 ptr, &h6200000)
#define SPRITE_GFX		cast(u16 ptr, &h6400000)
#define SPRITE_GFX_SUB		cast(u16 ptr, &h6600000)
#define VRAM_0                  cast(u16 ptr, &h6000000)
#define VRAM                    cast(u16 ptr, &h6800000)
#define VRAM_A                  cast(u16 ptr, &h6800000)
#define VRAM_B                  cast(u16 ptr, &h6820000)
#define VRAM_C                  cast(u16 ptr, &h6840000)
#define VRAM_D                  cast(u16 ptr, &h6860000)
#define VRAM_E                  cast(u16 ptr, &h6880000)
#define VRAM_F                  cast(u16 ptr, &h6890000)
#define VRAM_G                  cast(u16 ptr, &h6894000)
#define VRAM_H                  cast(u16 ptr, &h6898000)
#define VRAM_I                  cast(u16 ptr, &h68A0000)

#define VRAM_E_EXT_PALETTE (cast(_ext_palette ptr,VRAM_E))
#define VRAM_F_EXT_PALETTE (cast(_ext_palette ptr,VRAM_F))
#define VRAM_G_EXT_PALETTE (cast(_ext_palette ptr,VRAM_G))
#define VRAM_H_EXT_PALETTE (cast(_ext_palette ptr,VRAM_H))
#define VRAM_F_EXT_SPR_PALETTE (cast(_palette ptr,VRAM_F))
#define VRAM_G_EXT_SPR_PALETTE (cast(_palette ptr,VRAM_G))
#define VRAM_I_EXT_SPR_PALETTE (cast(_palette ptr,VRAM_I))



#define __OAM                   cast(u16 ptr, &h07000000)
#define __OAM_SUB               cast(u16 ptr, &h07000400)


#define pGFX_CONTROL          cptr_vu16_ptr(&h04000060)
#define GFX_CONTROL           *pGFX_CONTROL

#define pGFX_RDLINES_COUNT    cptr_vu8_ptr(&h04000320)
#define GFX_RDLINES_COUNT     cast_vu8_ptr(&h04000320)

#define pGFX_FIFO              cptr_vu32_ptr(&h04000400)
#define pGFX_STATUS            cptr_vu32_ptr(&h04000600)
#define pGFX_COLOR             cptr_vu32_ptr(&h04000480)
#define GFX_FIFO              *pGFX_FIFO
#define GFX_STATUS            *pGFX_STATUS
#define GFX_COLOR             *pGFX_COLOR

#define pGFX_VERTEX10          cptr_vu32_ptr(&h04000490)
#define pGFX_VERTEX_XY         cptr_vu32_ptr(&h04000494)
#define pGFX_VERTEX_XZ         cptr_vu32_ptr(&h04000498)
#define pGFX_VERTEX_YZ         cptr_vu32_ptr(&h0400049C)
#define pGFX_VERTEX_DIFF       cptr_vu32_ptr(&h040004A0)
#define GFX_VERTEX10          *pGFX_VERTEX10
#define GFX_VERTEX_XY         *pGFX_VERTEX_XY
#define GFX_VERTEX_XZ         *pGFX_VERTEX_XZ
#define GFX_VERTEX_YZ         *pGFX_VERTEX_YZ
#define GFX_VERTEX_DIFF       *pGFX_VERTEX_DIFF

#define pGFX_CLRIMAGE_OFFSET   cptr_vu16_ptr(&h04000356)
#define pGFX_VERTEX16          cptr_vu32_ptr(&h0400048C)
#define pGFX_TEX_COORD         cptr_vu32_ptr(&h04000488)
#define pGFX_TEX_FORMAT        cptr_vu32_ptr(&h040004A8)
#define pGFX_PAL_FORMAT        cptr_vu32_ptr(&h040004AC)
#define GFX_CLRIMAGE_OFFSET   *pGFX_CLRIMAGE_OFFSET
#define GFX_VERTEX16          *pGFX_VERTEX16
#define GFX_TEX_COORD         *pGFX_TEX_COORD
#define GFX_TEX_FORMAT        *pGFX_TEX_FORMAT
#define GFX_PAL_FORMAT        *pGFX_PAL_FORMAT

#define pGFX_CLEAR_COLOR       cptr_vu32_ptr(&h04000350)
#define pGFX_CLEAR_DEPTH       cptr_vu16_ptr(&h04000354)
#define GFX_CLEAR_COLOR       *pGFX_CLEAR_COLOR
#define GFX_CLEAR_DEPTH       *pGFX_CLEAR_DEPTH

#define pGFX_LIGHT_VECTOR      cptr_vu32_ptr(&h040004C8)
#define pGFX_LIGHT_COLOR       cptr_vu32_ptr(&h040004CC)
#define pGFX_NORMAL            cptr_vu32_ptr(&h04000484)
#define GFX_LIGHT_VECTOR      *pGFX_LIGHT_VECTOR
#define GFX_LIGHT_COLOR       *pGFX_LIGHT_COLOR
#define GFX_NORMAL            *pGFX_NORMAL

#define pGFX_DIFFUSE_AMBIENT   cptr_vu32_ptr(&h040004C0)
#define pGFX_SPECULAR_EMISSION cptr_vu32_ptr(&h040004C4)
#define pGFX_SHININESS         cptr_vu32_ptr(&h040004D0)
#define GFX_DIFFUSE_AMBIENT   *pGFX_DIFFUSE_AMBIENT
#define GFX_SPECULAR_EMISSION *pGFX_SPECULAR_EMISSION
#define GFX_SHININESS         *pGFX_SHININESS

#define pGFX_POLY_FORMAT       cptr_vu32_ptr(&h040004A4)
#define pGFX_ALPHA_TEST        cptr_vu16_ptr(&h04000340)
#define GFX_POLY_FORMAT       *pGFX_POLY_FORMAT
#define GFX_ALPHA_TEST        *pGFX_ALPHA_TEST

#define pGFX_BEGIN		cptr_vu32_ptr(&h04000500)
#define pGFX_END		cptr_vu32_ptr(&h04000504)
#define pGFX_FLUSH		cptr_vu32_ptr(&h04000540)
#define pGFX_VIEWPORT		cptr_vu32_ptr(&h04000580)
#define pGFX_FOG_COLOR		cptr_vu32_ptr(&h04000358)
#define pGFX_FOG_OFFSET		cptr_vu32_ptr(&h0400035C)
#define pGFX_BOX_TEST		cptr_vs32_ptr(&h040005C0)
#define pGFX_POS_TEST		cptr_vu32_ptr(&h040005C4)
#define pGFX_VEC_TEST		cptr_vu32_ptr(&h040005C8)
#define GFX_BEGIN		*pGFX_BEGIN
#define GFX_END			*pGFX_END
#define GFX_FLUSH		*pGFX_FLUSH
#define GFX_VIEWPORT		*pGFX_VIEWPORT
#define GFX_FOG_COLOR		*pGFX_FOG_COLOR
#define GFX_FOG_OFFSET		*pGFX_FOG_OFFSET	
#define GFX_BOX_TEST		*pGFX_BOX_TEST
#define GFX_POS_TEST		*pGFX_POS_TEST
#define GFX_VEC_TEST		*pGFX_VEC_TEST

#define GFX_TOON_TABLE cptr_vu16_ptr(&h04000380)
#define GFX_EDGE_TABLE cptr_vu16_ptr(&h04000330)
#define GFX_FOG_TABLE  cast(vu8 ptr,&h04000360)
#define GFX_POS_RESULT cptr_vs32_ptr(&h04000620)
#define GFX_VEC_RESULT cptr_vs16_ptr(&h04000630)

#define GFX_BUSY (GFX_STATUS and vBIT(27))

#define pGFX_VERTEX_RAM_USAGE	cptr_vu32_ptr(&h04000604)
#define pGFX_POLYGON_RAM_USAGE	cptr_vu32_ptr(&h04000604)
#define GFX_VERTEX_RAM_USAGE	((*pGFX_VERTEX_RAM_USAGE) shr 16)
#define GFX_POLYGON_RAM_USAGE	((*pGFX_POLYGON_RAM_USAGE) and &hFFFF)

#define pGFX_CUTOFF_DEPTH	cast(u16 ptr,&h04000610)
#define GFX_CUTOFF_DEPTH	*pGFX_CUTOFF_DEPTH

'// Matrix processor control
#define pMATRIX_CONTROL		cast(u32 ptr,&h04000440)
#define pMATRIX_PUSH		cast(u32 ptr,&h04000444)
#define pMATRIX_POP		cast(u32 ptr,&h04000448)
#define pMATRIX_SCALE		cptr_vs32_ptr(&h0400046C)
#define pMATRIX_TRANSLATE	cptr_vs32_ptr(&h04000470)
#define pMATRIX_RESTORE		cast(u32 ptr,&h04000450)
#define pMATRIX_STORE		cast(u32 ptr,&h0400044C)
#define pMATRIX_IDENTITY	cast(u32 ptr,&h04000454)
#define pMATRIX_LOAD4x4		cptr_vs32_ptr(&h04000458)
#define pMATRIX_LOAD4x3		cptr_vs32_ptr(&h0400045C)
#define pMATRIX_MULT4x4		cptr_vs32_ptr(&h04000460)
#define pMATRIX_MULT4x3		cptr_vs32_ptr(&h04000464)
#define pMATRIX_MULT3x3		cptr_vs32_ptr(&h04000468)
#define MATRIX_CONTROL		*pMATRIX_CONTROL
#define MATRIX_PUSH		*pMATRIX_PUSH
#define MATRIX_POP		*pMATRIX_POP
#define MATRIX_SCALE		*pMATRIX_SCALE
#define MATRIX_TRANSLATE	*pMATRIX_TRANSLATE
#define MATRIX_RESTORE		*pMATRIX_RESTORE
#define MATRIX_STORE		*pMATRIX_STORE
#define MATRIX_IDENTITY		*pMATRIX_IDENTITY
#define MATRIX_LOAD4x4		*pMATRIX_LOAD4x4
#define MATRIX_LOAD4x3		*pMATRIX_LOAD4x3
#define MATRIX_MULT4x4		*pMATRIX_MULT4x4
#define MATRIX_MULT4x3		*pMATRIX_MULT4x3
#define MATRIX_MULT3x3		*pMATRIX_MULT3x3

'//matrix operation results
#define MATRIX_READ_CLIP	(cptr_vs32_ptr(&h04000640))
#define MATRIX_READ_VECTOR	(cptr_vs32_ptr(&h04000680))
#define POINT_RESULT		(cptr_vs32_ptr(&h04000620))
#define VECTOR_RESULT		(cptr_vu16_ptr(&h04000630))


#define VRAM_ENABLE (1 shl 7)

enum VRAM_A_TYPE
	VRAM_A_LCD = 0
	VRAM_A_MAIN_BG = 1
	VRAM_A_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_A_MAIN_BG_0x06020000 = 1 or ((1) shl 3)
	VRAM_A_MAIN_BG_0x06040000 = 1 or ((2) shl 3)
	VRAM_A_MAIN_BG_0x06060000 = 1 or ((3) shl 3)
	VRAM_A_MAIN_SPRITE = 2
	VRAM_A_MAIN_SPRITE_0x06400000 = 2 or ((0) shl 3)
	VRAM_A_MAIN_SPRITE_0x06420000 = 2 or ((1) shl 3)
	VRAM_A_TEXTURE = 3
	VRAM_A_TEXTURE_SLOT0 = 3 or ((0) shl 3)
	VRAM_A_TEXTURE_SLOT1 = 3 or ((1) shl 3)
	VRAM_A_TEXTURE_SLOT2 = 3 or ((2) shl 3)
	VRAM_A_TEXTURE_SLOT3 = 3 or ((3) shl 3)
end enum

enum VRAM_B_TYPE
	VRAM_B_LCD = 0
	VRAM_B_MAIN_BG = 1 or ((1) shl 3)
	VRAM_B_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_B_MAIN_BG_0x06020000 = 1 or ((1) shl 3)
	VRAM_B_MAIN_BG_0x06040000 = 1 or ((2) shl 3)
	VRAM_B_MAIN_BG_0x06060000 = 1 or ((3) shl 3)
	VRAM_B_MAIN_SPRITE = 2
	VRAM_B_MAIN_SPRITE_0x06400000 = 2 or ((0) shl 3)
	VRAM_B_MAIN_SPRITE_0x06420000 = 2 or ((1) shl 3)
	VRAM_B_TEXTURE = 3 or ((1) shl 3)
	VRAM_B_TEXTURE_SLOT0 = 3 or ((0) shl 3)
	VRAM_B_TEXTURE_SLOT1 = 3 or ((1) shl 3)
	VRAM_B_TEXTURE_SLOT2 = 3 or ((2) shl 3)
	VRAM_B_TEXTURE_SLOT3 = 3 or ((3) shl 3)
end enum


enum VRAM_C_TYPE
	VRAM_C_LCD = 0
	VRAM_C_MAIN_BG = 1 or ((2) shl 3)
	VRAM_C_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_C_MAIN_BG_0x06020000 = 1 or ((1) shl 3)
	VRAM_C_MAIN_BG_0x06040000 = 1 or ((2) shl 3)
	VRAM_C_MAIN_BG_0x06060000 = 1 or ((3) shl 3)
	VRAM_C_ARM7 = 2
	VRAM_C_ARM7_0x06000000 = 2 or ((0) shl 3)
	VRAM_C_ARM7_0x06020000 = 2 or ((1) shl 3)
	VRAM_C_SUB_BG = 4
	VRAM_C_SUB_BG_0x06200000 = 4 or ((0) shl 3)
	VRAM_C_TEXTURE = 3 or ((2) shl 3)
	VRAM_C_TEXTURE_SLOT0 = 3 or ((0) shl 3)
	VRAM_C_TEXTURE_SLOT1 = 3 or ((1) shl 3)
	VRAM_C_TEXTURE_SLOT2 = 3 or ((2) shl 3)
	VRAM_C_TEXTURE_SLOT3 = 3 or ((3) shl 3)
end enum


enum VRAM_D_TYPE
	VRAM_D_LCD = 0
	VRAM_D_MAIN_BG = 1 or ((3) shl 3)
	VRAM_D_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_D_MAIN_BG_0x06020000 = 1 or ((1) shl 3)
	VRAM_D_MAIN_BG_0x06040000 = 1 or ((2) shl 3)
	VRAM_D_MAIN_BG_0x06060000 = 1 or ((3) shl 3)
	VRAM_D_ARM7 = 2 or ((1) shl 3)
	VRAM_D_ARM7_0x06000000 = 2 or ((0) shl 3)
	VRAM_D_ARM7_0x06020000 = 2 or ((1) shl 3)
	VRAM_D_SUB_SPRITE = 4
	VRAM_D_TEXTURE = 3 or ((3) shl 3)
	VRAM_D_TEXTURE_SLOT0 = 3 or ((0) shl 3)
	VRAM_D_TEXTURE_SLOT1 = 3 or ((1) shl 3)
	VRAM_D_TEXTURE_SLOT2 = 3 or ((2) shl 3)
	VRAM_D_TEXTURE_SLOT3 = 3 or ((3) shl 3)
end enum


enum VRAM_E_TYPE
	VRAM_E_LCD = 0
	VRAM_E_MAIN_BG = 1
	VRAM_E_MAIN_SPRITE = 2
	VRAM_E_TEX_PALETTE = 3
	VRAM_E_BG_EXT_PALETTE = 4
end enum


enum VRAM_F_TYPE
	VRAM_F_LCD = 0
	VRAM_F_MAIN_BG = 1
	VRAM_F_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_F_MAIN_BG_0x06004000 = 1 or ((1) shl 3)
	VRAM_F_MAIN_BG_0x06010000 = 1 or ((2) shl 3)
	VRAM_F_MAIN_BG_0x06014000 = 1 or ((3) shl 3)
	VRAM_F_MAIN_SPRITE = 2
	VRAM_F_MAIN_SPRITE_0x06400000 = 2 or ((0) shl 3)
	VRAM_F_MAIN_SPRITE_0x06404000 = 2 or ((1) shl 3)
	VRAM_F_MAIN_SPRITE_0x06410000 = 2 or ((2) shl 3)
	VRAM_F_MAIN_SPRITE_0x06414000 = 2 or ((3) shl 3)
	VRAM_F_TEX_PALETTE = 3
	VRAM_F_TEX_PALETTE_SLOT0 = 3 or ((0) shl 3)
	VRAM_F_TEX_PALETTE_SLOT1 = 3 or ((1) shl 3)
	VRAM_F_TEX_PALETTE_SLOT4 = 3 or ((2) shl 3)
	VRAM_F_TEX_PALETTE_SLOT5 = 3 or ((3) shl 3)
	VRAM_F_BG_EXT_PALETTE = 4
	VRAM_F_BG_EXT_PALETTE_SLOT01 = 4 or ((0) shl 3)
	VRAM_F_BG_EXT_PALETTE_SLOT23 = 4 or ((1) shl 3)
	VRAM_F_SPRITE_EXT_PALETTE = 5
end enum


enum VRAM_G_TYPE
	VRAM_G_LCD = 0
	VRAM_G_MAIN_BG = 1
	VRAM_G_MAIN_BG_0x06000000 = 1 or ((0) shl 3)
	VRAM_G_MAIN_BG_0x06004000 = 1 or ((1) shl 3)
	VRAM_G_MAIN_BG_0x06010000 = 1 or ((2) shl 3)
	VRAM_G_MAIN_BG_0x06014000 = 1 or ((3) shl 3)
	VRAM_G_MAIN_SPRITE = 2
	VRAM_G_MAIN_SPRITE_0x06400000 = 2 or ((0) shl 3)
	VRAM_G_MAIN_SPRITE_0x06404000 = 2 or ((1) shl 3)
	VRAM_G_MAIN_SPRITE_0x06410000 = 2 or ((2) shl 3)
	VRAM_G_MAIN_SPRITE_0x06414000 = 2 or ((3) shl 3)
	VRAM_G_TEX_PALETTE = 3
	VRAM_G_TEX_PALETTE_SLOT0 = 3 or ((0) shl 3)
	VRAM_G_TEX_PALETTE_SLOT1 = 3 or ((1) shl 3)
	VRAM_G_TEX_PALETTE_SLOT4 = 3 or ((2) shl 3)
	VRAM_G_TEX_PALETTE_SLOT5 = 3 or ((3) shl 3)
	VRAM_G_BG_EXT_PALETTE = 4
	VRAM_G_BG_EXT_PALETTE_SLOT01 = 4 or ((0) shl 3)
	VRAM_G_BG_EXT_PALETTE_SLOT23 = 4 or ((1) shl 3)
	VRAM_G_SPRITE_EXT_PALETTE = 5
end enum


enum VRAM_H_TYPE
	VRAM_H_LCD = 0
	VRAM_H_SUB_BG = 1
	VRAM_H_SUB_BG_EXT_PALETTE = 2
end enum


enum VRAM_I_TYPE
	VRAM_I_LCD = 0
	VRAM_I_SUB_BG_0x06208000 = 1
	VRAM_I_SUB_SPRITE = 2
	VRAM_I_SUB_SPRITE_EXT_PALETTE = 3
end enum

type _palette as u16 ptr
type _ext_palette as _palette ptr

declare function vramSetPrimaryBanks cdecl alias "vramSetPrimaryBanks" (byval a as VRAM_A_TYPE, byval b as VRAM_B_TYPE, byval c as VRAM_C_TYPE, byval d as VRAM_D_TYPE) as u32
declare function vramSetMainBanks cdecl alias "vramSetMainBanks" (byval a as VRAM_A_TYPE, byval b as VRAM_B_TYPE, byval c as VRAM_C_TYPE, byval d as VRAM_D_TYPE) as u32
declare function vramSetBanks_EFG cdecl alias "vramSetBanks_EFG" (byval e as VRAM_E_TYPE, byval f as VRAM_F_TYPE, byval g as VRAM_G_TYPE) as u32
declare function vramDefault cdecl alias "vramDefault" () as u32
declare sub vramRestorePrimaryBanks cdecl alias "vramRestorePrimaryBanks" (byval vramTemp as u32)
declare sub vramRestoreMainBanks cdecl alias "vramRestoreMainBanks" (byval vramTemp as u32)
declare sub vramRestoreBanks_EFG cdecl alias "vramRestoreBanks_EFG" (byval vramTemp as u32)

#define	REG_DISPCNT	cast_vu32_ptr(&h04000000)
#define	REG_DISPCNT_SUB	cast_vu32_ptr(&h04001000)

#define ENABLE_3D (1 shl 3)
#define DISPLAY_ENABLE_SHIFT 8
#define DISPLAY_BG0_ACTIVE (1 shl 8)
#define DISPLAY_BG1_ACTIVE (1 shl 9)
#define DISPLAY_BG2_ACTIVE (1 shl 10)
#define DISPLAY_BG3_ACTIVE (1 shl 11)
#define DISPLAY_SPR_ACTIVE (1 shl 12)
#define DISPLAY_WIN0_ON (1 shl 13)
#define DISPLAY_WIN1_ON (1 shl 14)
#define DISPLAY_SPR_WIN_ON (1 shl 15)

enum VideoMode
	MODE_0_2D = &h10000
	MODE_1_2D = &h10001
	MODE_2_2D = &h10002
	MODE_3_2D = &h10003
	MODE_4_2D = &h10004
	MODE_5_2D = &h10005
	MODE_6_2D = &h10006
	MODE_0_3D = (&h10000 or (1 shl 8) or (1 shl 3))
	MODE_1_3D = (&h10001 or (1 shl 8) or (1 shl 3))
	MODE_2_3D = (&h10002 or (1 shl 8) or (1 shl 3))
	MODE_3_3D = (&h10003 or (1 shl 8) or (1 shl 3))
	MODE_4_3D = (&h10004 or (1 shl 8) or (1 shl 3))
	MODE_5_3D = (&h10005 or (1 shl 8) or (1 shl 3))
	MODE_6_3D = (&h10006 or (1 shl 8) or (1 shl 3))
	MODE_FIFO = (3 shl 16)
	MODE_FB0 = (&h00020000)
	MODE_FB1 = (&h00060000)
	MODE_FB2 = (&h000A0000)
	MODE_FB3 = (&h000E0000)
end enum


#define DISPLAY_SPR_HBLANK (1 shl 23)
#define DISPLAY_SPR_1D_LAYOUT (1 shl 4)
#define DISPLAY_SPR_1D (1 shl 4)
#define DISPLAY_SPR_2D (0 shl 4)
#define DISPLAY_SPR_1D_BMP (4 shl 4)
#define DISPLAY_SPR_2D_BMP_128 (0 shl 4)
#define DISPLAY_SPR_2D_BMP_256 (2 shl 4)
#define DISPLAY_SPR_1D_SIZE_32 (0 shl 20)
#define DISPLAY_SPR_1D_SIZE_64 (1 shl 20)
#define DISPLAY_SPR_1D_SIZE_128 (2 shl 20)
#define DISPLAY_SPR_1D_SIZE_256 (3 shl 20)
#define DISPLAY_SPR_1D_BMP_SIZE_128 (0 shl 22)
#define DISPLAY_SPR_1D_BMP_SIZE_256 (1 shl 22)
#define DISPLAY_SPRITE_ATTR_MASK ((7 shl 4) or (7 shl 20) or (1 shl 31))
#define DISPLAY_SPR_EXT_PALETTE (1 shl 31)
#define DISPLAY_BG_EXT_PALETTE (1 shl 30)
#define DISPLAY_SCREEN_OFF (1 shl 7)

declare sub setBrightness cdecl alias "setBrightness" (byval screen as integer, byval level as integer)

#define BLEND_NONE (0 shl 6)
#define BLEND_ALPHA (1 shl 6)
#define BLEND_FADE_WHITE (2 shl 6)
#define BLEND_FADE_BLACK (3 shl 6)
#define BLEND_SRC_BG0 (1 shl 0)
#define BLEND_SRC_BG1 (1 shl 1)
#define BLEND_SRC_BG2 (1 shl 2)
#define BLEND_SRC_BG3 (1 shl 3)
#define BLEND_SRC_SPRITE (1 shl 4)
#define BLEND_SRC_BACKDROP (1 shl 5)
#define BLEND_DST_BG0 (1 shl 8)
#define BLEND_DST_BG1 (1 shl 9)
#define BLEND_DST_BG2 (1 shl 10)
#define BLEND_DST_BG3 (1 shl 11)
#define BLEND_DST_SPRITE (1 shl 12)
#define BLEND_DST_BACKDROP (1 shl 13)
#define DCAP_MODE_A (0)
#define DCAP_MODE_B (1)
#define DCAP_MODE_BLEND (2)
#define DCAP_SRC_A_COMPOSITED (0)
#define DCAP_SRC_A_3DONLY (1)
#define DCAP_SRC_B_VRAM (0)
#define DCAP_SRC_B_DISPFIFO (1)
#define DCAP_SIZE_128x128 (0)
#define DCAP_SIZE_256x64 (1)
#define DCAP_SIZE_256x128 (2)
#define DCAP_SIZE_256x192 (3)
#define DCAP_BANK_VRAM_A (0)
#define DCAP_BANK_VRAM_B (1)
#define DCAP_BANK_VRAM_C (1)
#define DCAP_BANK_VRAM_D (2)

#define	REG_DISPCAPCNT		(cast_vu32_ptr(&h04000064))
#define REG_DISP_MMEM_FIFO	(cast_vu32_ptr(&h04000068))

#define DCAP_ENABLE      vBIT(31)
#define DCAP_MODE(n)     (((n) and 3) shl 29)
#define DCAP_SRC_ADDR(n) (((n) and 3) shl 26)
#define DCAP_SRC(n)      (((n) and 3) shl 24)
#define DCAP_SRC_A(n)    (((n) and 1) shl 24)
#define DCAP_SRC_B(n)    (((n) and 1) shl 25)
#define DCAP_SIZE(n)     (((n) and 3) shl 20)
#define DCAP_OFFSET(n)   (((n) and 3) shl 18)
#define DCAP_BANK(n)     (((n) and 3) shl 16)
#define DCAP_B(n)        (((n) and &h1F) shl 8)
#define DCAP_A(n)        (((n) and &h1F) shl 0)

#define vramSetBankA(inta) VRAM_A_CR = VRAM_ENABLE or inta:
#define vramSetBankB(intb) VRAM_B_CR = VRAM_ENABLE or intb:
#define vramSetBankC(intc) VRAM_C_CR = VRAM_ENABLE or intc:
#define vramSetBankD(intd) VRAM_D_CR = VRAM_ENABLE or intd:
#define vramSetBankE(inte) VRAM_E_CR = VRAM_ENABLE or inte:
#define vramSetBankF(intf) VRAM_F_CR = VRAM_ENABLE or intf:
#define vramSetBankG(intg) VRAM_G_CR = VRAM_ENABLE or intg:
#define vramSetBankH(inth) VRAM_H_CR = VRAM_ENABLE or inth:
#define vramSetBankI(inti) VRAM_I_CR = VRAM_ENABLE or inti:

#define videoSetMode( u32mode ) REG_DISPCNT = u32mode:
#define videoSetModeSub( u32mode ) REG_DISPCNT_SUB = u32mode:
#define videoGetMode() ((REG_DISPCNT) and &h30007)
#define videoGetModeSub() ((REG_DISPCNT_SUB) and &h30007)
#define video3DEnabled() iif((REG_DISPCNT andalso ENABLE_3D),true,false)
#define videoBgEnable(intnumber) REG_DISPCNT or= (1 shl (DISPLAY_ENABLE_SHIFT + intnumber):
#define videoBgEnableSub(intnumber) REG_DISPCNT_SUB or= (1 shl (DISPLAY_ENABLE_SHIFT + intnumber):
#define videoBgDisable(intnumber) REG_DISPCNT and= not (1 shl (DISPLAY_ENABLE_SHIFT + intnumber)):
#define videoBgDisableSub(intnumber) REG_DISPCNT_SUB and= not (1 shl (DISPLAY_ENABLE_SHIFT + intnumber)):
#define SetBackdropColor(u16color) BG_PALETTE[0] = u16color:
#define SetBackdropColorSub(u16color) BG_PALETTE_SUB[0] = u16color:


#endif
