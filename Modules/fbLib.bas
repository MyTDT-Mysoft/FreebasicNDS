#define ARM9

'#define __FB_GFX_NO_8BPP__
'#define __FB_GFX_NO_16BPP__
#define __FB_GFX_NO_OLD_HEADER__
'#define __FB_GFX_NO_GL_RENDER__
'#define __FB_GFX_SMOOTHSCREEN__
'#define __FB_GFX_LAZYTEXTURE__
'#define __FB_GFX_DIRECTSCREEN__
'#define __FB_CALLBACKS__
'#define __FB_FAT__
#ifndef __FB_NO_NITRO__
  #define __FB_NITRO__
#endif

#define rtUseASM
#undef __FB_WIN32__
#define __FB_LINUX__

#undef system
#define system fb_system

#define IsNot 0=
#define FBlib_Debug(_P...) 
'printf(_P)

type FBSTR as any ptr

#if 1
  #define DebugShowFunctionName() '
  #undef allocate
  #undef callocate
  #undef reallocate
  #undef deallocate
  #define allocate(_M) Malloc(_M)
  #define callocate(_M) calloc(_M,1)
  #define reallocate(_O,_M) realloc(_O,_M)
  #define deallocate(_O) free(_O)
#endif

#include once "crt.bi"
#include once "crt\unistd.bi"
#include once "fbgfx.bi"

#define _FB_Merge(_A,_B) _A##_B
#define _FB_ToStr(_T) #_T

#define _FB_Inline_(_N) _N##__ alias _FB_ToStr(_FB_Merge(_N,__FB__INLINE__))
#define _FB_Inline(_N) _N alias _FB_ToStr(_FB_Merge(_N,__FB__INLINE__))

'#define _FB_Inline_(_N) _N##__ alias _FB_ToStr(_FB_Merge(_N,__FB__STATIC__))
'#define _FB_Inline(_N) _N alias _FB_ToStr(_FB_Merge(_N,__FB__STATIC__))

#define _FB_Private(_N) _N alias _FB_ToStr(_FB_Merge(_N,__FB__STATIC__))
#define _FB_Private_(_N) _N##__ alias _FB_ToStr(_FB_Merge(_N,__FB__STATIC__))
'#define __priv private 'not working yet
#define __priv
#define __private private

#ifndef DebugShowFunctionName
  #include once "DebugControl.bas"
#endif
#include once "nds.bi"
#include once "hacks.bi"

#include once "sys/socket.bi"
#include once "netinet/in.bi"
#include once "netdb.bi"

rem ================ I2C (ARM7) ===============
  static shared as long fb_i2cCurrentDelay = &h180
  
  enum i2cDevices
    I2C_UNK3	= &h40
    I2C_PM		= &h4A
    I2C_CAM0	= &h7A
    I2C_CAM1	= &h78
    I2C_GPIO	= &h90
    I2C_UNK1	= &hA0
    I2C_UNK2	= &hE0    
  end enum
  
  '// Registers for Power Management (I2C_PM)
  const I2CREGPM_BATUNK    = &h00
  const I2CREGPM_PWRIF     = &h10
  const I2CREGPM_PWRCNT    = &h11
  const I2CREGPM_MMCPWR    = &h12
  const I2CREGPM_BATTERY   = &h20
  const I2CREGPM_CAMLED    = &h31
  const I2CREGPM_VOL       = &h40
  const I2CREGPM_RESETFLAG = &h70
  
  #define REG_I2CDATA	cast_vu8_ptr(&h4004500)
  #define REG_I2CCNT	cast_vu8_ptr(&h4004501)
  
  #define i2cWaitBusy() while(REG_I2CCNT and &h80) : wend
  
  __private sub fb_i2cDelay()
    swiDelay(fb_i2cCurrentDelay)
  end sub
  __private sub fb_i2cStop(arg0 as u8)
    if(fb_i2cCurrentDelay) then
      REG_I2CCNT = (arg0 shl 5) or &hC0
      fb_i2cDelay()
      REG_I2CCNT = &hC5
    else 
      REG_I2CCNT = (arg0 shl 5) or &hC1
    end if
  end sub
  __private function fb_i2cGetResult() as u8
    i2cWaitBusy()
    return (REG_I2CCNT shr 4) and &h01
  end function
  __private function fb_i2cSelectDevice(device as u8) as u8
    i2cWaitBusy()
    REG_I2CDATA = device : REG_I2CCNT = &hC2
    return fb_i2cGetResult()
  end function
  __private function fb_i2cSelectRegister(reg as u8) as u8
    fb_i2cDelay()
    REG_I2CDATA = reg
    REG_I2CCNT = &hC0
    return fb_i2cGetResult()
  end function
  __private function fb_i2cWriteRegister(device as ubyte,reg as ubyte, _data as ubyte) as long
    for i as long = 0 to 7
      if fb_i2cSelectDevice(device) andalso fb_i2cSelectRegister(reg) then
        fb_i2cDelay()
        REG_I2CDATA = _data
        fb_i2cStop(0)
        if fb_i2cGetResult() then return 1
      end if
      REG_I2CCNT = &hC5
    next i
  end function
  
rem ===========================================

#ifndef ino_t
  type ino_t as integer
  type dev_t as longint
  type mode_t as integer
  type off_t as integer
  type gid_t as integer
  type uid_t as integer
  type caddr_t as integer
  type nlink_t as uinteger
#endif

#include once "fat.bi"
#include once "filesystem.bi"
#include once "sys\dirent.bi"

#define fbReadOnly	&h01
#define fbHidden		&h02
#define fbSystem		&h04
#define fbDirectory	&h10
#define fbArchive		&h20
#define fbNormal		(fbReadOnly or fbArchive)

'dim shared as integer fbBufferIncrement
#macro CheckFifoFull()
while cast_vu32_ptr(&h4000600) and (1 shl 24)  
  DoNothing()
wend
#endmacro

type FBSTRING
  data as zstring ptr
  len as integer  
  size as integer
end type
type FBSTRINGTemp
  data   as zstring ptr
  len    as integer  
  size   as integer
  uCheck as integer
end type
type FB_ARRAYDIMTB 
	as integer iELEMENTS
  as integer iLBOUND
  as integer iUBOUND
end type
type FB_ARRAYDESC
  as any ptr pDATA
  as any ptr pPTR
  as integer iSIZE
  as integer iELEMENT_LEN
  as integer iDIMENSIONS
  as FB_ARRAYDIMTB tDIMTB(8-1)
end type
#ifdef __FB_CALLBACKS__
type CallBackStruct
  CallBack as any ptr
  cbData   as any ptr
end type
#endif

'scope
namespace gfx
  'GL_MAX_DEPTH
  const DepthFar  = -4095
  const DepthNext = 2  
  enum PutMethod
    pmTrans  = 0   'Put all pixels those of the transparent color
    pmPset   = 1   'Put a solid square of pixels
    pmPreset = 2   'Put a solid square of source inverse pixels
    pmAnd    = 3   'Perform an AND between the target/Source pixels
    pmOr     = 4   'Perform an OR between the target/Source pixels
    pmXor    = 5   'Perform an XOR between the target/Source pixels
    pmAlpha  = 6   'Perform alpha value is on source pixels
    pmAdd    = 7   'Perform a clipped ADD between the target/Source pixels
    pmCustom = 8   'Calls custom function for each pixel
    pmBlend  = 9   'Perform a fixed alpha blend on target/source pixels
  end enum
  enum TextureFlags
    tfAllocated = 1
    tfNeedUpdate = 2
    tfIsCompressed = 4
  end enum
  enum GfxDrivers
    gdOpenGL = -1
    gdDefault = 0
  end enum
  #macro GlDataEntries()
    uPrev    :24 as ulong
    TexWid   :4  as ubyte
    TexHei   :4  as ubyte    
    uNext    :24 as ulong
    TexFlags :8  as ubyte
    Texture      as short
    Reserved(11 to 12) as ubyte
  #endmacro
  type GlData field=1 'using 10 out of 12 bytes
    GlDataEntries()
  end type
  type ImageGL
    as ulong type,bpp,width,height,pitch
    GlDataEntries()
  end type
  type EngineFlags
    as integer NeedUpdate:1, UpdatePal:1, CanFlush: 1, WantFlush: 1, MustUpdate: 2
    as integer IsView    :1, IsRotated:1, IsDual  : 1, DualSwap  : 1
  end type
  type TexParms
    union
      type
        VramPtr     as ushort '0->512kb (div 8)
        RepeatS:1   as ushort 'clamp/repeat
        RepeatT:1   as ushort 'clamp/repeat
        FlipS:1     as ushort 'flip
        FlipT:1     as ushort 'flip
        TexWid:3    as ushort '(8 shl N)
        TexHei:3    as ushort '(8 shl N)
        TexFmt:3    as ushort 'fmt
        Trans0:1    as ushort 'color 0 is transparent
        CoordMode:2 as ushort 'transformation mode
      end type
      u32 as ulong 
    end union
  end type     
  
  #if (not defined(__FB_GFX_NO_GL_RENDER__)) and defined(__FB_GFX_LAZYTEXTURE__)
    static shared as ubyte g_TexImageWrite,g_TexImageRead
    static shared as ImageGL ptr g_pTex(255)
  #endif
  
  static shared as EngineFlags FG
  static shared as ushort ptr PalettePtr
  static shared as any ptr Scrptr,vramptr,vrambptr
  static shared as short Locked,CurX,CurY
  static shared as short GfxDriver,CurrentDriver=-32768
  static shared as fb.image ptr scr
  static shared as uinteger TextureColor=-1,TransColor,GfxSize,VertexCount
  static shared as integer bg,bg2
  static shared as integer Texture,Depth,FontTex,g_TextureMemoryUsage
  static shared as short IsView,ViewLT,ViewTP,ViewRT,ViewBT,ViewWid,ViewHei
  static shared as uinteger DefaultVGA(255) = { _
    &h000000,&h0000AA,&h00AA00,&h00AAAA,&hAA0000,&hAA00AA,&hAA5500,&hAAAAAA, _
    &h555555,&h5555FF,&h55FF55,&h55FFFF,&hFF5555,&hFF55FF,&hFFFF55,&hFFFFFF, _
    &h000000,&h141414,&h202020,&h2C2C2C,&h383838,&h444444,&h505050,&h616161, _
    &h717171,&h818181,&h919191,&hA1A1A1,&hB6B6B6,&hCACACA,&hE2E2E2,&hFFFFFF, _
    &h0000FF,&h4000FF,&h7D00FF,&hBE00FF,&hFF00FF,&hFF00BE,&hFF007D,&hFF0040, _
    &hFF0000,&hFF4000,&hFF7D00,&hFFBE00,&hFFFF00,&hBEFF00,&h7DFF00,&h40FF00, _
    &h00FF00,&h00FF40,&h00FF7D,&h00FFBE,&h00FFFF,&h00BEFF,&h007DFF,&h0040FF, _
    &h7D7DFF,&h9D7DFF,&hBE7DFF,&hDE7DFF,&hFF7DFF,&hFF7DDE,&hFF7DBE,&hFF7D9D, _
    &hFF7D7D,&hFF9D7D,&hFFBE7D,&hFFDE7D,&hFFFF7D,&hDEFF7D,&hBEFF7D,&h9DFF7D, _
    &h7DFF7D,&h7DFF9D,&h7DFFBE,&h7DFFDE,&h7DFFFF,&h7DDEFF,&h7DBEFF,&h7D9DFF, _
    &hB6B6FF,&hC6B6FF,&hDAB6FF,&hEAB6FF,&hFFB6FF,&hFFB6EA,&hFFB6DA,&hFFB6C6, _
    &hFFB6B6,&hFFC6B6,&hFFDAB6,&hFFEAB6,&hFFFFB6,&hEAFFB6,&hDAFFB6,&hC6FFB6, _
    &hB6FFB6,&hB6FFC6,&hB6FFDA,&hB6FFEA,&hB6FFFF,&hB6EAFF,&hB6DAFF,&hB6C6FF, _
    &h000071,&h1C0071,&h380071,&h550071,&h710071,&h710055,&h710038,&h71001C, _
    &h710000,&h711C00,&h713800,&h715500,&h717100,&h557100,&h387100,&h1C7100, _
    &h007100,&h00711C,&h007138,&h007155,&h007171,&h005571,&h003871,&h001C71, _
    &h383871,&h443871,&h553871,&h613871,&h713871,&h713861,&h713855,&h713844, _
    &h713838,&h714438,&h715538,&h716138,&h717138,&h617138,&h557138,&h447138, _
    &h387138,&h387144,&h387155,&h387161,&h387171,&h386171,&h385571,&h384471, _
    &h505071,&h595071,&h615071,&h695071,&h715071,&h715069,&h715061,&h715059, _
    &h715050,&h715950,&h716150,&h716950,&h717150,&h697150,&h617150,&h597150, _
    &h507150,&h507159,&h507161,&h507169,&h507171,&h506971,&h506171,&h505971, _
    &h000040,&h100040,&h200040,&h300040,&h400040,&h400030,&h400020,&h400010, _
    &h400000,&h401000,&h402000,&h403000,&h404000,&h304000,&h204000,&h104000, _
    &h004000,&h004010,&h004020,&h004030,&h004040,&h003040,&h002040,&h001040, _
    &h202040,&h282040,&h302040,&h382040,&h402040,&h402038,&h402030,&h402028, _
    &h402020,&h402820,&h403020,&h403820,&h404020,&h384020,&h304020,&h284020, _
    &h204020,&h204028,&h204030,&h204038,&h204040,&h203840,&h203040,&h202840, _
    &h2C2C40,&h302C40,&h342C40,&h3C2C40,&h402C40,&h402C3C,&h402C34,&h402C30, _
    &h402C2C,&h40302C,&h40342C,&h403C2C,&h40402C,&h3C402C,&h34402C,&h30402C, _
    &h2C402C,&h2C4030,&h2C4034,&h2C403C,&h2C4040,&h2C3C40,&h2C3440,&h2C3040, _
    &h000000,&h000000,&h000000,&h000000,&h000000,&h000000,&h000000,&h000000 }  
  '---------------------------------------------------------------------------

  const TransColor16 = 0
  '&b0111110000011111
  
end namespace
'end scope

'scope
namespace fb 
  enum              'Extra enumerated keys
    SC_BUTTONA = 128
    SC_BUTTONB = 127
    SC_BUTTONSELECT = 126
    SC_BUTTONSTART = 125
    SC_BUTTONRIGHT = 124
    SC_BUTTONLEFT = 123
    SC_BUTTONUP = 122
    SC_BUTTONDOWN = 121
    SC_BUTTONR = 120
    SC_BUTTONL = 119
    SC_BUTTONX = 118
    SC_BUTTONY = 117
    SC_BUTTONTOUCH = 116
    SC_BUTTONLID = 115
  end enum  
  enum ErrorNumbers 'Freebasic error numbers
    enNoError   ' 0  No error 
    enIllegal   ' 1  Illegal function call 
    enNotFound  ' 2  File not found signal 
    enIOerror   ' 3  File I/O error 
    enNoMemory  ' 4  Out of memory 
    enNoResume  ' 5  Illegal resume 
    enOffBounds ' 6  Out of bounds array access 
    enNullPtr   ' 7  Null Pointer Access 
    enDenied    ' 8  No privileges 
    enInterrupt ' 9  interrupted signal 
    enIllInt    '10  illegal instruction signal 
    enFPerror   '11  floating point error signal 
    enSegFault  '12  segmentation violation signal 
    enTerminate '13  Termination request signal 
    enAbnormal  '14  abnormal termination signal 
    enQuit      '15  quit request signal 
    enNoGosub   '16  return without gosub 
    enFileEnd   '17  end of file
  end enum
  enum OpenModes    'File Open Modes
    omBinary = 0    
    omRandom
    omInput
    omOutput
    omAppend
    omInvalid
  end enum
  enum AccessFlags  'File Open Access Flags
    afRead  = 1
    afWrite = 2
  end enum
  
  const MaxFbFiles = 127  
  'const TimerFreq = 1024
  const TimerFreq = (BUS_CLOCK/(65536*64))
  
  type fbfile       'Freebasic file handle
    phandle as file ptr    
    iFlags  as integer
    ilof    as longint
  end type
 
  static shared as zstring ptr pzEXEPATH
  static shared as short VsyncHappened,KeyboardOffset,KeyboardTempOffset
  static shared as byte ScreenEchoIsON,KeyboardIsON
  static shared as short InkeyBuff(0 to 255),CodeState(-128 to 127),ScanState(0 to 255)
  static shared as short InkeyWrite,InkeyRead
  static shared as short dsButtons,MouseX,MouseY
  static shared as integer InitialStack,ExecutingCallbacks 
  static shared as FBSTRING ptr TempString,InputString,ReturnString,DestroyTemp  
  static shared as fbfile fnum(1 to MaxFbFiles)
end namespace
'end scope

declare function fb_Color_ alias "fb_Color" (iFore as integer,iBack as integer,Unk0 as integer) as integer
declare function fb_GetX_ alias "fb_GetX" () as integer

#ifdef __FB_CALLBACKS__
dim shared as CallBackStruct cbVsync(7)
#endif
dim shared as any ptr fbLastConcat
dim shared as Keyboard ptr fbKeyboard
dim shared as printConsole ptr fbConsole
dim shared as PrintConsole fbTopConsole,fbBottomConsole
static shared as ulong fb_Ticks

#define IsTempString(_size) ((_size) and &h80000000)
#define ToTempString(_size) ((_size) or &h80000000)
#define TempStringSize(_size) ((_size) and (not (&h80000000)))

#macro WriteMask(IntMask) 
  if (IntMask) = 1 then 
    fputc(asc(!"\n"),f) 
  elseif (IntMask) = 2 then   
    dim as integer Amount = (((fbConsole->CursorX+1) or 7)+1)-fbConsole->CursorX
    fputs(((@"                 ")+17)-Amount,f)
  end if
#endmacro

static shared as any ptr TempStringList(63)
static shared as long TempStringCount = 0

#macro DestroyTempString(VarName)  
  if VarName then
    for N as long = TempStringCount-1 to 0 step -1
      if VarName = TempStringList(N) then
        var pTemp = VarName
        swap TempStringList(N), TempStringList(TempStringCount-1)
        TempStringCount -= 1        
        with *cptr(FBSTRING ptr,VarName)  
          '-1 = constant string , <-1 = temporary string
          var IsTemp = ((cuint(.size) and &hFFF00000) = &h80000000)
          if .Data then deallocate(.Data):.Data=0:.Len=0:.Size=0        
          if IsTemp then '.Size < -1 then     
            'puts("dealloc data")
            'if (cuint(VarName) and &h80000000) then          
            'for N as long = 0 to TempStringCount-1
              'if VarName = TempStringList(N) then
                'swap TempStringList(N), TempStringList(TempStringCount-1)
                'TempStringCount -= 1
                'printf(!"dealloc name %i(%i)\n",N,TempStringCount+1)
                Deallocate(VarName) : VarName = 0
                'exit for
              'end if
            'next N
            'end if        
          end if  
        end with
        'printf(!"Temp-: %p (%i)\n",pTemp,TempStringCount)
        'puts(__FUNCTION__)
      end if
    next N
  end if  
#endmacro
#macro CreateTempString(VarName) 
  if fb.DestroyTemp then
    DestroyTempString(fb.DestroyTemp)
  end if  
  VarName = allocate(sizeof(FBSTRINGTemp))
  TempStringList(TempStringCount)=VarName : TempStringCount += 1
  with *cptr(FBSTRING ptr,VarName)
    .data = 0 : .len  = 0 : .size = (1 shl 31)    
  end with  
  'puts(__FUNCTION__)
  'printf(!"Temp+: %p (%i)\n",VarName,TempStringCount)
#endmacro
#macro InitTempString(VarName)   
  TempStringList(TempStringCount)=VarName : TempStringCount += 1
#endmacro

enum NDS_FifoCommands
  fcNone
  fcRead  '(addr)
  fcWrite '(addr,value)
  fcExec  '(addr,parameter)
end enum

static shared as long NDS_PendingAck=0
const FIFO_ARM7Ex = FIFO_RSVD_01

__private function NDS_Arm7Ack() as ulong
  while NDS_PendingAck > 0      
    if fifoCheckValue32(FIFO_ARM7Ex) then 
      function = fifoGetValue32(FIFO_ARM7Ex) : NDS_PendingAck -= 1
    else
      swiIntrWait(1,IRQ_FIFO_NOT_EMPTY)
    end if
  wend
end function
__private function NDS_Arm7Read( pAddr as any ptr ) as ulong  
  fifoSendValue32(FIFO_ARM7Ex,fcRead)
  fifoSendValue32(FIFO_ARM7Ex,cuint(pAddr))
  NDS_PendingAck += 1
  return NDS_Arm7Ack()  
end function
__private sub NDS_Arm7Write( pAddr as any ptr , uValue as ulong , uAck as long = 1 )
  fifoSendValue32(FIFO_ARM7Ex,fcWrite)
  fifoSendValue32(FIFO_ARM7Ex,cuint(pAddr))
  fifoSendValue32(FIFO_ARM7Ex,uValue)
  NDS_PendingAck += 1
  if uAck then NDS_Arm7Ack()    
end sub
__private function NDS_Arm7Exec( pAddr as any ptr , pParm as any ptr , uAck as long = 1 ) as ulong
  fifoSendValue32(FIFO_ARM7Ex,fcExec)
  fifoSendValue32(FIFO_ARM7Ex,cuint(pAddr))
  fifoSendValue32(FIFO_ARM7Ex,cuint(pParm))  
  NDS_PendingAck += 1
  return iif(uAck,NDS_Arm7Ack(),-1)
end function

__private sub _fb_INT_UpdateScreen()
  #ifdef __FB_GFX_DIRECTSCREEN__
  exit sub
  #endif
  if DmaBusy(2) then exit sub
  var pSrc = gfx.ScrPtr, iSrcSz = gfx.gfxsize, pVram = gfx.vramptr
  if gfx.fg.isDual then
    if DmaBusy(3) then exit sub
    DC_FlushRange(pSrc, iSrcSz)
    var iSz = 192*gfx.scr->Pitch    
    dmaCopyWordsAsynch(3,pSrc,gfx.vrambptr,iSz)
    pSrc += (iSrcSz-iSz)
    dmaCopyWordsAsynch(2,pSrc,gfx.vramptr,iSz)    
    gfx.fg.NeedUpdate = 0: gfx.fg.MustUpdate=0
    #if 0
      if gfx.fg.DualSwap then
        gfx.fg.DualSwap = 0: pSrc += iSrcSz
        gfx.fg.NeedUpdate = 0: gfx.fg.MustUpdate=0
      else
        gfx.fg.DualSwap = 1: pVram = gfx.vrambptr
        gfx.fg.NeedUpdate = 1: gfx.fg.MustUpdate=2
      end if          
    #endif
  else
    gfx.fg.NeedUpdate = 0: gfx.fg.MustUpdate=0
    'DC_FlushRange(pSrc, iSrcSz)
    dmaCopyWordsAsynch(2,pSrc,pVram,iSrcSz)
  end if                
  
end sub

'------------------------------------------------------------------------------------------
dim shared fbTempCallBack as function (as any ptr) as integer
#ifdef __FB_CALLBACKS__
  __private sub fb_DoVsyncCallBack(iStart as long=0)
    for CNT as integer = iStart to iStart+3
      with cbVsync(CNT)
        if .CallBack then       
          fbTempCallBack = .CallBack      
          fbTempCallBack(.cbData)
        end if      
      end with
    next CNT  
  end sub
#endif

sub TimerInterrupt cdecl () export  
  fb_Ticks += 1
end sub

#if (not defined(__FB_GFX_NO_GL_RENDER__)) and defined(__FB_GFX_LAZYTEXTURE__)
  declare sub fbgl_UploadTexture( pTex as gfx.ImageGL ptr ) 
  sub vCountInterrupt cdecl () export  
    while gfx.g_TexImageRead <> gfx.g_TexImageWrite    
      fbgl_UploadTexture( gfx.g_pTex(gfx.g_TexImageRead) )
      gfx.g_TexImageRead = (gfx.g_TexImageRead+1) and 255    
      if cuint(REG_VCOUNT)>=(262-48) then exit while
    wend     
  end sub
#endif

sub vBlankInterrupt cdecl () export
  #define MasterInterrupt cast_vu32_ptr(&h04000208)
  
  'printf(!"%i\r",GFX_VCOUNT)
  
  var OldInts = MasterInterrupt
  MasterInterrupt or= 1   
  
    '#if 1
    'ScanKeys()
    #ifdef DebugMemoryUsage  
      static as integer OldUsage=-1,OldTmr,OldStack
      dim as integer NewStack = cuint(@NewStack)  
      OldTmr += 1
      if OldTmr > 120 orelse abs(fb.MemUsage-OldUsage)>512 orelse abs(NewStack-OldStack)>256 then
        'color 10: if pos() > 1 then printf !"\r\n"
        fb_Color_(10,-1,0) : if fb_GetX_() > 1 then printf !"\r\n"
        OldUsage = fb.MemUsage: OldTMR = 0
        if abs(NewStack-OldStack)>256 then
          OldStack = NewStack    
          printf(!"Mem=%i\x08kb(%i)Stk=%i\x08kb\r", _
          OldUsage\1024,fb.BlockCount,(fb.InitialStack-OldStack)\1024)
        else
          printf(!"Mem=%i \x08kb(%i)\r",OldUsage\1024,fb.BlockCount)
        end if
        color 15
      end if
    #endif  
  
    if gfx.scr->bpp = 1 andalso Gfx.fg.UpdatePal then 
      if gfx.CurrentDriver = gfx.gdOpenGL then
        #ifndef __FB_GFX_NO_GL_RENDER__
          #define FastButNoDesmume
          #ifdef FastButNoDesmume
            dc_flushrange(gfx.PalettePtr,256*2)    
            vramSetBankG(VRAM_F_LCD)
            dmacopy(gfx.PalettePtr,VRAM_G,256*2)
            vramSetBankG(VRAM_F_TEX_PALETTE_SLOT0)
          #else
            if Gfx.fg.UpdatePal then
              glBindTexture(GL_TEXTURE_2D, gfx.Texture)
              glColorTableEXT(0,0,256,0,0,gfx.PalettePtr)      
              Gfx.fg.UpdatePal = 0              
            end if
          #endif
          setBackdropColor( gfx.PalettePtr[0] )
        #endif
      elseif gfx.fg.IsDual andalso gfx.PalettePtr then
        dc_flushrange(gfx.PalettePtr,256*2)    
        dmacopy(gfx.PalettePtr,BG_PALETTE_SUB,256*2)
        setBackdropColorSub( gfx.PalettePtr[0] )
      end if
    end if
  #if 1 
    static as byte iSwap : iSwap xor= 1
    if gfx.vramptr andalso gfx.ScrPtr then
      #ifdef __FB_GFX_SMOOTHSCREEN__        
        if gfx.CurrentDriver = gfx.gdOpenGL then
          'cast_vu32_ptr(&h4000010) = rnd*511
        else
          bgSetScroll(gfx.bg, iSwap , 0) 
          if gfx.fg.IsDual then 
            bgSetScroll(gfx.bg2, iSwap , 0)
          end if
          bgUpdate()
        end if
      #endif
      if gfx.Locked then
        if gfx.fg.MustUpdate=0 then gfx.fg.MustUpdate=1
        gfx.fg.NeedUpdate = 1
      end if          
      if gfx.Locked=0 or gfx.fg.MustUpdate=2 then _fb_INT_UpdateScreen()      
    end if
    if gfx.CurrentDriver = gfx.gdOpenGL then
      if gfx.fg.WantFlush then
        CheckFifoFull(): gfx.VertexCount = cast_vu32_ptr(&h4000604) shr 16
        glflush(GL_TRANS_MANUALSORT)
        gfx.Depth = gfx.DepthFar : gfx.fg.CanFlush = 0 : gfx.fg.WantFlush = 0
      end if
      #ifdef __FB_GFX_SMOOTHSCREEN__      
      cast_vu32_ptr(&h4000010) = iSwap 'X offset
      #endif
    end if
    
    if fb.KeyboardIsON then
      KeyboardUpdate()
    end if
    fb.DsButtons = keysCurrent()
    'if fb.KeyboardIsON then fb.DsButtons and= (not (KEY_TOUCH))
    dim as integer PressNum = 0
    for CNT as integer = 12 to 0 step -1
      if (fb.DsButtons and (1 shl CNT)) then  PressNum = -128+CNT
    next CNT  
    for CNT as integer = -128 to (-128+12)
      if PressNum <> CNT then 
        fb.CodeState(CNT) = 0
      else
        if fb.CodeState(CNT) = 0 then
          fb.CodeState(CNT) = 128
        end if
      end if
    next CNT    
    for CNT as integer = -128 to 127
      if fb.CodeState(CNT) then
        if (fb.CodeState(CNT) and 128) then
          if ((fb.InkeyWrite+1) and 255) <> fb.InKeyRead then
            fb.InkeyBuff(fb.InkeyWrite) = CNT
            fb.InkeyWrite = (fb.InkeyWrite+1) and 255
          end if
        end if
        if fb.CodeState(CNT) = 128 then 
          fb.CodeState(CNT) = 1
        elseif fb.CodeState(CNT) >= 40 then
          fb.CodeState(CNT) xor= 128
        else
          fb.CodeState(CNT) += 1
        end if
      end if
    next CNT  
    if (fb.DsButtons and KEY_TOUCH) then
      dim as TouchPosition TempTouch = any
      TouchRead(@TempTouch)
      if gfx.fg.IsDual then         '256x384
        fb.MouseX = TempTouch.px
        fb.MouseY = TempTouch.py+((gfx.scr->Height) shr 1)
      elseif gfx.fg.IsRotated then  '192x256
        fb.MouseX = TempTouch.py
        fb.MouseY = ((gfx.scr->Height)-1)-TempTouch.px
      else                          '256x192
        if fb.KeyboardIsON=0 orelse TempTouch.py < (192-fb.KeyboardOffset) then
          fb.MouseX = (TempTouch.px*gfx.scr->Width)\256
          fb.MouseY = (TempTouch.py*gfx.scr->Height)\192
        end if
      end if
    end if
  #endif
  
  #ifdef __FB_CALLBACKS__
    fb_DoVsyncCallBack(4)    
  #endif
  
  MasterInterrupt = OldInts
  fb.VsyncHappened = 1  
  
end sub

#macro _FB_KeyTranslate_()
  select case key 
  case -15: exit sub
  case -17: key = -fb.SC_UP      : iScan = fb.SC_UP
  case -18: key = -fb.SC_RIGHT   : iScan = fb.SC_RIGHT
  case -19: key = -fb.SC_DOWN    : iScan = fb.SC_DOWN
  case -20: key = -fb.SC_LEFT    : iScan = fb.SC_LEFT
  case -23: key = 27             : iScan = fb.SC_ESCAPE
  case  10: key = 13             : iScan = fb.SC_ENTER
  case  -5                       : iScan = fb.SC_MENU
  case   8                       : iScan = fb.SC_BACKSPACE
  case   9                       : iScan = fb.SC_TAB
  case  32                       : iScan = fb.SC_SPACE
  case  cc("a"),cc("A")        : iScan = fb.SC_A
  case  cc("b"),cc("B")        : iScan = fb.SC_B
  case  cc("c"),cc("C")        : iScan = fb.SC_C
  case  cc("d"),cc("D")        : iScan = fb.SC_D
  case  cc("e"),cc("E")        : iScan = fb.SC_E
  case  cc("f"),cc("F")        : iScan = fb.SC_F
  case  cc("g"),cc("G")        : iScan = fb.SC_G
  case  cc("h"),cc("H")        : iScan = fb.SC_H
  case  cc("i"),cc("I")        : iScan = fb.SC_I
  case  cc("j"),cc("J")        : iScan = fb.SC_J
  case  cc("k"),cc("K")        : iScan = fb.SC_K
  case  cc("l"),cc("L")        : iScan = fb.SC_L
  case  cc("m"),cc("M")        : iScan = fb.SC_M
  case  cc("n"),cc("N")        : iScan = fb.SC_N
  case  cc("o"),cc("O")        : iScan = fb.SC_O
  case  cc("p"),cc("P")        : iScan = fb.SC_P
  case  cc("q"),cc("Q")        : iScan = fb.SC_Q
  case  cc("r"),cc("R")        : iScan = fb.SC_R
  case  cc("s"),cc("S")        : iScan = fb.SC_S
  case  cc("t"),cc("T")        : iScan = fb.SC_T 
  case  cc("u"),cc("U")        : iScan = fb.SC_U
  case  cc("v"),cc("V")        : iScan = fb.SC_V
  case  cc("w"),cc("W")        : iScan = fb.SC_W
  case  cc("x"),cc("X")        : iScan = fb.SC_X
  case  cc("y"),cc("Y")        : iScan = fb.SC_Y
  case  cc("z"),cc("Z")        : iScan = fb.SC_Z
  case  cc("!"),cc("1")        : iScan = fb.SC_1
  case  cc("@"),cc("2")        : iScan = fb.SC_2
  case  cc("#"),cc("3")        : iScan = fb.SC_3
  case  cc("$"),cc("4")        : iScan = fb.SC_4
  case  cc("%"),cc("5")        : iScan = fb.SC_5
  case  cc("^"),cc("6")        : iScan = fb.SC_6
  case  cc("&"),cc("7")        : iScan = fb.SC_7
  case  cc("*"),cc("8")        : iScan = fb.SC_8
  case  cc("("),cc("9")        : iScan = fb.SC_9
  case  cc(")"),cc("0")        : iScan = fb.SC_0
  case  cc("_"),cc("-")        : iScan = fb.SC_MINUS
  case  cc("+"),cc("=")        : iScan = fb.SC_EQUALS
  case  cc("<"),cc(",")        : iScan = fb.SC_COMMA
  case  cc(">"),cc(".")        : iScan = fb.SC_PERIOD
  case  cc("{"),cc("[")        : iScan = fb.SC_LEFTBRACKET
  case  cc("}"),cc("]")        : iScan = fb.SC_RIGHTBRACKET
  case  cc(":"),cc(";")        : iScan = fb.SC_SEMICOLON
  case  cc(""""),cc("'")       : iScan = fb.SC_QUOTE
  case  cc("`"),cc("~")        : iScan = fb.SC_TILDE
  case  cc("|"),cc("\")        : iScan = fb.SC_BACKSLASH
  case  cc("?"),cc("/")        : iScan = fb.SC_SLASH
  case -128 to -1                : iScan = -key
  end select  
#endmacro

#define cc(_C_) cint(asc(_C_))

__private sub OnKeyPressed cdecl (key as integer)
  'printf(!"%i\n",key)
  dim as integer iScan = key
  _FB_KeyTranslate_()  
  'print iScan,key,"pressed"  
  if key > cint(0) then fb.CodeState(key) = 128    
  fb.ScanState(abs(iScan)) = -1
  if fb.ScreenEchoIsON then
    if key > cint(0) then putchar(key)
  end if
end sub
__private sub OnKeyReleased cdecl (key as integer)
  dim as integer iScan = key
  _FB_KeyTranslate_()
  'print iScan,key,"released"  
  if key > 0 then fb.CodeState(key) = 0
  fb.ScanState(abs(iScan)) = 0
  fb.ScanState(14) = 0
end sub

'#undef memset
#define FastSet memset
#define FastSet16 fbFastSet16
'#define memset fbFastSet
'fbFastSet
__private function fbFastSet cdecl alias "memset" (pTarget as any ptr,iChar as integer,iSize as uinteger) as any ptr
  asm 
    #macro SetByte(LastByte)
    strb r1, [r0!],#1    
    #if LastByte<>-1
    subs r2, #1
    beq 9f
    #endif
    #endmacro    
    ldr r0,$pTarget
    ldr r1,$iChar
    ldr r2,$iSize    
    cmp r2, #0
    blt 9f
    cmp r2, #7
    bgt 1f
    SetByte(0)
    SetByte(1)
    SetByte(2)
    SetByte(3)
    SetByte(4)
    SetByte(5)
    SetByte(6)    
    SetByte(-1)
    
    1:
    orr r1, r1, LSL #8
    orr r1, r1, LSL #16
    tst r0, #3    
    beq 2f
    sub r2, #1
    strb r1, [r0!],#1
    tst r0, #3
    beq 2f
    sub r2, #1
    strb r1, [r0!],#1
    tst r0, #3
    beq 2f
    sub r2, #1
    strb r1, [r0!],#1
    
    2:
    subs r2, #16
    blt 3f
    mov r4,r1
    mov r5,r1
    mov r6,r1
    2:
    stmia r0 !,{r1,r4,r5,r6}
    subs r2, #16
    bge 2b
    
    3:
    adds r2, #16
    beq 9f
    subs r2, #4
    blt 4f
    3: str r1,[r0!],#4
    subs r2, #4
    bge 3b
    
    4:
    adds r2, #4
    beq 9f
    SetByte(0)
    SetByte(1)
    SetByte(2)
    SetByte(-1)
    
    9:
  end asm
  return 0
end function
__private function fbFastSet16 cdecl (pTarget as any ptr,iVal16 as integer,iSize as uinteger) as any ptr
  var pPtr = cptr(ushort ptr,pTarget) 'TODO: asm optimization
  for N as integer = 0 to iSize-1
    pPtr[N] = iVal16
  next N  
  return 0
end function

'#undef memcpy
'#define memcpy FastCopy
#define FastCopy memcpy
__private function memcpy cdecl alias "memcpy" (pTarget as any ptr,pSource as any ptr,iAmount as uinteger) as any ptr
  asm  
        #macro SaveByte(DoIt,iBits)
        #if DoIt=1
        lsr r5, iBits             'remove iBits bits
        #endif
        subs r2, #1               'Byte copied 
        strb r5, [r1!],#1         'Save Byte and increment
        beq 9f                    'Done? 
        #endmacro
        #macro CopyByte(LastByte)
        ldrb r3, [r0!],#1         'Load Byte and increment 
        #if LastByte=0
        subs r2, #1               'Byte copied 
        #endif
        strb r3, [r1!],#1         'Save Byte and increment
        #if LastByte=0
        beq 9f                    'Done? 
        #else
        b 9f
        #endif
        #endmacro
        'eors r0,r0
        '0: beq 0b
        ldr r0, $pSource          'r0 = Source 
        ldr r1, $pTarget          'r1 = Target 
        ldr r2, $iAmount          'r2 = Amount 
        cmp r2, #0                'Amount is valid? 
        ble 9f                    'no? then do nothing 
        cmp r2, #7                'Is Amount too small? 
        bhi 4f                    'No? then do BulkCopy 
        '-------- Remainder Bytes --------- 
        CopyByte(0)             '\
        CopyByte(0)             '|
        CopyByte(0)             '| copy up to 8 bytes
        CopyByte(0)             '| unrolled to not
        CopyByte(0)             '| waste even more
        CopyByte(0)             '| cpu time.
        CopyByte(0)             '|
        CopyByte(1)             '/
      4:and r4,r1,#3              'Align of Target on first bits 
        orr r4,r0,LSL #30         'Align of Source on last bits 
        and r0,#-4                'Force Align Down
        and r1,#-4                'Force Align Down
        ldr r3,8f                 'Get Table Address 
        ldr r15,[r3,r4,ROR #28]   'Jump to Ptr #r4 (28=-4=adj+*4) 
    '----------------------------------------------------------- 
    rem ===    Source      | Target Aligned ===
    00: subs r2, #32              '32 or More bytes left? 
        blo 4f                    'no? then start 16 each time 
        ldmia r0 !,{r3-r10}       'load 32 bytes and advance src 
        stmia r1 !,{r3-r10}       'save 32 bytes and advance tgt 
        b 00b                     'read more 32 bytes 
      4:adds r2, #32              'last was exactly 32? 
        beq 9f                    'yes? then it's done 
      5:subs r2, #16              '16 or More bytes left? 
        blo 4f                    'no? then start copying words 
        ldmia r0 !,{r3,r4,r5,r6}  'load 16 bytes and advance src 
        stmia r1 !,{r3,r4,r5,r6}  'save 16 bytes and advance tgt 
        subs r2, #16              '16 or more bytes left? 
        blo 4f                    'no? then start copying words 
        ldmia r0 !,{r6,r7,r8,r9}  'load 16 bytes and advance src 
        stmia r1 !,{r6,r7,r8,r9}  'save 16 bytes and advance tgt 
        b 5b                      'continue looping until less 16 
      4:adds r2, #16              'last was exactly 16? 
        beq 9f                    'then it's done 
      5:subs r2, #4               '4 or more bytes left? 
        blo 6f                    'no? then only bytes left 
        ldr r6,[r0!],#4           'read 4 bytes and advance src 
        str r6,[r1!],#4           'save 4 bytes and advance tgt 
        subs r2, #4               '4 or more bytes left? 
        blo 6f                    'no? then only bytes left 
        ldr r6,[r0!],#4           'read 4 bytes and advance src 
        str r6,[r1!],#4           'save 4 bytes and advance tgt 
        b 5b                      'continue looping until less 4 
      6:adds r2,#4                'last was exactly 4? 
        beq 9f                    'yes? then it's done
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(1)               'Copy last bytes (up to 3)
    rem ===    Source+1    | Target Aligned ===    
    01: subs r2, #16              '16 or more bytes left? 
        blo 4f                    'no? then start copying words 
        ldmia r0 !, {r5-r9}       'read 16 bytes+padd / adv src 
      5:mov r4, r5, LSR #8        '\ 
        orr r4, r6, LSL #24       '|  
        mov r5, r6, LSR #8        '|   
        orr r5, r7, LSL #24       '|    
        mov r6, r7, LSR #8        '| realign words 
        orr r6, r8, LSL #24       '|   
        mov r7, r8, LSR #8        '|  
        orr r7, r9, LSL #24       '/ 
        stmia r1 !,{r4-r7}        'save 16 bytes 
        mov r5,r9                 'padd becomes first word 
        subs r2, #16              '16 or more bytes left? 
        ldmplia r0 !,{r6-r9}      'yes? load more 16 bytes 
        bpl 5b                    'yes? continue copy 
        adds r2, #16              'was exactly 16?      -especial-\ 
        beq 9f                    'yes? then done       |_\case/_|| 
        subs r2, #4               '4 or mores bytes left?  \__/   | 
        blo 7f                    'no? then save bytes from padd  | 
        ldr r6, [r0!],#4          'padd is there so load 4 bytes  | 
        b 5f                      'and then continue word by word / 
      4:adds r2, #16              'was exactly 16? 
        beq 9f                    'yes? then done 
        subs r2, #4               '4 or more bytes left? 
        blo 6f                    'no? then copy bytes 
        ldmia r0 !,{r5,r6}        '8 bytes plus padding + adv src 
      5:mov r4, r5, LSR #8        'realign 
        orr r4, r6, LSL #24       'the word 
        str r4,[r1!],#4           'save word + adv tgt
        mov r5,r6                 'padd becomes word 
        subs r2, #4               '4 or more bytes left?
        ldrpl r6, [r0!],#4        'yes? load word + adv src 
        bpl 5b                    'yes? continue copy
      7:adds r2, #4               'was exactly 4?                \ 
        beq 9f                    'yes? then done                | 
        SaveByte(1,#8)            'save last bytes (up to 3)     | 
        SaveByte(1,#8)            'save last bytes (up to 3)     | 
        SaveByte(1,#8)            'save last bytes (up to 3)     / 
      6:adds r2,#4                'last was exactly 4? 
        beq 9f                    'yes? then it's done
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(1)               'Copy last bytes (up to 3)
    rem ===    Source+2    | Target Aligned ===    
    02: subs r2, #16              '16 or more bytes left? 
        blo 4f                    'no? then start copying words 
        ldmia r0 !, {r5-r9}       'read 16 bytes+padd / adv src 
      5:mov r4, r5, LSR #16       '\ 
        orr r4, r6, LSL #16       '|  
        mov r5, r6, LSR #16       '|   
        orr r5, r7, LSL #16       '|    
        mov r6, r7, LSR #16       '| realign words 
        orr r6, r8, LSL #16       '|   
        mov r7, r8, LSR #16       '|  
        orr r7, r9, LSL #16       '/ 
        stmia r1 !,{r4-r7}        'save 16 bytes 
        mov r5,r9                 'padd becomes first word 
        subs r2, #16              '16 or more bytes left? 
        ldmplia r0 !,{r6-r9}      'yes? load more 16 bytes 
        bpl 5b                    'yes? continue copy 
        adds r2, #16              'was exactly 16?      -especial-\ 
        beq 9f                    'yes? then done       |_\case/_|| 
        subs r2, #4               '4 or mores bytes left?  \__/   | 
        blo 7f                    'no? then save bytes from padd  | 
        ldr r6, [r0!],#4          'padd is there so load 4 bytes  | 
        b 5f                      'and then continue word by word / 
      4:adds r2, #16              'was exactly 16? 
        beq 9f                    'yes? then done 
        subs r2, #4               '4 or more bytes left? 
        blo 6f                    'no? then copy bytes 
        ldmia r0 !,{r5,r6}        '8 bytes plus padding + adv src 
      5:mov r4, r5, LSR #16       'realign 
        orr r4, r6, LSL #16       'the word 
        str r4,[r1!],#4           'save word + adv tgt
        mov r5,r6                 'padd becomes word 
        subs r2, #4               '4 or more bytes left?
        ldrpl r6, [r0!],#4        'yes? load word + adv src 
        bpl 5b                    'yes? continue copy
      7:adds r2, #4               'was exactly 4?                \ 
        beq 9f                    'yes? then done                | 
        SaveByte(1,#16)           'save last bytes (up to 3)     | 
        SaveByte(1,#8)            'save last bytes (up to 3)     | 
        ldrb r5, [r0]             'read last byte                | 
        SaveByte(0,#0)            'save last bytes (up to 3)     / 
      6:adds r2,#4                'last was exactly 4? 
        beq 9f                    'yes? then it's done
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(1)               'Copy last bytes (up to 3)
    rem ===    Source+3    | Target Aligned ===    
    03: subs r2, #16              '16 or more bytes left? 
        blo 4f                    'no? then start copying words 
        ldmia r0 !, {r5-r9}       'read 16 bytes+padd / adv src 
      5:mov r4, r5, LSR #24       '\ 
        orr r4, r6, LSL #8        '|  
        mov r5, r6, LSR #24       '|   
        orr r5, r7, LSL #8        '|    
        mov r6, r7, LSR #24       '| realign words 
        orr r6, r8, LSL #8        '|   
        mov r7, r8, LSR #24       '|  
        orr r7, r9, LSL #8        '/ 
        stmia r1 !,{r4-r7}        'save 16 bytes 
        mov r5,r9                 'padd becomes first word 
        subs r2, #16              '16 or more bytes left? 
        ldmplia r0 !,{r6-r9}      'yes? load more 16 bytes 
        bpl 5b                    'yes? continue copy 
        adds r2, #16              'was exactly 16?      -especial-\ 
        beq 9f                    'yes? then done       |_\case/_|| 
        subs r2, #4               '4 or mores bytes left?  \__/   | 
        blo 7f                    'no? then save bytes from padd  | 
        ldr r6, [r0!],#4          'padd is there so load 4 bytes  | 
        b 5f                      'and then continue word by word / 
      4:adds r2, #16              'was exactly 16? 
        beq 9f                    'yes? then done 
        subs r2, #4               '4 or more bytes left? 
        blo 6f                    'no? then copy bytes 
        ldmia r0 !,{r5,r6}        '8 bytes plus padding + adv src 
      5:mov r4, r5, LSR #24       'realign 
        orr r4, r6, LSL #8        'the word 
        str r4,[r1!],#4           'save word + adv tgt
        mov r5,r6                 'padd becomes word 
        subs r2, #4               '4 or more bytes left?
        ldrpl r6, [r0!],#4        'yes? load word + adv src 
        bpl 5b                    'yes? continue copy
      7:adds r2, #4               'was exactly 4?                \ 
        beq 9f                    'yes? then done                | 
        SaveByte(1,#24)           'save last bytes (up to 3)     | 
        ldr r5,[r0]               'more 2 bytes                  | 
        SaveByte(0,#0)            'save last bytes (up to 3)     | 
        SaveByte(1,#8)            'save last bytes (up to 3)     / 
      6:adds r2,#4                'last was exactly 4? 
        beq 9f                    'yes? then it's done
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(0)               'Copy last bytes (up to 3)
        CopyByte(1)               'Copy last bytes (up to 3)
    rem === Source Aligned | Target+1 ===    
    10: ldr r4, [r0]              '\
        ldr r5, [r1]              '|
        and r5, #0xFF             '| copy 3 bytes, so...
        sub r2, #3                '| Align Target and
        orr r5, r4, LSL #8        '| Source becomes +3
        str r5, [r1!],#4          '|
        b 03b                     '/
    rem ===    Source+1    | Target+1 ===    
    11: ldr r4, [r0,#1]           '\
        ldr r5, [r1]              '|
        and r5, #0xFF             '| copy 3 bytes, so...
        sub r2, #3                '| Align Target and
        orr r5, r4, LSL #8        '| Align Source
        str r5, [r1!],#4          '|
        add r0, #4                '|
        b 00b                     '/
    rem ===    Source+2    | Target+1 ===    
    12: ldrh r4, [r0,#2]          '\
        ldrb r6, [r0,#4]!         '|
        ldr r5, [r1]              '|
        and r5, #0xFF             '| copy 3 bytes, so...
        sub r2, #3                '| Align Target and
        orr r4, r6, LSL #16       '| Source+1
        orr r5, r4, LSL #8        '|
        str r5, [r1!],#4          '|
        b 01b                     '/
    rem ===    Source+3    | Target+1 ===    
    13: ldrb r4, [r0,#3]          '\
        ldrh r6, [r0,#4]!         '|
        ldr r5, [r1]              '|
        and r5, #0xFF             '| copy 3 bytes, so...
        sub r2, #3                '| Align Target and
        orr r4, r6, LSL #8        '| Source+2
        orr r5, r4, LSL #8        '|
        str r5, [r1!],#4          '|
        b 02b                     '/
    rem ----------------------------------------------------------
    8:  .word 8f      '-\--- Begin of The Table --- 
      8:.word 00b     ' | Src=Aligned | Dst=Aligned 
        .word 01b     ' | Src=OffBy 1 | Dst=Aligned 
        .word 02b     ' | Src=OffBy 2 | Dst=Aligned 
        .word 03b     ' | Src=OffBy 3 | Dst=Aligned 
        .word 10b     ' | Src=Aligned | Dst=OffBy 1 
        .word 11b     ' | Src=OffBy 1 | Dst=OffBy 1 
        .word 12b     ' | Src=OffBy 2 | Dst=OffBy 1 
        .word 13b     ' | Src=OffBy 3 | Dst=OffBy 1 
        .word 20f     ' | Src=Aligned | Dst=OffBy 2 
        .word 21f     ' | Src=OffBy 1 | Dst=OffBy 2 
        .word 22f     ' | Src=OffBy 2 | Dst=OffBy 2 
        .word 23f     ' | Src=OffBy 3 | Dst=OffBy 2 
        .word 30f     ' | Src=Aligned | Dst=OffBy 3 
        .word 31f     ' | Src=OffBy 1 | Dst=OffBy 3 
        .word 32f     ' | Src=OffBy 2 | Dst=OffBy 3 
        .word 33f     ' | Src=OffBy 3 | Dst=OffBy 3 
        '-----------------------------------------------------------
    rem === Source Aligned | Target+2 ===    
    20: ldrh r4, [r0]             '\                    
        sub r2, #2                '| copy 2 bytes, so... 
        strh r4, [r1,#2]          '| Align Target and     
        add r1,#4                 '| Source becomes +2   
        b 02b                     '/                    
    rem ===    Source+1    | Target+2 ===    
    21: ldr r4, [r0,#1]           '\                    
        sub r2, #2                '| copy 2 bytes, so... 
        strh r4, [r1,#2]          '| Align Target and     
        add r1,#4                 '| Source becomes +3   
        b 03b                     '/                    
    rem ===    Source+2    | Target+2 ===    
    22: ldrh r4, [r0,#2]          '\                    
        sub r2, #2                '| copy 2 bytes, so... 
        strh r4, [r1,#2]          '| Align Target and     
        add r1,#4                 '| Align Source        
        add r0,#4                 '|                    
        b 00b                     '/
    rem ===    Source+3    | Target+2 ===    
    23: ldrb r4, [r0,#3]          '\                   
        ldrb r5, [r0,#4]!         '|                    
        sub r2, #2                '| copy 2 bytes, so... 
        orr r4, r5, LSL #8        '| Align Target and     
        strh r4, [r1,#2]          '| Source becomes +1   
        add r1,#4                 '|                    
        b 01b                     '/                   
    rem === Source Aligned | Target+3 ===    
    30: ldrb r4, [r0]             '\                    
        sub r2, #1                '| copy 1 bytes, so... 
        strb r4, [r1,#3]          '| Align Target and     
        add r1,#4                 '| Source becomes +1   
        b 01b                     '/                    
    rem ===    Source+1    | Target+3 ===    
    31: ldrb r4, [r0,#1]          '\                    
        sub r2, #1                '| copy 1 bytes, so... 
        strb r4, [r1,#3]          '| Align Target and     
        add r1,#4                 '| Source becomes +2   
        b 02b                     '/                    
    rem ===    Source+2    | Target+3 ===    
    32: ldrb r4, [r0,#2]          '\                    
        sub r2, #1                '| copy 1 bytes, so... 
        strb r4, [r1,#3]          '| Align Target and     
        add r1,#4                 '| Source becomes +3   
        b 03b                     '/                    
    rem ===    Source+3    | Target+3 ===    
    33: ldrb r4, [r0,#3]          '\                    
        sub r2, #1                '| copy 1 bytes, so... 
        strb r4, [r1,#3]          '| Align Target and     
        add r1,#4                 '| Align Source        
        add r0,#4                 '|                    
        b 00b                     '/                   
    9: '-----------------------------------------------------------
  end asm
  return 0
end function
declare function fbFastCopy cdecl alias "memcpy" (pTarget as any ptr,pSource as any ptr,iAmount as uinteger) as any ptr

sub _FB_Private_(fb_GfxFlip) (iUnk0 as integer,iUnk1 as integer)
  #ifndef __FB_GFX_NO_GL_RENDER__
    #if 0
      gfx.fg.WantFlush = 1
    #else
      if gfx.CurrentDriver = gfx.gdOpenGL then
        CheckFifoFull(): gfx.VertexCount = cast_vu32_ptr(&h4000604) shr 16
        gfx.fg.CanFlush = 0: glflush(GL_TRANS_MANUALSORT): gfx.Depth = gfx.DepthFar
      end if
    #endif
  #endif  
  
  #if 0
    #ifdef __FB_CALLBACKS__
      for CNT as integer = 0 to 3
        with cbVsync(CNT)
          if .CallBack then
            fbTempCallBack = .CallBack
            fbTempCallBack(.cbData)
          end if      
        end with
      next CNT
    #endif
  #endif
  
  exit sub
  iUnk0 = iUnk0 'unused
  iUnk1 = iUnk1 'unused
end sub
'_FB_Private_(
#define fb_GfxWaitVSync_ fb_GfxWaitVSync__
function _FB_Private_(fb_GfxWaitVSync) () as integer  
 
  dim as integer Happened = any
  fb.VsyncHappened = 0
  
  #ifdef __FB_CALLBACKS__
  do 
    Happened =0         
    for CNT as integer = 0 to 3
      with cbVsync(CNT)        
        if .CallBack then
          Happened = 1          
          fbTempCallBack = .CallBack
          fbTempCallBack(.cbData)
        end if
        if fb.VsyncHappened then return 0
      end with
    next CNT    
    if Happened = 0 then exit do
    exit do
  loop
  #endif
  swiWaitForVBlank():return 0
end function
#ifdef __FB_CALLBACKS__
  __private function fb_AddVsyncCallBack(pFunction as any ptr, pData as any ptr,WhileRest as integer=true) as integer
    dim as integer Start= 0
    if WhileRest=0 then Start=4    
    if pFunction = 0 then return 0
    for CNT as integer = Start to Start+3
      with cbVsync(CNT)
        if .CallBack = 0 then
          .cbData = pData
          .CallBack = pFunction
          return CNT+1
        end if
      end with
    next CNT
  end function
  __private function fb_RemoveVsyncCallBack(pFunction as any ptr) as integer
    if pFunction=0 then return 0
    for CNT as integer = 0 to 7
      with cbVsync(CNT)
        if .Callback = pFunction then 
          .CallBack = 0: .cbData = 0
          return CNT+1
        end if
      end with
    next CNT
  end function
#endif
'------------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_Timer) () as double
  'return fb_Ticks/fb.TimerFreq 
  'return cast_vu64_ptr(@fb_Ticks)/fb.TimerFreq 
  static as double dTime
  var dNewTime = (cast_vu32_ptr(@fb_Ticks)/fb.TimerFreq)+(timerTick(0))/(65536*fb.TimerFreq)
  if dNewTime < dTime then dNewTime = dTime else dTime = dNewTime
  return dNewTime
end function
__priv function _FB_Private_(fb_SleepEx) (Amount as integer,MustWait as integer) as integer  
  static as uinteger TempKeys = any
  if Amount < 0 then
    scanKeys(): TempKeys = keysCurrent()
    do
      scanKeys()
      dim as uinteger CheckKeys = keysDownRepeat()
      if CheckKeys < TempKeys then TempKeys = CheckKeys
      if CheckKeys > TempKeys then return 0
      fb_GfxWaitVSync_()
    loop
  elseif Amount=0 then
    var hBlankEnabled = (REG_IE and IRQ_HBLANK)
    if hBlankEnabled=0 then irqEnable(IRQ_HBLANK)
    swiIntrWait(1,IRQ_ALL)
    if hBlankEnabled=0 then irqDisable(IRQ_HBLANK)
  else
    var dAfter = timer+Amount/1000    
    if MustWait=0 then scanKeys(): TempKeys = keysHeld()  
    while (dAfter-timer) > (1/60)
      fb_GfxWaitVSync_()
      if MustWait=0 then
        scanKeys()
        dim as uinteger CheckKeys = keysDownRepeat()
        if CheckKeys < TempKeys then TempKeys = CheckKeys
        if CheckKeys > TempKeys then return 0
      end if    
    wend
    var hBlankEnabled = (REG_IE and IRQ_HBLANK)
    if hBlankEnabled=0 then irqEnable(IRQ_HBLANK)
    while dAfter > timer      
      swiIntrWait(1,IRQ_ALL)
    wend
    if hBlankEnabled=0 then irqDisable(IRQ_HBLANK)
    return 1
  end if
end function
sub _FB_Inline_(fb_Sleep) (Amount as integer)
  fb_SleepEx__(Amount,0)
end sub
sub _FB_Inline_(fb_Beep) ()
  dim as integer BeepChan = SoundPlayPSG(3,3520,127,64)
  sleep 250,1:SoundKill(BeepChan)
end sub

__priv sub _FB_Private_(fb_ConsoleView) (iStart as integer,iStop as integer)
  if iStart < 1 then exit sub
  if iStop < iStart then exit sub
  if iStop > 24 then exit sub
  consoleSetWindow(fbConsole,0,iStart-1,32,(iStop-iStart)+1)
end sub

function _FB_Inline_(fb_Width) ( iWid as integer, iHei as integer ) as long
  if iWid=1 andalso iHei=1 then return &h2018
  iWid=iHei
  return &h2018
end function
'------------------------------------------------------------------------------------------
__priv sub _FB_Private_(fb_PrintVoid) (fnum as integer,mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout
  WriteMask(mask)
end sub
__priv sub _FB_Private_(fb_PrintString) (fnum as integer,FBs as any ptr,mask as integer )
  DebugShowFunctionName()
  #define s cptr(FBSTRING ptr,FBs)    
  'printf(!"[print %08X , %i]\n",cint(s->Data),s->len)  
  dim as file ptr f
  if fnum = 0 then f = stdout	
  #if 1 'Workaround
  for CNT as integer = 0 to (s->len)-1
    dim as integer ichar = cptr(ubyte ptr,s->data)[CNT]
    if ichar=0 then ichar=32
    fputc(ichar,f)
  next CNT  
  #else
  fwrite(s->data,1,s->len,f)
  #endif
  WriteMask(mask)
  DestroyTempString(FBs)
end sub
sub _FB_Inline_(fb_PrintByte) (fnum as integer,Number as byte,Mask as integer)
  dim as file ptr f  
  dim as uinteger Temp = number
  if Temp >= 128 then Temp -= 256
  if fnum = 0 then f = stdout	
  printf("% i",Temp)
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintUByte) (fnum as integer,Number as ubyte,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("%u",Number)
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintShort) (fnum as integer,Number as short,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("% i",Number)
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintUShort) (fnum as integer,Number as ushort,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("%u",Number)
  WriteMask(mask)
end sub
__priv sub _FB_Private_(fb_PrintInt) (fnum as integer,Number as integer,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("% i",Number)
  WriteMask(mask)
end sub
__priv sub _FB_Private_(fb_PrintUInt) (fnum as integer,Number as uinteger,Mask as integer)  
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("%u",Number)
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintLongint) (fnum as integer,Number as longint,Mask as integer)  
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("% 1.0f",cast(double,Number))
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintULongint) (fnum as integer,Number as ulongint,Mask as integer)  
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("%1.0f",cast(double,Number))
  WriteMask(mask)
end sub
__priv sub _FB_Private_(fb_PrintDouble) (fnum as integer,Number as double,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("% .15g",Number)
  WriteMask(mask)
end sub
sub _FB_Inline_(fb_PrintSingle) (fnum as integer,Number as single,Mask as integer)
  dim as file ptr f
  if fnum = 0 then f = stdout	
  printf("% .7g",Number)
  WriteMask(mask)
end sub
'------------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_StrAllocTempDescZEx) (s as zstring ptr,s_len as integer) as FBSTR
  DebugShowFunctionName()
  'printf(!"[alloc %08X , %i]\n",cint(s),s_len)
  #define result fb.TempString
  CreateTempString(result)
  result->data = reallocate(result->data,( s_len + 1 ))
  FastCopy( result->data, s, s_len )
  result->data[s_len] = 0
  result->len = s_len
  result->size or= (s_len + 1)
  #ifdef DebugShowSize
  printf(!"StrAllocTempDescZEx\n Size=%i\n",result->size): sleep DebugDelay,1
  #endif
  return result
end function
function _FB_Inline_(fb_StrAllocTempDescZ) (s as zstring ptr) as FBSTR
  return fb_StrAllocTempDescZEx__(s,strlen(s))
end function
function _FB_Inline_(fb_StrAllocTempResult) ( pFromString as any ptr ) as FBSTR
  #define s cptr(FBSTRING ptr,pFromString)    
  CreateTempString( fb.ReturnString )
  if pFromString andalso s->data then
    with *fb.ReturnString
      .data = allocate( s->size )
      .len = s->len
      .size or= TempStringSize(s->size)
      memcpy(.data,s->data,TempStringSize(.size))
    end with
  end if
  return fb.ReturnString
end function
'------------------------------------------------------------------------------------------
function _FB_Inline_(fb_ByteToStr) (Number as byte) as FBSTR
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sprintf(fb.TempString->data,"%i",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_UByteToStr) (Number as ubyte) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sprintf(fb.TempString->data,"%u",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_ShortToStr) (Number as short) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sprintf(fb.TempString->data,"%i",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_UShortToStr) (Number as ushort) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sprintf(fb.TempString->data,"%u",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_IntToStr) (Number as integer) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%i",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_UIntToStr) (Number as uinteger) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%u",Number)	
  return fb.TempString  
end function
function _FB_Inline_(fb_LongintToStr) (Number as longint) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(20)
  fb.TempString->size or= 20
  fb.TempString->len = sprintf(fb.TempString->data,"%Li",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_ULongintToStr) (Number as ulongint) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(20)
  fb.TempString->size or= 20
  fb.TempString->len = sprintf(fb.TempString->data,"%Lu",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_FloatToStr) (Number as single) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%.7g",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_DoubleToStr) (Number as double) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(20)
  fb.TempString->size or= 20
  fb.TempString->len = sprintf(fb.TempString->data,"%.15g",Number)	
  return fb.TempString
end function
'------------------------------------------------------------------------------------------
function _FB_Inline(fbHexToInt) (x as byte ptr,xSize as integer) as integer  
  dim as uinteger Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as uinteger OldInt = Integral
    select case Char
    case asc("0") to asc("9")
      Integral = (Integral shl 4)+(Char-asc("0"))
    case asc("A") to asc("F")
      Integral = (Integral shl 4)+(Char-(asc("A")-10))
    case asc("a") to asc("f")
      Integral = (Integral shl 4)+(Char-(asc("a")-10))
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
function _FB_Inline(fbOctToInt) (x as byte ptr,xSize as integer) as integer  
  dim as uinteger Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as uinteger OldInt = Integral
    select case Char
    case asc("0") to asc("7")
      Integral = (Integral shl 3)+(Char-asc("0"))    
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
function _FB_Inline(fbBinToInt) (x as byte ptr,xSize as integer) as integer  
  dim as uinteger Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as uinteger OldInt = Integral
    select case Char
    case asc("0") to asc("1")
      Integral = (Integral shl 1)+(Char-asc("0"))    
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
function _FB_Inline(fbHexToLng) (x as byte ptr,xSize as integer) as longint
  dim as ulongint Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as ulongint OldInt = Integral
    select case Char
    case asc("0") to asc("9")
      Integral = (Integral shl 4)+(Char-asc("0"))
    case asc("A") to asc("F")
      Integral = (Integral shl 4)+(Char-(asc("A")-10))
    case asc("a") to asc("f")
      Integral = (Integral shl 4)+(Char-(asc("a")-10))
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
function _FB_Inline(fbOctToLng) (x as byte ptr,xSize as integer) as longint
  dim as ulongint Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as ulongint OldInt = Integral
    select case Char
    case asc("0") to asc("7")
      Integral = (Integral shl 3)+(Char-asc("0"))    
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
function _FB_Inline(fbBinToLng) (x as byte ptr,xSize as integer) as longint
  dim as ulongint Integral = 0
  for CNT as integer = 0 to xSize-1
    dim as uinteger Char = x[CNT]  
    dim as ulongint OldInt = Integral
    select case Char
    case asc("0") to asc("1")
      Integral = (Integral shl 1)+(Char-asc("0"))    
    case else
      exit for
    end select    
    if Integral < OldInt then return -1
  next CNT
  return Integral
end function
__priv function _FB_Private_(fb_VAL) (fbQueryString as any ptr) as double
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as short NoSpace,HaveDot,HaveSign,Sign
  dim as short DeciCount,ExpoentSign,Done
  dim as longint Integral,Decimal,Expoent
  dim as double Result
  dim as byte ptr x = s.Data
  
  static Init as short,DeciNum(15) as double
  if Init = 0 then
    Init = 1: DeciNum(0) = 1
    for CNT as integer = 1 to 15
      DeciNum(CNT)=DeciNum(CNT-1)*.1
    next CNT
  end if
  
  for CNT as integer = 0 to s.Len-1
    dim as uinteger Char = x[CNT]  
    select case Char
    case asc("0") to asc("9")
      if HaveDot=0 then
        Integral = (Integral*10)+(Char-asc("0"))
      elseif HaveDot=1 then        
        Decimal = (Decimal*10)+(Char-asc("0")): DeciCount += 1
      else
        Expoent = (Expoent*10)+(Char-asc("0"))
      end if
      NoSpace = 1
    case asc("-")
      if HaveSign then exit for
      if HaveDot <> 2 and NoSpace then exit for
      NoSpace = 1: if HaveDot=2 then ExpoentSign=1 else Sign = 1
    case asc("+")
      if HaveSign then exit for
      if HaveDot <> 2 and NoSpace then exit for
      NoSpace = 1: if HaveDot=2 then ExpoentSign=0 else Sign = 0
    case asc(" ")
      if NoSpace then exit for
    case asc(".")
      if HaveDot then exit for
      NoSpace=1:HaveDot=1
    case asc("d"),asc("D"),asc("e"),asc("E")
      if HaveDot = 2 then exit for
      HaveDot=2: HaveSign = 0  
    case asc("&")
      select case cuint(x[CNT+1])
      case asc("h"),asc("H")
        function = fbHexToLng(x+CNT+2,s.Len-(CNT+2))
        Done = 1
      case asc("b"),asc("B")
        function = fbBinToLng(x+CNT+2,s.Len-(CNT+2))
        Done = 1
      case asc("o"),asc("O")
        function = fbOctToLng(x+CNT+2,s.Len-(CNT+2))
        Done = 1
      end select
      if Done then
        DestroyTempString(fbQueryString)
        exit function
      else
        exit for
      end if
    case else
      exit for
    end select
  next CNT
  Result = Integral+(Decimal*DeciNum(DeciCount))
  'Decimal += Integral
  if ExpoentSign then Expoent = -Expoent
  if Expoent then Result *= (10^Expoent)
  if Sign then Result = -Result
  DestroyTempString(fbQueryString)
  return Result
end function
__priv function _FB_Private_(fb_VALINT) (fbQueryString as any ptr) as integer
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as uinteger NoSpace,Sign,Integral,Done
  dim as byte ptr x = s.Data
  for CNT as integer = 0 to s.Len-1
    dim as uinteger Char = x[CNT]  
    select case Char
    case asc("0") to asc("9")  
      dim as uinteger OldInt = Integral
      Integral = Integral*10+(Char-asc("0"))
      if Integral < OldInt then return -1
      NoSpace = 1
    case asc("-")
      if NoSpace then exit for      
      NoSpace = 1:Sign = 1
    case asc("+")
      if NoSpace then exit for      
      NoSpace = 1: Sign = 0
    case asc(" ")
      if NoSpace then exit for    
    case asc("&")      
      select case cuint(x[CNT+1])
      case asc("h"),asc("H")
        function = fbHexToInt(x+CNT+2,s.Len-(CNT+2))
        done = 1
      case asc("b"),asc("B")
        function = fbBinToInt(x+CNT+2,s.Len-(CNT+2))
        done = 1
      case asc("o"),asc("O")
        function = fbOctToInt(x+CNT+2,s.Len-(CNT+2))
        done = 1
      end select
      if Done then
        DestroyTempString(fbQueryString)
        exit function
      else
        exit for
      end if
      
    case else
      exit for
    end select
  next CNT  
  if Sign then Integral = -Integral
  DestroyTempString(fbQueryString)
  return Integral  
end function
__priv function _FB_Private_(fb_VALLNG) (fbQueryString as any ptr) as longint
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as uinteger NoSpace,Sign,Done
  dim as ulongint Integral
  dim as byte ptr x = s.Data
  for CNT as integer = 0 to s.Len-1
    dim as uinteger Char = x[CNT]  
    select case Char
    case asc("0") to asc("9")  
      dim as ulongint OldInt = Integral
      Integral = Integral*10+(Char-asc("0"))
      if Integral < OldInt then return -1
      NoSpace = 1
    case asc("-")
      if NoSpace then exit for      
      NoSpace = 1:Sign = 1
    case asc("+")
      if NoSpace then exit for      
      NoSpace = 1: Sign = 0
    case asc(" ")
      if NoSpace then exit for    
    case asc("&")
      select case cuint(x[CNT+1])
      case asc("h"),asc("H")
        function = fbHexToLng(x+CNT+2,s.Len-(CNT+2))        
        done =1
      case asc("b"),asc("B")
        function = fbBinToLng(x+CNT+2,s.Len-(CNT+2))
        done =1
      case asc("o"),asc("O")
        function = fbOctToLng(x+CNT+2,s.Len-(CNT+2))
        done =1
      end select
      if Done then
        DestroyTempString(fbQueryString)
        exit function
      else
        exit for
      end if
      
    case else
      exit for
    end select
  next CNT  
  if Sign then Integral = -Integral
  DestroyTempString(fbQueryString)
  return Integral  
end function
'------------------------------------------------------------------------------------------
function _FB_Inline_(fb_FIXSingle) (Number0 as single) as single    
  dim as single Number = Number0
  'const FracBits = 23, RestBits = (sizeof(Number)*8)-FracBits  
  '#define Num (((*cptr(uinteger ptr,@Number) shl 1) shr (FracBits+1))-(127-RestBits))
  '*cptr(uinteger ptr,@Number) and= (not (cuint(-1) shr Num))
  'return Number
  return cint(Number)
end function
function _FB_Inline_(fb_FIXDouble) (Number as double) as double  
  'const FracBits = 52, RestBits = (sizeof(Number)*8)-FracBits  
  '#define Num ((culngint(*cptr(ulongint ptr,@Number) shl 1) shr (FracBits+1))-(1023-RestBits))
  '*cptr(ulongint ptr,@Number) and= (not ((-1ull) shr Num))
  'return Number
  return cint(Number)
end function
function _FB_Inline_(fb_SGNi) (iNumber as integer) as integer
  if iNumber > 0 then return 1
  if iNumber < 0 then return -1
  return 0
end function
function _FB_Inline_(fb_SGNl) (iNumber as long) as long
  if iNumber > 0 then return 1
  if iNumber < 0 then return -1
  return 0
end function
function _FB_Inline_(fb_SGNs) (iNumber as short) as integer
  if iNumber > 0 then return 1
  if iNumber < 0 then return -1
  return 0
end function
function _FB_Inline_(fb_SGNSingle) (sNumber as single) as integer  
  if sNumber > 0 then return 1
  if sNumber < 0 then return -1
  return 0
end function
function _FB_Inline_(fb_SGNDouble) (dNumber as double) as integer
  if dNumber > 0 then return 1
  if dNumber < 0 then return -1
  return 0
end function
'------------------------------------------------------------------------------------------
function _FB_Inline_(fb_MKSHORT) (Number as short) as FBSTR    
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sizeof(short)
  *cptr(short ptr,fb.TempString->data) = Number
  cptr(ubyte ptr,fb.TempString->data)[fb.TempString->len]=0
  return fb.TempString
end function
function _FB_Inline_(fb_MKI) (Number as integer) as FBSTR
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sizeof(integer)
  *cptr(integer ptr,fb.TempString->data) = Number
  cptr(ubyte ptr,fb.TempString->data)[fb.TempString->len]=0
  return fb.TempString  
end function
function _FB_Inline_(fb_MKLONGINT) (Number as longint) as FBSTR    
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sizeof(longint)
  *cptr(longint ptr,fb.TempString->data) = Number
  cptr(ubyte ptr,fb.TempString->data)[fb.TempString->len]=0
  return fb.TempString
end function
function _FB_Inline_(fb_MKS) (Number as single) as FBSTR    
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(8)
  fb.TempString->size or= 8
  fb.TempString->len = sizeof(single)
  *cptr(single ptr,fb.TempString->data) = Number
  cptr(ubyte ptr,fb.TempString->data)[fb.TempString->len]=0
  return fb.TempString  
end function
function _FB_Inline_(fb_MKD) (Number as double) as FBSTR    
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sizeof(double)
  *cptr(double ptr,fb.TempString->data) = Number
  cptr(ubyte ptr,fb.TempString->data)[fb.TempString->len]=0
  return fb.TempString  
end function
function _FB_Inline_(fb_CVSHORT) (fbQueryString as any ptr) as short
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as short iResult
  if s.data andalso s.len >= sizeof(short) then
    iResult = *cptr(short ptr,s.Data)
  end if
  DestroyTempString(fbQueryString)
  return iResult
end function
function _FB_Inline_(fb_CVI) (fbQueryString as any ptr) as integer
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as integer iResult
  if s.data andalso s.len >= sizeof(integer) then
    iResult = *cptr(integer ptr,s.Data)
  end if
  DestroyTempString(fbQueryString)
  return iResult
end function
function _FB_Inline_(fb_CVLONGINT) (fbQueryString as any ptr) as longint
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as longint iResult
  if s.data andalso s.len >= sizeof(longint) then
    iResult = *cptr(longint ptr,s.Data)
  end if
  DestroyTempString(fbQueryString)
  return iResult
end function
function _FB_Inline_(fb_CVS) (fbQueryString as any ptr) as single
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as single iResult
  if s.data andalso s.len >= sizeof(single) then
    iResult = *cptr(single ptr,s.Data)
  end if
  DestroyTempString(fbQueryString)
  return iResult
end function
function _FB_Inline_(fb_CVD) (fbQueryString as any ptr) as double
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as double iResult
  if s.data andalso s.len >= sizeof(double) then
    iResult = *cptr(double ptr,s.Data)
  end if
  DestroyTempString(fbQueryString)
  return iResult
end function
'------------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_BINEx_Proto) (Number as integer,iWidth as integer,MaxSize as integer) as FBSTR
  DebugShowFunctionName()
  dim TempBuff(64-1) as ubyte = any, Temp as ubyte ptr = @TempBuff(0)+64
  dim as uinteger BitCheck = 1,BitPos = 0,BitNumb = Number
  if cuint(iWidth) > 32 then iWidth = 32  
  for BitPos = 0 to iWidth-1
    Temp -= 1: *Temp = 48+((BitNumb and BitCheck) shr BitPos)
    BitCheck += BitCheck
  next BitPos  
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= ((BitPos or 3)+1)
    #ifdef DebugShowSize
    printf(!"BINex_Proto Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = allocate(.size and ((1 shl 31)-1))
    .Len = BitPos
    FastCopy(.data,Temp,BitPos)
    cptr(ubyte ptr,.data)[.Len]=0
  end with
  return fb.TempString
  MaxSize = MaxSize 'unused
end function
__priv function _FB_Private_(fb_BIN_i) (Number as integer) as FBSTR
  DebugShowFunctionName()
  dim TempBuff(64-1) as ubyte = any, Temp as ubyte ptr = @TempBuff(0)+64
  dim as uinteger BitCheck = 1,BitPos = 0,BitNumb = Number
  do
    Temp -= 1: *Temp = 48+((BitNumb and BitCheck) shr BitPos)
    BitCheck += BitCheck: BitPos += 1
  loop while BitNumb <> 0 and BitCheck <= BitNumb  
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= ((BitPos or 3)+1)
    #ifdef DebugShowSize
    printf(!"BIN_i Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = allocate(.size and ((1 shl 31)-1))
    .Len = BitPos
    FastCopy(.data,Temp,BitPos)
    cptr(ubyte ptr,.data)[.Len]=0
  end with
  return fb.TempString
end function
function _FB_Inline_(fb_BINEx_i) (Number as integer,iWidth as integer) as FBSTR  
  return fb_BINEx_Proto__(Number,iWidth,32)
end function
'------------------------------------------------------------------------------------------
function _FB_Inline_(fb_HEX_b) (Number as byte) as FBSTR    
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(4)
  fb.TempString->size or= 4
  fb.TempString->len = sprintf(fb.TempString->data,"%X",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_HEXEx_b) (Number as byte,CharWidth as integer) as FBSTR  
  DebugShowFunctionName()
  if CharWidth > 15 then CharWidth = 15  
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%0*X",CharWidth,Number)	
  return fb.TempString  
end function
function _FB_Inline_(fb_HEX_s) (Number as short) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%X",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_HEXEx_s) (Number as short,CharWidth as integer) as FBSTR  
  DebugShowFunctionName()
  if CharWidth > 15 then CharWidth = 15
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%0*X",CharWidth,Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_HEX_i) (Number as integer) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%X",Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_HEXEx_i) (Number as integer,CharWidth as integer) as FBSTR  
  DebugShowFunctionName()
  if CharWidth > 15 then CharWidth = 15
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(16)
  fb.TempString->size or= 16
  fb.TempString->len = sprintf(fb.TempString->data,"%0*X",CharWidth,Number)	
  return fb.TempString
end function
function _FB_Inline_(fb_HEX_l) (Number as longint) as FBSTR  
  DebugShowFunctionName()
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(20)
  fb.TempString->size or= 20    
  if culngint(Number) >= &h100000000ull then
    fb.TempString->len = sprintf(fb.TempString->data,"%X%08X",cuint(culngint(Number) shr 32),cuint(Number))	
  else
    fb.TempString->len = sprintf(fb.TempString->data,"%X",cuint(Number))	
  end if
  return fb.TempString
end function
function _FB_Inline_(fb_HEXEx_l) (Number as longint,CharWidth as integer) as FBSTR  
  DebugShowFunctionName()
  if CharWidth > 19 then CharWidth = 19
  CreateTempString(fb.TempString)
  fb.TempString->data = allocate(20)
  fb.TempString->size or= 20
  if CharWidth > 8 then
    fb.TempString->len = sprintf(fb.TempString->Data,"%0*X%08X",CharWidth-8,cuint(culngint(Number) shr 32),cuint(Number))	
  else
    fb.TempString->len = sprintf(fb.TempString->Data,"%0*X",CharWidth,cuint(Number))	
  end if
  return fb.TempString
end function
'------------------------------------------------------------------------------------------
sub _FB_Inline_(fb_MemSwap) (Target as any ptr, Source as any ptr, Amount as integer )
  'while Amount > 4
  '  dim as uinteger Temp = *cptr(uinteger ptr,Target)
  '  *cptr(uinteger ptr,Target) = *cptr(uinteger ptr,Source)
  '  *cptr(uinteger ptr,Source) = Temp
  '  Target += 4: Source += 4: Amount -= 4
  'wend
  while Amount
    dim as ubyte Temp = *cptr(ubyte ptr,Target)
    *cptr(ubyte ptr,Target) = *cptr(ubyte ptr,Source)
    *cptr(ubyte ptr,Source) = Temp
    Target += 1: Source += 1: Amount -= 1
  wend
end sub
'------------------------------------------------------------------------------------------
UndefAll()
#define P1 fbTargetString as any ptr
#define P2 iTargetLen as integer
#define P3 fbQueryString as any ptr
#define P4 iQueryLen as integer
#define P5 unk0 as integer
__priv function _FB_Private_(fb_StrAssign) (P1,P2,P3,P4,P5) as FBSTR
  dim as any ptr SourceData = fbQueryString
  DebugShowFunctionName()
  if unk0 <> 0 then printf(!"fb_strAssign unk0=%i\n",1)    
  ''printf(!"[assign %08X , %i]\n",cint(fbQueryString),iQueryLen)
  #define s cptr(FBSTRING ptr,fbTargetString)
  dim as short IsFbString
  if iQueryLen < 0 then 'Source String is a Freebasic String
    if fbQueryString then
      with *cptr(FBSTRING ptr,fbQueryString)
        iQueryLen = .len+1
        SourceData = .data
      end with
    else
      iQueryLen = 1:SourceData = 0
      if fbTargetString=0 then return 0      
    end if
    IsFbString = 1    
  elseif iQueryLen = 0 then 'Source String is a *zstring
    iQueryLen = strlen( SourceData )+1
  end if
  iQueryLen -= 1     
  if iTargetLen >= 0 then 'target is a zstring*xx    
    if iTargetLen > 0 then
      iTargetLen -= 1: if (iQueryLen) > iTargetLen then iQueryLen = iTargetLen
    end if
    FastCopy(cast(zstring ptr,fbTargetString),cast(zstring ptr,SourceData),iQueryLen)
    cptr(ubyte ptr,fbTargetString)[iQueryLen] = 0
  else 'target is a string
    if s->size = -1 then printf(!"fb_StrAssign Realloc CONST string\n"):beep:sleep          
    s->Data = reallocate(s->Data, iQueryLen + 1 )
    FastCopy( s->Data, SourceData, iQueryLen )
    s->Data[iQueryLen] = 0
    s->len = iQueryLen' + 1
    s->size = (s->size and (1 shl 31)) or (iQueryLen + 1)
    #ifdef DebugShowSize
    printf(!"StrAssign Size=%i\n",s->size): sleep DebugDelay,1
    #endif
  end if
  if IsFbString then 'andalso fbTargetString <> fbQueryString then
    DestroyTempString(fbQueryString)
  end if
  return fbTargetString
end function
function _FB_Inline_(fb_StrInit) (P1,P2,P3,P4,P5) as FBSTR
  DebugShowFunctionName()
  if iTargetLen < 0 then FastSet(fbTargetString,0,sizeof(FBSTRING))
  return fb_StrAssign__(fbTargetString,iTargetLen,fbQueryString,iQueryLen,unk0)
end function
__priv function _FB_Private_(fb_StrConcatAssign) (P1,P2,P3,P4,P5) as any ptr
  dim as any ptr SourceData = fbQueryString
  DebugShowFunctionName()
  #define s cptr(FBSTRING ptr,fbTargetString)	
  'printf(!"catasg FBs=%08X len=%i \n       src=%08X len=%i\n",cint(FBs),tgt_len,cint(src),src_len)
  dim as short isFbString
  if iQueryLen < 0 then 'Source String is a Freebasic String
    with *cptr(FBSTRING ptr,fbQueryString)
      iQueryLen = .len
      SourceData = .data
      isFbString = 1
    end with
  elseif iQueryLen = 0 then 'Source String is a *zstring
    iQueryLen = strlen( SourceData )
  else 
    iQueryLen -= 1
  end if  
  if iTargetLen >= 0 then 'target is a zstring*xx
    print "concatassign with zstring ";iTargetLen
    dim as integer tlen = strlen( fbTargetString )	
    if iTargetLen > 0 then
      iTargetLen -= 1
    else
      iTargetLen = tlen
    end if    
    'printf(!"SourceLen=%i \n",src_len)
    if (tlen+iQueryLen) > iTargetLen then iQueryLen = iTargetLen-tlen
    'printf(!"TargetLen=%i AmountToCopy=%i\n!",tgt_len,src_len)    
    FastCopy(fbTargetString+tlen,SourceData,iQueryLen)
    cptr(ubyte ptr,fbTargetString)[iQueryLen+tlen] = 0  
  else 'target is a string
    if s->size = -1 then printf(!"fb_StrConcatAssign Re CONST str\n"):beep:sleep
    s->size = (s->size and (1 shl 31)) or (s->len + iQueryLen + 1)
    's->size = (1 shl 31) or (s->len + iQueryLen + 1)
    #ifdef DebugShowSize
    printf(!"StrConcatAssign Size=%i\n",s->size): sleep DebugDelay,1
    #endif
    s->Data = reallocate(s->Data, (s->size and ((1 shl 31)-1)) )
    FastCopy( cast(any ptr,s->Data)+s->len, SourceData, iQueryLen )
    s->Data[s->len+iQueryLen] = 0: s->len += iQueryLen
  end if
  if IsFbString then 'andalso fbTargetString <> fbQueryString then
    DestroyTempString(fbQueryString)
  end if
  return fbTargetString
  unk0 = unk0 'unused
end function
__priv function _FB_Private_(fb_StrConcat) (TempFBs as any ptr , SrcA as any ptr, SrcAsz as integer, SrcB as any ptr, SrcBsz as integer) as FBSTR
  dim as any ptr DeallocA=SrcA,DeallocB=SrcB
  DebugShowFunctionName()
  'printf(!"concat FBs=%08X len=%i \n       src=%08X len=%i\n",cint(SrcA),SrcAsz,cint(SrcB),SrcBsz)
  #define FBa cptr(FBSTRING ptr,SrcA)
  #define FBb cptr(FBSTRING ptr,SrcB)
  #define s cptr(FBSTRING ptr,TempFBs)
  dim as byte isFbStringA,isFbStringB
  if SrcAsz >= 0 then 'SourceA is zstring
    SrcAsz = strlen(SrcA)
  else
    SrcAsz = FBa->Len 'Get Length from FBSTRING SourceA
    SrcA = FBa->data  'Get Data pointer from FBSTRING SourceA
    isFbStringA = 1
  end if
  if SrcBsz >= 0 then 'SourceB is zstring
    SrcBsz = strlen(SrcB)
  else
    SrcBsz = FBb->Len 'Get Length from FBSTRING SourceB
    SrcB = FBb->data  'Get Data pointer from FBSTRING SourceB
    isFbStringB = 1
  end if
  InitTempString(s)
  s->Len = SrcAsz+SrcBsz
  if s->size = -1 then printf(!"fb_StrConcat Realloc CONST string\n"):beep:sleep
  's->Size = (s->size and (1 shl 31)) or (s->Len+1)
  s->Size = (s->Len+1) ' or (1 shl 31)
  s->Data = reallocate(s->Data,(s->Size and ((1 shl 31)-1))) 'New Data
  FastCopy(s->Data,SrcA,SrcAsz)
  FastCopy(s->Data+SrcAsz,SrcB,SrcBsz)
  cptr(ubyte ptr,s->Data)[s->len]=0  
  
  if isFbStringA then 'andalso DeallocA <> TempFBs then
    DestroyTempString(DeallocA)
  end if
  if isFbStringB then 'andalso DeallocB <> TempFBs andalso DeallocA <> DeallocB then
    DestroyTempString(DeallocB)
  end if
  return TempFBs
end function
__priv sub _FB_Private_(fb_StrDelete) (StringToDelete as any ptr)
  DebugShowFunctionName()
  'printf(!"Deleting String: %x\n",cuint(StringToDelete))
  if StringToDelete = 0 then exit sub
  with *cptr(FBSTRING ptr,StringToDelete)    
    if .size = -1 then printf(!"fb_StrDelete CONST string\n"):beep:sleep    
    if IsTempString(.size) then
      DestroyTempString(StringToDelete)
    else
      if .data then deallocate(.data)    
      .data=0:.len=0: .size = 0 'and= (1 shl 31)
    end if
  end with
end sub
__priv function _FB_Private_(fb_StrCompare) (fbStringA as any ptr,StringSizeA as integer,fbStringB as any ptr,StringSizeB as integer) as integer
  dim as any ptr DeallocA=fbStringA,DeallocB=fbStringB  
  DebugShowFunctionName()
  dim as integer iResult
  dim as byte isFbStringA,isFbStringB
  #define sB cptr(FBSTRING ptr,fbStringB)  
  #define sA cptr(FBSTRING ptr,fbStringA)
  select case stringSizeA
  case  -1  : StringSizeA = (sA->Len) : fbStringA = sA->Data: isFbStringA = 1
  case else : StringSizeA = strlen(fbStringA)'+1
  end select  
  select case stringSizeB
  case  -1  : StringSizeB = (sB->Len) : fbStringB = sB->Data: isFbStringB = 1
  case else : StringSizeB = strlen(fbStringB)'+1
  end select  
  'printf(!"%i(%s)%i %i(%s)%i\n",StringSizeA,fbStringA,isFbStringA,StringSizeB,fbStringA,isFbStringB)
  if StringSizeA > StringSizeB then 
    iResult = memcmp(fbStringA,fbStringB,StringSizeB and &h7FFFFFFF)
  else
    iResult = memcmp(fbStringA,fbStringB,StringSizeA and &h7FFFFFFF)
  end if
  if isFbStringA then
    DestroyTempString(DeallocA)
  end if
  if isFbStringB then 'andalso fbStringA <> fbStringB then
    DestroyTempString(DeallocB)
  end if
  if iResult then return iResult else return sgn(StringSizeA-StringSizeB)
end function
'------------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_StrLen) (fbQueryString as any ptr,StringSize as integer) as integer
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim as integer iResult
  if StringSize >=0 then
    'if StringSize > 0 then print "len with zstring ";StringSize
    iResult = strlen(fbQueryString)  
  else
    iResult = s.len    
    DestroyTempString(fbQueryString)
  end if
  return iResult
end function
__priv function _FB_Private_(fb_StrInstr) (iStart as integer,fbQueryString as any ptr,fbMatchString as any ptr) as integer
  DebugShowFunctionName()
  dim as integer iResult
  #define s *cptr(FBSTRING ptr,fbQueryString)
  #define q *cptr(FBSTRING ptr,fbMatchString)
  if iStart < 1 or iStart > s.Len orelse q.Len > s.len or q.Len < 1 then     
    if fbMatchString <> fbQueryString then
      DestroyTempString(fbMatchString)
    end if
    DestroyTempString(fbQueryString)
    return 0
  end if
  
  dim as any ptr Result
  dim as any ptr Start = s.Data+(iStart-1)
  dim as integer Lent = s.Len-(iStart-1)
  
  dim as ubyte Char = cptr(ubyte ptr,Start)[Lent]
  if char then cptr(ubyte ptr,Start)[Lent] = 0  
  if q.Len = 1 then
    Result = memchr(Start,*cptr(ubyte ptr,q.Data),Lent)
  else
    Result = strstr(Start,q.Data)
  end if
  if char then cptr(ubyte ptr,Start)[Lent] = Char
  
  if Result then iResult = (cuint(Result)-cuint(s.Data))+1
  
  DestroyTempString(fbQueryString)
  'if fbMatchString <> fbQueryString then
  DestroyTempString(fbMatchString)
  'end if
  
  return iResult
  
end function
__priv function _FB_Private_(fb_StrInstrRev) (fbQueryString as any ptr,fbMatchString as any ptr,iStart as integer) as integer
  DebugShowFunctionName()
  dim as integer iResult
  #define s *cptr(FBSTRING ptr,fbQueryString)
  #define q *cptr(FBSTRING ptr,fbMatchString)
  if iStart < 1 or iStart > s.Len orelse q.Len > s.len or q.Len < 1 then     
    if fbMatchString <> fbQueryString then
      DestroyTempString(fbMatchString)
    end if
    DestroyTempString(fbQueryString)
    return 0
  end if
  
  dim as any ptr Result
  dim as any ptr Start = s.Data+(iStart-1)
  dim as integer Lent = s.Len-(iStart-1)
  
  dim as ubyte Char = cptr(ubyte ptr,Start)[Lent]
  if char then cptr(ubyte ptr,Start)[Lent] = 0  
  if q.Len = 1 then
    Result = strrchr(Start,*cptr(ubyte ptr,q.Data))
  else
    puts("Not implmented!")
    Result = strstr(Start,q.Data)
  end if
  if char then cptr(ubyte ptr,Start)[Lent] = Char
  
  if Result then iResult = (cuint(Result)-cuint(s.Data))+1
  
  DestroyTempString(fbQueryString)
  'if fbMatchString <> fbQueryString then
  DestroyTempString(fbMatchString)
  'end if
  
  return iResult
  
end function
__priv function _FB_Private_(fb_LCASE) (fbQueryString as any ptr) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  CreateTempString(fb.TempString)
  with *fb.TempString
    .len = s.len
    .size or= (.len+1)
    #ifdef DebugShowSize
    printf(!"LCASE Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))    
    dim as byte ptr Src=s.data,Dst=.data
    dim as uinteger Char
    for CNT as integer = 0 to .len
      Char = *Src: Src += 1
      if cuint(Char-asc("A")) <= (asc("Z")-asc("A")) then Char += asc("a")-asc("A")
      *Dst = Char: Dst += 1
    next CNT
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv function _FB_Private_(fb_UCASE) (fbQueryString as any ptr) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  CreateTempString(fb.TempString)
  with *fb.TempString
    .len = s.len
    .size or= (.len+1)
    #ifdef DebugShowSize
    printf(!"UCASE Size=%i %i\n",.size,(.size and ((1 shl 31)-1))): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))    
    dim as byte ptr Src=s.data,Dst=.data
    dim as uinteger Char
    for CNT as integer = 0 to .len
      Char = *Src: Src += 1
      if cuint(Char-asc("a")) <= (asc("z")-asc("a")) then Char += asc("A")-asc("a")
      *Dst = Char: Dst += 1
    next CNT
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv function _FB_Private_(fb_LEFT) (fbQueryString as any ptr, iAmount as integer) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  if iAmount < 0 then iAmount = 0
  if iAmount > s.Len then iAmount = s.Len
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= (iAmount+1)
    #ifdef DebugShowSize
    printf(!"LEFT Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount
    FastCopy(.data,s.data,.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
function _FB_Inline_(fb_LTRIM) (fbQueryString as any ptr) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim TempData as ubyte ptr=cast(any ptr,s.Data),iAmount as integer
  for iAmount = 0 to s.Len-1
    if TempData[iAmount] <> asc(" ") then exit for
  next iAmount 
  iAmount = s.Len-iAmount
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= (iAmount+1)
    #ifdef DebugShowSize
    printf(!"LTRIM Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount
    FastCopy(.data,s.data+(s.len-.len),.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv function _FB_Private_(fb_RIGHT) (fbQueryString as any ptr, iAmount as integer) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  if iAmount < 0 then iAmount = 0
  if iAmount > s.Len then iAmount = s.Len    
  CreateTempString(fb.TempString)
  with *fb.TempString  
    .size or= (iAmount+1)
    #ifdef DebugShowSize
    printf(!"RIGHT Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount
    FastCopy(.data,s.data+(s.len-.len),.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
function _FB_Inline_(fb_RTRIM) (fbQueryString as any ptr) as FBSTR  
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim TempData as ubyte ptr=cast(any ptr,s.Data),iAmount as integer  
  for iAmount = s.Len-1 to 0 step -1
    if TempData[iAmount] <> asc(" ") then exit for
  next iAmount  
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= (iAmount+2)
    #ifdef DebugShowSize
    printf(!"RTRIM Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount+1
    FastCopy(.data,s.data,.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv function _FB_Private_(fb_StrMid) (fbQueryString as any ptr, iStart as integer, iAmount as integer) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  iStart -= 1
  if iStart < 0 or iStart > s.Len then iStart = 0: iAmount = 0
  if iAmount < 0 then iAmount = s.Len
  if (iStart+iAmount) > s.Len then iAmount = s.Len-iStart  
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= (iAmount+1)
    #ifdef DebugShowSize
    printf(!"StrMid Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount
    FastCopy(.data,s.data+iStart,.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv function _FB_Private_(fb_TRIM) (fbQueryString as any ptr) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  dim TempData as ubyte ptr=cast(any ptr,s.Data)
  dim as integer iStart,iAmount
  for iStart = 0 to s.Len-1
    if TempData[iStart] <> asc(" ") then exit for
  next iStart
  for iAmount = s.Len-1 to 0 step -1
    if TempData[iAmount] <> asc(" ") then exit for
  next iAmount  
  iAmount -= iStart  
  if iAmount < 0 then iAmount += 1
  CreateTempString(fb.TempString)
  with *fb.TempString
    .size or= (iAmount+2)
    #ifdef DebugShowSize
    printf(!"TRIM Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))
    .len = iAmount+1
    FastCopy(.data,s.data+iStart,.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
__priv sub _FB_Private_(fb_StrAssignMid) (fbQueryString as any ptr, iStart as integer, iAmount as integer,fbSetString as any ptr)
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbSetString)
  with *cptr(FBSTRING ptr,fbQueryString)
    iStart -= 1
    if iStart < 0 or iStart > .Len then iStart = 0: iAmount = 0
    if iAmount < 0 or iAmount > s.Len then iAmount = s.Len  
    if (iStart+iAmount) > .Len then iAmount = .Len-iStart    
    FastCopy(.data+iStart,s.data,iAmount)    
  end with
  if fbSetString <> fbQueryString then
    DestroyTempString(fbSetString)
  end if
end sub
'------------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_StrFill1) (iAmount as integer,iChar as integer) as FBSTR
  DebugShowFunctionName()
  if iAmount < 0 then iAmount = 0  
  CreateTempString(fb.TempString)
  with *fb.TempString
    .len = iAmount
    .size or= (.len+1)
    #ifdef DebugShowSize
    printf(!"StrFill1 Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))    
    FastSet(.data,iChar,.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  return fb.TempString
end function
__priv function _FB_Private_(fb_StrFill2) (iAmount as Integer,fbQueryString as any ptr) as FBSTR
  DebugShowFunctionName()
  #define s *cptr(FBSTRING ptr,fbQueryString)
  if iAmount < 0 then iAmount = 0
  if s.Len < 0 then iAmount = 0
  CreateTempString(fb.TempString)
  with *fb.TempString
    .len = iAmount
    .size or= (.len+1)
    #ifdef DebugShowSize
    printf(!"StrFill2 Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = reallocate(.data,(.size and ((1 shl 31)-1)))    
    FastSet(.data,*cptr(ubyte ptr,s.data),.len)
    cptr(ubyte ptr,.data)[.len] = 0
  end with
  DestroyTempString(fbQueryString)
  return fb.TempString
end function
function _FB_Inline_(fb_SPACE) (iAmount as integer) as FBSTR
  return fb_StrFill1__(iAmount,asc(" "))
end function
'------------------------------------------------------------------------------------------

__priv function _FB_Private_(fb_ConsoleInput) (fbQueryString as any ptr,QueryType as integer,StringSize as integer) as integer
  DebugShowFunctionName()
  'if fbLastConcat = cptr(FBSTRING ptr,fbQueryString)->data then fbLastConcat = 0  
  fb_PrintString__(0,fbQueryString,0)  
  if StringSize >= 0 then fb_StrDelete__(fbQueryString)
  if QueryType = -1 then
    putchar(asc("?")):putchar(asc(" "))
  end if
  dim as integer CharAscii
  'DestroyTempString(fb.InputString)
  CreateTempString(fb.InputString)
  if fb.DestroyTemp then
    DestroyTempString(fb.DestroyTemp)    
  end if
  fb.DestroyTemp = fb.InputString
  
  with *fb.InputString
    .len = 0:.size or= 64
    #ifdef DebugShowSize
    printf(!"ConsoleInput Size=%i\n",.size): sleep DebugDelay,1
    #endif
    .data = allocate((.size and ((1 shl 31)-1)))
    do
      fb.ScreenEchoIsON = True
      CharAscii = getc(STDIN)
      fb.ScreenEchoIsON = False
      if CharAscii = asc(!"\n") then
        cptr(ubyte ptr,.data)[.len] = 0
        exit do
      end if
      cptr(ubyte ptr,.data)[.len] = CharAscii
      .len += 1
      if (.len and 63) = 0 then
        .size += 64: .data = reallocate(.data,(.size and ((1 shl 31)-1)))
        #ifdef DebugShowSize
        printf(!"ConsoleInput Size=%i\n",.size): sleep DebugDelay,1
        #endif
      end if
    loop   
    'printf("{%s}",.data):sleep'
  end with
  return fb.InputString->len  
end function
__priv function _FB_Private_(fb_InputString) (TargetString as any ptr,StringSize as integer,Unk1 as integer) as integer  
  DebugShowFunctionName()
  dim as integer iResult
  with *fb.InputString
    #define s *cptr(FBSTRING ptr,TargetString)
    if .len andalso .Data then
      'printf(!"{%s}\n",.Data)
      while *cptr(ubyte ptr,.Data) = 32 or *cptr(ubyte ptr,.Data) = 9
        .Data += 1: .Len -= 1': .Size -= 1
      wend
      dim as integer NewSize = .len
      dim as any ptr NewPointer = memchr(.Data,asc(","),NewSize)
      if NewPointer then NewSize = (cuint(NewPointer)-cuint(.Data))     
      if TargetString then
        'puts("Target String!")
        if StringSize = -1 then          
          'print("Freebasic string?")
          if s.size = -1 then printf(!"fb_InputString Realloc CONST string\n"):beep:sleep
          s.data = reallocate(s.data,NewSize+1)
          s.len = NewSize: s.size = (s.size and ((1 shl 31))) or (NewSize+1)
          #ifdef DebugShowSize
          printf(!"InputString Size=%i\n",s.size): sleep DebugDelay,1
          #endif
          FastCopy(s.data,.data,NewSize)
          cptr(ubyte ptr,s.data)[NewSize] = 0          
          iResult = NewSize                   
        else          
          if StringSize = 0 then StringSize = strlen(TargetString)
          if NewSize >= StringSize then NewSize = StringSize-1
          if NewSize < 1 then
            cptr(ubyte ptr,TargetString)[0] = 0
          else
            FastCopy(TargetString,.data,NewSize)
            cptr(ubyte ptr,TargetString)[NewSize] = 0
          end if
          iResult = NewSize
        end if
      end if
      if NewPointer then
        NewSize += 1
        .Data += NewSize 
        .Len -= NewSize: if .Len < 0 then .Len = 0
        dim as integer Temp = (.Size and (1 shl 31))
        .Size -= (Temp+NewSize): if .Size < 0 then .Size = 0
        .Size or= Temp
      else
        if .Data then deallocate(.data)
        .Data = 0:.Len = 0:.Size = (.size and ((1 shl 31)))
      end if
    else
      if StringSize = -1 then
        if s.size = -1 then printf(!"fb_InputString dealloc CONST\n")
        if s.data then deallocate(s.data)          
        s.data=0:s.len = 0: s.size = (s.size and ((1 shl 31)))
        #ifdef DebugShowSize
        printf(!"InputString Size=%i\n",s.size): sleep DebugDelay,1
        #endif
      else
        cptr(ubyte ptr,s.data)[0] = 0
      end if
    end if
  end with
  return iResult
  Unk1 = Unk1 'unused
end function
__priv function _FB_Private_(fb_InputNumber) (ZScan as zstring ptr,Target as any ptr) as integer  
  DebugShowFunctionName()
  with *fb.InputString
    if .len andalso .Data then
      while *cptr(ubyte ptr,.Data) = 32 or *cptr(ubyte ptr,.Data) = 9
        .Data += 1: .Len -= 1: .Size -= 1
      wend
      dim as integer NewSize = .len
      dim as any ptr NewPointer = memchr(.Data,asc(","),NewSize)
      if NewPointer then NewSize = (cuint(NewPointer)-cuint(.Data))
      sscanf(.Data,ZScan,Target)
      if NewPointer then
        NewSize += 1
        .Data += NewSize
        .Len -= NewSize: if .Len < 0 then .Len = 0
        dim as integer Temp = (.Size and (1 shl 31))
        .Size -= (Temp+NewSize): if .Size < 0 then .Size = 0
        .Size or= Temp
      else
        .Data = 0:.Len = 0:.Size = (.size and ((1 shl 31)))        
      end if      
      return NewSize
    else
      sscanf("0",ZScan,Target)
    end if
  end with
end function
function _FB_Inline_(fb_InputByte) (Target as byte ptr) as integer  
  dim as integer TempTarget
  function = fb_InputNumber__("%i",cast(any ptr,@TempTarget))
  *Target = TempTarget
end function
function _FB_Inline_(fb_InputUbyte) (Target as ubyte ptr) as integer  
  dim as uinteger TempTarget
  function = fb_InputNumber__("%u",cast(any ptr,@TempTarget))
  *Target = TempTarget
end function
function _FB_Inline_(fb_InputShort) (Target as short ptr) as integer  
  return fb_InputNumber__("%hi",cast(any ptr,Target))
end function
function _FB_Inline_(fb_InputUshort) (Target as ushort ptr) as integer  
  return fb_InputNumber__("%hu",cast(any ptr,Target))
end function
function _FB_Inline_(fb_InputInt) (Target as integer ptr) as integer  
  return fb_InputNumber__("%i",cast(any ptr,Target))
end function
function _FB_Inline_(fb_InputUint) (Target as uinteger ptr) as integer  
  return fb_InputNumber__("%u",cast(any ptr,Target))
end function
function _FB_Inline_(fb_InputSingle) (Target as single ptr) as integer  
  return fb_InputNumber__("%f",cast(any ptr,Target))
end function
function _FB_Inline_(fb_InputDouble) (Target as double ptr) as integer  
  return fb_InputNumber__("%Lf",cast(any ptr,Target))
end function
'------------------------------------------------------------------------------------------

extern keyBufferLength alias "keyBufferLength" as long 'libnds keyboard

__priv function _FB_Private_(fb_Inkey) () as FBSTR  
  DebugShowFunctionName()
  static as zstring*4 InkData = "   "
  static as FBSTRING InkeyString
  if fb.InkeyRead <> fb.InkeyWrite then  
    dim as integer NewKey = fb.InkeyBuff(fb.InkeyRead)
    'createTempString(fb.TempString)
    InkeyString.data = @InkData
    InkeyString.size = -1    
    if NewKey < 0 then
      InkeyString.len = 2
      cptr(ushort ptr,InkeyString.data)[0] = 255+((-NewKey) shl 8)      
    else
      InkeyString.len = 1
      cptr(ubyte ptr,InkeyString.data)[0] = NewKey
    end if
    fb.InkeyRead = (fb.InkeyRead+1) and 255    
    if keyBufferLength then keyBufferLength -= 1
  else
    InkeyString.data = @InkData
    InkeyString.size = -1
    InkeyString.len = 0
  end if
  cptr(ubyte ptr,InkeyString.data)[InkeyString.len]=0
  return @InkeyString  
end function
function _FB_Inline_(fb_GetMouse) (iX as integer ptr,iY as integer ptr,iWheel as integer ptr,iButtons as integer ptr,iClip as integer ptr) as integer
  *iX = fb.MouseX: *iY = fb.MouseY
  *iButtons = iif(fb.DsButtons and KEY_TOUCH,1,0)
  *iWheel = 0: *iClip = 0
  Return 0
end function
function _FB_Inline_(fb_SetMouse) (iX as integer,iY as integer,iCursor as integer,iClip as integer) as integer
  return -1
  iX = iX 'unused
  iY = iY 'unused
  iCursor = iCursor 'unused
  iClip = iClip 'unused
end function
function _FB_Inline_(fb_Multikey) (iScanCode as integer) as integer
  if iScanCode < 0 then return ((fb.dsButtons and (-iScanCode))<>0)
  if iScanCode >= fb.SC_BUTTONTOUCH and iScanCode <= fb.SC_BUTTONA then
    return (fb.dsButtons and (1 shl (128-iScanCode)))<>0
  end if
  return fb.ScanState((iScanCode and 127))<>0
end function
'------------------------------------------------------------------------------------------
function _FB_Inline_(fb_Locate) (iLin as integer,iCol as integer,Unk0 as integer,Unk1 as integer,Unk2 as integer) as integer  
  if iLin > 24 or icol > 32 then return 0  
  if iLin > 0 then fbConsole->CursorY = iLin-1
  if iCol > 0 then fbConsole->CursorX = iCol-1
  return 1
  Unk0 = Unk0 'unused
  Unk1 = Unk1 'unused
  Unk2 = Unk2 'unused
end function
sub _FB_Inline_(fb_Cls) (Unk0 as integer)
  puts(@!"\x1b[2J"):locate 1,1
  Unk0 = Unk0 'unused
end sub
__priv function _FB_Private_(fb_Color) (iFore as integer,iBack as integer,Unk0 as integer) as integer  
  dim as integer uColor = ((iFore and 4) shr 2) or ((iFore and 1) shl 2) or (iFore and 10)
  fbConsole->FontCurPal = (uColor shl 12)
  return 1
  iBack = iBack 'unused
  Unk0 = Unk0 'unused
end function
__priv function _FB_Private_(fb_GetX) () as integer
  return ((fbConsole->CursorX) and 31)+1
end function
__priv function _FB_Private_(fb_GetY) () as integer
  return ((fbConsole->CursorY)+((fbConsole->CursorX) shr 5))+1
end function
'------------------------------------------------------------------------------------------
sub _FB_Inline_(fb_Randomize) (dSeed as double,iType as integer)
  if dSeed = -1 then dSeed = fb_Ticks
  srand(dSeed) '*cptr(integer ptr,@dSeed) xor (dSeed*1024))  
  exit sub
  iType = iType 'unused
end sub
function _FB_Inline_(fb_Rnd) (Seed as Single) as double
  if Seed <> 1 then srand(Seed) 'srand(*cptr(uinteger ptr,@Seed))
  return Rand()*(1/2147483648.0)
end function
'-----------------------------------------------------------------------------------------
function _FB_Inline_(fb_FileFree) () as integer  
  for CNT as integer = 1 to fb.MaxFbFiles
    with fb.fnum(CNT)
      if .pHandle=0 then return CNT
    end with
  next CNT
  return 0
end function
undefall()
#define P1 fbFileName as any ptr
#define P2 iMode      as fb.OpenModes
#define P3 iAccess    as fb.AccessFlags
#define P4 iLock      as fb.AccessFlags
#define P5 iFileNum   as integer
#define P6 iFieldSz   as integer
__priv function _FB_Private_(fb_FileOpen) (P1,P2,P3,P4,P5,P6) as fb.ErrorNumbers
  DebugShowFunctionName()
  dim as integer iResult  
  do
    #define s *cptr(FBSTRING ptr,fbFileName)  
    if cuint(iFileNum) > fb.MaxFbFiles then iResult=fb.enIllegal: exit do
    if fb.fnum(iFileNum).pHandle then iResult=fb.enIllegal: exit do
    if cuint(iMode) >= fb.omInvalid then iResult=fb.enIllegal: exit do
    
    dim as zstring ptr OpenMode = @"a+"
    select case (iAccess and (fb.afRead or fb.afWrite))
    case fb.afRead
      OpenMode = @"rb"
    case fb.afWrite
      OpenMode = @"wb"
    end select
        
    with fb.fnum(iFileNum)    
      .pHandle = fopen((s.Data),OpenMode)
      if .pHandle=0 then iResult = fb.enNotFound: exit do
      if OpenMode = @"a+" then freopen((s.Data),"r+",.pHandle)
      'dim as stat tStat = any
      'fstat(.pHandle , @tStat )
      '.iLof = tStat.st_size
      fSeek(.pHandle,0,SEEK_END)
      'printf(!"%i %i\n",cint(.iLof),fTell(.pHandle))
      .iLof = fTell(.pHandle)
      fSeek(.pHandle,0,SEEK_SET)
      .iFlags = iMode
    end with
    
    iResult = fb.enNoError
    exit do
  loop   
  DestroyTempString(fbFileName)
  return iResult
  iLock = iLock 'unused
  iFieldSZ = iFieldSZ 'unused
end function
function _FB_Inline_(fb_FileSize) (iFileNum as integer) as longint
  if cuint(iFileNum) > fb.MaxFbFiles then return -fb.enIllegal
  with fb.fnum(iFileNum)
    if .pHandle=0 then return -fb.enIllegal
    return .iLof
  end with
end function
__priv function _FB_Private_(fb_FileSeekLarge) (iFileNum as integer,iFilePos as longint) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return fb.enIllegal
  with fb.fnum(iFileNum)
    if .pHandle=0 or iFilePos = 0 then return fb.enIllegal
    if fSeek(.pHandle,iFilePos-1,SEEK_SET) = 0 then
      return fb.enNoError
    else
      return fb.enIOerror
    end if
  end with
end function
__priv function _FB_Private_(fb_FileSeek) (iFileNum as integer,iFilePos as uinteger) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return fb.enIllegal
  with fb.fnum(iFileNum)
    if .pHandle=0 or iFilePos = 0 then return fb.enIllegal
    if fSeek(.pHandle,iFilePos-1,SEEK_SET) = 0 then
      return fb.enNoError
    else
      return fb.enIOerror
    end if
  end with
end function
__priv function _FB_Private_(fb_FileTell) (iFileNum as integer) as longint
  if cuint(iFileNum) > fb.MaxFbFiles then return -fb.enIllegal
  with fb.fnum(iFileNum)
    if .pHandle=0 then return -fb.enIllegal
    return fTell(.pHandle)+1
  end with
end function
__priv function _FB_Private_(fb_FileEof) (iFileNum as integer) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return -1
  with fb.fnum(iFileNum)
    if .pHandle=0 then return -1
    return seek(iFileNum) >= lof(iFileNum)
  end with
end function
__priv function _FB_Private_(fb_FileClose) (iFileNum as integer) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return fb.enIllegal
  with fb.fnum(iFileNum)
    if .pHandle=0 then return fb.enIllegal
    fclose(.pHandle)
    .pHandle = 0: .iFlags = 0: .iLof = 0    
  end with
  return fb.EnNoError
end function
__priv function _FB_Private_(fb_FileGet) (iFileNum as integer,iSeek as uinteger,pBuffer as any ptr,iAmount as integer) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return -fb.enIllegal  
  with fb.fnum(iFileNum)
    if .pHandle=0 or pBuffer = 0 then return -fb.enIllegal
    if iSeek then fb_FileSeek__(iFileNum,iSeek)
    fread(pBuffer,1,iAmount,.pHandle)
  end with
end function
__priv function _FB_Private_(fb_FilePut) (iFileNum as integer,iSeek as uinteger,pBuffer as any ptr,iAmount as integer) as integer
  if cuint(iFileNum) > fb.MaxFbFiles then return -fb.enIllegal  
  with fb.fnum(iFileNum)
    if .pHandle=0 or pBuffer = 0 then return -fb.enIllegal
    if iSeek then fb_FileSeek__(iFileNum,iSeek)
    fwrite(pBuffer,1,iAmount,.pHandle)
  end with
end function
__priv function _FB_Private_(fb_FileLineInput) (iFileNum as integer,fbTarget as any ptr, unk0 as integer, unk1 as integer) as integer
  DebugShowFunctionName()
  if unk0 <> -1 then printf("fb_FileLineInput unk0 = %i",unk0)
  if unk1 <> 0 then printf("fb_FileLineInput unk1 = %i",unk1)
  if cuint(iFileNum) > fb.MaxFbFiles then return -fb.enIllegal
  dim as any ptr InFile = fb.fnum(iFileNum).pHandle,Result
  if InFile = 0 then return -fb.enIllegal
  dim as integer ReadSize,CurPosi=fTell(InFile)
  if fb_FileEof__(iFileNum) then printf !"????\n":return 0
  with *cptr(FBSTRING ptr,fbTarget)
    dim as integer WasTemp = ((.size) and (1 shl 31))
    if .size = -1 then printf(!"FileLineInput CONST %x\n",cuint(fbTarget)):beep:sleep
    .size = 0
    static as integer BufferIncrement = 96
    if BufferIncrement > 256 then BufferIncrement = 256
    do      
      if BufferIncrement < 4 then BufferIncrement = 4
      .data = reallocate(.data,.size+BufferIncrement)
      ReadSize = fread(.data+.size,1,BufferIncrement,InFile)      
      BufferIncrement = (BufferIncrement+(ReadSize*7)) shr 3
      if ReadSize > 1 then
        Result = memchr(.data+.size,10,ReadSize)
      else
        Result = 0
      end if
      .size += ReadSize
      if Result orelse ReadSize < BufferIncrement then
        if Result then
          fSeek(InFile,CurPosi+(cuint(Result)-cuint(.data)+1),SEEK_SET)
          if Result<>.Data andalso *cptr(ubyte ptr,Result-1) = 13 then Result -= 1          
          .size = cuint(Result)-cuint(.data)          
        end if
        .len = .size: .size += 1
        .data = reallocate(.data,.size)
        cptr(ubyte ptr,.data)[.len]=0
        if .size < 0 then print "wtf?"
        .size or= WasTemp
        return .len
      end if
    loop
  end with
end function
'-----------------------------------------------------------------------------------------
__priv function _FB_Private_(fb_WildMatch) (zFilter as zstring ptr, zFile as zstring ptr) as integer
  var pFilter = cast(ubyte ptr,zFilter), pFile = cast(ubyte ptr,zFile)
  dim as integer iFilter,iFile,iLast=-1,iMid=0,iFound=0
  do  
    var iChar = pFilter[iFilter]  
    select case iChar
    case 0,asc("?"),asc("*")    
      if iLast <> -1 then           
        if iMid=0 then
          for CNT as integer = 0 to (iFilter-iLast)-1          
            if pFilter[iLast+CNT] <> pFile[iFile+CNT] then exit do
          next CNT        
          iFile += (iFilter-iLast)
        else
          var iTemp = iFile
          do                      
            if pFile[iTemp] = pFilter[iLast] then             
              for CNT as integer = 1 to (iFilter-iLast)+(iChar<>0)
                if pFilter[iLast+CNT] <> pFile[iTemp+CNT] then 
                  iTemp += 1: continue do
                end if
              next CNT            
              iFile = iTemp+(iFilter-iLast): exit do
            else
              if pFile[iTemp]=0 then exit do,do
            end if
            iTemp += 1
          loop        
        end if      
      end if    
      if iChar = 0 then iFound=(pFile[iFile]=0):exit do    
      iLast = -1
      if iChar = asc("?") then 
        iFile -= pFile[iFile]<>0: iFilter += 1: continue do
      end if
      iLast = iFilter+1: if iChar = asc("*") then iMid = 1
    case else
      if iLast = -1 then iLast = iFilter    
    end select
    iFilter += 1  
  loop
  return iFound
end function
__priv function _FB_Private_(fb_Dir_Proto) (fbQueryString as any ptr, iFlags as integer, pOutAtt as integer ptr ) as FBSTR
  #define s *cptr(FBSTRING ptr,fbQueryString)
  static sFilter as string,iAttr as integer,pdir as DIR ptr
  if fbQueryString then
    if pdir then closedir(pdir):pdir=NULL
    if s.len = 0 then return fb_StrAllocTempResult__(NULL)
    if s.data = NULL then return fb_StrAllocTempResult__(NULL)
    dim as integer iTemp=any,iPath=-1
    dim sPath as string
    dim pChar as ubyte ptr = s.data    
    for CNT as integer = s.len-1 to 0 step -1
      if pChar[CNT] = asc("/") then
        iTemp = pChar[CNT+1]: pChar[CNT+1]=NULL
        sPath = s->data : pChar[CNT+1] = iTemp
        iPath = CNT+1: exit for
      end if
    next CNT
    if iPath = -1 then iPath = 0: sPath = "./"
    sFilter = *((s.data)+iPath): iAttr = iFlags
    'printf(!"[%s]%s\n",sPath,sFilter)
    pdir = opendir(sPath)  
    DestroyTempString(fbQueryString)
  end if
  if pdir=0 then 
    return fb_StrAllocTempResult__(NULL)
  else  
    dim pent as dirent ptr , iAtt as integer
    #if 0
    dim as ubyte uTab(255) = any
    for CNT as integer = 0 to asc("a")-1: uTab(CNT) = CNT: next CNT
    for CNT as integer = asc("a") to asc("z"): uTab(CNT) = CNT-32: next CNT
    for CNT as integer = asc("z")+1 to 255: uTab(CNT) = CNT: next CNT
    #endif
    do
      pent = readdir(pdir)
      if pent=NULL then closedir(pdir):pdir=NULL:return fb_StrAllocTempResult__(NULL)
      if pent->d_type = DT_DIR then iAtt = fbDirectory else iAtt = fbNormal    
      if (iAtt and iAttr) then
        if len(sFilter) = 0 orelse fb_WildMatch__(sFilter,pent->d_name) then
          CreateTempString(fb.TempString)
          with *fb.TempString
            .len = strlen(pent->d_name)
            .size or= .len+1
            .data = allocate(.len+1)
            memcpy(.data,@pent->d_name,(.len+1))
          end with      
          if pOutAtt then *pOutAtt = iAtt
          return fb.TempString
        end if
      end if
    loop
  end if
end function
function _FB_Inline_(fb_Dir) (fbQueryString as any ptr, iFlags as integer, iOutAtt as integer ptr ) as FBSTR  
  DebugShowFunctionName()
  return fb_Dir_Proto__(fbQueryString,iFlags,iOutAtt)  
end function
function _FB_Inline_(fb_DirNext) ( iOutAtt as integer ptr ) as FBSTR
  DebugShowFunctionName()
  return fb_Dir_Proto__( NULL , NULL , iOutAtt )
end function
declare function mkdir_ cdecl alias "mkdir" (as zstring ptr,as integer) as integer
function _FB_Inline_(fb_MkDir) ( fbStringDirectory as any ptr ) as integer
  #define s *cptr(FBSTRING ptr,fbStringDirectory)  
  return mkdir_(s.data,&o777)
end function
#if 0
scope
  dim as string path = "/"
  dim as DIR ptr pdir = opendir(path)
  dim as stat FileStat
  if pdir then
    do
      dim as dirent ptr pent = readdir(pdir)
      if pent=0 then exit do
      dim as string fname = path+pent->d_name
      print Stat(pent->d_name,@FileStat),
      print "[";pent->d_name;"]",S_ISDIR(FileStat.st_mode)
    loop		
    closedir(pdir)
  else
    printf(!"opendir() failure.\n")
  end if  
  print "[";
  fb_PrintString_(0,fbQueryString,0)
  print "]"
  DestroyTempString(fbQueryString)
  CreateTempString(fb.TempString)
  with *fb.TempString
    .len = 0
    .size or= 0
    .data = 0    
    'cptr(ubyte ptr,.data)[.len] = 0
  end with
  return fb.TempString
  iFlags = iFlags 'unused
  iOutAtt = iOutAtt 'unused
end scope
#endif  
'-----------------------------------------------------------------------------------------
sub _FB_Inline_(fb_End) (iExitCode as integer)
  'exit_(iExitCode)
  systemShutDown()
end sub
'-----------------------------------------------------------------------------------------
__priv sub _FB_Private_(fb_ArrayStrErase) ( fbArray as any ptr )
  DebugShowFunctionName()
  if fbArray=0 then exit sub
  with *cptr(FB_ARRAYDESC ptr,fbArray)
    if .pPTR then 
      dim as FBSTRING ptr StringElement
      for CNT as integer = 0 to (.iSize\sizeof(FBSTRING))-1
        if StringElement[CNT].Data then fb_StrDelete__(StringElement+CNT)
      next CNT      
      deallocate(.pPTR)      
    end if
    FastSet(fbArray,0,sizeof(fbarray))    
  end with  
end sub
#if not __FB_MIN_VERSION__(0, 24, 5)
__priv function _FB_Private_(fb_ArrayErase) ( fbArray as any ptr, iIsString as integer) as integer
  if fbArray=0 then return 0  
  if iIsString then
    DebugShowFunctionName()
    fb_ArrayStrErase_(fbArray)    
  else
    with *cptr(FB_ARRAYDESC ptr,fbArray)
      if .pPTR then deallocate(.pPTR)
      FastSet(fbArray,0,sizeof(fbarray))    
    end with
  end if
  return -1  
end function
#else
__priv function _FB_Private_(fb_ArrayErase) ( fbArray as any ptr) as integer
  if fbArray=0 then return 0    
  with *cptr(FB_ARRAYDESC ptr,fbArray)
    if .pPTR then deallocate(.pPTR)
    FastSet(fbArray,0,sizeof(fbarray))    
  end with
  return -1  
end function
__priv function _FB_Private_(fb_ArrayEraseStr) ( fbArray as any ptr) as integer
  if fbArray=0 then return 0    
  DebugShowFunctionName()
  fb_ArrayStrErase__(fbArray)
  return -1  
end function
__priv function _FB_Private_(fb_ArrayDestructStr) ( fbArray as any ptr) as integer
  if fbArray=0 then return 0    
  DebugShowFunctionName()
  fb_ArrayStrErase__(fbArray)
  return -1  
end function
#endif
undefAll()
#define P1 fbArray   as any ptr
#define P2 iItemSz   as integer
#define P3 iDoClear  as integer
#define P4 iIsString as integer
#define P5 iDepth    as integer
#define P6 ...
__priv function _FB_Private_(fb_ArrayRedimEx) ( P1,P2,P3,P4,P5,P6 ) as integer
  DebugShowFunctionName()
  if fbArray=0 or iItemSz <=0 then return 0  
  
  with *cptr(FB_ARRAYDESC ptr,fbArray)        
    
    if iIsString andalso .pPTR then fb_ArrayStrErase__(fbArray)
    if iDepth <= 0 then iDepth = .iDIMENSIONS else .iDIMENSIONS = iDepth        
    .iELEMENT_LEN = iItemSz: .iSIZE = iItemSz
    
    dim as integer iLBound,iUBound
    dim as any ptr ARG = @iDepth+1 'Get ... ptr HACK!!
    for CNT as integer = 0 to iDepth-1
      iLBound = *cptr(integer ptr,ARG): ARG += sizeof(integer)
      iUBound = *cptr(integer ptr,ARG): ARG += sizeof(integer)
      if iLBound <> 0 then print "Bounds: ";iLBound;",";iUBound
      .iSIZE *= ((iUbound-iLBound)+1)
      with .tDIMTB(CNT)
        .iLBOUND = iLBound: .iUBOUND = iUBound
        .iELEMENTS = ((iUbound-iLBound)+1)
      end with
    next CNT    
    
    if (.iSIZE and 3) then .iSIZE = (.iSIZE or 3)+1    
    .pPTR = reallocate(.pPTR,.iSIZE): .pDATA = .pPTR    
    if .pPTR = 0 then printf(!"%i: %s\n",__LINE__,"Failed to allocate!"):sleep    
    if iDoClear then FastSet(.pPTR,0,.iSIZE)
    
  end with
  
  return -1  
end function
function _FB_Inline_(fb_ArrayLBound) ( fbArray as any ptr, iDepth as integer) as integer
  if fbArray=0 or iDepth>7 then return 0
  return cptr(FB_ARRAYDESC ptr,fbArray)->tDIMTB(iDepth).iLBOUND
end function
function _FB_Inline_(fb_ArrayUBound) ( fbArray as any ptr, iDepth as integer) as integer  
  if fbArray=0 or iDepth>7 then return 0
  return cptr(FB_ARRAYDESC ptr,fbArray)->tDIMTB(iDepth).iUBOUND
end function
'******************* VBCOMPAT ****************
__priv function _FB_Private_(fb_FileLen) ( zFilename as zstring ptr ) as longint '__FB__INLINE__
  #ifndef PLATFORM_INDEPENDENT
  dim as integer FileStat(31)
  Stat( zFilename , cast(any ptr,@FileStat(0)) )
  return FileStat(6)
  #else
  var f = freefile()
  if open( *zFilename for binary access read as #f ) then
    return 0
  else
    function = lof(f): close #f
    exit function
  end if
  #endif
end function
'-----------------------------------------------------------------------------------------
sub _FB_Inline(KeyboardShowHideSync) (ID as any ptr)
  KeyboardShow()
  #ifdef __FB_CALLBACKS__
  fb_RemoveVsyncCallBack(@KeyboardShowHideSync)
  #endif
  exit sub
  ID = ID 'unused
end sub
__private sub KeyboardShowHide(DirectionPTR as any ptr)
  dim as integer Direction = cast(integer,DirectionPTR)
  if fbKeyboard = 0 then exit sub  
  if Direction > 0 then
    fb.KeyboardTempOffset += 3
    if fb.KeyboardTempOffset > fb.KeyboardOffset then
      fb.KeyboardTempOffset = fb.KeyboardOffset
    end if
  elseif Direction < 0 then
    fb.KeyboardTempOffset -= 3
    if fb.KeyboardTempOffset < 0 then
      fb.KeyboardTempOffset = 0
    end if
  else
    fb.KeyboardTempOffset = 0
  end if  
  fbKeyboard->offset_y = -192+fb.KeyboardTempOffset
  if fb.KeyboardTempOffset=0 then
    #ifdef __FB_CALLBACKS__
    fb_RemoveVsyncCallBack(@KeyboardShowHideSync)
    #endif
    KeyboardHide()
    #ifdef __FB_CALLBACKS__
    fb_RemoveVsyncCallBack(@KeyboardShowHide)  
    #endif
  elseif fb.KeyboardTempOffset = fb.KeyboardOffset then
    #ifdef __FB_CALLBACKS__
    fb_AddVsyncCallBack(@KeyboardShowHideSync,0,True)  
    fb_RemoveVsyncCallBack(@KeyboardShowHide)
    #endif
    KeyboardShow()
  else
    #ifdef __FB_CALLBACKS__
    fb_AddVsyncCallBack(@KeyboardShowHideSync,0,True)
    #endif
  end if
end sub
sub _FB_Inline(fb_ShowKeyboard) ()  
  fb.KeyboardIsON = 1
  #ifdef __FB_CALLBACKS__
    fb_RemoveVsyncCallBack(@KeyboardShowHide)    
    fb_AddVsyncCallBack(@KeyboardShowHide,cast(any ptr,1),False)  
  #else
    fbKeyboard->offset_y = -192+fb.KeyboardOffset
    KeyboardShow()
  #endif
end sub
sub _FB_Inline_(fb_HideKeyboard) ()
  fb.KeyboardIsON = 0
  #ifdef __FB_CALLBACKS__
    fb_RemoveVsyncCallBack(@KeyboardShowHide)  
    fb_AddVsyncCallBack(@KeyboardShowHide,cast(any ptr,-1),False)
  #else
    fbKeyboard->offset_y = -192+0
    KeyboardHide()
  #endif
end sub

__private sub fb_exception cdecl ()
  printf(!"\nException!!! \n")
  sleep
end sub

__private sub _fb_ARM7_ResetDSi()  
  fb_i2cWriteRegister(I2C_PM, I2CREGPM_RESETFLAG, &h01) '// Bootflag = Warmboot/SkipHealthSafety
  fb_i2cWriteRegister(I2C_PM, I2CREGPM_PWRCNT   , &h01) '// Reset to DSi Menu
end sub

'causes a system reset (runs on arm7)
__private sub fb_system()
  NDS_Arm7Exec( @_fb_ARM7_ResetDSi , 0 )
end sub

scope
  
  #ifdef DebugMemoryUsage
    dim as integer __FB_Temp_Stack
    fb.InitialStack = cuint(@__FB_Temp_Stack)
  #endif
  
  videoSetModeSub(MODE_0_2D) : vramSetBankC(VRAM_C_SUB_BG)
  
  'consoleInit(@fbTopConsole, 3,BgType_Text4bpp, BgSize_T_256x256, 31, 0, true, true)
  'consoleInit(@fbBottomConsole, 0,BgType_Text4bpp, BgSize_T_256x256, 31, 0, false, true)
  
  '//limit sub memory to 48kb
  
  'fbKeyboard = 0
  '#ifdef fbKeyboardOnMain
  'fbKeyboard = keyboardInit(NULL, 3, BgType_Text4bpp, BgSize_T_256x512, 16, 0, true, true)
  '#else
        
  fbConsole = consoleInit(0, 0,BgType_Text4bpp, BgSize_T_256x256, 10, 2, false, true)
  fbKeyboard = keyboardInit(NULL, 3, BgType_Text4bpp, BgSize_T_256x256, 14, 0, false, true)  
    
  '#endif
  'if fbKeyboard = 0 then end
  if fbKeyboard then
    fbKeyboard->OnKeyPressed = @OnKeyPressed
    fbKeyboard->OnKeyReleased = @OnKeyReleased
    fbKeyboard->ScrollSpeed = 0
  end if
  
  scope 'copy data to the new ram mapping location
    'using malloc/free because console isnt ready yet to debug  them
    var pImg = malloc(48*1024)
    dmaCopyWords(2,&h06200000,pImg,48*1024)
    VRAM_C_CR = 0  
    vramSetBankH(VRAM_H_SUB_BG)
    vramSetBankI(VRAM_I_SUB_BG_0x06208000)
    dmaCopyWords(2,pImg,&h06200000,48*1024)
    free(pImg)
  end scope  
  
  VRAM_A_CR = 0 : VRAM_B_CR = 0  'Disable Vram Block A-B
  VRAM_C_CR = 0 : VRAM_D_CR = 0  'Disable Vram Block C-D
  ConsoleClear()
  
  'fbConsole = ConsoleDemoInit() '@fbBottomConsole
      
  setExceptionHandler(@fb_exception)
    
  'if *cast_vu32_ptr(&h4004008) then
  FBlib_Debug(!"Full DSi Flags")
  cast_vu32_ptr(&h4004008) = -1
  'RAM priority
  'cast_vu32_ptr(&h4000204) = (cast_vu32_ptr(&h4000204) and (not (1 shl 15)))
    
  FBlib_Debug(!"ConsoleDemoInit()\n")' : getchar()
  FBlib_Debug(!"Stack = %X\n",fb.InitialStack)
      
  soundEnable()
  FBlib_Debug(!"soundEnable\n")' : getchar()
  
  irqSet(IRQ_VBLANK, @vBlankInterrupt)
  irqEnable(IRQ_VBLANK)
  swiWaitForVBlank()
  
  FBlib_Debug(!"irqEnable (vBlankInterrupt)\n")' : getchar()
  
  dim as any ptr pTimerHandler = @TimerInterrupt 'cast(any ptr,1024)  
  'dim as any ptr InPtr = @TimerInterrupt
  'FastCopy(pTimerHandler,InPtr,240)  
  fb_Ticks = 0
  '(TIMER_FREQ(fb.TimerFreq))
  timerStart(0, ClockDivider_64, 0, pTimerHandler) '8hz
  #ifdef __FB_EXTRACALLBACKS__
    timerStart(3, ClockDivider_64, (TIMER_FREQ(1024*4)), @CallbackInterrupt)
  #endif  
  FBlib_Debug(!"timerStart\n")' : getchar()
  
  keysSetRepeat(40,3)
  ConsoleSelect(fbConsole)
  fb.KeyboardOffset = 192-abs(fbKeyboard->offset_y)  
  FBlib_Debug(!"ConsoleSelect(fbConsole)\n")' : getchar()
  
  dim as byte iGotFat = 0
  #ifdef __FB_FAT__      
    FBlib_Debug(!"Initializating FAT\n")
    if fatInitDefault()=0 then
      color 12:printf !"Failed to start FAT.\n"
    else
      iGotFat = 1
    end if  
    FBlib_Debug(!"FAT Init\n")' : getchar()
  #endif
    
  #ifndef __FB_NO_NITRO__
    #ifdef __FB_NITRO__  
      if iGotFat=0 then
        FBlib_Debug(!"Initializing Nitro\n")' : getchar()
        if nitroFSInit(@fb.pzEXEPATH)=0 then 
          color 12:printf !"Failed to start NitroFS.\n"
        else    
          'printf(!"NitroFS:'%s'\n",fb.pzEXEPATH)
          FBlib_Debug("chdir... ")
          chdir_ "nitro:/"    
          FBlib_Debug(!"ok!\n")
        end if
        FBlib_Debug(!"nitroFSInit()\n")' : getchar()
      end if
    #endif
  #endif
    
  FBlib_Debug(!"all set...\n")
  
  #if 0
    fb_ShowKeyboard()
    lcdMainOnTop()  
    cls  
    do
      locate 1,1
      printf("%i \r",keyBufferLength)    
    loop
  #endif  
  
  #if (not defined(__FB_GFX_NO_GL_RENDER__)) and defined(__FB_GFX_LAZYTEXTURE__)
    irqSet(IRQ_VCOUNT, @vCountInterrupt)    
  #endif
  SetYtrigger(192-48)
  irqEnable(IRQ_VCOUNT)
  
end scope


'#undef FastCopy