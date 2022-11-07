DeclareResource(fbgfxfont_tex)

type fbBmpFileHeader field=1
  as ushort   Signature    'BM
  as uinteger FileSize     'Size of BMP file
  as uinteger Reserved1    'Reserved O.o
  as uinteger ImageOffset  'Offset to image data
  as uinteger BihSize      'size of BITMAPINFOHEADER structure, must be 40
  as uinteger Wid          'Image Width
  as uinteger Hei          'Image Height
  as ushort   Planes       'Must be 1 (no mode-x .bmp :P)
  as ushort   Bpp          'Bits Per Pixel (1,4,8,16,24,32)
  as uinteger Compression  'compression type (0=none, 1=RLE-8, 2=RLE-4)
  as uinteger ImageSize    'Size of image data (plus paddings)
  as uinteger hres         'ppm Horizontal resolution (lol)
  as uinteger vres         'ppm Vertical resolution (lol)
  as uinteger MaxColors    'number of colors in image, or zero
  as uinteger NeedColors   'number of important colors, or zero
end type
' ***************************************************************************************
' *****************************  Atan Table used for circles ****************************
' ***************************************************************************************
static shared as short ifbAtnTab(2048) 'iTabSize
scope 'Init Table
  const _PI2=6.2831854,_iTabSize = 2048 '~(Radius/1.4) usage
  for CNT as integer = 0 to _iTabSize
    ifbAtnTab(CNT) = atn(CNT/_iTabSize)*(16384/_PI2)
  next CNT
end scope
' ***************************************************************************************
' ************************** CONVERT A RGB888 to RGBA1555 *******************************
function _FB_Inline(fb_Gfx24to16) (Color32 as uinteger) as ushort
  if (Color32 and &hFFFFFF) = &hFF00FF then
    return gfx.TransColor16
  else
    #define iBlue Color32 and 255
    #define iGreen (Color32 shr 8) and 255
    #define iRed (Color32 shr 16) and 255
    #define RR ((iRed) shr 3) or &h8000
    #define GG (((iGreen) shr 3) shl 5)
    #define BB (((iBlue) shr 3) shl 10) 
    return RR or GG or BB
  end if
end function
' ***************************************************************************************
#ifndef __FB_GFX_NO_GL_RENDER__
__private sub fb_NewTextureGL alias "fb_newTextureGL" (fbImage as fb.image ptr)
  dim as integer glWid,glHei,TempTex
  for CNT as integer = 0 to TEXTURE_SIZE_1024
    if (8 shl CNT) >= cint(fbImage->Width) then glWid = CNT:exit for
  next CNT
  for CNT as integer = 0 to TEXTURE_SIZE_1024
    if (8 shl CNT) >= cint(fbImage->Height) then glHei = CNT:exit for
  next CNT
  with *cptr(gfx.GlData ptr,@(fbImage->_Reserved(1)))
    if glGenTextures(1,@TempTex) = 0 then
      puts "Failed to create texture :("
    end if
    .Texture = TempTex
    .TexWid = glWid : .TexHei = glHei
    .TexFlags = gfx.tfNeedUpdate    
    .uPrev = 0 : .uNext = 0
  end with
end sub
__private sub fb_UpdatePaletteGL alias "fb_UpdatePaletteGL" ()
  if Gfx.fg.UpdatePal then
    'glBindTexture(GL_TEXTURE_2D, gfx.Texture)
    glColorTableEXT(0,0,256,0,0,gfx.PalettePtr)
    Gfx.fg.UpdatePal = 0
  end if
end sub
#define Lnk2Ptr(_off) cast(gfx.imageGL ptr,(_off) shl 2)
#define Ptr2Lnk(_ptr) (cast(ulong,(_ptr)) shr 2)
static shared as gfx.imageGL ptr g_fbglRootImg , g_fbglTailImg
static shared as long g_iTexCount
__private sub fbgl_AddTexture( pImage as any ptr )
  'if pImage = 0 then exit sub
  var pImg = cast(gfx.imageGL ptr,pImage)
  scope
    var uTemp = Ptr2Lnk(pImg)
    if pImg <> Lnk2Ptr(uTemp) then
      puts("Unsupported texture address!")
      exit sub
    end if
  end scope
  g_iTexCount += 1
  'if first element added it become start/end
  if g_fbglRootImg = 0 then
    g_fbglRootImg = pImg : g_fbglTailImg = pImg
    exit sub
  end if
  pImg->uNext = 0                      'as this is the new root
  pImg->uPrev = Ptr2Lnk(g_fbglRootImg) 'previous is also the previous root
  g_fbglRootImg = pImg                 'new root ptr -> ptr
  'if there was an previous root, then set the next of that one to the new root
  if pImg->uPrev then Lnk2Ptr(pImg->uPrev)->uNext = Ptr2Lnk(pImg)
end sub
__private sub fbgl_DelTexture( pImage as any ptr )
  'if pImage = 0 then exit sub
  var pImg = cast(gfx.imageGL ptr,pImage)
  
  var pPrev = Lnk2Ptr(pImg->uPrev)
  var pNext = Lnk2Ptr(pImg->uNext)
  
  if pPrev then 
    pPrev->uNext = pImg->uNext 
  else
    g_fbglTailImg = pNext
  end if
  if pNext then 
    pNext->uPrev = pImg->uPrev
  else
    g_fbglRootImg = pPrev
  end if
  
  g_iTexCount -= 1
  
end sub
__private sub fbgl_BubbleUpTexture( pImage as any ptr )
  'if pImage = 0 then exit sub
  var pImg = cast(gfx.imageGL ptr,pImage)
  
  var pNext = Lnk2Ptr(pImg->uNext)
  'already root? then can't bubble up more
  if pNext = 0 then exit sub
  
  var pPrev = Lnk2Ptr(pImg->uPrev)
  'theres a previous one? the next of that will become current next
  if pPrev then
    pPrev->uNext = pImg->uNext
  else 'otherwise the next one is the new tail
    g_fbglTailImg = pNext
  end if  
  
  var pNextNext = Lnk2Ptr(pNext->uNext)
      
  pNext->uPrev = pImg->uPrev   'the previous of my next is my previous
  pImg->uPrev = pImg->uNext    'my new previous becomes my next
  pImg->uNext = pNext->uNext   'my new next is now former next next
  pNext->uNext = Ptr2Lnk(pImg) 'the next of my next is me
  
  'if my next had a next... then the previous of that next becomes me
  if pNextNext then pNextNext->uPrev = pNext->uNext
  'if i now dont have a next then i'm the root one
  if pImg->uNext = 0 then g_fbglRootImg = pImg
  
end sub
__private sub fbgl_UploadTexture( pTex as gfx.ImageGL ptr ) 
  with *pTex
    if .Texture then
      var iType = iif(.Bpp>8,GL_RGBA,GL_RGB256)
      var iNewTexSz = (8 shl .TexWid)*(8 shl .TexHei)
      var iOldMemUsage = gfx.g_TextureMemoryUsage
      dim as long Resu = any
      
      dim as gl_texture_data ptr TexPtr
      if (.TexFlags and gfx.tfAllocated) then TexPtr = glGetTexturePointer(.Texture)                      
      if TexPtr then              
        gfx.g_TextureMemoryUsage -= (8 shl .TexWid)*(8 shl .TexHei)
        'printf("%i ",gfx.g_TextureMemoryUsage\1024)
        'dim as integer TempText = .Texture
        'glDeleteTextures(1,@TempText) : .Texture=0
        .TexFlags = (.TexFlags and (not gfx.tfAllocated)) or (gfx.tfNeedUpdate)
        'printf("%i ",g_iTexCount)
        fbgl_DelTexture(pTex)
        TexPtr = 0
      end if
      
      glBindTexture(0,.Texture)
      do        
        'if (.TexFlags and gfx.tfAllocated) then Resu=1:exit do
        Resu = glTexImage2D(0,0,iType,.TexWid,.TexHei,0,TEXGEN_OFF, pTex+1) 'TEXGEN_TEXCOORD
        if Resu orelse g_fbglTailImg=0 then exit do        
        do 
          if g_fbglTailImg = 0 then exit do,do
          with *g_fbglTailImg                    
            gfx.g_TextureMemoryUsage -= (8 shl .TexWid)*(8 shl .TexHei)            
            dim as integer TempText = .Texture
            glDeleteTextures(1,@TempText) : .Texture=0
            .TexFlags = (.TexFlags and (not gfx.tfAllocated)) or (gfx.tfNeedUpdate)
          end with
          fbgl_DelTexture(g_fbglTailImg)
        loop while abs(gfx.g_TextureMemoryUsage-iOldMemUsage) < iNewTexSz
      loop          
      if Resu then                 
        if (.TexFlags and gfx.tfAllocated)=0 then 
          fbgl_AddTexture( pTex )
          gfx.g_TextureMemoryUsage += iNewTexSz
        end if
        .TexFlags = (.TexFlags or gfx.tfAllocated) and (not gfx.tfNeedUpdate)
        'dim as zstring*64 zText = any
        'sprintf(zText,"TexUpload=%i %fms",Resu,csng((timer-TMR)*1000))
        'puts(zText)
        'printf(!"(%i) \0",g_iTexCount)
        'nocashMessage(zText)
      else
        dim as zstring*64 zText = any
        'nocashMessage("Failed to upload texture.")
        sprintf(zText,!"Img:%p(%ix%i) Tex:%i Sz:%i",pTex,.Width,.Height,.Texture,iNewTexSz)
        'nocashMessage(zText)
        puts(zText)
        puts("Upload texture failed.")
        'sleep 500,1
        'do : sleep 1,1 : loop
      end if
    end if
  end with
end sub
#endif
' *************************** GET POINTER TO SCREEN BITS ********************************
function _FB_Inline_(fb_GfxScreenPtr) () as any ptr
  return gfx.scrptr
end function
' **************************** CREATE A NEW SCREEN AREA *********************************
UndefAll()
#define P1 Wid     as integer
#define P2 Hei     as integer
#define P3 Bpp     as integer
#define P4 Pages   as integer
#define P5 Flags   as integer
#define P6 Refresh as integer
__priv function _FB_Private_(fb_GfxScreenRes) (P1,P2,P3,P4,P5,P6) as integer
  dim as integer OglRender,Pitch
  'if bpp > 16 then return 0
  if bpp <= 8 then bpp=8 else Bpp=16
  
  select case Wid
  case 192 '192x256
    if Hei <> 256 then return 0
    Pitch = 256: Gfx.fg.IsRotated = 1: Gfx.fg.IsDual = 0
  case 256 '256x192 / 256x(192-480)
    if Hei<192 or Hei > 480 then return 0
    Pitch = 256: Gfx.fg.IsRotated = 0
    if Wid=257 then
      Wid=256 : Gfx.fg.IsDual = 0
    else
      Gfx.fg.IsDual = iif(Hei>192,1,0)
    end if
  case 257 to 512
    if Hei < 192 or Hei > 384 then return 0
    Pitch = 512: Gfx.fg.IsRotated = 0 : Gfx.fg.IsDual = 0
  case else
    return 0
  end select
  
  if Pages>2 then return 0
  lcdMainOnBottom()
  
  #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.PalettePtr andalso gfx.CurrentDriver = gfx.gdOpenGL then
      deallocate(gfx.PalettePtr)
      gfx.PalettePtr = 0
    end if
  #endif
    
  if gfx.GfxDriver <> gfx.gdOpenGL then
    videoSetMode(MODE_5_2D)
    if Wid>256 andalso Hei>=192 then
      vramSetBankA(VRAM_A_MAIN_BG)
      vramSetBankB(VRAM_B_MAIN_BG)
      if Bpp=16 then
        vramSetBankC(VRAM_C_MAIN_BG)
        vramSetBankD(VRAM_D_MAIN_BG)
      end if
    else
      if Bpp=16 then
        vramSetBankA(VRAM_A_MAIN_BG)
      else
        vramSetBankE(VRAM_E_MAIN_BG)
      end if      
    end if
    if gfx.fg.IsDual then
      videoSetModeSub(MODE_5_2D)    
      vramSetBankC(VRAM_C_SUB_BG)
    end if
  else
    #ifndef __FB_GFX_NO_GL_RENDER__
      videoSetMode(MODE_0_3D)
      vramSetBankA(VRAM_A_TEXTURE) : vramSetBankB(VRAM_B_TEXTURE)
      vramSetBankC(VRAM_C_TEXTURE) : vramSetBankD(VRAM_D_TEXTURE)  
      vramSetBankF(VRAM_F_TEX_PALETTE_SLOT0)
      vramSetBankF(VRAM_G_TEX_PALETTE_SLOT1)
      glInit()
      glEnable(GL_TEXTURE_2D) : glEnable(GL_BLEND) : glEnable(GL_ANTIALIAS)  
      glClearColor(0,0,0,0) : glClearPolyID(63) : glClearDepth(&h7FFF)
      glMatrixMode(GL_TEXTURE) : glLoadIdentity() : glMatrixMode(GL_MODELVIEW)
      'glMaterialf(GL_AMBIENT, RGB15(16,16,16))
      'glMaterialf(GL_DIFFUSE, RGB15(16,16,16))
      'glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(8,8,8))
      'glMaterialf(GL_EMISSION, RGB15(16,16,16))
      glViewport(0,0,255,191) 'Wid-1,Hei-1)
      glColor3f(1,1,1)
      glMatrixMode(GL_PROJECTION)
      glLoadIdentity()      
      glOrthof32(0,Wid,Hei,0,0,8192) 
      
      glMatrixMode(GL_MODELVIEW)
      glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE)      
      'glPolyFmt(POLY_ALPHA(16) or POLY_CULL_NONE)
      glEnable(GL_POLY_OVERFLOW)
      'cast_vu32_ptr(&h40004A4) = &b00000000000111110111100011000000
      'cast_vu32_ptr(&h40004A4) or= (1 shl 11)
      
    #else
      puts "SCREENRES: GL render disabled."
    #endif
  end if
  gfx.CurrentDriver = gfx.GfxDriver
  OglRender = (gfx.CurrentDriver = gfx.gdOpenGL)
  
  if bpp=16 then
    #ifndef __FB_GFX_NO_16BPP__
    if OglRender=0 then 
      if Wid>256 andalso Hei>=192 then               
        gfx.bg = bgInit(3, BgType_Bmp16, BgSize_B16_512x512, 0,0)
        bgSetScale(gfx.bg,(Wid*256)\256,(Hei*256)\192)
        'bgSetScroll(bg, 128, 96)
      else
        var iSz = iif(Wid>256 andalso Hei>192,BgSize_B16_512x512,BgSize_B16_256x256)
        gfx.bg = bgInit(3, BgType_Bmp16, iSz, 0,0)      
      end if
    end if
    #endif
  else
    if OglRender then       
      #ifndef __FB_GFX_NO_GL_RENDER__
        gfx.PalettePtr = callocate(256*2)      
      #endif
    else
      if Wid>256 andalso Hei>192 then               
        gfx.bg = bgInit(3, BgType_Bmp8, BgSize_B8_512x512, 0,0)
        bgSetScale(gfx.bg,(Wid*256)\256,(Hei*256)\192)
        'bgSetScroll(bg, 128, 96)
      else
        gfx.bg = bgInit(3, BgType_Bmp8, BgSize_B8_256x256, 0,0) 
      end if      
      if gfx.fg.IsDual then
        gfx.bg2 = bgInitSub(3, BgType_Bmp8, BgSize_B8_256x256, 0,0) 
        gfx.vrambptr = cast(any ptr,cuint(bgGetGfxPtr(gfx.bg2)))
      end if
      gfx.PalettePtr = BG_PALETTE
    end if
    'dim as ushort MyPal(255)
    for CNT as integer = 0 to 255
      dim as uinteger R = (gfx.DefaultVGA(CNT) shr 16) and 255
      dim as uinteger G = (gfx.DefaultVGA(CNT) shr  8) and 255
      dim as uinteger B = (gfx.DefaultVGA(CNT) shr  0) and 255
      gfx.PalettePtr[CNT] = (R shr 3) or ((G shr 3) shl 5) or ((B shr 3) shl 10) or &h8000
    next CNT
    Gfx.fg.UpdatePal = 1
  end if  
  
  if OglRender then
    #ifndef __FB_GFX_NO_GL_RENDER__
      dim as integer glWid,glHei
      for CNT as integer = 0 to TEXTURE_SIZE_1024
        if (8 shl CNT) >= Wid then glWid = CNT:exit for
      next CNT
      for CNT as integer = 0 to TEXTURE_SIZE_1024
        if (8 shl CNT) >= Hei then glHei = CNT:exit for
      next CNT
      gfx.GfxSize = (8 shl glWid)*Hei '(8 shl glHei)    
      gfx.GfxSize = ((gfx.GfxSize*Bpp) shr 3)    
      
      gfx.Scr = reallocate(gfx.Scr,gfx.GfxSize+sizeof(fb.image)+wid) 
      
      gfx.Scr->Pitch = ((8 shl glWid)*Bpp) shr 3        
      with *cptr(gfx.ImageGL ptr,gfx.Scr)
        dim as integer TempTex 
        glGenTextures(1,@TempTex )
        glBindTexture(GL_TEXTURE_2D, gfx.FontTex)
        .Texture = TempTex 
        .TexWid = glWid
        .TexHei = glHei
        .TexFlags = gfx.tfNeedUpdate        
        'fb_UpdatePaletteGL()      
        gfx.Texture = .Texture
        glBindTexture(GL_TEXTURE_2D, 0)
      end with    
      
      dim as short TempPal(3) = {0,-1,-1,-1}
      glResetTextures()      
      glGenTextures(1,@gfx.FontTex)
      glBindTexture(GL_TEXTURE_2D, gfx.FontTex)
      
      glTexImage2D(0,0,GL_RGB4,4,4,0,TEXGEN_TEXCOORD or _
      GL_TEXTURE_COLOR0_TRANSPARENT, fbgfxfont_tex)
      glColorTableEXT(0,0,4,0,0,cast(any ptr,@TempPal(0)))
      glAssignColorTable (0, gfx.FontTex)
      
      glBindTexture(GL_TEXTURE_2D, 0)
      
      if Gfx.fg.IsRotated then
        var iW=(Wid\2),iH=(Hei\2)        
        glTranslatef32(iH,iW,0)
        glRotatef(90,0,0,1)        
        glTranslatef32(-iW,-iH,0)
      end if
      
    #endif    
  else 
    if Gfx.fg.IsRotated then
      bgSetCenter(gfx.bg, 128, 128)
      bgSetRotate(gfx.bg, -8192) 'bgSetRotateScale(bg3, 16384, 256, 256)
      bgSetScroll(gfx.bg, 128, 127)
      'bgUpdate()
    end if
    gfx.GfxSize = (((Pitch*Bpp) shr 3)*Hei)
    #ifdef __FB_GFX_DIRECTSCREEN__
      gfx.Scr = cast(any ptr,bgGetGfxPtr(gfx.bg))+pitch-sizeof(fb.image)
    #else
      if isDSiMode() then
        gfx.Scr = cast(any ptr,&h3700000) 'DSI WRAM
      else
        gfx.Scr = reallocate(gfx.Scr,gfx.GfxSize+sizeof(fb.image)+pitch)
      end if
    #endif
    
    gfx.Scr->Pitch = (Pitch*Bpp) shr 3
  end if
  
  gfx.Scr->Type = &h7
  gfx.Scr->Width = Wid
  gfx.Scr->Height = Hei
  gfx.Scr->Bpp = (Bpp shr 3)
  
  gfx.GfxSize = (gfx.Scr->Pitch)*(gfx.Scr->Height)
  gfx.Scrptr = cast(any ptr,gfx.scr+1)
  gfx.vramptr = cast(any ptr,cuint(bgGetGfxPtr(gfx.bg)) and (OglRender=0))
  gfx.TransColor = iif(Bpp <= 8,0,rgba(255,0,255,0))
  gfx.Depth = gfx.DepthFar
  
  gfx.Locked = 0: gfx.fg.DualSwap = 0
  #ifndef __FB_GFX_DIRECTSCREEN__
    dc_flushrange(gfx.scrptr,gfx.gfxsize)
    DmaFillWords(0,gfx.Scrptr,gfx.GfxSize)
  #endif
  
  bgUpdate()
 
  exit function
  Flags = Flags 'unused
  Refresh = Refresh 'unused
  
end function
' ************************ RETURNS INFO ABOUT GRAPHICS SCREEN ***************************
UndefAll()
#define P1 piWid    as integer ptr
#define P2 piHei    as integer ptr
#define P3 piDepth  as integer ptr
#define P4 piBpp    as integer ptr
#define P5 piPitch  as integer ptr
#define P6 piRate   as integer ptr
#define P7 pDriver  as any ptr
__priv sub _FB_Private_(fb_GfxScreenInfo) ( P1,P2,P3,P4,P5,P6,P7 )
  'dim as string ptr psDriver = psDriver
  if gfx.scr then
    with *gfx.scr
      *piWid = .Width   : *piHei = .Height
      *piBpp = .Bpp     : *piDepth = .Bpp shl 3
      *PiPitch = .Pitch : *piRate = 60      
      if gfx.CurrentDriver = gfx.gdOpenGL then
        '*psDriver = "DS-GL"
      else
        '*psDriver = "DS"
      end if      
    end with
  else
    *piWid = 256 : *piHei = 192 : *piBpp = 1 : *piDepth = 8
    *PiPitch = 256 : *piRate = 60 ': *psDriver = "DS"
  end if
end sub
' ********************** SETS A VIEW (CLIPPING) ON THE SCREEN ***************************
UndefAll()
#define P1 iLeft    as integer
#define P2 iTop     as integer
#define P3 iRight   as integer
#define P4 iBottom  as integer
#define P5 iBkgnd   as uinteger
#define P6 iBorder  as uinteger
#define P7 iFlags   as integer
__priv sub _FB_Private_(fb_GfxView) ( P1,P2,P3,P4,P5,P6,P7 )
  if gfx.ScrPtr=0 then exit sub 
  var iWid = gfx.Scr->Width, iHei = gfx.Scr->Height
  
  if iLeft = -32768 and iRight = -32768 then    
    if iTop = -32768 and iBottom = -32768 then      
      gfx.ViewLT = 0: gfx.ViewRT = iWid-1
      gfx.ViewTP = 0: gfx.ViewBT = iHei-1
      gfx.ViewWid = iWid : gfx.ViewHei = iHei
      #ifndef __FB_GFX_NO_GL_RENDER__
        if gfx.CurrentDriver = gfx.gdOpenGL then         
          glViewport(gfx.ViewLT,gfx.ViewTP,gfx.ViewRT,gfx.ViewBT)          
          glMatrixMode(GL_PROJECTION)
          glLoadIdentity()          
          glOrthof32(gfx.ViewLT,gfx.ViewRT,gfx.ViewBT,gfx.ViewTP,0, 8192)
          glMatrixMode(GL_MODELVIEW)
        end if
      #endif
      gfx.IsView = 0: exit sub
    end if
  end if

  'is view screen?
  #if 0
    if (iFlags and 1)=0 andalso gfx.IsView then
      iLeft  += gfx.ViewLT: iTop    += gfx.ViewTP
      iRight += gfx.ViewLT: iBottom += gfx.ViewTP    
    end if
  #endif
  
  if iLeft   < 0 then iLeft  =0 else if iLeft   >= iWid then iLeft   = iWid-1
  if iTop    < 0 then iTop   =0 else if iTop    >= iHei then iTop    = iHei-1
  if iRight  < 0 then iRight =0 else if iRight  >= iWid then iRight  = iWid-1
  if iBottom < 0 then iBottom=0 else if iBottom >= iHei then iBottom = iHei-1
  if iLeft > iRight then swap iLeft,iRight
  if iTop > iBottom then swap iTop,iBottom
  
  gfx.ViewLT = iLeft : gfx.ViewRT = iRight
  gfx.ViewTP = iTop  : gfx.ViewBT = iBottom
  gfx.ViewWid = (iRight-iLeft)+1
  gfx.ViewHei = (iBottom-iTop)+1  
  #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.CurrentDriver = gfx.gdOpenGL then            
      'glViewport(gfx.ViewLT,gfx.ViewTP,gfx.ViewRT,gfx.ViewBT)
      glViewport(gfx.ViewTP,gfx.ViewLT,gfx.ViewBT,gfx.ViewRT)
      glMatrixMode(GL_PROJECTION)
      glLoadIdentity()      
      'glOrthof32(gfx.ViewLT,gfx.ViewRT,gfx.ViewBT,gfx.ViewTP,0, 8192)
      glOrthof32(gfx.ViewTP,gfx.ViewBT,gfx.ViewRT,gfx.ViewLT,0, 8192)
      glMatrixMode(GL_MODELVIEW)
    end if
  #endif
  gfx.IsView = 1
  
end sub
' *************************** SET GFX WINDOW TITLE (puts) *******************************
sub _FB_Inline_(fb_GfxSetWindowTitle) ( FBs as any ptr )
  DebugShowFunctionName()  
  puts(*cptr(string ptr,FBs))
  DestroyTempString(FBs)  
end sub
' *********************** SET ONE PALETTE INDEX ON MODES <=8 ****************************
sub _FB_Inline_(fb_GfxPalette) (iIndex as integer,iRed as integer,iGreen as integer,iBlue as integer)
  if cuint(iIndex) < 256 then    
    if iGreen < 0 and iBlue < 0 then
      dim as uinteger iColor = (iRed and &h3E3E3E) shr 1
      #define RR ((iColor and &h1F) shl 10)
      #define GG ((iColor and &h1F00) shr 3)
      #define BB ((iColor and &h1F0000) shr 16)
      gfx.PalettePtr[iIndex] =  RR or GG or BB or &h8000
    else
      #define RR (iRed shr 3) or &h8000
      #define GG ((iGreen shr 3) shl 5)
      #define BB ((iBlue shr 3) shl 10) 
      gfx.PalettePtr[iIndex] =  RR or GG or BB
    end if
    Gfx.fg.UpdatePal = 1
  end if  
end sub
' *********************** GET ONE PALETTE INDEX ON MODES <=8 ****************************
sub _FB_Inline_(fb_GfxPaletteGet) (iIndex as integer,piRed as integer ptr,piGreen as integer ptr,piBlue as integer ptr)
  if cuint(iIndex) < 256 then
    if piRed then
      if piGreen=0 and piBlue=0 then 'rgb666
        var iPal16 = gfx.PalettePtr[iIndex]
        #define RR ((iPal16 and &b000000000011111) shl 1)
        #define GG ((ipal16 and &b000001111100000) shl 2)
        #define BB ((ipal16 and &b111110000000000) shl 3)
        *piRed = RR or GG or BB
      else
        var iPal16 = gfx.PalettePtr[iIndex]        
        *piRed   = ((iPal16 and &b000000000011111) shl 3)
        *piGreen = ((ipal16 and &b000001111100000) shr 2)
        *piBlue  = ((ipal16 and &b111110000000000) shr 7)
      end if
    end if
  end if
end sub
' ************************* SET FULL PALETTE ON MODES <=8 *******************************
sub _FB_Inline_(fb_GfxPaletteUsing) (iPalArray as integer ptr)
  if gfx.Scr->Bpp > 8 or gfx.ScrPtr=0 then exit sub
  dim as integer PalCnt = (1 shl gfx.Scr->Bpp)-1  
  for CNT as integer = 0 to PalCnt
    dim as uinteger iColor = (iPalArray[CNT] and &h3E3E3E) shr 1
    #define RR ((iColor and &h1F) shl 10)
    #define GG ((iColor and &h1F00) shr 3)
    #define BB ((iColor and &h1F0000) shr 16)
    gfx.PalettePtr[CNT] =  RR or GG or BB or &h8000
    'gfx.PalettePtr[CNT] = fb_Gfx24to16(iPalArray[CNT])
  next CNT
  Gfx.fg.UpdatePal = 1
end sub
' ************************* GET FULL PALETTE ON MODES <=8 *******************************
sub _FB_Inline_(fb_GfxPaletteGetUsing) (iPalArray as integer ptr)
  if gfx.Scr->Bpp > 8 or gfx.ScrPtr=0 then exit sub
  dim as integer PalCnt = (1 shl gfx.Scr->Bpp)-1  
  for CNT as integer = 0 to PalCnt
    dim as uinteger Temp = gfx.PalettePtr[CNT]
    dim as uinteger R = ((Temp and &h1F)*63)\31
    dim as uinteger G = (((Temp shr 5) and &h1F)*63)\31
    dim as uinteger B = (((Temp shr 10) and &h1F)*63)\31
    iPalArray[CNT] = rgba(R,G,B,0)
  next CNT  
end sub
' **************** INCREMENT LOCK COUNT THAT PREVENT SCREEN UPDATE  *********************
sub _FB_Inline_(fb_GfxLock) ()
  gfx.Locked += 1
end sub
' **************** DECREMENT LOCK COUNT THAT PREVENT SCREEN UPDATE  *********************
__priv sub _FB_Private_(fb_GfxUnlock) (UnkA as integer,UnkB as integer)  
  if gfx.Locked then 
    'if gfx.Locked=1 and gfx.fg.MustUpdate=1 then
    '  '_fb_INT_UpdateScreen()      
    'end if
    gfx.Locked -= 1    
    if gfx.Locked = 0 then
      static as byte iMustCount
      if gfx.fg.MustUpdate=1 then _fb_INT_UpdateScreen()
      '_fb_INT_UpdateScreen()
      #if 0
        if gfx.NeedUpdate = 1 then
          while DmaBusy(2)
            printf ""
            DoNothing()
          wend        
          'DC_FlushRange(gfx.ScrPtr, gfx.gfxsize)
          dmaCopyWordsAsynch(2,gfx.ScrPtr,gfx.vramptr,gfx.gfxsize)
          gfx.NeedUpdate = 0      
          if gfx.CurrentDriver = gfx.gdOpenGL andalso gfx.CanFlush then 
            gfx.CanFlush = 0: glflush(0): gfx.Depth = gfx.DepthFar
          end if            
        end if  
        if gfx.CurrentDriver = gfx.gdOpenGL then
          with *cptr(gfx.GlData ptr,@(gfx.scr->_Reserved(1)))
            if .Texture then .TexFlags or= gfx.tfNeedUpdate
          end with
        end if        
      #endif    
    end if
  end if
  exit sub
  UnkA = UnkA 'unused
  UnkB = UnkB 'unused
end sub
' ************************** CREATE AN IMAGE BUFFER *************************************
UndefAll()
#define P1 iWid   as integer
#define P2 iHei   as integer
#define P3 iColor as integer
#define P4 iBpp   as integer
#define P5 iFlags as integer
__priv function _FB_Private_(fb_GfxImageCreate) (P1,P2,P3,P4,P5) as any ptr
  
  if iWid < 0 or iHei < 0 then return 0
  if iBpp = 0 then
    if gfx.Scrptr then
      iBpp = gfx.Scr->Bpp shl 3
    else 
      return 0
    end if
  end if  
  if ibpp > 16 then return 0
  if ibpp <= 8 then iBpp=8 else iBpp=16
  if (iFlags and &h80000000) then 
    if iBpp > 8 then iColor = rgba(255,0,255,0)
  end if
  dim as integer TempPitch = ((iWid*iBpp) shr 3)  
  dim as fb.image ptr TempImage
  
  if gfx.CurrentDriver = gfx.gdOpenGL then
    #ifndef __FB_GFX_NO_GL_RENDER__
      dim as integer glWid,glHei,TempTex
      for CNT as integer = 0 to TEXTURE_SIZE_1024
        if (8 shl CNT) >= iWid then glWid = CNT:exit for
      next CNT
      for CNT as integer = 0 to TEXTURE_SIZE_1024
        if (8 shl CNT) >= iHei then glHei = CNT:exit for
      next CNT
      TempPitch = ((8 shl glWid)*iBpp) shr 3
      TempImage = allocate((TempPitch*iHei)+sizeof(fb.image))    
      if TempImage = 0 then 
        puts "Failed to allocate create image :("
        return 0
      end if      
      with *cptr(gfx.GlData ptr,@(TempImage->_Reserved(1)))        
        .Texture = 0 : .TexFlags = gfx.tfNeedUpdate        
        .TexWid = glWid : .TexHei = glHei
        .uPrev = 0 : .uNext = 0
      end with
    #endif
  else  
    if (TempPitch and 3) then TempPitch = (TempPitch or 3)+1
    TempImage = allocate(sizeof(fb.image)+iHei*TempPitch)
    if TempImage = 0 then 
      puts "Failed to allocate create image :("
      return 0
    end if  
  end if
  
  with *TempImage
    .Type = fb.PUT_HEADER_NEW
    .Width = iWid : .Height = iHei
    .Bpp = iBpp shr 3 : .Pitch = TempPitch
  end with  
  dim as uinteger TempColor
  if iBpp > 8 then
    #ifndef __FB_GFX_NO_16BPP__
    TempColor = fb_Gfx24to16(iColor)    
    #endif
  else
    TempColor = (iColor and 255)+((iColor and 255) shl 8)
  end if
  TempColor = TempColor or (TempColor shl 16)
  dc_flushrange(TempImage+1,iHei*TempPitch)  
  DmaFillWords(TempColor,TempImage+1,iHei*TempPitch)  
  return TempImage
end function
' ************************** CREATE AN IMAGE BUFFER *************************************
__priv sub _FB_Private_(fb_GfxImageDestroy) (pBuffer as any ptr)
  if pBuffer then 
    #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.CurrentDriver = gfx.gdOpenGL then      
      with *cptr(gfx.ImageGL ptr,pBuffer)      
        if .Texture then 
          fbgl_DelTexture(pBuffer)
          dim as integer TempText = .Texture          
          gfx.g_TextureMemoryUsage -= (8 shl .TexWid)*(8 shl .TexHei)
          glDeleteTextures(1,@TempText)
          'Gfx.fg.UpdatePal = 1            
        end if
      end with
    end if
    #endif
    deallocate(pBuffer)
  end if  
end sub
' ************* LOAD A .BMP FILE ON TARGET AND OPTIONALLY SAVE ITS PALETTE *************
__priv function _FB_Private_(fb_GfxBload) (fbStrName as any ptr,pOutBuff as any ptr,pPal as any ptr) as integer
  if pOutBuff=0 and gfx.ScrPtr=0 then return 0
  dim as integer BmpFile = freefile()
  dim as string ptr Temp = fbStrName
  if open(*Temp for binary access read as #BmpFile) then
    puts "Failed to open bmp..."    
    puts(*Temp)
    return 0
  end if
  dim as fbBmpFileHeader BmpHeader
  get #BmpFile,1,BmpHeader
  if BmpHeader.Signature <> cvshort("BM") then
    close #BmpFile: return 0
  end if
  
  dim as integer inBpp,PalCnt
  dim as integer OutWid,OutHei,OutPitch,OutBpp,inPitch,FileOffs
  dim as any ptr OutData
  dim as uinteger TempPal(255)
  
  if pOutBuff = 0 then pOutBuff = gfx.scr    
  dim as fb.image ptr TempHead = cptr(fb.image ptr,pOutBuff)
  with *Temphead
    OutWid = .Width: OutHei = .Height
    OutBpp = .Bpp: outData = TempHead+1
    OutPitch = .Pitch
  end with  
  if gfx.CurrentDriver = gfx.gdOpenGL then
    #ifndef __FB_GFX_NO_GL_RENDER__
      with *cptr(gfx.GlData ptr,@(TempHead->_Reserved(1)))
        if .Texture then .TexFlags or= gfx.tfNeedUpdate      
      end with
    #endif
  end if  
  
  with BmpHeader
    if .Bpp <= 8 then 
      InBpp = .Bpp:.Bpp = 1
      PalCnt = 1 shl inBpp
    else
      InBpp = .Bpp: .Bpp = 2
    end if    
    inPitch = (.Wid*(InBpp)) shr 3
    if (InPitch and 3) then inPitch = (inPitch or 3)+1        
    if .Bpp <> 1 and .Bpp <> 2 and .Bpp <> 3 and .Bpp <> 4 then 
      close #BmpFile: return 0
    end if    
    
    if .Bpp <= 1 then
      Get #BmpFile,,*cptr(ubyte ptr,@TempPal(0)),PalCnt shl 2      
      if cuint(pPal) > 0 then
        for CNT as integer = 0 to (PalCnt)-1
          var uPal = TempPal(CNT) and &hFCFCFC
          uPal = (uPal shr 16) or ((uPal shl 16) and &hFF0000) or (uPal and &hFF00)
          cptr(uinteger ptr,pPal)[CNT] = (uPal shr 2)
        next CNT        
      elseif cuint(pPal) = 0 and gfx.Scr->Bpp = 1 then
        for CNT as integer = 0 to (PalCnt shl 2)-1
          palette CNT,(TempPal(CNT) and &hFCFCFC) shr 2
          'gfx.PalettePtr[CNT] = fb_Gfx24to16(TempPal(CNT))
        next CNT
        Gfx.fg.UpdatePal = 1        
      end if
      for CNT as integer = 0 to (PalCnt)-1
        TempPal(CNT) = fb_Gfx24to16(TempPal(CNT))
      next CNT
    end if
    
    FileOffs = .ImageOffset+1+(InPitch*(.Hei-1))
    dim as integer LineSize = InPitch,LineCount = .Hei-1
    
    select case OutBpp
    case 1 '256 color output
      select case inBpp
      case 4 '16 color input
        if (inPitch shl 1) then LineSize = OutPitch shr 1
        if LineCount >= OutHei then LineCount = OutHei-1
        dim as ubyte ptr inBuff = Callocate(LineSize)
        for Y as integer = 0 to LineCount
          get #BmpFile,FileOffs-(Y*InPitch),*inBuff,LineSize
          for CNT as integer = 0 to LineSize-1
            dim as integer Temp = inBuff[CNT]
            cptr(ushort ptr,OutData)[CNT] = (Temp shr 4) or ((Temp and &h0F) shl 8)
          next CNT
          OutData += OutPitch
        next Y
      case 8 '256 color input
        if InPitch > OutPitch then LineSize = OutPitch
        if LineCount >= OutHei then LineCount = OutHei-1        
        'FileOffs-(Y*InPitch)
        OutData += LineCount*OutPitch
        for Y as integer = 0 to LineCount
          get #BmpFile,,*cptr(ubyte ptr,OutData),InPitch 'LineSize
          OutData -= OutPitch
        next Y
      case else
        printf !"Bitmap Combination not supported %i %i\n",InBPP,OutBpp
        sleep
      end select
    case 2 '15 bit output
      #ifndef __FB_GFX_NO_16BPP__
        select case inBpp
        case 8  '8 bits (palette)
          if LineCount >= OutHei then LineCount = OutHei-1
          'dim as ubyte ptr pLine = allocate(LineSize*2)
          'dim as ubyte ptr pLine = cast(any ptr,@pTemp(0))
          dim as ubyte ptr pFullLine = callocate(LineSize)
          if pFullLine = 0 then
            printf("!Failed to allocate for bload...\n"):sleep
          end if
          for Y as integer = 0 to LineCount
            dim as ubyte ptr pLine = pFullLine
            get #BmpFile,FileOffs-(Y*InPitch),*cptr(ubyte ptr,pLine),LineSize
            dim as ushort ptr TempOut = OutData
            for CNT as integer = 0 to .Wid-1
              #define RR ((pLine[0]) shr 3) or &h8000
              #define GG (((pLine[1]) shr 3) shl 5)
              #define BB (((pLine[2]) shr 3) shl 10) 
              *TempOut = TempPal(*pLine)            
              TempOut += 1: pLine += 1
            next CNT               
            OutData += OutPitch
          next Y
          Deallocate(pFullLine)
        case 24 '24 bits (RGB)        
          if LineCount >= OutHei then LineCount = OutHei-1                
          dim as ubyte ptr pFullLine = callocate(LineSize)
          if pFullLine = 0 then
            printf("!Failed to allocate for bload...\n"):sleep
          end if
          for Y as integer = 0 to LineCount
            dim as ubyte ptr pLine = pFullLine
            dim as integer Temp = FileOffs-(Y*InPitch)          
            get #BmpFile,FileOffs-(Y*InPitch),*cptr(ubyte ptr,pLine),LineSize
            get #BmpFile,,*cptr(ubyte ptr,pLine),LineSize
            dim as ushort ptr TempOut = OutData
            for CNT as integer = 0 to .Wid-1
              #define RR ((pLine[2]) shr 3) or &h8000
              #define GG (((pLine[1]) shr 3) shl 5)
              #define BB (((pLine[0]) shr 3) shl 10) 
              *TempOut = RR or GG or BB
              if *TempOut = &b1111110000011111 then *TempOut = &b0111110000011111
              TempOut += 1: pLine += 3
            next CNT               
            OutData += OutPitch
          next Y        
          Deallocate(pFullLine)
        case else
          printf !"Bad Bitmap Combination... %i %i\n",inBPP,OutBpp
          sleep
        end select          
      #else
        puts "BLOAD: 16bpp disabled."        
      #endif
    case else        
      printf !"Bitmap output not supported... %i %i",InBPP,OutBpp
      sleep
    end select
    close #BmpFile: return 0
  end with
  close #BmpFile:return 1
end function
' **************************************************************************************
sub _FB_Inline_(fb_GfxPset) (pTarget as any ptr,sX as single,sY as single, iColor as uinteger,iUnk0 as integer,iUnk1 as integer)
  dim as integer X = sX, Y = sY
  if pTarget = 0 then
    #ifndef __FB_GFX_NO_GL_RENDER__
      pTarget = gfx.scr  
      with *cptr(fb.image ptr,pTarget)
        if .bpp <= 1 then
          iColor = gfx.PalettePtr[iColor and 255]
        else
          #define RR ((iColor and &hF8) shl 7)
          #define GG ((iColor and &hF800) shr 6)
          #define BB ((iColor and &hF80000) shr 19)
          iColor = RR or GG or BB or &h8000
        end if 
        CheckFifoFull()
        glColor(iColor)        
        glBindTexture(0,0)      
        glBegin(GL_TRIANGLES)
        glVertex3v16(X, Y, gfx.Depth)
        glVertex3v16(X, Y, gfx.Depth)
        glVertex3v16(X, Y, gfx.Depth)
        glEnd()
        gfx.Depth += gfx.DepthNext : gfx.fg.CanFlush = 1        
      end with
    #endif
  else
    puts "Pset to buffer Not Yet..."
  end if
  
  gfx.CurX=X:gfx.CurY=Y  
  exit sub
  iUnk0 = iUnk0 'unused
  iUnk1 = iUnk1 'unused
end sub
' *********************** GET COLOR OF AN DOT FROM TARGET ******************************
function _FB_Inline_(fb_GfxPoint) (pTarget as any ptr,sX as single,sY as single ) as integer
  dim as integer X = sX, Y = sY
  if pTarget = 0 then pTarget = gfx.scr  
  with *cptr(fb.image ptr,pTarget)
    if .Type <> 7 then
      puts "gfxpoint: Old Header?"
    else
      if cuint(X) >= cuint(.Width) then return -1
      if cuint(Y) >= cuint(.Height) then return -1
      select case .bpp
      case 1: return cptr(ubyte ptr,pTarget+sizeof(fb.image)+Y*.Pitch)[X]
      case 2: return cptr(ushort ptr,pTarget+sizeof(fb.image)+Y*.Pitch)[X]
      case else: puts "gfxpoint: bpp not supported": return -1
      end select
    end if
  end with
end function
' ******************** DRAW AN OPTIONALLY STYLLED LINE ON TARGET ***********************
UndefAll()
#define P1 pTarget as any ptr
#define P2 sX      as single
#define P3 sY      as single
#define P4 sXX     as single
#define P5 sYY     as single
#define P6 iColor  as uinteger
#define P7 iType   as integer
#define P8 iStyle  as uinteger
#define P9 iFlags  as integer
__priv sub _FB_Private_(fb_GfxLine) (P1,P2,P3,P4,P5,P6,P7,P8,P9)
  dim as integer X=sX,Y=sY,XX=sXX,YY=sYY
  static as integer OutWid,OutHei,OutBpp,OutPitch
  static as any ptr OutData
  
  if (iFlags and 2) then X=gfx.CurX:Y=gfx.CurY
  gfx.CurX=XX:gfx.CurY=YY
  
  if pTarget = 0 then     
    pTarget = gfx.scr
    if gfx.CurrentDriver = gfx.gdOpenGL then
      #ifndef __FB_GFX_NO_GL_RENDER__
        XX += 1: YY += 1
        with *cptr(fb.image ptr,pTarget)
          if .bpp <= 1 then
            iColor = gfx.PalettePtr[iColor and 255]          
          else
            #define RR ((iColor and &hF8) shl 7)
            #define GG ((iColor and &hF800) shr 6)
            #define BB ((iColor and &hF80000) shr 19)
            iColor = RR or GG or BB or &h8000
          end if 
          CheckFifoFull()
          glColor(iColor)        
          glBindTexture(0,0)
          select case iType
          case 0 'Normal Line
            glBegin(GL_TRIANGLES)
            glVertex3v16(X, Y, gfx.Depth)
            glVertex3v16(XX, YY, gfx.Depth)
            glVertex3v16(XX, YY, gfx.Depth)
            glEnd()
          case 1 'Box
            glPolyFmt(POLY_ALPHA(0) or POLY_CULL_FRONT)
            glBegin(GL_QUAD)
            glVertex3v16(X, Y, gfx.Depth)
            glVertex3v16(XX, Y, gfx.Depth)
            glVertex3v16(XX, YY, gfx.Depth)
            glVertex3v16(X, YY, gfx.Depth)          
            glEnd()          
            glPolyFmt(POLY_ALPHA(31) or POLY_CULL_FRONT)
          case 2 'Filled Box
            glBegin(GL_QUADS)  
            glColor(iColor)
            glVertex3v16(X, Y, gfx.Depth)
            glVertex3v16(XX, Y, gfx.Depth)
            glVertex3v16(XX, YY, gfx.Depth)
            glVertex3v16(X, YY, gfx.Depth)
            glEnd()
          end select
        end with
        gfx.Depth += gfx.DepthNext:gfx.fg.CanFlush = 1
        exit sub
      #endif
    end if      
  end if
  dim as fb.image ptr TempHead = cptr(fb.image ptr,pTarget)  
  #ifdef __FB_GFX_NO_OLD_HEADER__
  if 1 then
  #else
  if TempHead->Type <> 7 then    
      puts "LINE: Old Header?"
      OutWid = TempHead->Old.Width
      OutHei = TempHead->Old.Height
      OutBpp = (TempHead->Old.Bpp)*8
      OutPitch = (OutWid*OutBpp) shr 3    
  else
  #endif
    with *Temphead
      OutWid = .Width: OutHei = .Height
      OutBpp = .Bpp: outData = TempHead+1
      OutPitch = .Pitch
    end with
  end if
  
  gfx.Locked += 1
  
  select case OutBpp
  case 1 '256 colors
    select case iType
    case 0 'normal 
      dim as uinteger TempColor = iColor and 255
      if Y = YY then
        if X > XX then swap X,XX
        if Y > YY then swap Y,YY            
        'horz line
        if cuint(XX) >= cuint(OutWid) goto exitsub
        if X < 0 then X = 0: if XX < 0 goto exitsub
        if XX >= OutWid then XX=OutWid-1: if X >= OutWid goto exitsub
        OutData += Y*OutPitch+X        
        FastSet(OutData,TempColor,(XX-X)+1)
      else        
        dim as integer steep = abs(yy - y) > abs(xx - x)
        if steep then swap x, y: swap xx, yy  
        if x > xx then swap x, xx: swap y, yy
        if x < 0 then if xx < 0 goto exitsub
        dim as integer deltax = xx - x
        dim as integer deltay = abs(yy - y)
        dim as integer ierror = deltax shr 1 
        dim as integer pstep
        
        if xx >= OutWid then if x >= OutWid goto exitsub
        if yy > y then 
          if y < 0 then if yy < 0 goto exitsub
          if yy >= OutHei then if y >= OutHei goto exitsub
        else
          if yy < 0 then if y < 0 goto exitsub
          if y >= OutHei then if yy >= OutHei goto exitsub
        end if        
        if steep then
          if xx >= OutHei then xx = OutHei-1
          if y < yy then pstep = 1 else pstep = -1  
          if x < 0 then
            ierror -= deltay*x: x = 0
            dim as integer itemp = ierror\deltax
            if y <= yy then y += itemp else y -= itemp
            ierror = deltax-(ierror-itemp*deltax)
          end if                    
          OutData += ((x*OutPitch)+y)          
          
          if pstep > 0 then
            for py as integer = x to xx        
              *cptr(ubyte ptr,OutData) = TempColor
              
              ierror -= deltay: OutData += OutPitch
              if ierror <= 0 then 
                outdata += pstep: ierror += deltax
                y += 1: if y>= OutWid goto exitsub
              end if
            next py
          else
            for py as integer = x to xx        
              *cptr(ubyte ptr,OutData) = TempColor        
              ierror -= deltay: OutData += OutPitch
              if ierror <= 0 then 
                outdata += pstep: ierror += deltax
                y -= 1: if y<0 goto exitsub
              end if
            next py
          end if
        else
          if xx >= OutWid then xx = OutWid-1
          if y <= yy then pstep = OutPitch else pstep = -OutPitch    
          if x < 0 then
            ierror -= deltay*x: x = 0
            dim as integer itemp = ierror\deltax      
            if pstep>0 then y += itemp else y -= itemp
            ierror = deltax-(ierror-itemp*deltax)
          end if
          OutData += ((y*OutPitch)+x)
          if pstep > 0 then
            for px as integer = x to xx      
              if cuint(y) < cuint(OutHei) then
                *cptr(ubyte ptr,OutData) = TempColor      
              end if
              ierror -= deltay: OutData += 1
              if ierror <= 0 then 
                OutData += pstep: ierror += deltax
                y += 1: if y >= OutHei goto exitsub
              end if        
            next px
          else
            for px as integer = x to xx      
              if cuint(y) < cuint(OutHei) then
                *cptr(ubyte ptr,OutData) = TempColor      
              end if
              ierror -= deltay: OutData += 1
              if ierror <= 0 then 
                OutData += pstep: ierror += deltax          
                y -= 1: if y < 0 goto exitsub
              end if
            next px
          end if
        end if
      end if
    case 1 'B
      dim as uinteger TempColor = iColor and 255
      dim as integer HasLeft=1,HasRight=1,NoTop,NoBottom
      if X > XX then swap X,XX
      if Y > YY then swap Y,YY
      if X < 0 then 
        if XX < 0 goto exitsub
        X = 0: HasLeft = 0
      end if
      if XX >= OutWid then
        if X >= OutWid goto exitsub
        XX = OutWid-1: HasRight = 0
      end if
      if Y < 0 then
        if YY < 0 goto exitsub
        Y=0: OutData += Y*OutPitch+X
      else
        OutData += Y*OutPitch+X
        FastSet(OutDatA,TempColor,(XX-X)+1)
        NoTop = 1
      end if
      if YY >= OutHei then
        if Y >= OutHei goto exitsub
        YY=OutHei-1
      else
        FastSet(OutData+((YY-Y)*OutPitch),TempColor,(XX-X)+1)
        NoBottom = 1
      end if     
      if (HasLeft and HasRight) then
        XX -= X
        for CNT as integer = 0 to (YY-Y)
          *cptr(ubyte ptr,OutData) = TempColor
          *cptr(ubyte ptr,OutData+XX) = TempColor
          OutData += OutPitch
        next CNT
      elseif HasLeft then        
        for CNT as integer = 0 to (YY-Y)
          *cptr(ubyte ptr,OutData) = TempColor          
          OutData += OutPitch
        next CNT
      elseif HasRight then
        OutData += (XX-X)
        for CNT as integer = 0 to (YY-Y)
          *cptr(ubyte ptr,OutData) = TempColor          
          OutData += OutPitch
        next CNT        
      end if
    case 2 'BF
      dim as uinteger TempColor = iColor and 255
      TempColor = TempColor or (TempColor shl 8)
      TempColor = TempColor or (TempColor shl 16)
      if X > XX then swap X,XX
      if Y > YY then swap Y,YY
      if X < 0 then X = 0: if XX < 0 goto exitsub
      if XX >= OutWid then XX = OutWid-1: if X >= OutWid goto exitsub
      if Y < 0  then Y = 0: if YY < 0 goto exitsub
      if YY >= OutHei then YY = OutHei-1: if Y >= OutHei goto exitsub
      OutData += Y*OutPitch+X
      'if X = 0 and XX = (OutWid-1) then        
      '  dc_flushrange(OutData,(OutPitch*((YY-Y)+1)))
      '  DmaFillWords(TempColor,OutData,(OutPitch*((YY-Y)+1)))
      'else        
        XX -= (X-1)
        for CNT as integer = 0 to (YY-Y)
          FastSet(OutData,TempColor,XX)
          OutData += OutPitch
        next CNT        
      'end if          
    case else
      puts "Line type unknown..."
    end select
  case 2 '16bit
    #ifndef __FB_GFX_NO_16BPP__
      select case iType
      case 1 'B
        dim as uinteger TempColor = fb_Gfx24to16(iColor)
        dim as integer HasLeft=1,HasRight=1,NoTop,NoBottom
        if X > XX then swap X,XX
        if Y > YY then swap Y,YY
        if X < 0 then 
          if XX < 0 goto exitsub
          X = 0: HasLeft = 0
        end if
        if XX >= OutWid then
          if X >= OutWid goto exitsub
          XX = OutWid-1: HasRight = 0
        end if
        if Y < 0 then
          if YY < 0 then goto exitsub
          Y=0: OutData += Y*OutPitch+X+X
        else
          OutData += Y*OutPitch+X+X
          for CNX as integer = 0 to (XX-X)
            cptr(ushort ptr,OutData)[CNX] = TempColor
          next CNX
          NoTop = 1
        end if
        if YY >= OutHei then
          if Y >= OutHei goto exitsub
          YY=OutHei-1
        else
          dim as any ptr OutData2 = OutData+((YY-Y)*OutPitch)
          for CNX as integer = 0 to (XX-X)
            cptr(ushort ptr,OutData2)[CNX] = TempColor
          next CNX        
          NoBottom = 1
        end if     
        XX -= X
        if (HasLeft and HasRight) then        
          for CNT as integer = 0 to (YY-Y)
            *cptr(ushort ptr,OutData) = TempColor
            *cptr(ushort ptr,OutData+XX+XX) = TempColor
            OutData += OutPitch
          next CNT
        elseif HasLeft then
          for CNT as integer = 0 to (YY-Y)          
            *cptr(ushort ptr,OutData) = TempColor          
            OutData += OutPitch
          next CNT
        elseif HasRight then
          OutData += XX+XX
          for CNT as integer = 0 to (YY-Y)
            *cptr(ushort ptr,OutData) = TempColor          
            OutData += OutPitch
          next CNT        
        end if
      case 2 'BF
        #define RR ((iColor and &hF8) shl 7)
        #define GG ((iColor and &hF800) shr 6)
        #define BB ((iColor and &hF80000) shr 19)
        dim as uinteger TempColor = RR or GG or BB or &h8000
        TempColor = TempColor or (TempColor shl 16)       
        if X > XX then swap X,XX
        if Y > YY then swap Y,YY
        if X < 0 then X = 0: if XX < 0 goto exitsub
        if XX >= OutWid then XX = OutWid-1:if X >= OutWid goto exitsub
        if YY < 0  then Y = 0: if YY < 0 goto exitsub
        if YY >= OutHei then YY = OutHei-1: if YY >= OutHei goto exitsub
        if X = 0 and XX = (OutWid-1) then
          OutData += Y*OutPitch
          dc_flushrange(OutData,(OutPitch*((YY-Y)+1)))
          DmaFillWords(TempColor,OutData,(OutPitch*((YY-Y)+1)))
        else
          OutData += Y*OutPitch+X+X
          for CNY as integer = 0 to (YY-Y)
            for CNX as integer = 0 to (XX-X)
              cptr(ushort ptr,OutData)[CNX] = TempColor
            next CNX
            OutData += OutPitch
          next CNY
        end if      
      case else
        puts "Line not yet..."
      end select
    #else
      puts "LINE: 16bpp disabled"
    #endif
  case else
    puts "bit type not yet..."
  end select
  
  #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.CurrentDriver = gfx.gdOpenGL then
      with *cptr(gfx.GlData ptr,@(TempHead->_Reserved(1)))
        if .Texture then .TexFlags or= gfx.tfNeedUpdate
      end with
    end if
  #endif
  
  exitsub:
  gfx.Locked -= 1
  
  exit sub
  iStyle = iStyle 'Unused
  
end sub
' ************************** DRAW AN STRING ON TARGET *********************************
UndefAll()
#define  P1 pTarget as any ptr
#define  P2 sX      as single
#define  P3 sY      as single
#define  P4 Unk0    as integer
#define  P5 fbText  as any ptr
#define  P6 iColor  as uinteger
#define  P7 Unk1    as any ptr
#define  P8 Unk2    as integer
#define  P9 Unk3    as any ptr
#define P10 Unk4    as any ptr
#define P11 Unk5    as any ptr
__priv function _FB_Private_(fb_GfxDrawString) (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11) as integer
  DebugShowFunctionName()
  do
    #define s *cptr(FBSTRING ptr,fbText)
    dim as integer X=sX,Y=sY
    static as uinteger OutWid,OutHei,OutBpp,OutPitch
    static as any ptr OutData
    
    if s.len = 0 or s.data=0 then exit do
    dim as integer strsz = s.len
    dim as ubyte ptr strchar = cast(any ptr,s.data)
    
    if pTarget = 0 then pTarget = gfx.scr
    gfx.Locked += 1
    
    with *cptr(fb.image ptr,pTarget)
      '      --------- OpenGL --------- 
      if gfx.CurrentDriver = gfx.gdOpenGL andalso pTarget = gfx.scr then
        #ifndef __FB_GFX_NO_GL_RENDER__
          CheckFifoFull()        
            if Y <= -8 or Y > cint(.height) or X >= cint(.width) then exit do
            if .bpp <= 1 then
              iColor = gfx.PalettePtr[iColor and 255]
            else
              #define RR ((iColor and &hF8) shl 7)
              #define GG ((iColor and &hF800) shr 6)
              #define BB ((iColor and &hF80000) shr 19)
              iColor = RR or GG or BB or &h8000
            end if                    
            glBindTexture(0,gfx.FontTex)            
            'dim as short TempPal(3) = {0,-1,-1,-1}
            'glColorTableEXT(0,0,4,0,0,cast(any ptr,@TempPal(0)))
            glColor(iColor)
            glBegin(GL_QUAD_STRIP)
            'glBegin(GL_QUADS)
            do
              dim as long iOC=-1,OPY=-1
              while X < -8
                strsz -= 1: if strsz=0 then exit do
                X += 8: strchar += 1
              wend
              while X <= cint(.width)
                var iC = *strchar and 15
                dim as long PX = (iC) shl (3+(9-4))
                dim as long PY = ((*strchar shr 4) shl (3+(9-4)))'-16
                const SZ = 8 shl (9-4)           
                if PY<>OPY orelse iC<>((iOC+1) and 15) then
                  glTexCoord2f32(PX   ,PY)    : glVertex3v16(X  ,Y  ,gfx.Depth)
                  glTexCoord2f32(PX   ,PY+SZ) : glVertex3v16(X  ,Y+8,gfx.Depth)
                end if
                glTexCoord2f32(PX+SZ,PY)    : glVertex3v16(X+8,Y  ,gfx.Depth)
                glTexCoord2f32(PX+SZ,PY+SZ) : glVertex3v16(X+8,Y+8,gfx.Depth)
                strsz -= 1: if strsz=0 then exit do                
                X += 8: strchar += 1 : iOC = iC : OPY=PY
              wend
              exit do
            loop
            glEnd()
          gfx.Depth += gfx.DepthNext : gfx.fg.CanFlush = 1
          function=1:exit do
        #endif
      else ' -------- Software --------         
        strsz -= 1        
        if Y <= -8 or Y >= cint(.height) then exit do
        if X < -8 then 
          var iDiff = ((X+8) shr 3)      
          X -= (iDiff shl 3)
          strsz += iDiff: strchar -= iDiff
        end if    
        if X >= cint(.width) or strsz < 0 then exit do        
        var pFont = cast(ubyte ptr,fbgfxfont_tex)
        dim as integer iHei = 8  
        if Y < 0 then pFont -= (Y shl 5): iHei += Y: Y = 0
        if Y >= cint(.height-8) then iHei -= (Y-(.height-8))
        select case .bpp
        case 1 '8
          var pOut = cast(ubyte ptr,pTarget+sizeof(fb.image))+Y*(.pitch)+X
          for CNT as integer = 0 to strsz
            dim as ubyte ptr pIn = pFont + _
            (((*strchar) shr 4) shl 8) + ((*strchar and &hF) shl 1)  
            for Y as integer = 1 to iHei     
              if cuint(X) >= (.width-8) then
                if (pIn[0] and 1)  then if cuint(X+0) < .width then pOut[0] = iColor
                if (pIn[0] and 4)  then if cuint(X+1) < .width then pOut[1] = iColor
                if (pIn[0] and 16) then if cuint(X+2) < .width then pOut[2] = iColor
                if (pIn[0] and 64) then if cuint(X+3) < .width then pOut[3] = iColor
                if (pIn[1] and 1)  then if cuint(X+4) < .width then pOut[4] = iColor
                if (pIn[1] and 4)  then if cuint(X+5) < .width then pOut[5] = iColor
                if (pIn[1] and 16) then if cuint(X+6) < .width then pOut[6] = iColor
                if (pIn[1] and 64) then if cuint(X+7) < .width then pOut[7] = iColor
              else
                if (pIn[0] and 1)  then pOut[0] = iColor
                if (pIn[0] and 4)  then pOut[1] = iColor
                if (pIn[0] and 16) then pOut[2] = iColor
                if (pIn[0] and 64) then pOut[3] = iColor
                if (pIn[1] and 1)  then pOut[4] = iColor
                if (pIn[1] and 4)  then pOut[5] = iColor
                if (pIn[1] and 16) then pOut[6] = iColor
                if (pIn[1] and 64) then pOut[7] = iColor
              end if
              pIn += 32: pOut += (.pitch)
            next Y
            pOut -= (((.pitch)*iHei)-8): strchar += 1: X += 8
            if X >= cint(.width) then exit for
          next CNT          
        case 2 '16
          #ifndef __FB_GFX_NO_16BPP__
            var pOut = cast(ushort ptr,pTarget+sizeof(fb.image))+Y*(.width)+X
            iColor = fb_Gfx24to16(iColor)
            for CNT as integer = 0 to strsz
              dim as ubyte ptr pIn = pFont + _
              (((*strchar) shr 4) shl 8) + ((*strchar and &hF) shl 1)  
              for Y as integer = 1 to iHei     
                if cuint(X) >= (.width-8) then
                  if (pIn[0] and 1)  then if cuint(X+0) < .width then pOut[0] = iColor
                  if (pIn[0] and 4)  then if cuint(X+1) < .width then pOut[1] = iColor
                  if (pIn[0] and 16) then if cuint(X+2) < .width then pOut[2] = iColor
                  if (pIn[0] and 64) then if cuint(X+3) < .width then pOut[3] = iColor
                  if (pIn[1] and 1)  then if cuint(X+4) < .width then pOut[4] = iColor
                  if (pIn[1] and 4)  then if cuint(X+5) < .width then pOut[5] = iColor
                  if (pIn[1] and 16) then if cuint(X+6) < .width then pOut[6] = iColor
                  if (pIn[1] and 64) then if cuint(X+7) < .width then pOut[7] = iColor
                else
                  if (pIn[0] and 1)  then pOut[0] = iColor
                  if (pIn[0] and 4)  then pOut[1] = iColor
                  if (pIn[0] and 16) then pOut[2] = iColor
                  if (pIn[0] and 64) then pOut[3] = iColor
                  if (pIn[1] and 1)  then pOut[4] = iColor
                  if (pIn[1] and 4)  then pOut[5] = iColor
                  if (pIn[1] and 16) then pOut[6] = iColor
                  if (pIn[1] and 64) then pOut[7] = iColor
                end if
                pIn += 32: pOut += (.width)
              next Y
              pOut -= (((.width)*iHei)-8): strchar += 1: X += 8
              if X >= cint(.width) then exit for
            next CNT
          #else
            puts("DRAWSTRING: 16bpp disabled")
          #endif
        case else
          printf !"DrawString Wrong bpp: %i\n",.bpp
        end select
        function=1:exit do
      end if
    end with    
  loop
  gfx.Locked -= 1
  DestroyTempString(fbText)
  exit function
  Unk0 = Unk0 'Unused
  Unk1 = Unk1 'Unused
  Unk2 = Unk2 'Unused
  Unk3 = Unk3 'Unused
  Unk4 = Unk4 'Unused
  Unk5 = Unk5 'Unused
end function
' ************** CALCULATE REAL OFFSETS/COORDINATES/TARGETS for PUT *******************
UndefAll()
#define P1  pTarget as any ptr
#define P2  sPosX   as single
#define P3  sPosY   as single
#define P4  pSource as any ptr
#define P5  iCropX  as integer
#define P6  iCropY  as integer
#define P7  iCropXX as integer
#define P8  iCropYY as integer
#define P9  iStep   as integer
#define P10 iMethod as integer
#define P11 pMethod as any ptr
#define P12 iMParm  as integer
#define P13 pCustom as any ptr
#define P14 pCParm  as any ptr
__priv function _FB_Private_(fb_GfxPut) (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10,P11,P12,P13,P14) as integer  
  dim as integer PosX=sPosX,PosY=sPosY,OutWid,OutHei
  dim as integer XStart,YStart,bs,inBpp,OutBpp,IsScreen
  dim as integer SrcSize=sizeof(fb.image),TgtSize=sizeof(fb.image)
  dim as any ptr inStart,OutStart
  'iCropY += 1: iCropYY += 1
  if pSource = 0 then return 0
  if pTarget = 0 then pTarget = gfx.scr: IsScreen = 1
  
  if gfx.CurrentDriver <> gfx.gdOpenGL then
    if IsScreen andalso gfx.IsView then    
      static as fb.image tView
      tView = *cptr(fb.image ptr,pTarget):pTarget = @tView
      tView.Width  = gfx.ViewWid : PosX -= gfx.ViewLT
      tView.Height = gfx.ViewHei : PosY -= gfx.ViewTP  
      IsScreen = 2
    end if
  end if
  
  '0 = trans   1 = pset    2 = preset  
  '3 = and     4 = or      5 = xor     
  '6 = alpha   7 = add     8 = custom  
  '9 = blend  10 =        11 =         
  
  #ifndef __FB_GFX_NO_OLD_HEADER__
    if cptr(fb.image ptr,pSource)->Type <> 7 then
      static as fb.image NewHead
      NewHead.Width = cptr(fb.image ptr,pSource)->Old.Width
      NewHead.Height = cptr(fb.image ptr,pSource)->Old.Height
      NewHead.Bpp = (cptr(fb.image ptr,pSource)->Old.Bpp)
      NewHead.Pitch = (NewHead.Width*NewHead.Bpp) shr 3
      pSource = @NewHead: SrcSize = sizeof(ushort)*2    
    end if
  #endif
  
  #define tgt *cptr(fb.image ptr,pTarget)  
  with *cptr(fb.image ptr,pSource)    
    
    if cint(.Width) <= 0 or cint(.Height) <= 0 then return 0
    if cint(tgt.Width) <= 0 or cint(tgt.Height) <= 0 then return 0
    
    inBpp = .Bpp: OutBpp = Tgt.Bpp
    if InBpp > 8 then InBpp shr= 3
    if OutBpp > 8 then OutBpp shr= 3
    if InBpp <> 1 and inBpp <> 2 then 
      printf !"PUT: Wrong bpp: %i\n",InBpp
      return 0
    end if
    if InBpp <> OutBpp then return 0
    if cuint(iCropX) >= cint(.Width)  then iCropX = 0
    if cuint(iCropY) >= cint(.Height) then iCropY = 0
    if iCropXX < 0 or iCropX >= cint(.Width)  then iCropXX = cint(.Width)-1
    if iCropYY < 0 or iCropY >= cint(.Height) then iCropYY = cint(.Height)-1
    if iCropX > iCropXX then swap iCropX,iCropXX
    if iCropY > iCropYY then swap iCropY,iCropYY
    OutWid = (iCropXX-iCropX)+1
    OutHei = (iCropYY-iCropY)+1
    if gfx.CurrentDriver <> gfx.gdOpenGL then
      if PosX >= cint(tgt.Width) then return 0
      if PosY >= cint(tgt.Height) then return 0    
      if PosX <= -OutWid then return 0
      if PosY <= -OutHei then return 0
    end if
    
    if PosX < 0 then OutWid += PosX: iCropX -= PosX: PosX=0
    if PosY < 0 then OutHei += PosY: iCropY -= PosY: PosY=0
    if (PosX+OutWid) > cint(tgt.Width) then 
      iCropXX -= (PosX+OutWid)-tgt.Width : OutWid = cint(tgt.Width)-PosX
    end if
    if (PosY+OutHei) > cint(tgt.Height) then 
      iCropYY -= (PosY+OutHei)-tgt.Height : OutHei = cint(tgt.Height)-PosY
    end if
    if gfx.CurrentDriver = gfx.gdOpenGL andalso IsScreen then
      #ifndef __FB_GFX_NO_GL_RENDER__
        CheckFifoFull()
        'printf iCropX,iCropY,iCropXX,iCropYY
        with *cptr(gfx.ImageGL ptr,pSource)        
          if .Texture = 0 then 
            fb_NewTextureGL(pSource)        
            .TexFlags or= gfx.tfNeedUpdate
          end if
          #ifdef __FB_GFX_LAZYTEXTURE__
          var uIME = enterCriticalSection()
            glBindTexture(0,.Texture)
            if (.TexFlags and (gfx.tfAllocated or gfx.tfNeedUpdate))=0 then
              dim as gfx.TexParms tTemp 
                tTemp.TexWid = .TexWid
                tTemp.TexHei = .TexHei
                tTemp.TexFmt = 0 'GL_RGB256
                tTemp.CoordMode = 0 '1
              GFX_TEX_FORMAT = tTemp.u32
            end if
          #else
            glBindTexture(0,.Texture)            
          #endif          
          if (.TexFlags and gfx.tfNeedUpdate) then
            dim as integer Resu
            'iType = iif(inBpp>1,GL_RGBA,GL_RGB256)            
            'dim as double TMR = timer
            if 0 then 'TexPtr then
              #if 0
                dim as integer TexSize = ((8 shl .TexWid)*(cptr(fb.image ptr,pSource)->Height))*InBpp            
                dc_flushrange(pSource+sizeof(fb.image),TexSize)
                'cast_vu16_ptr(&h4000000) or= (1 shl 4)
                'while (cast_vu16_ptr(&h4000006) and 255) < 144
                '  fb_DoVsyncCallBack()
                '  if (cast_vu32_ptr(&h4000006) and 255) >= 144 then exit while
                '  'swiIntrWait(1,IRQ_HBLANK)
                'wend
                select case cuint(TexPtr)
                case &h6800000 to &h681FFFF: vramSetBankA(VRAM_A_LCD): Resu = 1
                case &h6820000 to &h683FFFF: vramSetBankB(VRAM_B_LCD): Resu = 2
                case &h6840000 to &h685FFFF: vramSetBankC(VRAM_C_LCD): Resu = 3
                case &h6860000 to &h687FFFF: vramSetBankD(VRAM_D_LCD): Resu = 4
                case else: Resu = 0
                end select              
                Resu = 1
                if Resu then              
                  dmacopy(pSource+sizeof(fb.image),TexPtr,TexSize)
                  select case cuint(TexPtr)
                  case &h6800000 to &h681FFFF: vramSetBankA(VRAM_A_TEXTURE)
                  case &h6820000 to &h683FFFF: vramSetBankB(VRAM_B_TEXTURE)
                  case &h6840000 to &h685FFFF: vramSetBankC(VRAM_C_TEXTURE)
                  case &h6860000 to &h687FFFF: vramSetBankD(VRAM_D_TEXTURE)
                  end select
                end if
                'cast_vu16_ptr(&h4000000) and= (not (1 shl 4))
                'puts "Texture Dynamic upload..."
              #endif
            else
              #if (not defined(__FB_GFX_NO_GL_RENDER__)) and defined(__FB_GFX_LAZYTEXTURE__)
                if ((gfx.g_TexImageWrite+1) and 255)=gfx.g_TexImageRead then               
                  puts("Update buffer full!")
                  fbgl_UploadTexture(pSource)
                else                              
                  'GL_NOTEXTURE
                  'if glTexImage2D(0,0,GL_NOTEXTURE,0,.TexWid,.TexHei,TEXGEN_TEXCOORD,pSource+sizeof(gfx.ImageGL))=0 then
                  '  'puts("Failed...")
                  'end if
                  .TexFlags and= (not gfx.tfNeedUpdate)
                  gfx.g_pTex(gfx.g_TexImageWrite) = pSource
                  gfx.g_TexImageWrite = (gfx.g_TexImageWrite+1) and 255
                end if
              #else
                while cuint((REG_VCOUNT)-144) > (192-144)
                  sleep 0
                wend
                fbgl_UploadTexture(pSource)
              #endif
            end if         
          end if
          
          dim as integer PX = (iCropX) shl (9-.TexWid), PXX = ((iCropXX+1) shl (9-.TexWid))
          dim as integer PY = iCropY shl (9-.TexHei), PYY = ((iCropYY+1) shl (9-.TexHei))
          'TEXGEN_TEXCOORD
          glTexParameter(0,TEXGEN_OFF or (GL_TEXTURE_COLOR0_TRANSPARENT and (iMethod<>gfx.pmPset)))
          'glAssignColorTable (0, gfx.Texture)        
          glColor(gfx.TextureColor)                
          dim as byte bUndoCull = 0
          if iMethod=gfx.pmBlend then 
            dim as integer iAlpha = (imPARM and 255) shr 3
            if iAlpha < 1 then iAlpha = 1 else if iAlpha > 31 then iAlpha = 31
            glPolyFmt(POLY_ALPHA(iAlpha) or POLY_CULL_FRONT) : bUndoCull = 1
          end if
          if (.TexFlags and gfx.tfAllocated) then 
            fbgl_BubbleUpTexture(pSource)
          else
            glPolyFmt(POLY_ALPHA(1) or POLY_CULL_BACK)
            bUndoCull = 1
          end if
          
          glBegin(GL_QUADS)          
            glTexCoord2f32(PX,PY-1):glVertex3v16(PosX, PosY, gfx.Depth)
            glTexCoord2f32(PXX,PY-1):glVertex3v16(PosX+OutWid, PosY, gfx.Depth)
            glTexCoord2f32(PXX,PYY-1):glVertex3v16(PosX+OutWid, PosY+OutHei, gfx.Depth)
            glTexCoord2f32(PX,PYY-1):glVertex3v16(PosX, PosY+OutHei, gfx.Depth)
          glEnd()
          gfx.Depth += gfx.DepthNext:gfx.fg.CanFlush = 1
          if bUndoCull then glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE)
          #ifdef __FB_GFX_LAZYTEXTURE__
          leaveCriticalSection(uIME)
          #endif
        end with
        
      #endif
    else
      #ifndef __FB_GFX_NO_GL_RENDER__
        if gfx.CurrentDriver = gfx.gdOpenGL then
          with *cptr(gfx.GlData ptr,@(tgt._Reserved(1)))
            if .Texture then .TexFlags or= gfx.tfNeedUpdate      
          end with
        end if  
      #endif
      
      bs = inBpp:OutWid *= bs
      inStart = pSource+SrcSize+(iCropY*.Pitch)+(iCropX*bs)
      
      if IsScreen=2 then
        OutStart = cast(any ptr,gfx.scr+1)+((gfx.ViewTP+PosY)*tgt.Pitch)+((gfx.ViewLT+PosX)*bs)
      else      
        OutStart = pTarget+TgtSize+(PosY*tgt.Pitch)+(PosX*bs)
      end if
      
      UndefAll()
      #define P1 pSourceStart as ubyte ptr
      #define P2 pTargetStart as ubyte ptr
      #define P3 iLineSize    as integer
      #define P4 iRowCount    as integer
      #define P5 iSourcePitch as integer
      #define P6 iTargetPitch as integer
      #define P7 iMethodParm  as integer
      #define P8 iCustomFunc  as any ptr
      #define P9 iCustomParm  as any ptr
      dim MethodFunc as sub (P1,P2,P3,P4,P5,P6,P7,P8,P9) = pMethod
      gfx.Locked += 1
      MethodFunc(inStart,OutStart,OutWid,OutHei,.pitch,tgt.pitch,iMParm,pCustom,pCParm)
      gfx.Locked -= 1
      
    end if
    
    return -1
    
  end with
  
  iStep = iStep 'Unused
  
end function
' ====================================================================================
' ================== CALLBACK FOR METHODS PASSED TO PUT FUNCTION =====================
' ====================================================================================
UndefAll()
#define P1 pSource      as ubyte ptr
#define P2 pTarget      as ubyte ptr
#define P3 iLineSize    as integer
#define P4 iRowCount    as integer
#define P5 iSourcePitch as integer
#define P6 iTargetPitch as integer
#define P7 iMethodParm  as integer
#define P8 iCustomFunc  as any ptr
#define P9 iCustomParm  as any ptr
' ********************************* ALPHA METHOD **************************************
__priv sub _FB_Private_(fb_hPutBlend) (P1,P2,P3,P4,P5,P6,P7,P8,P9)
  'puts("Puts With Alpha Not Yet...")
  exit sub
  pSource = pSource 'Unused
  pTarget = pTarget 'Unused
  iLineSize = iLineSize 'Unused
  iRowCount = iRowCount 'Unused
  iSourcePitch = iSourcePitch 'Unused
  iTargetPitch = iTargetPitch 'Unused
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
' ********************************* PSET METHOD **************************************
__priv sub _FB_Private_(fb_hPutPSet) (P1,P2,P3,P4,P5,P6,P7,P8,P9)
  'print hex$(pSource,8);" ";hex$(pTarget,8);" ";iLineSize
  #ifdef rtUseASM
  asm
    ldr r0, $iRowCount
    ldr r1, $iLineSize
    ldr r2, $pSource
    ldr r3, $pTarget
    ldr r4, $iSourcePitch
    ldr r5, $iTargetPitch        
    sub r2, #1
    sub r3, #1
    sub r4, r1
    sub r5, r1
    
    cmp r1, #4
    bge 0f
    1: mov r6, r1    
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!    
    2:
    add r2, r4
    add r3, r5
    subs r0, #1
    bne 1b
    b 9f  
    
    0: mov r6, r1
    1: ldrb r7, [r2,#1]!
    ldrb r8, [r2,#1]!
    ldrb r9, [r2,#1]!
    ldrb r10, [r2,#1]!
    strb r7, [r3,#1]!
    strb r8, [r3,#1]!
    strb r9, [r3,#1]!
    strb r10, [r3,#1]!
    sub r6, #4
    cmp r6, #4
    bge 1b            
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    strb r7, [r3,#1]!    
    2:
    add r2, r4
    add r3, r5
    subs r0, #1
    bne 0b    
    9:
  end asm  
  #else
  for CNT as integer = 0 to iRowCount-1    
    'for CNT as integer = 0 to iLineSize-1 step 2
    '  *cptr(ushort ptr,pTarget+CNT) = *cptr(ushort ptr,pSource+CNT)
    'next CNT
    FastCopy(pTarget,pSource,iLineSize)
    pSource += iSourcePitch: pTarget += iTargetPitch
  next CNT
  #endif
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
' ******************************** TRANS METHOD **************************************
__priv sub _FB_Private_(fb_hPutTrans) (P1,P2,P3,P4,P5,P6,P7,P8,P9)  
  
  #ifdef rtUseASM
  asm
    ldr r0, $iRowCount
    ldr r1, $iLineSize
    ldr r2, $pSource
    ldr r3, $pTarget
    ldr r4, $iSourcePitch
    ldr r5, $iTargetPitch        
    sub r2, #1
    sub r3, #1
    sub r4, r1
    sub r5, r1
    
    cmp r1, #4
    bge 0f
    1: mov r6, r1    
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!
    addeq r3, #1
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!
    addeq r3, #1
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!    
    addeq r3, #1
    2:
    add r2, r4
    add r3, r5
    subs r0, #1
    bne 1b
    b 9f  
    
    0: mov r6, r1
    1: ldrb r7, [r2,#1]!
    ldrb r8, [r2,#1]!
    ldrb r9, [r2,#1]!
    ldrb r10, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!
    addeq r3, #1
    cmp r8, #0
    strneb r8, [r3,#1]!
    addeq r3, #1
    cmp r9, #0
    strneb r9, [r3,#1]!
    addeq r3, #1
    cmp r10, #0
    strneb r10, [r3,#1]!
    addeq r3, #1
    sub r6, #4
    cmp r6, #4
    bge 1b            
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!
    addeq r3, #1
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!
    addeq r3, #1
    subs r6, #1
    bmi 2f
    ldrb r7, [r2,#1]!
    cmp r7, #0
    strneb r7, [r3,#1]!    
    addeq r3, #1
    2:
    add r2, r4
    add r3, r5
    subs r0, #1
    bne 0b    
    9:
  end asm
  #else
  for CNT as integer = 0 to iRowCount-1      
    for POSI as integer = 0 to iLineSize-1
      if pSource[POSI] then pTarget[POSI] = pSource[POSI]
    next POSI        
    pSource += iSourcePitch
    pTarget += iTargetPitch    
  next CNT
  #endif
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
' ******************************** TRANS METHOD **************************************
__priv sub _FB_Private_(fb_hPutAnd) (P1,P2,P3,P4,P5,P6,P7,P8,P9)  
  for CNT as integer = 0 to iRowCount-1        
    for POSI as integer = 0 to iLineSize-1
      pTarget[POSI] and= pSource[POSI]
    next POSI
    pSource += iSourcePitch
    pTarget += iTargetPitch    
  next CNT
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
__priv sub _FB_Private_(fb_hPutXor) (P1,P2,P3,P4,P5,P6,P7,P8,P9)  
  for CNT as integer = 0 to iRowCount-1        
    for POSI as integer = 0 to iLineSize-1
      pTarget[POSI] xor= pSource[POSI]
    next POSI
    pSource += iSourcePitch
    pTarget += iTargetPitch    
  next CNT
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
__priv sub _FB_Private_(fb_hPutOr) (P1,P2,P3,P4,P5,P6,P7,P8,P9)  
  for CNT as integer = 0 to iRowCount-1        
    for POSI as integer = 0 to iLineSize-1
      pTarget[POSI] or= pSource[POSI]
    next POSI
    pSource += iSourcePitch
    pTarget += iTargetPitch    
  next CNT
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
__priv sub _FB_Private_(fb_hPutPReset) (P1,P2,P3,P4,P5,P6,P7,P8,P9)  
  for CNT as integer = 0 to iRowCount-1        
    for POSI as integer = 0 to iLineSize-1
      pTarget[POSI] = not pSource[POSI]
    next POSI
    pSource += iSourcePitch
    pTarget += iTargetPitch    
  next CNT
  exit sub
  iMethodParm = iMethodParm 'Unused
  iCustomFunc = iCustomFunc 'Unused
  iCustomParm = iCustomParm 'Unused
end sub
' ****************** PAINT AN AREA LIMITED BY A BORDER COLOR ***********************
UndefAll()
#define P1 pTarget as any ptr
#define P2 sX      as single
#define P3 sY      as single
#define P4 iColor  as uinteger
#define P5 iBorder as uinteger
#define P6 sStyle  as any ptr
#define P7 iUnk    as integer
#define p8 iFlags  as integer
__priv sub _FB_Private_(fb_GfxPaint) (P1,P2,P3,P4,P5,P6,P7,P8)
    
  dim as integer X=sX,Y=sY
  dim as integer OutWid=any,OutHei=any,OutBpp=any,OutPitch=any
  dim as any ptr OutData=any
  
  'DestroyTempString(sStyle)
    
  if pTarget = 0 then     
    pTarget = gfx.scr
    #ifndef __FB_GFX_NO_GL_RENDER__
      if gfx.CurrentDriver = gfx.gdOpenGL then      
        puts("PAINT: over GL! :O") 'TODO
        exit sub
      end if
    #endif
  end if
  dim as fb.image ptr TempHead = cptr(fb.image ptr,pTarget)  
  #ifdef __FB_GFX_NO_OLD_HEADER__
  if 1 then
  #else
  if TempHead->Type <> 7 then    
    OutWid = TempHead->Old.Width
    OutHei = TempHead->Old.Height
    OutBpp = (TempHead->Old.Bpp)*8
    OutPitch = (OutWid*OutBpp) shr 3  
    OutData = cast(any ptr,pTarget)+4
    puts("PAINT: old header!")
  else
  #endif
    with *Temphead
      OutWid = .Width: OutHei = .Height
      OutBpp = .Bpp: OutData = TempHead+1
      OutPitch = .Pitch
    end with
  end if  
  'Clips paint...
  if cuint(X) >= OutWid or cuint(Y) >= OutHei then exit sub
  'Paint Variables

  #define stack_size 64
  dim as integer stack_pos=any,x1=any,ya=any,yb=any
  dim as integer on_lineA=any,on_lineB=any,oldx=any  
  dim stack(0 to stack_size - 1) as integer = any  
  'Paint Initial stack setup
  stack_pos = stack_size-2  
  stack(stack_pos+0) = X
  stack(stack_pos+1) = Y
  
  if iFlags <> 4 then
    printf !"PAINT: Unknown flags %i",iFlags
    exit sub
  end if
  
  gfx.Locked += 1
    
  select case OutBpp
  case 1 '256 colors
    dim cTab(255) as byte
    cTab(iColor)=1:cTab(iBorder)=1
    
    dim as ubyte ptr p = any        
    while stack_pos < stack_size
      
      if stack_pos < 4 then
        puts("PAINT stack overflow!")
        exit sub
      end if
      
      X = stack(stack_pos+0)
      Y = stack(stack_pos+1)
      stack_pos += 2    
      p = OutData+(y * OutPitch)    
      on_lineA = 0:on_lineB = 0
      
      do
        X -= 1: if X < 0 then exit do
      loop until p[X] = iBorder
      X += 1
      
      oldx=X : ya=Y-1 : yb=Y+1
      
      if (cuint(yb) <= OutHei) then
        while x < OutWid
          if p[x] = iBorder then exit while                            
          if cTab(p[x + OutPitch])=0 then
            if on_lineB = 0 then
              stack_pos -= 2
              stack(stack_pos+0) = X
              stack(stack_pos+1) = yb
              on_lineB = 1
            end if
          else
            on_lineB = 0
          end if        
          x += 1
        wend    
      end if    
      if (cuint(ya) <= OutHei) then
        for xx as integer =oldx to x-1
          if cTab(p[xx - OutPitch])=0 then
            if on_lineA = 0 then
              stack_pos -= 2
              stack(stack_pos+0) = xx
              stack(stack_pos+1) = ya
              on_lineA = 1
            end if
          else
            on_lineA = 0
          end if
          'p[xx] = iColor
        next xx      
      end if
      
      'memset(@p[oldx],iColor,x-oldx)
      FastSet(@p[oldx],iColor,x-oldx)
      
    wend
  case 2 '16bit
    #ifndef __FB_GFX_NO_16BPP__
      #define p cptr(ushort ptr,pp)
      #define p_(_off) cptr(ushort ptr,(_off)+(pp))      
      if stack_pos < 0 then
        puts("PAINT stack overflow!")
        exit sub
      end if
      dim as any ptr pp = any      
      while stack_pos < stack_size
        X = stack(stack_pos+0)
        Y = stack(stack_pos+1)
        stack_pos += 2    
        pp = OutData+(y * OutPitch)    
        on_lineA = 0:on_lineB = 0
        
        do
          X -= 1: if X < 0 then exit do
        loop until p[X] = iBorder
        X += 1
        
        oldx=X : ya=Y-1 : yb=Y+1
        
        if (cuint(yb) < OutHei) then
          while x < OutWid
            if p[x] = iBorder then exit while                            
            if p_(OutPitch)[x]<>iBorder and p_(OutPitch)[x]<>iColor then
              if on_lineB = 0 then
                stack_pos -= 2
                stack(stack_pos+0) = X
                stack(stack_pos+1) = yb
                on_lineB = 1
              end if
            else
              on_lineB = 0
            end if        
            x += 1
          wend    
        end if    
        if (cuint(ya) < OutHei) then
          for xx as integer =oldx to x-1
            if p_(-OutPitch)[xx]<>iBorder and p_(-OutPitch)[xx]<>iColor then
              if on_lineA = 0 then
                stack_pos -= 2
                stack(stack_pos+0) = xx
                stack(stack_pos+1) = ya
                on_lineA = 1
              end if
            else
              on_lineA = 0
            end if
            'p[xx] = iColor
          next xx      
        end if
        
        for CNT as integer = oldx to x-1
          p[CNT] = iColor
        next CNT
      wend
    #else
      puts "PAINT: 16bpp disabled"
    #endif
  case else
    puts "PAINT: other bpp not yet..."
  end select
  
  #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.CurrentDriver = gfx.gdOpenGL then
      with *cptr(gfx.GlData ptr,@(TempHead->_Reserved(1)))
        if .Texture then .TexFlags or= gfx.tfNeedUpdate
      end with
    end if  
  #endif

  gfx.Locked -= 1
  exit sub
  
  iUnk = iUnk 'Unused
  
end sub
' **************** DRAWS A CIRCLE/ELIPPSE/ARC FILLED or OUTLINED ********************
UndefAll()
#define P1  pTarget as any ptr
#define P2  sX      as single
#define P3  sY      as single
#define P4  fRadius as single
#define P5  iColor  as uinteger
#define P6  fAspect as single
#define P7  fStart  as single
#define P8  fEnd    as single
#define P9  iFilled as integer
#define P10 iFlags  as integer
__priv sub _FB_Private_(fb_GfxEllipse) (P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)
  
  dim as integer X0=sX,Y0=sY
  dim as integer OutWid=any,OutHei=any,OutBpp=any,OutPitch=any
  dim as any ptr OutData=any
  
  if pTarget = 0 then     
    pTarget = gfx.scr
    #ifndef __FB_GFX_NO_GL_RENDER__
      if gfx.CurrentDriver = gfx.gdOpenGL then      
        puts("CIRCLE: over GL! :O") 'TODO
        exit sub
      end if
    #endif
  end if
  dim as fb.image ptr TempHead = cptr(fb.image ptr,pTarget)  
  #ifdef __FB_GFX_NO_OLD_HEADER__
  if 1 then
  #else
  if TempHead->Type <> 7 then    
    OutWid = TempHead->Old.Width
    OutHei = TempHead->Old.Height
    OutBpp = (TempHead->Old.Bpp)*8
    OutPitch = (OutWid*OutBpp) shr 3  
    OutData = cast(any ptr,pTarget)+4
    puts("CIRCLE: old header!")
  else
  #endif
    with *Temphead
      OutWid = .Width: OutHei = .Height
      OutBpp = .Bpp: OutData = TempHead+1
      OutPitch = .Pitch
    end with
  end if  
    
  if iFlags <> 4 then
    printf !"CIRCLE: Unknown flags %i",iFlags
    exit sub
  end if
  
  gfx.Locked += 1  
  
  ' >>>>> THIS DOUBLE TIMES LOL <<<<
  'if fStart=0 then
  '  if *cast(uinteger ptr,@fEnd) <> &h40C90FDC then
  '    fStart = 0.000001
  '  end if
  'end if  
  ' >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  
  select case OutBpp
  case 1 '256 colors
    if fAspect <> 0 then          'ELLIPSE 
      puts "CIRCLE: ellipse not yet"
    else                          'CIRCLE  
      dim as integer x = fRadius,y = 0, radiusError = 1-x          
      var iBuffSz=(OutPitch*OutHei)
      var pMidPix = cast(byte ptr,OutData)+(y0*OutPitch)+(x0)  
      if iFilled then               'FILLED CIRCLE   
        pMidPix -= x0
        var q0 = pMidPix-(x*OutPitch) ' y0-x 
        var q1 = pMidPix-(y*OutPitch) ' y0-y 
        var q2 = pMidPix+(y*OutPitch) ' y0+y 
        var q3 = pMidPix+(x*OutPitch) ' y0+x 
        while x >= y
          var iAmountY = y+y+1, iAmountX = x+x+1
          var iLeftY = x0-y, iLeftX = x0-x    
          if iLeftY < 0 then iAmountY += iLeftY: iLeftY=0
          if iLeftX < 0 then iAmountX += iLeftX: iLeftX=0
          if (x0+y) >= OutWid then iAmountY -= (x0+y)-(OutWid-1)
          if (x0+x) >= OutWid then iAmountX -= (x0+x)-(OutWid-1)    
          if iAmountY > 0 then
            if (cuint(q0)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset(q0+iLeftY,iColor,iAmountY) '0
            end if
            if (cuint(q3)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset(q3+iLeftY,iColor,iAmountY) '3
            end if
          end if
          if iAmountX > 0 then
            if (cuint(q1)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset(q1+iLeftX,iColor,iAmountX) '1
            end if
            if (cuint(q2)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset(q2+iLeftX,iColor,iAmountX) '2
            end if
          end if
          
          y += 1: q1 -= OutPitch: q2 += OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1
          else
            x -= 1: q0 += OutPitch: q3 -= OutPitch 
            radiusError += 2 * (y - x + 1)
          end if    
        wend
      elseif fStart then            'OUTLINED ARC    
        const _PI2=6.2831854,sTemp=16384/_PI2,_iTabSize = 2048        
        dim as integer iStartAng = (fStart*sTemp) and 16383
        dim as integer iEndAng   = (fEnd*sTemp) and 16383        
        if iStartAng > iEndAng then iEndAng += 16384          
        #macro SetOctant(_N,_ANGS,_ANGE,_ALGO)
        if (iStartAng >= (_ANGS) and iEndAng <= (_ANGE)) orelse (iEndAng>= (_ANGS) and iStartAng <= (_ANGE)) then q##_N = _ALGO
        if (iStartAng >= (_ANGS+16384) and iEndAng <= (_ANGE+16384)) orelse (iEndAng>= (_ANGS+16384) and iStartAng <= (_ANGE+16384)) then q##_N = _ALGO  
        #endmacro
        dim as ubyte ptr q0,q1,q2,q3,q4,q5,q6,q7
        SetOctant(0,14336,16383,pMidPix+(y*OutPitch)+x) 'x0 + x , y0 + y
        SetOctant(1,12288,14335,pMidPix+(x*OutPitch)+y) 'x0 + y , y0 + x
        SetOctant(2,10240,12887,pMidPix+(x*OutPitch)-y) 'x0 - y , y0 + x
        SetOctant(3, 8192,10239,pMidPix+(y*OutPitch)-x) 'x0 - x , y0 + y
        SetOctant(4, 6144, 8191,pMidPix-(y*OutPitch)-x) 'x0 - x , y0 - y
        SetOctant(5, 4096, 6143,pMidPix-(x*OutPitch)-y) 'x0 - y , y0 - x
        SetOctant(6, 2048, 4095,pMidPix-(x*OutPitch)+y) 'x0 + y , y0 - x
        SetOctant(7,    0, 2047,pMidPix-(y*OutPitch)+x) 'x0 + x , y0 - y
        #macro DrawPixel(N) 
          if (cuint(q##n)-cuint(OutData))<iBuffSz then 
            if i##N >= iStartAng and i##N <= iEndAng then *q##N = iColor
            if i##N >= (iStartAng-16384) and i##N <= (iEndAng-16384) then *q##N = iColor
          end if
        #endmacro      
        while x >= y    
          var i7 = ifbAtnTab((y*_iTabSize)\x)    
          var i6=4095-i7,i5=i7+4096,i4=8192-i7,i3=i7+8192
          var i2=12288-i7,i1=i7+12288,i0=16383-i7
          if cuint(x0+x) < OutWid then : DrawPIxel(0) : DrawPIxel(7) : end if    
          if cuint(x0+y) < OutWid then : DrawPIxel(1) : DrawPIxel(6) : end if    
          if cuint(x0-x) < OutWid then : DrawPIxel(3) : DrawPIxel(4) : end if
          if cuint(x0-y) < OutWid then : DrawPIxel(2) : DrawPIxel(5) : end if
          y += 1: q0 += OutPitch: q1 += 1: q2 -= 1: q3 += OutPitch: 
          q4 -= OutPitch: q5 -= 1: q6 += 1: q7 -= OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1            
          else
            x -= 1: q0 -= 1: q1 -= OutPitch: q2 -= OutPitch: q3 += 1
            q4 += 1: q5 += OutPitch: q6 += OutPitch: q7 -= 1
            radiusError += 2 * (y - x + 1)
          end if
        wend        
      else                          'OUTLINED CIRCLE 
        'printf(!"%x \n",*cptr(uinteger ptr,@fEnd))
        var q0 = pMidPix+(y*OutPitch)+x 'x0 + x , y0 + y
        var q1 = pMidPix+(x*OutPitch)+y 'x0 + y , y0 + x
        var q2 = pMidPix+(x*OutPitch)-y 'x0 - y , y0 + x
        var q3 = pMidPix+(y*OutPitch)-x 'x0 - x , y0 + y
        var q4 = pMidPix-(y*OutPitch)-x 'x0 - x , y0 - y
        var q5 = pMidPix-(x*OutPitch)-y 'x0 - y , y0 - x
        var q6 = pMidPix-(x*OutPitch)+y 'x0 + y , y0 - x
        var q7 = pMidPix-(y*OutPitch)+x 'x0 + x , y0 - y
        #define DrawPixel(N) if (cuint(q##n)-cuint(OutData))<iBuffSz then : *q##N = iColor : end if    
        while x >= y
          if cuint(x0+x) < OutWid then : DrawPixel(0) : DrawPixel(7) : end if
          if cuint(x0+y) < OutWid then : DrawPixel(1) : DrawPixel(6) : end if
          if cuint(x0-x) < OutWid then : DrawPixel(3) : DrawPixel(4) : end if
          if cuint(x0-y) < OutWid then : DrawPixel(2) : DrawPixel(5) : end if
          y += 1: q0 += OutPitch: q1 += 1: q2 -= 1: q3 += OutPitch
          q4 -= OutPitch: q5 -= 1: q6 += 1: q7 -= OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1
          else
            x -= 1: q0 -= 1: q1 -= OutPitch: q2 -= OutPitch: q3 += 1
            q4 += 1: q5 += OutPitch: q6 += OutPitch: q7 -= 1
            radiusError += 2 * (y - x + 1)
          end if    
        wend
      end if
    end if
  case 2 '16bit
    iColor = fb_Gfx24to16(iColor)
    #ifndef __FB_GFX_NO_16BPP__    
    if fAspect <> 0 then          'ELLIPSE 
      puts "CIRCLE: ellipse not yet"
    else                          'CIRCLE  
      dim as integer x = fRadius,y = 0, radiusError = 1-x          
      var iBuffSz=(OutPitch*OutHei)
      var pMidPix = cast(byte ptr,OutData)+(y0*OutPitch)+(x0*2)  
      if iFilled then               'FILLED CIRCLE   
        pMidPix -= x0*2
        var q0 = pMidPix-(x*OutPitch) ' y0-x 
        var q1 = pMidPix-(y*OutPitch) ' y0-y 
        var q2 = pMidPix+(y*OutPitch) ' y0+y 
        var q3 = pMidPix+(x*OutPitch) ' y0+x 
        while x >= y
          var iAmountY = y+y+1, iAmountX = x+x+1
          var iLeftY = x0-y, iLeftX = x0-x    
          if iLeftY < 0 then iAmountY += iLeftY: iLeftY=0
          if iLeftX < 0 then iAmountX += iLeftX: iLeftX=0
          if (x0+y) >= OutWid then iAmountY -= (x0+y)-(OutWid-1)
          if (x0+x) >= OutWid then iAmountX -= (x0+x)-(OutWid-1)    
          if iAmountY > 0 then
            if (cuint(q0)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset16(q0+iLeftY*2,iColor,iAmountY) '0
            end if
            if (cuint(q3)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset16(q3+iLeftY*2,iColor,iAmountY) '3
            end if
          end if
          if iAmountX > 0 then
            if (cuint(q1)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset16(q1+iLeftX*2,iColor,iAmountX) '1
            end if
            if (cuint(q2)-cuint(OutData))<iBuffSz then 'Y Clipping
              fastset16(q2+iLeftX*2,iColor,iAmountX) '2
            end if
          end if
          
          y += 1: q1 -= OutPitch: q2 += OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1
          else
            x -= 1: q0 += OutPitch: q3 -= OutPitch 
            radiusError += 2 * (y - x + 1)
          end if    
        wend
      elseif fStart then            'OUTLINED ARC    
        const _PI2=6.2831854,sTemp=16384/_PI2,_iTabSize = 2048        
        dim as integer iStartAng = (fStart*sTemp) and 16383
        dim as integer iEndAng   = (fEnd*sTemp) and 16383        
        if iStartAng > iEndAng then iEndAng += 16384          
        #macro SetOctant(_N,_ANGS,_ANGE,_ALGO)
        if (iStartAng >= (_ANGS) and iEndAng <= (_ANGE)) orelse (iEndAng>= (_ANGS) and iStartAng <= (_ANGE)) then q##_N = cast(ushort ptr,_ALGO)
        if (iStartAng >= (_ANGS+16384) and iEndAng <= (_ANGE+16384)) orelse (iEndAng>= (_ANGS+16384) and iStartAng <= (_ANGE+16384)) then q##_N = cast(ushort ptr,_ALGO)
        #endmacro
        dim as ushort ptr q0=any,q1=any,q2=any,q3=any,q4=any,q5=any,q6=any,q7=any
        SetOctant(0,14336,16383,pMidPix+(y*OutPitch)+x*2) 'x0 + x , y0 + y
        SetOctant(1,12288,14335,pMidPix+(x*OutPitch)+y*2) 'x0 + y , y0 + x
        SetOctant(2,10240,12887,pMidPix+(x*OutPitch)-y*2) 'x0 - y , y0 + x
        SetOctant(3, 8192,10239,pMidPix+(y*OutPitch)-x*2) 'x0 - x , y0 + y
        SetOctant(4, 6144, 8191,pMidPix-(y*OutPitch)-x*2) 'x0 - x , y0 - y
        SetOctant(5, 4096, 6143,pMidPix-(x*OutPitch)-y*2) 'x0 - y , y0 - x
        SetOctant(6, 2048, 4095,pMidPix-(x*OutPitch)+y*2) 'x0 + y , y0 - x
        SetOctant(7,    0, 2047,pMidPix-(y*OutPitch)+x*2) 'x0 + x , y0 - y
        #macro DrawPixel(N)
          if (cuint(q##n)-cuint(OutData))<iBuffSz then 
            if i##N >= iStartAng and i##N <= iEndAng then *q##N = iColor
            if i##N >= (iStartAng-16384) and i##N <= (iEndAng-16384) then *q##N = iColor
          end if
        #endmacro      
        while x >= y    
          var i7 = ifbAtnTab((y*_iTabSize)\x)    
          var i6=4095-i7,i5=i7+4096,i4=8192-i7,i3=i7+8192
          var i2=12288-i7,i1=i7+12288,i0=16383-i7
          if cuint(x0+x) < OutWid then : DrawPIxel(0) : DrawPIxel(7) : end if    
          if cuint(x0+y) < OutWid then : DrawPIxel(1) : DrawPIxel(6) : end if    
          if cuint(x0-x) < OutWid then : DrawPIxel(3) : DrawPIxel(4) : end if
          if cuint(x0-y) < OutWid then : DrawPIxel(2) : DrawPIxel(5) : end if
          y += 1: q0 += OutPitch: q1 += 2: q2 -= 2: q3 += OutPitch: 
          q4 -= OutPitch: q5 -= 2: q6 += 2: q7 -= OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1            
          else            
            x -= 1: q0 -= 1: : q3 += 2 : q4 += 1 : q7 -= 1
            *cptr(any ptr ptr,@q1) -= OutPitch : *cptr(any ptr ptr,@q2) -= OutPitch
            *cptr(any ptr ptr,@q5) += OutPitch : *cptr(any ptr ptr,@q6) += OutPitch
            radiusError += 2 * (y - x + 1)
          end if
        wend        
      else                          'OUTLINED CIRCLE 
        'printf(!"%x \n",*cptr(uinteger ptr,@fEnd))
        var q0 = pMidPix+(y*OutPitch)+x*2 'x0 + x , y0 + y
        var q1 = pMidPix+(x*OutPitch)+y*2 'x0 + y , y0 + x
        var q2 = pMidPix+(x*OutPitch)-y*2 'x0 - y , y0 + x
        var q3 = pMidPix+(y*OutPitch)-x*2 'x0 - x , y0 + y
        var q4 = pMidPix-(y*OutPitch)-x*2 'x0 - x , y0 - y
        var q5 = pMidPix-(x*OutPitch)-y*2 'x0 - y , y0 - x
        var q6 = pMidPix-(x*OutPitch)+y*2 'x0 + y , y0 - x
        var q7 = pMidPix-(y*OutPitch)+x*2 'x0 + x , y0 - y
        #define DrawPixel(N) if (cuint(q##n)-cuint(OutData))<iBuffSz then : *q##N = iColor : end if    
        while x >= y
          if cuint(x0+x) < OutWid then : DrawPixel(0) : DrawPixel(7) : end if
          if cuint(x0+y) < OutWid then : DrawPixel(1) : DrawPixel(6) : end if
          if cuint(x0-x) < OutWid then : DrawPixel(3) : DrawPixel(4) : end if
          if cuint(x0-y) < OutWid then : DrawPixel(2) : DrawPixel(5) : end if
          y += 1: q1 += 1: q2 -= 1: q5 -= 1: q6 += 1
          *cptr(any ptr ptr,@q0) += OutPitch : *cptr(any ptr ptr,@q3) += OutPitch
          *cptr(any ptr ptr,@q4) -= OutPitch : *cptr(any ptr ptr,@q7) -= OutPitch
          if (radiusError<0) then    
            radiusError += 2 * y + 1
          else
            x -= 1: q0 -= 1 : q3 += 1 : q4 += 1 : q7 -= 1
            *cptr(any ptr ptr,@q1) -= OutPitch : *cptr(any ptr ptr,@q2) -= OutPitch
            *cptr(any ptr ptr,@q5) += OutPitch : *cptr(any ptr ptr,@q6) += OutPitch            
            radiusError += 2 * (y - x + 1)
          end if    
        wend
      end if
    end if
    #else
      puts "CIRCLE: 16bpp disabled"
    #endif
  case else
    puts "CIRCLE: other bpp not yet"
  end select
  
  #ifndef __FB_GFX_NO_GL_RENDER__
    if gfx.CurrentDriver = gfx.gdOpenGL then
      with *cptr(gfx.GlData ptr,@(TempHead->_Reserved(1)))
        if .Texture then .TexFlags or= gfx.tfNeedUpdate
      end with
    end if  
  #endif

  gfx.Locked -= 1: exit sub
  
end sub

UndefAll()
#undef FastCopy
#undef FastSet