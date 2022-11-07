#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 02          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

declare function DrawGLScene() as integer

'// Setup the Main screen for 3D 
videoSetMode(MODE_0_3D)

'// initialize the geometry engine
glInit()

'// enable antialiasing
glEnable(GL_ANTIALIAS)

'// setup the rear plane
glClearColor(0,0,0,31) '// BG must be opaque for AA to work
glClearPolyID(63) '// BG must have a unique polygon ID for AA to work
glClearDepth(&h7FFF)

'// Set our viewport to be the same size as the screen
glViewport(0,0,255,191)

'// setup the view
glMatrixMode(GL_PROJECTION)
glLoadIdentity()
gluPerspective(70, 256.0 / 192.0, 0.1, 100)

'//ds specific, several attributes can be set here	
glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE)

do	
  '// Set the current matrix to be the model matrix
  glMatrixMode(GL_MODELVIEW)
  
  glColor3f(1, 1, 1) '// Set the color..not in nehe source...ds gl default will be black
  
  '//Push our original Matrix onto the stack (save state)
  glPushMatrix()
  
  DrawGLScene()
  
  '// Pop our Matrix from the stack (restore state)
  glPopMatrix(1)
  
  '//a handy little built in function to wait for a screen refresh
  swiWaitForVBlank()
  
  '// flush to screen	
  glFlush(0)	
loop

function DrawGLScene() as integer
	'//we are going to use floating point for the tutorial...keep in mind the DS has no
	'//floating point hardware.  For real life use the built in fixed point types.
	'//this is where the magic happens
	glLoadIdentity()
	return true
end function
