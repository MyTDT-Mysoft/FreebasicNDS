#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 04          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

declare function DrawGLScene() as integer

dim shared as single rtri      '// Angle For The Triangle ( NEW )
dim shared as single rquad     '// Angle For The Quad ( NEW )

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
  '*ds does this automagicaly* glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT) // Clear Screen And Depth Buffer
	glLoadIdentity()                  '// Reset The Current Modelview Matrix
	glTranslatef(-1.5f,0.0f,-4.0f)    '// Move Left 1.5 Units And Into The Screen 3.0
	glRotatef(rtri,0.0f,1.0f,0.0f)    '// Rotate The Triangle On The Y axis ( NEW )
	glColor3f(1, 1, 1)                '// set the vertex color
	glBegin(GL_TRIANGLES)             '// Start Drawing A Triangle
		glColor3f(1.0f,0.0f,0.0f)       '// Set Top Point Of Triangle To Red
		glVertex3f( 0.0f, 1.0f, 0.0f)   '// First Point Of The Triangle
		glColor3f(0.0f,1.0f,0.0f)       '// Set Left Point Of Triangle To Green
		glVertex3f(-1.0f,-1.0f, 0.0f)   '// Second Point Of The Triangle
		glColor3f(0.0f,0.0f,1.0f)       '// Set Right Point Of Triangle To Blue
		glVertex3f( 1.0f,-1.0f, 0.0f)   '// Third Point Of The Triangle
	glEnd()                           '// Done Drawing The Triangle
	glLoadIdentity()                  '// Reset The Current Modelview Matrix
	glTranslatef(1.5f,0.0f,-6.0f)     '// Move Right 1.5 Units And Into The Screen 6.0
	glRotatef(rquad,1.0f,0.0f,0.0f)   '// Rotate The Quad On The X axis ( NEW )
	glColor3f(0.5f,0.5f,1.0f)         '// Set The Color To Blue One Time Only
	glBegin(GL_QUADS)                 '// Draw A Quad
		glVertex3f(-1.0f, 1.0f, 0.0f)   '// Top Left
		glVertex3f( 1.0f, 1.0f, 0.0f)   '// Top Right
		glVertex3f( 1.0f,-1.0f, 0.0f)   '// Bottom Right
		glVertex3f(-1.0f,-1.0f, 0.0f)   '// Bottom Left
	glEnd()                           '// Done Drawing The Quad
	rtri+=0.9f                        '// Increase The Rotation Variable For The Triangle ( NEW )
	rquad-=0.75f                      '// Decrease The Rotation Variable For The Quad ( NEW )
	return true
end function
