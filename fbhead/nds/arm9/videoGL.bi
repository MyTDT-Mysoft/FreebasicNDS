''
''
'' videoGl -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __videoGl_bi__
#define __videoGl_bi__

#include "nds/dma.bi"
#include "nds/ndstypes.bi"
'#include "nds/arm9/sassert.bi"
#include "nds/arm9/video.bi"
#include "nds/arm9/cache.bi"
#include "nds/arm9/trig_lut.bi"
#include "nds/arm9/math.bi"
#include "nds/arm9/dynamicArray.bi"

#define LUT_SIZE (1 shl 15)
#define LUT_MASK ((1 shl 15) -1)
#define MAX_TEXTURES 2048

type fixed12d3 as uint16
type t16 as short
type v16 as short
type v10 as short
type _rgb as ushort

#define intto12d3(n)    ((n) shl 3) 
#define floatto12d3(n)  (cast(fixed12d3,((n) * (1 shl 3))))
#define GL_MAX_DEPTH &h7FFF
#define inttof32(n)          ((n) shl 12)
#define f32toint(n)          ((n) shr 12)
#define floattof32(n)        (cast(integer,((n) * (1 shl 12))))
#define f32tofloat(n)        ((cast(single,(n))) / cast(single,(1 shl 12)))

#define f32tot16(n)          (cast(t16,(n shr 8)))
#define inttot16(n)          ((n) shl 4)
#define t16toint(n)          ((n) shr 4)
#define floattot16(n)        (cast(t16,((n) * (1 shl 4))))
#define TEXTURE_PACK(u,v)    (((u) and &hFFFF) or ((v) shl 16))

#define inttov16(n)          ((n) shl 12)
#define f32tov16(n)          (n)
#define v16toint(n)          ((n) shr 12)
#define floattov16(n)        (cast(v16,((n) * (1 shl 12))))
#define VERTEX_PACK(x,y)     (((x) and &hFFFF) or ((y) shl 16))

#define inttov10(n)          ((n) shl 9) 
#define f32tov10(n)          (cast(v10,(n shr 3)))
#define v10toint(n)          ((n) shr 9)
#define floattov10(n)        cast(v10,iif((n>.998),&h1FF,cint(((n)*(1 shl 9)))))
#define NORMAL_PACK(x,y,z)   (((x) and &h3FF) or (((y) and &h3FF) shl 10) or ((z) shl 20))

#ifndef rgb15
type rgb15 as u16
#endif

type m3x3
  m(0 to 9-1) as integer
end type

type m4x4
  m(0 to 16-1) as integer
end type

type m4x3
  m(0 to 12-1) as integer
end type

type GLvector
  x as integer
  y as integer
  z as integer
end type

#define GL_FALSE 0
#define GL_TRUE 1

enum GL_GLBEGIN_ENUM
  GL_TRIANGLES = 0
  GL_QUADS = 1
  GL_TRIANGLE_STRIP = 2
  GL_QUAD_STRIP = 3
  GL_TRIANGLE = 0
  GL_QUAD = 1
end enum

enum GL_MATRIX_MODE_ENUM
  GL_PROJECTION = 0
  GL_POSITION = 1
  GL_MODELVIEW = 2
  GL_TEXTURE = 3
end enum

enum GL_MATERIALS_ENUM
  GL_AMBIENT = &h01
  GL_DIFFUSE = &h02
  GL_AMBIENT_AND_DIFFUSE = &h03
  GL_SPECULAR = &h04
  GL_SHININESS = &h08
  GL_EMISSION = &h10
end enum

enum GL_POLY_FORMAT_ENUM
	POLY_FORMAT_LIGHT0     = (1 shl 0)
	POLY_FORMAT_LIGHT1     = (1 shl 1)
	POLY_FORMAT_LIGHT2     = (1 shl 2)
	POLY_FORMAT_LIGHT3     = (1 shl 3)
	
  POLY_MODULATION        = (0 shl 4)
	POLY_DECAL             = (1 shl 4)
	POLY_TOON_HIGHLIGHT    = (2 shl 4)
	POLY_SHADOW            = (3 shl 4)
  
	POLY_CULL_FRONT        = (1 shl 6)
	POLY_CULL_BACK         = (2 shl 6)
	POLY_CULL_NONE         = (3 shl 6)
  
	POLY_ALPHADEPTH_KEEP   = (0 shl 11)
	POLY_ALPHADEPTH_UPDATE = (1 shl 11)
  
	POLY_FARPLANE_HIDE     = (0 shl 12)
	POLY_FARPLANE_RENDER   = (1 shl 12)
  
	POLY_1DOT_HIDE         = (0 shl 13)
	POLY_1DOT_RENDER       = (1 shl 13)
  
	POLY_DEPTH_LESS        = (0 shl 14)
	POLY_DEPTH_EQUAL       = (1 shl 14)
  
	POLY_FOG               = (1 shl 15)
end enum

enum GL_TEXTURE_SIZE_ENUM
	TEXTURE_SIZE_8 = 0
	TEXTURE_SIZE_16 = 1
	TEXTURE_SIZE_32 = 2
	TEXTURE_SIZE_64 = 3
	TEXTURE_SIZE_128 = 4
	TEXTURE_SIZE_256 = 5
	TEXTURE_SIZE_512 = 6
	TEXTURE_SIZE_1024 = 7
end enum

enum GL_TEXTURE_PARAM_ENUM
	GL_TEXTURE_WRAP_S = (1 shl 16)
	GL_TEXTURE_WRAP_T = (1 shl 17)
	GL_TEXTURE_FLIP_S = (1 shl 18)
	GL_TEXTURE_FLIP_T = (1 shl 19)
	GL_TEXTURE_COLOR0_TRANSPARENT = (1 shl 29)
	TEXGEN_OFF = (0 shl 30)
	TEXGEN_TEXCOORD = (1 shl 30)
	TEXGEN_NORMAL = (2 shl 30)
	TEXGEN_POSITION = (3 shl 30)
end enum

enum GL_TEXTURE_TYPE_ENUM
  GL_NOTEXTURE
	GL_RGB32_A3 = 1
	GL_RGB4 = 2
	GL_RGB16 = 3
	GL_RGB256 = 4
	GL_COMPRESSED = 5
	GL_RGB8_A5 = 6
	GL_RGBA = 7
	GL_RGB = 8
end enum

enum DISP3DCNT_ENUM
	GL_TEXTURE_2D      = (1 shl 0)
	GL_TOON_HIGHLIGHT  = (1 shl 1)
	GL_ALPHA_TEST      = (1 shl 2)
	GL_BLEND           = (1 shl 3)
	GL_ANTIALIAS       = (1 shl 4)
	GL_OUTLINE         = (1 shl 5)
	GL_FOG_ONLY_ALPHA  = (1 shl 6)
	GL_FOG             = (1 shl 7)
	GL_COLOR_UNDERFLOW = (1 shl 12)
	GL_POLY_OVERFLOW   = (1 shl 13)
	GL_CLEAR_BMP       = (1 shl 14)
end enum

enum GL_GET_ENUM
	GL_GET_VERTEX_RAM_COUNT
	GL_GET_POLYGON_RAM_COUNT
	GL_GET_MATRIX_VECTOR
	GL_GET_MATRIX_POSITION
	GL_GET_MATRIX_PROJECTION
	GL_GET_MATRIX_CLIP
	GL_GET_TEXTURE_WIDTH
	GL_GET_TEXTURE_HEIGHT
end enum

enum GLFLUSH_ENUM
	GL_TRANS_MANUALSORT = (1 shl 0)
	GL_WBUFFERING       = (1 shl 1)
end enum

type s_SingleBlock
	indexOut as uint32
	AddrSet as uint8 ptr
	node(0 to 4-1) as s_SingleBlock ptr
	blockSize as uint32
end type

type s_vramBlock
	startAddr as uint8 ptr
	endAddr as uint8 ptr
	firstBlock as s_SingleBlock ptr
	firstEmpty as s_SingleBlock ptr
	firstAlloc as s_SingleBlock ptr
	lastExamined as s_SingleBlock ptr
	lastExaminedAddr as uint8 ptr
	lastExaminedSize as uint32
	blockPtrs as DynamicArray
	deallocBlocks as DynamicArray
	blockCount as uint32
	deallocCount as uint32
end type

type gl_texture_data
	vramAddr as any ptr
	texIndex as uint32
	texIndexExt as uint32
	palIndex as integer
	texFormat as uint32
	texSize as uint32
end type

type gl_palette_data
	vramAddr as any ptr
	palIndex as uint32
	addr as uint16
	palSize as uint16
	connectCount as uint32
end type

type gl_hidden_globals
	matrixMode as GL_MATRIX_MODE_ENUM
	vramBlocks(2-1) as s_vramBlock ptr
	vramLock(2-1) as integer
	texturePtrs as DynamicArray
	palettePtrs as DynamicArray
	deallocTex as DynamicArray
	deallocPal as DynamicArray
	deallocTexSize as uint32
	deallocPalSize as uint32
	activeTexture as integer
	activePalette as integer
	texCount as integer
	palCount as integer
	clearColor as u32
	isActive as uint8
end type

extern glGlobalData alias "glGlobalData" as gl_hidden_globals
static shared as gl_hidden_globals ptr glGlob = @glGlobalData

#define FIFO_COMMAND_PACK(c1,c2,c3,c4) (((c4) shl 24) or ((c3) shl 16) or ((c2) shl 8) or (c1))
                                                               
#define REG2ID(r)			cast(u8,(cast(u32,r)-&h04000400) shr 2)

#define FIFO_NOP     REG2ID(pGFX_FIFO)
#define FIFO_STATUS  REG2ID(pGFX_STATUS)
#define FIFO_COLOR   REG2ID(pGFX_COLOR)

#define FIFO_VERTEX16       REG2ID(pGFX_VERTEX16)
#define FIFO_VERTEX10       REG2ID(pGFX_VERTEX10)
#define FIFO_VERTEX_XY      REG2ID(pGFX_VERTEX_XY)
#define FIFO_VERTEX_XZ      REG2ID(pGFX_VERTEX_XZ)
#define FIFO_VERTEX_YZ      REG2ID(pGFX_VERTEX_YZ)
#define FIFO_TEX_COORD      REG2ID(pGFX_TEX_COORD)
#define FIFO_TEX_FORMAT     REG2ID(pGFX_TEX_FORMAT)
#define FIFO_PAL_FORMAT     REG2ID(pGFX_PAL_FORMAT)

#define FIFO_CLEAR_COLOR    REG2ID(pGFX_CLEAR_COLOR)
#define FIFO_CLEAR_DEPTH    REG2ID(pGFX_CLEAR_DEPTH)

#define FIFO_LIGHT_VECTOR   REG2ID(pGFX_LIGHT_VECTOR) 
#define FIFO_LIGHT_COLOR    REG2ID(pGFX_LIGHT_COLOR)
#define FIFO_NORMAL         REG2ID(pGFX_NORMAL)

#define FIFO_DIFFUSE_AMBIENT   REG2ID(GFX_DIFFUSE_AMBIENT)
#define FIFO_SPECULAR_EMISSION REG2ID(pGFX_SPECULAR_EMISSION)
#define FIFO_SHININESS         REG2ID(pGFX_SHININESS)

#define FIFO_POLY_FORMAT REG2ID(pGFX_POLY_FORMAT)

#define FIFO_BEGIN       REG2ID(pGFX_BEGIN)
#define FIFO_END         REG2ID(pGFX_END)
#define FIFO_FLUSH       REG2ID(pGFX_FLUSH)
#define FIFO_VIEWPORT    REG2ID(pGFX_VIEWPORT)


extern "C"
declare sub      glRotatef32i        (byval angle as integer, byval x as integer, byval y as integer, byval z as integer)
declare function glTexImage2D        (byval target as integer, byval empty1 as integer, byval type as GL_TEXTURE_TYPE_ENUM, byval sizeX as integer, byval sizeY as integer, byval empty2 as integer, byval param as integer, byval texture as any ptr) as integer
declare sub      glColorTableEXT     (byval target as integer, byval empty1 as integer, byval width as uint16, byval empty2 as integer, byval empty3 as integer, byval table as uint16 ptr)
declare sub      glAssignColorTable  (byval target as integer, byval name as integer)
declare sub      glTexParameter      (byval target as integer, byval param as integer)
declare function glGetTexParameter   () as u32
declare function glGetTexturePointer (byval name as integer) as any ptr
declare sub      glBindTexture       (byval target as integer, byval name as integer)
declare function glGenTextures       (byval n as integer, byval names as integer ptr) as integer
declare function glDeleteTextures    (byval n as integer, byval names as integer ptr) as integer
declare sub      glResetTextures     ()
declare sub      glTexCoord2f32      (byval u as integer, byval v as integer)
declare sub      glMaterialf         (byval mode as GL_MATERIALS_ENUM, byval color as _rgb)
declare sub      glInit_C            ()
declare function glGetGlobals        () as gl_hidden_globals ptr
end extern

#define POLY_ALPHA(int_n) cast(u32,(cast(u32,(int_n)) shl 16))

#define POLY_ID(int_n) cast(u32,(cast(u32,(int_n)) shl 24))

#define glBegin(GL_GLBEGIN_ENUM_mode) GFX_BEGIN = GL_GLBEGIN_ENUM_mode:

#define glEnd() GFX_END = 0:

#define glClearDepth(fixed12d3_depth) GFX_CLEAR_DEPTH = (fixed12d3_depth):

#define glColor3b(uint8_red, uint8_green, uint8_blue) GFX_COLOR = cast(u32,RGB15((uint8_red) shr 3, (uint8_green) shr 3, (uint8_blue) shr 3))
 'vu32

#define glColor(rgb_color) GFX_COLOR = cast(u32,rgb_color)
 'vu32

#define glVertex3v16(v16_x, v16_y, v16_z) GFX_VERTEX16 = ((v16_y) shl 16) or ((v16_x) and &hFFFF):GFX_VERTEX16 = (v16_z):

#define glTexCoord2t16(t16_u, t16_v) GFX_TEX_COORD = TEXTURE_PACK(t16_u,t16_v):

#define glPushMatrix() MATRIX_PUSH = 0:

#define glPopMatrix(int_num) MATRIX_POP = int_num:

#define glRestoreMatrix(int_index) MATRIX_RESTORE = int_index:

#define glStoreMatrix(int_index) MATRIX_STORE = int_index:

#define glScalev glScalev__FB__INLINE__
sub glScalev__FB__INLINE__(v as GLvector ptr)
  MATRIX_SCALE = v->x
  MATRIX_SCALE = v->y
  MATRIX_SCALE = v->z
end sub

#define glTranslatev glTranslatev__FB__INLINE__
sub glTranslatev__FB__INLINE__( v as GLvector ptr)
	MATRIX_TRANSLATE = v->x
	MATRIX_TRANSLATE = v->y
	MATRIX_TRANSLATE = v->z
end sub

'// map old name to new name
#define glTranslate3f32 glTranslatef32

#define glTranslatef32(int_x, int_y, int_z) MATRIX_TRANSLATE = int_x:MATRIX_TRANSLATE = int_y:MATRIX_TRANSLATE = int_z:

#define glScalef32 glScalef32__FB__INLINE__
sub glScalef32__FB__INLINE__ (x as integer,y as integer,z as integer)
	MATRIX_SCALE = x
	MATRIX_SCALE = y
	MATRIX_SCALE = z
end sub

#define glLight glLight__FB__INLINE__
sub glLight__FB__INLINE__(id as integer, rgbcolor as ushort, x as v10, y as v10, z as v10) 
  id = (id and 3) shl 30
  GFX_LIGHT_VECTOR = id or ((z and &h3FF) shl 20) or ((y and &h3FF) shl 10) or (x and &h3FF)
  GFX_LIGHT_COLOR = id or rgbcolor
end sub

#define glNormal(u32_normal) GFX_NORMAL = u32_normal:

#define glLoadIdentity() MATRIX_IDENTITY = 0:

#define glMatrixMode(GL_MATRIX_MODE_ENUM_mode) MATRIX_CONTROL = (GL_MATRIX_MODE_ENUM_mode):

#define glViewport(uint8_x1, uint8_y1, uint8_x2, uint8_y2) GFX_VIEWPORT = (uint8_x1) + ((uint8_y1) shl 8) + ((uint8_x2) shl 16) + ((uint8_y2) shl 24):

#define glFlush(u32_mode) GFX_FLUSH = u32_mode:

#define glMaterialShinyness glMaterialShinyness__FB__INLINE__
sub glMaterialShinyness__FB__INLINE__()
  dim as u32 shiny32((128\4)-1)
  dim as u8 ptr shiny8 = cast(u8 ptr,@shiny32(0))

  dim as integer i

  for i = 0 to (128*2)-1 step 2
    shiny8[i shr 1] = i
  next i

  for i = 0 to ((128\4)-1)
    GFX_SHININESS = shiny32(i)
  next i
end sub

#define glCallList glCallList__FB__INLINE__
sub glCallList__FB__INLINE__(list as u32 ptr) 
  'sassert(list != NULL,"glCallList received a null display list pointer");

  dim as u32 count = *list
  list += 1

  'sassert(count != 0,"glCallList received a display list of size 0");

  'flush the area that we are going to DMA
  DC_FlushRange(list, count shl 2)

  while ((DMA_CR(0) and DMA_BUSY) or (DMA_CR(1) and DMA_BUSY) or (DMA_CR(2) and DMA_BUSY) or (DMA_CR(3) and DMA_BUSY))
    DoNothing2()
  wend

  'send the packed list asynchronously via DMA to the FIFO
  DMA_SRC(0) = cast(u32,list)
  DMA_DEST(0) = &h4000400
  DMA_CR(0) = DMA_FIFO or count
  
  while (DMA_CR(0) and DMA_BUSY)
    DoNothing2()
  wend
end sub

#define glPolyFmt(u32_params) GFX_POLY_FORMAT = u32_params

#define glEnable(int_bits) GFX_CONTROL or= (int_bits):

#define glDisable(int_bits) GFX_CONTROL and= (not int_bits):

#define glFogShift(int_shift) GFX_CONTROL = ((GFX_CONTROL and &hF0FF) or ((int_shift) shl 8)):

#define glFogOffset(int_offset) GFX_FOG_OFFSET = (int_offset):

#define glFogColor(uint8_red, uint8_green, uint8_blue, uint8_alpha) GFX_FOG_COLOR = RGB15(uint8_red,uint8_green,uint8_blue) or ((uint8_alpha) shl 16):

#define glFogDensity(int_index, int_density) GFX_FOG_TABLE[int_index] = int_density:

#define glLoadMatrix4x4 glLoadMatrix4x4__FB__INLINE__
sub glLoadMatrix4x4__FB__INLINE__(m as m4x4 ptr)
 	MATRIX_LOAD4x4 = m->m(0)
 	MATRIX_LOAD4x4 = m->m(1)
	MATRIX_LOAD4x4 = m->m(2)
 	MATRIX_LOAD4x4 = m->m(3)
 
 	MATRIX_LOAD4x4 = m->m(4)
 	MATRIX_LOAD4x4 = m->m(5)
 	MATRIX_LOAD4x4 = m->m(6)
  	MATRIX_LOAD4x4 = m->m(7)
 
 	MATRIX_LOAD4x4 = m->m(8)
 	MATRIX_LOAD4x4 = m->m(9)
 	MATRIX_LOAD4x4 = m->m(10)
 	MATRIX_LOAD4x4 = m->m(11)
 
 	MATRIX_LOAD4x4 = m->m(12)
 	MATRIX_LOAD4x4 = m->m(13)
 	MATRIX_LOAD4x4 = m->m(14)
 	MATRIX_LOAD4x4 = m->m(15)
end sub

#define glLoadMatrix4x3 glLoadMatrix4x3__FB__INLINE__
sub glLoadMatrix4x3__FB__INLINE__(m as m4x3 ptr)
        MATRIX_LOAD4x3 = m->m(0)
        MATRIX_LOAD4x3 = m->m(1)
        MATRIX_LOAD4x3 = m->m(2)
        MATRIX_LOAD4x3 = m->m(3)

        MATRIX_LOAD4x3 = m->m(4)
        MATRIX_LOAD4x3 = m->m(5)
        MATRIX_LOAD4x3 = m->m(6)
        MATRIX_LOAD4x3 = m->m(7)

        MATRIX_LOAD4x3 = m->m(8)
        MATRIX_LOAD4x3 = m->m(9)
        MATRIX_LOAD4x3 = m->m(10)
        MATRIX_LOAD4x3 = m->m(11)
end sub

#define glMultMatrix4x4 glMultMatrix4x4__FB__INLINE__
sub glMultMatrix4x4__FB__INLINE__(m as m4x4 ptr)
 	MATRIX_MULT4x4 = m->m(0)
 	MATRIX_MULT4x4 = m->m(1)
 	MATRIX_MULT4x4 = m->m(2)
 	MATRIX_MULT4x4 = m->m(3)
 
 	MATRIX_MULT4x4 = m->m(4)
 	MATRIX_MULT4x4 = m->m(5)
 	MATRIX_MULT4x4 = m->m(6)
 	MATRIX_MULT4x4 = m->m(7)
 
 	MATRIX_MULT4x4 = m->m(8)
 	MATRIX_MULT4x4 = m->m(9)
 	MATRIX_MULT4x4 = m->m(10)
 	MATRIX_MULT4x4 = m->m(11)
 
 	MATRIX_MULT4x4 = m->m(12)
 	MATRIX_MULT4x4 = m->m(13)
 	MATRIX_MULT4x4 = m->m(14)
 	MATRIX_MULT4x4 = m->m(15)
end sub

#define glMultMatrix4x3 glMultMatrix4x3__FB__INLINE__
sub glMultMatrix4x3__FB__INLINE__ (m as m4x3 ptr)

 	MATRIX_MULT4x3 = m->m(0)
 	MATRIX_MULT4x3 = m->m(1)
 	MATRIX_MULT4x3 = m->m(2)
 	MATRIX_MULT4x3 = m->m(3)
 
 	MATRIX_MULT4x3 = m->m(4)
 	MATRIX_MULT4x3 = m->m(5)
 	MATRIX_MULT4x3 = m->m(6)
 	MATRIX_MULT4x3 = m->m(7)
 
 	MATRIX_MULT4x3 = m->m(8)
 	MATRIX_MULT4x3 = m->m(9)
 	MATRIX_MULT4x3 = m->m(10)
 	MATRIX_MULT4x3 = m->m(11)
 
end sub 

#define glMultMatrix3x3 glMultMatrix3x3__FB__INLINE__
sub glMultMatrix3x3__FB__INLINE__(m as m3x3 ptr) 
 	MATRIX_MULT3x3 = m->m(0)
 	MATRIX_MULT3x3 = m->m(1)
 	MATRIX_MULT3x3 = m->m(2)
 
 	MATRIX_MULT3x3 = m->m(3)
 	MATRIX_MULT3x3 = m->m(4)
 	MATRIX_MULT3x3 = m->m(5)
 
 	MATRIX_MULT3x3 = m->m(6)
 	MATRIX_MULT3x3 = m->m(7)
 	MATRIX_MULT3x3 = m->m(8)
end sub

#define glRotateXi glRotateXi__FB__INLINE__
sub glRotateXi__FB__INLINE__(angle as integer)
  dim as integer sine = sinLerp(angle) '//SIN[angle and  LUT_MASK]
  dim as integer cosine = cosLerp(angle) '//COS[angle and LUT_MASK]
  MATRIX_MULT3x3 = inttof32(1) 
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = cosine
  MATRIX_MULT3x3 = sine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = -sine
  MATRIX_MULT3x3 = cosine
end sub

#define glRotateYi glRotateYi__FB__INLINE__
sub glRotateYi__FB__INLINE__(angle as integer)
  dim as integer sine = sinLerp(angle) '//SIN[angle and  LUT_MASK]
  dim as integer cosine = cosLerp(angle) '//COS[angle and LUT_MASK]
  MATRIX_MULT3x3 = cosine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = -sine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = inttof32(1)
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = sine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = cosine
end sub

#define glRotateZi glRotateZi__FB__INLINE__
sub glRotateZi__FB__INLINE__(angle as integer)
  dim as integer sine = sinLerp(angle)   '//SIN[angle &  LUT_MASK];
  dim as integer cosine = cosLerp(angle) '//COS[angle & LUT_MASK];
  MATRIX_MULT3x3 = cosine
  MATRIX_MULT3x3 = sine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = - sine
  MATRIX_MULT3x3 = cosine
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = 0
  MATRIX_MULT3x3 = inttof32(1)
end sub

#define glOrthof32 glOrthof32__FB__INLINE__
sub glOrthof32__FB__INLINE__(ileft as integer,iright as integer,ibottom as integer,itop as integer,izNear as integer,izFar as integer)
  MATRIX_MULT4x4 = divf32(inttof32(2), iright - ileft)
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0

  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = divf32(inttof32(2), itop - ibottom)
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0

  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = divf32(inttof32(-2), izFar - izNear)
  MATRIX_MULT4x4 = 0

  MATRIX_MULT4x4 = -divf32(iright + ileft, iright - ileft)
  MATRIX_MULT4x4 = -divf32(itop + ibottom, itop - ibottom)
  MATRIX_MULT4x4 = -divf32(izFar + izNear, izFar - izNear)
  MATRIX_MULT4x4 = floattof32(1.0F)
end sub

#define gluLookAtf32 gluLookAtf32__FB__INLINE__
sub gluLookAtf32__FB__INLINE__(eyex as integer,eyey as integer,eyez as integer,lookAtx as integer,lookAty as integer,lookAtz as integer,upx as integer,upy as integer,upz as integer)
 	dim as integer side(3-1), forward(3-1), up(3-1), eye(3-1)
 
 	forward(0) = eyex - lookAtx
 	forward(1) = eyey - lookAty
 	forward(2) = eyez - lookAtz
 
 	normalizef32(@forward(0))
 
 	up(0) = upx
 	up(1) = upy
 	up(2) = upz
 	eye(0) = eyex
 	eye(1) = eyey
 	eye(2) = eyez
 
 	crossf32(@up(0), @forward(0), @side(0))
 
 	normalizef32(@side(0))
 
 	'// Recompute local up
 	crossf32(@forward(0), @side(0), @up(0))
 
 	glMatrixMode(GL_MODELVIEW)
 
 
 	'// should we use MATRIX_MULT4x3?
 	MATRIX_MULT4x3 = side(0)
 	MATRIX_MULT4x3 = up(0)
 	MATRIX_MULT4x3 = forward(0)
 
 	MATRIX_MULT4x3 = side(1)
 	MATRIX_MULT4x3 = up(1)
 	MATRIX_MULT4x3 = forward(1)
 
 	MATRIX_MULT4x3 = side(2)
 	MATRIX_MULT4x3 = up(2)
 	MATRIX_MULT4x3 = forward(2)
 
 	MATRIX_MULT4x3 = -dotf32(@eye(0),@side(0))
 	MATRIX_MULT4x3 = -dotf32(@eye(0),@up(0))
 	MATRIX_MULT4x3 = -dotf32(@eye(0),@forward(0))
end sub

#define glFrustumf32 glFrustumf32__FB__INLINE__
sub glFrustumf32__FB__INLINE__(ileft as integer,iright as integer,ibottom as integer,itop as integer,inear as integer,ifar as integer)
  MATRIX_MULT4x4 = divf32(2*inear, iright - ileft)
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0

  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = divf32(2*inear, itop - ibottom)
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0

  MATRIX_MULT4x4 = divf32(iright + ileft, iright - ileft)
  MATRIX_MULT4x4 = divf32(itop + ibottom, itop - ibottom)
  MATRIX_MULT4x4 = -divf32(ifar + inear, ifar - inear)
  MATRIX_MULT4x4 = floattof32(-1.0)

  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = 0
  MATRIX_MULT4x4 = -divf32(2 * mulf32(ifar, inear), ifar - inear)
  MATRIX_MULT4x4 = 0
end sub

#define gluPerspectivef32 gluPerspectivef32__FB__INLINE__
sub gluPerspectivef32__FB__INLINE__(fovy as integer,aspect as integer,zNear as integer,zFar as integer)
  dim as integer xmin, xmax, ymin, ymax  
  ymax = mulf32(zNear, tanLerp(fovy shr 1))
  ymin = -ymax
  xmin = mulf32(ymin, aspect)
  xmax = mulf32(ymax, aspect)
  glFrustumf32(xmin, xmax, ymin, ymax, zNear, zFar)
end sub

'// GL_STATIC_INL
'// /*! \fn void gluPickMatrix(int x, int y, int width, int height, const int viewport[4])
'// \brief Utility function which generates a picking matrix for selection
'// \param x 2D x of center  (touch x normally)
'// \param y 2D y of center  (touch y normally)
'// \param width width in pixels of the window (3 or 4 is a good number)
'// \param height height in pixels of the window (3 or 4 is a good number)
'// \param viewport the current viewport (normally {0, 0, 255, 191}) */
'// void gluPickMatrix(int x, int y, int width, int height, const int viewport[4]) {
'// 	MATRIX_MULT4x4 = inttof32(viewport[2]) / width;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = inttof32(viewport[3]) / height;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = inttof32(1);
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = inttof32(viewport[2] + ((viewport[0] - x)<<1)) / width;
'// 	MATRIX_MULT4x4 = inttof32(viewport[3] + ((viewport[1] - y)<<1)) / height;
'// 	MATRIX_MULT4x4 = 0;
'// 	MATRIX_MULT4x4 = inttof32(1);
'// }

'// GL_STATIC_INL
'// /*!  \fn void glResetMatrixStack(void)
'// \brief Resets matrix stack to top level */
'// void glResetMatrixStack(void) {
'// 	'// make sure there are no push/pops that haven't executed yet
'// 	while(GFX_STATUS & BIT(14)){
'// 		GFX_STATUS |= 1 << 15; '// clear push/pop errors or push/pop busy bit never clears
'// 	}
'// 
'// 	'// pop the projection stack to the top; poping 0 off an empty stack causes an error... weird?
'// 	if((GFX_STATUS&(1<<13))!=0) {
'// 		glMatrixMode(GL_PROJECTION);
'// 		glPopMatrix(1);
'// 	}
'// 
'// 	'// 31 deep modelview matrix; 32nd entry works but sets error flag
'// 	glMatrixMode(GL_MODELVIEW);
'// 	glPopMatrix((GFX_STATUS >> 8) & 0x1F);
'// 
'// 	'// load identity to all the matrices
'// 	glMatrixMode(GL_MODELVIEW);
'// 	glLoadIdentity();
'// 	glMatrixMode(GL_PROJECTION);
'// 	glLoadIdentity();
'// 	glMatrixMode(GL_TEXTURE);
'// 	glLoadIdentity();
'// }

'// GL_STATIC_INL
'// /*! \fn void glSetOutlineColor(int id, _rgb color)
'// \brief Specifies an edge color for polygons
'// \param id which outline color to set (0-7)
'// \param color the 15bit color to set */
'// void glSetOutlineColor(int id, _rgb color) { GFX_EDGE_TABLE[id] = color; }

'// GL_STATIC_INL
'// /*! \fn void glSetToonTable(const uint16 *table)
'// \brief Loads a toon table
'// \param table pointer to the 32 color palette to load into the toon table*/
'// void glSetToonTable(const uint16 *table) {
'// 	int i;
'// 	for(i = 0; i < 32; i++ )
'// 		GFX_TOON_TABLE[i] = table[i];
'// }

#define glSetToonTableRange(int_start, int_end, rgb_color) for i as integer = (int_start) to (int_end): GFX_TOON_TABLE[i] = rgb_color: next i:

#define glGetFixed glGetFixed__FB__INLINE__
sub glGetFixed__FB__INLINE__(iparam as GL_GET_ENUM, f as integer ptr) 
  dim as integer i
  
  #macro WaitForGfx() 
  while GFX_BUSY
    DoNothing()
  wend
  #endmacro
  
  select case iparam 
  case GL_GET_MATRIX_VECTOR
    WaitForGfx()
    for i = 0 to 8: f[i] = MATRIX_READ_VECTOR[i]: next
    
  case GL_GET_MATRIX_CLIP
    WaitForGfx()
    for i = 0 to 15: f[i] = MATRIX_READ_CLIP[i]: next
    
  case GL_GET_MATRIX_PROJECTION
    glMatrixMode(GL_POSITION)
    glPushMatrix()
    glLoadIdentity()
    WaitForGfx()
    for i = 0 to 15:  f[i] = MATRIX_READ_CLIP[i]: next 		
    glPopMatrix(1)
    
  case GL_GET_MATRIX_POSITION
    glMatrixMode(GL_PROJECTION)
    glPushMatrix()
    glLoadIdentity()
    WaitForGfx()
    for i = 0 to 15:  f[i] = MATRIX_READ_CLIP[i]: next
    glPopMatrix(1)
  end select
  
end sub

'// GL_STATIC_INL
'// /*!  \fn void glAlphaFunc(int alphaThreshold)
'// \brief set the minimum alpha value that will be used<BR>
'// <A HREF="http:'//nocash.emubase.de/gbatek.htm#ds3ddisplaycontrol">GBATEK http:'//nocash.emubase.de/gbatek.htm#ds3ddisplaycontrol</A>
'// \param alphaThreshold minimum alpha value that will be used (0-15) */
'// void glAlphaFunc(int alphaThreshold) { GFX_ALPHA_TEST = alphaThreshold; }

'// GL_STATIC_INL
'// /*!  \fn  void glCutoffDepth(fixed12d3 wVal)
'// \brief Stop the drawing of polygons that are a certain distance from the camera.<BR>
'// <A HREF="http:'//nocash.emubase.de/gbatek.htm#ds3ddisplaycontrol">GBATEK http:'//nocash.emubase.de/gbatek.htm#ds3ddisplaycontrol</A>
'// \param wVal polygons that are beyond this W-value(distance from camera) will not be drawn; 15bit value. */
'// void glCutoffDepth(fixed12d3 wVal) { GFX_CUTOFF_DEPTH = wVal; }

#define glInit() glInit_C():

#macro glClearColor(uint8_red, uint8_green, uint8_blue, uint8_alpha)
  glGlob->clearColor = ( glGlob->clearColor and &hFFE08000) or _
  (&h7FFF and RGB15((uint8_red), (uint8_green), (uint8_blue))) or (((uint8_alpha) and &h1F) shl 16)
  GFX_CLEAR_COLOR = glGlob->clearColor
#endmacro

#define glClearPolyID(uint8_ID) glGlob->clearColor = ( glGlob->clearColor and &hC0FFFFFF) or (( (uint8_ID) and &h3F ) shl 24 ):GFX_CLEAR_COLOR = glGlob->clearColor:

'// }

'// GL_STATIC_INL
'// /*! \fn void glGetInt(GL_GET_ENUM param, int* i)
'// \brief Grabs integer state variables from openGL
'// \param param The state variable to retrieve
'// \param i pointer with room to hold the requested data */
'// void glGetInt(GL_GET_ENUM param, int* i) {
'// 	switch (param) {
'// 		case GL_GET_POLYGON_RAM_COUNT:
'// 			*i = GFX_POLYGON_RAM_USAGE;
'// 			break;
'// 		case GL_GET_VERTEX_RAM_COUNT:
'// 			*i = GFX_VERTEX_RAM_USAGE;
'// 			break;
'// 		case GL_GET_TEXTURE_WIDTH: {
'// 			gl_texture_data *tex = (gl_texture_data*)DynamicArrayGet( &glGlob->texturePtrs, glGlob->activeTexture );
'// 			if( tex )
'// 				*i = 8 << ((tex->texFormat >> 20 ) & 7 );			
'// 			break; }
'// 		case GL_GET_TEXTURE_HEIGHT: {
'// 			gl_texture_data *tex = (gl_texture_data*)DynamicArrayGet( &glGlob->texturePtrs, glGlob->activeTexture );
'// 			if( tex )
'// 				*i = 8 << ((tex->texFormat >> 23 ) & 7 );
'// 			break; }
'// 		default:
'// 			break;
'// 	}
'// }


'//---------------------------------------------------------------------------------
'//                    INLINED FlOAT WRAPPERS
'//
#define glVertex3f(float_x, float_y, float_z) glVertex3v16(floattov16(float_x), floattov16(float_y), floattov16(float_z)):
'// }

#define glRotatef32(float_angle, int_x, int_y, int_z) glRotatef32i(cast(integer,(((float_angle) * DEGREES_IN_CIRCLE / 360.0))), (int_x), (int_y), (int_z)):

#define glRotatef(float_angle, float_x, float_y, float_z) glRotatef32((float_angle), floattof32(float_x), floattof32(float_y), floattof32(float_z)):

#define glColor3f(float_r, float_g, float_b) GFX_COLOR = ((float_r)*31)+(((float_g)*31) shl 5)+(((float_b)*31) shl 10)

#define glScalef(float_x, float_y, float_z) MATRIX_SCALE = floattof32(float_x):MATRIX_SCALE = floattof32(float_y):MATRIX_SCALE = floattof32(float_z)

#macro glTranslatef(float_x, float_y, float_z)
  MATRIX_TRANSLATE = floattof32(float_x)
  MATRIX_TRANSLATE = floattof32(float_y)
  MATRIX_TRANSLATE = floattof32(float_z)
#endmacro

#define glNormal3f(float_x, float_y, float_z) glNormal(NORMAL_PACK(floattov10(float_x), floattov10(float_y), floattov10(float_z)))

#define glRotateX(floatAngle)  glRotateXi(cast(integer,((floatAngle) * DEGREES_IN_CIRCLE / 360.0)))

#define glRotateY(floatAngle)  glRotateYi(cast(integer,((floatAngle) * DEGREES_IN_CIRCLE / 360.0)))

#define glRotateZ(float_angle) glRotateZi(cast(integer,((float_angle * DEGREES_IN_CIRCLE / 360.0))))

#define glOrtho(float_left,float_right,float_bottom,float_top,float_zNear,float_zFar) glOrthof32(floattof32(float_left), floattof32(float_right), floattof32(float_bottom), floattof32(float_top), floattof32(float_zNear), floattof32(float_zFar))

#define gluLookAt gluLookAt__FB__INLINE__
sub gluLookAt__FB__INLINE__(eyex as single,eyey as single,eyez as single,lookAtx as single,lookAty as single,lookAtz as single,upx as single,upy as single,upz as single)
  gluLookAtf32(floattof32(eyex), floattof32(eyey), floattof32(eyez), _
  floattof32(lookAtx), floattof32(lookAty), floattof32(lookAtz), _
  floattof32(upx), floattof32(upy), floattof32(upz))
end sub

#define glFrustum glFrustum__FB__INLINE__
sub glFrustum__FB__INLINE__(fleft as single,fright as single,fbottom as single,ftop as single,fnear as single,ffar as single) 
  glFrustumf32(floattof32(fleft), floattof32(fright), floattof32(fbottom), floattof32(ftop), floattof32(fnear), floattof32(ffar))
end sub

#macro gluPerspective(float_fovy, float_aspect, float_zNear, float_zFar) 
  gluPerspectivef32(cast(integer,((float_fovy) * DEGREES_IN_CIRCLE / 360.0)), _
  floattof32((float_aspect)), floattof32((float_zNear)), floattof32((float_zFar)))
#endmacro

#define glTexCoord2f glTexCoord2f__FB__INLINE__
sub glTexCoord2f__FB__INLINE__(s as single,t as single)
  dim as gl_texture_data ptr tex = cast(gl_texture_data ptr, _
  DynamicArrayGet( @glGlob->texturePtrs, glGlob->activeTexture ))
  if tex then
    dim as integer x = (tex->texFormat shr 20) and 7
    dim as integer y = (tex->texFormat shr 23) and 7
    glTexCoord2t16(floattot16(s*(8 shl x)), floattot16(t*(8 shl y)))
  end if
end sub


#endif
