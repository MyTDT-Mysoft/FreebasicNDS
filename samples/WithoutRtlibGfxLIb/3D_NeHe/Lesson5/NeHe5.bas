#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 05          '
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
  
  glLoadIdentity()                      '// Reset The Current Modelview Matrix
	glTranslatef(-1.5f,0.0f,-4.0f)        '// Move Left 1.5 Units And Into The Screen 4.0
	glRotatef(rtri,0.0f,1.0f,0.0f)        '// Rotate The Triangle On The Y axis ( NEW )
	
  glBegin(GL_TRIANGLES)									'// Start Drawing A Triangle
		glColor3f(1.0f,0.0f,0.0f)						'// Red
		glVertex3f( 0.0f, 1.0f, 0.0f)			  '// Top Of Triangle (Front)
		glColor3f(0.0f,1.0f,0.0f)						'// Green
		glVertex3f(-1.0f,-1.0f, 1.0f)			  '// Left Of Triangle (Front)
		glColor3f(0.0f,0.0f,1.0f)						'// Blue
		glVertex3f( 1.0f,-1.0f, 1.0f)			  '// Right Of Triangle (Front)
		glColor3f(1.0f,0.0f,0.0f)						'// Red
		glVertex3f( 0.0f, 1.0f, 0.0f)			  '// Top Of Triangle (Right)
		glColor3f(0.0f,0.0f,1.0f)						'// Blue
		glVertex3f( 1.0f,-1.0f, 1.0f)			  '// Left Of Triangle (Right)
		glColor3f(0.0f,1.0f,0.0f)						'// Green
		glVertex3f( 1.0f,-1.0f, -1.0f)			'// Right Of Triangle (Right)
		glColor3f(1.0f,0.0f,0.0f)			      '// Red
		glVertex3f( 0.0f, 1.0f, 0.0f)			  '// Top Of Triangle (Back)
		glColor3f(0.0f,1.0f,0.0f)						'// Green
		glVertex3f( 1.0f,-1.0f, -1.0f)			'// Left Of Triangle (Back)
		glColor3f(0.0f,0.0f,1.0f)						'// Blue
		glVertex3f(-1.0f,-1.0f, -1.0f)			'// Right Of Triangle (Back)
		glColor3f(1.0f,0.0f,0.0f)						'// Red
		glVertex3f( 0.0f, 1.0f, 0.0f)			  '// Top Of Triangle (Left)
		glColor3f(0.0f,0.0f,1.0f)						'// Blue
		glVertex3f(-1.0f,-1.0f,-1.0f)			  '// Left Of Triangle (Left)
		glColor3f(0.0f,1.0f,0.0f)			      '// Green
		glVertex3f(-1.0f,-1.0f, 1.0f)			  '// Right Of Triangle (Left)
	glEnd()															  '// Done Drawing The Pyramid

	glLoadIdentity()                      '// Reset The Current Modelview Matrix
	glTranslatef(1.5f,0.0f,-4.6f)					'// Move Right 1.5 Units And Into The Screen 7.0
	glRotatef(rquad,1.0f,1.0f,1.0f)			  '// Rotate The Quad On The X axis ( NEW )
	
  glBegin(GL_QUADS)										  '// Draw A Quad
		glColor3f(0.0f,1.0f,0.0f)						'// Set The Color To Green
		glVertex3f( 1.0f, 1.0f,-1.0f)				'// Top Right Of The Quad (Top)
		glVertex3f(-1.0f, 1.0f,-1.0f)			  '// Top Left Of The Quad (Top)
		glVertex3f(-1.0f, 1.0f, 1.0f)			  '// Bottom Left Of The Quad (Top)
		glVertex3f( 1.0f, 1.0f, 1.0f)			  '// Bottom Right Of The Quad (Top)
		glColor3f(1.0f,0.5f,0.0f)						'// Set The Color To Orange
		glVertex3f( 1.0f,-1.0f, 1.0f)			  '// Top Right Of The Quad (Bottom)
		glVertex3f(-1.0f,-1.0f, 1.0f)			  '// Top Left Of The Quad (Bottom)
		glVertex3f(-1.0f,-1.0f,-1.0f)			  '// Bottom Left Of The Quad (Bottom)
		glVertex3f( 1.0f,-1.0f,-1.0f)			  '// Bottom Right Of The Quad (Bottom)
		glColor3f(1.0f,0.0f,0.0f)						'// Set The Color To Red
		glVertex3f( 1.0f, 1.0f, 1.0f)			  '// Top Right Of The Quad (Front)
		glVertex3f(-1.0f, 1.0f, 1.0f)			  '// Top Left Of The Quad (Front)
		glVertex3f(-1.0f,-1.0f, 1.0f)			  '// Bottom Left Of The Quad (Front)
		glVertex3f( 1.0f,-1.0f, 1.0f)			  '// Bottom Right Of The Quad (Front)
		glColor3f(1.0f,1.0f,0.0f)						'// Set The Color To Yellow
		glVertex3f( 1.0f,-1.0f,-1.0f)			  '// Top Right Of The Quad (Back)
		glVertex3f(-1.0f,-1.0f,-1.0f)			  '// Top Left Of The Quad (Back)
		glVertex3f(-1.0f, 1.0f,-1.0f) 			'// Bottom Left Of The Quad (Back)
		glVertex3f( 1.0f, 1.0f,-1.0f) 			'// Bottom Right Of The Quad (Back)
		glColor3f(0.0f,0.0f,1.0f)			      '// Set The Color To Blue
		glVertex3f(-1.0f, 1.0f, 1.0f)			  '// Top Right Of The Quad (Left)
		glVertex3f(-1.0f, 1.0f,-1.0f)			  '// Top Left Of The Quad (Left)
		glVertex3f(-1.0f,-1.0f,-1.0f)			  '// Bottom Left Of The Quad (Left)
		glVertex3f(-1.0f,-1.0f, 1.0f)			  '// Bottom Right Of The Quad (Left)
		glColor3f(1.0f,0.0f,1.0f) 					'// Set The Color To Violet
		glVertex3f( 1.0f, 1.0f,-1.0f)			  '// Top Right Of The Quad (Right)
		glVertex3f( 1.0f, 1.0f, 1.0f)			  '// Top Left Of The Quad (Right)
		glVertex3f( 1.0f,-1.0f, 1.0f)       '// Bottom Left Of The Quad (Right)
		glVertex3f( 1.0f,-1.0f,-1.0f)			  '// Bottom Right Of The Quad (Right)
	glEnd()															  '// Done Drawing The Quad
	
  rtri+=0.2f														'// Increase The Rotation Variable For The Triangle ( NEW )
	rquad-=0.15f												  '// Decrease The Rotation Variable For The Quad ( NEW )
	return true														'// Keep Going

end function
