#define ARM9

#include "crt.bi"
#include "nds.bi"

DeclareResource(teapot_bin) 'teapot_bin // teapot_bin_end // teapot_bin_size
DeclareResource(cafe_bin)   'cafe_bin // cafe_bin_end // cafe_bin_size

sub get_pen_delta( dx as integer ptr, dy as integer ptr )
	static as integer prev_pen(2-1) = { &h7FFFFFFF, &h7FFFFFFF }
	dim as touchPosition touchXY
	
	dim as u32 ukeys = keysHeld()

	if ( ukeys and KEY_TOUCH ) then	
		
		touchRead(@touchXY)
		if prev_pen(0) <> &h7FFFFFFF then		
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


function main cdecl alias "main" () as integer

	dim as integer rotateX = 0
	dim as integer rotateY = 0

	'//set mode 0, enable BG0 and set it to 3D
	videoSetMode(MODE_0_3D)

	'// intialize gl
	glInit()
	
	'// enable antialiasing
	glEnable(GL_ANTIALIAS)
	
	'// setup the rear plane
	glClearColor(0,0,0,31) '// BG must be opaque for AA to work
	glClearPolyID(63) ' // BG must have a unique polygon ID for AA to work
	glClearDepth(&h7FFF)

	'//this should work the same as the normal gl call
	glViewport(0,0,255,191)

	vramSetBankA(VRAM_A_TEXTURE)
	glEnable(GL_TEXTURE_2D)
	
	dim as integer cafe_texid
	glGenTextures( 1, @cafe_texid )
	glBindTexture( 0, cafe_texid )
	glTexImage2D( 0, 0, GL_RGB, TEXTURE_SIZE_128 , _
  TEXTURE_SIZE_128, 0, GL_TEXTURE_WRAP_S or _
  GL_TEXTURE_WRAP_T or TEXGEN_NORMAL, cast(u8 ptr,cafe_bin) )

	
	'//any floating point gl call is being converted to fixed prior to being implemented
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 40)
	
	do	
		
    '//TEXGEN_NORMAL helpfully pops our normals into this matrix and uses the result as texcoords
		
    glMatrixMode(GL_TEXTURE)
		glLoadIdentity()
		dim as GLvector tex_scale = ( 64 shl 16, -64 shl 16, 1 shl 16 )
		glScalev( @tex_scale )	'//scale normals up from (-1,1) range into texcoords
		glRotateXi(rotateX)		  '//rotate texture-matrix to match the camera
		glRotateYi(rotateY)

		glMatrixMode(GL_POSITION)
		glLoadIdentity()
		glTranslatef32(0, 0, floattof32(-3))
		glRotateXi(rotateX)
		glRotateYi(rotateY)

		glMaterialf(GL_EMISSION, RGB15(31,31,31))

		glPolyFmt(POLY_ALPHA(31) or POLY_CULL_BACK )

		scanKeys()
		dim as u32 ukeys = keysHeld()

		if (ukeys and KEY_UP)    then rotateX += 3 shl 3
		if (ukeys and KEY_DOWN)  then rotateX -= 3 shl 3
		if (ukeys and KEY_LEFT)  then rotateY += 3 shl 3
		if (ukeys and KEY_RIGHT) then rotateY -= 3 shl 3

		dim as integer pen_delta(2-1)
		get_pen_delta( @pen_delta(0), @pen_delta(1) )
		rotateY -= pen_delta(0)
		rotateX -= pen_delta(1)

		glBindTexture( 0, cafe_texid )
		glCallList(cast(u32 ptr,teapot_bin))

		glFlush(0)
    
	loop

	return 0
  
end function
