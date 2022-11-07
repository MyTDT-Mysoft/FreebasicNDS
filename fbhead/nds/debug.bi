#ifndef NDS_DEBUG_INCLUDE
#define NDS_DEBUG_INCLUDE

extern "C"

  declare sub nocashWrite (message as const zstring ptr, ilen as integer)
  'Send a message to the no$gba debug window 
  declare sub nocashMessage(message as const zstring ptr)

end extern

#endif '' NDS_DEBUG_INCLUDE

