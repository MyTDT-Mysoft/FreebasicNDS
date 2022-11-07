#ifndef __TOUCH_H__
#define __TOUCH_H__

'/*! \file
'	\brief contains a struct with touch screen data.
'*/

'//! holds data related to the touch screen.
type touchPosition 
	as u16  rawx   '//!< Raw x value from the A2D
	as u16  rawy   '//!< Raw y value from the A2D
	as u16  px     '//!< Processes pixel X value
	as u16  py     '//!< Processes pixel Y value
	as u16  z1     '//!< Raw cross panel resistance
	as u16  z2     '//!< Raw cross panel resistance
end type
#endif
