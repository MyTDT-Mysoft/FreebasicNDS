#define ARM9

#include "crt.bi"
#include "nds.bi"

sub OnKeyPressed cdecl (key as integer)
  if key > 0 then
    iprintf("%c", key)
  end if
end sub

function main cdecl alias "main"() as integer

   consoleDemoInit()

   dim as Keyboard ptr kbd = keyboardDemoInit()

   kbd->OnKeyPressed = @OnKeyPressed

   do
      dim as zstring*256 myName

      iprintf(!"What is your name?\n")

      scanf("%s", myName)

      iprintf(!"\nHello %s", myName)

      scanKeys()
      
      while(keysDown()=0)
        scanKeys()
      wend

      swiWaitForVBlank()
      consoleClear()
      
   loop

   return 0
   
end function

