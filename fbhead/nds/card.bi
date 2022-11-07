''
''
'' card -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __card_bi__
#define __card_bi__

#if 0
  #define CARD_CR1_ENABLE &h80
  #define CARD_CR1_IRQ &h40
  #define EEPROM_WRSR &h01
  #define EEPROM_WRDI &h04
  #define EEPROM_RDSR &h05
  #define EEPROM_WREN &h06
  #define EEPROM_RDID &h9f
  #define CARD_ACTIVATE (1 shl 31)
  #define CARD_WR (1 shl 30)
  #define CARD_nRESET (1 shl 29)
  #define CARD_SEC_LARGE (1 shl 28)
  #define CARD_CLK_SLOW (1 shl 27)
  #define CARD_SEC_CMD (1 shl 22)
  #define CARD_SEC_SEED (1 shl 15)
  #define CARD_SEC_EN (1 shl 14)
  #define CARD_SEC_DAT (1 shl 13)
  #define CARD_BUSY (1 shl 31)
  #define CARD_DATA_READY (1 shl 23)
  #define CARD_CMD_DUMMY &h9F
  #define CARD_CMD_HEADER_READ &h00
  #define CARD_CMD_HEADER_CHIPID &h90
  #define CARD_CMD_ACTIVATE_BF &h3C
  #define CARD_CMD_ACTIVATE_SEC &h40
  #define CARD_CMD_SECURE_CHIPID &h10
  #define CARD_CMD_SECURE_READ &h20
  #define CARD_CMD_DISABLE_SEC &h60
  #define CARD_CMD_DATA_MODE &hA0
  #define CARD_CMD_DATA_READ &hB7
  #define CARD_CMD_DATA_CHIPID &hB8
#endif

#define	REG_CARD_DATA_RD  cast_vu32_ptr(&h04100010)
#define REG_AUXSPICNT     cast_vu16_ptr(&h040001A0)
#define REG_AUXSPICNTH    cast_vu8_ptr(&h040001A1)
#define REG_AUXSPIDATA    cast_vu8_ptr(&h040001A2)
#define REG_ROMCTRL       cast_vu32_ptr(&h040001A4)
#define REG_CARD_COMMAND  cast_vu8_ptr(&h040001A8)

#define	REG_CARD_1B0  cast_vu32_ptr(&h040001B0)
#define	REG_CARD_1B4  cast_vu32_ptr(&h040001B4)
#define	REG_CARD_1B8  cast_vu16_ptr(&h040001B8)
#define	REG_CARD_1BA  cast_vu32_ptr(&h040001BA)

const CARD_CR1_ENABLE =  &h80  'in byte 1, i.e. 0x8000
const CARD_CR1_IRQ    =  &h40  'in byte 1, i.e. 0x4000

'// SPI EEPROM COMMANDS
enum
  SPI_EEPROM_WRSR = &h01
  SPI_EEPROM_PP   = &h02	'' Page Program
  SPI_EEPROM_READ = &h03
  SPI_EEPROM_WRDI = &h04  '' Write disable
  SPI_EEPROM_RDSR = &h05  '' Read status register
  SPI_EEPROM_WREN = &h06  '' Write enable
  SPI_EEPROM_PW   = &h0a	'' Page Write
  SPI_EEPROM_FAST = &h0b	'' Fast Read
  SPI_EEPROM_RDID = &h9f
  SPI_EEPROM_RDP  = &hab	'' Release from deep power down
  SPI_EEPROM_DPD  = &hb9  '' Deep power down
end enum

const   CARD_ACTIVATE   = (1 shl 31)            '' when writing, get the ball rolling
const   CARD_WR         = (1 shl 30)            '' Card write enable
const   CARD_nRESET     = (1 shl 29)            '' value on the /reset pin (1 = high out, not a reset state, 0 = low out = in reset)
const   CARD_SEC_LARGE  = (1 shl 28)            '' Use "other" secure area mode, which tranfers blocks of 0x1000 bytes at a time
const   CARD_CLK_SLOW   = (1 shl 27)            '' Transfer clock rate (0 = 6.7MHz, 1 = 4.2MHz)
'' Transfer block size, (0 = None, 1..6 = (0x100 << n) bytes, 7 = 4 bytes)
#define CARD_BLK_SIZE(n)  (((n)and 7)shl 24)    
const   CARD_SEC_CMD    = (1 shl 22)            '' The command transfer will be hardware encrypted (KEY2)
'' Transfer delay length part 2
#define CARD_DELAY2(n)    (((n)and &h3F)shl 16) 
const   CARD_SEC_SEED   = (1 shl 15)            '' Apply encryption (KEY2) seed to hardware registers
const   CARD_SEC_EN     = (1 shl 14)            '' Security enable
const   CARD_SEC_DAT    = (1 shl 13)            '' The data transfer will be hardware encrypted (KEY2)
'' Transfer delay length part 1
#define CARD_DELAY1(n)  = ((n) and &h1FFF)      

'' 3 bits in b10..b8 indicate something
'' read bits
const   CARD_BUSY       = (1 shl 31)            '' when reading, still expecting incomming data?
const   CARD_DATA_READY = (1 shl 23)            '' when reading, CARD_DATA_RD or CARD_DATA has another word of data and is good to go

'' Card commands
const CARD_CMD_DUMMY         = &h9F
const CARD_CMD_HEADER_READ   = &h00
const CARD_CMD_HEADER_CHIPID = &h90
const CARD_CMD_ACTIVATE_BF   = &h3C  '' Go into blowfish (KEY1) encryption mode
const CARD_CMD_ACTIVATE_SEC  = &h40  '' Go into hardware (KEY2) encryption mode
const CARD_CMD_SECURE_CHIPID = &h10
const CARD_CMD_SECURE_READ   = &h20
const CARD_CMD_DISABLE_SEC   = &h60  '' Leave hardware (KEY2) encryption mode
const CARD_CMD_DATA_MODE     = &hA0
const CARD_CMD_DATA_READ     = &hB7
const CARD_CMD_DATA_CHIPID   = &hB8

''REG_AUXSPICNT
const CARD_ENABLE     = (1 shl 15)
const CARD_SPI_ENABLE	= (1 shl 13)
const CARD_SPI_BUSY		= (1 shl  7)
const CARD_SPI_HOLD		= (1 shl  6)

const CARD_SPICNTH_ENABLE = (1 shl 7)  '' in byte 1, i.e. 0x8000
const CARD_SPICNTH_IRQ    = (1 shl 6)  '' in byte 1, i.e. 0x4000

declare sub cardWriteCommand cdecl alias "cardWriteCommand" (byval command as u8 ptr)
declare sub cardPolledTransfer cdecl alias "cardPolledTransfer" (byval flags as u32, byval destination as u32 ptr, byval length as u32, byval command as u8 ptr)
declare sub cardStartTransfer cdecl alias "cardStartTransfer" (byval command as u8 ptr, byval destination as u32 ptr, byval channel as integer, byval flags as u32)
declare function cardWriteAndRead cdecl alias "cardWriteAndRead" (byval command as u8 ptr, byval flags as u32) as uint32
declare sub cardParamCommand cdecl alias "cardParamCommand" (byval command as u8, byval parameter as u32, byval flags as u32, byval destination as u32 ptr, byval length as u32)

'' These commands require the cart to not be initialized yet, which may mean the user
'' needs to eject and reinsert the cart or they will return random data.

declare sub cardReadHeader cdecl alias "cardReadHeader" (byval header as u8 ptr)
declare function cardReadID cdecl alias "cardReadID" (byval flags as u32) as u32
declare sub cardReset cdecl alias "cardReset" ()

sub eepromWaitBusy cdecl alias "eepromWaitBusy__FB__INLINE__"() 
	while (REG_AUXSPICNT and CARD_SPI_BUSY) : wend
end sub

declare sub cardReadEeprom cdecl alias "cardReadEeprom" (byval address as u32, byval data as u8 ptr, byval length as u32, byval addrtype as u32)
declare sub cardWriteEeprom cdecl alias "cardWriteEeprom" (byval address as u32, byval data as u8 ptr, byval length as u32, byval addrtype as u32)

declare function cardEepromReadID cdecl alias "cardEepromReadID" () as u32
declare function cardEepromCommand cdecl alias "cardEepromCommand" (byval command as u8) as u8

'/*
' * -1:no card or no EEPROM
' *  0:unknown                 PassMe?
' *  1:TYPE 1  4Kbit(512Byte)  EEPROM
' *  2:TYPE 2 64Kbit(8KByte)or 512kbit(64Kbyte)   EEPROM
' *  3:TYPE 3  2Mbit(256KByte) FLASH MEMORY (some rare 4Mbit and 8Mbit chips also)
' */
declare function cardEepromGetType cdecl alias "cardEepromGetType" () as integer
'' Returns the size in bytes of EEPROM
declare function cardEepromGetSize cdecl alias "cardEepromGetSize" () as u32

'' Erases the entire chip. TYPE 3 chips MUST be erased before writing to them. (I think?)
declare sub cardEepromChipErase cdecl alias "cardEepromChipErase" ()
'' Erases a single sector of the TYPE 3 chip
declare sub cardEepromSectorErase cdecl alias "cardEepromSectorErase" (byval address as u32)




#endif
