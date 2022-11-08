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
Just like the DOS version, no multithread is operations are avaliable, however there's some extra functions added so that you can do background tasks, trough callbacks (functions called at every frame, so that you can use to slowly load stuff in background, that will be independent of the rest of the code), also since the NDS have an ARM7, theres the possibility to use something similar as **ThreadCall** to call an async function on the ARM7 side (should avoid it taking too long, because ARM7 is responsible for many I/O stuff that will be delayed meanwhile, in my test it was enough to have a 16khz mp3m running on ARM7)

# Runtime libary setup
unlike regular freebasic, the runtime library is not included as a static library,
but instead is compiled along the project everytime (but since its a single module its fast this way), 
and allowing for the compiler to do the best optimization and dead code detection as possible.  

That said you have **#define**'s to enable or disable certain possibilities that are not commonly used (or much viable on NDS),
later with the creationg of the *fbcDS* binary wrapper, those will have compiler switch options, but they will translate to the same defines anyway.  

the script that creates a new project copies a CrossConfig.bi file that set the default state of those, 
as well include the runtime library and gfx library "modules" (**fblib.bas** and **fbgfx.bas**), 
in addition it also have the conditional code, so that that is just added for NDS, 
but it also change default folder to use the **NitroFiles** subfolder so that the same "data files" can be used
both on native and on NDS builds (very useful to code testing for both)  

Here is a list of the defines that i implemented so far (and default settings according to **CrossConfig.bi**:
- \_\_FB_GFX_NO_8BPP\_\_  
 Disables all primitives and blending for 8bpp buffers.
- \_\_FB_GFX_NO_16BPP\_\_  
 Disables all primitives and blending for 16bpp buffers. (DEFAULT)
- \_\_FB_GFX_NO_OLD_HEADER\_\_
 Disables handling buffers with old/QB style (4 bytes
- \_\_FB_GFX_NO_GL_RENDER\_\_
- \_\_FB_GFX_SMOOTHSCREEN\_\_
- \_\_FB_GFX_LAZYTEXTURE\_\_
- \_\_FB_GFX_DIRECTSCREEN\_\_
- \_\_FB_CALLBACKS\_^_
- \_\_FB_FAT\_^_
_ \_\_FB_NO_NITRO\_^_

