''
''
'' memory -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __memory_bi__
#define __memory_bi__

#ifdef ARM9
  #define REG_EXMEMCNT (cast_vu16_ptr(&h04000204))
#else
  #define REG_EXMEMSTAT (cast_vu16_ptr(&h04000204))
#endif

#define ARM7_MAIN_RAM_PRIORITY vBIT(15)
#define ARM7_OWNS_CARD vBIT(11)
#define ARM7_OWNS_ROM  vBIT(7)

#define REG_MBK1 cptr_vu8_ptr(&h04004040) 'WRAM_A 0..3
#define REG_MBK2 cptr_vu8_ptr(&h04004044) 'WRAM_B 0..3
#define REG_MBK3 cptr_vu8_ptr(&h04004048) 'WRAM_B 4..7
#define REG_MBK4 cptr_vu8_ptr(&h0400404C) 'WRAM_C 0..3
#define REG_MBK5 cptr_vu8_ptr(&h04004050) 'WRAM_C 4..7
#define REG_MBK6 cast_vu32_ptr(&h04004054)
#define REG_MBK7 cast_vu32_ptr(&h04004058)
#define REG_MBK8 cast_vu32_ptr(&h0400405C)
#define REG_MBK9 cast_vu32_ptr(&h04004060)

' Protection register (write-once sadly)
#ifdef ARM7
  #define PROTECTION    (cast_vu32_ptr(&h04000308))
#endif

' 8 bit pointer to the start of all the ram.
#define ALLRAM        (cast(u8 ptr,&h00000000))

' 8 bit pointer to main ram.
#define MAINRAM8      (cast(u8 ptr,&h02000000))
' 16 bit pointer to main ram.
#define MAINRAM16     (cast(u16 ptr,&h02000000))
' 32 bit pointer to main ram.
#define MAINRAM32     (cast(u32 ptr,&h02000000))

'// TODO: fixme: shared RAM

'// GBA_BUS is volatile, while GBAROM is not
'//! 16 bit volatile pointer to the GBA slot bus.
#define GBA_BUS       (cptr_Vu16_ptr(&h08000000))
'//! 16 bit pointer to the GBA slot ROM.
#define GBAROM        (cast(u16 ptr,&h08000000))

'//! 8 bit pointer to GBA slot Save ram.
#define SRAM          (cast(u8 ptr,&h0A000000))


#ifdef ARM7
#define VRAM          (cast(u16 ptr,&h06000000))
#endif


type sGBAHeader field=1
	entryPoint as u32
	logo(156-1) as u8
	title as zstring * &hC
	gamecode as zstring * &h4
	makercode as u16
	is96h as u8
	unitcode as u8
	devicecode as u8
	unused(7-1) as u8
	version as u8
	complement as u8
	checksum as u16
end type

#define GBA_HEADER (*cast(tGBAHeader ptr,&h08000000))

type sNDSHeader as tNDSHeader
type tNDSHeader field=1
	gameTitle as zstring * 12
	gameCode as zstring * 4
	makercode as zstring * 2
	unitCode as u8
	deviceType as u8
	deviceSize as u8
	reserved1(9-1) as u8
	romversion as u8
	flags as u8
  
	arm9romOffset as u32
	arm9executeAddress as any ptr
	arm9destination as any ptr
	arm9binarySize as u32
	arm7romOffset as u32
	arm7executeAddress as any ptr
	arm7destination as any ptr
	arm7binarySize as u32
  
	filenameOffset as u32
	filenameSize as u32
	fatOffset as u32
	fatSize as u32
  
	arm9overlaySource as u32
	arm9overlaySize as u32
	arm7overlaySource as u32
	arm7overlaySize as u32
  
	cardControl13 as u32
	cardControlBF as u32
	bannerOffset as u32
  
	secureCRC16 as u16
  
	readTimeout as u16
  
	unknownRAM1 as u32
	unknownRAM2 as u32
  
	bfPrime1 as u32
	bfPrime2 as u32  
	romSize as u32
  
	headerSize as u32
	zeros88(14-1) as u32
	gbaLogo(156-1) as u8
	logoCRC16 as u16
	headerCRC16 as u16
end type

type DSiHeader
	as tNDSHeader ndshdr
	as u32 debugRomSource      'debug ROM offset.
	as u32 debugRomSize        'debug size.
	as u32 debugRomDestination 'debug RAM destination.
	as u32 offset_0x16C        'reserved?

	as u8 zero(&h10-1)

	as u8 global_mbk_setting(5-1,4-1)
	as u32 arm9_mbk_setting(3-1)
	as u32 arm7_mbk_setting(3-1)
	as u32 mbk9_wramcnt_setting

	as u32 region_flags
	as u32 access_control
	as u32 scfg_ext_mask
	as u8 offset_0x1BC(3-1)
	as u8 appflags

	as any ptr arm9iromOffset
	as u32 offset_0x1C4
	as any ptr arm9idestination
	as u32 arm9ibinarySize
	as any ptr arm7iromOffset
	as u32 offset_0x1D4
	as any ptr arm7idestination
	as u32 arm7ibinarySize

	as u32 digest_ntr_start
	as u32 digest_ntr_size
	as u32 digest_twl_start
	as u32 digest_twl_size
	as u32 sector_hashtable_start
	as u32 sector_hashtable_size
	as u32 block_hashtable_start
	as u32 block_hashtable_size
	as u32 digest_sector_size
	as u32 digest_block_sectorcount

	as u32 banner_size
	as u32 offset_0x20C
	as u32 total_rom_size
	as u32 offset_0x214
	as u32 offset_0x218
	as u32 offset_0x21C

	as u32 modcrypt1_start
	as u32 modcrypt1_size
	as u32 modcrypt2_start
	as u32 modcrypt2_size

	as u32 tid_low
	as u32 tid_high
	as u32 public_sav_size
	as u32 private_sav_size
	as u8 reserved3(176-1)
	as u8 age_ratings(&h10-1)

	as u8 hmac_arm9(20-1)
	as u8 hmac_arm7(20-1)
	as u8 hmac_digest_master(20-1)
	as u8 hmac_icon_title(20-1)
	as u8 hmac_arm9i(20-1)
	as u8 hmac_arm7i(20-1)
	as u8 reserved4(40-1)
	as u8 hmac_arm9_no_secure(20-1)
	as u8 reserved5(2636-1)
	as u8 debug_args(&h180-1)
	as u8 rsa_signature(&h80-1)
end type 'tDSiHeader

#define __NDSHeader (cast(tNDSHeader ptr,&h02FFFE00))
#define __DSiHeader (cast(tDSiHeader ptr,&h02FFE000))

type sNDSBanner as tNDSBanner
type tNDSBanner field=1
	version as u16
	crc as u16
	reserved(28-1) as u8
	icon(512-1) as u8
	palette(16-1) as u16
	titles(6-1,128-1) as u16
end type

extern "C"

#ifdef ARM9
#define BUS_OWNER_ARM9 true
#define BUS_OWNER_ARM7 false

#define sysSetCartOwner sysSetCartOwner__FB__INLINE__
sub sysSetCartOwner__FB__INLINE__ (iarm9 as integer) 
  REG_EXMEMCNT = ((REG_EXMEMCNT and ((ARM7_OWNS_ROM=0))) or iif(iarm9,0,ARM7_OWNS_ROM))
end sub

#define sysSetCardOwner sysSetCardOwner__FB__INLINE__
'\fn void sysSetCardOwner(bool arm9)
'\brief Sets the owner of the DS card bus.  Both CPUs cannot have access to the DS card bus (slot 1).
'\param arm9 if true the arm9 is the owner, otherwise the arm7
sub sysSetCardOwner__FB__INLINE__(iarm9 as integer) 
  REG_EXMEMCNT = ((REG_EXMEMCNT and ((ARM7_OWNS_CARD=0))) or iif(iarm9,0,ARM7_OWNS_CARD))
end sub


'\brief Sets the owner of the DS card bus (slot 1) and gba cart bus (slot 2).  Only one cpu may access the device at a time.
'\param arm9rom if true the arm9 is the owner of slot 2, otherwise the arm7
'\param arm9card if true the arm9 is the owner of slot 1, otherwise the arm7
#define sysSetBusOwners sysSetBusOwners__FB__INLINE__
sub sysSetBusOwners__FB__INLINE__ (iarm9rom as integer,iarm9card as integer)
  REG_EXMEMCNT = (REG_EXMEMCNT and (((ARM7_OWNS_CARD or ARM7_OWNS_ROM))=0) or _
  iif(iarm9card,0,ARM7_OWNS_CARD) or iif(iarm9rom,0,ARM7_OWNS_ROM))
end sub

#endif '//ARM9

end extern

#endif
