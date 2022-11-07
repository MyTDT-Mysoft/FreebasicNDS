#define ARM9

#include "crt.bi"
#include "nds.bi"

dim shared as integer ExceptCount

sub MyException cdecl ()
  printf("Exception!!! \n")
  ExceptCount += 1
end sub

function main cdecl alias "main" () as integer

	'// install the default exception handler
	defaultExceptionHandler()  
  setExceptionHandler(@MyException)
  consoleDemoInit()
  
	'// generate an exception
	*cast(u32 ptr,8192) = 100
  
  dim as integer X,Y
  X \= Y
    
  printf("Done! %i exceptions occurred",ExceptCount)

	do
    swiWaitForVBlank()
  loop
  
  return 0

end function
