#define ARM9

#include "crt.bi"
#include "nds.bi"

'//-------------------------------------------------------
'//-------------------------------------------------------
sub renderCube(angle as integer)
 
	glPushMatrix()
	glTranslatef(0, 0, -4)
	glRotatef32i(degreesToAngle(angle), inttof32(1), inttof32(1), inttof32(1))
	
	glBegin(GL_QUADS)
		glColor3b(255,0,0):		glVertex3f(-1.0,  1.0,  1.0)
		glColor3b(0,255,0):		glVertex3f( 1.0,  1.0,  1.0)
		glColor3b(0,0,255):   glVertex3f( 1.0, -1.0,  1.0)
		glColor3b(255,255,0):	glVertex3f(-1.0, -1.0,  1.0)

		glColor3b(255,0,0):		glVertex3f(-1.0,  1.0, -1.0)
		glColor3b(0,255,0):		glVertex3f( 1.0,  1.0, -1.0)
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0, -1.0)
		glColor3b(255,255,0):	glVertex3f(-1.0, -1.0, -1.0)

		glColor3b(255,0,0):		glVertex3f(-1.0,  1.0,  1.0)
		glColor3b(0,255,0):		glVertex3f( 1.0,  1.0,  1.0)
		glColor3b(0,0,255):		glVertex3f( 1.0,  1.0, -1.0)
		glColor3b(255,255,0):	glVertex3f(-1.0,  1.0, -1.0)

		glColor3b(255,0,0):		glVertex3f(-1.0, -1.0,  1.0)
		glColor3b(0,255,0):		glVertex3f( 1.0, -1.0,  1.0)
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0, -1.0)
		glColor3b(255,255,0):	glVertex3f(-1.0, -1.0, -1.0)

		glColor3b(255,0,0):		glVertex3f( 1.0, 1.0,  -1.0)
		glColor3b(0,255,0):		glVertex3f( 1.0, 1.0,   1.0)
		glColor3b(0,0,255):		glVertex3f( 1.0,-1.0,   1.0)
		glColor3b(255,255,0):	glVertex3f( 1.0,-1.0,  -1.0)

		glColor3b(255,0,0):		glVertex3f(-1.0, 1.0,  -1.0)
		glColor3b(0,255,0):		glVertex3f(-1.0, 1.0,   1.0)
		glColor3b(0,0,255):		glVertex3f(-1.0,-1.0,   1.0)
		glColor3b(255,255,0):	glVertex3f(-1.0,-1.0,  -1.0)					

	glEnd()
 
	glPopMatrix(1)
end sub
  
'//-------------------------------------------------------
'//-------------------------------------------------------
sub renderPyramid(angle as integer)
 
	glPushMatrix()
	glTranslatef(0, 0, -4)
	glRotatef32i(degreesToAngle(angle), inttof32(1),inttof32(1),inttof32(1))
	
	glBegin(GL_QUADS)
		glColor3b(255,0,0):		glVertex3f(-1.0, -1.0,  1.0)					
		glColor3b(0,255,0):		glVertex3f( 1.0, -1.0,  1.0)					
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0, -1.0)					
		glColor3b(255,255,0):	glVertex3f(-1.0, -1.0, -1.0)					
	glEnd()

	glBegin(GL_TRIANGLES)
		glColor3b(255,0,0):		glVertex3f( 0.0,  1.0,  0.0):					
		glColor3b(0,255,0):		glVertex3f(-1.0, -1.0,  1.0):					
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0,  1.0):					

		glColor3b(255,0,0):		glVertex3f( 0.0,  1.0,  0.0):					
		glColor3b(0,255,0):		glVertex3f(-1.0, -1.0, -1.0):					
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0, -1.0):					

		glColor3b(255,0,0):		glVertex3f( 0.0,  1.0,  0.0):					
		glColor3b(0,255,0):		glVertex3f(-1.0, -1.0,  1.0):					
		glColor3b(0,0,255):		glVertex3f(-1.0, -1.0, -1.0):					

		glColor3b(255,0,0):		glVertex3f( 0.0,  1.0,  0.0):					
		glColor3b(0,255,0): 	glVertex3f( 1.0, -1.0,  1.0):					
		glColor3b(0,0,255):		glVertex3f( 1.0, -1.0, -1.0):					
	glEnd()
 
	glPopMatrix(1)
end sub
 
'//-------------------------------------------------------
'//-------------------------------------------------------
sub RenderScene(top as integer)

	static as ushort angle = 0
 
	if top then
		renderCube(angle)
	else
		renderPyramid(angle)
  end if

	angle += 1
  
end sub
 
 
'//-------------------------------------------------------
'// set up a 2D layer construced of bitmap sprites
'// this holds the image when rendering to the top screen
'//-------------------------------------------------------
'//-------------------------------------------------------
sub initSubSprites()
 
	oamInit(@oamSub, SpriteMapping_Bmp_2D_256, false)
 
	dim as integer x = 0
	dim as integer y = 0
 
	dim as integer id = 0

  #if 1
	'//set up a 4x3 grid of 64x64 sprites to cover the screen
	for y = 0 to 3-1
    for x = 0 to 4-1	
      dim as u16 ptr offset = @SPRITE_GFX_SUB[(x * 64) + (y * 64 * 256)]
      oamSet(@oamSub, x + y * 4, x * 64, y * 64, 0, 15, SpriteSize_64x64, _
      SpriteColorFormat_Bmp, offset, -1, false,false,false,false,false)      
      oamSub.oamMemory[id].attribute(0) = ATTR0_BMP or ATTR0_SQUARE or (64 * y)
      oamSub.oamMemory[id].attribute(1) = ATTR1_SIZE_64 or (64 * x)
      oamSub.oamMemory[id].attribute(2) = ATTR2_ALPHA(1) or (8 * 32 * y) or (8 * x)
      id += 1
    next x
  next y
  #endif
 
	swiWaitForVBlank()
 
	oamUpdate(@oamSub)
end sub

'//-------------------------------------------------------
'//-------------------------------------------------------
function main cdecl alias "main" () as integer
 
	videoSetMode(MODE_0_3D)
	videoSetModeSub(MODE_5_2D)
 
	glInit()
 
	'// sub sprites hold the bottom image when 3D directed to top
	initSubSprites()
 
	'// sub background holds the top image when 3D directed to bottom
	bgInitSub(3, BgType_Bmp16, BgSize_B16_256x256, 0, 0)
 
'//-------------------------------------------------------
'//	 Setup gl
'//-------------------------------------------------------
	glEnable(GL_ANTIALIAS)
 
	glClearColor(0,0,0,31) 
	glClearPolyID(63)
	glClearDepth(&h7FFF)
 
	glViewport(0,0,255,191)
 
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 100)
 
	glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE)
 
  #define IsNot 0=
'//-------------------------------------------------------
'//	 main loop
'//-------------------------------------------------------
	dim as integer top = true
 
  irqEnable(IRQ_HBLANK)
	do	
		'// wait for capture unit to be ready
		while (REG_DISPCAPCNT and DCAP_ENABLE)
      swiIntrWait(1,IRQ_ALL)
    wend
 
		'//-------------------------------------------------------
		'//	 Switch render targets
		'//-------------------------------------------------------
		top = IsNot top
 
		if top then		
			lcdMainOnBottom()
			vramSetBankC(VRAM_C_LCD)
			vramSetBankD(VRAM_D_SUB_SPRITE)
			REG_DISPCAPCNT = DCAP_BANK(2) or DCAP_ENABLE or DCAP_SIZE(3)		
		else		
			lcdMainOnTop()
			vramSetBankD(VRAM_D_LCD)
			vramSetBankC(VRAM_C_SUB_BG)
			REG_DISPCAPCNT = DCAP_BANK(3) or DCAP_ENABLE or DCAP_SIZE(3)
		end if
 
		'//-------------------------------------------------------
		'//	 Render the scene
		'//-------------------------------------------------------
		glMatrixMode(GL_MODELVIEW)
 
		renderScene(top)
 
		glFlush(0)
	loop
 
	return 0
end function
