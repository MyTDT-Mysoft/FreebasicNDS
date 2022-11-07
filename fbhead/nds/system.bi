''
''
'' system -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __system_bi__
#define __system_bi__

#include "ndstypes.bi"

' LCD status register.
#define	REG_DISPSTAT      cast_vu16_ptr(&h04000004)

#define	REG_VCOUNT        cast_vu16_ptr(&h4000006)
#define HALT_CR           cast_vu16_ptr(&h04000300)
#define	REG_POWERCNT      cast_vu16_ptr(&h4000304)
#define REG_SCFG_ROM      cast_vu16_ptr(&h4004000)
#define PM_LED_CONTROL(m) ((m) shl 4)
'#define PersonalData      cast(PERSONAL_DATA ptr,&h2FFFC80)
'#define __system_argv     cast(__argv ptr,&h02FFFE70)

#ifdef ARM7
  #define REG_SCFG_A9ROM cast_vu8_ptr(&h4004000)
  #define REG_SCFG_A7ROM cast_vu8_ptr(&h4004001)
#endif

#define REG_SCFG_CLK		cast_vu16_ptr(&h4004004)
#define REG_SCFG_RST		cast_vu16_ptr(&h4004006)
#define REG_SCFG_EXT		cast_vu32_ptr(&h4004008)
#define REG_SCFG_MC			cast_vu16_ptr(&h4004010)

sub SetYtrigger cdecl alias "SetYtrigger__FB__INLINE__" (Yvalue as integer) 
	REG_DISPSTAT = (REG_DISPSTAT and &h007F ) or (Yvalue shl 8) or (( Yvalue and &h100 ) shr 1)
end sub

#define PM_ARM9_DIRECT 1 shl 16

enum DISP_BITS
	DISP_IN_VBLANK    = 1 shl 0
	DISP_IN_HBLANK    = 1 shl 1
	DISP_YTRIGGERED   = 1 shl 2
	DISP_VBLANK_IRQ   = 1 shl 3
	DISP_HBLANK_IRQ   = 1 shl 4
	DISP_YTRIGGER_IRQ = 1 shl 5
end enum

enum PM_Bits
	PM_SOUND_AMP        = (1 shl 0)
	PM_SOUND_MUTE       = (1 shl 1)
	PM_BACKLIGHT_BOTTOM = (1 shl 2)
	PM_BACKLIGHT_TOP    = (1 shl 3)
	PM_SYSTEM_PWR       = (1 shl 6)
	POWER_LCD           = (vBIT(16) or (1 shl 0))
	POWER_2D_A          = (vBIT(16) or (1 shl 1))
	POWER_MATRIX        = (vBIT(16) or (1 shl 2))
	POWER_3D_CORE       = (vBIT(16) or (1 shl 3))
	POWER_2D_B          = (vBIT(16) or (1 shl 9))
	POWER_SWAP_LCDS     = (vBIT(16) or (1 shl 15))
	POWER_ALL_2D        = vBIT(16) or POWER_LCD or POWER_2D_A or POWER_2D_B
	POWER_ALL           = vBIT(16) or POWER_ALL_2D or POWER_3D_CORE or POWER_MATRIX
end enum

declare sub systemSleep cdecl alias "systemSleep" ()

'Set the LED blink mode
'  bm What to power on.
declare sub ledBlink cdecl alias "ledBlink" (bm as integer)

'Checks whether the application is running in DSi mode.
extern __dsimode alias "__dsimode" as bool
function isDSiMode cdecl alias "isDSiMode__FB__INLINE__" () as bool	
	return __dsimode
end function
#undef __dsimode

#if 0
enum BACKLIGHT_LEVELS
	BACKLIGHT_LOW
	BACKLIGHT_MED
	BACKLIGHT_HIGH
	BACKLIGHT_MAX
end enum
#endif

extern "C"
  #ifdef ARM9
    '#define powerOn(int_bits) REG_POWERCNT or= int_bits  
    declare sub powerOn(bits as integer)
    '#define powerOff(PM_Bits_bits) REG_POWERCNT and= not (PM_Bits_bits)
    declare sub powerOff(bits as integer)
  
    'internal fifo handlers
    declare sub systemMsgHandler(bytes as integer, user_data as any ptr)
    declare sub systemValueHandler(value as u32, pdata as any ptr)
  
    '#define lcdSwap() REG_POWERCNT xor= POWER_SWAP_LCDS
    sub lcdSwap alias "lcdSwap" ()
      REG_POWERCNT xor= POWER_SWAP_LCDS
    end sub  
    '#define lcdMainOnTop() REG_POWERCNT or= POWER_SWAP_LCDS
    sub lcdMainOnTop alias "lcdMainOnTop" () 
      REG_POWERCNT or= POWER_SWAP_LCDS
    end sub  
    '#define lcdMainOnBottom() REG_POWERCNT and= not POWER_SWAP_LCDS
    sub lcdMainOnBottom alias "lcdMainOnBottom" ()
      REG_POWERCNT and= (not POWER_SWAP_LCDS)
    end sub  
    '#define systemShutDown() powerOn(PM_SYSTEM_PWR)
    sub systemShutDown alias "systemShutDown" ()
      powerOn(PM_SYSTEM_PWR)
    end sub
    
    declare sub readFirmware(address as u32, buffer as any ptr, length as u32)
    declare function writeFirmware(address as u32 , buffer as any ptr, length as u32) as integer

    'gets the DS Battery level
    declare function getBatteryLevel() as u32

    'Set the arm9 vector base
	    'highVector high vector
    declare sub setVectorBase(highVector as integer)

    'A struct with all the CPU exeption vectors.
    'each member contains an ARM instuction that will be executed when an exeption occured.
    'See gbatek for more information.

    type sysVectors_t as sysVectors
    type sysVectors
      as VoidFn reset			      'CPU reset.
      as VoidFn undefined       'undefined instruction.
      as VoidFn swi 			      'software interrupt.
      as VoidFn prefetch_abort  'prefetch abort.
      as VoidFn data_abort      'data abort.
      as VoidFn fiq             'fast interrupt.
    end type
    extern as sysVectors SystemVectors alias "SystemVectors" '??
    
    declare sub setSDcallback( as sub (as integer) )
    
    'Sets the ARM9 clock speed, only possible in DSi mode
    '  speed: CPU speed (false = 67.03MHz, true = 134.06MHz)
    'return The old CPU speed value    
    declare function setCpuClock(speed as bool) as bool
    
    'Helper functions for heap size
    'returns current start of heap space
    declare function getHeapStart() as u8 ptr
    'returns current end of heap space
    declare function getHeapEnd() as u8 ptr
    'returns current heap limit
    declare function getHeapLimit() as u8 ptr

  #endif
  
  'TODO: convert those while implementing fb support for ARM7
  #ifdef ARM7
  
    #define REG_CONSOLEID	(*(vu64*)0x04004D00)
    //!	Power-controlled hardware devices accessable to the ARM7.
    /*!	Note that these should only be used when programming for
      the ARM7.  Trying to boot up these hardware devices via
      the ARM9 would lead to unexpected results.
      ARM7 only.
    */
    typedef enum {
      POWER_SOUND = BIT(0),			//!<	Controls the power for the sound controller.
    
      PM_CONTROL_REG		= 0,		//!<	Selects the PM control register
      PM_BATTERY_REG		= 1,		//!<	Selects the PM battery register
      PM_AMPLIFIER_REG	= 2,		//!<	Selects the PM amplifier register
      PM_READ_REGISTER	= (1<<7),	//!<	Selects the PM read register
      PM_AMP_OFFSET		= 2,		//!<	Selects the PM amp register
      PM_GAIN_OFFSET		= 3,		//!<	Selects the PM gain register
      PM_BACKLIGHT_LEVEL	= 4, 		//!<	Selects the DS Lite backlight register
      PM_GAIN_20			= 0,		//!<	Sets the mic gain to 20db
      PM_GAIN_40			= 1,		//!<	Sets the mic gain to 40db
      PM_GAIN_80			= 2,		//!<	Sets the mic gain to 80db
      PM_GAIN_160			= 3,		//!<	Sets the mic gain to 160db
      PM_AMP_ON			= 1,		//!<	Turns the sound amp on
      PM_AMP_OFF			= 0			//!<	Turns the sound amp off
    } ARM7_power;
    
    //!< PM control register bits - LED control
    #define PM_LED_CONTROL(m)  ((m)<<4)
    
    //install the fifo power handler
    void installSystemFIFO(void);
    
    //cause the ds to enter low power mode
    void systemSleep(void);
    //internal can check if sleep mode is enabled
    int sleepEnabled(void);
    
    // Warning: These functions use the SPI chain, and are thus 'critical'
    // sections, make sure to disable interrupts during the call if you've
    // got a VBlank IRQ polling the touch screen, etc...
    
    // Read/write a power management register
    int writePowerManagement(int reg, int command);
    
    static inline
    int readPowerManagement(int reg) {
      return writePowerManagement((reg)|PM_READ_REGISTER, 0);
    }
    
    static inline
    void powerOn(int bits) {
      REG_POWERCNT |= bits;
    }
    
    static inline
    void powerOff(PM_Bits bits) {
      REG_POWERCNT &= ~bits;
    }
    
    void readUserSettings();
    void systemShutDown();
    
    #define readPowerManagement(int_reg) writePowerManagement((int_reg) or PM_READ_REGISTER, 0)
  #endif
end extern

'Backlight level settings.
'Note, these are only available on DS Lite.  
enum BACKLIGHT_LEVELS
  BACKLIGHT_LOW
  BACKLIGHT_MED
  BACKLIGHT_HIGH
  BACKLIGHT_MAX
end enum
    
  'Common functions
  
  '   
  '  User's DS settings.
  '  Defines the structure the DS firmware uses for transfer
  '  of the user's settings to the booted program.
  ' 
  '  Theme/Color values:
  '  - 0 = Gray
  '  - 1 = Brown
  '  - 2 = Red
  '  - 3 = Pink
  '  - 4 = Orange
  '  - 5 = Yellow
  '  - 6 = Yellow/Green-ish
  '  - 7 = Green
  '  - 8 = Dark Green
  '  - 9 = Green/Blue-ish
  '  - 10 = Light Blue
  '  - 11 = Blue
  '  - 12 = Dark Blue
  '  - 13 = Dark Purple
  '  - 14 = Purple
  '  - 15 = Purple/Red-ish
  '
  '  Language values:
  '  - 0 = Japanese
  '  - 1 = English
  '  - 2 = French
  '  - 3 = German
  '  - 4 = Italian
  '  - 5 = Spanish
  '  - 6 = Chinese(?)
  '  - 7 = Unknown/Reserved
  '*/
  
  type tPERSONAL_DATA as PERSONAL_DATA
  type PERSONAL_DATA  
    as u8 RESERVED0(2-1)  '??? (0x05 0x00). (version according to gbatek)
  
    as u8 theme           'The user's theme color (0-15).
    as u8 birthMonth      'The user's birth month (1-12).
    as u8 birthDay        'The user's birth day (1-31).
  
    as u8 RESERVED1(1-1)  '???
  
    as s16 name(10-1)     'The user's name in UTF-16 format.
    as u16 nameLen        'The length of the user's name in characters.
  
    as s16 message(26-1)  'The user's message.
    as u16 messageLen     'The length of the user's message in characters.
  
    as u8 alarmHour				'What hour the alarm clock is set to (0-23).
    as u8 alarmMinute			'What minute the alarm clock is set to (0-59). 
    '0x02FFFCD3  alarm minute
  
    as u8 RESERVED2(4-1)  '?? 0x02FFFCD4 ??
    
    as u16 calX1          'Touchscreen calibration: first X touch
    as u16 calY1          'Touchscreen calibration: first Y touch
    as u8 calX1px         'Touchscreen calibration: first X touch pixel
    as u8 calY1px         'Touchscreen calibration: first X touch pixel
  
    as u16 calX2          'Touchscreen calibration: second X touch
    as u16 calY2          'Touchscreen calibration: second Y touch
    as u8 calX2px         'Touchscreen calibration: second X touch pixel
    as u8 calY2px         'Touchscreen calibration: second Y touch pixel
  
    as uinteger language          : 3	'User's language.
    as uinteger gbaScreen         : 1	'GBA screen selection (lower screen if set, otherwise upper screen).
    as uinteger defaultBrightness : 2	'Brightness level at power on, dslite.
    as uinteger autoMode          : 1	'The DS should boot from the DS cart or GBA cart automatically if one is inserted.
    as uinteger RESERVED5         : 2	'???
    as uinteger settingsLost      : 1	'User Settings Lost (0=Normal, 1=Prompt/Settings Lost)
    as uinteger RESERVED6         : 6	'???
  
    as u16	RESERVED3     '???
    as u32	rtcOffset     'Real Time Clock offset.
    as u32	RESERVED4     '???
  end type
  
  'Default location for the user's personal data (see PERSONAL_DATA).
  #define pPersonalData (cast(PERSONAL_DATA ptr,&h2FFFC80))
    
  'struct containing time and day of the real time clock.
  type RTCtime
    as u8 year    'add 2000 to get 4 digit year
    as u8 month   '1 to 12
    as u8 day		  '1 to (days in month)
  
    as u8 weekday 'day of week
    as u8 hours	  '0 to 11 for AM, 52 to 63 for PM
    as u8 minutes	'0 to 59
    as u8 seconds	'0 to 59
  end type  
    
  'argv struct magic number
  #define ARGV_MAGIC &h5f617267
  
  '//structure used to set up argc/argv on the DS
  type __argv
    as integer argvMagic        'argv magic number, set to 0x5f617267 ('_arg') if valid
    as zstring ptr commandLine  'base address of command line, set of null terminated strings
    as integer length           'total length of command line
    as integer argc             'internal use, number of arguments
    as zstring ptr ptr argv     'internal use, argv pointer
    as integer dummy			      'internal use
    as u32 host                 'internal use, host ip for dslink 
  end type
  
  #define __system_argv		(cast(__argv ptr,&h02FFFE70))
  
  'bootstub'
  const BOOTSIG = &h62757473746F6F62ULL 
  
  type __bootstub
    as u64    bootsig
    as VoidFn arm9reboot
    as VoidFn arm7reboot
    as u32    bootsize
  end type

extern "C"

  #ifdef ARM9
    declare function memCached (address as any ptr) as any ptr
    declare function memUncached (address as any ptr) as any ptr
    declare sub      resetARM7(address as u32)
  #endif
  #ifdef ARM7
    declare sub      resetARM9(address as u32)
  #endif

end extern

#endif
