''
''
'' registers_alt -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __registers_alt_bi__
#define __registers_alt_bi__

#include "nds/ndstypes.bi"

'// math registers
#define DIV_CR			REG_DIVCNT

#define DIV_NUMERATOR64		REG_DIV_NUMER
#define DIV_NUMERATOR32		REG_DIV_NUMER_L

#define DIV_DENOMINATOR64	REG_DIV_DENOM
#define DIV_DENOMINATOR32	REG_DIV_DENOM_L

#define DIV_RESULT64  REG_DIV_RESULT
#define DIV_RESULT32  REG_DIV_RESULT_L

#define DIV_REMAINDER64  REG_DIVREM_RESULT
#define DIV_REMAINDER32  REG_DIVREM_RESULT_L

#define SQRT_CR        REG_SQRTCNT
#define SQRT_PARAM64   REG_SQRT_PARAM
#define SQRT_PARAM32   REG_SQRT_PARAM_L
#define SQRT_RESULT32  REG_SQRT_RESULT

'// graphics registers

#define DISPLAY_CR  REG_DISPCNT

#ifdef ARM9
#define WAIT_CR     REG_EXMEMCNT
#else
#define WAIT_CR     REG_EXMEMSTAT
#endif

#define DISP_SR			REG_DISPSTAT
#define DISP_Y			REG_VCOUNT

#define BG0_CR			REG_BG0CNT
#define BG1_CR			REG_BG1CNT
#define BG2_CR			REG_BG2CNT
#define BG3_CR			REG_BG3CNT

#define BG0_X0			REG_BG0HOFS
#define BG0_Y0			REG_BG0VOFS
#define BG1_X0			REG_BG1HOFS
#define BG1_Y0			REG_BG1VOFS
#define BG2_X0			REG_BG2HOFS
#define BG2_Y0			REG_BG2VOFS
#define BG3_X0			REG_BG3HOFS
#define BG3_Y0			REG_BG3VOFS

#define BG2_XDX			REG_BG2PA
#define BG2_XDY			REG_BG2PB
#define BG2_YDX			REG_BG2PC
#define BG2_YDY			REG_BG2PD
#define BG2_CX			REG_BG2X
#define BG2_CY			REG_BG2Y

#define BG3_XDX			REG_BG3PA
#define BG3_XDY			REG_BG3PB
#define BG3_YDX			REG_BG3PC
#define BG3_YDY			REG_BG3PD
#define BG3_CX			REG_BG3X
#define BG3_CY			REG_BG3Y

#define	REG_WIN0H		cast_vu16_ptr(&h4000040)
#define	REG_WIN1H		cast_vu16_ptr(&h4000042)
#define	REG_WIN0V		cast_vu16_ptr(&h4000044)
#define	REG_WIN1V		cast_vu16_ptr(&h4000046)
#define	REG_WININ		cast_vu16_ptr(&h4000048)
#define	REG_WINOUT  cast_vu16_ptr(&h400004A)


#define MOSAIC_CR REG_MOSAIC

#define BLEND_CR  REG_BLDCNT
#define BLEND_AB  REG_BLDALPHA
#define BLEND_Y   REG_BLDY

#define SUB_BLEND_CR  REG_BLDCNT_SUB
#define SUB_BLEND_AB  REG_BLDALPHA_SUB
#define SUB_BLEND_Y   REG_BLDY_SUB


#define SERIAL_CR   REG_SPICNT
#define SERIAL_DATA REG_SPIDATA
#define SIO_CR      REG_SIOCNT
#define R_CR        REG_RCNT

#define	DISP_CAPTURE  REG_DISPCAPCNT

#define BRIGHTNESS      REG_MASTER_BRIGHT
#define SUB_BRIGHTNESS  REG_MASTER_BRIGHT_SUB

'/*	secondary screen */
#define SUB_DISPLAY_CR  REG_DISPCNT_SUB

#define SUB_BG0_CR		REG_BG0CNT_SUB
#define SUB_BG1_CR		REG_BG1CNT_SUB
#define SUB_BG2_CR		REG_BG2CNT_SUB
#define SUB_BG3_CR		REG_BG3CNT_SUB

#define SUB_BG0_X0		REG_BG0HOFS_SUB
#define SUB_BG0_Y0		REG_BG0VOFS_SUB
#define SUB_BG1_X0		REG_BG1HOFS_SUB
#define SUB_BG1_Y0		REG_BG1VOFS_SUB
#define SUB_BG2_X0		REG_BG2HOFS_SUB
#define SUB_BG2_Y0		REG_BG2VOFS_SUB
#define SUB_BG3_X0		REG_BG3HOFS_SUB
#define SUB_BG3_Y0		REG_BG3VOFS_SUB

#define SUB_BG2_XDX		REG_BG2PA_SUB
#define SUB_BG2_XDY		REG_BG2PB_SUB
#define SUB_BG2_YDX		REG_BG2PC_SUB
#define SUB_BG2_YDY		REG_BG2PD_SUB
#define SUB_BG2_CX		REG_BG2X_SUB
#define SUB_BG2_CY		REG_BG2Y_SUB

#define SUB_BG3_XDX		REG_BG3PA_SUB
#define SUB_BG3_XDY		REG_BG3PB_SUB
#define SUB_BG3_YDX		REG_BG3PC_SUB
#define SUB_BG3_YDY		REG_BG3PD_SUB
#define SUB_BG3_CX		REG_BG3X_SUB
#define SUB_BG3_CY		REG_BG3Y_SUB

#define	REG_WIN0H_SUB   cast_vu16_ptr(&h4001040)
#define	REG_WIN1H_SUB   cast_vu16_ptr(&h4001042)
#define	REG_WIN0V_SUB   cast_vu16_ptr(&h4001044)
#define	REG_WIN1V_SUB   cast_vu16_ptr(&h4001046)
#define	REG_WININ_SUB   cast_vu16_ptr(&h4001048)
#define	REG_WINOUT_SUB  cast_vu16_ptr(&h400104A)

#define	SUB_MOSAIC_CR  REG_MOSAIC_SUB

#define	REG_BLDMOD_SUB cast_vu16_ptr(&h4001050)
#define	REG_COLV_SUB   cast_vu16_ptr(&h4001052)
#define	REG_COLY_SUB   cast_vu16_ptr(&h4001054)

'/*common*/

#define	REG_DMA0SAD		cast_vu32_ptr(&h40000B0)
#define	REG_DMA0SAD_L	cast_vu16_ptr(&h40000B0)
#define	REG_DMA0SAD_H	cast_vu16_ptr(&h40000B2)
#define	REG_DMA0DAD		cast_vu32_ptr(&h40000B4)
#define	REG_DMA0DAD_L	cast_vu16_ptr(&h40000B4)
#define	REG_DMA0DAD_H	cast_vu16_ptr(&h40000B6)
#define	REG_DMA0CNT		cast_vu32_ptr(&h40000B8)
#define	REG_DMA0CNT_L	cast_vu16_ptr(&h40000B8)
#define	REG_DMA0CNT_H	cast_vu16_ptr(&h40000BA)

#define	REG_DMA1SAD		cast_vu32_ptr(&h40000BC)
#define	REG_DMA1SAD_L	cast_vu16_ptr(&h40000BC)
#define	REG_DMA1SAD_H	cast_vu16_ptr(&h40000BE)
#define	REG_DMA1DAD		cast_vu32_ptr(&h40000C0)
#define	REG_DMA1DAD_L	cast_vu16_ptr(&h40000C0)
#define	REG_DMA1DAD_H	cast_vu16_ptr(&h40000C2)
#define	REG_DMA1CNT		cast_vu32_ptr(&h40000C4)
#define	REG_DMA1CNT_L	cast_vu16_ptr(&h40000C4)
#define	REG_DMA1CNT_H	cast_vu16_ptr(&h40000C6)

#define	REG_DMA2SAD		cast_vu32_ptr(&h40000C8)
#define	REG_DMA2SAD_L	cast_vu16_ptr(&h40000C8)
#define	REG_DMA2SAD_H	cast_vu16_ptr(&h40000CA)
#define	REG_DMA2DAD		cast_vu32_ptr(&h40000CC)
#define	REG_DMA2DAD_L	cast_vu16_ptr(&h40000CC)
#define	REG_DMA2DAD_H	cast_vu16_ptr(&h40000CE)
#define	REG_DMA2CNT		cast_vu32_ptr(&h40000D0)
#define	REG_DMA2CNT_L	cast_vu16_ptr(&h40000D0)
#define	REG_DMA2CNT_H	cast_vu16_ptr(&h40000D2)

#define	REG_DMA3SAD		cast_vu32_ptr(&h40000D4)
#define	REG_DMA3SAD_L	cast_vu16_ptr(&h40000D4)
#define	REG_DMA3SAD_H	cast_vu16_ptr(&h40000D6)
#define	REG_DMA3DAD		cast_vu32_ptr(&h40000D8)
#define	REG_DMA3DAD_L	cast_vu16_ptr(&h40000D8)
#define	REG_DMA3DAD_H	cast_vu16_ptr(&h40000DA)
#define	REG_DMA3CNT		cast_vu32_ptr(&h40000DC)
#define	REG_DMA3CNT_L	cast_vu16_ptr(&h40000DC)
#define	REG_DMA3CNT_H	cast_vu16_ptr(&h40000DE)

#define	REG_TIME    cptr_vu16_ptr(&h4000100)
#define	REG_TM0D    cast_vu16_ptr(&h4000100)
#define	REG_TM0CNT  cast_vu16_ptr(&h4000102)
#define	REG_TM1D    cast_vu16_ptr(&h4000106)
#define	REG_TM2D    cast_vu16_ptr(&h4000108)
#define	REG_TM2CNT  cast_vu16_ptr(&h400010A)
#define	REG_TM3D    cast_vu16_ptr(&h400010C)
#define	REG_TM3CNT  cast_vu16_ptr(&h400010E)

#define	REG_SIOCNT      cast_vu16_ptr(&h4000128)
#define	REG_SIOMLT_SEND cast_vu16_ptr(&h400012A)

#define	_KEYS       REG_KEYINPUT
#define	KEYS_CR     REG_KEYCNT
'//??? (sio defines, no link port though)
#define	REG_RCNT    cast_vu16_ptr(&h4000134)
#define	REG_HS_CTRL cast_vu16_ptr(&h4000140)

'/* Interupt	enable registers */
#define	IE			REG_IE
#define	_IF			REG_IF
#define	IME			REG_IME

'/*controls power  &h30f	is all on */
#define POWER_CR	REG_POWERCNT

'/* ram	controllers	0&h8	is enabled,	other bits have	to do with mapping */
#define	REG_VRAM_A_CR	cast_vu8_ptr(&h4000240)
#define	REG_VRAM_B_CR	cast_vu8_ptr(&h4000241)
#define	REG_VRAM_C_CR	cast_vu8_ptr(&h4000242)
#define	REG_VRAM_D_CR	cast_vu8_ptr(&h4000243)
#define	REG_VRAM_E_CR	cast_vu8_ptr(&h4000244)
#define	REG_VRAM_F_CR	cast_vu8_ptr(&h4000245)
#define	REG_VRAM_G_CR	cast_vu8_ptr(&h4000246)
#define	REG_VRAM_H_CR	cast_vu8_ptr(&h4000248)
#define	REG_VRAM_I_CR	cast_vu8_ptr(&h4000249)
#define	REG_WRAM_CNT	cast_vu8_ptr(&h4000247)


'/*3D graphics stuff*/
#define	REG_GFX_FIFO    cast_vu32_ptr(&h4000400)
#define	REG_GFX_STATUS  cast_vu32_ptr(&h4000600)
#define	REG_GFX_CONTROL cast_vu16_ptr(&h4000060)
#define	REG_COLOR       cast_vu32_ptr(&h4000480)
#define	REG_VERTEX16    cast_vu32_ptr(&h400048C)
#define	REG_TEXT_COORD  cast_vu32_ptr(&h4000488)
#define	REG_TEXT_FORMAT cast_vu32_ptr(&h40004A8)


#define	REG_CLEAR_COLOR cast_vu32_ptr(&h4000350)
#define	REG_CLEAR_DEPTH cast_vu16_ptr(&h4000354)

#define	REG_LIGHT_VECTOR cast_vu32_ptr(&h40004C8)
#define	REG_LIGHT_COLOR  cast_vu32_ptr(&h40004CC)
#define	REG_NORMAL       cast_vu32_ptr(&h4000484)

#define	REG_DIFFUSE_AMBIENT   cast_vu32_ptr(&h40004C0)
#define	REG_SPECULAR_EMISSION	cast_vu32_ptr(&h40004C4)
#define	REG_SHININESS         cast_vu32_ptr(&h40004D0)

#define	REG_POLY_FORMAT cast_vu32_ptr(&h40004A4)

#define	REG_GFX_BEGIN    cast_vu32_ptr(&h4000500)
#define	REG_GFX_END      cast_vu32_ptr(&h4000504)
#define	REG_GFX_FLUSH    cast_vu32_ptr(&h4000540)
#define	REG_GFX_VIEWPORT cast_vu32_ptr(&h4000580)

#define	REG_MTX_CONTROL   cast_vu32_ptr(&h4000440)
#define	REG_MTX_PUSH      cast_vu32_ptr(&h4000444)
#define	REG_MTX_POP       cast_vu32_ptr(&h4000448)
#define	REG_MTX_SCALE     cast_vint32_ptr(&h400046C)
#define	REG_MTX_TRANSLATE cast_vint32_ptr(&h4000470)
#define	REG_MTX_RESTORE   cast_vu32_ptr(&h4000450)
#define	REG_MTX_STORE     cast_vu32_ptr(&h400044C)
#define	REG_MTX_IDENTITY  cast_vu32_ptr(&h4000454)
#define	REG_MTX_LOAD4x4   (*cast(f32 ptr,&h4000458))
#define	REG_MTX_LOAD4x3   (*cast(f32 ptr,&h400045C))
#define	REG_MTX_MULT4x4   (*cast(f32 ptr,&h4000460))
#define	REG_MTX_MULT4x3   (*cast(f32 ptr,&h4000464))
#define	REG_MTX_MULT3x3   (*cast(f32 ptr,&h4000468))

'// Card	bus

#define	CARD_CR1     REG_AUXSPICNT
#define	CARD_CR1H    REG_AUXSPICNTH
#define	CARD_CR2     REG_ROMCTRL
#define CARD_EEPDATA REG_AUXSPIDATA

#define	REG_CARD_DATA  cast_vu32_ptr(&h04100000)
#define CARD_COMMAND   REG_CARD_COMMAND
#define	CARD_DATA_RD   REG_CARD_DATA_RD
#define	CARD_1B0       REG_CARD_1B0
#define	CARD_1B4       REG_CARD_1B4
#define	CARD_1B8       REG_CARD_1B8
#define	CARD_1BA       REG_CARD_1BA

'// sound

#define SOUND_CR         REG_SOUNDCNT
#define SOUND_MASTER_VOL REG_MASTER_VOLUME
#define SOUND_BIAS       REG_SOUNDBIAS

#endif

