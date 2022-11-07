#define fbc 
'-x f:\devkitpro\Project\Cprocessor.exe

#include "windows.bi"

dim as integer MyFile = freefile()
dim as string Fname = command$()
if open(Fname for binary access read as #MyFile)=0 then    
  dim as integer fsize = lof(MyFile)
  'print "File size: " & fsize
  dim as string MyLine = space(fsize)  
  get #MyFile,1,*cptr(ubyte ptr,strptr(MyLine)),fsize   
  dim as integer ResultC = instr(1,MyLine,"static void fb_ctor__main( void )")
  dim as integer Result = instr(1,MyLine,"static inline integer fb_dtosi")
  dim as integer ResultA = instr(1,MyLine,"static inline longint fb_dtosl")
  dim as integer ResultB = instr(1,MyLine,"static inline integer fb_ftosi")
  dim as integer ResultE = instr(1,MyLine,"static inline longint fb_ftosl")
  dim as integer ResultD = instr(1,MyLine,"typedef struct _string { char *data; int len; int size; } string;")  
  dim as integer ResultF = instr(1,MyLine,"typedef char byte;")  
  if ResultC = 0 then print "ERROR: ResultC not found!":sleep:end
  if Result  = 0 then print "WARNING: Result not found!"
  if ResultA = 0 then print "WARNING: ResultA not found!"
  if ResultB = 0 then print "WARNING: ResultB not found!"
  if ResultD = 0 then print "WARNING: ResultD not found!"
  if ResultF = 0 then print "WARNING: ResultF not found!"
  'print "Result: " & Result
  close #MyFile
  
  if ResultF then
    mid$(MyLine,ResultF) = !"typedef char ubyte;\r\ntypedef   signed char byte;"
  end if  
  if ResultD orelse ResultC orelse Result orelse ResultB orelse ResultA then    
    'if ResultE then
    '  if MyLine[0] <> 32 and MyLine[0] <> 9 then        
    '    MyLine = "static inline "+MyLine
    '  end if
    'end if
    if ResultC then
      var sText = "static void fb_ctor__main( void ) ; //"
      mid$(MyLine,ResultC,len(sText)) = sText
      'MyLine = left$(MyLine,ResultC-1) + _
      '"static void fb_ctor__main( void ) ; //" + _
      'mid$(MyLine,ResultC+65)
    end if
    if Result then
      Result = instr(1,MyLine,"static inline integer fb_dtosi")
      dim as integer Result2 = instr(Result,MyLine,"}")
      'print "Result2: " & Result2
      if Result2 then
        MyLine = left$(MyLine,Result-1) + _
        "#define fb_dtosi( temp_double ) ((integer)__builtin_lrint(temp_double))"+  _       
        mid$(MyLine,Result2+1)
        '"#define fb_dtosi( temp_double ) (((temp_double) > 0) ? ((int)(temp_double+.5)) : ((int)(temp_double-.5)))" + _
      end if      
    end if
    if ResultA then                                    
      ResultA = instr(1,MyLine,"static inline longint fb_dtosl")            
      dim as integer Result2 = instr(ResultA,MyLine,"}")
      'print "Result2: " & Result2
      if Result2 then
        MyLine = left$(MyLine,ResultA-1) + _
        "#define fb_dtosl( temp_double ) ((longint)__builtin_llrint(temp_double))"+  _       
        mid$(MyLine,Result2+1)
        '"#define fb_dtosi( temp_double ) (((temp_double) > 0) ? ((int)(temp_double+.5)) : ((int)(temp_double-.5)))" + _
      end if      
    end if
    if ResultB then
      ResultB = instr(1,MyLine,"static inline integer fb_ftosi")
      dim as integer Result2 = instr(ResultB,MyLine,"}")
      'print "Result2: " & Result2
      if Result2 then
        MyLine = left$(MyLine,ResultB-1) + _
        "#define fb_ftosi( temp_double ) ((int)__builtin_lrintf(temp_double))"+ _       
        mid$(MyLine,Result2+1)
        '"#define fb_ftosi( temp_double ) (((temp_double) > 0) ? ((int)(temp_double+.5)) : ((int)(temp_double-.5)))" + _
      end if
    end if 
    if ResultE then
      ResultE = instr(1,MyLine,"static inline longint fb_ftosl")
      dim as integer Result2 = instr(ResultE,MyLine,"}")
      'print "Result2: " & Result2
      if Result2 then
        MyLine = left$(MyLine,ResultE-1) + _
        "#define fb_ftosl( temp_double ) ((longint)__builtin_llrintf(temp_double))"+ _       
        mid$(MyLine,Result2+1)
        '"#define fb_ftosi( temp_double ) (((temp_double) > 0) ? ((int)(temp_double+.5)) : ((int)(temp_double-.5)))" + _
      end if
    end if 
    if ResultD then
      instr(1,MyLine,"typedef struct _string { char *data; int len; int size; } string;")  
      mid$(MyLine,ResultD) = "typedef struct Fstring { char *data; int len; int size; } string;"
    end if
  end if
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__FB_ARRAYDESC$ *")
      if NEWPOSI = 0 or NEWPOSI > ResultC then exit do
      mid$(MyLine,NEWPOSI,17) = "           void *"
      POSI = NEWPOSI+17
    loop
  end scope
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__attribute__((gcc_struct))")
      if NEWPOSI = 0 then exit do
      mid$(MyLine,NEWPOSI,27) = "                           "
      POSI = NEWPOSI+27
    loop
  end scope
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__attribute__(( constructor ))")
      if NEWPOSI = 0 then exit do
      mid$(MyLine,NEWPOSI,30) = "                              "
      POSI = NEWPOSI+30
    loop
  end scope

  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__attribute__((constructor))")
      if NEWPOSI = 0 then exit do
      mid$(MyLine,NEWPOSI,28) = "                              "
      POSI = NEWPOSI+28
    loop
  end scope
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"string *")
      if NEWPOSI = 0 or NEWPOSI > ResultC then exit do
      mid$(MyLine,NEWPOSI,8) = "  void *"
      POSI = NEWPOSI+8
    loop
  end scope
  
  #if 0
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"string*")
      if NEWPOSI = 0 or NEWPOSI > ResultC then exit do
      select case MyLine[NEWPOSI-2]
      case 9,10,asc(" "),asc("("),
      mid$(MyLine,NEWPOSI,7) = "  void*"
      POSI = NEWPOSI+7
    loop
  end scope
  #else
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,chr$(10)+"string*")
      if NEWPOSI = 0 or NEWPOSI > ResultC then exit do
      mid$(MyLine,NEWPOSI,8) = chr$(10)+"  void*"
      POSI = NEWPOSI+8
    loop
  end scope
  #endif
    
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,chr$(10)+", string*")
      if NEWPOSI = 0 or NEWPOSI > ResultC then exit do
      mid$(MyLine,NEWPOSI,10) = chr$(10)+"  , void*"
      POSI = NEWPOSI+10
    loop
  end scope
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__FB__INLINE__")  
      if NEWPOSI = 0 then exit do            
      dim as integer LINEPOSI = instrrev(MyLine,chr$(10),NEWPOSI)+1
      if MyLine[LINEPOSI-1] <> 32 and MyLine[LINEPOSI-1] <> 9 then
        dim as integer LINESIZE = (NEWPOSI-LINEPOSI)
        mid$(MyLine,LINEPOSI,LINESIZE+14) = _
        "static inline " + mid$(MyLine,LINEPOSI,LINESIZE)
      else
        dim as integer LINEEND = instr(NEWPOSI,MyLine,chr$(10))-1
        dim as integer LINESIZE = (LINEEND-NEWPOSI)
        mid$(MyLine,NEWPOSI,LINESIZE) = _
        mid$(MyLine,NEWPOSI+14,LINESIZE-14)+"              "
      end if
      POSI = NEWPOSI+14
    loop
  end scope
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"__FB__STATIC__")  
      if NEWPOSI = 0 then exit do            
      dim as integer LINEPOSI = instrrev(MyLine,chr$(10),NEWPOSI)+1
      if MyLine[LINEPOSI-1] <> 32 and MyLine[LINEPOSI-1] <> 9 then
        dim as integer LINESIZE = (NEWPOSI-LINEPOSI)
        mid$(MyLine,LINEPOSI,LINESIZE+14) = _
        "static        " + mid$(MyLine,LINEPOSI,LINESIZE)
      else
        dim as integer LINEEND = instr(NEWPOSI,MyLine,chr$(10))-1
        dim as integer LINESIZE = (LINEEND-NEWPOSI)
        mid$(MyLine,NEWPOSI,LINESIZE) = _
        mid$(MyLine,NEWPOSI+14,LINESIZE-14)+"              "
      end if
      POSI = NEWPOSI+14
    loop
  end scope
  
  scope
    dim as integer POSI = 1    
    do
      'dim as integer NEWPOSI = instr(POSI,MyLine,"__attribute__((stdcall)) fb_")  
      dim as integer NEWPOSI = instr(POSI,MyLine," fb_")  
      if NEWPOSI = 0 or NEWPOSI > ResultC  then exit do
      POSI = NEWPOSI+4 '32
      'if mid(MyLine,NEWPOSI,len(" fb_GfxFlip")) = " fb_GfxFlip" then continue do
      dim as integer LINEPOSI = instrrev(MyLine,chr$(10),NEWPOSI)+1
      mid$(MyLine,LINEPOSI,2) = "//"            
    loop
  end scope  
  
  scope
    dim as integer POSI = 1
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"integer fb_ArrayRedimEx( struct __FB_ARRAYDESC$*")  
      if NEWPOSI = 0 or NEWPOSI > ResultC  then exit do            
      dim as integer LINEPOSI = instrrev(MyLine,chr$(10),NEWPOSI)+1
      mid$(MyLine,LINEPOSI,2) = "//"      
      POSI = NEWPOSI+32
    loop
  end scope  
  
  scope    
    dim as integer POSI = 1    
    do
      dim as integer NEWPOSI = instr(POSI,MyLine,"fb_StrAllocTempDescZEx( (char*)"""", 0 );")
      if NEWPOSI = 0 then exit do
      mid$(MyLine,NEWPOSI,39) = "0;                                     "      
      POSI = NEWPOSI+39
    loop
  end scope
  
  if open(Fname for binary access write as #MyFile)=0 then  
    put #MyFile,1,*cptr(ubyte ptr,strptr(MyLine)),len(MyLine)
    Close #MyFile
  end if
end if

