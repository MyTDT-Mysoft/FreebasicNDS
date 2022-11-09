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
``` where **\_FB_Inline\_** is a macro that does the following
```freebasic
function MyFunction__ alias "MyFunction__FB__INLINE__" (Var as VarType) as ReturnType
``` which then is handled by the C preprocessor which will find the \_\_FB\_\_INLINE\_\_ suffix, remove it and add the "inline" to the begin of the C translated line to achieve it properly.  
- **Private Functions**  
 while freebasic have the **private** keyword, i couldnt use that with the runtime/gfx library names, otherwise they would get duplicated definition among other stuff because the way the libraries are handled, and if i dont set the function as private, then the "dead code elimination" does not work very well, and you end getting a much bigger binary (even with inlined functions and macros i saved almost 80kb on the .exe by using private, so programs probabily should use the regular private keword, but for rtlib implementation i did similar as the inline case:
 ```freebasic
 function _FB_Private_(MyFunction) (Var as VarType) as ReturnType
 function MyFunction__ alias "MyFunction__FB__STATIC__" (Var as VarType) as ReturnType
 ```
 
