<h1> Compatibility Information </h1>
Here you can see a list of differences in implementation that i have from regular freebasic/runtime
library that i judged necessary to obtain optimal performance on nintendo DS(i).  

Only a subset of freebasic runtime library is implemented... (i implemented as need arises from my projects),
so theres probabily a lot (specially from the very oldschool ways, or too new functions), 
other than the differences this is also listing functions that i implemented, and those that i didnt or wont implement.  

<h1> Runtime libary setup </h1>
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

Here is a list of the defines that i implemented so far:
- ^_^_FB_GFX_NO_8BPP^_^_
 test...
- ^_^_FB_GFX_NO_16BPP^_^_
- ^_^_FB_GFX_NO_OLD_HEADER^_^_
- ^_^_FB_GFX_NO_GL_RENDER^_^_
- ^_^_FB_GFX_SMOOTHSCREEN^_^_
- ^_^_FB_GFX_LAZYTEXTURE^_^_
- ^_^_FB_GFX_DIRECTSCREEN^_^_
- ^_^_FB_CALLBACKS^_^_
- ^_^_FB_FAT^_^_
_ ^_^_FB_NO_NITRO^_^_

