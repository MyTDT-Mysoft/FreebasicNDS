#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

DeclareResource(statue_bin)

sub get_pen_delta( dx as integer ptr,dy as integer ptr )
	
  static as integer prev_pen(2-1) = { &h7FFFFFFF, &h7FFFFFFF }
  
	dim as u32 ikeys = keysHeld()
	dim as touchPosition touchXY
  
	if ( ikeys and KEY_TOUCH ) then	
		touchRead(@touchXY)
		if ( prev_pen(0) <> &h7FFFFFFF ) then		
			*dx = (prev_pen(0) - touchXY.rawx)
			*dy = (prev_pen(1) - touchXY.rawy)
    end if
		prev_pen(0) = touchXY.rawx
		prev_pen(1) = touchXY.rawy	
  else	
		prev_pen(0) = &h7FFFFFFF
    prev_pen(1) = &h7FFFFFFF
		*dx = 0: *dy = 0
  end if
  
end sub


dim as integer rotateX = 0
dim as integer rotateY = 0

'//set mode 0, enable BG0 and set it to 3D
videoSetMode(MODE_0_3D)

'// initialize gl
glInit()

'// enable antialiasing
glEnable(GL_ANTIALIAS)

'// setup the rear plane
glClearColor(0,0,0,31) ' // BG must be opaque for AA to work
glClearPolyID(63) ' // BG must have a unique polygon ID for AA to work
glClearDepth(&h7FFF)

'//this should work the same as the normal gl call
glViewport(0,0,255,191)

'//toon-table entry 0 is for completely unlit pixels, going up to entry 31 for completely lit
'//We block-fill it in two halves, we get cartoony 2-tone lighting
dim as single Temp = 1.114681
for CNT as integer = 0 to 31
  glSetToonTableRange( CNT, CNT, RGB15((CNT\3) xor 7,Temp-1,CNT) )  
  Temp *= 1.114681
next CNT

'//any floating point gl call is being converted to fixed prior to being implemented
glMatrixMode(GL_PROJECTION)
glLoadIdentity()
gluPerspective(70, 256.0 / 192.0, 0.1, 40)

'//NB: When toon-shading, the hw ignores lights 2 and 3
'//Also note that the hw uses the RED component of the lit vertex to index the toon-table
glLight(0, RGB15(16,16,16),0,floattov10(-1.0),0)
glLight(1, RGB15(16,16,16),floattov10(-1.0),0,0)

gluLookAt(0.0,0.0,-3.0, _ '//camera position 
0.0, 0.0, 0.0,          _ '//look at
0.0, 1.0, 0.0)          _ '//up

do
  
  glMatrixMode(GL_MODELVIEW)
  glPushMatrix()
  glRotateXi(rotateX)
  glRotateYi(rotateY)
  
  glMaterialf(GL_AMBIENT, RGB15(8,8,8))
  glMaterialf(GL_DIFFUSE, RGB15(24,24,24))
  glMaterialf(GL_SPECULAR, RGB15(0,0,0))
  glMaterialf(GL_EMISSION, RGB15(0,0,0))
  
  glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK or _
  POLY_FORMAT_LIGHT0 or POLY_FORMAT_LIGHT1 or POLY_TOON_HIGHLIGHT)
  
  scanKeys()
  dim as u32 ikeys = keysHeld()
  
  if (ikeys and KEY_UP)    then rotateX += 64
  if (ikeys and KEY_DOWN)  then rotateX -= 64
  if (ikeys and KEY_LEFT)  then rotateY += 64
  if (ikeys and KEY_RIGHT) then rotateY -= 64
  
  dim as integer pen_delta(2-1)
  get_pen_delta( @pen_delta(0), @pen_delta(1) )
  rotateY -= pen_delta(0)*8
  rotateX -= pen_delta(1)*8
  
  glCallList(cast(u32 ptr,statue_bin))
  glPopMatrix(1)
  
  glFlush(0)
  
  swiWaitForVBlank()
  
loop
