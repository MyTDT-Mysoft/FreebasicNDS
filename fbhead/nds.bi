#ifndef NDS_INCLUDE
#define NDS_INCLUDE

#macro DoNothing()
  'asm
  '  add r0, #1
  'end asm
#endmacro
#macro DoNothing2()
  'print "";
#endmacro

#if __FB_DEBUG__
  #print " Using Nocash DEBUG"
  #macro sassert(a,b)
    if (a)=0 then nocashMessage( __FILE__ & " (" & __LINE__ & "): " & b)
  #endmacro
#else
  #define sassert(a,b)
 #endif
 
#define vbit(bitnum) (1 shl bitnum)
#define iprintf printf
#define infinite 0 to (1 shl 30)

#macro DeclareResourceInternal(BinName,TempBinEnd,TempBinSize)
extern as u8 ptr_##TempBinEnd alias #TempBinEnd
#define BinName##_end (@ptr_##TempBinEnd)
extern as u8 ptr_##BinName alias #BinName
#define BinName (@ptr_##BinName)
extern as u32 ##TempBinSize alias #TempBinSize
#endmacro

#macro DeclareResource(BinName)
#define TempBinEnd2 BinName##_end
#define TempBinSize2 BinName##_size
DeclareResourceInternal(BinName,TempBinEnd2,TempBinSize2)
#undef TempBinEnd2
#undef TempBinSize2
#endmacro

#ifndef ARM7
#ifndef ARM9
#error Either ARM7 or ARM9 must be defined
#endif
#endif

#ifndef uint32_t
#define uint32_t ulong
#endif

#include "nds/libversion.bi"
#include "nds/ndstypes.bi"
#include "nds/bios.bi"
#include "nds/card.bi"
#include "nds/debug.bi"
#include "nds/dma.bi"
#include "nds/interrupts.bi"
#include "nds/ipc.bi"
#include "nds/memory.bi"
#include "nds/system.bi"
#include "nds/timers.bi"
#include "nds/fifocommon.bi"
#include "nds/touch.bi"
#include "nds/input.bi"
'#include "nds/sha1.bi"

'---------------------------------------------------------------------------------
#ifdef ARM9
'---------------------------------------------------------------------------------

#include "nds/arm9/dynamicArray.bi"
'#include "nds/arm9/linkedlist.bi"
#include "nds/arm9/background.bi"
'#include "nds/arm9/boxtest.bi"
#include "nds/arm9/cache.bi"
#include "nds/arm9/console.bi"
#include "nds/arm9/decompress.bi"
#include "nds/arm9/exceptions.bi"
'#include "nds/arm9/guitarGrip.bi"
#include "nds/arm9/image.bi"
#include "nds/arm9/input.bi"
#include "nds/arm9/keyboard.bi"
#include "nds/arm9/math.bi"
'#include "nds/arm9/paddle.bi"
#include "nds/arm9/pcx.bi"
'#include "nds/arm9/piano.bi"
'#include "nds/arm9/rumble.bi"
'#include "nds/arm9/sassert.bi"
#include "nds/arm9/sound.bi"
#include "nds/arm9/sprite.bi"
'#include "nds/arm9/window.bi"
#include "nds/arm9/trig_lut.bi"
#include "nds/arm9/video.bi"
#include "nds/arm9/videoGL.bi"
'#include "nds/arm9/nand.bi"

'//---------------------------------------------------------------------------------
#endif '// #ifdef ARM9
'//---------------------------------------------------------------------------------

'//---------------------------------------------------------------------------------
#ifdef ARM7
'//---------------------------------------------------------------------------------

'#include "nds/arm7/aes.bi"
'#include "nds/arm7/audio.bi"
'#include "nds/arm7/clock.bi"
'#include "nds/arm7/codec.bi"
'#include "nds/arm7/input.bi"
'#include "nds/arm7/i2c.bi"
'#include "nds/arm7/sdmmc.bi"
'#include "nds/arm7/serial.bi"
'#include "nds/arm7/touch.bi"

'//---------------------------------------------------------------------------------
#endif '// #ifdef ARM7
'//---------------------------------------------------------------------------------

#endif '// NDS_INCLUDE
