#include "PAT.bas"

const PLAYRATE = 1

enum PlayModes
  pmLegato = 1
  pmNormal = 2
  pmStacato = 4
  pmPercentage = 7
  pmBackground = 16  
end enum

declare sub AddNote(NOTE as integer,DURATION as single,MODE as integer)
declare sub Play(TEXT as string)

dim shared as integer OldChan=-1,NoteChan=-1
dim shared as integer PlayInstrument

sub PlayFlush()
  if NoteChan then SoundKill(NoteChan):NoteChan = -1
  if OldCHan then SoundKill(OldChan):OldChan = -1
end sub


sub AddNote(NOTE as integer,DURATION as single, MODE as integer)
  
  static as integer Legato,PlayingFreq
  static as double TMRNOTE,NOTSZ,PASZ  
  dim as integer FLAG
  static as PatDSwave ptr PlayingNote,NewNote
  
  #macro SetNote(nNote)
  NewNote = 0
  for CNT as integer = 0 to PatDSWaveCount(PlayInstrument)-1
    with *PatDSWave(PlayInstrument,CNT)      
      if nNote >= .MinFreq\.FreqMultiplier then
        if nNote <= .MaxFreq\.FreqMultiplier then
          NewNote = PatDSWave(PlayInstrument,CNT): exit for
        end if
      end if
    end with
  next CNT
  if NewNote then
    with *NewNote
      dim as integer NewFreq = .Frequency*(nNote/(.OrgFreq/.FreqMultiplier))
      if NoteChan >= 0 then
        dim as integer NewChan    
        NewChan = soundPlaySample(NewNote+1,SoundFormat_ADPCM, _
        .LoopEnd-.LoopStart,NewFreq,127,64,True,.LoopStart\4)
        if OldChan <> -1 then SoundKill(OldChan)
        SwiDelay(11)
        SoundSetVolume(NoteChan,1)        
        OldChan = NoteChan: NoteChan = NewChan
      else
        NoteChan = soundPlaySample(NewNote+1,SoundFormat_ADPCM, _
        .LoopEnd-.LoopStart,NewFreq,127,64,True,.LoopStart\4)    
      end if
    end with
  end if
  PlayingNote = NewNote: PlayingFreq = nNote
  #endmacro
  #macro ResetNote()
  if NoteChan >= 0 then         
    SoundSetVolume(NoteChan,1):PlayingNote = 0    
    if OldChan <> -1 then SoundKill(OldChan): OldChan = -1
  end if  
  #endmacro
  
  TMRNOTE = timer  
  if DURATION=0 then exit sub
  
  if NOTE < 1 then    
    NOTSZ=0
    PASZ=DURATION
  else    
    LEGATO = 0
    select case MODE and pmPercentage  
    case pmLegato:  NOTSZ = DURATION: Legato = 1
    case pmNormal:  NOTSZ = DURATION*.75
    case pmStacato: NOTSZ = DURATION*.5
    case else:      NOTSZ = DURATION*.75
    end select 
    PASZ=DURATION-NOTSZ    
  end if
  
  'if abs(timer-TMRNOTE) > 1/64 then 
  if NOTSZ > 0 then        
    SetNote(NOTE)
    while (timer-TMRNOTE) <= NOTSZ
      swiIntrWait(1,IRQ_HBLANK) 'rem
    wend
    TMRNOTE += NOTSZ
  end if  
  
  if LEGATO = 0 or NOTSZ=0 then 
    ResetNote()  
  end if
  while (timer-TMRNOTE) <= PASZ
    swiIntrWait(1,IRQ_HBLANK) 'rem
  wend
  
  TMRNOTE += PASZ
  
end sub

' *******************************************************************
' *******************************************************************
' *******************************************************************
dim shared as single PLAYNOTES(142) = { 30.867, _ ' B-1 
0,32.703   ,0,36.708   ,0,41.203   ,0,43.653   ,0,48.999   ,0,55   ,0,61.735   , _ 'C0 B0
0,65.406   ,0,73.416   ,0,82.406   ,0,87.307   ,0,97.998   ,0,110  ,0,123.470  , _ 'C1 B1
0,130.812  ,0,146.832  ,0,164.813  ,0,174.614  ,0,195.997  ,0,220  ,0,246.941  , _ 'C2 B2
0,261.625  ,0,293.664  ,0,329.627  ,0,349.228  ,0,391.995  ,0,440  ,0,493.883  , _ 'C3 B3
0,523.251  ,0,587.329  ,0,659.255  ,0,698.456  ,0,783.990  ,0,880  ,0,987.766  , _ 'C4 B4
0,1046.502 ,0,1174.659 ,0,1318.510 ,0,1396.912 ,0,1567.981 ,0,1760 ,0,1975.533 , _ 'C5 B5
0,2093.004 ,0,2349.318 ,0,2637.020 ,0,2793.825 ,0,3135.963 ,0,3520 ,0,3951.066 , _ 'C6 B6
0,4186.008 ,0,4698.636 ,0,5274.040 ,0,5587.651 ,0,6271.926 ,0,7040 ,0,7902.131 , _ 'C7 B7
0,8372.016 ,0,9397.270 ,0,10548.083,0,11175.301,0,12543.855,0,14080,0,15804.263, _ 'C8 B8
0,16744.033,0,18794.542,0,21096.166,0,22350.605,0,25087.710,0,28160,0,31608.527, _ 'C9 B9
0,32768 }
sub Play(TEXT as string) 'Thread(ID as any ptr)
  
  ' middle frequencies
  if PLAYNOTES(1)=0 then
    for C as integer = 1 to 141 step 2
      PLAYNOTES(C) = (PLAYNOTES(C-1)+PLAYNOTES(C+1))/2 'semitons
    next C 
  end if
  
  #define CheckNote() if STPARM then STPLAY=1:goto _PlayNote_
  #macro ReadNumber(NUMB)
  NUMBSZ=0:NUMB=0:D=C+2
  while C<TXSZ andalso TEXT[C+1] >= 48 andalso TEXT[C+1] <= 57
    NUMBSZ += 1: C += 1
    NUMB = (NUMB*10)+(TEXT[C]-48)
  wend  
  #endmacro
  
  'static as integer LLCNT
  
  #macro AddNewNote()
  if STSIZE=0 then STSIZE=PL  
  NLEN = (((PLAYRATE*60)/(PT shr 2))*(1/STSIZE))*EXTRATOT
  'LLCNT = LLCNT+1
  'print LLCNT;" ";PLAYRATE;" ";PT;" ";STSIZE;" ";EXTRATOT;" ";csng(NLEN)
  if NOTE <> -1 then    
    NOTE += STCHG
    #ifdef MyDebug
    static as zstring ptr pExtra(4) = {@"",@".",@"..",@"...",@"...."}
    TMPSTR = str$(STSIZE)
    if STSIZE < 10 then TMPSTR = " "+TMPSTR
    print "Note:" & NOTENAME(NOTE)+*pExtra(EXTRA)+ _
    " Oct:" & PO & " Lnt:" & TMPSTR & _
    " ~" & MODENAME(PM and pmPercentage)    
    #endif
    FREQ = PlayNotes(2+((PO+1)*14)+NOTE)    
    AddNote(FREQ,NLEN,PM)
  else
    AddNote(0,NLEN,PM)
  end if
  STPARM=0:STSIZE=0:STCHG=0:STPLAY=0:NOTE=-1
  EXTRAATU=.5:EXTRATOT=1:EXTRA=0
  #endmacro
  
  #ifdef MyDebug
  static as zstring*3 NOTENAME(13) = { _
  "C","C#","D","D#","E","E#","F","F#","G","G#","A","A#","B","B#" }
  static as zstring*10 MODENAME(4) = {"","Legato","Normal","","Stacatto"}  
  dim as string TMPSTR
  #endif
  
  static as integer PT=120        'Playing quartes notes per minute
  static as integer PL=4          'Note length 1/2^(PL-1)
  static as integer PM=pmNormal   'play mode
  static as integer PO=3          'Oitave
  static as integer PI=1          'Play instrument
  static as integer NOTE=-1       'Note Playing
  static as integer STPARM        'Waiting Parameters
  static as integer STSIZE        'Already have size
  static as integer STCHG         'Already changed size
  static as double EXTRAATU=.5    'Extra size
  static as double EXTRATOT=1     'Extra total
  dim as integer STPLAY,EXTRA     'Go play!
  dim as integer TXSZ,NUMBSZ,C,D
  dim as double NLEN,PLEN        'Calculated length
  dim as double FREQ             'Note frequency
  
  TXSZ = cptr(uinteger ptr,@TEXT)[1]-1
  for CNT as integer = 0 to TXSZ
    if TEXT[CNT] >= asc("a") and TEXT[CNT] <= asc("z") then
      TEXT[CNT] -= 32
    end if
  next CNT
  
  for C = 0 to TXSZ
    
    _PlayNote_:    
    if STPLAY then
      AddNewNote()
    end if
    
    select case TEXT[C]
    case asc("M")               'MODES
      CheckNote()
      C += 1: if C > TXSZ then exit for      
      select case TEXT[C]
      case asc("B"),asc("F")    ' -> Background/Foreground
        if TEXT[C]=asc("B") then 
          PM or= pmBackground
        else
          PM and= (not pmBackground)
        end if
      case asc("L")             ' -> Legato
        PM= (PM and (not pmPercentage)) or pmLegato
        'print "Mode Legato"
      case asc("N")             ' -> Normal
        PM= (PM and (not pmPercentage)) or pmNormal
        'print "Mode Normal" 
      case asc("S")             ' -> Staccato
        PM= (PM and (not pmPercentage)) or pmStacato
        'print "Mode Stacato"
      end select
    case asc("T")              'TEMPO
      CheckNote()
      ReadNumber(PT)      
      'print "Tempo " & PT
      if NUMBSZ then if PT < 32 or PT > 255 then PT = 120      
    case asc("L")              'Length
      CheckNote()
      ReadNumber(PL)
      'print "Length " & PL
      if NUMBSZ then if PL < 1 or PL > 64 then PL = 4
    case asc("O")              'Octave
      CheckNote()
      ReadNumber(PO)
      if NUMBSZ then if PO < 0 or PO > 6 then PO = 3
      'print "Octave " & PO
    case asc("I")
      CheckNote()
      ReadNumber(PI)      
      if PI < 0 or PI > 127 then PI = 1
      PlayInstrument = PI
    case asc(">")              'Increase Octave
      CheckNote()
      if PO < 6 then PO += 1
      'print "Octave " & PO
    case asc("<")              'Decrease Octave
      CheckNote()
      if PO > 0 then PO -= 1
      'print "Octave " & PO
    case asc("P")              'Pause
      CheckNote()
      ReadNumber(STSIZE)
      if STSIZE > 0 and STSIZE < 64 then
        'print "Pause: " & STSIZE
        NOTE=-1: STPLAY = 1: goto _PlayNote_
      else
        STSIZE=0
      end if
    case asc("C") to asc("G")  'Notes C-G
      CheckNote()
      STPARM = -1
      NOTE = (TEXT[C]-asc("C"))*2
      'print "Note: " & NOTE
    case asc("A") to asc("B")  'Notes A-B
      CheckNote()
      STPARM = -1
      NOTE = (TEXT[C]-asc("A")+5)*2
      'print "Note: " & NOTE
    case asc("#"),asc("+")     'Above note (sutenido)
      if STPARM andalso STCHG=0 then 
        STCHG=1
      end if      
    case asc("-")              'Below note (bemol)
      if STPARM andalso STCHG=0 then 
        STCHG=-1
        'print "Bemol"
      end if
    case asc(".")              'extra 50%
      if STPARM then 
        EXTRATOT += EXTRAATU:EXTRAATU /= 2
        EXTRA += 1
        'print "Extra: " & fix(EXTRATOT*100)
      end if
    case asc("0") to asc("9")  'notesize
      if STPARM and STSIZE=0 then
        C -= 1
        'print cptr(zstring ptr,strptr(TEXT))[C]
        ReadNumber(STSIZE)        
        'print STSIZE
        if STSIZE < 1 or STSIZE > 64 then STSIZE=0        
      end if
    end select
    
  next C  
  
  if STPARM then
    AddNewNote()
  end if
  
end sub
