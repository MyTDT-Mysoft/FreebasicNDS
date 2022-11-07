#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 09          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

'//needed to load pcx files
#include "nds/arm9/image.bi"

DeclareResource(Star_pcx)   'CASE SENSITIVE!

declare function DrawGLScene() as integer

dim shared as integer twinkle		'// Twinkling Stars
dim shared as integer tp        ''T' Key Pressed?

const	as integer num=50		      '// Number Of Stars To Draw

type stars        '// Create A Structure For Star
	as integer r, g, b '// Stars Color
	as single dist     '// Stars Distance From Center
  as single angle		 '// Stars Current Angle
end type

dim shared as stars star(num-1)		 '// Need To Keep Track Of 'num' Stars

dim shared as single zoom=-15.0f	 '// Distance Away From Stars
dim shared as single tilt=90.0f		 '// Tilt The View
dim shared as single spin			     '// Spin Stars

dim shared as integer iloop        '// General Loop Variable
dim shared as integer texture(1-1) '// Storage For One textures

'// Load PCX files And Convert To Textures
function LoadGLTextures()  as integer
	dim as sImage pcx
  
	'//load our texture
	loadPCX(cast(u8 ptr,Star_pcx), @pcx)
	image8to16trans(@pcx, 0)
  
	'//DS supports no filtering of anykind so no need for more than one texture
	glGenTextures(1, @texture(0))
	glBindTexture(0, texture(0))
	glTexImage2D(0, 0, GL_RGBA, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8)
  
	imageDestroy_(@pcx)
	return true
  
end function

'// Setup the Main screen for 3D 
videoSetMode(MODE_0_3D)
vramSetBankA(VRAM_A_TEXTURE)  

'// initialize the geometry engine
glInit()

'// enable antialiasing
glEnable(GL_ANTIALIAS)

'// setup the rear plane
glClearColor(0,0,0,31)  '// BG must be opaque for AA to work
glClearPolyID(63)       '// BG must have a unique polygon ID for AA to work
glClearDepth(&h7FFF)

'// enable textures
glEnable(GL_TEXTURE_2D)

'// enable alpha blending
glEnable(GL_BLEND)

'// Set our viewport to be the same size as the screen
glViewport(0,0,255,191)

LoadGLTextures()

glMatrixMode(GL_PROJECTION)
glLoadIdentity()
gluPerspective(70, 256.0 / 192.0, 0.1, 100)
glColor3f(1,1,1)

'//set up a directional light arguments are light number (0-3), light color, 
'//and an x,y,z vector that points in the direction of the light
glLight(0, RGB15(31,31,31) , 0, 0,floattov10(-1.0))

'//need to set up some material properties since DS does not have them set by default
glMaterialf(GL_AMBIENT, RGB15(16,16,16))
glMaterialf(GL_DIFFUSE, RGB15(16,16,16))
glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(8,8,8))
glMaterialf(GL_EMISSION, RGB15(16,16,16))

'//ds uses a table for shinyness..this generates a half-ass one
glMaterialShinyness()

glPolyFmt(POLY_ALPHA(15) or POLY_CULL_BACK  or POLY_FORMAT_LIGHT0)

glMatrixMode(GL_MODELVIEW)

do
  DrawGLScene()
  
  scanKeys()				
  if ((keysDown() and KEY_A)) then twinkle xor= 1
  
  '// flush to screen	
  glFlush(0)
  
  '// wait for the screen to refresh
  swiWaitForVBlank()
  
loop


function DrawGLScene() as integer '// Here's Where We Do All The Drawing
	glBindTexture(GL_TEXTURE_2D, texture(0)) '// Select Our Texture
  
	for iloop=0 to num-1  '// Loop Through All The Stars
		
    with star(iloop)
      glLoadIdentity()								    '// Reset The View Before We Draw Each Star
      glTranslatef(0.0f,0.0f,zoom)				'// Zoom Into The Screen (Using The Value In 'zoom')
      glRotatef(tilt,1.0f,0.0f,0.0f)			'// Tilt The View (Using The Value In 'tilt')
      glRotatef(.angle,0.0f,1.0f,0.0f)    '// Rotate To The Current Stars Angle
      glTranslatef(.dist,0.0f,0.0f) 		  '// Move Forward On The X Plane
      glRotatef(-.angle,0.0f,1.0f,0.0f)   '// Cancel The Current Stars Angle
      glRotatef(-tilt,1.0f,0.0f,0.0f) 		'// Cancel The Screen Tilt
      
      if twinkle then		
        glColor3b(star((num-iloop)-1).r, _
        star((num-iloop)-1).g,star((num-iloop)-1).b)  '///different
        glBegin(GL_QUADS)
				glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f,-1.0f, 0.0f)
				glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f,-1.0f, 0.0f)
				glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f, 1.0f, 0.0f)
				glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f, 1.0f, 0.0f)
        glEnd()
      end if
      
      glRotatef(spin,0.0f,0.0f,1.0f)
      glColor3b(.r,.g,.b)                            '//different
      glBegin(GL_QUADS)
			glTexCoord2f(0.0f, 0.0f): glVertex3f(-1.0f,-1.0f, 0.0f)
			glTexCoord2f(1.0f, 0.0f): glVertex3f( 1.0f,-1.0f, 0.0f)
			glTexCoord2f(1.0f, 1.0f): glVertex3f( 1.0f, 1.0f, 0.0f)
			glTexCoord2f(0.0f, 1.0f): glVertex3f(-1.0f, 1.0f, 0.0f)
      glEnd()
      
      spin+=0.01f
      .angle+=cast(single,iloop)/num
      .dist-=0.01f
      if .dist<0.0f then		
        .dist+=5.0f
        .r=rand() mod 256
        .g=rand() mod 256
        .b=rand() mod 256
      end if
      
    end with
    
  next iloop
	
  return true '// Keep Going
  
end function
