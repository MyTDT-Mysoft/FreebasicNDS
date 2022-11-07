type PatDSheader
  PatSignature     as uinteger
  InstrumentNumber as integer
  InstrumentName   as zstring*16
  WaveCount        as integer
  PatVolume        as integer
end type
type PatDSwave
  WaveSize         as uinteger
  LoopStart        as uinteger
  LoopEnd          as uinteger
  Frequency        as uinteger
  MinFreq          as uinteger
  MaxFreq          as uinteger
  OrgFreq          as uinteger
  WaveFlags        as uinteger
  FreqMultiplier   as uinteger
  Reserved(6)      as uinteger
end type

#if 0
function ReadShort(ShortPtr as any ptr) as uinteger
  dim as ubyte ptr Temp = ShortPtr
  return Temp[0]+(Temp[1] shl 8)
end function
function ReadInteger(IntPtr as any ptr) as uinteger
  dim as ubyte ptr Temp = IntPtr
  return Temp[0]+(Temp[1] shl 8)+(Temp[2] shl 16)+(Temp[3] shl 24)
end function
#endif

function LoadPAT(PatFile as PatDSheader ptr,OutputWaves as PatDSwave ptr ptr) as integer  
  dim WaveInfo as PatDSwave ptr = cast(any ptr,PatFile+1)  
  dim as integer WaveCount = PatFile->WaveCount  
  for WaveNum as integer = 0 to WaveCount-1
    OutputWaves[WaveNum] = WaveInfo    
    WaveInfo = cast(any ptr,WaveInfo+1)+WaveInfo->WaveSize    
  next WaveNum
  return WaveCount
end function

dim shared as PatDSwave ptr PatDSWave(127,31)
dim shared as integer PatDSWaveCount(127)

'DeclareResource(PAT000_pDS)
'PatDSWaveCount(0) = LoadPAT(cast(any ptr,PAT000_pDS),@PatDSWave(0,0))
DeclareResource(PAT001_pDS)
PatDSWaveCount(1) = LoadPAT(cast(any ptr,PAT001_pDS),@PatDSWave(1,0))
'DeclareResource(PAT006_pDS)
'PatDSWaveCount(6) = LoadPAT(cast(any ptr,PAT006_pDS),@PatDSWave(6,0))
'DeclareResource(PAT009_pDS)
'PatDSWaveCount(9) = LoadPAT(cast(any ptr,PAT009_pDS),@PatDSWave(9,0))
'DeclareResource(PAT025_pDS)
'PatDSWaveCount(25) = LoadPAT(cast(any ptr,PAT025_pDS),@PatDSWave(25,0))
'DeclareResource(PAT027_pDS)
'PatDSWaveCount(27) = LoadPAT(cast(any ptr,PAT027_pDS),@PatDSWave(27,0))
'DeclareResource(PAT053_pDS)
'PatDSWaveCount(53) = LoadPAT(cast(any ptr,PAT053_pDS),@PatDSWave(53,0))
'DeclareResource(PAT058_pDS)
'PatDSWaveCount(58) = LoadPAT(cast(any ptr,PAT058_pDS),@PatDSWave(58,0))
'DeclareResource(PAT059_pDS)
'PatDSWaveCount(59) = LoadPAT(cast(any ptr,PAT059_pDS),@PatDSWave(59,0))
'DeclareResource(PAT088_pDS)
'PatDSWaveCount(88) = LoadPAT(cast(any ptr,PAT088_pDS),@PatDSWave(88,0))

for CNT as integer = 0 to 127
  if PatDSWaveCount(CNT) = 0 then
    PatDSWaveCount(CNT) = PatDSWaveCount(1)
    for NUM as integer= 0 to 31
      PatDSWave(CNT,NUM) = PatDSWave(1,NUM)
    next NUM
  end if
next CNT
  
