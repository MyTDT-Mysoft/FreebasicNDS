''
''
'' interrupts -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __interrupts_bi__
#define __interrupts_bi__

enum IRQ_MASKS
	IRQ_VBLANK         = vBIT( 0)
	IRQ_HBLANK         = vBIT( 1)
	IRQ_VCOUNT         = vBIT( 2)
	IRQ_TIMER0         = vBIT( 3)
	IRQ_TIMER1         = vBIT( 4)
	IRQ_TIMER2         = vBIT( 5)
	IRQ_TIMER3         = vBIT( 6)
	IRQ_NETWORK        = vBIT( 7)
	IRQ_DMA0           = vBIT( 8)
	IRQ_DMA1           = vBIT( 9)
	IRQ_DMA2           = vBIT(10)
	IRQ_DMA3           = vBIT(11)
	IRQ_KEYS           = vBIT(12)
	IRQ_CART           = vBIT(13)
	IRQ_IPC_SYNC       = vBIT(16)
	IRQ_FIFO_EMPTY     = vBIT(17)
	IRQ_FIFO_NOT_EMPTY = vBIT(18)
	IRQ_CARD           = vBIT(19)
	IRQ_CARD_LINE      = vBIT(20)
	IRQ_GEOMETRY_FIFO  = vBIT(21)
	IRQ_LID            = vBIT(22)
	IRQ_SPI            = vBIT(23)
	IRQ_WIFI           = vBIT(24)
	IRQ_ALL            = (not 0)
end enum

'// values allowed for REG_AUXIE and REG_AUXIF
type IRQ_MASK as IRQ_MASKS
enum IRQ_MASKSAUX
	IRQ_I2C   = vBIT(6)
  IRQ_SDMMC = vBIT(8)
end enum

#define IRQ_TIMER(n) (1 shl ((n) + 3))
const MAX_INTERRUPTS = 25

'' REG_IE - Interrupt Enable Register.
''   This is the activation mask for the internal interrupts.  Unless
''   the corresponding bit is set, the IRQ will be masked out.
#define REG_IE	cast_vu32_ptr(&h04000210)
#define REG_AUXIE	cast_vu32_ptr(&h04000218)

'' REG_IF - Interrupt Flag Register.
''  Since there is only one hardware interrupt vector, the IF register
''  contains flags to indicate when a particular of interrupt has occured.
''  To acknowledge processing interrupts, set IF to the value of the interrupt handled.
#define REG_IF	cast_vu32_ptr(&h04000214)
#define REG_AUXIF	cast_vu32_ptr(&h0400021C)

'' REG_IME - Interrupt Master Enable Register.
''   When bit 0 is clear, all interrupts are masked.  When it is 1,
''   interrupts will occur if not masked out in REG_IE.
#define REG_IME	cast_vu32_ptr(&h04000208)

enum IME_VALUE
	IME_DISABLE = 0 ''Disable all interrupts.
	IME_ENABLE  = 1 ''Enable all interrupts not masked out in REG_IE
end enum
extern __irq_vector() alias "__irq_vector" as VoidFn
extern __irq_flags_t() alias "__irq_flags" as vuint32 'fix-me
extern __irq_flagsaux_t() alias "__irq_flagsaux" as vuint32 'fix-me

#define INTR_WAIT_FLAGS     *(__irq_flags)
#define INTR_WAIT_FLAGSAUX  *(__irq_flagsaux)
#define IRQ_HANDLER         *(__irq_vector)

type IntTable
	handler as IntFn
	mask as u32
end type

declare sub irqInit cdecl alias "irqInit" ()
declare sub irqSet cdecl alias "irqSet" (byval irq as u32, byval handler as VoidFn)
declare sub irqSetAUX cdecl alias "irqSetAUX" (byval irq as u32, byval handler as VoidFn)
declare sub irqClear cdecl alias "irqClear" (byval irq as u32)
declare sub irqClearAUX cdecl alias "irqClearAUX" (byval irq as u32)
declare sub irqInitHandler cdecl alias "irqInitHandler" (byval handler as VoidFn)
declare sub irqEnable cdecl alias "irqEnable" (byval irq as u32)
declare sub irqEnableAUX cdecl alias "irqEnableAUX" (byval irq as u32)
declare sub irqDisable cdecl alias "irqDisable" (byval irq as u32)
declare sub irqDisableAUX cdecl alias "irqDisableAUX" (byval irq as u32)
declare sub swiIntrWait cdecl alias "swiIntrWait" (byval waitForSet as u32, byval flags as uint32)
declare sub swiWaitForVBlank cdecl alias "swiWaitForVBlank" ()
declare function setPowerButtonCB cdecl alias "setPowerButtonCB" (byval CB as VoidFn) as VoidFn

'declare function enterCriticalSection cdecl alias "enterCriticalSection" () as integer
function enterCriticalSection cdecl alias "enterCriticalSection__FB__INLINE__" () as integer
	var oldIME = REG_IME : REG_IME = 0
	return oldIME
end function

'declare sub leaveCriticalSection cdecl alias "leaveCriticalSection" (byval oldIME as integer)
sub leaveCriticalSection cdecl alias "leaveCriticalSection__FB__INLINE__" (oldIME as integer)
	REG_IME = oldIME
end sub

#endif
