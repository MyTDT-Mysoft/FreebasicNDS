#define ARM9

'// include your ndslib
#include "crt.bi"
#include "nds.bi"

'''''''''''''''''''''''''''''''''''''''''
'           NDS NeHe Lesson 10          '
'             Author: Mysoft            '
'''''''''''''''''''''''''''''''''''''''''

'//needed to load pcx files
#include "nds/arm9/image.bi"

DeclareResource(Mud_pcx)    'CASE SENSITIVE!
DeclareResource(World_txt)  'CASE SENSITIVE!
DeclareResource(fblogo_pcx) 'CASE SENSITIVE!

declare function DrawGLScene() as integer

dim shared as integer heading
dim shared as int32 xpos
dim shared as int32 zpos

dim shared as integer yrot = 0
dim shared as int32 walkbias = 0
dim shared as integer walkbiasangle = 0
dim shared as integer lookupdown = 0

dim shared as integer	texture(2-1)

type CubeRotType
  as single x=0,y=0,z=0
end type

dim shared as CubeRotType CubeRot

type VERTEX
	as v16 x, y, z
	as t16 u, v
end type
type TRIANGLE
	as VERTEX vertex(3-1)
end type
type SECTOR
	as integer numtriangles
	as TRIANGLE ptr triangle
end type

dim shared as SECTOR sector1				'// Our Model Goes Here:
dim shared as u8 ptr file = cast(u8 ptr,World_txt)

function LoadGLTextures() as integer '// Load PCX files And Convert To Textures
	
  dim as sImage pcx '//////////////(NEW) and different from nehe.
  
	glGenTextures(2, @texture(0))
	
	'//load our texture
	loadPCX(cast(u8 ptr,Mud_pcx), @pcx)
	image8to16(@pcx)
  
	glBindTexture(0, texture(0))
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD or GL_TEXTURE_WRAP_S or _
  GL_TEXTURE_WRAP_T, pcx.image.data8)
	
	imageDestroy_(@pcx) 'ImageDestroy already used by FB
  
	loadPCX(cast(u8 ptr,fblogo_pcx), @pcx)
	image8to16(@pcx)
	glBindTexture(0, texture(1))
	glTexImage2D(0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, TEXGEN_TEXCOORD, pcx.image.data8)
	
	return True
end function

sub myGetStr(buff as zstring ptr,size as integer)
  
	*buff = *file: file += 1
  
	while *buff <> 10 and *buff <> 13	
		buff += 1
		*buff = *file: file += 1
  wend
	
	buff[0] = 10
	buff[1] = 0
	
end sub
sub readstr(sstring as zstring ptr)
	do	
		myGetStr(sstring, 255)
  loop while sstring[0] = asc("/") or sstring[0] = 10
end sub
sub SetupWorld()
	dim as single x, y, z, u, v
	dim as integer numtriangles
	dim as zstring*256 oneline
  
	readstr(oneline)
	sscanf(oneline, !"NUMPOLLIES %d\n", @numtriangles)
  
	sector1.triangle = cast(TRIANGLE ptr,malloc(numtriangles*sizeof(TRIANGLE)))
	sector1.numtriangles = numtriangles
  
	for loop_ as integer = 0 to (numtriangles-1)  'LOOP already used by FB
		for vert as integer = 0 to (3-1)		
			readstr(oneline)
			sscanf(oneline, !"%f %f %f %f %f", @x, @y, @z, @u, @v)
			sector1.triangle[loop_].vertex(vert).x = floattov16(x)
			sector1.triangle[loop_].vertex(vert).y = floattov16(y)
			sector1.triangle[loop_].vertex(vert).z = floattov16(z)
			sector1.triangle[loop_].vertex(vert).u = floattot16(u*128)
			sector1.triangle[loop_].vertex(vert).v = floattot16(v*128)
    next vert
  next loop_
end sub

sub TransformCube()
	glRotatef(cubeRot.x,1.0f,0.0f,0.0f)
	glRotatef(cubeRot.y,0.0f,1.0f,0.0f)
	glRotatef(cubeRot.z,0.0f,0.0f,1.0f)
end sub
sub EmitCube(Scale as single)
  
	glPushMatrix()
	glScalef(Scale,Scale,Scale)
	
	glRotatef(cubeRot.x,1.0f,0.0f,0.0f)
	glRotatef(cubeRot.y,0.0f,1.0f,0.0f)
	glRotatef(cubeRot.z,0.0f,0.0f,1.0f)
  
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
	glPopMatrix(1)
  
end sub
sub ShadowDemo()
  
	cubeRot.y+=0.8f
  
  static as single CubeHigh = -.4
  
  CubeHigh += 1/256
  if CubeHigh > .8 then CubeHigh -= 1.6
  
  dim as single CubeScale = .1/(1+(abs(CubeHigh)))
  
	'//draw the actual cube
	glPushMatrix()
  glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK or POLY_FORMAT_LIGHT0 or POLY_FOG)
	glTranslatef(0.0f,.1+abs(CubeHigh),-.4f) '; //draw the cube up in the air
	TransformCube()
	glBindTexture(GL_TEXTURE_2D, texture(1))
	EmitCube(0.1)
	glPopMatrix(1)
  
  
	'//draw the shadow:
	scope
		'//draw the cube shadow on the ground
		glPushMatrix()
		glTranslatef(0.0f,0.01f,-0.4f)
		TransformCube()
		
		'//use no texture. set shadow color: we'll use green just to show that it is possible
		glBindTexture(0,0)
		glColor(RGB15(0,8,0))
		
		'//1st shadow pass
		'//be sure to use opaque here
		glPolyFmt(POLY_SHADOW or POLY_CULL_FRONT or POLY_ALPHA(31) )
		EmitCube(CubeScale)
		
		'//2nd shadow pass
		'//be sure to use a different polyID here (shadow with polyID 0 can't be cast on surface with polyID 0)
		'//we set the fog bit here because we want the shadow to be fogged later. i think it may be buggy but it looks better.
		glPolyFmt(POLY_SHADOW or POLY_CULL_BACK or POLY_ALPHA(15) or POLY_ID(1) or POLY_FOG)
		EmitCube(CubeScale)
		
		'//reset poly attribute
		glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE or POLY_FORMAT_LIGHT0 or POLY_FOG)
		
		glPopMatrix(1)
  end scope
end sub

'// Setup the Main screen for 3D 
videoSetMode(MODE_0_3D)
vramSetBankA(VRAM_A_TEXTURE) ' //NEW  must set up some memory for textures

consoleDemoInit()

'// initialize the geometry engine
glInit()

'// enable textures
glEnable(GL_TEXTURE_2D)

'// enable antialiasing
glEnable(GL_ANTIALIAS)

'// enable alpha blending for shadow demo
glEnable(GL_BLEND)

'// setup the rear plane
glClearColor(0,0,0,31) '// BG must be opaque for AA to work
glClearPolyID(63)      '// BG must have a unique polygon ID for AA to work
glClearDepth(&h7FFF)

'// Set our viewport to be the same size as the screen
glViewport(0,0,255,191)

LoadGLTextures()
SetupWorld()

glMatrixMode(GL_PROJECTION)
glLoadIdentity()
gluPerspective(70, 256.0 / 192.0, 0.1, 100)

glLight(0, RGB15(31,31,31),0,floattov10(-1.0),0)

'//need to set up some material properties since DS does not have them set by default
glMaterialf(GL_AMBIENT, RGB15(16,16,16))
glMaterialf(GL_DIFFUSE, RGB15(16,16,16))
glMaterialf(GL_SPECULAR, vBIT(15) or RGB15(8,8,8))
glMaterialf(GL_EMISSION, RGB15(16,16,16))

'//ds uses a table for shinyness..this generates a half-ass one
glMaterialShinyness()

'//ds specific, several attributes can be set here	
glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE or POLY_FORMAT_LIGHT0 or POLY_FOG)

'// Set the current matrix to be the model matrix
glMatrixMode(GL_MODELVIEW)

'//setup demo fog parameters
'//these parameters are somewhat arbitrary, and designed to illustrate fog in just this one case.
'//you will certainly need to tweak them for your own use.
'//be sure to have set the POLY_FOG bit on any material you want to be fogged.
glEnable(GL_FOG)
glFogShift(2)
glFogColor(0,0,0,0)
for i as integer = 0 to (32-1)  
  glFogDensity(i,(i*4)+(i shr 3))
next i	
glFogOffset(&h6000)

dim as touchPosition	thisXY
dim as touchPosition	lastXY => ( 0,0,0,0 )

do	
  '//these little button functions are pretty handy
  scanKeys()				
	
  if (keysHeld() and (KEY_LEFT or KEY_Y)) then		
    xpos -= (sinLerp(heading + degreesToAngle(90)) shr 5)
    zpos += (cosLerp(heading + degreesToAngle(90)) shr 5)
  end if
  if (keysHeld() and (KEY_RIGHT or KEY_A)) then		
    xpos += (sinLerp(heading + degreesToAngle(90)) shr 5)
    zpos -= (cosLerp(heading + degreesToAngle(90)) shr 5)
  end if
  if (keysHeld() and (KEY_DOWN or KEY_B)) then		    
    xpos -= (sinLerp(heading) shr 5)
    zpos += (cosLerp(heading) shr 5)    
    walkbiasangle += degreesToAngle(5)    
    walkbias = sinLerp(walkbiasangle) shr 4
  end if
  if (keysHeld() and (KEY_UP or KEY_X)) then		
    xpos += (sinLerp(heading) shr 5)
    zpos -= (cosLerp(heading) shr 5)
    if (walkbiasangle <= 0) then			
      walkbiasangle = DEGREES_IN_CIRCLE
    else			
      walkbiasangle -= degreesToAngle(5)						
    end if
    walkbias = sinLerp(walkbiasangle) shr 4
  end if
  
  '// Camera rotation by touch screen
  if (keysHeld() and KEY_TOUCH) then		
    touchRead(@thisXY)
    dim as int16 dx = (thisXY.px - lastXY.px)
    dim as int16 dy = (thisXY.py - lastXY.py)
    
    '// filtering measurement errors
    if abs(dx)<20 andalso abs(dy)<20 then			
    '  if dx>-3 andalso dx<3 then dx=0
    '  if dy>-2 andalso dy<2 then dy=0
      lookupdown += degreesToAngle(dy)
      heading += degreesToAngle(dx)
      yrot = heading
    end if
    lastXY = thisXY
  end if
  
  glColor3f(1,1,1)
  
  glPushMatrix()  
  DrawGLScene()  
  glPopMatrix(1)
  
  '// flush to screen
  glFlush(0)
  
  '// wait for the screen to refresh
  swiWaitForVBlank()
loop

function DrawGLScene() as integer '// Here's Where We Do All The Drawing
  
  dim as v16 x_m, y_m, z_m
  dim as t16 u_m, v_m
  dim as int32 xtrans = -xpos
  dim as int32 ztrans = -zpos  
  dim as int32 ytrans = -walkbias-(1 shl 10)
	dim as integer sceneroty = yrot 'DEGREES_IN_CIRCLE - yrot
  
  glLoadIdentity()
  
  dim numtriangles as integer
  
  glRotatef32i(lookupdown,(1 shl 12),0,0)
	glRotatef32i(sceneroty,0,(1 shl 12),0)

	glTranslatef32(xtrans, ytrans, ztrans)
    
  glBindTexture(GL_TEXTURE_2D, texture(0))
  
  numtriangles = sector1.numtriangles
  
  '// Process Each Triangle
  for loop_m as integer = 0 to (numtriangles-1)  
    glBegin(GL_TRIANGLES)
    glNormal(NORMAL_PACK( 0, 0, 1 shl 10))
    x_m = sector1.triangle[loop_m].vertex(0).x
    y_m = sector1.triangle[loop_m].vertex(0).y
    z_m = sector1.triangle[loop_m].vertex(0).z
    u_m = sector1.triangle[loop_m].vertex(0).u
    v_m = sector1.triangle[loop_m].vertex(0).v
    glTexCoord2t16(u_m,v_m): glVertex3v16(x_m,y_m,z_m)
    
    x_m = sector1.triangle[loop_m].vertex(1).x
    y_m = sector1.triangle[loop_m].vertex(1).y
    z_m = sector1.triangle[loop_m].vertex(1).z
    u_m = sector1.triangle[loop_m].vertex(1).u
    v_m = sector1.triangle[loop_m].vertex(1).v
    glTexCoord2t16(u_m,v_m): glVertex3v16(x_m,y_m,z_m)
    
    x_m = sector1.triangle[loop_m].vertex(2).x
    y_m = sector1.triangle[loop_m].vertex(2).y
    z_m = sector1.triangle[loop_m].vertex(2).z
    u_m = sector1.triangle[loop_m].vertex(2).u
    v_m = sector1.triangle[loop_m].vertex(2).v
    glTexCoord2t16(u_m,v_m): glVertex3v16(x_m,y_m,z_m)
    glEnd()
  next loop_m
  
  ShadowDemo()
  
  return true '// Everything Went OK
  
end function
