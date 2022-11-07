#include once "crt.bi"

namespace fb
dim shared as uinteger MemUsage,BlockCount
end namespace

#undef allocate
#undef callocate
#undef reallocate
#undef deallocate

#define DebugWait()
const DebugDelay = 0
'#define DebugWait() sleep DebugDelay,1

#define SafeMemoryControl 1

declare function fb_SleepEx_ alias "fb_SleepEx" (Amount as integer,MustWait as integer) as integer  

'#define DebugMem
#define DebugMemError
'#define DebugShowSize
'#define DebugFunctionName
#define DebugMemoryUsage
'#define DebugBlockCount
#define WaitKey() fb_SleepEx_(-1,0)

#define _smcExtra 6

extern "c"
#if SafeMemoryControl = 1
  #ifdef DebugFunctionName
    #define allocate(Amount) _allocate(Amount,__LINE__)
    function _allocate(Amount as integer, iLine as integer) as any ptr
      if iLine then printf(!"%i\n",iLine)
  #else
    function allocate(Amount as integer) as any ptr
  #endif
    if (amount and 3) then Amount = (Amount or 3)+1
    dim as uinteger ptr Temp = malloc(Amount+8)
    if Temp then
      Temp[0] = Amount+8+_smcExtra: Temp[1] = &h1234FEDC
      fb.MemUsage += Temp[0]: fb.BlockCount += 1: Temp += 2
    else
      #ifdef DebugMemError
      printf(!"%s %X(%i)\n","Failed to allocate",Amount,Amount and ((1 shl 31)-1)):WaitKey()':beep: sleep
      #endif
    end if
    #ifdef DebugMem
    color 2
    printf(!"Allocate!    %08x %i\n",cuint(Temp),Amount):DebugWait()
    color 7
    #endif
    #ifdef DebugBlockCount
    printf(!"Block Count = %i\n",fb.BlockCount)
    #endif
    return Temp
  end function
  
  function callocate(Amount as integer) as any ptr
    if (amount and 3) then Amount = (Amount or 3)+1
    dim as uinteger ptr Temp = calloc(Amount+8,1)
    if Temp then 
      Temp[0] = Amount+8+_smcExtra: Temp[1] = &h1234FEDC
      fb.MemUsage += Temp[0]: fb.BlockCount += 1: Temp += 2
    else
      #ifdef DebugMemError
      color 4
      printf(!"Failed to callocate\n"):WaitKey()':beep: sleep
      color 7
      #endif
    end if  
    #ifdef DebugMem
    color 2
    printf(!"Callocate!   %08x %i\n",cuint(Temp),Amount):DebugWait()
    color 7
    #endif
    #ifdef DebugBlockCount
    printf(!"Block Count = %i\n",fb.BlockCount)
    #endif
    return Temp
  end function
  function reallocate(OldBlock as any ptr,Amount as integer) as any ptr  
    if OldBlock then
      if cptr(uinteger ptr,OldBlock-8)[1] = &h1234FEDC then
        fb.MemUsage -= cptr(uinteger ptr,OldBlock-8)[0]: fb.BlockCount -= 1
        cptr(uinteger ptr,OldBlock-8)[1] = 0
      else
        #ifdef DebugMemError
        color 12
        printf(!"realloc foreign memory :(\n"):WaitKey()': beep: sleep
        color 7
        #endif
      end if
    end if
    amount = (amount+3) and (not 3)
    dim as uinteger ptr Temp=any
    if OldBlock then Temp=realloc(OldBlock-8,Amount+8) else Temp=malloc(Amount+8)
    if Temp then
      Temp[0] = Amount+8 : Temp[1] = &h1234FEDC
      if OldBlock=0 then Temp[0] += _smcExtra
      fb.MemUsage += Temp[0]: fb.BlockCount += 1: Temp += 2
    else
      #ifdef DebugMemError
      color 12
      printf(!"Failed to reallocate\n"):WaitKey()': beep
      color 7
      #endif
    end if
    #ifdef DebugMem
    color 6
    printf(!"Re! %08x %08x %i\n",cuint(OldBlock),cuint(Temp),Amount): DebugWait()
    color 7
    #endif
    #ifdef DebugBlockCount
    printf(!"Block Count = %i\n",fb.BlockCount)
    #endif
    return Temp
  end function
  sub Deallocate(MemBlock as any ptr)
    if MemBlock andalso cptr(uinteger ptr,MemBlock-8)[1] = &h1234FEDC then
      cptr(uinteger ptr,MemBlock-8)[1] = 0 : fb.BlockCount -= 1
      #ifdef DebugMem
      color 4
      printf(!"Deallocate!  %08x %i\n",cuint(MemBlock),cptr(integer ptr,MemBlock-8)[0])
      color 7
      #endif
      fb.MemUsage -= cptr(integer ptr,MemBlock-8)[0]
      free(MemBlock-8)
    else
      #ifdef DebugMemError
      color 12
      printf(!"Deallocate!  %08x ?\n",cuint(MemBlock))
      color 7
      #endif
      #ifdef DebugMemError
      if MemBlock then 
        color 12
        printf(!"Free bad memory? %X :(\n",cuint(MemBlock)):WaitKey()':beep
        color 7
      end if
      #endif
    end if  
    #ifdef DebugBlockCount
    printf(!"Block Count = %i\n",fb.BlockCount)
    #endif
    #ifdef DebugMem
    DebugWait()
    #endif
  end sub
#else
  function allocate(Amount as integer) as any ptr    
    return Malloc(Amount)
  end function
  function callocate(Amount as integer) as any ptr  
    return calloc(Amount,1)  
  end function
  function reallocate(OldBlock as any ptr,Amount as integer) as any ptr  
    Return realloc(OldBlock,Amount)
  end function
  sub Deallocate(MemBlock as any ptr)  
    Free(MemBlock)
  end sub
#endif
end extern

#macro DebugShowFunctionName()
  #ifdef DebugFunctionName
  printf(__FUNCTION__  & !"\n")
  sleep DebugDelay\2,1
  #endif
#endmacro
