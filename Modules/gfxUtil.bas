declare sub palcopy (OFFSETPALETEA as integer ptr,OFFSETPALETEB as integer ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
declare sub palchange (OFFSETPALETEA as any ptr, OFFSETPALETEB as any ptr, PERCENTAGE as single, STARTCOLOR as integer=0, ENDCOLOR as integer=255)
declare sub PalRotate (OFFSETPALETE as integer ptr,ROTATESTEP as integer,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
declare sub palset (OFFSETPALETE as any ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
declare sub palfade (OFFSETPALETE as any ptr,PERCENTAGE as integer,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
declare sub palget (OFFSETPALETE as any ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)

dim shared as integer TTTXXX,XXTMPPALXX(255)

sub PalRotate (OFFSETPALETE as integer ptr,ROTATESTEP as integer,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
  static as integer PALBACK(255),ATUCOLOR,QTCOR,QTSUM
  if STARTCOLOR > ENDCOLOR then swap STARTCOLOR,ENDCOLOR
  QTCOR = (ENDCOLOR-STARTCOLOR)
  ROTATESTEP = ROTATESTEP mod QTCOR
  if ROTATESTEP = 0 then exit sub
  for ATUCOLOR = STARTCOLOR to ENDCOLOR
    PALBACK(ATUCOLOR-STARTCOLOR) = *(OFFSETPALETE+ATUCOLOR)
  next ATUCOLOR
  if ROTATESTEP < 0 then
    for ATUCOLOR = 0 to QTCOR
      *(OFFSETPALETE+STARTCOLOR+ATUCOLOR) = _
      PALBACK(((ATUCOLOR-ROTATESTEP) mod (QTCOR)))    
    next ATUCOLOR
  else
    for ATUCOLOR = 0 to QTCOR
      *(OFFSETPALETE+STARTCOLOR+ATUCOLOR) = _
      PALBACK(((ATUCOLOR-ROTATESTEP+QTCOR) mod (QTCOR)))
    next ATUCOLOR
  end if  
end sub
  
sub palcopy (OFFSETPALETEA as integer ptr,OFFSETPALETEB as integer ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
  static as integer ATUCOLOR
  if STARTCOLOR > ENDCOLOR then swap STARTCOLOR,ENDCOLOR
  for ATUCOLOR = STARTCOLOR to ENDCOLOR
    *(OFFSETPALETEB+ATUCOLOR) = *(OFFSETPALETEA+ATUCOLOR)
  next ATUCOLOR
end sub

sub palfade (OFFSETPALETE as any ptr,PERCENTAGE as integer,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
  dim as integer ATUCOLOR,R,G,B
  if PERCENTAGE < 0 or PERCENTAGE > 100 then exit sub
  if STARTCOLOR > ENDCOLOR then swap STARTCOLOR,ENDCOLOR 
  for ATUCOLOR = STARTCOLOR to ENDCOLOR
    dim as uinteger Temp = cptr(uinteger ptr,OffsetPalete)[ATUCOLOR]
    B = ((Temp and 255)*PERCENTAGE)\100
    G = (((Temp shr 8) and 255)*PERCENTAGE)\100
    R = (((Temp shr 16) and 255)*PERCENTAGE)\100
    palette ATUCOLOR,rgba(R,G,B,0)
  next ATUCOLOR  
end sub

sub palget (OFFSETPALETE as any ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
  static as integer ATUCOLOR,R,G,B
  static as any ptr OFFSET
  if STARTCOLOR > ENDCOLOR then swap STARTCOLOR,ENDCOLOR  
  palette get using XXTMPPALXX
  OFFSET = OFFSETPALETE + STARTCOLOR * 4
  for ATUCOLOR = STARTCOLOR to ENDCOLOR
    B = (XXTMPPALXX(ATUCOLOR) shr 16) and 255
    G = (XXTMPPALXX(ATUCOLOR) shr 8) and 255
    R = (XXTMPPALXX(ATUCOLOR)) and 255
    poke OFFSET, R
    OFFSET = OFFSET + 1
    poke OFFSET, G
    OFFSET = OFFSET + 1
    poke OFFSET, B
    OFFSET = OFFSET + 2
  next ATUCOLOR
end sub

sub palset (OFFSETPALETE as any ptr,STARTCOLOR as integer=0,ENDCOLOR as integer=255)
  dim as integer ATUCOLOR,R,G,B  
  if STARTCOLOR > ENDCOLOR then swap STARTCOLOR,ENDCOLOR 
  for ATUCOLOR = STARTCOLOR to ENDCOLOR
    dim as uinteger Temp = cptr(uinteger ptr,OffsetPalete)[ATUCOLOR]
    B = (Temp and 255)
    G = ((Temp shr 8) and 255)
    R = ((Temp shr 16) and 255)
    palette ATUCOLOR,rgba(R,G,B,0)
  next ATUCOLOR  
end sub
