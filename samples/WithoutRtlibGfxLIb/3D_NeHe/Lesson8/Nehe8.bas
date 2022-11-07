#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 08          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

'//needed to load pcx files
#include "nds/arm9/image.bi"

DeclareResource(fblogo_pcx) 'CASE SENSITIVE!

declare function DrawGLScene() as integer

dim shared as integer light '// Lighting ON/OFF ( NEW )
'dim shared as integer lp    '// L Pressed? ( NEW )

dim shared as single xrot     '// X Rotation
dim shared as single yrot     '// Y Rotation
dim shared as single xspeed   '// X Rotation Speed
dim shared as single yspeed   '// Y Rotation Speed
dim shared as single z=-5.0f  '// Depth Into The Screen

'dim shared as single LightAmbient(...)  = { 0.5f, 0.5f, 0.5f, 1.0f }
'dim shared as single LightDiffuse(...)  = { 1.0f, 1.0f, 1.0f, 1.0f }
'dim shared as single LightPosition(...) = { 0.0f, 0.0f, 2.0f, 1.0f }

'// Storage For 3 Textures (only going to use 1 on the DS for this demo)
dim shared as integer texture(3-1) 

function LoadGLTextures() as integer 	'// Load PCX files And Convert To Textures

	dim as sImage pcx         '//////////////(NEW) and different from nehe.

	'//load our texture
	loadPCX(cast(u8 ptr,fblogo_pcx), @pcx)
	image8to16(@pcx)

	'//DS supports no filtering of anykind so no need for more than one texture
	glGenTextures(1, @texture(0))
	glBindTexture(0, texture(0))
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8)

	imageDestroy_(@pcx) '"ImageDestroy" is already used by FB!

	return true
end function

	'// Setup the Main screen for 3D 
	videoSetMode(MODE_0_3D)
	vramSetBankA(VRAM_A_TEXTURE)           '//NEW  must set up some memory for textures
	
	'// initialize the geometry engine
	glInit()
	
	'// enable textures
	glEnable(GL_TEXTURE_2D)
	
  glEnable(GL_BLEND)
  
	'// enable antialiasing
	glEnable(GL_ANTIALIAS)
	
	'// setup the rear plane
	glClearColor(0,0,0,31) '// BG must be opaque for AA to work
	glClearPolyID(63)      '// BG must have a unique polygon ID for AA to work
	glClearDepth(&h7FFF)

	'// Set our viewport to be the same size as the screen
	glViewport(0,0,255,191)
	
	LoadGLTextures()
	
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 100)
	
	'//set up a directional light arguments are light number (0-3), light color, 
	'//and an x,y,z vector that points in the direction of the light, the direction must be normalized
	glLight(0, RGB15(31,31,31) , 0, floattov10(-1.0), 0)
	
  glColor3f(1,1,1)
  
  glMatrixMode(GL_MODELVIEW)
  
	'//need to set up some material properties since DS does not have them set by default
	glMaterialf(GL_AMBIENT, RGB15(16,16,16))
	glMaterialf(GL_DIFFUSE, RGB15(16,16,16))
	glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(8,8,8))
	glMaterialf(GL_EMISSION, RGB15(16,16,16))
	
	'//ds uses a table for shinyness..this generates a half-ass one
	glMaterialShinyness()
	
	'// Set the current matrix to be the model matrix
  
  glMatrixMode(GL_MODELVIEW)
  
	do
	
		'//these little button functions are pretty handy
		scanKeys()
	
		if ((keysDown() and KEY_A))   then light = not light
		if (keysHeld() and KEY_R)     then z-=0.02f
		if (keysHeld() and KEY_L)     then z+=0.02f
		if (keysHeld() and KEY_LEFT)  then xspeed-=0.01f
		if (keysHeld() and KEY_RIGHT) then xspeed+=0.01f
		if (keysHeld() and KEY_UP)    then yspeed+=0.01f
		if (keysHeld() and KEY_DOWN)  then yspeed-=0.01f
    if (keysHeld() and KEY_START) then 
      xspeed=0:yspeed=0:xrot=0:yrot=0
    end if
		
		DrawGLScene()

		'// flush to screen	
		glFlush(0)
		
		'// wait for the screen to refresh
		swiWaitForVBlank()
    
	loop


function DrawGLScene() as integer '// Here's Where We Do All The Drawing

	glLoadIdentity()									
	glTranslatef(0.0f,0.0f,z)

	glRotatef(xrot,1.0f,0.0f,0.0f)
	glRotatef(yrot,0.0f,1.0f,0.0f)
  
  glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE or iif(light,POLY_FORMAT_LIGHT0,0))

	glBindTexture(GL_TEXTURE_2D, texture(0))  '//no filters to swtich between

	glBegin(GL_QUADS)
		'// Front Face
		glNormal3f( 0.0f, 0.0f, 1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		'// Back Face
		glNormal3f( 0.0f, 0.0f,-1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		'// Top Face
		glNormal3f( 0.0f, 1.0f, 0.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		'// Bottom Face
		glNormal3f( 0.0f,-1.0f, 0.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		'// Right face
		glNormal3f( 1.0f, 0.0f, 0.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
  glEnd()
    glPolyFmt(POLY_ALPHA(15) or POLY_CULL_BACK  or POLY_FORMAT_LIGHT0)
  
  glBegin(GL_QUADS)
    '// Left Face
		glNormal3f(-1.0f, 0.0f, 0.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
	glEnd()

	xrot+=xspeed
	yrot+=yspeed
	return true '// Keep Going

end function
