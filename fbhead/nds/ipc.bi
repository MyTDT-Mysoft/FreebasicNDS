#ifndef NDS_IPC_INCLUDE
#define NDS_IPC_INCLUDE

#include "ndstypes.bi"

'---------------------------------------------------------------------------------
' Synchronization register                                                        
'---------------------------------------------------------------------------------
#define REG_IPC_SYNC cast_vuint16_ptr(&h04000180)

enum IPC_SYNC_BITS
  IPC_SYNC_IRQ_ENABLE		=	vBIT(14)
  IPC_SYNC_IRQ_REQUEST	=	vBIT(13)
end enum

sub IPC_SendSync cdecl alias "IPC_SendSync__FB__INLINE__" (_sync as unsigned integer)
	REG_IPC_SYNC = (REG_IPC_SYNC and &hf0ff) or (((_sync) and &h0f) shl 8) or IPC_SYNC_IRQ_REQUEST
end sub

function IPC_GetSync cdecl alias "IPC_GetSync__FB__INLINE__"() as integer
	return REG_IPC_SYNC and &h0f
end function

'---------------------------------------------------------------------------------
' fifo                                                                            
'---------------------------------------------------------------------------------
#define REG_IPC_FIFO_TX		cast_vu32_ptr(&h4000188)
#define REG_IPC_FIFO_RX		cast_vu32_ptr(&h4100000)
#define REG_IPC_FIFO_CR		cast_vu16_ptr(&h4000184)

enum IPC_CONTROL_BITS
	IPC_FIFO_SEND_EMPTY	=	(1 shl 0)
	IPC_FIFO_SEND_FULL	=	(1 shl 1)
	IPC_FIFO_SEND_IRQ	  = (1 shl 2)
	IPC_FIFO_SEND_CLEAR = (1 shl 3)
	IPC_FIFO_RECV_EMPTY = (1 shl 8)
	IPC_FIFO_RECV_FULL  = (1 shl 9)
	IPC_FIFO_RECV_IRQ   = (1 shl 10)
	IPC_FIFO_ERROR      = (1 shl 14)
	IPC_FIFO_ENABLE     = (1 shl 15)
end enum

#endif 'NDS_IPC_INCLUDE


