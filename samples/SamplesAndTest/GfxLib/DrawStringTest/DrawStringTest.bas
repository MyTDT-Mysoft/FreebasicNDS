#ifdef __FB_NDS__
'#define __FB_NITRO__
'#define __FB_PRECISE_TIMER__
'#define __FB_GFX_NO_GL_RENDER__
#define __FB_GFX_NO_16BPP__
#define __FB_GFX_NO_OLD_HEADER__
#include "Modules\fbLib.bas"
#include "Modules\fbgfx.bas"
#else
#include "crt.bi"
#endif

#ifdef __FB_NDS__
gfx.GfxDriver = gfx.gdOpenGL
#endif

screenres 256,192,16

dim as integer FPS,FPC
dim as double TMR = timer

do
  
  line (0,0)-(255,191),0,bf  
  static as integer FRAME
  FRAME += 1
  for CNTY as integer = 0 to 23 step 2
    dim as integer CNY = CNTY+8,POSY = CNTY shl 3
    for CNTX as integer = 0 to 31 step 2
      dim as integer CNU = (((CNY+CNTX) shr 1)+FRAME) and 31
      CNU = rgb(CNU shl 1,CNU shl 2,CNU shl 3)
      line(CNTX shl 3,POSY)-((CNTX shl 3)+15,POSY+15),CNU,bf
    next CNTX
  next CNTY
  
  draw string (4,4),"Fps: " & FPS,rgb(255,128,64)  
  draw string (8,82),"Mysoft... freebasic... fbgfx "+chr$(1),rgb(21,064,21)
  draw string (8,92),"Mysoft... freebasic... fbgfx "+chr$(1),rgb(42,128,42)
  draw string (8,102),"Mysoft... freebasic... fbgfx "+chr$(1),rgb(85,255,85)

  draw string (60-1,30),"Draw string Test",rgb(255,255,255)
  draw string (60+1,30),"Draw string Test",rgb(255,255,255)
  draw string (60,30-1),"Draw string Test",rgb(255,255,255)
  draw string (60,30+1),"Draw string Test",rgb(255,255,255)
  draw string (60-1,30-1),"Draw string Test",rgb(255,255,255)
  draw string (60+1,30+1),"Draw string Test",rgb(255,255,255)
  draw string (60-1,30+1),"Draw string Test",rgb(255,255,255)
  draw string (60+1,30-1),"Draw string Test",rgb(255,255,255)
  draw string (60,30),"Draw string Test",rgb(0,0,0)
  
  draw string (60-1,162),"Draw string Test",rgb(0,0,64)
  draw string (60+1,162),"Draw string Test",rgb(0,0,64)
  draw string (60,162-1),"Draw string Test",rgb(0,0,64)
  draw string (60,162+1),"Draw string Test",rgb(0,0,64)
  draw string (60-1,162-1),"Draw string Test",rgb(0,0,64)
  draw string (60+1,162+1),"Draw string Test",rgb(0,0,64)
  draw string (60-1,162+1),"Draw string Test",rgb(0,0,64)
  draw string (60+1,162-1),"Draw string Test",rgb(0,0,64)
  draw string (60,162),"Draw string Test",rgb(85,255,255)

  flip  
  'screensync
    
  FPC += 1
  if (timer-TMR) >= .5 then
    FPS=FPC*2:FPC=0:TMR = timer
  end if
  
loop until inkey$ <> ""
























#if 0
#include "gfx.bas"

gfx.GfxDriver = gfx.gdOpenGL
screenres 256,192,8

dim as any ptr MyImage = ImageCreate(256,256)
dim as integer MyTexture 
dim as any ptr MyPal = callocate(256*4),SwPal = callocate(256*4)
dim as any ptr Ying(15)

dim as any ptr Stack
asm
  str r13,$Stack
end asm

print hex$(cuint(Stack),8)

for CNT as integer = 0 to 15
  Ying(CNT) = ImageCreate(58,48)
next CNT

bload "test.bmp",MyImage,MyPal

for CNT as integer = 0 to 15
  dim as string Temp
  Temp = "0"+str$(CNT)
  bload "Ying"+right$(Temp,2)+".bmp",Ying(CNT),SwPal
next CNT

palcopy SwPal,MyPal,128,255

dim as double TMR
static as integer Frame

do
  
  dim as integer VX = 255
  dim as integer XX = VX shl (12-8)
  
  dim as integer MX,MY
  
  getmouse MX,MY
  
  Frame += 1
  if (Frame and 3) = 0 then    
    palrotate MyPal,1,54,63
    palrotate MyPal,1,67,79   '67,79
    palrotate MyPal,1,83,95   '83,96
    palrotate MyPal,1,99,111  '99,111
    palrotate MyPal,1,113,127 '113,127 
  end if
  
  palset MyPal,0,255
    
  Put (0,0),MyImage,pset
  put (MX-29,MY-24),Ying((Frame and 31) shr 1),trans
  
  flip    
  screensync  
    
loop

sleep
#endif


