#define ARM9

#include "crt.bi"
#include "nds.bi"

'--------------------------------------------------
' Very simple RTC example with a cheesy watch face 
'--------------------------------------------------

dim shared as zstring*10 months(12-1) = {"January", "February", "March", "April", _
"May", "June", "July", "August", "September", "October", "November", "December"}
dim shared as zstring*10 weekDays(7-1) = {"Sunday", "Monday", _ 
"Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"}
dim shared as u16 daysAtStartOfMonthLUT(12-1) = { _
0	  mod 7, _ '//januari   31              
31	mod 7, _ '//februari  28+1(leap year) 
59	mod 7, _ '//maart     31              
90	mod 7, _ '//april     30              
120	mod 7, _ '//mei       31              
151	mod 7, _ '//juni      30              
181	mod 7, _ '//juli      31              
212	mod 7, _ '//augustus  31              
243	mod 7, _ '//september 30              
273	mod 7, _ '//oktober   31              
304	mod 7, _ '//november  30              
334	mod 7 }  '//december  31              

#define isLeapYear(year) (((year) mod 4) = 0)

function getDayOfWeek(iday as uinteger,imonth as uinteger,iyear as uinteger) as uinteger
  'http://en.wikipedia.org/wiki/Calculating_the_day_of_the_week
  iday += 2*(3-((iyear\100) mod 4))
  iyear mod= 100
  iday += iyear + (iyear\4)
  iday += daysAtStartOfMonthLUT(imonth) - (isLeapYear(iyear) and (imonth <= 1))
  return iday mod 7
end function

declare sub init3D()
declare sub update3D(ihours as integer,iseconds as integer,iminutes as integer)

function main cdecl alias "main" () as integer
  
  dim as integer ihours, iseconds, iminutes, iday, imonth, iyear
  
  consoleDemoInit()
  init3D()
  
  do
    
    dim as time_t unixTime = time_()
    dim as tm ptr timeStruct = gmtime(@unixTime)
    
    ihours = timeStruct->tm_hour
    iminutes = timeStruct->tm_min
    iseconds = timeStruct->tm_sec
    iday = timeStruct->tm_mday
    imonth = timeStruct->tm_mon
    iyear = timeStruct->tm_year+1900
    
    printf(!"\x1b[2J%02i:%02i:%02i", ihours, iminutes, iseconds)
    printf(!"\n%s %s %i %i", _
    weekDays(getDayOfWeek(iday, imonth, iyear)), months(imonth), iday, iyear)
    
    update3D(ihours, iseconds, iminutes)
    
    swiWaitForVBlank()
  loop
  
	return 0
end function

'//draw a watch hands
sub DrawQuad(sx as single,sy as single,swidth as single,sheight as single)
  
	glBegin(GL_QUADS)
	glVertex3f(sx - swidth / 2, sy, 0)
	glVertex3f(sx + swidth / 2, sy, 0)
	glVertex3f(sx  + swidth / 2, sy + sheight, 0)
	glVertex3f(sx - swidth / 2, sy + sheight, 0)
	glEnd()
  
end sub

sub init3D()
  
  '//put 3D on top
  lcdMainOnTop()
  
	'// Setup the Main screen for 3D
	videoSetMode(MODE_0_3D)
  
	'// Reset the screen and setup the view
	glInit()
  
	'// Set our viewport to be the same size as the screen
	glViewport(0,0,255,191)
  
	'// Specify the Clear Color and Depth
	glClearColor(0,0,0,31)
	glClearDepth(&h7FFF)
  
	'//ds specific, several attributes can be set here
	glPolyFmt(POLY_ALPHA(31) or POLY_CULL_NONE)
  
	'// Set the current matrix to be the model matrix
	glMatrixMode(GL_MODELVIEW)
	glLoadIdentity()
  
	glMatrixMode(GL_PROJECTION)
	glLoadIdentity()
	gluPerspective(70, 256.0 / 192.0, 0.1, 100)
	gluLookAt(	0.0, 0.0, 3.0, _  '//camera possition
  0.0, 0.0, 0.0,             _  '//look at
  0.0, 1.0, 0.0)                '//up
end sub

sub update3D(ihours as integer,iseconds as integer,iminutes as integer)
  
	'//Push our original Matrix onto the stack (save state)
	glPushMatrix()
  
	'//draw second hand
	glColor3f(0,0,1)
	glRotateZ(-iseconds * 360 / 60)
	glTranslatef(0,1.9,0)
	DrawQuad(0,0,.2,.2)
  
	'// Pop our Matrix from the stack (restore state)
	glPopMatrix(1)
  
	'//Push our original Matrix onto the stack (save state)
	glPushMatrix()
  
	'//draw minute hand
	glColor3f(0,1,0)
	glRotateZ(-iminutes * 360 / 60)
	DrawQuad(0,0,.2,2)
  
	'// Pop our Matrix from the stack (restore state)
	glPopMatrix(1)
  
	'//Push our original Matrix onto the stack (save state)
	glPushMatrix()
  
	'//draw hourhand
	glColor3f(1,0,0)
	glRotateZ(-ihours * 360 / 12)
	DrawQuad(0,0,.3,1.8)
  
	'// Pop our Matrix from the stack (restore state)
	glPopMatrix(1)
  
	'// flush to screen
	glFlush(0)
end sub

