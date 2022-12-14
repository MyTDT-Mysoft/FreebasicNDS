#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 06          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

'//needed to load pcx files
#include "nds/arm9/image.bi"

DeclareResource(fblogo_pcx) 'CASE SENSITIVE!

declare function DrawGLScene() as integer

dim shared as single xrot  '// X Rotation ( NEW )
dim shared as single yrot  '// Y Rotation ( NEW )
dim shared as single zrot  '// Z Rotation ( NEW )

dim shared as integer texture(1-1) '// Storage For One Texture ( NEW )

function LoadGLTextures() as integer '// Load PCX files And Convert To Textures

	dim as sImage pcx        '//////////////(NEW) and different from nehe.

	'//load our texture
	loadPCX(cast(u8 ptr,fblogo_pcx), @pcx)
	
	image8to16(@pcx)

	glGenTextures(1, @texture(0))
	glBindTexture(0, texture(0))
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8)

	imageDestroy_(@pcx)
	return true
  
end function

	
	'// Setup the Main screen for 3D 
	videoSetMode(MODE_0_3D)
	vramSetBankA(VRAM_A_TEXTURE)          '//NEW  must set up some memory for textures
	
	'// initialize the geometry engine
	glInit()
	
	'// enable textures
	glEnable(GL_TEXTURE_2D)
	
	'// enable antialiasing
	glEnable(GL_ANTIALIAS)
	
	'// setup the rear plane
	glClearColor(0,0,0,31)  '// BG must be opaque for AA to work
	glClearPolyID(63) '// BG must have a unique polygon ID for AA to work
	glClearDepth(&h7FFF)
	
	'// Set our viewport to be the same size as the screen
	glViewport(0,0,255,191)
	
	LoadGLTextures()
	
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 100)
	
	'// Set the current matrix to be the model matrix
	glMatrixMode(GL_MODELVIEW)
	  
  
	'//need to set up some material properties since DS does not have them set by default
	glMaterialf(GL_AMBIENT, RGB15(16,16,16))
	glMaterialf(GL_DIFFUSE, RGB15(16,16,16))
	glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(8,8,8))
	glMaterialf(GL_EMISSION, RGB15(16,16,16))
	
	'//ds uses a table for shinyness..this generates a half-ass one
	glMaterialShinyness()
	
	'//ds specific, several attributes can be set here	
	glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE or _
  POLY_FORMAT_LIGHT0 or POLY_FORMAT_LIGHT1 or POLY_FORMAT_LIGHT2)
    
	glLight(0,RGB15(31,31,31),0,floattov10(-1.0),0)
	glLight(1,RGB15(31,31,31),0,0,floattov10(-1.0))
	glLight(2,RGB15(31,31,31),0,0,floattov10(1.0))
	
	do	
		'// set the color of the vertices to be drawn
		glColor3f(1,1,1)
		
		DrawGLScene()

		'// flush to screen	
		glFlush(0)
		
		'// wait for the screen to refresh
		swiWaitForVBlank()
	loop

function DrawGLScene() as integer   '// Here's Where We Do All The Drawing
	glLoadIdentity()									'// Reset The View
	glTranslatef(0.0f,0.0f,-3.0f)

	glRotatef(xrot,1.0f,0.0f,0.0f)
	glRotatef(yrot,0.0f,1.0f,0.0f)
	glRotatef(zrot,0.0f,0.0f,1.0f)

	glBindTexture(GL_TEXTURE_2D, texture(0))

	glBegin(GL_QUADS)
		'// Front Face
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		'// Back Face
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		'// Top Face
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		'// Bottom Face
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		'// Right face
		glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f,  1.0f, -1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f( 1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 0.0f): glVertex3f( 1.0f, -1.0f,  1.0f)
		'// Left Face
		glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f, -1.0f, -1.0f)
		glTexCoord2f(1.0f, 0.0f): glVertex3f(-1.0f, -1.0f,  1.0f)
		glTexCoord2f(1.0f, 1.0f): glVertex3f(-1.0f,  1.0f,  1.0f)
		glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f,  1.0f, -1.0f)
	glEnd()

	xrot += 0.3f
	yrot += 0.2f
	zrot += 0.4f
	return true
end function
