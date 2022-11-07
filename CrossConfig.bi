#ifdef __FB_NDS__  
  
  #define __FB_GFX_NO_GL_RENDER__  'comment this to use the OpenGL hw accelerated render backend
  '#define __FB_NO_NITRO__          'comment this to enable "nitrofiles/" usage (embedded on .nds)
  #define __FB_GFX_NO_OLD_HEADER__ 'comment this to enable "old (QB compatible)" fbheader usage (please dont!)
  '#define __FB_GFX_NO_16BPP__     'comment this to enable 16bpp fbgfx (32bpp not possible)
  
  '#define __FB_FAT__              'uncomment this to enable FAT usage (access to the flashcard filesystem)  
  '#define __FB_CALLBACKS__        'uncomment this to enable callbacks every frame (to emulate sorta like threads)
  '#define __FB_GFX_SMOOTHSCREEN__ 'uncomment this to enable filtering of the fbgfx framebuffer
  
  #include "Modules\fbLib.bas"
  #include "Modules\fbgfx.bas"  
  #ifndef __FB_GFX_NO_GL_RENDER__
    gfx.GfxDriver = gfx.gdOpenGL  
  #endif  
  
#else
  #include "crt.bi"
  #include "fbgfx.bi" 
  'this is so you can have the same base folder for native and NDS files (embedded on NDS cart)
  chdir "nitrofiles/" 
#endif
