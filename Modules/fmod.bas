#ifndef __FB_CALLBACKS__
  #error "fmod requires __FB_CALLBACKS__  defined before including fblib.bas"
#endif

const FSOUND_INIT_USEDEFAULTMIDISYNTH = 0
const FSOUND_INIT_GLOBALFOCUS = 0
const FSOUND_INIT_DONTLATENCYADJUST = 0

const FSOUND_HW3D        =   0
const FSOUND_LOOP_OFF    =   0
const FSOUND_NORMAL      =   0
const FSOUND_MONO        =   0
const FSOUND_16BITS      =   0
const FSOUDN_SIGNED      =   0
const FSOUND_LOOP_NORMAL =   1
const FSOUND_LOOP_BIDI   =   1
const FSOUND_8BITS       =   2
const FSOUND_STEREO      =   4
const FSOUND_UNSIGNED    =   8
const FSOUND_LOADRAW     = 256
const FSOUND_LOADMEMORY  = 512

const FSOUND_FREE = -1
const FSOUND_ALL = -1

#define FMUSIC_LoadSong(Nothing) 0
#define FMUSIC_PlaySong(Nothing)
#define FMUSIC_SetMasterVolume(A,B)
#define FSOUND_IsPlaying(Channel) -1

type FMUSIC_MODULE as any ptr
type Fsound_Sample as any ptr

type FWAVE_Chunk
  as ulong lID
  as ulong lSize
end type
type FWAVE_FileHdr
  as ulong lRIFF     'cvl("RIFF")
  as long  lSize     'file size -8
  as ulong lWave     'cvl("WAVE")
  tChunk as FWAVE_Chunk 
  'as ulong lFormat   'cvl("fmt ")
  'as ulong lFmtSz    'sizeof(WAVEFORMAT) / sizeof(WAVEFORMATEX)
end type
type FWAVE_FormatEx field=1
  as ushort wFormatTag 
  as ushort nChannels
  as ulong  nSamplesPerSec 
  as ulong  nAvgBytesPerSec
  as ushort nBlockAlign
  as ushort wBitsPerSample
  as ushort cbSize
  union
    as short AdpcmSample
    as ubyte  bData(239-1)
  end union
end type
type FSOUND_SampleInfo
  Signature as integer
  Frequency as integer  
  Size      as integer
  Format    as ubyte
  LoopMode  as ubyte
  Volume    as ubyte
  Pan       as ubyte
  'pCallback as any ptr
end type
type FSOUND_AsyncStruct
  pData     as any ptr
  pSample   as any ptr
  Remaining as ulong  
  File      as ubyte
  Format    as ubyte
  BlockSz   as ushort
end type
  

static shared as any ptr FSOUND_Channels(15)
static shared as FSOUND_AsyncStruct FSOUND_Async
dim shared as uinteger FSOUND_InitFrequency

function FSOUND_Init(Freq as integer,Chans as integer,Flags as integer) as integer
  if Freq < 8000 or Freq > 65536 then 
    SoundDisable()
    FSOUND_InitFrequency = 0
    return 0
  end if
  FSOUND_InitFrequency = Freq
  soundEnable()
  Return 1
end function

sub FSOUND_SetVolume(iChannel as integer,iVolume as integer)  
  if iVolume < 0 then iVolume = 0
  if iVolume > 255 then iVolume = 255
  if iChannel < 1 then
    for CNT as integer = 0 to 15
      soundSetVolume(CNT,(iVolume shr 1) or (iVolume shr 7))
    next CNT
  elseif iChannel <= 16 then
    soundSetVolume(iChannel-1,(iVolume shr 1) or (iVolume shr 7))
  end if
end sub

sub FSOUND_SetFrequency(iChannel as integer,iFrequency as integer)
  if iFrequency < 32 then iFrequency = 32
  if iFrequency > 65536*2 then iFrequency = 65536*2
  soundSetFreq(iChannel-1,iFrequency)
end sub

sub FSOUND_StopSound(iChannel as integer)
  if iChannel < 1 then
    for CNT as integer = 0 to 15
      SoundKill(CNT)
    next CNT
  elseif iChannel <= 16 then
    SoundKill(iChannel-1)
  end if
end sub

sub FSOUND_LoadCallBack(ID as any ptr)
  with FSOUND_Async        
    var iLoaded = 0
    do
      if .Remaining > .BlockSz then      
        Get #.File,,*cptr(ubyte ptr,.pData),.BlockSz
        if .Format = SoundFormat_8Bit then
          dim as uinteger ptr SD = cast(any ptr,.pData)        
          for CNT as integer = 0 to (.BlockSz\4)-1
            *SD xor= &h80808080: SD += 1
          next CNT
        end if
        .pData += iif(.Format=SoundFormat_ADPCM,(.BlockSz-4),.BlockSz)
        .Remaining -= .BlockSz
      else
        get #.File,,*cptr(ubyte ptr,.pData),.Remaining    
        if .Format = SoundFormat_8Bit then
          dim as uinteger ptr SD = .pData
          for CNT as integer = 0 to (.Remaining shr 2)-1
            *SD xor= &h80808080: SD += 1
          next CNT
        end if
        .pData=0:.Remaining=0
        .pSample=0:close #.File
        fb_RemoveVsyncCallBack(@FSOUND_LoadCallBack)
        exit do
      end if
      iLoaded += .BlockSz
    loop until iLoaded >= 1024
    'printf(!"%i    \r",.Remaining)
  end with
end sub
sub FSOUND_Sample_Free(Sample as any ptr)  
  if Sample=0 then exit sub
  with FSOUND_Async
    if .pSample=Sample then
      fb_RemoveVsyncCallBack(@FSOUND_LoadCallBack)    
      if .pData then close #.File: .pData=0: .pSample = 0          
    end if  
  end with
  with *cptr(FSOUND_SampleInfo ptr,Sample)
    if .Signature = cvi("fSND") then      
    Deallocate(Sample)
  end if
  end with
end sub

function FSOUND_Sample_Load(CHAN as integer,FileName as zstring ptr,LoopMode as integer,LoopStart as integer,LoopEnd as integer) as any ptr
  dim as string TempString
  dim as integer SampleFile,FileSize
  dim as any ptr TempSample
  dim as ubyte ptr SampleData
  dim as integer SoundFreq
  dim as short SoundChan,SoundBits
  dim as integer AdpcmSample
    
  if (LoopMode and FSOUND_LOADMEMORY) then
    if FileName <= 0 then return 0
    if LoopEnd <= 0 then return 0
    if (LoopMode and FSOUND_LOADRAW) = 0 then return 0
    SampleFile = -1: FileSize = LoopEnd
    TempSample = callocate(Sizeof(FSOUND_SampleInfo)+FileSize+4)  
    if TempSample = 0 then return 0
    SoundChan = iif(LoopMode and FSOUND_STEREO,2,1)
    SoundFreq = FSOUND_InitFrequency
    SoundBits =  iif(LoopMode and FSOUND_8BITS,8,16)
    SampleData = TempSample+Sizeof(FSOUND_SampleInfo)
  else 'Load from filename
    if FileName then TempString = *FileName else return 0  
    SampleFile = freefile()
    if open(TempString for binary access read as #SampleFile) then return 0  
    
    dim tChunk as FWAVE_Chunk = any   
    const MinFmtSz = offsetof(FWAVE_FormatEx,cbSize)
    FileSize = lof(SampleFile)
    if FileSize <= (sizeof(FWAVE_FileHdr)+MinFmtSz) then 
      puts("too small wave file")
      close #SampleFile:return 0  
    end if
    scope 'get/check file header
      dim tHdr as FWAVE_FileHdr  = any
      get #SampleFile,,tHdr
      with tHdr
        if .lRIFF <> cvl("RIFF") orelse .lWave <> cvl("WAVE") then
          puts("invalid .wav file")
          close #SampleFile:return 0  
        end if
        tChunk = tHdr.tChunk
      end with
    end scope
    do      
      if eof(SampleFile) then
        puts("premature end of .wav file")        
        close #SampleFile:return 0  
      end if
      select case tChunk.lID
      case cvl("fmt ")
        dim tFmt as FWAVE_FormatEx = any
        if tChunk.lSize < MinFmtSz orelse tChunk.lSize > sizeof(FWAVE_FormatEx) then
          printf(!"bad 'fmt ' sz=%i\n",tChunk.lSize)
          close #SampleFile:return 0
        end if        
        get #SampleFile,,*cptr(ubyte ptr,@tFmt),tChunk.lSize
        with tFmt  
          if .wFormatTag <> &h0001 andalso .wFormatTag <> &h0011 then 'PCM
            printf(!"unknown wave tag %04X\n",.wFormatTag)
            close #SampleFile:return 0  
          end if
          SoundChan = .nChannels
          SoundFreq = .nSamplesPerSec
          SoundBits = .wBitsPerSample
          if tChunk.lSize > MinFmtSz andalso .cbSize then
            printf(!"Extra Size = %i\n",.cbSize)            
          end if
          var iAlign = (.nChannels*.wBitsPerSample)\8
          if .nBlockAlign <> iAlign then printf(!"Block Align= %i\n",.nBlockAlign)
          if .wFormatTag = &h0011 then 'ADPCM
            AdpcmSample = .nBlockAlign '.AdpcmSample
          end if
        end with
      case cvl("data"),cvl("DATA")
        exit do
      case else
        'dim as zstring*8 zID = any
        '*cptr(ulong ptr,@zID) = tChunk.lID : zID[4]=0
        'printf(!"ID=%s Sz=%i (skip)\n",zID,tChunk.lSize) : sleep
        seek #SampleFile,cint(seek(SampleFile))+tChunk.lSize        
      end select
      get #SampleFile,,tChunk
    loop
 
    FileSize = tChunk.lSize
    TempSample = callocate(Sizeof(FSOUND_SampleInfo)+tChunk.lSize+8)  
    if TempSample = 0 then close #SampleFile:return 0
    SampleData = TempSample+Sizeof(FSOUND_SampleInfo)    
  end if

  if SoundChan <> 1 then 
    printf !"MultiChannel Waves not yet...\n"
  end if
  if SoundFreq < 8000 or SoundFreq > 44100 then
    printf "Bad sound frequency: " & SoundFreq & !"\n"
  end if
  if SoundBits <> 16 and SoundBits <> 8 andalso SoundBits <> 4 then
    printf "Bad sound bits: " & SoundBits & !"\n"
  end if
  
  with *cptr(FSOUND_SampleInfo ptr,TempSample)
    .Signature = cvi("fSND")
    .Frequency = SoundFreq
    .Size = FileSize : .LoopMode = (LoopMode and 1)
    .Volume = 127 : .Pan = 64
    select case SoundBits
    case  4
      .Format = SoundFormat_ADPCM 'IMA-ADPCM
      .Size = (FileSize-((FileSize\AdpcmSample)*4))+4
    case  8
      .Format = SoundFormat_8Bit  '8 Bits
      while (FileSize and 3) 'make multiple of 4 bytes
        cptr(ubyte ptr,TempSample)[FileSize] = cptr(ubyte ptr,TempSample)[FileSize-1]
        FileSize += 1
      wend
    case 16
      .Format = SoundFormat_16Bit '16 bits
      FileSize and= (not 1) 'force align fix
      while (FileSize and 3) 'make multiple of 4 bytes
        cptr(ushort ptr,TempSample)[FileSize] = cptr(ushort ptr,TempSample)[FileSize-2]
        FileSize += 2
      wend
    end select    
  end with
  
  if SampleFile < 0 then
    memcpy(SampleData,FileName,FileSize)
    dim as uinteger ptr SD = cast(any ptr,SampleData)
    if SoundBits=8 then
      for CNT as integer = 0 to (FileSize shr 2)-1
        *SD xor= &h80808080: SD += 1
      next CNT
    end if
  elseif FileSize > 128*1024 then
    with FSOUND_Async
      if .pData then
        fb_RemoveVsyncCallBack(@FSOUND_LoadCallBack)
        if .pData then        
          if .Format = SoundFormat_ADPCM then
            while .Remaining > 0
              get #SampleFile,,*cptr(ubyte ptr,.pData),iif(.Remaining>.BlockSz,.BlockSz,.Remaining)
              .pData += (.BlockSz-4) : .Remaining -= .BlockSz
            wend
          else
            get #.File,,*cptr(ubyte ptr,.pData),.Remaining            
            if .Format = SoundFormat_8Bit then
              dim as uinteger ptr SD = cast(any ptr,.pData)
              for CNT as integer = 0 to (.Remaining shr 2)-1
                *SD xor= &h80808080: SD += 1
              next CNT
            end if
          end if
          close #.File: .pData=0: .pSample = 0
        end if
      end if            
      .pData = SampleData: .Remaining = FileSize
      .File = SampleFile: .pSample = TempSample    
      .Format = cptr(FSOUND_SampleInfo ptr,TempSample)->Format
      .BlockSz = iif(SoundBits=4,AdpcmSample,1024)
      if SoundBits=4 then Get #.File,,*cptr(ubyte ptr,.pData),4
      var iLoaded = 0
      do
        Get #.File,,*cptr(ubyte ptr,.pData),.BlockSz
        if .Format = SoundFormat_8Bit then
          dim as uinteger ptr SD = cast(any ptr,.pData)
          for CNT as integer = 0 to (.BlockSz shr 2)-1
            *SD xor= &h80808080: SD += 1
          next CNT
        end if
        .pData += iif(SoundBits=4,.BlockSz-4,.BlockSz): .Remaining -= .BlockSz
        iLoaded += .BlockSz
      loop until iLoaded >= 1024 orelse .Remaining <= 0
      fb_AddVsyncCallBack(@FSOUND_LoadCallBack,0,True)
    end with
  else
    if SoundBits=4 then
      #if 0
        cptr(short ptr,SampleData)[0] = AdpcmSample 
        cptr(short ptr,SampleData)[1] = 0
        get #SampleFile,,SampleData[sizeof(short)*2],FileSize
      #endif
      var pData = SampleData, Remaining = cint(FileSize)
      get #SampleFile,,*pData,4 : Remaining -= 4 : pData += 4
      while Remaining > 0
        get #SampleFile,,*pData,iif(Remaining>AdpcmSample,AdpcmSample,Remaining)
        pData += (AdpcmSample-4) : Remaining -= AdpcmSample
      wend
    else
      get #SampleFile,,*SampleData,FileSize
    end if
    if SoundBits = 8 then
      dim as uinteger ptr SD = cast(any ptr,SampleData)
      for CNT as integer = 0 to (FileSize shr 2)-1
        *SD xor= &h80808080: SD += 1
      next CNT
    end if
    close #SampleFile
  end if    
  
  return TempSample
end function

function FSOUND_PlaySound(CHAN as integer,Sample as any ptr) as integer  
  dim as integer TempChannel
  if Sample=0 then return 0
  with *cptr(FSOUND_SampleInfo ptr,Sample)
    if .Signature <> cvi("fSND") then return 0    
    TempChannel = soundPlaySample(Sample+sizeof(FSOUND_SampleInfo), _
    .Format,.Size,.Frequency,.Volume,.Pan,.LoopMode,0)+1
    FSOUND_Channels(TempChannel) = Sample
    return TempChannel
  end with
end function

function FSOUND_Sample_SetDefaults(Sample as any ptr,DefFreq as integer,DefVol as integer,DefPan as integer,DefPri as integer) as integer
  with *cptr(FSOUND_SampleInfo ptr,Sample)
    if .Signature <>  cvi("fSND") then return 0
    if DefFreq <> -1 then .Frequency = DefFreq
    if DefVol <> -1 then .Volume = DefVol shr 1
    if DefPan <> -1 then .Pan = DefPan shr 1
  end with
end function

sub FSOUND_Update()
  'nothing do to yet? :)
end sub

sub FSOUND_Close()
  'nothing do to? :)
end sub
