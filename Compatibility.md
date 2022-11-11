# Compatibility Information
Here you can see a list of differences in implementation that i have from regular freebasic/runtime
library that i judged necessary to obtain optimal performance on nintendo DS(i).  

Only a subset of freebasic runtime library is implemented... (i implemented as need arises from my projects),
so theres probabily many unimplemented (specially from the very oldschool ways, or too new functions), 
other than the differences this is also listing functions that i implemented, and those that i didnt or wont implement.  
using an unimplemented function will result in linker errors with the name of the internal freebasic function.

## Lang modes:
Only the main **-lang fb** was tested, so odds is that lot of runtime library functions called for qb/lite/deprecated wont be avaliable here,
everything else that does not depend on the runtime library still work.
## Object Orientation:
No OOP library function was added so far, so only operations that dont depend on that is avaliable (but discouraged)
## Multithread:
Just like the DOS version, no multithread operations are avaliable, however there's some extra functions added so that you can do background tasks, trough callbacks (functions called at every frame, so that you can use to slowly load stuff in background, that will be independent of the rest of the code), also since the NDS have an ARM7, theres the possibility to use something similar as **ThreadCall** to call an async function on the ARM7 side (should avoid it taking too long, because ARM7 is responsible for many I/O stuff that will be delayed meanwhile, in my test it was enough to have a 16khz mp3 running on ARM7)

# Runtime Libary setup
unlike regular freebasic, the runtime library is not included as a static library,
but instead is compiled along the project everytime (but since its a single module its fast this way), 
and allowing for the compiler to do the best optimization and dead code detection as possible.  

That said you have **#define**'s to enable or disable certain possibilities that are not commonly used (or much viable on NDS),
later with the creation of the *fbcDS* binary wrapper, those will have compiler switch options, but they will translate to the same defines anyway.  

the script that creates a new project copies a CrossConfig.bi file that set the default state of those, 
as well include the runtime library and gfx library "modules" (**fblib.bas** and **fbgfx.bas**), 
in addition it also have the conditional code, so that that is just added for NDS, 
but it also change default folder to use the **NitroFiles** subfolder so that the same "data files" can be used
both on native and on NDS builds (very useful to code testing for both)  

Here is a list of the defines that i implemented so far (and default settings according to **CrossConfig.bi**:
- **\_\_FB_GFX_NO_8BPP\_\_**  
 Disables all primitives and blending for 8bpp buffers.
- **\_\_FB_GFX_NO_16BPP\_\_**  (DEFAULT)  
 Disables all primitives and blending for 16bpp buffers.
- **\_\_FB_GFX_NO_OLD_HEADER\_\_**  (DEFAULT)  
 Disables handling buffers with old/QB style (4 bytes headers)
- **\_\_FB_GFX_NO_GL_RENDER\_\_**  (DEFAULT)  
 Disables the GL(like) hardware accelerated, note that as of now the screenres opengl flag is not doing anything, but this speed ups rendering specially for 16bpp when drawing directly to the screen, drawing to the buffers is the regular soft render, but note that the DS only have 512kb of memory for textures, so if more than that is used freebasic will delete the least used one's to upload the new one's (that only affect VRAM, the image buffer holding them are unnafected), and theres a WIP to use "compressed textures" (which requires about half the memory of 8bpp and quarter of the memory of 16bpp) however the conversion of an image block, to that format is SLOW (on the DS) and so a permanent action. No more changes can be done directly over a buffer with compressed format (so ideally for such case a external tool would be used and the resulting buffers added as a file (or perahps a custom .bmp format)
- **\_\_FB_GFX_SMOOTHSCREEN\_\_**  
 Uses a temporal smooth filtering, useful for higher resolutions like 512x192 that would be a perfect linear scaled 256x192, happens automatically every frame, so as long no library disables interrupts for too long (pretty bad), then it will work very nicely, however most emulators dont do VSYNC (or have frameskips), which will affect this, works great on real hardware :)
- **\_\_FB_CALLBACKS\_\_**  
 Enables the usage of "background tasks", functions that get called at vsync... **WhileRest** means that the callback will be called when sleep command is issued as well... using all the "idle" time (the function is responsible to not overdo)... up to 4 regular and 4 rest callbacks are supported at the moment
  ```freebasic
  declare function fb_AddVsyncCallBack(pFunction as any ptr, pData as any ptr,WhileRest as integer=true) as integer
  declare function fb_RemoveVsyncCallBack(pFunction as any ptr) as integer
  ```
- **\_\_FB_FAT\_\_**  
 Enables the usage of flashcard filesystem rooting at **fat:/** , if just one of them FAT or NITRO is enabled, then the default dir is already inside the **fat:/** or **nitro:/** but if both are enabled you must make sure to use appropriate path
- **\_\_FB_NO_NITRO\_\_**  
 Despite this is not a native feature of freebasic its default usage on NDS, because normally games are single .NDS files so its considered as eessential and so as nitro is enabled by default, this one actually DISABLES it, also while NITRO is enabled, *CrossConfig.bi* will chdir to the **NitroFiles** subfolder when not compiling for NDS, so that you can have the same default folder on both NDS and native..
- **\_\_FB_GFX_LAZYTEXTURE\_\_**  _experimental_  
 While in GL(like) HW ACC mode, textures are uploaded when the **PUT** gfx command is issued, however since theres a limited portion of time that textures can be handled without artifacts (because textures that got deleted may be used by the previous frame), resulting in delayed frames, however with this flag the uploads are lazily delayed to the moment that they can be uploaded, allowing the PUT to continue faster (but this need improvements and currently its not fully working as desired)  
- **\_\_FB_GFX_DIRECTSCREEN\_\_** _experimental_  
 Normally a framebuffer is created in RAM, and copied (when theres changes) to the VRAM using DMA at appropriate time, but even that this is closer to free, that add its toll to the bandwidth and RAM waitstates (terrible buggy on NDS), so this allows to act like on QB where what you draw get rendered directly to the screen (and double buffer can be utilized, for maximum performance), however NDS hardware does not allow 8bit writes to VRAM, so 8bpp mode wont work properly in DS mode (DSi have revised hardware that improves this), with 16bpp modes thats fine (note that "multiple pages" are not currently fully implemented (TODO)
 
# Extras features
some special features were added into freebasic NDS, to accomodate the environment, they are implemented with a combination of macros/functions, or name aliases as well a preprocessing (both the .bas and the generate .c), which are parts that i had to add to the toolchain to have everything working the way it should be... such features are:  
- **Volatile**  
 Since NDS uses memory mapped I/O it requires the volatile keyword, so lots of the libNDS and then freebasic internals use I/O, then libNDS used type definitions with the volatile qualifier vu8 vu16 vu32, so since that's not possible in freebasic i created a set of functions for volatile access, so while if volatile existed it would be like ```cptr(vu16 ptr, &hFF884422) = &h1122``` instead the function ```cast_vu16( &hFF84422 ) = &h1122``` or ```*cptr_vu16( &hFF884422 ) = &h122``` is the appropriate way to access such I/O.  
- **Inlined Functions**  
 libNDS implements some features trough inlined functions (usually as part of the headers), so when converting the headers i had a choice to make those work with macros, or regular functions (and hope that the compiler would do it properly), however i decided to add a way to have such feature in freebasic trough the preprocessors that i mentioned earlier. So to declare a inlined function you use the following:
  ```freebasic
  function _FB_Inline_(MyFunction) (Var as VarType) as ReturnType
  ```
  where **\_FB_Inline\_** is a macro that does the following:
  ```freebasic 
  function MyFunction__ alias "MyFunction__FB__INLINE__" (Var as VarType) as ReturnType
  ```
  which then is handled by the C preprocessor which will find the \_\_FB\_\_INLINE\_\_ suffix, remove it and add the "inline" to the begin of the C translated line to achieve it properly.  
- **Private Functions**  
 while freebasic have the **private** keyword, i couldnt use that with the runtime/gfx library names, otherwise they would get duplicated definition among other stuff because the way the libraries are handled, and if i dont set the function as private, then the "dead code elimination" does not work very well, and you end getting a much bigger binary (even with inlined functions and macros i saved almost 80kb on the .exe by using private, so programs probabily should use the regular private keword, but for rtlib implementation i did similar as the inline case:
  ```freebasic
  function _FB_Private_(MyFunction) (Var as VarType) as ReturnType
  ``` 
  which results in:
  ```freebasic
  function MyFunction__ alias "MyFunction__FB__STATIC__" (Var as VarType) as ReturnType
  ```  
  
# Extra functions
while their functionality may end using being implemented as flags to other stuff like **screen** , **screencontrol** or functions like **threadcall**...
i added a few functions that were necessary to handle specific environment differences, they are:
```freebasic
sub fb_ShowKeyboard()
```
 shows the libNDS virtual keyboard on the console screen, which is required while using **inkey()** ... when using **input** that is a synchronous functions then the keyboard popups automatically. if the define **\_\_FB_CALLBACKS\_\_** is defined or enabled in the **CrossConfig.bi** then it smoothly slides into the screen, otherwise it appears immediatelly.  
```freebasic
sub fb_HideKeyboard()
```
 hides the libNDS virtual keyboard, if the define **\_\_FB_CALLBACKS\_\_** is defined or enabled in the **CrossConfig.bi** then it smoothly slides out the screen, otherwise it vanish immediatelly.
```freebasic
function fb_AddVsyncCallBack(pFunction as any ptr, pData as any ptr,WhileRest as integer=true) as integer
```
 if **\_\_FB_CALLBACKS\_\_** is enabled then a function will be added to be called every frame, this function have the same prototype as threads, with just the **pData** pointer being passed as parameter, if the **WhileRest** parameter is true then the callback will be called also when sleep is called, basically using all IDLE time as opportunity for the callback to run (keep the code on those short to not compromise the stability), theres 4 slots for regular callback, and 4 slots for idle callbacks. Theres no check for already existing callback functions, so if you add a function more than once it will use more slots as well, i limited the slots to avoid too much instability but theres a constant for that on **fblib.bas** if more required.
```freebasic
function fb_RemoveVsyncCallBack(pFunction as any ptr) as integer
```
 remove a callback previously added by **fb_AddVsyncCallBack**, if a function is inserted twice, it must be removed twice.
```freebasic
function NDS_Arm7Exec( pAddr as any ptr , pParm as any ptr , uAck as long = 1 ) as ulong '(experimental!)
```
 this function calls a function with similar prototype as the thread and the vsync callbacks, i.e. **pParm** as parameter for the data to be passed to the function, however allowing to returnin an **ulong** value, but this function is executed on the ARM7 (33mhz) processor instead of the main ARM9 (66mhz or (133mhz in DSi mode)), this is useful also for low level coders, because some hardware is only accessible from the ARM7 side, so this allow you to run compatible code there, (notice that some stuff is only accessible from the arm9 side, so not everything will work there, also since its an ARM7 processor it have some limitations, but normally GCC does not generate such ARM9 only instructions, then most code running there (that wont recklessy perform I/O) is fine. the **uAck** when non zero forces the function to wait for the execution on ARM7 side, if 0 it executes asynchronously and return imediatelly, you should call the **NDS_Arm7Ack()** to wait for the function to finish, multiple functions can be queded, the ACK will wait for all pending functions to finish (but avoid using of multiple functions as that disrupt arm7 normal handling, (wifi/touch/input))
```freebasic
 function NDS_Arm7Ack() as ulong
```
 waits for all the functions queded on the ARM7 side with **NDS_Arm7Exec** to finish and return the return code of the last one (so having more than one, means you lose their return value, maybe in future i can store the return values for individual function acknowledgement.  

# Console
  Console on NDS uses one of them screens (unless GFX makes use of both of them), among the samples theres a 2 console sample, but that was a test, and right now it wont work with the current state of rtlib, i have yet to decide how to interface that in a comaptible way, the console is just the regular debug console from the libNDS that is a 32x24 (8x8 chars), with 16 colors, (NO BACKGROUND COLORS!), i may override the libNDS console and make my own in future to support background colors and "width" properly (as far as the NDS limits allow), would be possible to have a 64x32 (4x6 chars), and maybe with that and smooth jiterring have 80x25 up to 80x32 or 64x48... but totally not 80x50, a slower gfx based console using (subpixel resolution would be possible, but slow).
  The console on NDS also support a subset of ANSI codes (locate,color is implemented that way), and ofcourse the touchscreen is always avaliable, **multikey** and **inkey()** accept some extra scancodes **fb.SC_BUTTONA** , **fb.SC_BUTTONX** , **fb.SC_BUTTONY** , **fb.SC_BUTTONL** , **fb.SC_BUTTONR** , **fb.SC_BUTTONSTART** , **fb.SC_BUTTONSELECT** , **fb.SC_BUTTONTOUCH** , so yeah pressing the screen counts as a key pressed as well. Console charset is ASCII only (0-127), with the characters 1 to 31 from codepage 437 (just like US ENGLISH DOS, thats the default libNDS console), if needed i guess i could add a custom font to allow for the full codepage (or other codepages)

# Freebasic GFX
  while full fbgfx support is expected, theres some limitations on feature avaliable, for example only 8bpp and 16bpp (<8=8 , >16=16) modes were implemented, it would be possible to implement buffers with 32bpp, but giving the hardware wont support that (it would need to be converter to 16bpp when copying to VRAM, waay slower than just doing an almost transparent DMA to vram), theres some things not fully implemented specially in 16bpp soft render, resolution have limitations (like on the DOS version), i didnt made a resolution enumeration (see **GFX Resolutions** section), either way the NDS resolution is a fixed 256x192, so everything will be scaled to that (or split between two screens), also keep in mind that while normally the screenframebuffer is fully linear the NDS is not for all resolutions, on NDS theres a 256 or 512 pixel pitch, so when acessing the framebuffer directly in resolutions that are not 256 or 512 pixels wide, that must be taken into consideration. Also while normally the 16bpp format is RGB565 on DS its actually RGBA1555, and the "alpha bit" must be 1 all t he times or nothing will appear. default **CrossConfig.bi** have 16bpp disabled (to save to reduce .NDS file size), so the **#define \_\_FB_GFX_NO_16BPP\_\_** need to be commented, for 16bpp to be avaliable, likewise, theres a fbgfx hardware acceleration that can be enabled by commented the **#define \_\_FB_GFX_NO_GL_RENDER\_\_**, (see **GFX Acceleration** section). Currently 2 pages are not fully implemented but they will be useful for directscreen mode, a, and basically no screenres flag will have any effeect.  
  **get** is not implemented, but since freebasic have a more advanced **put** than QBASIC, get becomes unecessary, except for grabbing from the screen, but the screen on freebasic NDS is also a **fb.image** buffer, that you can access by using **gfx.scr** (also useful for 3D renderer)
# GFX resolutions
- 256x192
 Native NDS resolution for one, supported in 8bpp/16bpp with softrender (normal) and HW ACC
- 192x256
 Same as 256x192, but the result is rotated to allow "book style" programs (Soft+HW ACC)
- 256x384
 Dual screen resolution, so the first 192 lines belong to the top screen, and the remaining 192 lines belong to the bottom screen, updates are swapped each frame... so effectively 30 fps updates instead of 60 fps. (Soft only, HW ACC can be added, but textures will be reduced to 256kb instead of 512kb)
- Others:
 Technically any resolution up to 512x512 is acceptable (1024x512 is usable in 8bpp mode, but that is not supported, maybe it can be allowed with **\_\_FB_GFX_DIRECTSCREEN\_\_**, so you could have 640x480 resolution (but that would still be scaled to 256x192 at end).
  Resolutions biggers than 256x192 specially 512x192 can benefit from the jitter (temporal) scaling enabled with **\_\_FB_GFX_SMOOTHSCREEN\_\_** to have a linear scale to 256x192

# GFX acceleration
 So, while the regular softrender, is easy to handle and compatible, it also can be a bit slow, a program that would fully utilize DS hardware could bypass fbgfx or mix with it (since the 3D render, and the framebuffer are just layers, so it can be combined with TILES and SPRITES, and etc.. using regular libNDS calls, but those would be strictly DS, (not very good if you plan to have the game working both native and on DS, unless an API would simulate the DS hardware native, but so to squeeze a bit more out of the DS hardware, i decided to make a hardware accelerated renderer for fbgfx.  
  When enabled (i.e. when **\_\_FB_GFX_NO_GL_RENDER\_\_** is not defined (or its commented on the **CrossConfig.bi** then all operations made directly to the screen are hardware accelerated, right now only **line** , **put** and **draw string** are implemented, that are the most common, also line with patterns wont work because no shaders or stipples are possible on DS, likewise **paint** wont be implemented in HW ACC for the same reason.
  Nintendo DS have a limit of 6144 vertices per frame, and lines require 3 vertices, so only 2048 lines are possible, or 1536 squares, (each character drawn by **Draw String** is a square, so you need to balance that, and for text that remains static, it could be benefit to draw on buffer created by **ImageCreate** and then draw that as a texture.
  When using this mode **flip** (like in GL mode) is required to update the screen (screenlock/unlock have no effect, but theres a trick to still use the soft render frambuffer, drawing to the **gfx.scr** image buffer (screenres 256x192 ONLY!), to have the softrender work as a layer above the 3D, so you can have the status, and other not suitable or expensive (in terms of vertices) effects applied on top of your 3D screen!), and unfortunately since only the **VERTICES!!** are swapped (theres no color or zbuffers for 3D), the output is redraw each frame, which means, you need to draw the **whole screen** every frame when using this method!!!!
  While using hardware acceleration then images need to be uploaded as textures, fbgfx uploads the texture automatically when you use **put** to draw them, and even on 16bpp mode, you can have both 8bpp and 16bpp images, because NDS have only 512kb of texture memory, and textures size must be powers of two with minimum size of 8... so if you have a 17x17 image it would use a 32x32 texture (however it will only use memory equivalent of 32x17).
  Images while in hw acc mode have *pitch* that makes pixels width always power of two, to simplify and speed up texture upload), buffers can be converted to use compressed texture to effectively halve its size, however once you use compressed textures, 256-384kb  are reserved for them leaving only 128-256kb for the textulre textures (thats due DS limitations on where those can be stored), but eventually i will try to subvert that a bit by improve the libNDS texture allocation algorithm, so that both compresed and non compressed can exist on the same blocks.
  That said, the NDS hardware have the capability to render to a framebuffer, that can be reused on the next frame, which would allow 2x vertices at 30fps or 3x vertices at 20fps (also required to use 3D on both screens (not supported by fbgfx)), but that only capture the image not the depth (Z), and costs 128kb of texture ram, so for now i'm not implemented such capability either with fbgfx.
