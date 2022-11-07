''
''
'' dma -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __dma_bi__
#define __dma_bi__

#define DMA0_SRC       cast_vuint32_ptr(&h040000B0)
#define DMA0_DEST      cast_vuint32_ptr(&h040000B4)
#define DMA0_CR        cast_vuint32_ptr(&h040000B8)

#define DMA1_SRC       cast_vuint32_ptr(&h040000BC)
#define DMA1_DEST      cast_vuint32_ptr(&h040000C0)
#define DMA1_CR        cast_vuint32_ptr(&h040000C4)

#define DMA2_SRC       cast_vuint32_ptr(&h040000C8)
#define DMA2_DEST      cast_vuint32_ptr(&h040000CC)
#define DMA2_CR        cast_vuint32_ptr(&h040000D0)

#define DMA3_SRC       cast_vuint32_ptr(&h040000D4)
#define DMA3_DEST      cast_vuint32_ptr(&h040000D8)
#define DMA3_CR        cast_vuint32_ptr(&h040000DC)


#define DMA_SRC(intn)  cast_vuint32_ptr((cuint(&h040000B0)+(intn*12)))
#define DMA_DEST(intn) cast_vuint32_ptr((cuint(&h040000B4)+(intn*12)))
#define DMA_CR(intn)   cast_vuint32_ptr((cuint(&h040000B8)+(intn*12)))

#ifdef ARM9
#define DMA_FILL(intn) cast_vuint32_ptr((&h040000E0+(intn*4)))
#define pDMA_FILL(intn) cptr_vuint32_ptr((&h040000E0+(intn*4)))
#endif


#define DMA_START_NOW 0
#define DMA_START_CARD (5 shl 27)
#define DMA_16_BIT 0

const DMA_ENABLE  = vBIT(31)
const DMA_BUSY    = vBIT(31)
const DMA_IRQ_REQ = vBIT(30)

#ifdef ARM7
#define DMA_START_VBL   vBIT(27)
#endif

#ifdef ARM9
#define DMA_START_HBL   vBIT(28)
#define DMA_START_VBL   vBIT(27)
#define DMA_START_FIFO	(7 shl 27)
#define DMA_DISP_FIFO	(4 shl 27)
#endif

#define DMA_16_BIT      0
#define DMA_32_BIT      vBIT(26)


#define DMA_REPEAT      vBIT(25)

#define DMA_SRC_INC     (0)
#define DMA_SRC_DEC     vBIT(23)
#define DMA_SRC_FIX     vBIT(24)

#define DMA_DST_INC     (0)
#define DMA_DST_DEC     vBIT(21)
#define DMA_DST_FIX     vBIT(22)
#define DMA_DST_RESET   (3 shl 21)

#define DMA_COPY_WORDS     (DMA_ENABLE or DMA_32_BIT or DMA_START_NOW)
#define DMA_COPY_HALFWORDS (DMA_ENABLE or DMA_16_BIT or DMA_START_NOW)
#define DMA_FIFO	(DMA_ENABLE or DMA_32_BIT  or DMA_DST_FIX or DMA_START_FIFO)

#macro dmaCopyWords(uint8channel, voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(uint8channel) = cast(uint32,voidptrsrc)
  DMA_DEST(uint8channel) = cast(uint32,voidptrdest)
  DMA_CR(uint8channel) = DMA_COPY_WORDS or (cast(uint32,uint32size) shr 2)
  do : loop while (DMA_CR(uint8channel) and DMA_BUSY)  
#endmacro
#macro dmaCopyHalfWords(uint8channel, voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(uint8channel) = cast(uint32,voidptrsrc)
  DMA_DEST(uint8channel) = cast(uint32,voidptrdest)
  DMA_CR(uint8channel) = DMA_COPY_HALFWORDS  or (cast(uint32,uint32size) shr 1)
  do : loop while  (DMA_CR(uint8channel) and DMA_BUSY)
#endmacro
#macro dmaCopy(voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(3) = cast(uint32,voidptrsrc)
  DMA_DEST(3) = cast(uint32,voidptrdest)
  DMA_CR(3) = DMA_COPY_HALFWORDS  or (cast(uint32,uint32size) shr 1)
  do : loop while (DMA_CR(3) and DMA_BUSY)
#endmacro

#macro dmaCopyWordsAsynch(uint8channel, voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(uint8channel) = cast(uint32,voidptrsrc)
  DMA_DEST(uint8channel) = cast(uint32,voidptrdest)
  DMA_CR(uint8channel) = DMA_COPY_WORDS or (cast(uint32,uint32size) shr 2)
#endmacro
#macro dmaCopyHalfWordsAsynch(uint8channel, voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(uint8channel) = cast(uint32,voidptrsrc)
  DMA_DEST(uint8channel) = cast(uint32,voidptrdest)
  DMA_CR(uint8channel) = DMA_COPY_HALFWORDS  or (cast(uint32,uint32size) shr 1)
#endmacro
#macro dmaCopyAsynch(voidptrsrc, voidptrdest, uint32size)
  DMA_SRC(3) = cast(uint32,voidptrsrc)
  DMA_DEST(3) = cast(uint32,voidptrdest)
  DMA_CR(3) = DMA_COPY_HALFWORDS  or (cast(uint32,uint32size) shr 1)
#endmacro


#macro dmaFillWords(u32value, voidptrdest, uint32size)
  #ifdef ARM7	
    cast_vu32_ptr(&h027FFE04) = u32value 'cast_vu32_ptr(@u32value)
    DMA_SRC(3) = &h027FFE04
  #else	
    DMA_FILL(3) = u32value 'cast_vuint32_ptr(@u32value)
    DMA_SRC(3) = cast(uint32,(pDMA_FILL(3)))
  #endif	
  DMA_DEST(3) = cast(uint32,voidptrdest)
  DMA_CR(3) = DMA_SRC_FIX or DMA_COPY_WORDS or (uint32size shr 2)
  do : loop while (DMA_CR(3) and DMA_BUSY)
#endmacro
#macro dmaFillHalfWords(u32value, voidptrdest, uint32size)
  #ifdef ARM7	
    cast_vu32_ptr(&h027FFE04) = u32value 'cast_vu32_ptr(@u32value)
    DMA_SRC(3) = &h027FFE04
  #else	
    DMA_FILL(3) = u32value 'cast_vuint32_ptr(@u32value)
    DMA_SRC(3) = cast(uint32,(pDMA_FILL(3)))
  #endif	
  DMA_DEST(3) = cast(uint32,voidptrdest)
  DMA_CR(3) = DMA_SRC_FIX or DMA_COPY_HALFWORDS or ((uint32size) shr 1)
  do : loop while (DMA_CR(3) and DMA_BUSY)
#endmacro

#macro dmaFillWordsasynch(uint8channel,u32value, voidptrdest, uint32size)
  #ifdef ARM7	
    cast_vu32_ptr(&h027FFE04+(uint8channel shl 2)) = u32value 'cast(vu32,u32value)
    DMA_SRC(uint8channel) = &h027FFE04+(uint8channel shl 2)
  #else	
    DMA_FILL(uint8channel) = u32value 'cast_vuint32_ptr(@u32value)
    DMA_SRC(uint8channel) = cast(uint32,(pDMA_FILL(uint8channel)))
  #endif	
  DMA_DEST(uint8channel) = cast(uint32,voidptrdest)
  DMA_CR(uint8channel) = DMA_SRC_FIX or DMA_COPY_WORDS or (uint32size shr 2)
#endmacro
#macro dmaFillHalfWordsasynch(u32value, voidptrdest, uint32size)
  #ifdef ARM7	
    cast_vu32_ptr(&h027FFE04) = u32value 'cast_vu32_ptr(@u32value)
    DMA_SRC(3) = &h027FFE04
  #else	
    DMA_FILL(3) = u32value 'cast_vuint32_ptr(@u32value)
    DMA_SRC(3) = cast(uint32,(pDMA_FILL(3)))
  #endif	
  DMA_DEST(3) = cast(uint32,voidptrdest)
  DMA_CR(3) = DMA_SRC_FIX or DMA_COPY_HALFWORDS or ((uint32size) shr 1)
#endmacro

#define dmaBusy(uint8channel) ((DMA_CR(uint8channel) and DMA_BUSY) shr 31)

#endif
