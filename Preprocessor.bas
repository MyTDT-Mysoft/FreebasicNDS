dim as string LLine,MyLine,Fname = command$()
dim as zstring*5 Registers(...) = {"r0","r1","r2","r3","r4","r5","r6","r7", _
"r8","r9","r10","r11","r12","r13","r14","sp","lr","cpsr" }
'"r15","pc","spsr"
dim as integer NewFile,MyFile,LastPoint
dim as byte Chars(255)

Chars(asc("_")) = 1
for CNT as integer = asc("A") to asc("Z")
  Chars(CNT) = 1
  Chars(CNT or 32) = 1
next CNT
for CNT as integer = asc("0") to asc("9")
  Chars(CNT) = 1
next CNT

MyFile = freefile()
open Fname for input as #MyFile
NewFile = freefile()
open "main.bas" for output as #NewFile
print #NewFile,"#undef allocate"
print #NewFile,"#undef callocate"
print #NewFile,"#undef reallocate" 
print #NewFile,"#undef deallocate"

while not eof(MyFile)
  line input #1,MyLine
  print #NewFile, MyLine
  if lcase$(left$(trim$(MyLine),3)) = "asm" then
    dim as byte UsedRegs(ubound(Registers))
    dim as string VarsRead,VarsWrite,Regs,Ident
    LastPoint = seek(MyFile)    
    redim as integer ParmNums(15)
    dim as integer TotalCount,ReadCount,WriteCount
    
    'print MyLine
    
    do
      dim as integer IsRead,IsMemory
      if eof(1) then exit while
      line input #1,MyLine
      LLine = lcase$(MyLine)
      if left$(ltrim$(LLine),7) = "end asm" then         
        seek #MyFile, LastPoint
        exit do
      end if
      
      for CNT as integer = 1 to len(LLine)
        'print mid$(LLine,CNT)
        for REG as integer = 0 to ubound(Registers)
          dim as integer RegSZ = len(Registers(REG))
          if mid$(LLine,CNT,RegSZ) = Registers(REG) then
            if Chars(LLine[CNT-2]) = 0 then
              if Chars(LLine[CNT+RegSZ-1]) = 0 then
                UsedRegs(REG) = 1
                CNT += (RegSZ-1): exit for
              end if
            end if
          end if
        next REG
        if IsRead = 0 then
          if mid$(LLine,CNT,3) = "ldr" andalso Chars(LLine[CNT-2]) = 0 then
            IsRead = 1: IsMemory = 1
          elseif mid$(LLine,CNT,3) = "str" andalso Chars(LLine[CNT-2]) = 0 then
            IsRead  = -1: IsMemory = 1
          elseif LLine[CNT-1] = asc(",") then
            IsRead = 1
          end if
        end if
        if LLine[CNT-1] = asc("'") then exit for
        if LLine[CNT-1] = asc("$") then          
          dim as integer Posi
          for Posi = CNT to len(LLine)
            if Chars(LLine[Posi]) = 0 then              
              if IsRead = 1 then
                if len(VarsRead) then VarsRead += " , "
                if Ismemory then VarsRead += """m"" (" else VarsRead += """r"" ("
                VarsRead += mid$(MyLine,CNT+1,Posi-CNT)+"$)"
                ParmNums(TotalCount) = -(ReadCount+1)
                ReadCount += 1
              else
                if len(VarsWrite) then VarsWrite += " , "
                if Ismemory then VarsWrite += """=m"" (" else VarsWrite += """=r"" ("
                VarsWrite += mid$(MyLine,CNT+1,Posi-CNT)+"$)"
                ParmNums(TotalCount) = WriteCount+1
                WriteCount += 1
              end if              
              TotalCount += 1
              if (TotalCount and 15) = 0 then
                redim preserve ParmNums(TotalCount or 15)
              end if
              CNT = Posi: exit for                
            end if            
          next Posi
        end if
        'print
      next CNT      
      
    loop 
    
    for CNT as integer = 0 to TotalCount-1            
      if ParmNums(CNT) < 0 then
        ParmNums(CNT) = ((-ParmNums(CNT))-1)+WriteCount
      else
        ParmNums(CNT) -= 1
      end if      
    next CNT
    
    dim as integer VarCount      
    do
      dim as Integer EndPosi = -1
      if eof(1) then exit while
      line input #1,MyLine
      LLine = lcase$(MyLine)      
      if left$(ltrim$(LLine),7) = "end asm" then         
        'print #OutFile,MyLine
        exit do
      end if      
      do
        dim as integer Max = len(LLine)                        
        dim as integer StartChar = 1
        for CNT as integer = StartChar to len(LLine)
          if LLine[CNT-1] = asc("'") then
            EndPosi = CNT-1: exit for
          end if
          if LLine[CNT-1] = asc("$") then          
            dim as integer Posi          
            for Posi = CNT to Max              
              if Chars(LLine[Posi]) = 0 then                              
                dim as string Temp = "%" & ParmNums(VarCount)
                MyLine = left$(MyLine,CNT-1)+Temp+Mid$(MyLine,Posi+1)
                LLine = lcase$(MyLine)            
                StartChar = CNT+len(Temp):VarCount += 1            
                continue do
              end if          
            next Posi                      
          end if     
        next CNT 
        exit do
      loop
      
      dim as integer Posi
      if EndPosi = -1 then EndPosi = len(MyLine)
      for Posi = 0 to EndPosi-1
        dim as integer Char = MyLine[Posi]
        if Char <> 9 and Char <> 32 then exit for
      next Posi
      if Posi > Len(Ident) then Ident = left$(MyLine,Posi)
      if Posi <> EndPosi then
        MyLine = left$(MyLine,Posi)+""""+ _
        rtrim$(mid$(MyLine,Posi+1,(EndPosi-Posi)))+ _
        "\n"" _ "+mid$(MyLine,EndPosi+1)
      else
        MyLine = left$(MyLine,EndPosi)+ _
        "_ "+mid$(MyLine,EndPosi+1)
      end if        
      'print MyLine
      print #NewFile, MyLine
    loop
    
    'print Ident+": "+VarsWrite+" _"    
    print #NewFile,Ident+": "+VarsWrite+" _"    
    'print Ident+": "+VarsRead+" _"    
    print #NewFile,Ident+": "+VarsRead+" _"    
    LLine = ""
    for CNT as integer = 0 to ubound(Registers)      
      if USedRegs(CNT) then 
        if len(LLine) then LLine += ","
        LLine &= """" & Registers(CNT) & """"
      end if
    next CNT
    'print Ident+": "+LLine+" _"
    print #NewFile,Ident+": "+LLine+" _"
    'print MyLine
    print #Newfile,MyLine
  end if
wend
print #NewFile, "#ifndef main"
print #NewFile, "declare sub fbmain cdecl alias ""fb_ctor__main"" () "
print #NewFile, "function main cdecl alias ""main"" () as integer"
print #NewFile, "  fbmain()"
print #NewFile, "  return 0"
print #NewFile, "end function"
print #NewFile, "#endif"

close #MyFile,#NewFile
