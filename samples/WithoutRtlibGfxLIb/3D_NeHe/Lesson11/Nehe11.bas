#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 11          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

'//needed to load pcx files
#include "nds/arm9/image.bi"

DeclareResource(fblogo_pcx)   'CASE SENSITIVE!

declare function DrawGLScene() as integer

dim shared as v16 points(64-1,32-1,3-1)  '// The Array For The Points On The Grid Of Our "Wave"
dim shared as integer wiggle_count = 0   '// Counter Used To Control How Fast Flag Waves

dim shared as single xrot '// X Rotation ( NEW )
dim shared as single yrot '// Y Rotation ( NEW )
dim shared as single zrot '// Z Rotation ( NEW )
dim shared as v16 hold    '// Temporarily Holds A Floating Point Value

dim shared as integer texture(1) '// Storage For Textures

function ssin(angle as single) as single
	dim as int32 s = sinLerp(cast(integer,((angle * DEGREES_IN_CIRCLE) / 360.0)))
	return f32tofloat(s)
end function

function scos(angle as single) as single
	dim as int32 s = cosLerp(cast(integer,((angle * DEGREES_IN_CIRCLE) / 360.0)))
	return f32tofloat(s)
end function
 
function LoadGLTextures() as integer '// Load PCX files And Convert To Textures
	dim as sImage pcx

	'//load our texture
	loadPCX(cast(u8 ptr,fblogo_pcx), @pcx)
	
	image8to16(@pcx)

	glGenTextures(1, @texture(0))
	glBindTexture(0, texture(0))
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8)

	return true
end function

sub InitGL() 
	
	'// Setup the Main screen for 3D 
	videoSetMode(MODE_0_3D)
	vramSetBankA(VRAM_A_TEXTURE) '//NEW  must set up some memory for textures
	
	'// initialize the geometry engine
	glInit()
	
	'// enable textures
	glEnable(GL_TEXTURE_2D)
	
	'// Set our viewport to be the same size as the screen
	glViewport(0,0,255,191)
	
	'// enable antialiasing
	glEnable(GL_ANTIALIAS)
	
	'// setup the rear plane
	glClearColor(0,0,0,31)   '// BG must be opaque for AA to work
	glClearPolyID(63)        '// BG must have a unique polygon ID for AA to work
	glClearDepth(&h7FFF)
	
	LoadGLTextures()
	
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 100)
	
	'//need to set up some material properties since DS does not have them set by default
	glMaterialf(GL_AMBIENT, RGB15(31,31,31))
	glMaterialf(GL_DIFFUSE, RGB15(31,31,31))
	glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(16,16,16))
	glMaterialf(GL_EMISSION, RGB15(31,31,31))
	
	'//ds uses a table for shinyness..this generates a half-ass one
	glMaterialShinyness()
	
	'//ds specific, several attributes can be set here	
	glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE )
	
	for x as integer = 0 to (32-1)	
		for y as integer = 0 to (32-1)		
			points(x,y,0)= (inttov16(x)/4)
			points(x,y,1)= (inttov16(y)/4)
			points(x,y,2)= sinLerp(x * (DEGREES_IN_CIRCLE / 32))
		next y
	next x
	
end sub


	InitGL()
	
	glMatrixMode(GL_MODELVIEW)
	
	do	
		DrawGLScene()
		
		'// flush to screen	
		glFlush(0)
		
		'// wait for the screen to refresh
		swiWaitForVBlank()
	loop
	

function DrawGLScene() as integer '// Here's Where We Do All The Drawing
	dim as integer x, y
	dim as t16 float_x, float_y, float_xb, float_yb
	
	glColor3b(255,255,255) '// set the vertex color
	
	glLoadIdentity() '// Reset The View

	glTranslatef(0.0f,0.0f,-12.0f)
	  
	glRotatef(xrot,1.0f,0.0f,0.0f)
	glRotatef(yrot,0.0f,1.0f,0.0f)  
	glRotatef(zrot,0.0f,0.0f,1.0f)

	glBindTexture(GL_TEXTURE_2D, texture(0))

	glBegin(GL_QUADS)
	for x = 0 to (31-1)  
		for y = 0 to (31-1)		
			float_x = inttot16(x) shl 2
			float_y = inttot16(y) shl 2
			float_xb = inttot16(x+1) shl 2
			float_yb = inttot16(y+1) shl 2
			glTexCoord2t16( float_x, float_y )
			glVertex3v16( points(x,y,0), points(x,y,1), points(x,y,2) )
			glTexCoord2t16( float_x, float_yb )
			glVertex3v16( points(x,y+1,0), points(x,y+1,1), points(x,y+1,2) )
			glTexCoord2t16( float_xb, float_yb )
			glVertex3v16( points(x+1,y+1,0), points(x+1,y+1,1), points(x+1,y+1,2) )
			glTexCoord2t16( float_xb, float_y )
			glVertex3v16( points(x+1,y,0), points(x+1,y,1), points(x+1,y,2) )      		
		next y
	next x
	glEnd()

	if wiggle_count = 2 then	
		for y = 0 to (32-1)
			hold=points(0,y,2)
			for x = 0 to (32-1)
        points(x,y,2) = points(x+1,y,2)
			next x
			points(31,y,2)=hold
		next y
		wiggle_count = 0
	end if

	wiggle_count += 1

	xrot+=0.3f
	yrot+=0.2f
	zrot+=0.4f

	return True
end function
