#pragma once

#inclib "wolfssl"

#if 0
  #include once "crt/long.bi"
  #include once "crt/pthread.bi"
  #include once "crt/stdio.bi"
  #include once "dirent.bi"
  #include once "unistd.bi"
  #include once "sys/stat.bi"
  #include once "crt/time.bi"
  #include once "crt/stddef.bi"
  #include once "crt/stdlib.bi"
  #include once "crt/string.bi"
  #include once "crt/ctype.bi"
  #include once "crt/sys/types.bi"
  #include once "crt/errno.bi"
  #include once "fcntl.bi"
  #include once "crt/sys/socket.bi"
  #include once "arpa/inet.bi"
  #include once "netinet/in.bi"
  #include once "netdb.bi"
  #include once "sys/ioctl.bi"
  #include once "crt/stdarg.bi"
  #include once "sys/uio.bi"
#endif

#include once "crt.bi"

#ifndef clong 
type clong as long
type culong as ulong
#endif

#if 0
  #ifdef __FB_WIN32__
    #undef integer
    #define integer long
    #include once "win/winsock2.bi"
  #else  
    #include once "crt.bi"
    #include once "crt/sys/select.bi"
    #include once "crt/sys/socket.bi"
    #include once "crt/netinet/in.bi"
    #include once "crt/netdb.bi"
    #include once "crt/unistd.bi"
    #include once "crt/arpa/inet.bi"
  #endif
#endif

extern "C"

#define WOLFSSL_SSL_H
#define WOLF_CRYPT_SETTINGS_H
#define WOLF_CRYPT_VISIBILITY_H
#define WOLFSSL_API
#define WOLFSSL_LOCAL
#define WOLFSSL_ABI
#define WOLFSSL_MAKE_FIPS_VERSION(major, minor) (((major) * 256) + (minor))
#define WOLFSSL_FIPS_VERSION_CODE WOLFSSL_MAKE_FIPS_VERSION(0, 0)
#define FIPS_VERSION_LT(major, minor) (WOLFSSL_FIPS_VERSION_CODE < WOLFSSL_MAKE_FIPS_VERSION(major, minor))
#define FIPS_VERSION_LE(major, minor) (WOLFSSL_FIPS_VERSION_CODE <= WOLFSSL_MAKE_FIPS_VERSION(major, minor))
#define FIPS_VERSION_EQ(major, minor) (WOLFSSL_FIPS_VERSION_CODE = WOLFSSL_MAKE_FIPS_VERSION(major, minor))
#define FIPS_VERSION_GE(major, minor) (WOLFSSL_FIPS_VERSION_CODE >= WOLFSSL_MAKE_FIPS_VERSION(major, minor))
#define FIPS_VERSION_GT(major, minor) (WOLFSSL_FIPS_VERSION_CODE > WOLFSSL_MAKE_FIPS_VERSION(major, minor))
#define FLASH_QUALIFIER
#define USE_WOLFSSL_MEMORY
#define XSTREAM_ALIGN
const WOLFSSL_GENERAL_ALIGNMENT = 4
#define WOLFSSL_SP_MATH_ALL
#define HAVE_ALL_CURVES
const ECC_MIN_KEY_SZ = 224
#undef AES_MAX_KEY_SIZE
const AES_MAX_KEY_SIZE = 256
#undef WOLFSSL_AES_128
#define WOLFSSL_AES_128
#undef WOLFSSL_AES_192
#define WOLFSSL_AES_192
#undef WOLFSSL_AES_256
#define WOLFSSL_AES_256
#undef HAVE_AES_DECRYPT
#define HAVE_AES_DECRYPT
#undef HAVE_AES_CBC
#define HAVE_AES_CBC
#define HAVE_PUBLIC_FFDHE
const MIN_FFDHE_BITS = 0
const MIN_FFDHE_FP_MAX_BITS = MIN_FFDHE_BITS * 2
const WOLFSSL_MIN_AUTH_TAG_SZ = 12
#define RSA_DECODE_EXTRA
#define ECC_DECODE_EXTRA
const WC_ASYNC_DEV_SIZE = 0
#undef HAVE_PKCS12
#define HAVE_PKCS12
#undef HAVE_PKCS8
#define HAVE_PKCS8
#undef HAVE_PBKDF1
#define HAVE_PBKDF1
#undef HAVE_PBKDF2
#define HAVE_PBKDF2
const WOLFSSL_ALERT_COUNT_MAX = 5
#undef WOLFSSL_PEM_TO_DER
#define WOLFSSL_PEM_TO_DER
#undef WOLFSSL_HAVE_PRF
#define WOLFSSL_HAVE_PRF
#define WOLFSSL_BASE64_DECODE
#define WOLFSSL_SMALL_STACK_STATIC
#undef NO_RC4
#define NO_RC4
#undef WOLFSSL_ASYNC_IO
#define WOLFSSL_ASYNC_IO
#define WOLFSSL_VERSION_H
#define LIBWOLFSSL_VERSION_STRING "5.5.0"
const LIBWOLFSSL_VERSION_HEX = &h05005000
#define WOLF_CRYPT_ASN_PUBLIC_H
#define WOLF_CRYPT_TYPES_H
#define WOLF_CRYPT_PORT_H
#define WOLF_C99
#define WOLFSSL_PTHREADS
type wolfSSL_Mutex as pthread_mutex_t ptr

type wolfSSL_Ref
	mutex as wolfSSL_Mutex
	count as long
end type

declare sub wolfSSL_RefInit(byval ref as wolfSSL_Ref ptr, byval err as long ptr)
declare sub wolfSSL_RefFree(byval ref as wolfSSL_Ref ptr)
declare sub wolfSSL_RefInc(byval ref as wolfSSL_Ref ptr, byval err as long ptr)
declare sub wolfSSL_RefDec(byval ref as wolfSSL_Ref ptr, byval isZero as long ptr, byval err as long ptr)

const WOLFSSL_CRYPT_HW_MUTEX = 0
#define wolfSSL_CryptHwMutexInit() 0
#define wolfSSL_CryptHwMutexLock() 0
#define wolfSSL_CryptHwMutexUnLock() 0

declare function wc_InitMutex(byval m as wolfSSL_Mutex ptr) as long
declare function wc_InitAndAllocMutex() as wolfSSL_Mutex ptr
declare function wc_FreeMutex(byval m as wolfSSL_Mutex ptr) as long
declare function wc_LockMutex(byval m as wolfSSL_Mutex ptr) as long
declare function wc_UnLockMutex(byval m as wolfSSL_Mutex ptr) as long
declare function wolfCrypt_Init() as long
declare function wolfCrypt_Cleanup() as long
#define XFILE FILE ptr
#define XFOPEN fopen
#define XFDOPEN fdopen
#define XFSEEK fseek
#define XFTELL ftell
#define XREWIND rewind
#define XFREAD fread
#define XFWRITE fwrite
#define XFCLOSE fclose
#define XSEEK_END SEEK_END
#define XBADFILE NULL
#define XFGETS fgets
#define XFPRINTF fprintf
#define XFFLUSH fflush
#define XWRITE write
#define XREAD read
#define XCLOSE close
#define XSTAT stat
#define XS_ISREG(s) S_ISREG(s)
#define SEPARATOR_CHAR asc(":")
type XSTAT_TYPE as XSTAT

const __MAX_FILENAME_SZ = 256
const __MAX_PATH = 256

declare function wc_FileLoad(byval fname as const zstring ptr, byval buf as ubyte ptr ptr, byval bufLen as uinteger ptr, byval heap as any ptr) as long

#ifndef dirent
type dirent as dirent ptr
type dir as dir ptr
#endif

type ReadDirCtx
	entry as dirent ptr
	dir as DIR ptr
	s as stat
	name as zstring * 256
end type

const WC_READDIR_NOFILE = -1
declare function wc_ReadDirFirst(byval ctx as ReadDirCtx ptr, byval path as const zstring ptr, byval name as zstring ptr ptr) as long
declare function wc_ReadDirNext(byval ctx as ReadDirCtx ptr, byval path as const zstring ptr, byval name as zstring ptr ptr) as long
declare sub wc_ReadDirClose(byval ctx as ReadDirCtx ptr)
const WC_ISFILEEXIST_NOFILE = -1
declare function wc_FileExists(byval fname as const zstring ptr) as long

#define XVFPRINTF vfprintf
#define XVSNPRINTF vsnprintf
#define XFPUTS fputs
#define XSPRINTF sprintf
#define XMKTIME(tm) mktime(tm)
#define XDIFFTIME(to, from) difftime(to, from)
#define XTIME(tl) time((tl))
#define XGMTIME(c, t) gmtime((c))
#define USE_WOLF_VALIDDATE
#define XVALIDATE_DATE(d, f, t) wc_ValidateDate((d), (f), (t))
declare function mystrnstr(byval s1 as const zstring ptr, byval s2 as const zstring ptr, byval n as ulong) as zstring ptr
const FILE_BUFFER_SIZE = 1 * 1024
#define WOLFSSL_GLOBAL
#define LITTLE_ENDIAN_ORDER

type _byte as ubyte
type sword8 as _byte
type word8 as ubyte
type sword16 as short
type word16 as ushort
type sword32 as long
type word32 as ulong
type wcchar as const zstring const ptr

const HAVE_ANONYMOUS_INLINE_AGGREGATES = 0
#define _WC_STRINGIFY_L2(str) #str
#define WC_STRINGIFY(str) _WC_STRINGIFY_L2(str)
#define WORD64_AVAILABLE
#define W64LIT(x) x##LL
type sword64 as longint
type word64 as ulongint
#define WC_32BIT_CPU
type wolfssl_word as word32
#define WOLFCRYPT_SLOW_WORD64

type w64wrapper
	n as word64
end type

type wc_ptr_t as uinteger

enum
	WOLFSSL_WORD_SIZE = sizeof(wolfssl_word)
	WOLFSSL_BIT_SIZE = 8
	WOLFSSL_WORD_BITS = WOLFSSL_WORD_SIZE * WOLFSSL_BIT_SIZE
end enum

const WOLFSSL_MAX_16BIT = &hffffu
'STILL TODO?
#define WC_INLINE
#define THREAD_LS_T
#undef FALL_THROUGH
#define FALL_THROUGH
#define XSTR_SIZEOF(x) (sizeof(x) - 1)
#define WOLFSSL_MEMORY_H

type wolfSSL_Malloc_cb as function(byval size as uinteger) as any ptr
type wolfSSL_Free_cb as sub(byval ptr as any ptr)
type wolfSSL_Realloc_cb as function(byval ptr as any ptr, byval size as uinteger) as any ptr

declare function wolfSSL_Malloc(byval size as uinteger) as any ptr
declare sub wolfSSL_Free_(byval ptr as any ptr)
declare function wolfSSL_Realloc(byval ptr as any ptr, byval size as uinteger) as any ptr
declare function wolfSSL_SetAllocators(byval mf as wolfSSL_Malloc_cb, byval ff as wolfSSL_Free_cb, byval rf as wolfSSL_Realloc_cb) as long
declare function wolfSSL_GetAllocators(byval mf as wolfSSL_Malloc_cb ptr, byval ff as wolfSSL_Free_cb ptr, byval rf as wolfSSL_Realloc_cb ptr) as long

#macro XMALLOC(s, h, t)
	scope
		cast(any, (h))
		cast(any, (t))
		wolfSSL_Malloc((s))
	end scope
#endmacro
#macro XFREE(p, h, t)
	scope
		dim xp as any ptr = (p)
		if xp then
			wolfSSL_Free_(xp)
		end if
	end scope
#endmacro
#define XREALLOC(p, n, h, t) wolfSSL_Realloc((p), (n))
#undef WC_DECLARE_VAR_IS_HEAP_ALLOC
#define WC_DECLARE_VAR(VAR_NAME, VAR_TYPE, VAR_SIZE, HEAP) VAR_TYPE VAR_NAME[VAR_SIZE]
#define WC_DECLARE_ARRAY(VAR_NAME, VAR_TYPE, VAR_ITEMS, VAR_SIZE, HEAP) VAR_TYPE VAR_NAME[VAR_ITEMS][VAR_SIZE]
#macro WC_INIT_ARRAY(VAR_NAME, VAR_TYPE, VAR_ITEMS, VAR_SIZE, HEAP)
	scope
	end scope
#endmacro
#define WC_FREE_VAR(VAR_NAME, HEAP)
#define WC_FREE_ARRAY(VAR_NAME, VAR_ITEMS, HEAP)

'' TODO: #define WC_DECLARE_ARRAY_DYNAMIC_DEC(VAR_NAME, VAR_TYPE, VAR_ITEMS, VAR_SIZE, HEAP) VAR_TYPE* VAR_NAME[VAR_ITEMS]; int idx##VAR_NAME, inner_idx_##VAR_NAME
'' TODO: #define WC_DECLARE_ARRAY_DYNAMIC_EXE(VAR_NAME, VAR_TYPE, VAR_ITEMS, VAR_SIZE, HEAP) for (idx##VAR_NAME=0; idx##VAR_NAME<(VAR_ITEMS); idx##VAR_NAME++) { (VAR_NAME)[idx##VAR_NAME] = (VAR_TYPE*)XMALLOC(VAR_SIZE, (HEAP), DYNAMIC_TYPE_TMP_BUFFER); if ((VAR_NAME)[idx##VAR_NAME] == NULL) { for (inner_idx_##VAR_NAME = 0; inner_idx_##VAR_NAME < idx##VAR_NAME; inner_idx_##VAR_NAME++) { XFREE((VAR_NAME)[inner_idx_##VAR_NAME], HEAP, DYNAMIC_TYPE_TMP_BUFFER); (VAR_NAME)[inner_idx_##VAR_NAME] = NULL; } for (inner_idx_##VAR_NAME = idx##VAR_NAME + 1; inner_idx_##VAR_NAME < (VAR_ITEMS); inner_idx_##VAR_NAME++) { (VAR_NAME)[inner_idx_##VAR_NAME] = NULL; } break; } }
'' TODO: #define WC_FREE_ARRAY_DYNAMIC(VAR_NAME, VAR_ITEMS, HEAP) for (idx##VAR_NAME=0; idx##VAR_NAME<(VAR_ITEMS); idx##VAR_NAME++) { XFREE((VAR_NAME)[idx##VAR_NAME], (HEAP), DYNAMIC_TYPE_TMP_BUFFER); }

#define USE_WOLF_STRTOK
#define USE_WOLF_STRSEP
#define USE_WOLF_STRLCPY
#define USE_WOLF_STRLCAT
#define XMEMCPY(d, s, l) memcpy((d), (s), (l))
#define XMEMSET(b, c, l) memset((b), (c), (l))
#define XMEMCMP(s1, s2, n) memcmp((s1), (s2), (n))
#define XMEMMOVE(d, s, l) memmove((d), (s), (l))
#define XSTRLEN(s1) strlen((s1))
#define XSTRNCPY(s1, s2, n) strncpy((s1), (s2), (n))
#define XSTRSTR(s1, s2) strstr((s1), (s2))
#define XSTRNSTR(s1, s2, n) mystrnstr((s1), (s2), (n))
#define XSTRNCMP(s1, s2, n) strncmp((s1), (s2), (n))
#define XSTRCMP(s1, s2) strcmp((s1), (s2))
#define XSTRNCAT(s1, s2, n) strncat((s1), (s2), (n))
#define XSTRSEP(s1, d) wc_strsep((s1), (d))
#define XSTRCASECMP(s1, s2) strcasecmp((s1), (s2))
#define XSTRNCASECMP(s1, s2, n) strncasecmp((s1), (s2), (n))
#define XSNPRINTF snprintf
#define XATOI(s) atoi((s))

declare function wc_strtok(byval str as zstring ptr, byval delim as const zstring ptr, byval nextp as zstring ptr ptr) as zstring ptr
declare function wc_strsep(byval stringp as zstring ptr ptr, byval delim as const zstring ptr) as zstring ptr
declare function wc_strlcpy(byval dst as zstring ptr, byval src as const zstring ptr, byval dstSize as uinteger) as uinteger
#define XSTRLCPY(s1, s2, n) wc_strlcpy((s1), (s2), (n))
declare function wc_strlcat(byval dst as zstring ptr, byval src as const zstring ptr, byval dstSize as uinteger) as uinteger

#define XSTRLCAT(s1, s2, n) wc_strlcat((s1), (s2), (n))
#define XGETENV getenv
#define XTOUPPER(c) toupper((c))
#define XTOLOWER(c) tolower((c))
'#define OFFSETOF(type, field) offsetof(type, field)

enum
	DYNAMIC_TYPE_CA = 1
	DYNAMIC_TYPE_CERT = 2
	DYNAMIC_TYPE_KEY = 3
	DYNAMIC_TYPE_FILE = 4
	DYNAMIC_TYPE_SUBJECT_CN = 5
	DYNAMIC_TYPE_PUBLIC_KEY = 6
	DYNAMIC_TYPE_SIGNER = 7
	DYNAMIC_TYPE_NONE = 8
	DYNAMIC_TYPE_BIGINT = 9
	DYNAMIC_TYPE_RSA = 10
	DYNAMIC_TYPE_METHOD = 11
	DYNAMIC_TYPE_OUT_BUFFER = 12
	DYNAMIC_TYPE_IN_BUFFER = 13
	DYNAMIC_TYPE_INFO = 14
	DYNAMIC_TYPE_DH = 15
	DYNAMIC_TYPE_DOMAIN = 16
	DYNAMIC_TYPE_SSL = 17
	DYNAMIC_TYPE_CTX = 18
	DYNAMIC_TYPE_WRITEV = 19
	DYNAMIC_TYPE_OPENSSL = 20
	DYNAMIC_TYPE_DSA = 21
	DYNAMIC_TYPE_CRL = 22
	DYNAMIC_TYPE_REVOKED = 23
	DYNAMIC_TYPE_CRL_ENTRY = 24
	DYNAMIC_TYPE_CERT_MANAGER = 25
	DYNAMIC_TYPE_CRL_MONITOR = 26
	DYNAMIC_TYPE_OCSP_STATUS = 27
	DYNAMIC_TYPE_OCSP_ENTRY = 28
	DYNAMIC_TYPE_ALTNAME = 29
	DYNAMIC_TYPE_SUITES = 30
	DYNAMIC_TYPE_CIPHER = 31
	DYNAMIC_TYPE_RNG = 32
	DYNAMIC_TYPE_ARRAYS = 33
	DYNAMIC_TYPE_DTLS_POOL = 34
	DYNAMIC_TYPE_SOCKADDR = 35
	DYNAMIC_TYPE_LIBZ = 36
	DYNAMIC_TYPE_ECC = 37
	DYNAMIC_TYPE_TMP_BUFFER = 38
	DYNAMIC_TYPE_DTLS_MSG = 39
	DYNAMIC_TYPE_X509 = 40
	DYNAMIC_TYPE_TLSX = 41
	DYNAMIC_TYPE_OCSP = 42
	DYNAMIC_TYPE_SIGNATURE = 43
	DYNAMIC_TYPE_HASHES = 44
	DYNAMIC_TYPE_SRP = 45
	DYNAMIC_TYPE_COOKIE_PWD = 46
	DYNAMIC_TYPE_USER_CRYPTO = 47
	DYNAMIC_TYPE_OCSP_REQUEST = 48
	DYNAMIC_TYPE_X509_EXT = 49
	DYNAMIC_TYPE_X509_STORE = 50
	DYNAMIC_TYPE_X509_CTX = 51
	DYNAMIC_TYPE_URL = 52
	DYNAMIC_TYPE_DTLS_FRAG = 53
	DYNAMIC_TYPE_DTLS_BUFFER = 54
	DYNAMIC_TYPE_SESSION_TICK = 55
	DYNAMIC_TYPE_PKCS = 56
	DYNAMIC_TYPE_MUTEX = 57
	DYNAMIC_TYPE_PKCS7 = 58
	DYNAMIC_TYPE_AES_BUFFER = 59
	DYNAMIC_TYPE_WOLF_BIGINT = 60
	DYNAMIC_TYPE_ASN1 = 61
	DYNAMIC_TYPE_LOG = 62
	DYNAMIC_TYPE_WRITEDUP = 63
	DYNAMIC_TYPE_PRIVATE_KEY = 64
	DYNAMIC_TYPE_HMAC = 65
	DYNAMIC_TYPE_ASYNC = 66
	DYNAMIC_TYPE_ASYNC_NUMA = 67
	DYNAMIC_TYPE_ASYNC_NUMA64 = 68
	DYNAMIC_TYPE_CURVE25519 = 69
	DYNAMIC_TYPE_ED25519 = 70
	DYNAMIC_TYPE_SECRET = 71
	DYNAMIC_TYPE_DIGEST = 72
	DYNAMIC_TYPE_RSA_BUFFER = 73
	DYNAMIC_TYPE_DCERT = 74
	DYNAMIC_TYPE_STRING = 75
	DYNAMIC_TYPE_PEM = 76
	DYNAMIC_TYPE_DER = 77
	DYNAMIC_TYPE_CERT_EXT = 78
	DYNAMIC_TYPE_ALPN = 79
	DYNAMIC_TYPE_ENCRYPTEDINFO = 80
	DYNAMIC_TYPE_DIRCTX = 81
	DYNAMIC_TYPE_HASHCTX = 82
	DYNAMIC_TYPE_SEED = 83
	DYNAMIC_TYPE_SYMMETRIC_KEY = 84
	DYNAMIC_TYPE_ECC_BUFFER = 85
	DYNAMIC_TYPE_SALT = 87
	DYNAMIC_TYPE_HASH_TMP = 88
	DYNAMIC_TYPE_BLOB = 89
	DYNAMIC_TYPE_NAME_ENTRY = 90
	DYNAMIC_TYPE_CURVE448 = 91
	DYNAMIC_TYPE_ED448 = 92
	DYNAMIC_TYPE_AES = 93
	DYNAMIC_TYPE_CMAC = 94
	DYNAMIC_TYPE_FALCON = 95
	DYNAMIC_TYPE_SESSION = 96
	DYNAMIC_TYPE_DILITHIUM = 97
	DYNAMIC_TYPE_SNIFFER_SERVER = 1000
	DYNAMIC_TYPE_SNIFFER_SESSION = 1001
	DYNAMIC_TYPE_SNIFFER_PB = 1002
	DYNAMIC_TYPE_SNIFFER_PB_BUFFER = 1003
	DYNAMIC_TYPE_SNIFFER_TICKET_ID = 1004
	DYNAMIC_TYPE_SNIFFER_NAMED_KEY = 1005
	DYNAMIC_TYPE_SNIFFER_KEY = 1006
end enum

const WOLFSSL_MAX_ERROR_SZ = 80

enum
	MIN_STACK_BUFFER = 8
end enum

type wc_AlgoType as long
enum
	WC_ALGO_TYPE_NONE = 0
	WC_ALGO_TYPE_HASH = 1
	WC_ALGO_TYPE_CIPHER = 2
	WC_ALGO_TYPE_PK = 3
	WC_ALGO_TYPE_RNG = 4
	WC_ALGO_TYPE_SEED = 5
	WC_ALGO_TYPE_HMAC = 6
	WC_ALGO_TYPE_CMAC = 7
	WC_ALGO_TYPE_MAX = WC_ALGO_TYPE_CMAC
end enum

type wc_HashType as long
enum
	WC_HASH_TYPE_NONE = 0
	WC_HASH_TYPE_MD2 = 1
	WC_HASH_TYPE_MD4 = 2
	WC_HASH_TYPE_MD5 = 3
	WC_HASH_TYPE_SHA = 4
	WC_HASH_TYPE_SHA224 = 5
	WC_HASH_TYPE_SHA256 = 6
	WC_HASH_TYPE_SHA384 = 7
	WC_HASH_TYPE_SHA512 = 8
	WC_HASH_TYPE_MD5_SHA = 9
	WC_HASH_TYPE_SHA3_224 = 10
	WC_HASH_TYPE_SHA3_256 = 11
	WC_HASH_TYPE_SHA3_384 = 12
	WC_HASH_TYPE_SHA3_512 = 13
	WC_HASH_TYPE_BLAKE2B = 14
	WC_HASH_TYPE_BLAKE2S = 15
	WC_HASH_TYPE_SHA512_224 = 16
	WC_HASH_TYPE_SHA512_256 = 17
	WC_HASH_TYPE_SHAKE128 = 18
	WC_HASH_TYPE_SHAKE256 = 19
	WC_HASH_TYPE_MAX = WC_HASH_TYPE_SHAKE256
end enum

'const _WC_HASH_TYPE_MAX = WC_HASH_TYPE_BLAKE2S
'#undef _WC_HASH_TYPE_MAX
'const _WC_HASH_TYPE_MAX = WC_HASH_TYPE_SHA512_224
'#undef _WC_HASH_TYPE_MAX
'const _WC_HASH_TYPE_MAX = WC_HASH_TYPE_SHA512_256
'#undef _WC_HASH_TYPE_MAX
'const _WC_HASH_TYPE_MAX = WC_HASH_TYPE_SHAKE256
'#undef _WC_HASH_TYPE_MAX

type wc_CipherType as long
enum
	WC_CIPHER_NONE = 0
	WC_CIPHER_AES = 1
	WC_CIPHER_AES_CBC = 2
	WC_CIPHER_AES_GCM = 3
	WC_CIPHER_AES_CTR = 4
	WC_CIPHER_AES_XTS = 5
	WC_CIPHER_AES_CFB = 6
	WC_CIPHER_AES_CCM = 12
	WC_CIPHER_AES_ECB = 13
	WC_CIPHER_DES3 = 7
	WC_CIPHER_DES = 8
	WC_CIPHER_CHACHA = 9
	WC_CIPHER_MAX = WC_CIPHER_AES_CCM
end enum

type wc_PkType as long
enum
	WC_PK_TYPE_NONE = 0
	WC_PK_TYPE_RSA = 1
	WC_PK_TYPE_DH = 2
	WC_PK_TYPE_ECDH = 3
	WC_PK_TYPE_ECDSA_SIGN = 4
	WC_PK_TYPE_ECDSA_VERIFY = 5
	WC_PK_TYPE_ED25519_SIGN = 6
	WC_PK_TYPE_CURVE25519 = 7
	WC_PK_TYPE_RSA_KEYGEN = 8
	WC_PK_TYPE_EC_KEYGEN = 9
	WC_PK_TYPE_RSA_CHECK_PRIV_KEY = 10
	WC_PK_TYPE_EC_CHECK_PRIV_KEY = 11
	WC_PK_TYPE_ED448 = 12
	WC_PK_TYPE_CURVE448 = 13
	WC_PK_TYPE_ED25519_VERIFY = 14
	WC_PK_TYPE_ED25519_KEYGEN = 15
	WC_PK_TYPE_CURVE25519_KEYGEN = 16
	WC_PK_TYPE_MAX = WC_PK_TYPE_CURVE25519_KEYGEN
end enum

enum
	CTC_SETTINGS = &h0
end enum

declare function CheckRunTimeSettings() as word32
#define CheckCtcSettings() (CTC_SETTINGS = CheckRunTimeSettings())
const INVALID_DEVID = -2
#define ALIGN16
#define ALIGN32
#define ALIGN64
#define ALIGN128
#define ALIGN256
#define PEDANTIC_EXTENSION __extension__
#ifndef TRUE
  const TRUE = 1
  const FALSE = 0
#endif
#define EXIT_TEST(ret) return ret
#define PRAGMA_GCC_DIAG_PUSH
#define PRAGMA_GCC(str)
#define PRAGMA_GCC_DIAG_POP
#macro SAVE_VECTOR_REGISTERS(__VA_ARGS__...)
	scope
	end scope
#endmacro
#macro ASSERT_SAVED_VECTOR_REGISTERS(__VA_ARGS__...)
	scope
	end scope
#endmacro
#macro ASSERT_RESTORED_VECTOR_REGISTERS(__VA_ARGS__...)
	scope
	end scope
#endmacro
#macro RESTORE_VECTOR_REGISTERS()
	scope
	end scope
#endmacro
#macro PRIVATE_KEY_LOCK()
	scope
	end scope
#endmacro
#macro PRIVATE_KEY_UNLOCK()
	scope
	end scope
#endmacro
#define WOLF_CRYPT_DSA_H
#define WOLF_CRYPT_INTEGER_H
#define WOLF_CRYPT_SP_INT_H
const __WORDSIZE = 32
const CHAR_BIT = 8
const SCHAR_MIN = -128
const CHAR_MIN = SCHAR_MIN
const SCHAR_MAX = 127
const CHAR_MAX = SCHAR_MAX
const UCHAR_MAX = 255
const SHRT_MIN = -32768
const SHRT_MAX = 32767
const USHRT_MAX = 65535
#define INT_MIN ((-INT_MAX) - 1)
#define INT_MAX __INT_MAX__
#define UINT_MAX __UINT32_MAX__
#define LONG_MIN ((-LONG_MAX) - 1)
#define LONG_MAX __LONG_MAX__
#define ULONG_MAX __UINT32_MAX__
#define LLONG_MIN ((-LLONG_MAX) - 1)
#define LLONG_MAX __INT64_MAX__
#define ULLONG_MAX __UINT64_MAX__
#define WOLF_CRYPT_HASH_H
#define WOLF_CRYPT_MD5_H
type Md5 as wc_Md5

enum
	WC_MD5 = WC_HASH_TYPE_MD5
	WC_MD5_BLOCK_SIZE = 64
	WC_MD5_DIGEST_SIZE = 16
	WC_MD5_PAD_SIZE = 56
end enum

const MD5_DIGEST_SIZE = WC_MD5_DIGEST_SIZE
const MD5_BLOCK_SIZE = WC_MD5_BLOCK_SIZE
const MD5 = WC_MD5

type wc_Md5
	buffLen as word32
	loLen as word32
	hiLen as word32
	buffer(0 to (WC_MD5_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	digest(0 to (WC_MD5_DIGEST_SIZE / sizeof(word32)) - 1) as word32
	heap as any ptr
end type

declare function wc_InitMd5(byval md5 as wc_Md5 ptr) as long
declare function wc_InitMd5_ex(byval md5 as wc_Md5 ptr, byval heap as any ptr, byval devId as long) as long
declare function wc_Md5Update(byval md5 as wc_Md5 ptr, byval data as const _byte ptr, byval len as word32) as long
declare function wc_Md5Final(byval md5 as wc_Md5 ptr, byval hash as _byte ptr) as long
declare sub wc_Md5Free(byval md5 as wc_Md5 ptr)
declare function wc_Md5GetHash(byval md5 as wc_Md5 ptr, byval hash as _byte ptr) as long
declare function wc_Md5Copy(byval src as wc_Md5 ptr, byval dst as wc_Md5 ptr) as long
#define WOLF_CRYPT_SHA_H
type Sha as wc_Sha

enum
	WC_SHA = WC_HASH_TYPE_SHA
	WC_SHA_BLOCK_SIZE = 64
	WC_SHA_DIGEST_SIZE = 20
	WC_SHA_PAD_SIZE = 56
end enum

const SHA_PAD_SIZE = WC_SHA_PAD_SIZE
const SHA_DIGEST_SIZE = WC_SHA_DIGEST_SIZE
const SHA_BLOCK_SIZE = WC_SHA_BLOCK_SIZE
const SHA = WC_SHA

type wc_Sha
	buffLen as word32
	loLen as word32
	hiLen as word32
	buffer(0 to (WC_SHA_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	digest(0 to (WC_SHA_DIGEST_SIZE / sizeof(word32)) - 1) as word32
	heap as any ptr
end type

#define WC_SHA_TYPE_DEFINED
declare function wc_InitSha(byval sha as wc_Sha ptr) as long
declare function wc_InitSha_ex(byval sha as wc_Sha ptr, byval heap as any ptr, byval devId as long) as long
declare function wc_ShaUpdate(byval sha as wc_Sha ptr, byval data as const _byte ptr, byval len as word32) as long
declare function wc_ShaFinalRaw(byval sha as wc_Sha ptr, byval hash as _byte ptr) as long
declare function wc_ShaFinal(byval sha as wc_Sha ptr, byval hash as _byte ptr) as long
declare sub wc_ShaFree(byval sha as wc_Sha ptr)
declare function wc_ShaGetHash(byval sha as wc_Sha ptr, byval hash as _byte ptr) as long
declare function wc_ShaCopy(byval src as wc_Sha ptr, byval dst as wc_Sha ptr) as long
#define WOLF_CRYPT_SHA256_H
type Sha256 as wc_Sha256

enum
	WC_SHA256 = WC_HASH_TYPE_SHA256
	WC_SHA256_BLOCK_SIZE = 64
	WC_SHA256_DIGEST_SIZE = 32
	WC_SHA256_PAD_SIZE = 56
end enum

const SHA256_PAD_SIZE = WC_SHA256_PAD_SIZE
const SHA256_DIGEST_SIZE = WC_SHA256_DIGEST_SIZE
const SHA256_BLOCK_SIZE = WC_SHA256_BLOCK_SIZE
const SHA256 = WC_SHA256

type wc_Sha256
	digest(0 to (WC_SHA256_DIGEST_SIZE / sizeof(word32)) - 1) as word32
	buffer(0 to (WC_SHA256_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	buffLen as word32
	loLen as word32
	hiLen as word32
	heap as any ptr
end type

#define WC_SHA256_TYPE_DEFINED
declare function wc_InitSha256(byval sha as wc_Sha256 ptr) as long
declare function wc_InitSha256_ex(byval sha as wc_Sha256 ptr, byval heap as any ptr, byval devId as long) as long
declare function wc_Sha256Update(byval sha as wc_Sha256 ptr, byval data as const _byte ptr, byval len as word32) as long
declare function wc_Sha256FinalRaw(byval sha256 as wc_Sha256 ptr, byval hash as _byte ptr) as long
declare function wc_Sha256Final(byval sha256 as wc_Sha256 ptr, byval hash as _byte ptr) as long
declare sub wc_Sha256Free(byval sha256 as wc_Sha256 ptr)
declare function wc_Sha256GetHash(byval sha256 as wc_Sha256 ptr, byval hash as _byte ptr) as long
declare function wc_Sha256Copy(byval src as wc_Sha256 ptr, byval dst as wc_Sha256 ptr) as long
#define WOLF_CRYPT_MD4_H

enum
	MD4 = WC_HASH_TYPE_MD4
	MD4_BLOCK_SIZE = 64
	MD4_DIGEST_SIZE = 16
	MD4_PAD_SIZE = 56
end enum

type Md4
	buffLen as word32
	loLen as word32
	hiLen as word32
	digest(0 to (MD4_DIGEST_SIZE / sizeof(word32)) - 1) as word32
	buffer(0 to (MD4_BLOCK_SIZE / sizeof(word32)) - 1) as word32
end type

declare sub wc_InitMd4(byval md4 as Md4 ptr)
declare sub wc_Md4Update(byval md4 as Md4 ptr, byval data as const _byte ptr, byval len as word32)
declare sub wc_Md4Final(byval md4 as Md4 ptr, byval hash as _byte ptr)

type wc_MACAlgorithm as long
enum
	no_mac
	md5_mac
	sha_mac
	sha224_mac
	sha256_mac
	sha384_mac
	sha512_mac
	rmd_mac
	blake2b_mac
end enum

type wc_HashFlags as long
enum
	WC_HASH_FLAG_NONE = &h00000000
	WC_HASH_FLAG_WILLCOPY = &h00000001
	WC_HASH_FLAG_ISCOPY = &h00000002
end enum

union wc_HashAlg
	md5 as wc_Md5
	sha as wc_Sha
	sha256 as wc_Sha256
end union

const WC_MAX_DIGEST_SIZE = WC_SHA256_DIGEST_SIZE
const MAX_DIGEST_SIZE = WC_MAX_DIGEST_SIZE
const WC_MAX_BLOCK_SIZE = WC_SHA256_BLOCK_SIZE

declare function wc_HashGetOID(byval hash_type as wc_HashType) as long
declare function wc_OidGetHash(byval oid as long) as wc_HashType
declare function wc_HashTypeConvert(byval hashType as long) as wc_HashType
declare function wc_HashGetDigestSize(byval hash_type as wc_HashType) as long
declare function wc_HashGetBlockSize(byval hash_type as wc_HashType) as long
declare function wc_Hash(byval hash_type as wc_HashType, byval data as const _byte ptr, byval data_len as word32, byval hash as _byte ptr, byval hash_len as word32) as long
declare function wc_HashInit_ex(byval hash as wc_HashAlg ptr, byval type as wc_HashType, byval heap as any ptr, byval devId as long) as long
declare function wc_HashInit(byval hash as wc_HashAlg ptr, byval type as wc_HashType) as long
declare function wc_HashUpdate(byval hash as wc_HashAlg ptr, byval type as wc_HashType, byval data as const _byte ptr, byval dataSz as word32) as long
declare function wc_HashFinal(byval hash as wc_HashAlg ptr, byval type as wc_HashType, byval out as _byte ptr) as long
declare function wc_HashFree(byval hash as wc_HashAlg ptr, byval type as wc_HashType) as long
declare function wc_Md5Hash(byval data as const _byte ptr, byval len as word32, byval hash as _byte ptr) as long
declare function wc_ShaHash(byval data as const _byte ptr, byval len as word32, byval hash as _byte ptr) as long
declare function wc_Sha256Hash(byval data as const _byte ptr, byval len as word32, byval hash as _byte ptr) as long
const SP_UCHAR_BITS = 8
type sp_uint8 as ubyte
type sp_int8 as zstring
const SP_USHORT_BITS = 16
type sp_uint16 as ushort
type sp_int16 as short
const SP_UINT_BITS = 32
type sp_uint32 as ulong
type sp_int32 as long
const SP_ULONG_BITS = 32
const SP_ULLONG_BITS = 64
type sp_uint64 as ulongint
type sp_int64 as longint
const SP_WORD_SIZE = 32
const SP_WORD_SIZEOF = SP_WORD_SIZE / 8

type sp_int_digit as sp_uint32
type sp_sint_digit as sp_int32
type sp_int_word as sp_uint64
type sp_int_sword as sp_int64
const SP_MASK = &hffffffffu
type sp_digit as sp_int32

const SP_HALF_SIZE = SP_WORD_SIZE / 2
const SP_HALF_MAX = (cast(sp_digit, 1) shl SP_HALF_SIZE) - 1
const SP_DIGIT_MAX = SP_MASK
const SP_WORD_SHIFT = 5
const SP_WORD_MASK = SP_WORD_SIZE - 1
#define SP_PRINT_FMT "%08x"
#define WOLF_CRYPT_RANDOM_H
const RNG_MAX_BLOCK_LEN = cast(clong, &h10000)
const DRBG_SEED_LEN = 440 / 8
type CUSTOM_RAND_TYPE as _byte
#undef HAVE_HASHDRBG
#define HAVE_HASHDRBG
const WC_RESEED_INTERVAL = 1000000
#define WC_RNG_TYPE_DEFINED

type OS_Seed
	fd as long
end type

type DRBG_internal
	reseedCtr as word32
	lastBlock as word32
	V(0 to (440 / 8) - 1) as _byte
	C(0 to (440 / 8) - 1) as _byte
	matchCount as _byte
end type

#ifndef DRBG
type DRBG as DRBG ptr
#endif
type WC_RNG
	seed as OS_Seed
	heap as any ptr
	drbg as DRBG ptr
	status as _byte
end type

type RNG as WC_RNG
declare function wc_GenerateSeed(byval os as OS_Seed ptr, byval seed as _byte ptr, byval sz as word32) as long
declare function wc_rng_new(byval nonce as _byte ptr, byval nonceSz as word32, byval heap as any ptr) as WC_RNG ptr
declare sub wc_rng_free(byval rng as WC_RNG ptr)
declare function wc_InitRng(byval rng as WC_RNG ptr) as long
declare function wc_InitRng_ex(byval rng as WC_RNG ptr, byval heap as any ptr, byval devId as long) as long
declare function wc_InitRngNonce(byval rng as WC_RNG ptr, byval nonce as _byte ptr, byval nonceSz as word32) as long
declare function wc_InitRngNonce_ex(byval rng as WC_RNG ptr, byval nonce as _byte ptr, byval nonceSz as word32, byval heap as any ptr, byval devId as long) as long
declare function wc_RNG_GenerateBlock(byval rng as WC_RNG ptr, byval b as _byte ptr, byval sz as word32) as long
declare function wc_RNG_GenerateByte(byval rng as WC_RNG ptr, byval b as _byte ptr) as long
declare function wc_FreeRng(byval rng as WC_RNG ptr) as long
declare function wc_RNG_DRBG_Reseed(byval rng as WC_RNG ptr, byval entropy as const _byte ptr, byval entropySz as word32) as long
declare function wc_RNG_TestSeed(byval seed as const _byte ptr, byval seedSz as word32) as long
declare function wc_RNG_HealthTest(byval reseed as long, byval entropyA as const _byte ptr, byval entropyASz as word32, byval entropyB as const _byte ptr, byval entropyBSz as word32, byval output as _byte ptr, byval outputSz as word32) as long
declare function wc_RNG_HealthTest_ex(byval reseed as long, byval nonce as const _byte ptr, byval nonceSz as word32, byval entropyA as const _byte ptr, byval entropyASz as word32, byval entropyB as const _byte ptr, byval entropyBSz as word32, byval output as _byte ptr, byval outputSz as word32, byval heap as any ptr, byval devId as long) as long

const SP_INT_BITS = 3072
const SP_INT_DIGITS = ((((SP_INT_BITS * 2) + SP_WORD_SIZE) - 1) / SP_WORD_SIZE) + 1
const SP_INT_MAX_BITS = SP_INT_DIGITS * SP_WORD_SIZE
#macro sp_print(a, s)
	scope
		dim ii as long
		fprintf(stderr, "%s=0x0", s)
    '' TODO?: for (ii = (a)->used-1; ii >= 0; ii--) { fprintf(stderr, SP_PRINT_FMT, (a)->dp[ii]); }
    for ii=(a)->used-1 to 0 step -1
      fprintf(stderr, SP_PRINT_FMT, (a)->dp[ii])
    next		
		fprintf(stderr, !"\n")
	end scope
#endmacro
#macro sp_print_digit(a, s)
	scope
		fprintf(stderr, "%s=0x0", s)
		fprintf(stderr, SP_PRINT_FMT, a)
		fprintf(stderr, !"\n")
	end scope
#endmacro
#define sp_print_int(a, s) scope : fprintf(stderr, !"%s=0x0%x\n", s, a) : end scope
#define sp_isodd(a) (((a)->used <> 0) andalso ((a)->dp[0] and 1))
#define sp_iseven(a) (((a)->used <> 0) andalso (((a)->dp[0] and 1) = 0))
#define sp_iszero(a) ((a)->used = 0)
#define sp_isone(a) (((a)->used = 1) andalso ((a)->dp[0] = 1))
#define sp_isword(a, d) ((((d) = 0) andalso sp_iszero(a)) orelse (((a)->used = 1) andalso ((a)->dp[0] = (d))))
#define sp_abs(a, b) sp_copy(a, b)
#define sp_isneg(a) 0
#macro sp_clamp(a)
	scope
		dim ii as long
		'' TODO: for (ii = (a)->used - 1; ii >= 0 && (a)->dp[ii] == 0; ii--) { }
    ii = (a)->used-1
    while ii >=0 andalso (a)->dp[ii]=0
      ii -= 1
    wend 
		(a)->used = ii + 1
	end scope
#endmacro
#define CheckFastMathSettings() (SP_WORD_SIZE = CheckRunTimeFastMath())
#define MP_INT_SIZEOF(cnt) (sizeof(sp_int) - ((SP_INT_DIGITS - iif((cnt) = 0, 1, (cnt))) * sizeof(sp_int_digit)))
#define MP_INT_NEXT(t, cnt) cptr(sp_int ptr, cptr(_byte ptr, (t)) + MP_INT_SIZEOF(cnt))
const MP_NO = 0
const MP_YES = 1
const MP_RADIX_DEC = 10
const MP_RADIX_HEX = 16
const MP_GT = 1
const MP_EQ = 0
const MP_LT = -1
const MP_OKAY = 0
const MP_MEM = -2
const MP_VAL = -3
const FP_WOULDBLOCK = -4
const MP_NOT_INF = -5
const MP_RANGE = MP_NOT_INF
const DIGIT_BIT = SP_WORD_SIZE
const MP_MASK = SP_MASK

type sp_int
	used as long
	size as long
	dp(0 to (((((3072 * 2) + 32) - 1) / 32) + 1) - 1) as sp_int_digit
end type

type mp_int as sp_int
type mp_digit as sp_int_digit
#define __WOLFMATH_H__
#define MP_API WOLFSSL_LOCAL
#define MIN_(x, y) iif((x) < (y), (x), (y))
#define MAX_(x, y) iif((x) > (y), (x), (y))

declare function get_digit_count(byval a as const mp_int ptr) as long
declare function get_digit(byval a as const mp_int ptr, byval n as long) as mp_digit
declare function get_rand_digit(byval rng as WC_RNG ptr, byval d as mp_digit ptr) as long
declare function mp_cond_copy(byval a as mp_int ptr, byval copy as long, byval b as mp_int ptr) as long
declare function mp_rand(byval a as mp_int ptr, byval digits as long, byval rng as WC_RNG ptr) as long
const WC_TYPE_HEX_STR = 1
const WC_TYPE_UNSIGNED_BIN = 2
declare function wc_export_int(byval mp as mp_int ptr, byval buf as _byte ptr, byval len as word32 ptr, byval keySz as word32, byval encType as long) as long
declare function sp_init(byval a as sp_int ptr) as long
declare function sp_init_size(byval a as sp_int ptr, byval size as long) as long
declare function sp_init_multi(byval n1 as sp_int ptr, byval n2 as sp_int ptr, byval n3 as sp_int ptr, byval n4 as sp_int ptr, byval n5 as sp_int ptr, byval n6 as sp_int ptr) as long
declare sub sp_free(byval a as sp_int ptr)
declare function sp_grow(byval a as sp_int ptr, byval l as long) as long
declare sub sp_zero(byval a as sp_int ptr)
declare sub sp_clear(byval a as sp_int ptr)
declare sub sp_forcezero(byval a as sp_int ptr)
declare function sp_init_copy(byval r as sp_int ptr, byval a as sp_int ptr) as long
declare function sp_copy(byval a as const sp_int ptr, byval r as sp_int ptr) as long
declare function sp_exch(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function sp_cond_swap_ct(byval a as mp_int ptr, byval b as mp_int ptr, byval c as long, byval m as long) as long
declare function sp_cmp_mag(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function sp_cmp(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function sp_is_bit_set(byval a as sp_int ptr, byval b as ulong) as long
declare function sp_count_bits(byval a as const sp_int ptr) as long
declare function sp_leading_bit(byval a as sp_int ptr) as long
declare function sp_set_bit(byval a as sp_int ptr, byval i as long) as long
declare function sp_2expt(byval a as sp_int ptr, byval e as long) as long
declare function sp_set(byval a as sp_int ptr, byval d as sp_int_digit) as long
declare function sp_set_int(byval a as sp_int ptr, byval n as culong) as long
declare function sp_cmp_d(byval a as sp_int ptr, byval d as sp_int_digit) as long
declare function sp_add_d(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function sp_sub_d(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function sp_mul_d(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function sp_div_d(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr, byval rem as sp_int_digit ptr) as long
declare function sp_mod_d(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int_digit ptr) as long
declare function sp_add(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_sub(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_addmod(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_submod(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_lshd(byval a as sp_int ptr, byval s as long) as long
declare sub sp_rshd(byval a as sp_int ptr, byval c as long)
declare sub sp_rshb(byval a as sp_int ptr, byval n as long, byval r as sp_int ptr)
declare function sp_div(byval a as sp_int ptr, byval d as sp_int ptr, byval r as sp_int ptr, byval rem as sp_int ptr) as long
declare function sp_mod(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_mul(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_mulmod(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_invmod(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_exptmod_ex(byval b as sp_int ptr, byval e as sp_int ptr, byval digits as long, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_exptmod(byval b as sp_int ptr, byval e as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_exptmod_nct(byval b as sp_int ptr, byval e as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_div_2d(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr, byval rem as sp_int ptr) as long
declare function sp_mod_2d(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr) as long
declare function sp_mul_2d(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr) as long
declare function sp_sqr(byval a as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_sqrmod(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function sp_mont_red(byval a as sp_int ptr, byval m as sp_int ptr, byval mp as sp_int_digit) as long
declare function sp_mont_setup(byval m as sp_int ptr, byval rho as sp_int_digit ptr) as long
declare function sp_mont_norm(byval norm as sp_int ptr, byval m as sp_int ptr) as long
declare function sp_unsigned_bin_size(byval a as const sp_int ptr) as long
declare function sp_read_unsigned_bin(byval a as sp_int ptr, byval in as const _byte ptr, byval inSz as word32) as long
declare function sp_to_unsigned_bin(byval a as sp_int ptr, byval out as _byte ptr) as long
declare function sp_to_unsigned_bin_len(byval a as sp_int ptr, byval out as _byte ptr, byval outSz as long) as long
declare function sp_to_unsigned_bin_at_pos(byval o as long, byval a as sp_int ptr, byval out as ubyte ptr) as long
declare function sp_read_radix(byval a as sp_int ptr, byval in as const zstring ptr, byval radix as long) as long
declare function sp_tohex(byval a as sp_int ptr, byval str as zstring ptr) as long
declare function sp_todecimal(byval a as mp_int ptr, byval str as zstring ptr) as long
declare function sp_toradix(byval a as mp_int ptr, byval str as zstring ptr, byval radix as long) as long
declare function sp_radix_size(byval a as mp_int ptr, byval radix as long, byval size as long ptr) as long
declare function sp_rand_prime(byval r as sp_int ptr, byval len as long, byval rng as WC_RNG ptr, byval heap as any ptr) as long
declare function sp_prime_is_prime(byval a as mp_int ptr, byval t as long, byval result as long ptr) as long
declare function sp_prime_is_prime_ex(byval a as mp_int ptr, byval t as long, byval result as long ptr, byval rng as WC_RNG ptr) as long
declare function CheckRunTimeFastMath() as word32

#define mp_mul_2(a, r) sp_mul_2d(a, 1, r)
#define mp_div_3(a, r, rem) sp_div_d(a, 3, r, rem)
#define mp_rshb(A, x) sp_rshb(A, x, A)
#define mp_is_bit_set(a, b) sp_is_bit_set(a, culng(b))

declare function mp_montgomery_reduce alias "sp_mont_red"(byval a as sp_int ptr, byval m as sp_int ptr, byval mp as sp_int_digit) as long
declare function mp_montgomery_setup alias "sp_mont_setup"(byval m as sp_int ptr, byval rho as sp_int_digit ptr) as long
declare function mp_montgomery_calc_normalization alias "sp_mont_norm"(byval norm as sp_int ptr, byval m as sp_int ptr) as long

#define mp_isodd sp_isodd
#define mp_iseven sp_iseven
#define mp_iszero sp_iszero
#define mp_isone sp_isone
#define mp_isword sp_isword
#define mp_abs sp_abs
#define mp_isneg sp_isneg
#define mp_clamp sp_clamp

declare function mp_init alias "sp_init"(byval a as sp_int ptr) as long
declare function mp_init_size alias "sp_init_size"(byval a as sp_int ptr, byval size as long) as long
declare function mp_init_multi alias "sp_init_multi"(byval n1 as sp_int ptr, byval n2 as sp_int ptr, byval n3 as sp_int ptr, byval n4 as sp_int ptr, byval n5 as sp_int ptr, byval n6 as sp_int ptr) as long
declare sub mp_free alias "sp_free"(byval a as sp_int ptr)
declare function mp_grow alias "sp_grow"(byval a as sp_int ptr, byval l as long) as long
declare sub mp_zero alias "sp_zero"(byval a as sp_int ptr)
declare sub mp_clear alias "sp_clear"(byval a as sp_int ptr)
declare sub mp_forcezero alias "sp_forcezero"(byval a as sp_int ptr)
declare function mp_copy alias "sp_copy"(byval a as const sp_int ptr, byval r as sp_int ptr) as long
declare function mp_init_copy alias "sp_init_copy"(byval r as sp_int ptr, byval a as sp_int ptr) as long
declare function mp_exch alias "sp_exch"(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function mp_cond_swap_ct alias "sp_cond_swap_ct"(byval a as mp_int ptr, byval b as mp_int ptr, byval c as long, byval m as long) as long
declare function mp_cmp_mag alias "sp_cmp_mag"(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function mp_cmp alias "sp_cmp"(byval a as sp_int ptr, byval b as sp_int ptr) as long
declare function mp_count_bits alias "sp_count_bits"(byval a as const sp_int ptr) as long
#define mp_cnt_lsb sp_cnt_lsb
declare function mp_leading_bit alias "sp_leading_bit"(byval a as sp_int ptr) as long
declare function mp_set_bit alias "sp_set_bit"(byval a as sp_int ptr, byval i as long) as long
declare function mp_2expt alias "sp_2expt"(byval a as sp_int ptr, byval e as long) as long
declare function mp_set alias "sp_set"(byval a as sp_int ptr, byval d as sp_int_digit) as long
declare function mp_set_int alias "sp_set_int"(byval a as sp_int ptr, byval n as culong) as long
declare function mp_cmp_d alias "sp_cmp_d"(byval a as sp_int ptr, byval d as sp_int_digit) as long
declare function mp_add_d alias "sp_add_d"(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function mp_sub_d alias "sp_sub_d"(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function mp_mul_d alias "sp_mul_d"(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr) as long
declare function mp_div_d alias "sp_div_d"(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int ptr, byval rem as sp_int_digit ptr) as long
declare function mp_mod_d alias "sp_mod_d"(byval a as sp_int ptr, byval d as sp_int_digit, byval r as sp_int_digit ptr) as long
#define mp_div_2_mod_ct sp_div_2_mod_ct
#define mp_div_2 sp_div_2
declare function mp_add alias "sp_add"(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_sub alias "sp_sub"(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_addmod alias "sp_addmod"(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_submod alias "sp_submod"(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
#define mp_addmod_ct sp_addmod_ct
#define mp_submod_ct sp_submod_ct
declare function mp_lshd alias "sp_lshd"(byval a as sp_int ptr, byval s as long) as long
declare sub mp_rshd alias "sp_rshd"(byval a as sp_int ptr, byval c as long)
declare function mp_div alias "sp_div"(byval a as sp_int ptr, byval d as sp_int ptr, byval r as sp_int ptr, byval rem as sp_int ptr) as long
declare function mp_mod alias "sp_mod"(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_mul alias "sp_mul"(byval a as sp_int ptr, byval b as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_mulmod alias "sp_mulmod"(byval a as sp_int ptr, byval b as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_invmod alias "sp_invmod"(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
#define mp_invmod_mont_ct sp_invmod_mont_ct
declare function mp_exptmod_ex alias "sp_exptmod_ex"(byval b as sp_int ptr, byval e as sp_int ptr, byval digits as long, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_exptmod alias "sp_exptmod"(byval b as sp_int ptr, byval e as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_exptmod_nct alias "sp_exptmod_nct"(byval b as sp_int ptr, byval e as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_div_2d alias "sp_div_2d"(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr, byval rem as sp_int ptr) as long
declare function mp_mod_2d alias "sp_mod_2d"(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr) as long
declare function mp_mul_2d alias "sp_mul_2d"(byval a as sp_int ptr, byval e as long, byval r as sp_int ptr) as long
declare function mp_sqr alias "sp_sqr"(byval a as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_sqrmod alias "sp_sqrmod"(byval a as sp_int ptr, byval m as sp_int ptr, byval r as sp_int ptr) as long
declare function mp_unsigned_bin_size alias "sp_unsigned_bin_size"(byval a as const sp_int ptr) as long
declare function mp_read_unsigned_bin alias "sp_read_unsigned_bin"(byval a as sp_int ptr, byval in as const _byte ptr, byval inSz as word32) as long
declare function mp_to_unsigned_bin alias "sp_to_unsigned_bin"(byval a as sp_int ptr, byval out as _byte ptr) as long
declare function mp_to_unsigned_bin_len alias "sp_to_unsigned_bin_len"(byval a as sp_int ptr, byval out as _byte ptr, byval outSz as long) as long
declare function mp_to_unsigned_bin_at_pos alias "sp_to_unsigned_bin_at_pos"(byval o as long, byval a as sp_int ptr, byval out as ubyte ptr) as long
declare function mp_read_radix alias "sp_read_radix"(byval a as sp_int ptr, byval in as const zstring ptr, byval radix as long) as long
declare function mp_tohex alias "sp_tohex"(byval a as sp_int ptr, byval str as zstring ptr) as long
declare function mp_todecimal alias "sp_todecimal"(byval a as mp_int ptr, byval str as zstring ptr) as long
declare function mp_toradix alias "sp_toradix"(byval a as mp_int ptr, byval str as zstring ptr, byval radix as long) as long
declare function mp_radix_size alias "sp_radix_size"(byval a as mp_int ptr, byval radix as long, byval size as long ptr) as long
declare function mp_rand_prime alias "sp_rand_prime"(byval r as sp_int ptr, byval len as long, byval rng as WC_RNG ptr, byval heap as any ptr) as long
declare function mp_prime_is_prime alias "sp_prime_is_prime"(byval a as mp_int ptr, byval t as long, byval result as long ptr) as long
declare function mp_prime_is_prime_ex alias "sp_prime_is_prime_ex"(byval a as mp_int ptr, byval t as long, byval result as long ptr, byval rng as WC_RNG ptr) as long

#define mp_gcd sp_gcd
#define mp_lcm sp_lcm
#define mp_memzero_add sp_memzero_add
#define mp_memzero_check sp_memzero_check

enum
	DSA_PUBLIC = 0
	DSA_PRIVATE = 1
end enum

enum
	DSA_160_HALF_SIZE = 20
	DSA_160_SIG_SIZE = 40
	DSA_HALF_SIZE = DSA_160_HALF_SIZE
	DSA_SIG_SIZE = DSA_160_SIG_SIZE
	DSA_256_HALF_SIZE = 32
	DSA_256_SIG_SIZE = 64
	DSA_MIN_HALF_SIZE = DSA_160_HALF_SIZE
	DSA_MIN_SIG_SIZE = DSA_160_SIG_SIZE
	DSA_MAX_HALF_SIZE = DSA_256_HALF_SIZE
	DSA_MAX_SIG_SIZE = DSA_256_SIG_SIZE
end enum

type DsaKey
	p as mp_int
	q as mp_int
	g as mp_int
	y as mp_int
	x as mp_int
	as long type
	heap as any ptr
end type

declare function wc_InitDsaKey(byval key as DsaKey ptr) as long
declare function InitDsaKey alias "wc_InitDsaKey"(byval key as DsaKey ptr) as long
declare function wc_InitDsaKey_h(byval key as DsaKey ptr, byval h as any ptr) as long
declare sub wc_FreeDsaKey(byval key as DsaKey ptr)
declare sub FreeDsaKey alias "wc_FreeDsaKey"(byval key as DsaKey ptr)
declare function wc_DsaSign(byval digest as const _byte ptr, byval out as _byte ptr, byval key as DsaKey ptr, byval rng as WC_RNG ptr) as long
declare function DsaSign alias "wc_DsaSign"(byval digest as const _byte ptr, byval out as _byte ptr, byval key as DsaKey ptr, byval rng as WC_RNG ptr) as long
declare function wc_DsaVerify(byval digest as const _byte ptr, byval sig as const _byte ptr, byval key as DsaKey ptr, byval answer as long ptr) as long
declare function DsaVerify alias "wc_DsaVerify"(byval digest as const _byte ptr, byval sig as const _byte ptr, byval key as DsaKey ptr, byval answer as long ptr) as long
declare function wc_DsaPublicKeyDecode(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval key as DsaKey ptr, byval inSz as word32) as long
declare function DsaPublicKeyDecode alias "wc_DsaPublicKeyDecode"(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval key as DsaKey ptr, byval inSz as word32) as long
declare function wc_DsaPrivateKeyDecode(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval key as DsaKey ptr, byval inSz as word32) as long
declare function DsaPrivateKeyDecode alias "wc_DsaPrivateKeyDecode"(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval key as DsaKey ptr, byval inSz as word32) as long
declare function wc_DsaKeyToDer(byval key as DsaKey ptr, byval output as _byte ptr, byval inLen as word32) as long
declare function DsaKeyToDer alias "wc_DsaKeyToDer"(byval key as DsaKey ptr, byval output as _byte ptr, byval inLen as word32) as long
declare function wc_SetDsaPublicKey(byval output as _byte ptr, byval key as DsaKey ptr, byval outLen as long, byval with_header as long) as long
declare function wc_DsaKeyToPublicDer(byval key as DsaKey ptr, byval output as _byte ptr, byval inLen as word32) as long
declare function wc_DsaImportParamsRaw(byval dsa as DsaKey ptr, byval p as const zstring ptr, byval q as const zstring ptr, byval g as const zstring ptr) as long
declare function wc_DsaImportParamsRawCheck(byval dsa as DsaKey ptr, byval p as const zstring ptr, byval q as const zstring ptr, byval g as const zstring ptr, byval trusted as long, byval rng as WC_RNG ptr) as long
declare function wc_DsaExportParamsRaw(byval dsa as DsaKey ptr, byval p as _byte ptr, byval pSz as word32 ptr, byval q as _byte ptr, byval qSz as word32 ptr, byval g as _byte ptr, byval gSz as word32 ptr) as long
declare function wc_DsaExportKeyRaw(byval dsa as DsaKey ptr, byval x as _byte ptr, byval xSz as word32 ptr, byval y as _byte ptr, byval ySz as word32 ptr) as long

#define WC_ECCKEY_TYPE_DEFINED
#define WC_ED25519KEY_TYPE_DEFINED
#define WC_CURVE25519KEY_TYPE_DEFINED
#define WC_ED448KEY_TYPE_DEFINED
#define WC_CURVE448KEY_TYPE_DEFINED
#define WC_RSAKEY_TYPE_DEFINED
#define WC_DH_TYPE_DEFINED
#define WC_FALCONKEY_TYPE_DEFINED
#define WC_DILITHIUMKEY_TYPE_DEFINED

type Ecc_Sum as long
enum
	ECC_SECP112R1_OID = 182
	ECC_SECP112R2_OID = 183
	ECC_SECP128R1_OID = 204
	ECC_SECP128R2_OID = 205
	ECC_SECP160R1_OID = 184
	ECC_SECP160R2_OID = 206
	ECC_SECP160K1_OID = 185
	ECC_BRAINPOOLP160R1_OID = 98
	ECC_SECP192R1_OID = 520
	ECC_PRIME192V2_OID = 521
	ECC_PRIME192V3_OID = 522
	ECC_SECP192K1_OID = 207
	ECC_BRAINPOOLP192R1_OID = 100
	ECC_SECP224R1_OID = 209
	ECC_SECP224K1_OID = 208
	ECC_BRAINPOOLP224R1_OID = 102
	ECC_PRIME239V1_OID = 523
	ECC_PRIME239V2_OID = 524
	ECC_PRIME239V3_OID = 525
	ECC_SECP256R1_OID = 526
	ECC_SECP256K1_OID = 186
	ECC_BRAINPOOLP256R1_OID = 104
	ECC_X25519_OID = 365
	ECC_ED25519_OID = 256
	ECC_BRAINPOOLP320R1_OID = 106
	ECC_X448_OID = 362
	ECC_ED448_OID = 257
	ECC_SECP384R1_OID = 210
	ECC_BRAINPOOLP384R1_OID = 108
	ECC_BRAINPOOLP512R1_OID = 110
	ECC_SECP521R1_OID = 211
end enum

type CertType as long
enum
	CERT_TYPE = 0
	PRIVATEKEY_TYPE
	DH_PARAM_TYPE
	DSA_PARAM_TYPE
	CRL_TYPE
	CA_TYPE
	ECC_PRIVATEKEY_TYPE
	DSA_PRIVATEKEY_TYPE
	CERTREQ_TYPE
	DSA_TYPE
	ECC_TYPE
	RSA_TYPE
	PUBLICKEY_TYPE
	RSA_PUBLICKEY_TYPE
	ECC_PUBLICKEY_TYPE
	TRUSTED_PEER_TYPE
	EDDSA_PRIVATEKEY_TYPE
	ED25519_TYPE
	ED448_TYPE
	PKCS12_TYPE
	PKCS8_PRIVATEKEY_TYPE
	PKCS8_ENC_PRIVATEKEY_TYPE
	DETECT_CERT_TYPE
	DH_PRIVATEKEY_TYPE
	X942_PARAM_TYPE
	FALCON_LEVEL1_TYPE
	FALCON_LEVEL5_TYPE
	DILITHIUM_LEVEL2_TYPE
	DILITHIUM_LEVEL3_TYPE
	DILITHIUM_LEVEL5_TYPE
	DILITHIUM_AES_LEVEL2_TYPE
	DILITHIUM_AES_LEVEL3_TYPE
	DILITHIUM_AES_LEVEL5_TYPE
end enum

type Ctc_SigType as long
enum
	CTC_SHAwDSA = 517
	CTC_SHA256wDSA = 416
	CTC_MD2wRSA = 646
	CTC_MD5wRSA = 648
	CTC_SHAwRSA = 649
	CTC_SHAwECDSA = 520
	CTC_SHA224wRSA = 658
	CTC_SHA224wECDSA = 523
	CTC_SHA256wRSA = 655
	CTC_SHA256wECDSA = 524
	CTC_SHA384wRSA = 656
	CTC_SHA384wECDSA = 525
	CTC_SHA512wRSA = 657
	CTC_SHA512wECDSA = 526
	CTC_SHA3_224wECDSA = 423
	CTC_SHA3_256wECDSA = 424
	CTC_SHA3_384wECDSA = 425
	CTC_SHA3_512wECDSA = 426
	CTC_SHA3_224wRSA = 427
	CTC_SHA3_256wRSA = 428
	CTC_SHA3_384wRSA = 429
	CTC_SHA3_512wRSA = 430
	CTC_RSASSAPSS = 654
	CTC_ED25519 = 256
	CTC_ED448 = 257
	CTC_FALCON_LEVEL1 = 268
	CTC_FALCON_LEVEL5 = 271
	CTC_DILITHIUM_LEVEL2 = 213
	CTC_DILITHIUM_LEVEL3 = 216
	CTC_DILITHIUM_LEVEL5 = 220
	CTC_DILITHIUM_AES_LEVEL2 = 217
	CTC_DILITHIUM_AES_LEVEL3 = 221
	CTC_DILITHIUM_AES_LEVEL5 = 224
end enum

type Ctc_Encoding as long
enum
	CTC_UTF8 = &h0c
	CTC_PRINTABLE = &h13
end enum

const WC_CTC_NAME_SIZE = 64
const WC_CTC_MAX_ALT_SIZE = 16384

type Ctc_Misc as long
enum
	CTC_COUNTRY_SIZE = 2
	CTC_NAME_SIZE = 64
	CTC_DATE_SIZE = 32
	CTC_MAX_ALT_SIZE = 16384
	CTC_SERIAL_SIZE = 20
	CTC_GEN_SERIAL_SZ = 16
	CTC_FILETYPE_ASN1 = 2
	CTC_FILETYPE_PEM = 1
	CTC_FILETYPE_DEFAULT = 2
end enum

type DerBuffer
	buffer as _byte ptr
	heap as any ptr
	length as word32
	as long type
	dynType as long
end type

type WOLFSSL_ASN1_TIME
	data(0 to CTC_DATE_SIZE - 1) as ubyte
	length as long
	as long type
end type

enum
	IV_SZ = 32
	NAME_SZ = 80
	PEM_PASS_READ = 0
	PEM_PASS_WRITE = 1
end enum

type EncryptedInfo
	passwd_cb as function(byval passwd as zstring ptr, byval sz as long, byval rw as long, byval userdata as any ptr) as long
	passwd_userdata as any ptr
	consumed as clong
	cipherType as long
	keySz as word32
	ivSz as word32
	name as zstring * NAME_SZ
	iv(0 to IV_SZ - 1) as _byte
	set : 1 as word16
end type

const WOLFSSL_ASN1_INTEGER_MAX = 20

type WOLFSSL_ASN1_INTEGER
	intData(0 to 19) as ubyte
	negative as ubyte
	data as ubyte ptr
	dataMax as ulong
	isDynamic : 1 as ulong
	length as long
	as long type
end type

#ifndef RsaKey
type RsaKey as RsaKey ptr
#endif

declare function wc_GetDateInfo(byval certDate as const _byte ptr, byval certDateSz as long, byval date as const _byte ptr ptr, byval format as _byte ptr, byval length as long ptr) as long
declare function wc_GetDateAsCalendarTime(byval date as const _byte ptr, byval length as long, byval format as _byte, byval timearg as tm ptr) as long
declare function wc_PemGetHeaderFooter(byval type as long, byval header as const zstring ptr ptr, byval footer as const zstring ptr ptr) as long
declare function wc_AllocDer(byval pDer as DerBuffer ptr ptr, byval length as word32, byval type as long, byval heap as any ptr) as long
declare sub wc_FreeDer(byval pDer as DerBuffer ptr ptr)
declare function wc_PemToDer(byval buff as const ubyte ptr, byval longSz as clong, byval type as long, byval pDer as DerBuffer ptr ptr, byval heap as any ptr, byval info as EncryptedInfo ptr, byval keyFormat as long ptr) as long
declare function wc_KeyPemToDer(byval pem as const ubyte ptr, byval pemSz as long, byval buff as ubyte ptr, byval buffSz as long, byval pass as const zstring ptr) as long
declare function wc_CertPemToDer(byval pem as const ubyte ptr, byval pemSz as long, byval buff as ubyte ptr, byval buffSz as long, byval type as long) as long
declare function wc_RsaPublicKeyDecode_ex(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval inSz as word32, byval n as const _byte ptr ptr, byval nSz as word32 ptr, byval e as const _byte ptr ptr, byval eSz as word32 ptr) as long
declare function wc_RsaKeyToPublicDer(byval key as RsaKey ptr, byval output as _byte ptr, byval inLen as word32) as long
declare function wc_RsaPublicKeyDerSize(byval key as RsaKey ptr, byval with_header as long) as long
declare function wc_RsaKeyToPublicDer_ex(byval key as RsaKey ptr, byval output as _byte ptr, byval inLen as word32, byval with_header as long) as long
declare function wc_DsaParamsDecode(byval input as const _byte ptr, byval inOutIdx as word32 ptr, byval key as DsaKey ptr, byval inSz as word32) as long
declare function wc_DsaKeyToParamsDer(byval key as DsaKey ptr, byval output as _byte ptr, byval inLen as word32) as long
declare function wc_DsaKeyToParamsDer_ex(byval key as DsaKey ptr, byval output as _byte ptr, byval inLen as word32 ptr) as long
declare function wc_EncodeSignature(byval out as _byte ptr, byval digest as const _byte ptr, byval digSz as word32, byval hashOID as long) as word32
declare function wc_GetCTC_HashOID(byval type as long) as long
declare function wc_GetPkcs8TraditionalOffset(byval input as _byte ptr, byval inOutIdx as word32 ptr, byval sz as word32) as long
declare function wc_CreatePKCS8Key(byval out as _byte ptr, byval outSz as word32 ptr, byval key as _byte ptr, byval keySz as word32, byval algoID as long, byval curveOID as const _byte ptr, byval oidSz as word32) as long
declare function wc_EncryptPKCS8Key(byval key as _byte ptr, byval keySz as word32, byval out as _byte ptr, byval outSz as word32 ptr, byval password as const zstring ptr, byval passwordSz as long, byval vPKCS as long, byval pbeOid as long, byval encAlgId as long, byval salt as _byte ptr, byval saltSz as word32, byval itt as long, byval rng as WC_RNG ptr, byval heap as any ptr) as long
declare function wc_DecryptPKCS8Key(byval input as _byte ptr, byval sz as word32, byval password as const zstring ptr, byval passwordSz as long) as long
declare function wc_CreateEncryptedPKCS8Key(byval key as _byte ptr, byval keySz as word32, byval out as _byte ptr, byval outSz as word32 ptr, byval password as const zstring ptr, byval passwordSz as long, byval vPKCS as long, byval pbeOid as long, byval encAlgId as long, byval salt as _byte ptr, byval saltSz as word32, byval itt as long, byval rng as WC_RNG ptr, byval heap as any ptr) as long
declare function wc_GetTime(byval timePtr as any ptr, byval timeSize as word32) as long
type wc_time_cb as function(byval t as time_t ptr) as time_t
declare function wc_SetTimeCb(byval f as wc_time_cb) as long
declare function wc_Time(byval t as time_t ptr) as time_t

#ifndef DecodedCert
type DecodedCert as DecodedCert ptr
#endif

declare sub wc_InitDecodedCert(byval cert as DecodedCert ptr, byval source as const _byte ptr, byval inSz as word32, byval heap as any ptr)
declare sub wc_FreeDecodedCert(byval cert as DecodedCert ptr)
declare function wc_ParseCert(byval cert as DecodedCert ptr, byval type as long, byval verify as long, byval cm as any ptr) as long
declare function wc_GetPubKeyDerFromCert(byval cert as DecodedCert ptr, byval derKey as _byte ptr, byval derKeySz as word32 ptr) as long
#define WOLF_CRYPT_ERROR_H

enum
	MAX_CODE_E = -100
	OPEN_RAN_E = -101
	READ_RAN_E = -102
	WINCRYPT_E = -103
	CRYPTGEN_E = -104
	RAN_BLOCK_E = -105
	BAD_MUTEX_E = -106
	WC_TIMEOUT_E = -107
	WC_PENDING_E = -108
	WC_NOT_PENDING_E = -109
	MP_INIT_E = -110
	MP_READ_E = -111
	MP_EXPTMOD_E = -112
	MP_TO_E = -113
	MP_SUB_E = -114
	MP_ADD_E = -115
	MP_MUL_E = -116
	MP_MULMOD_E = -117
	MP_MOD_E = -118
	MP_INVMOD_E = -119
	MP_CMP_E = -120
	MP_ZERO_E = -121
	MEMORY_E = -125
	VAR_STATE_CHANGE_E = -126
	RSA_WRONG_TYPE_E = -130
	RSA_BUFFER_E = -131
	BUFFER_E = -132
	ALGO_ID_E = -133
	PUBLIC_KEY_E = -134
	DATE_E = -135
	SUBJECT_E = -136
	ISSUER_E = -137
	CA_TRUE_E = -138
	EXTENSIONS_E = -139
	ASN_PARSE_E = -140
	ASN_VERSION_E = -141
	ASN_GETINT_E = -142
	ASN_RSA_KEY_E = -143
	ASN_OBJECT_ID_E = -144
	ASN_TAG_NULL_E = -145
	ASN_EXPECT_0_E = -146
	ASN_BITSTR_E = -147
	ASN_UNKNOWN_OID_E = -148
	ASN_DATE_SZ_E = -149
	ASN_BEFORE_DATE_E = -150
	ASN_AFTER_DATE_E = -151
	ASN_SIG_OID_E = -152
	ASN_TIME_E = -153
	ASN_INPUT_E = -154
	ASN_SIG_CONFIRM_E = -155
	ASN_SIG_HASH_E = -156
	ASN_SIG_KEY_E = -157
	ASN_DH_KEY_E = -158
	ASN_CRIT_EXT_E = -160
	ASN_ALT_NAME_E = -161
	ASN_NO_PEM_HEADER = -162
	ECC_BAD_ARG_E = -170
	ASN_ECC_KEY_E = -171
	ECC_CURVE_OID_E = -172
	BAD_FUNC_ARG = -173
	NOT_COMPILED_IN = -174
	UNICODE_SIZE_E = -175
	NO_PASSWORD = -176
	ALT_NAME_E = -177
	BAD_OCSP_RESPONDER = -178
	CRL_CERT_DATE_ERR = -179
	AES_GCM_AUTH_E = -180
	AES_CCM_AUTH_E = -181
	ASYNC_INIT_E = -182
	COMPRESS_INIT_E = -183
	COMPRESS_E = -184
	DECOMPRESS_INIT_E = -185
	DECOMPRESS_E = -186
	BAD_ALIGN_E = -187
	ASN_NO_SIGNER_E = -188
	ASN_CRL_CONFIRM_E = -189
	ASN_CRL_NO_SIGNER_E = -190
	ASN_OCSP_CONFIRM_E = -191
	BAD_STATE_E = -192
	BAD_PADDING_E = -193
	REQ_ATTRIBUTE_E = -194
	PKCS7_OID_E = -195
	PKCS7_RECIP_E = -196
	FIPS_NOT_ALLOWED_E = -197
	ASN_NAME_INVALID_E = -198
	RNG_FAILURE_E = -199
	HMAC_MIN_KEYLEN_E = -200
	RSA_PAD_E = -201
	LENGTH_ONLY_E = -202
	IN_CORE_FIPS_E = -203
	AES_KAT_FIPS_E = -204
	DES3_KAT_FIPS_E = -205
	HMAC_KAT_FIPS_E = -206
	RSA_KAT_FIPS_E = -207
	DRBG_KAT_FIPS_E = -208
	DRBG_CONT_FIPS_E = -209
	AESGCM_KAT_FIPS_E = -210
	THREAD_STORE_KEY_E = -211
	THREAD_STORE_SET_E = -212
	MAC_CMP_FAILED_E = -213
	IS_POINT_E = -214
	ECC_INF_E = -215
	ECC_PRIV_KEY_E = -216
	ECC_OUT_OF_RANGE_E = -217
	SRP_CALL_ORDER_E = -218
	SRP_VERIFY_E = -219
	SRP_BAD_KEY_E = -220
	ASN_NO_SKID = -221
	ASN_NO_AKID = -222
	ASN_NO_KEYUSAGE = -223
	SKID_E = -224
	AKID_E = -225
	KEYUSAGE_E = -226
	CERTPOLICIES_E = -227
	WC_INIT_E = -228
	SIG_VERIFY_E = -229
	BAD_COND_E = -230
	SIG_TYPE_E = -231
	HASH_TYPE_E = -232
	WC_KEY_SIZE_E = -234
	ASN_COUNTRY_SIZE_E = -235
	MISSING_RNG_E = -236
	ASN_PATHLEN_SIZE_E = -237
	ASN_PATHLEN_INV_E = -238
	BAD_KEYWRAP_ALG_E = -239
	BAD_KEYWRAP_IV_E = -240
	WC_CLEANUP_E = -241
	ECC_CDH_KAT_FIPS_E = -242
	DH_CHECK_PUB_E = -243
	BAD_PATH_ERROR = -244
	ASYNC_OP_E = -245
	ECC_PRIVATEONLY_E = -246
	EXTKEYUSAGE_E = -247
	WC_HW_E = -248
	WC_HW_WAIT_E = -249
	PSS_SALTLEN_E = -250
	PRIME_GEN_E = -251
	BER_INDEF_E = -252
	RSA_OUT_OF_RANGE_E = -253
	RSAPSS_PAT_FIPS_E = -254
	ECDSA_PAT_FIPS_E = -255
	DH_KAT_FIPS_E = -256
	AESCCM_KAT_FIPS_E = -257
	SHA3_KAT_FIPS_E = -258
	ECDHE_KAT_FIPS_E = -259
	AES_GCM_OVERFLOW_E = -260
	AES_CCM_OVERFLOW_E = -261
	RSA_KEY_PAIR_E = -262
	DH_CHECK_PRIV_E = -263
	WC_AFALG_SOCK_E = -264
	WC_DEVCRYPTO_E = -265
	ZLIB_INIT_ERROR = -266
	ZLIB_COMPRESS_ERROR = -267
	ZLIB_DECOMPRESS_ERROR = -268
	PKCS7_NO_SIGNER_E = -269
	WC_PKCS7_WANT_READ_E = -270
	CRYPTOCB_UNAVAILABLE = -271
	PKCS7_SIGNEEDS_CHECK = -272
	PSS_SALTLEN_RECOVER_E = -273
	CHACHA_POLY_OVERFLOW = -274
	ASN_SELF_SIGNED_E = -275
	SAKKE_VERIFY_FAIL_E = -276
	MISSING_IV = -277
	MISSING_KEY = -278
	BAD_LENGTH_E = -279
	ECDSA_KAT_FIPS_E = -280
	RSA_PAT_FIPS_E = -281
	KDF_TLS12_KAT_FIPS_E = -282
	KDF_TLS13_KAT_FIPS_E = -283
	KDF_SSH_KAT_FIPS_E = -284
	DHE_PCT_E = -285
	ECC_PCT_E = -286
	FIPS_PRIVATE_KEY_LOCKED_E = -287
	PROTOCOLCB_UNAVAILABLE = -288
	AES_SIV_AUTH_E = -289
	NO_VALID_DEVID = -290
	IO_FAILED_E = -291
	SYSLIB_FAILED_E = -292
	WC_LAST_E = -292
	MIN_CODE_E = -300
end enum

declare sub wc_ErrorString(byval err as long, byval buff as zstring ptr)
declare function wc_GetErrorString(byval error as long) as const zstring ptr
#define WOLFSSL_LOGGING_H

type wc_LogLevels as long
enum
	ERROR_LOG = 0
	INFO_LOG
	ENTER_LOG
	LEAVE_LOG
	OTHER_LOG
end enum

type wolfSSL_Logging_cb as sub(byval logLevel as const long, byval logMessage as const zstring const ptr)
declare function wolfSSL_SetLoggingCb(byval log_function as wolfSSL_Logging_cb) as long
declare function wolfSSL_GetLoggingCb() as wolfSSL_Logging_cb
declare function wolfSSL_Debugging_ON() as long
declare sub wolfSSL_Debugging_OFF()

#define WOLFSSL_START(n)
#define WOLFSSL_END(n)
#define WOLFSSL_TIME(n)
#define WOLFSSL_ENTER(m)
#define WOLFSSL_LEAVE(m, r)
#define WOLFSSL_STUB(m)
#define WOLFSSL_IS_DEBUG_ON() 0
#macro WOLFSSL_MSG_EX(m, __VA_ARGS__...)
	scope
	end scope
#endmacro
#macro WOLFSSL_MSG(m)
	scope
	end scope
#endmacro
#macro WOLFSSL_BUFFER(b, l)
	scope
	end scope
#endmacro
#define WOLFSSL_ERROR(e)
#define WOLFSSL_ERROR_MSG(m)
#define WOLFSSL_ERROR_VERBOSE(e) (e)
#define WOLFSSL_OPENSSL_COMPAT_TYPES_H_
#define WOLF_CRYPT_HMAC_H
const WC_HMAC_INNER_HASH_KEYED_SW = 1
const WC_HMAC_INNER_HASH_KEYED_DEV = 2

enum
	HMAC_FIPS_MIN_KEY = 14
	IPAD = &h36
	OPAD = &h5C
	WC_SHA512 = WC_HASH_TYPE_SHA512
	WC_SHA512_224 = WC_HASH_TYPE_SHA512_224
	WC_SHA512_256 = WC_HASH_TYPE_SHA512_256
	WC_SHA384 = WC_HASH_TYPE_SHA384
	WC_SHA224 = WC_HASH_TYPE_SHA224
	WC_SHA3_224 = WC_HASH_TYPE_SHA3_224
	WC_SHA3_256 = WC_HASH_TYPE_SHA3_256
	WC_SHA3_384 = WC_HASH_TYPE_SHA3_384
	WC_SHA3_512 = WC_HASH_TYPE_SHA3_512
end enum

const WC_HMAC_BLOCK_SIZE = WC_MAX_BLOCK_SIZE
const HMAC_BLOCK_SIZE = WC_HMAC_BLOCK_SIZE

union wc_HmacHash
	md5 as wc_Md5
	sha as wc_Sha
	sha256 as wc_Sha256
end union

type Hmac
	hash as wc_HmacHash
	ipad(0 to (WC_SHA256_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	opad(0 to (WC_SHA256_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	innerHash(0 to (WC_SHA256_DIGEST_SIZE / sizeof(word32)) - 1) as word32
	heap as any ptr
	macType as _byte
	innerHashKeyed as _byte
end type

#define WC_HMAC_TYPE_DEFINED
declare function wc_HmacSetKey(byval hmac as Hmac ptr, byval type as long, byval key as const _byte ptr, byval keySz as word32) as long
declare function wc_HmacUpdate(byval hmac as Hmac ptr, byval in as const _byte ptr, byval sz as word32) as long
declare function wc_HmacFinal(byval hmac as Hmac ptr, byval out as _byte ptr) as long
declare function wc_HmacSizeByType(byval type as long) as long
declare function wc_HmacInit(byval hmac as Hmac ptr, byval heap as any ptr, byval devId as long) as long
declare sub wc_HmacFree(byval hmac as Hmac ptr)
declare function wolfSSL_GetHmacMaxSize() as long
declare function _InitHmac(byval hmac as Hmac ptr, byval type as long, byval heap as any ptr) as long

type WOLFSSL_HMAC_CTX
	hmac as Hmac
	as long type
	save_ipad(0 to (WC_SHA256_BLOCK_SIZE / sizeof(word32)) - 1) as word32
	save_opad(0 to (WC_SHA256_BLOCK_SIZE / sizeof(word32)) - 1) as word32
end type

type WOLFSSL_EVP_MD as zstring
type WOLFSSL_EVP_CIPHER as zstring
type WOLFSSL_ENGINE as long
type WOLFSSL_PKCS8_PRIV_KEY_INFO as WOLFSSL_EVP_PKEY
#define WOLFSSL_CALLBACKS_H

enum
	MAX_PACKETNAME_SZ = 24
	MAX_CIPHERNAME_SZ = 24
	MAX_TIMEOUT_NAME_SZ = 24
	MAX_PACKETS_HANDSHAKE = 14
	MAX_VALUE_SZ = 128
end enum

type WOLFSSL as WOLFSSL

type handShakeInfo_st
	ssl as WOLFSSL ptr
	cipherName as zstring * MAX_CIPHERNAME_SZ + 1
	packetNames(0 to MAX_PACKETS_HANDSHAKE - 1) as zstring * MAX_PACKETNAME_SZ + 1
	numberPackets as long
	negotiationError as long
end type

type HandShakeInfo as handShakeInfo_st

type WOLFSSL_TIMEVAL
	tv_sec as clong
	tv_usec as clong
end type

'TODO???
#ifndef TimeVal
  type Timeval as WOLFSSL_TIMEVAL
#endif
type Timeval_ as WOLFSSL_TIMEVAL

type packetInfo_st
	packetName as zstring * MAX_PACKETNAME_SZ + 1
	timestamp as WOLFSSL_TIMEVAL
	value(0 to MAX_VALUE_SZ - 1) as ubyte
	bufferValue as ubyte ptr
	valueSz as long
end type

type PacketInfo as packetInfo_st

type timeoutInfo_st
	timeoutName as zstring * MAX_TIMEOUT_NAME_SZ + 1
	flags as long
	numberPackets as long
	packets(0 to MAX_PACKETS_HANDSHAKE - 1) as PacketInfo
	timeoutValue as WOLFSSL_TIMEVAL
end type

type TimeoutInfo as timeoutInfo_st
#define WOLFSSL_VERSION_ LIBWOLFSSL_VERSION_STRING
type WOLFSSL_LHASH as WOLFSSL_STACK
#define WOLF_LHASH_OF(x) WOLFSSL_LHASH
#define WOLF_STACK_OF(x) WOLFSSL_STACK
#define DECLARE_STACK_OF(x) WOLF_STACK_OF(x)
#define WOLFSSL_WOLFSSL_TYPE_DEFINED
#define WOLFSSL_WOLFSSL_CTX_TYPE_DEFINED
type WOLFSSL_X509_PKCS12 as WC_PKCS12
type WOLFSSL_X509_STORE_CTX as WOLFSSL_X509_STORE_CTX_
type WOLFSSL_X509_STORE_CTX_verify_cb as function(byval as long, byval as WOLFSSL_X509_STORE_CTX ptr) as long

#define WOLFSSL_TYPES_DEFINED
#define WOLFSSL_IO_H
#define USE_WOLFSSL_IO
#define XFCNTL(fd, flag, block) fcntl((fd), (flag), (block))
#define SOCKET_EWOULDBLOCK EWOULDBLOCK
#define SOCKET_EAGAIN EAGAIN
#define SOCKET_ECONNRESET ECONNRESET
#define SOCKET_EINTR EINTR
#define SOCKET_EPIPE EPIPE
#define SOCKET_ECONNREFUSED ECONNREFUSED
#define SOCKET_ECONNABORTED ECONNABORTED
#define SEND_FUNCTION send
#define RECV_FUNCTION recv
#define HAVE_SOCKADDR
type SOCKET_T as long
const SOCKET_INVALID = -1
#define XSOCKLENT socklen_t
type SOCKADDR_S as sockaddr_storage

#ifndef socklen_t
type socklen_t as socklen_t
#endif

declare function wolfIO_TcpConnect(byval sockfd as SOCKET_T ptr, byval ip as const zstring ptr, byval port as ushort, byval to_sec as long) as long
declare function wolfIO_TcpAccept(byval sockfd as SOCKET_T, byval peer_addr as SOCKADDR ptr, byval peer_len as socklen_t ptr) as long
declare function wolfIO_TcpBind(byval sockfd as SOCKET_T ptr, byval port as word16) as long
declare function wolfIO_Send(byval sd as SOCKET_T, byval buf as zstring ptr, byval sz as long, byval wrFlags as long) as long
declare function wolfIO_Recv(byval sd as SOCKET_T, byval buf as zstring ptr, byval sz as long, byval rdFlags as long) as long
#ifndef CloseSocket
#define CloseSocket(s) close(s)
#endif
#define StartTCP()
declare function BioSend(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long
declare function BioReceive(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long
declare function EmbedReceive(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long
declare function EmbedSend(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long
type CallbackIORecv as function(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long
type CallbackIOSend as function(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval sz as long, byval ctx as any ptr) as long

#ifndef WOLFSSL_CTX
type WOLFSSL_CTX as WOLFSSL_CTX
#endif

declare sub wolfSSL_CTX_SetIORecv(byval ctx as WOLFSSL_CTX ptr, byval CBIORecv as CallbackIORecv)
declare sub wolfSSL_CTX_SetIOSend(byval ctx as WOLFSSL_CTX ptr, byval CBIOSend as CallbackIOSend)
declare sub wolfSSL_SSLSetIORecv(byval ssl as WOLFSSL ptr, byval CBIORecv as CallbackIORecv)
declare sub wolfSSL_SSLSetIOSend(byval ssl as WOLFSSL ptr, byval CBIOSend as CallbackIOSend)
declare sub wolfSSL_SetIORecv alias "wolfSSL_CTX_SetIORecv"(byval ctx as WOLFSSL_CTX ptr, byval CBIORecv as CallbackIORecv)
declare sub wolfSSL_SetIOSend alias "wolfSSL_CTX_SetIOSend"(byval ctx as WOLFSSL_CTX ptr, byval CBIOSend as CallbackIOSend)
declare sub wolfSSL_SetIOReadCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare sub wolfSSL_SetIOWriteCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare function wolfSSL_GetIOReadCtx(byval ssl as WOLFSSL ptr) as any ptr
declare function wolfSSL_GetIOWriteCtx(byval ssl as WOLFSSL ptr) as any ptr
declare sub wolfSSL_SetIOReadFlags(byval ssl as WOLFSSL ptr, byval flags as long)
declare sub wolfSSL_SetIOWriteFlags(byval ssl as WOLFSSL ptr, byval flags as long)

#define XINET_NTOP(a, b, c, d) inet_ntop((a), (b), (c), (d))
#define XINET_PTON(a, b, c) inet_pton((a), (b), (c))
#define XHTONS(a) htons((a))
#define XNTOHS(a) ntohs((a))
#define WOLFSSL_IP4 AF_INET
#define WOLFSSL_IP6 AF_INET6
#define WOLFSSL_RSA_TYPE_DEFINED
#define WOLFSSL_DSA_TYPE_DEFINED
type WOLFSSL_EC_METHOD as WOLFSSL_EC_GROUP
#define WOLFSSL_EC_TYPE_DEFINED
#define WOLFSSL_ECDSA_TYPE_DEFINED
type WOLFSSL_X509_CRL as WOLFSSL_CRL
#define WOLFSSL_DH_TYPE_DEFINED
type WOLFSSL_ASN1_UTCTIME as WOLFSSL_ASN1_TIME
type WOLFSSL_ASN1_GENERALIZEDTIME as WOLFSSL_ASN1_TIME

type WOLFSSL_ASN1_STRING
	strData as zstring * CTC_NAME_SIZE
	length as long
	as long type
	nid as long
	data as zstring ptr
	flags as clong
	isDynamic : 1 as ulong
end type

const WOLFSSL_MAX_SNAME = 40
const WOLFSSL_ASN1_DYNAMIC = &h1
const WOLFSSL_ASN1_DYNAMIC_DATA = &h2
type WOLFSSL_ASN1_OBJECT as WOLFSSL_ASN1_OBJECT_
type WOLFSSL_ASN1_TYPE as WOLFSSL_ASN1_TYPE_

type WOLFSSL_ASN1_OTHERNAME
	type_id as WOLFSSL_ASN1_OBJECT ptr
	value as WOLFSSL_ASN1_TYPE ptr
end type

#ifndef WOLFSSL_X509_NAME
type WOLFSSL_X509_NAME as WOLFSSL_X509_NAME
#endif

union WOLFSSL_GENERAL_NAME_d
	ptr as zstring ptr
	otherName as WOLFSSL_ASN1_OTHERNAME ptr
	rfc822Name as WOLFSSL_ASN1_STRING ptr
	dNSName as WOLFSSL_ASN1_STRING ptr
	x400Address as WOLFSSL_ASN1_TYPE ptr
	directoryName as WOLFSSL_X509_NAME ptr
	uniformResourceIdentifier as WOLFSSL_ASN1_STRING ptr
	iPAddress as WOLFSSL_ASN1_STRING ptr
	registeredID as WOLFSSL_ASN1_OBJECT ptr
	ip as WOLFSSL_ASN1_STRING ptr
	dirn as WOLFSSL_X509_NAME ptr
	ia5 as WOLFSSL_ASN1_STRING ptr
	rid as WOLFSSL_ASN1_OBJECT ptr
	other as WOLFSSL_ASN1_TYPE ptr
end union

type WOLFSSL_GENERAL_NAME
	as long type
	d as WOLFSSL_GENERAL_NAME_d
end type


union WOLFSSL_DIST_POINT_NAME_name
	fullname as any ptr 'WOLFSSL_STACK ptr
end union

type WOLFSSL_DIST_POINT_NAME
	as long type
	name as WOLFSSL_DIST_POINT_NAME_name
end type

type WOLFSSL_DIST_POINT
	distpoint as WOLFSSL_DIST_POINT_NAME ptr
end type

type WOLFSSL_ACCESS_DESCRIPTION
	method as WOLFSSL_ASN1_OBJECT ptr
	location as WOLFSSL_GENERAL_NAME ptr
end type

#ifndef WOLFSSL_X509
type WOLFSSL_X509 as WOLFSSL_X509
#endif

type WOLFSSL_X509V3_CTX
	x509 as WOLFSSL_X509 ptr
end type

type d
	dNSName as WOLFSSL_ASN1_STRING ptr
	ia5_internal as WOLFSSL_ASN1_STRING
	ia5 as WOLFSSL_ASN1_STRING ptr
	iPAddress as WOLFSSL_ASN1_STRING ptr
end type

type WOLFSSL_ASN1_OBJECT_
	heap as any ptr
	obj as const ubyte ptr
	sName as zstring * 40
	as long type
	grp as long
	nid as long
	objSz as ulong
	dynamic as ubyte
	d as d
end type

union WOLFSSL_ASN1_TYPE_value
	ptr as zstring ptr
	asn1_string as WOLFSSL_ASN1_STRING ptr
	object as WOLFSSL_ASN1_OBJECT ptr
	integer as WOLFSSL_ASN1_INTEGER ptr
	bit_string as any ptr 'WOLFSSL_ASN1_BIT_STRING ptr
	octet_string as WOLFSSL_ASN1_STRING ptr
	printablestring as WOLFSSL_ASN1_STRING ptr
	ia5string as WOLFSSL_ASN1_STRING ptr
	utctime as WOLFSSL_ASN1_TIME ptr
	generalizedtime as WOLFSSL_ASN1_TIME ptr
	utf8string as WOLFSSL_ASN1_STRING ptr
	set as WOLFSSL_ASN1_STRING ptr
	sequence as WOLFSSL_ASN1_STRING ptr
end union

type WOLFSSL_ASN1_TYPE_
	as long type
	value as WOLFSSL_ASN1_TYPE_value
end type

#ifndef WOLFSSL_STACK
type WOLFSSL_STACK as WOLFSSL_STACK
#endif

type WOLFSSL_X509_ATTRIBUTE
	object as WOLFSSL_ASN1_OBJECT ptr
	value as WOLFSSL_ASN1_TYPE ptr
	set as any ptr 'WOLFSSL_STACK ptr
end type

union WOLFSSL_EVP_PKEY_pkey
	ptr as zstring ptr
end union

type WOLFSSL_EVP_PKEY
	heap as any ptr
	as long type
	save_type as long
	pkey_sz as long
	references as long
	refMutex as wolfSSL_Mutex
	pkey as WOLFSSL_EVP_PKEY_pkey
	pkcs8HeaderSz as word16
	ownDh : 1 as _byte
	ownEcc : 1 as _byte
	ownDsa : 1 as _byte
	ownRsa : 1 as _byte
end type

type WOLFSSL_X509_PKEY
	dec_pkey as WOLFSSL_EVP_PKEY ptr
	heap as any ptr
end type

type WOLFSSL_X509_INFO
	x509 as WOLFSSL_X509 ptr
	crl as WOLFSSL_X509_CRL ptr
	x_pkey as WOLFSSL_X509_PKEY ptr
	enc_cipher as EncryptedInfo
	enc_len as long
	enc_data as zstring ptr
	num as long
end type

#define WOLFSSL_EVP_PKEY_DEFAULT EVP_PKEY_RSA

type WOLFSSL_X509_ALGOR
	algorithm as WOLFSSL_ASN1_OBJECT ptr
	parameter as WOLFSSL_ASN1_TYPE ptr
end type

type WOLFSSL_X509_PUBKEY
	algor as WOLFSSL_X509_ALGOR ptr
	pkey as WOLFSSL_EVP_PKEY ptr
	pubKeyOID as long
end type

type BIO_TYPE as long
enum
	WOLFSSL_BIO_UNDEF = 0
	WOLFSSL_BIO_BUFFER = 1
	WOLFSSL_BIO_SOCKET = 2
	WOLFSSL_BIO_SSL = 3
	WOLFSSL_BIO_MEMORY = 4
	WOLFSSL_BIO_BIO = 5
	WOLFSSL_BIO_FILE = 6
	WOLFSSL_BIO_BASE64 = 7
	WOLFSSL_BIO_MD = 8
end enum

type BIO_FLAGS as long
enum
	WOLFSSL_BIO_FLAG_BASE64_NO_NL = &h01
	WOLFSSL_BIO_FLAG_READ = &h02
	WOLFSSL_BIO_FLAG_WRITE = &h04
	WOLFSSL_BIO_FLAG_IO_SPECIAL = &h08
	WOLFSSL_BIO_FLAG_RETRY = &h10
end enum

type BIO_CB_OPS as long
enum
	WOLFSSL_BIO_CB_FREE = &h01
	WOLFSSL_BIO_CB_READ = &h02
	WOLFSSL_BIO_CB_WRITE = &h03
	WOLFSSL_BIO_CB_PUTS = &h04
	WOLFSSL_BIO_CB_GETS = &h05
	WOLFSSL_BIO_CB_CTRL = &h06
	WOLFSSL_BIO_CB_RETURN = &h80
end enum

type WOLFSSL_BUF_MEM
	data as zstring ptr
	length as uinteger
	max as uinteger
end type

type WOLFSSL_BIO as WOLFSSL_BIO_
type wolfSSL_BIO_meth_write_cb as function(byval as WOLFSSL_BIO ptr, byval as const zstring ptr, byval as long) as long
type wolfSSL_BIO_meth_read_cb as function(byval as WOLFSSL_BIO ptr, byval as zstring ptr, byval as long) as long
type wolfSSL_BIO_meth_puts_cb as function(byval as WOLFSSL_BIO ptr, byval as const zstring ptr) as long
type wolfSSL_BIO_meth_gets_cb as function(byval as WOLFSSL_BIO ptr, byval as zstring ptr, byval as long) as long
type wolfSSL_BIO_meth_ctrl_get_cb as function(byval as WOLFSSL_BIO ptr, byval as long, byval as clong, byval as any ptr) as clong
type wolfSSL_BIO_meth_create_cb as function(byval as WOLFSSL_BIO ptr) as long
type wolfSSL_BIO_meth_destroy_cb as function(byval as WOLFSSL_BIO ptr) as long
type wolfssl_BIO_meth_ctrl_info_cb as function(byval as WOLFSSL_BIO ptr, byval as long, byval as function(byval as WOLFSSL_BIO ptr, byval as long, byval as long) as long) as clong
const MAX_BIO_METHOD_NAME = 256

type WOLFSSL_BIO_METHOD
	as _byte type
	name as zstring * 256
	writeCb as wolfSSL_BIO_meth_write_cb
	readCb as wolfSSL_BIO_meth_read_cb
	putsCb as wolfSSL_BIO_meth_puts_cb
	getsCb as wolfSSL_BIO_meth_gets_cb
	ctrlCb as wolfSSL_BIO_meth_ctrl_get_cb
	createCb as wolfSSL_BIO_meth_create_cb
	freeCb as wolfSSL_BIO_meth_destroy_cb
	ctrlInfoCb as wolfssl_BIO_meth_ctrl_info_cb
end type

type wolf_bio_info_cb as function(byval bio as WOLFSSL_BIO ptr, byval event as long, byval parg as const zstring ptr, byval iarg as long, byval larg as clong, byval return_value as clong) as clong

type WOLFSSL_BIO_
	mem_buf as WOLFSSL_BUF_MEM ptr
	method as WOLFSSL_BIO_METHOD ptr
	prev as WOLFSSL_BIO ptr
	next as WOLFSSL_BIO ptr
	pair as WOLFSSL_BIO ptr
	heap as any ptr
	ptr as any ptr
	usrCtx as any ptr
	ip as zstring ptr
	port as word16
	infoArg as zstring ptr
	infoCb as wolf_bio_info_cb
	wrSz as long
	wrIdx as long
	rdIdx as long
	readRq as long
	num as long
	eof as long
	flags as long
	as _byte type
	init : 1 as _byte
	shutdown : 1 as _byte
end type

type WOLFSSL_COMP_METHOD
	as long type
end type

type WOLFSSL_COMP
	id as long
	name as const zstring ptr
	method as WOLFSSL_COMP_METHOD ptr
end type

const WOLFSSL_X509_L_FILE_LOAD = &h1
const WOLFSSL_X509_L_ADD_DIR = &h2
const WOLFSSL_X509_L_ADD_STORE = &h3
const WOLFSSL_X509_L_LOAD_STORE = &h4

type WOLFSSL_X509_LOOKUP_METHOD
	as long type
end type

type WOLFSSL_X509_STORE as WOLFSSL_X509_STORE_

type WOLFSSL_X509_LOOKUP
	store as WOLFSSL_X509_STORE ptr
	as long type
	dirs as any ptr 'TODO: WOLFSSL_BY_DIR ptr
end type

type WOLFSSL_X509_STORE_
	cache as long
	cm as any ptr 'TODO: WOLFSSL_CERT_MANAGER ptr
	lookup as WOLFSSL_X509_LOOKUP
	refMutex as wolfSSL_Mutex
	refCount as long
end type

const WOLFSSL_ALWAYS_CHECK_SUBJECT = &h1
const WOLFSSL_NO_WILDCARDS = &h2
const WOLFSSL_NO_PARTIAL_WILDCARDS = &h4

type WOLFSSL_ALERT
	code as long
	level as long
end type

type WOLFSSL_ALERT_HISTORY
	last_rx as WOLFSSL_ALERT
	last_tx as WOLFSSL_ALERT
end type

type WOLFSSL_X509_REVOKED
	serialNumber as WOLFSSL_ASN1_INTEGER ptr
end type

type WOLFSSL_X509_LOOKUP_TYPE as long
enum
	WOLFSSL_X509_LU_NONE = 0
	WOLFSSL_X509_LU_X509
	WOLFSSL_X509_LU_CRL
end enum

union WOLFSSL_X509_OBJECT_data
	ptr as zstring ptr
	x509 as WOLFSSL_X509 ptr
	crl as WOLFSSL_X509_CRL ptr
end union

type WOLFSSL_X509_OBJECT
	as WOLFSSL_X509_LOOKUP_TYPE type
	data as WOLFSSL_X509_OBJECT_data
end type

type WOLFSSL_ASN1_BOOLEAN as long

type WOLFSSL_BUFFER_INFO
	buffer as ubyte ptr
	length as ulong
end type

type WOLFSSL_X509_STORE_CTX_
	store as WOLFSSL_X509_STORE ptr
	current_cert as WOLFSSL_X509 ptr
	sesChain as any ptr 'TODO: WOLFSSL_X509_CHAIN ptr
	chain as any ptr 'TODO: WOLFSSL_STACK ptr
	domain as zstring ptr
	userCtx as any ptr
	error as long
	error_depth as long
	discardSessionCerts as long
	totalCerts as long
	certs as WOLFSSL_BUFFER_INFO ptr
	verify_cb as WOLFSSL_X509_STORE_CTX_verify_cb
end type

type WOLFSSL_STRING as zstring ptr

type WOLFSSL_RAND_METHOD
	seed as function(byval seed as const any ptr, byval len as long) as long
	bytes as function(byval buf as ubyte ptr, byval len as long) as long
	cleanup as sub()
	add as function(byval add as const any ptr, byval len as long, byval entropy as double) as long
	pseudorand as function(byval buf as ubyte ptr, byval len as long) as long
	status as function() as long
end type

type AlertDescription as long
enum
	close_notify = 0
	unexpected_message = 10
	bad_record_mac = 20
	record_overflow = 22
	decompression_failure = 30
	handshake_failure = 40
	no_certificate = 41
	bad_certificate = 42
	unsupported_certificate = 43
	certificate_revoked = 44
	certificate_expired = 45
	certificate_unknown = 46
	illegal_parameter = 47
	unknown_ca = 48
	access_denied = 49
	decode_error = 50
	decrypt_error = 51
	protocol_version = 70
	insufficient_security = 71
	internal_error = 80
	inappropriate_fallback = 86
	user_canceled = 90
	no_renegotiation = 100
	missing_extension = 109
	unsupported_extension = 110
	unrecognized_name = 112
	bad_certificate_status_response = 113
	unknown_psk_identity = 115
	certificate_required = 116
	no_application_protocol = 120
end enum

type AlertLevel as long
enum
	alert_none = 0
	alert_warning = 1
	alert_fatal = 2
end enum

type SNICbReturn as long
enum
	warning_return = alert_warning
	fatal_return = alert_fatal
	noack_return
end enum

#define WS_RETURN_CODE(item1, item2) (item1)
const WOLFSSL_MAX_MASTER_KEY_LENGTH = 48
const WOLFSSL_MAX_GROUP_COUNT = 10
const WOLFSSL_MODE_AUTO_RETRY_ATTEMPTS = 10

#ifndef WOLFSSL_METHOD
type WOLFSSL_METHOD as WOLFSSL_METHOD
#endif

type wolfSSL_method_func as function(byval heap as any ptr) as WOLFSSL_METHOD ptr

declare function wolfTLS_client_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLS_client_method() as WOLFSSL_METHOD ptr
declare function wolfTLS_server_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLS_server_method() as WOLFSSL_METHOD ptr
declare function wolfSSLv23_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfSSLv23_method() as WOLFSSL_METHOD ptr
declare function wolfSSLv23_client_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfSSLv23_client_method() as WOLFSSL_METHOD ptr
declare function wolfSSLv23_server_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfSSLv23_server_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_client_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_client_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_server_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_1_server_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_client_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_client_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_server_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_2_server_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_client_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_client_method() as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_server_method_ex(byval heap as any ptr) as WOLFSSL_METHOD ptr
declare function wolfTLSv1_3_server_method() as WOLFSSL_METHOD ptr

declare function wolfSSL_CTX_use_certificate_file(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_CTX_use_PrivateKey_file(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval format as long) as long

const WOLFSSL_LOAD_FLAG_NONE = &h00000000
const WOLFSSL_LOAD_FLAG_IGNORE_ERR = &h00000001
const WOLFSSL_LOAD_FLAG_DATE_ERR_OKAY = &h00000002
const WOLFSSL_LOAD_FLAG_PEM_CA_ONLY = &h00000004
const WOLFSSL_LOAD_VERIFY_DEFAULT_FLAGS = WOLFSSL_LOAD_FLAG_NONE

declare function wolfSSL_get_verify_depth(byval ssl as WOLFSSL ptr) as clong
declare function wolfSSL_CTX_get_verify_depth(byval ctx as WOLFSSL_CTX ptr) as clong
declare sub wolfSSL_CTX_set_verify_depth(byval ctx as WOLFSSL_CTX ptr, byval depth as long)
const WOLFSSL_CIPHER_SUITE_FLAG_NONE = &h0
const WOLFSSL_CIPHER_SUITE_FLAG_NAMEALIAS = &h1
declare function wolfSSL_CTX_load_verify_locations_ex(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval path as const zstring ptr, byval flags as word32) as long
declare function wolfSSL_CTX_load_verify_locations(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval path as const zstring ptr) as long
declare function wolfSSL_CTX_use_certificate_chain_file(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr) as long
declare function wolfSSL_CTX_use_certificate_chain_file_format(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_CTX_use_RSAPrivateKey_file(byval ctx as WOLFSSL_CTX ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_use_certificate_file(byval ssl as WOLFSSL ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_use_PrivateKey_file(byval ssl as WOLFSSL ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_use_certificate_chain_file(byval ssl as WOLFSSL ptr, byval file as const zstring ptr) as long
declare function wolfSSL_use_certificate_chain_file_format(byval ssl as WOLFSSL ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_use_RSAPrivateKey_file(byval ssl as WOLFSSL ptr, byval file as const zstring ptr, byval format as long) as long
declare function wolfSSL_CTX_new_ex(byval method as WOLFSSL_METHOD ptr, byval heap as any ptr) as WOLFSSL_CTX ptr
declare function wolfSSL_CTX_new(byval method as WOLFSSL_METHOD ptr) as WOLFSSL_CTX ptr
declare function wolfSSL_CTX_up_ref(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_new(byval ctx as WOLFSSL_CTX ptr) as WOLFSSL ptr
declare function wolfSSL_get_SSL_CTX(byval ssl as WOLFSSL ptr) as WOLFSSL_CTX ptr

#ifndef WOLFSSL_X509_VERIFY_PARAM
type WOLFSSL_X509_VERIFY_PARAM as WOLFSSL_X509_VERIFY_PARAM
#endif

declare function wolfSSL_CTX_get0_param(byval ctx as WOLFSSL_CTX ptr) as WOLFSSL_X509_VERIFY_PARAM ptr
declare function wolfSSL_get0_param(byval ssl as WOLFSSL ptr) as WOLFSSL_X509_VERIFY_PARAM ptr
declare function wolfSSL_CTX_set1_param(byval ctx as WOLFSSL_CTX ptr, byval vpm as WOLFSSL_X509_VERIFY_PARAM ptr) as long
declare function wolfSSL_is_server(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_write_dup(byval ssl as WOLFSSL ptr) as WOLFSSL ptr
declare function wolfSSL_set_fd(byval ssl as WOLFSSL ptr, byval fd as long) as long
declare function wolfSSL_set_write_fd(byval ssl as WOLFSSL ptr, byval fd as long) as long
declare function wolfSSL_set_read_fd(byval ssl as WOLFSSL ptr, byval fd as long) as long
declare function wolfSSL_get_cipher_list(byval priority as long) as zstring ptr
declare function wolfSSL_get_cipher_list_ex(byval ssl as WOLFSSL ptr, byval priority as long) as zstring ptr
declare function wolfSSL_get_ciphers(byval buf as zstring ptr, byval len as long) as long
declare function wolfSSL_get_ciphers_iana(byval buf as zstring ptr, byval len as long) as long
declare function wolfSSL_get_cipher_name(byval ssl as WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_get_cipher_name_from_suite(byval cipherSuite0 as ubyte, byval cipherSuite as ubyte) as const zstring ptr
declare function wolfSSL_get_cipher_name_iana_from_suite(byval cipherSuite0 as ubyte, byval cipherSuite as ubyte) as const zstring ptr
declare function wolfSSL_get_cipher_suite_from_name(byval name as const zstring ptr, byval cipherSuite0 as ubyte ptr, byval cipherSuite as ubyte ptr, byval flags as long ptr) as long
declare function wolfSSL_get_shared_ciphers(byval ssl as WOLFSSL ptr, byval buf as zstring ptr, byval len as long) as const zstring ptr
declare function wolfSSL_get_curve_name(byval ssl as WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_get_fd(byval ssl as const WOLFSSL ptr) as long
declare function wolfSSL_connect(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_write(byval ssl as WOLFSSL ptr, byval data as const any ptr, byval sz as long) as long
declare function wolfSSL_read(byval ssl as WOLFSSL ptr, byval data as any ptr, byval sz as long) as long
declare function wolfSSL_peek(byval ssl as WOLFSSL ptr, byval data as any ptr, byval sz as long) as long
declare function wolfSSL_accept(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_mutual_auth(byval ctx as WOLFSSL_CTX ptr, byval req as long) as long
declare function wolfSSL_mutual_auth(byval ssl as WOLFSSL ptr, byval req as long) as long
declare sub wolfSSL_CTX_free(byval ctx as WOLFSSL_CTX ptr)

declare sub wolfSSL_free(byval ssl as WOLFSSL ptr)
declare function wolfSSL_shutdown(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_send(byval ssl as WOLFSSL ptr, byval data as const any ptr, byval sz as long, byval flags as long) as long
declare function wolfSSL_recv(byval ssl as WOLFSSL ptr, byval data as any ptr, byval sz as long, byval flags as long) as long
declare sub wolfSSL_CTX_set_quiet_shutdown(byval ctx as WOLFSSL_CTX ptr, byval mode as long)
declare sub wolfSSL_set_quiet_shutdown(byval ssl as WOLFSSL ptr, byval mode as long)
declare function wolfSSL_get_error(byval ssl as WOLFSSL ptr, byval ret as long) as long
declare function wolfSSL_get_alert_history(byval ssl as WOLFSSL ptr, byval h as WOLFSSL_ALERT_HISTORY ptr) as long

#ifndef WOLFSSL_SESSION
type WOLFSSL_SESSION as WOLFSSL_SESSION
#endif

declare function wolfSSL_set_session(byval ssl as WOLFSSL ptr, byval session as WOLFSSL_SESSION ptr) as long
declare function wolfSSL_SSL_SESSION_set_timeout(byval ses as WOLFSSL_SESSION ptr, byval t as clong) as clong
declare function wolfSSL_get_session(byval ssl as WOLFSSL ptr) as WOLFSSL_SESSION ptr
declare sub wolfSSL_flush_sessions(byval ctx as WOLFSSL_CTX ptr, byval tm as clong)
declare function wolfSSL_SetServerID(byval ssl as WOLFSSL ptr, byval id as const ubyte ptr, byval len as long, byval newSession as long) as long
type VerifyCallback as function(byval as long, byval as WOLFSSL_X509_STORE_CTX ptr) as long

const WOLF_CRYPTO_EX_INDEX_SSL = 0
const WOLF_CRYPTO_EX_INDEX_SSL_CTX = 1
const WOLF_CRYPTO_EX_INDEX_SSL_SESSION = 2
const WOLF_CRYPTO_EX_INDEX_X509 = 3
const WOLF_CRYPTO_EX_INDEX_X509_STORE = 4
const WOLF_CRYPTO_EX_INDEX_X509_STORE_CTX = 5
const WOLF_CRYPTO_EX_INDEX_DH = 6
const WOLF_CRYPTO_EX_INDEX_DSA = 7
const WOLF_CRYPTO_EX_INDEX_EC_KEY = 8
const WOLF_CRYPTO_EX_INDEX_RSA = 9
const WOLF_CRYPTO_EX_INDEX_ENGINE = 10
const WOLF_CRYPTO_EX_INDEX_UI = 11
const WOLF_CRYPTO_EX_INDEX_BIO = 12
const WOLF_CRYPTO_EX_INDEX_APP = 13
const WOLF_CRYPTO_EX_INDEX_UI_METHOD = 14
const WOLF_CRYPTO_EX_INDEX_DRBG = 15
const WOLF_CRYPTO_EX_INDEX__COUNT = 16

declare sub wolfSSL_CTX_set_verify(byval ctx as WOLFSSL_CTX ptr, byval mode as long, byval verify_callback as VerifyCallback)
declare sub wolfSSL_set_verify(byval ssl as WOLFSSL ptr, byval mode as long, byval verify_callback as VerifyCallback)
declare sub wolfSSL_set_verify_result(byval ssl as WOLFSSL ptr, byval v as clong)
declare sub wolfSSL_SetCertCbCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare sub wolfSSL_CTX_SetCertCbCtx(byval ctx as WOLFSSL_CTX ptr, byval userCtx as any ptr)
declare function wolfSSL_pending(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_has_pending(byval ssl as const WOLFSSL ptr) as long
declare sub wolfSSL_load_error_strings()
declare function wolfSSL_library_init() as long
declare function wolfSSL_CTX_set_session_cache_mode(byval ctx as WOLFSSL_CTX ptr, byval mode as clong) as clong
declare function wolfSSL_save_session_cache(byval fname as const zstring ptr) as long
declare function wolfSSL_restore_session_cache(byval fname as const zstring ptr) as long
declare function wolfSSL_memsave_session_cache(byval mem as any ptr, byval sz as long) as long
declare function wolfSSL_memrestore_session_cache(byval mem as const any ptr, byval sz as long) as long
declare function wolfSSL_get_session_cache_memsize() as long
declare function wolfSSL_CTX_save_cert_cache(byval ctx as WOLFSSL_CTX ptr, byval fname as const zstring ptr) as long
declare function wolfSSL_CTX_restore_cert_cache(byval ctx as WOLFSSL_CTX ptr, byval fname as const zstring ptr) as long
declare function wolfSSL_CTX_memsave_cert_cache(byval ctx as WOLFSSL_CTX ptr, byval mem as any ptr, byval sz as long, byval used as long ptr) as long
declare function wolfSSL_CTX_memrestore_cert_cache(byval ctx as WOLFSSL_CTX ptr, byval mem as const any ptr, byval sz as long) as long
declare function wolfSSL_CTX_get_cert_cache_memsize(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_set_cipher_list(byval ctx as WOLFSSL_CTX ptr, byval list as const zstring ptr) as long
declare function wolfSSL_set_cipher_list(byval ssl as WOLFSSL ptr, byval list as const zstring ptr) as long
declare sub wolfSSL_dtls_set_using_nonblock(byval ssl as WOLFSSL ptr, byval nonblock as long)
declare function wolfSSL_dtls_get_using_nonblock(byval ssl as WOLFSSL ptr) as long
declare sub wolfSSL_set_using_nonblock alias "wolfSSL_dtls_set_using_nonblock"(byval ssl as WOLFSSL ptr, byval nonblock as long)
declare function wolfSSL_get_using_nonblock alias "wolfSSL_dtls_get_using_nonblock"(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls_get_current_timeout(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls13_use_quick_timeout(byval ssl as WOLFSSL ptr) as long
declare sub wolfSSL_dtls13_set_send_more_acks(byval ssl as WOLFSSL ptr, byval value as long)
declare function wolfSSL_DTLSv1_get_timeout(byval ssl as WOLFSSL ptr, byval timeleft as WOLFSSL_TIMEVAL ptr) as long
declare sub wolfSSL_DTLSv1_set_initial_timeout_duration(byval ssl as WOLFSSL ptr, byval duration_ms as word32)
declare function wolfSSL_DTLSv1_handle_timeout(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls_set_timeout_init(byval ssl as WOLFSSL ptr, byval timeout as long) as long
declare function wolfSSL_dtls_set_timeout_max(byval ssl as WOLFSSL ptr, byval timeout as long) as long
declare function wolfSSL_dtls_got_timeout(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls_retransmit(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_dtls_create_peer(byval port as long, byval ip as zstring ptr) as any ptr
declare function wolfSSL_dtls_free_peer(byval addr as any ptr) as long
declare function wolfSSL_dtls_set_peer(byval ssl as WOLFSSL ptr, byval peer as any ptr, byval peerSz as ulong) as long
declare function wolfSSL_dtls_get_peer(byval ssl as WOLFSSL ptr, byval peer as any ptr, byval peerSz as ulong ptr) as long
declare function wolfSSL_CTX_dtls_set_sctp(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_dtls_set_sctp(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_dtls_set_mtu(byval ctx as WOLFSSL_CTX ptr, byval as ushort) as long
declare function wolfSSL_dtls_set_mtu(byval ssl as WOLFSSL ptr, byval as ushort) as long
declare function wolfSSL_dtls_get_drop_stats(byval ssl as WOLFSSL ptr, byval as ulong ptr, byval as ulong ptr) as long
declare function wolfSSL_CTX_mcast_set_member_id(byval ctx as WOLFSSL_CTX ptr, byval id as ushort) as long
declare function wolfSSL_set_secret(byval ssl as WOLFSSL ptr, byval epoch as ushort, byval preMasterSecret as const ubyte ptr, byval preMasterSz as ulong, byval clientRandom as const ubyte ptr, byval serverRandom as const ubyte ptr, byval suite as const ubyte ptr) as long
declare function wolfSSL_mcast_read(byval ssl as WOLFSSL ptr, byval id as ushort ptr, byval data as any ptr, byval sz as long) as long
declare function wolfSSL_mcast_peer_add(byval ssl as WOLFSSL ptr, byval peerId as ushort, byval sub as long) as long
declare function wolfSSL_mcast_peer_known(byval ssl as WOLFSSL ptr, byval peerId as ushort) as long
declare function wolfSSL_mcast_get_max_peers() as long
type CallbackMcastHighwater as function(byval peerId as ushort, byval maxSeq as ulong, byval curSeq as ulong, byval ctx as any ptr) as long
declare function wolfSSL_CTX_mcast_set_highwater_cb(byval ctx as WOLFSSL_CTX ptr, byval maxSeq as ulong, byval first as ulong, byval second as ulong, byval cb as CallbackMcastHighwater) as long
declare function wolfSSL_mcast_set_highwater_ctx(byval ssl as WOLFSSL ptr, byval ctx as any ptr) as long
declare function wolfSSL_ERR_GET_LIB(byval err as culong) as long
declare function wolfSSL_ERR_GET_REASON(byval err as culong) as long
declare function wolfSSL_ERR_error_string(byval errNumber as culong, byval data as zstring ptr) as zstring ptr
declare sub wolfSSL_ERR_error_string_n(byval e as culong, byval buf as zstring ptr, byval sz as culong)
declare function wolfSSL_ERR_reason_error_string(byval e as culong) as const zstring ptr
declare function wolfSSL_ERR_func_error_string(byval e as culong) as const zstring ptr
declare function wolfSSL_ERR_lib_error_string(byval e as culong) as const zstring ptr

#undef WOLFSSL_STACK
type WOLFSSL_STACK as WOLFSSL_STACK

declare function wolfSSL_sk_new_node(byval heap as any ptr) as WOLFSSL_STACK ptr
declare sub wolfSSL_sk_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_sk_free_node(byval in as WOLFSSL_STACK ptr)
declare function wolfSSL_sk_dup(byval sk as WOLFSSL_STACK ptr) as WOLFSSL_STACK ptr
declare function wolfSSL_sk_push_node(byval stack as WOLFSSL_STACK ptr ptr, byval in as WOLFSSL_STACK ptr) as long
declare function wolfSSL_sk_get_node(byval sk as WOLFSSL_STACK ptr, byval idx as long) as WOLFSSL_STACK ptr
declare function wolfSSL_sk_push(byval st as WOLFSSL_STACK ptr, byval data as const any ptr) as long
type WOLFSSL_GENERAL_NAMES as WOLFSSL_STACK
type WOLFSSL_DIST_POINTS as WOLFSSL_STACK
declare function wolfSSL_sk_X509_push(byval sk as WOLFSSL_STACK ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_sk_X509_pop(byval sk as WOLFSSL_STACK ptr) as WOLFSSL_X509 ptr
declare sub wolfSSL_sk_X509_free(byval sk as WOLFSSL_STACK ptr)
declare function wolfSSL_sk_X509_CRL_new() as WOLFSSL_STACK ptr
declare sub wolfSSL_sk_X509_CRL_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_X509_CRL ptr))
declare sub wolfSSL_sk_X509_CRL_free(byval sk as WOLFSSL_STACK ptr)
declare function wolfSSL_sk_X509_CRL_push(byval sk as WOLFSSL_STACK ptr, byval crl as WOLFSSL_X509_CRL ptr) as long
declare function wolfSSL_sk_X509_CRL_value(byval sk as WOLFSSL_STACK ptr, byval i as long) as WOLFSSL_X509_CRL ptr
declare function wolfSSL_sk_X509_CRL_num(byval sk as WOLFSSL_STACK ptr) as long
declare function wolfSSL_GENERAL_NAME_new() as WOLFSSL_GENERAL_NAME ptr
declare sub wolfSSL_GENERAL_NAME_free(byval gn as WOLFSSL_GENERAL_NAME ptr)
declare function wolfSSL_GENERAL_NAME_dup(byval gn as WOLFSSL_GENERAL_NAME ptr) as WOLFSSL_GENERAL_NAME ptr
declare function wolfSSL_GENERAL_NAME_set_type(byval name as WOLFSSL_GENERAL_NAME ptr, byval typ as long) as long
declare function wolfSSL_GENERAL_NAMES_dup(byval gns as WOLFSSL_GENERAL_NAMES ptr) as WOLFSSL_GENERAL_NAMES ptr
declare function wolfSSL_sk_GENERAL_NAME_push(byval sk as WOLFSSL_GENERAL_NAMES ptr, byval gn as WOLFSSL_GENERAL_NAME ptr) as long
declare function wolfSSL_sk_GENERAL_NAME_value(byval sk as WOLFSSL_STACK ptr, byval i as long) as WOLFSSL_GENERAL_NAME ptr
declare function wolfSSL_sk_GENERAL_NAME_num(byval sk as WOLFSSL_STACK ptr) as long
declare sub wolfSSL_sk_GENERAL_NAME_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_GENERAL_NAME ptr))
declare sub wolfSSL_sk_GENERAL_NAME_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_GENERAL_NAMES_free(byval name as WOLFSSL_GENERAL_NAMES ptr)
declare function wolfSSL_GENERAL_NAME_print(byval out as WOLFSSL_BIO ptr, byval name as WOLFSSL_GENERAL_NAME ptr) as long
declare function wolfSSL_DIST_POINT_new() as WOLFSSL_DIST_POINT ptr
declare sub wolfSSL_DIST_POINT_free(byval dp as WOLFSSL_DIST_POINT ptr)
declare function wolfSSL_sk_DIST_POINT_push(byval sk as WOLFSSL_DIST_POINTS ptr, byval dp as WOLFSSL_DIST_POINT ptr) as long
declare function wolfSSL_sk_DIST_POINT_value(byval sk as WOLFSSL_STACK ptr, byval i as long) as WOLFSSL_DIST_POINT ptr
declare function wolfSSL_sk_DIST_POINT_num(byval sk as WOLFSSL_STACK ptr) as long
declare sub wolfSSL_sk_DIST_POINT_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_DIST_POINT ptr))
declare sub wolfSSL_sk_DIST_POINT_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_DIST_POINTS_free(byval dp as WOLFSSL_DIST_POINTS ptr)
declare function wolfSSL_sk_ACCESS_DESCRIPTION_num(byval sk as WOLFSSL_STACK ptr) as long
declare sub wolfSSL_AUTHORITY_INFO_ACCESS_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_AUTHORITY_INFO_ACCESS_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_ACCESS_DESCRIPTION ptr))
declare function wolfSSL_sk_ACCESS_DESCRIPTION_value(byval sk as WOLFSSL_STACK ptr, byval idx as long) as WOLFSSL_ACCESS_DESCRIPTION ptr
declare sub wolfSSL_sk_ACCESS_DESCRIPTION_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_sk_ACCESS_DESCRIPTION_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_ACCESS_DESCRIPTION ptr))
declare sub wolfSSL_ACCESS_DESCRIPTION_free(byval a as WOLFSSL_ACCESS_DESCRIPTION ptr)

#ifndef WOLFSSL_X509_EXTENSION
type WOLFSSL_X509_EXTENSION as WOLFSSL_X509_EXTENSION
#endif

declare sub wolfSSL_sk_X509_EXTENSION_pop_free(byval sk as any ptr, byval f as sub(byval as WOLFSSL_X509_EXTENSION ptr))

declare function wolfSSL_sk_X509_EXTENSION_new_null() as WOLFSSL_STACK ptr
declare function wolfSSL_ASN1_OBJECT_new() as WOLFSSL_ASN1_OBJECT ptr
declare function wolfSSL_ASN1_OBJECT_dup(byval obj as WOLFSSL_ASN1_OBJECT ptr) as WOLFSSL_ASN1_OBJECT ptr
declare sub wolfSSL_ASN1_OBJECT_free(byval obj as WOLFSSL_ASN1_OBJECT ptr)
declare function wolfSSL_sk_new_asn1_obj() as WOLFSSL_STACK ptr
declare function wolfSSL_sk_ASN1_OBJECT_push(byval sk as WOLFSSL_STACK ptr, byval obj as WOLFSSL_ASN1_OBJECT ptr) as long
declare function wolfSSL_sk_ASN1_OBJECT_pop(byval sk as WOLFSSL_STACK ptr) as WOLFSSL_ASN1_OBJECT ptr
declare sub wolfSSL_sk_ASN1_OBJECT_free(byval sk as WOLFSSL_STACK ptr)
declare sub wolfSSL_sk_ASN1_OBJECT_pop_free(byval sk as WOLFSSL_STACK ptr, byval f as sub(byval as WOLFSSL_ASN1_OBJECT ptr))
declare function wolfSSL_ASN1_STRING_to_UTF8(byval out as ubyte ptr ptr, byval in as WOLFSSL_ASN1_STRING ptr) as long
declare function wolfSSL_ASN1_UNIVERSALSTRING_to_string(byval s as WOLFSSL_ASN1_STRING ptr) as long
declare function wolfSSL_sk_X509_EXTENSION_num(byval sk as WOLFSSL_STACK ptr) as long
declare function wolfSSL_sk_X509_EXTENSION_value(byval sk as WOLFSSL_STACK ptr, byval idx as long) as WOLFSSL_X509_EXTENSION ptr
declare function wolfSSL_set_ex_data(byval ssl as WOLFSSL ptr, byval idx as long, byval data as any ptr) as long
declare function wolfSSL_get_shutdown(byval ssl as const WOLFSSL ptr) as long
declare function wolfSSL_set_rfd(byval ssl as WOLFSSL ptr, byval rfd as long) as long
declare function wolfSSL_set_wfd(byval ssl as WOLFSSL ptr, byval wfd as long) as long
declare sub wolfSSL_set_shutdown(byval ssl as WOLFSSL ptr, byval opt as long)
declare function wolfSSL_set_session_id_context(byval ssl as WOLFSSL ptr, byval id as const ubyte ptr, byval len as ulong) as long
declare sub wolfSSL_set_connect_state(byval ssl as WOLFSSL ptr)
declare sub wolfSSL_set_accept_state(byval ssl as WOLFSSL ptr)
declare function wolfSSL_session_reused(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_SESSION_up_ref(byval session as WOLFSSL_SESSION ptr) as long
declare function wolfSSL_SESSION_dup(byval session as WOLFSSL_SESSION ptr) as WOLFSSL_SESSION ptr
declare function wolfSSL_SESSION_new() as WOLFSSL_SESSION ptr
declare function wolfSSL_SESSION_new_ex(byval heap as any ptr) as WOLFSSL_SESSION ptr
declare sub wolfSSL_SESSION_free(byval session as WOLFSSL_SESSION ptr)
declare function wolfSSL_CTX_add_session(byval ctx as WOLFSSL_CTX ptr, byval session as WOLFSSL_SESSION ptr) as long

#ifndef WOLFSSL_CIPHER
type WOLFSSL_CIPHER as WOLFSSL_CIPHER
#endif

declare function wolfSSL_SESSION_set_cipher(byval session as WOLFSSL_SESSION ptr, byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_is_init_finished(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_get_version(byval ssl as const WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_get_current_cipher_suite(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_get_current_cipher(byval ssl as WOLFSSL ptr) as WOLFSSL_CIPHER ptr
declare function wolfSSL_CIPHER_description(byval cipher as const WOLFSSL_CIPHER ptr, byval in as zstring ptr, byval len as long) as zstring ptr
declare function wolfSSL_CIPHER_get_name(byval cipher as const WOLFSSL_CIPHER ptr) as const zstring ptr
declare function wolfSSL_CIPHER_get_version(byval cipher as const WOLFSSL_CIPHER ptr) as const zstring ptr
declare function wolfSSL_CIPHER_get_id(byval cipher as const WOLFSSL_CIPHER ptr) as word32
declare function wolfSSL_CIPHER_get_auth_nid(byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_CIPHER_get_cipher_nid(byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_CIPHER_get_digest_nid(byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_CIPHER_get_kx_nid(byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_CIPHER_is_aead(byval cipher as const WOLFSSL_CIPHER ptr) as long
declare function wolfSSL_get_cipher_by_value(byval value as word16) as const WOLFSSL_CIPHER ptr
declare function wolfSSL_SESSION_CIPHER_get_name(byval session as const WOLFSSL_SESSION ptr) as const zstring ptr
declare function wolfSSL_get_cipher(byval ssl as WOLFSSL ptr) as const zstring ptr
declare sub wolfSSL_sk_CIPHER_free(byval sk as WOLFSSL_STACK ptr)
declare function wolfSSL_get1_session(byval ssl as WOLFSSL ptr) as WOLFSSL_SESSION ptr
declare function wolfSSL_X509_new() as WOLFSSL_X509 ptr
declare function wolfSSL_X509_dup(byval x as WOLFSSL_X509 ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_OCSP_parse_url(byval url as zstring ptr, byval host as zstring ptr ptr, byval port as zstring ptr ptr, byval path as zstring ptr ptr, byval ssl as long ptr) as long
declare function wolfSSL_BIO_new(byval as WOLFSSL_BIO_METHOD ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_free(byval bio as WOLFSSL_BIO ptr) as long
declare sub wolfSSL_BIO_vfree(byval bio as WOLFSSL_BIO ptr)
declare sub wolfSSL_BIO_free_all(byval bio as WOLFSSL_BIO ptr)
declare function wolfSSL_BIO_gets(byval bio as WOLFSSL_BIO ptr, byval buf as zstring ptr, byval sz as long) as long
declare function wolfSSL_BIO_puts(byval bio as WOLFSSL_BIO ptr, byval buf as const zstring ptr) as long
declare function wolfSSL_BIO_next(byval bio as WOLFSSL_BIO ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_find_type(byval bio as WOLFSSL_BIO ptr, byval type as long) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_read(byval bio as WOLFSSL_BIO ptr, byval buf as any ptr, byval len as long) as long
declare function wolfSSL_BIO_write(byval bio as WOLFSSL_BIO ptr, byval data as const any ptr, byval len as long) as long
declare function wolfSSL_BIO_push(byval top as WOLFSSL_BIO ptr, byval append as WOLFSSL_BIO ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_pop(byval bio as WOLFSSL_BIO ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_flush(byval bio as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_pending(byval bio as WOLFSSL_BIO ptr) as long
declare sub wolfSSL_BIO_set_callback(byval bio as WOLFSSL_BIO ptr, byval callback_func as wolf_bio_info_cb)
declare function wolfSSL_BIO_get_callback(byval bio as WOLFSSL_BIO ptr) as wolf_bio_info_cb
declare sub wolfSSL_BIO_set_callback_arg(byval bio as WOLFSSL_BIO ptr, byval arg as zstring ptr)
declare function wolfSSL_BIO_get_callback_arg(byval bio as const WOLFSSL_BIO ptr) as zstring ptr
declare function wolfSSL_BIO_f_md() as WOLFSSL_BIO_METHOD ptr

#ifndef WOLFSSL_EVP_MD_CTX
type WOLFSSL_EVP_MD_CTX as WOLFSSL_EVP_MD_CTX
#endif

declare function wolfSSL_BIO_get_md_ctx(byval bio as WOLFSSL_BIO ptr, byval mdcp as WOLFSSL_EVP_MD_CTX ptr ptr) as long
declare function wolfSSL_BIO_f_buffer() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_set_write_buffer_size(byval bio as WOLFSSL_BIO ptr, byval size as clong) as clong
declare function wolfSSL_BIO_f_ssl() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_new_socket(byval sfd as long, byval flag as long) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_eof(byval b as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_s_mem() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_f_base64() as WOLFSSL_BIO_METHOD ptr
declare sub wolfSSL_BIO_set_flags(byval bio as WOLFSSL_BIO ptr, byval flags as long)
declare sub wolfSSL_BIO_clear_flags(byval bio as WOLFSSL_BIO ptr, byval flags as long)
declare function wolfSSL_BIO_get_fd(byval bio as WOLFSSL_BIO ptr, byval fd as long ptr) as long
declare function wolfSSL_BIO_set_ex_data(byval bio as WOLFSSL_BIO ptr, byval idx as long, byval data as any ptr) as long
declare function wolfSSL_BIO_get_ex_data(byval bio as WOLFSSL_BIO ptr, byval idx as long) as any ptr
declare function wolfSSL_BIO_set_nbio(byval bio as WOLFSSL_BIO ptr, byval on as clong) as clong
declare function wolfSSL_BIO_get_mem_data(byval bio as WOLFSSL_BIO ptr, byval p as any ptr) as long
declare sub wolfSSL_BIO_set_init(byval bio as WOLFSSL_BIO ptr, byval init as long)
declare sub wolfSSL_BIO_set_data(byval bio as WOLFSSL_BIO ptr, byval ptr as any ptr)
declare function wolfSSL_BIO_get_data(byval bio as WOLFSSL_BIO ptr) as any ptr
declare sub wolfSSL_BIO_set_shutdown(byval bio as WOLFSSL_BIO ptr, byval shut as long)
declare function wolfSSL_BIO_get_shutdown(byval bio as WOLFSSL_BIO ptr) as long
declare sub wolfSSL_BIO_clear_retry_flags(byval bio as WOLFSSL_BIO ptr)
declare function wolfSSL_BIO_should_retry(byval bio as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_meth_new(byval type as long, byval name as const zstring ptr) as WOLFSSL_BIO_METHOD ptr
declare sub wolfSSL_BIO_meth_free(byval biom as WOLFSSL_BIO_METHOD ptr)
declare function wolfSSL_BIO_meth_set_write(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_write as wolfSSL_BIO_meth_write_cb) as long
declare function wolfSSL_BIO_meth_set_read(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_read as wolfSSL_BIO_meth_read_cb) as long
declare function wolfSSL_BIO_meth_set_puts(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_puts as wolfSSL_BIO_meth_puts_cb) as long
declare function wolfSSL_BIO_meth_set_gets(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_gets as wolfSSL_BIO_meth_gets_cb) as long
declare function wolfSSL_BIO_meth_set_ctrl(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_ctrl as wolfSSL_BIO_meth_ctrl_get_cb) as long
declare function wolfSSL_BIO_meth_set_create(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_create as wolfSSL_BIO_meth_create_cb) as long
declare function wolfSSL_BIO_meth_set_destroy(byval biom as WOLFSSL_BIO_METHOD ptr, byval biom_destroy as wolfSSL_BIO_meth_destroy_cb) as long
declare function wolfSSL_BIO_new_mem_buf(byval buf as const any ptr, byval len as long) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_set_ssl(byval b as WOLFSSL_BIO ptr, byval ssl as WOLFSSL ptr, byval flag as long) as clong
declare function wolfSSL_BIO_get_ssl(byval bio as WOLFSSL_BIO ptr, byval ssl as WOLFSSL ptr ptr) as clong
declare function wolfSSL_BIO_set_fd(byval b as WOLFSSL_BIO ptr, byval fd as long, byval flag as long) as clong
declare function wolfSSL_BIO_set_close(byval b as WOLFSSL_BIO ptr, byval flag as clong) as long
declare sub wolfSSL_set_bio(byval ssl as WOLFSSL ptr, byval rd as WOLFSSL_BIO ptr, byval wr as WOLFSSL_BIO ptr)
declare function wolfSSL_BIO_method_type(byval b as const WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_s_file() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_new_fd(byval fd as long, byval close_flag as long) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_s_bio() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_s_socket() as WOLFSSL_BIO_METHOD ptr
declare function wolfSSL_BIO_new_connect(byval str as const zstring ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_new_accept(byval port as const zstring ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_set_conn_hostname(byval b as WOLFSSL_BIO ptr, byval name as zstring ptr) as clong
declare function wolfSSL_BIO_set_conn_port(byval b as WOLFSSL_BIO ptr, byval port as zstring ptr) as clong
declare function wolfSSL_BIO_do_connect(byval b as WOLFSSL_BIO ptr) as clong
declare function wolfSSL_BIO_do_accept(byval b as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_new_ssl_connect(byval ctx as WOLFSSL_CTX ptr) as WOLFSSL_BIO ptr
declare function wolfSSL_BIO_do_handshake(byval b as WOLFSSL_BIO ptr) as clong
declare sub wolfSSL_BIO_ssl_shutdown(byval b as WOLFSSL_BIO ptr)
declare function wolfSSL_BIO_ctrl(byval bp as WOLFSSL_BIO ptr, byval cmd as long, byval larg as clong, byval parg as any ptr) as clong
declare function wolfSSL_BIO_int_ctrl(byval bp as WOLFSSL_BIO ptr, byval cmd as long, byval larg as clong, byval iarg as long) as clong
declare function wolfSSL_BIO_set_write_buf_size(byval b as WOLFSSL_BIO ptr, byval size as clong) as long
declare function wolfSSL_BIO_make_bio_pair(byval b1 as WOLFSSL_BIO ptr, byval b2 as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_up_ref(byval b as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_ctrl_reset_read_request(byval b as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_nread0(byval bio as WOLFSSL_BIO ptr, byval buf as zstring ptr ptr) as long
declare function wolfSSL_BIO_nread(byval bio as WOLFSSL_BIO ptr, byval buf as zstring ptr ptr, byval num as long) as long
declare function wolfSSL_BIO_nwrite(byval bio as WOLFSSL_BIO ptr, byval buf as zstring ptr ptr, byval num as long) as long
declare function wolfSSL_BIO_reset(byval bio as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_seek(byval bio as WOLFSSL_BIO ptr, byval ofs as long) as long
declare function wolfSSL_BIO_tell(byval bio as WOLFSSL_BIO ptr) as long
declare function wolfSSL_BIO_write_filename(byval bio as WOLFSSL_BIO ptr, byval name as zstring ptr) as long
declare function wolfSSL_BIO_set_mem_eof_return(byval bio as WOLFSSL_BIO ptr, byval v as long) as clong
declare function wolfSSL_BIO_get_mem_ptr(byval bio as WOLFSSL_BIO ptr, byval m as WOLFSSL_BUF_MEM ptr ptr) as clong
declare function wolfSSL_BIO_get_len(byval bio as WOLFSSL_BIO ptr) as long
declare sub wolfSSL_RAND_screen()
declare function wolfSSL_RAND_file_name(byval fname as zstring ptr, byval len as culong) as const zstring ptr
declare function wolfSSL_RAND_write_file(byval fname as const zstring ptr) as long
declare function wolfSSL_RAND_load_file(byval fname as const zstring ptr, byval len as clong) as long
declare function wolfSSL_RAND_egd(byval nm as const zstring ptr) as long
declare function wolfSSL_RAND_seed(byval seed as const any ptr, byval len as long) as long
declare sub wolfSSL_RAND_Cleanup()
declare sub wolfSSL_RAND_add(byval add as const any ptr, byval len as long, byval entropy as double)
declare function wolfSSL_RAND_poll() as long
declare function wolfSSL_COMP_zlib() as WOLFSSL_COMP_METHOD ptr
declare function wolfSSL_COMP_rle() as WOLFSSL_COMP_METHOD ptr
declare function wolfSSL_COMP_add_compression_method(byval method as long, byval data as any ptr) as long
declare function wolfSSL_thread_id() as culong
declare sub wolfSSL_set_id_callback(byval f as function() as culong)
declare sub wolfSSL_set_locking_callback(byval f as sub(byval as long, byval as long, byval as const zstring ptr, byval as long))

#ifndef WOLFSSL_dynlock_value
type WOLFSSL_dynlock_value as WOLFSSL_dynlock_value
#endif

declare sub wolfSSL_set_dynlock_create_callback(byval f as function(byval as const zstring ptr, byval as long) as WOLFSSL_dynlock_value ptr)
declare sub wolfSSL_set_dynlock_lock_callback(byval f as sub(byval as long, byval as WOLFSSL_dynlock_value ptr, byval as const zstring ptr, byval as long))
declare sub wolfSSL_set_dynlock_destroy_callback(byval f as sub(byval as WOLFSSL_dynlock_value ptr, byval as const zstring ptr, byval as long))
declare function wolfSSL_num_locks() as long
declare function wolfSSL_X509_STORE_CTX_get_current_cert(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_X509_STORE_CTX_get_error(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as long
declare function wolfSSL_X509_STORE_CTX_get_error_depth(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as long
declare sub wolfSSL_X509_STORE_CTX_set_verify_cb(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval verify_cb as WOLFSSL_X509_STORE_CTX_verify_cb)
declare sub wolfSSL_X509_STORE_set_verify_cb(byval st as WOLFSSL_X509_STORE ptr, byval verify_cb as WOLFSSL_X509_STORE_CTX_verify_cb)
declare function wolfSSL_i2d_X509_NAME(byval n as WOLFSSL_X509_NAME ptr, byval out as ubyte ptr ptr) as long
declare function wolfSSL_i2d_X509_NAME_canon(byval name as WOLFSSL_X509_NAME ptr, byval out as ubyte ptr ptr) as long
declare function wolfSSL_d2i_X509_NAME(byval name as WOLFSSL_X509_NAME ptr ptr, byval in as ubyte ptr ptr, byval length as clong) as WOLFSSL_X509_NAME ptr

#ifndef WOLFSSL_RSA
type WOLFSSL_RSA as WOLFSSL_RSA
#endif  

declare function wolfSSL_RSA_print_fp(byval fp as FILE ptr, byval rsa as WOLFSSL_RSA ptr, byval indent as long) as long
declare function wolfSSL_RSA_print(byval bio as WOLFSSL_BIO ptr, byval rsa as WOLFSSL_RSA ptr, byval offset as long) as long
declare function wolfSSL_X509_print_ex(byval bio as WOLFSSL_BIO ptr, byval x509 as WOLFSSL_X509 ptr, byval nmflags as culong, byval cflag as culong) as long
declare function wolfSSL_X509_print_fp(byval fp as FILE ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_signature_print(byval bp as WOLFSSL_BIO ptr, byval sigalg as const WOLFSSL_X509_ALGOR ptr, byval sig as const WOLFSSL_ASN1_STRING ptr) as long

#ifndef WOLFSSL_ASN1_BIT_STRING
type WOLFSSL_ASN1_BIT_STRING as WOLFSSL_ASN1_BIT_STRING
#endif

declare sub wolfSSL_X509_get0_signature(byval psig as const WOLFSSL_ASN1_BIT_STRING ptr ptr, byval palg as const WOLFSSL_X509_ALGOR ptr ptr, byval x509 as const WOLFSSL_X509 ptr)
declare function wolfSSL_X509_print(byval bio as WOLFSSL_BIO ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_REQ_print(byval bio as WOLFSSL_BIO ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_NAME_oneline(byval name as WOLFSSL_X509_NAME ptr, byval in as zstring ptr, byval sz as long) as zstring ptr
declare function wolfSSL_X509_NAME_hash(byval name as WOLFSSL_X509_NAME ptr) as culong
declare function wolfSSL_X509_get_issuer_name(byval cert as WOLFSSL_X509 ptr) as WOLFSSL_X509_NAME ptr
declare function wolfSSL_X509_issuer_name_hash(byval x509 as const WOLFSSL_X509 ptr) as culong
declare function wolfSSL_X509_get_subject_name(byval cert as WOLFSSL_X509 ptr) as WOLFSSL_X509_NAME ptr
declare function wolfSSL_X509_subject_name_hash(byval x509 as const WOLFSSL_X509 ptr) as culong
declare function wolfSSL_X509_ext_isSet_by_NID(byval x509 as WOLFSSL_X509 ptr, byval nid as long) as long
declare function wolfSSL_X509_ext_get_critical_by_NID(byval x509 as WOLFSSL_X509 ptr, byval nid as long) as long
declare function wolfSSL_X509_EXTENSION_set_critical(byval ex as WOLFSSL_X509_EXTENSION ptr, byval crit as long) as long
declare function wolfSSL_X509_get_isCA(byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_get_isSet_pathLength(byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_get_pathLength(byval x509 as WOLFSSL_X509 ptr) as ulong
declare function wolfSSL_X509_get_keyUsage(byval x509 as WOLFSSL_X509 ptr) as ulong
declare function wolfSSL_X509_get_authorityKeyID(byval x509 as WOLFSSL_X509 ptr, byval dst as ubyte ptr, byval dstLen as long ptr) as ubyte ptr
declare function wolfSSL_X509_get_subjectKeyID(byval x509 as WOLFSSL_X509 ptr, byval dst as ubyte ptr, byval dstLen as long ptr) as ubyte ptr
declare function wolfSSL_X509_verify(byval x509 as WOLFSSL_X509 ptr, byval pkey as WOLFSSL_EVP_PKEY ptr) as long
declare function wolfSSL_X509_set_subject_name(byval cert as WOLFSSL_X509 ptr, byval name as WOLFSSL_X509_NAME ptr) as long
declare function wolfSSL_X509_set_issuer_name(byval cert as WOLFSSL_X509 ptr, byval name as WOLFSSL_X509_NAME ptr) as long
declare function wolfSSL_X509_set_pubkey(byval cert as WOLFSSL_X509 ptr, byval pkey as WOLFSSL_EVP_PKEY ptr) as long
declare function wolfSSL_X509_set_notAfter(byval x509 as WOLFSSL_X509 ptr, byval t as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_X509_set_notBefore(byval x509 as WOLFSSL_X509 ptr, byval t as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_X509_get_notBefore(byval x509 as const WOLFSSL_X509 ptr) as WOLFSSL_ASN1_TIME ptr
declare function wolfSSL_X509_get_notAfter(byval x509 as const WOLFSSL_X509 ptr) as WOLFSSL_ASN1_TIME ptr
declare function wolfSSL_X509_set_serialNumber(byval x509 as WOLFSSL_X509 ptr, byval s as WOLFSSL_ASN1_INTEGER ptr) as long
declare function wolfSSL_X509_set_version(byval x509 as WOLFSSL_X509 ptr, byval v as clong) as long
declare function wolfSSL_X509_sign(byval x509 as WOLFSSL_X509 ptr, byval pkey as WOLFSSL_EVP_PKEY ptr, byval md as const WOLFSSL_EVP_MD ptr) as long
declare function wolfSSL_X509_sign_ctx(byval x509 as WOLFSSL_X509 ptr, byval ctx as WOLFSSL_EVP_MD_CTX ptr) as long
declare function wolfSSL_X509_NAME_entry_count(byval name as WOLFSSL_X509_NAME ptr) as long
declare function wolfSSL_X509_NAME_get_sz(byval name as WOLFSSL_X509_NAME ptr) as long
declare function wolfSSL_X509_NAME_get_text_by_NID(byval name as WOLFSSL_X509_NAME ptr, byval nid as long, byval buf as zstring ptr, byval len as long) as long
declare function wolfSSL_X509_NAME_get_index_by_NID(byval name as WOLFSSL_X509_NAME ptr, byval nid as long, byval pos as long) as long

#ifndef WOLFSSL_X509_NAME_ENTRY
type WOLFSSL_X509_NAME_ENTRY as WOLFSSL_X509_NAME_ENTRY
#endif

declare function wolfSSL_X509_NAME_ENTRY_get_data(byval in as WOLFSSL_X509_NAME_ENTRY ptr) as WOLFSSL_ASN1_STRING ptr
declare function wolfSSL_ASN1_STRING_new() as WOLFSSL_ASN1_STRING ptr
declare function wolfSSL_ASN1_STRING_dup(byval asn1 as WOLFSSL_ASN1_STRING ptr) as WOLFSSL_ASN1_STRING ptr
declare function wolfSSL_ASN1_STRING_type_new(byval type as long) as WOLFSSL_ASN1_STRING ptr
declare function wolfSSL_ASN1_STRING_type(byval asn1 as const WOLFSSL_ASN1_STRING ptr) as long
declare function wolfSSL_d2i_DISPLAYTEXT(byval asn as WOLFSSL_ASN1_STRING ptr ptr, byval in as const ubyte ptr ptr, byval len as clong) as WOLFSSL_ASN1_STRING ptr
declare function wolfSSL_ASN1_STRING_cmp(byval a as const WOLFSSL_ASN1_STRING ptr, byval b as const WOLFSSL_ASN1_STRING ptr) as long
declare sub wolfSSL_ASN1_STRING_free(byval asn1 as WOLFSSL_ASN1_STRING ptr)
declare function wolfSSL_ASN1_STRING_set(byval asn1 as WOLFSSL_ASN1_STRING ptr, byval data as const any ptr, byval dataSz as long) as long
declare function wolfSSL_ASN1_STRING_data(byval asn as WOLFSSL_ASN1_STRING ptr) as ubyte ptr
declare function wolfSSL_ASN1_STRING_get0_data(byval asn as const WOLFSSL_ASN1_STRING ptr) as const ubyte ptr
declare function wolfSSL_ASN1_STRING_length(byval asn as WOLFSSL_ASN1_STRING ptr) as long
declare function wolfSSL_ASN1_STRING_copy(byval dst as WOLFSSL_ASN1_STRING ptr, byval src as const WOLFSSL_ASN1_STRING ptr) as long
declare function wolfSSL_X509_verify_cert(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as long
declare function wolfSSL_X509_verify_cert_error_string(byval err as clong) as const zstring ptr
declare function wolfSSL_X509_get_signature_type(byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_get_signature(byval x509 as WOLFSSL_X509 ptr, byval buf as ubyte ptr, byval bufSz as long ptr) as long
declare function wolfSSL_X509_get_pubkey_buffer(byval x509 as WOLFSSL_X509 ptr, byval buf as ubyte ptr, byval bufSz as long ptr) as long
declare function wolfSSL_X509_get_pubkey_type(byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_LOOKUP_add_dir(byval lookup as WOLFSSL_X509_LOOKUP ptr, byval dir as const zstring ptr, byval len as clong) as long
declare function wolfSSL_X509_LOOKUP_load_file(byval lookup as WOLFSSL_X509_LOOKUP ptr, byval file as const zstring ptr, byval type as clong) as long
declare function wolfSSL_X509_LOOKUP_hash_dir() as WOLFSSL_X509_LOOKUP_METHOD ptr
declare function wolfSSL_X509_LOOKUP_file() as WOLFSSL_X509_LOOKUP_METHOD ptr
declare function wolfSSL_X509_LOOKUP_ctrl(byval ctx as WOLFSSL_X509_LOOKUP ptr, byval cmd as long, byval argc as const zstring ptr, byval argl as clong, byval ret as zstring ptr ptr) as long
declare function wolfSSL_X509_STORE_add_lookup(byval store as WOLFSSL_X509_STORE ptr, byval m as WOLFSSL_X509_LOOKUP_METHOD ptr) as WOLFSSL_X509_LOOKUP ptr
declare function wolfSSL_X509_STORE_new() as WOLFSSL_X509_STORE ptr
declare sub wolfSSL_X509_STORE_free(byval store as WOLFSSL_X509_STORE ptr)
declare function wolfSSL_X509_STORE_up_ref(byval store as WOLFSSL_X509_STORE ptr) as long
declare function wolfSSL_X509_STORE_add_cert(byval store as WOLFSSL_X509_STORE ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_X509_STORE_CTX_get_chain(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_STACK ptr
declare function wolfSSL_X509_STORE_CTX_get1_chain(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_STACK ptr
declare function wolfSSL_X509_STORE_CTX_get0_parent_ctx(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_X509_STORE_CTX ptr
declare function wolfSSL_X509_STORE_set_flags(byval store as WOLFSSL_X509_STORE ptr, byval flag as culong) as long
declare function wolfSSL_X509_STORE_set_default_paths(byval store as WOLFSSL_X509_STORE ptr) as long
declare function wolfSSL_X509_STORE_get_by_subject(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval idx as long, byval name as WOLFSSL_X509_NAME ptr, byval obj as WOLFSSL_X509_OBJECT ptr) as long
declare function wolfSSL_X509_STORE_CTX_new() as WOLFSSL_X509_STORE_CTX ptr
declare function wolfSSL_X509_STORE_CTX_init(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval store as WOLFSSL_X509_STORE ptr, byval x509 as WOLFSSL_X509 ptr, byval as WOLFSSL_STACK ptr) as long
declare sub wolfSSL_X509_STORE_CTX_free(byval ctx as WOLFSSL_X509_STORE_CTX ptr)
declare sub wolfSSL_X509_STORE_CTX_cleanup(byval ctx as WOLFSSL_X509_STORE_CTX ptr)
declare sub wolfSSL_X509_STORE_CTX_trusted_stack(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval sk as WOLFSSL_STACK ptr)
declare function wolfSSL_X509_CRL_get_lastUpdate(byval crl as WOLFSSL_X509_CRL ptr) as WOLFSSL_ASN1_TIME ptr
declare function wolfSSL_X509_CRL_get_nextUpdate(byval crl as WOLFSSL_X509_CRL ptr) as WOLFSSL_ASN1_TIME ptr
declare function wolfSSL_X509_get_pubkey(byval x509 as WOLFSSL_X509 ptr) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_X509_CRL_verify(byval crl as WOLFSSL_X509_CRL ptr, byval pkey as WOLFSSL_EVP_PKEY ptr) as long
declare sub wolfSSL_X509_OBJECT_free_contents(byval obj as WOLFSSL_X509_OBJECT ptr)
declare function wolfSSL_d2i_PKCS8_PKEY_bio(byval bio as WOLFSSL_BIO ptr, byval pkey as WOLFSSL_PKCS8_PRIV_KEY_INFO ptr ptr) as WOLFSSL_PKCS8_PRIV_KEY_INFO ptr
declare function wolfSSL_d2i_PKCS8_PKEY(byval pkey as WOLFSSL_PKCS8_PRIV_KEY_INFO ptr ptr, byval keyBuf as const ubyte ptr ptr, byval keyLen as clong) as WOLFSSL_PKCS8_PRIV_KEY_INFO ptr
declare function wolfSSL_d2i_PUBKEY_bio(byval bio as WOLFSSL_BIO ptr, byval out as WOLFSSL_EVP_PKEY ptr ptr) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_d2i_PUBKEY(byval key as WOLFSSL_EVP_PKEY ptr ptr, byval in as const ubyte ptr ptr, byval inSz as clong) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_i2d_PUBKEY(byval key as const WOLFSSL_EVP_PKEY ptr, byval der as ubyte ptr ptr) as long
declare function wolfSSL_d2i_PublicKey(byval type as long, byval pkey as WOLFSSL_EVP_PKEY ptr ptr, byval in as const ubyte ptr ptr, byval inSz as clong) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_d2i_PrivateKey(byval type as long, byval out as WOLFSSL_EVP_PKEY ptr ptr, byval in as const ubyte ptr ptr, byval inSz as clong) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_d2i_PrivateKey_EVP(byval key as WOLFSSL_EVP_PKEY ptr ptr, byval in as ubyte ptr ptr, byval inSz as clong) as WOLFSSL_EVP_PKEY ptr
declare function wolfSSL_i2d_PrivateKey(byval key as const WOLFSSL_EVP_PKEY ptr, byval der as ubyte ptr ptr) as long
declare function wolfSSL_i2d_PublicKey(byval key as const WOLFSSL_EVP_PKEY ptr, byval der as ubyte ptr ptr) as long
declare function wolfSSL_X509_cmp_current_time(byval asnTime as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_X509_CRL_get_REVOKED(byval crl as WOLFSSL_X509_CRL ptr) as WOLFSSL_X509_REVOKED ptr
declare function wolfSSL_sk_X509_REVOKED_value(byval revoked as WOLFSSL_X509_REVOKED ptr, byval value as long) as WOLFSSL_X509_REVOKED ptr
declare function wolfSSL_X509_get_serialNumber(byval x509 as WOLFSSL_X509 ptr) as WOLFSSL_ASN1_INTEGER ptr
declare sub wolfSSL_ASN1_INTEGER_free(byval in as WOLFSSL_ASN1_INTEGER ptr)
declare function wolfSSL_ASN1_INTEGER_new() as WOLFSSL_ASN1_INTEGER ptr
declare function wolfSSL_ASN1_INTEGER_dup(byval src as const WOLFSSL_ASN1_INTEGER ptr) as WOLFSSL_ASN1_INTEGER ptr
declare function wolfSSL_ASN1_INTEGER_set(byval a as WOLFSSL_ASN1_INTEGER ptr, byval v as clong) as long
declare function wolfSSL_d2i_ASN1_INTEGER(byval a as WOLFSSL_ASN1_INTEGER ptr ptr, byval in as const ubyte ptr ptr, byval inSz as clong) as WOLFSSL_ASN1_INTEGER ptr
declare function wolfSSL_i2d_ASN1_INTEGER(byval a as WOLFSSL_ASN1_INTEGER ptr, byval out as ubyte ptr ptr) as long
declare function wolfSSL_ASN1_TIME_print(byval bio as WOLFSSL_BIO ptr, byval asnTime as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_ASN1_TIME_to_string(byval t as WOLFSSL_ASN1_TIME ptr, byval buf as zstring ptr, byval len as long) as zstring ptr
declare function wolfSSL_ASN1_TIME_to_tm(byval asnTime as const WOLFSSL_ASN1_TIME ptr, byval tm as tm ptr) as long
declare function wolfSSL_ASN1_INTEGER_cmp(byval a as const WOLFSSL_ASN1_INTEGER ptr, byval b as const WOLFSSL_ASN1_INTEGER ptr) as long
declare function wolfSSL_ASN1_INTEGER_get(byval a as const WOLFSSL_ASN1_INTEGER ptr) as clong
declare function wolfSSL_load_client_CA_file(byval fname as const zstring ptr) as WOLFSSL_STACK ptr
declare function wolfSSL_CTX_get_client_CA_list(byval ctx as const WOLFSSL_CTX ptr) as WOLFSSL_STACK ptr
declare function wolfSSL_SSL_CTX_get_client_CA_list alias "wolfSSL_CTX_get_client_CA_list"(byval ctx as const WOLFSSL_CTX ptr) as WOLFSSL_STACK ptr
declare sub wolfSSL_CTX_set_client_CA_list(byval ctx as WOLFSSL_CTX ptr, byval as WOLFSSL_STACK ptr)
declare sub wolfSSL_set_client_CA_list(byval ssl as WOLFSSL ptr, byval as WOLFSSL_STACK ptr)
declare function wolfSSL_get_client_CA_list(byval ssl as const WOLFSSL ptr) as WOLFSSL_STACK ptr
type client_cert_cb as function(byval ssl as WOLFSSL ptr, byval x509 as WOLFSSL_X509 ptr ptr, byval pkey as WOLFSSL_EVP_PKEY ptr ptr) as long
declare sub wolfSSL_CTX_set_client_cert_cb(byval ctx as WOLFSSL_CTX ptr, byval cb as client_cert_cb)
type CertSetupCallback as function(byval ssl as WOLFSSL ptr, byval as any ptr) as long
declare sub wolfSSL_CTX_set_cert_cb(byval ctx as WOLFSSL_CTX ptr, byval cb as CertSetupCallback, byval arg as any ptr)
declare function CertSetupCbWrapper(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_X509_STORE_CTX_get_ex_data(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval idx as long) as any ptr
declare function wolfSSL_X509_STORE_CTX_set_ex_data(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval idx as long, byval data as any ptr) as long
declare function wolfSSL_X509_STORE_get_ex_data(byval store as WOLFSSL_X509_STORE ptr, byval idx as long) as any ptr
declare function wolfSSL_X509_STORE_set_ex_data(byval store as WOLFSSL_X509_STORE ptr, byval idx as long, byval data as any ptr) as long
declare sub wolfSSL_X509_STORE_CTX_set_depth(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval depth as long)
declare function wolfSSL_X509_STORE_CTX_get0_current_issuer(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_X509_STORE_CTX_get0_store(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_X509_STORE ptr
declare function wolfSSL_X509_STORE_CTX_get0_cert(byval ctx as WOLFSSL_X509_STORE_CTX ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_get_ex_data_X509_STORE_CTX_idx() as long
declare sub wolfSSL_X509_STORE_CTX_set_error(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval er as long)
declare sub wolfSSL_X509_STORE_CTX_set_error_depth(byval ctx as WOLFSSL_X509_STORE_CTX ptr, byval depth as long)
declare function wolfSSL_get_ex_data(byval ssl as const WOLFSSL ptr, byval idx as long) as any ptr
declare sub wolfSSL_CTX_set_default_passwd_cb_userdata(byval ctx as WOLFSSL_CTX ptr, byval userdata as any ptr)
declare sub wolfSSL_CTX_set_default_passwd_cb(byval ctx as WOLFSSL_CTX ptr, byval cb as function(byval passwd as zstring ptr, byval sz as long, byval rw as long, byval userdata as any ptr) as long)
declare function wolfSSL_CTX_get_default_passwd_cb(byval ctx as WOLFSSL_CTX ptr) as function(byval passwd as zstring ptr, byval sz as long, byval rw as long, byval userdata as any ptr) as long
declare function wolfSSL_CTX_get_default_passwd_cb_userdata(byval ctx as WOLFSSL_CTX ptr) as any ptr
declare sub wolfSSL_CTX_set_info_callback(byval ctx as WOLFSSL_CTX ptr, byval f as sub(byval ssl as const WOLFSSL ptr, byval type as long, byval val as long))
declare function wolfSSL_ERR_peek_error() as culong
declare function wolfSSL_GET_REASON(byval as long) as long
declare function wolfSSL_alert_type_string_long(byval alertID as long) as const zstring ptr
declare function wolfSSL_alert_desc_string_long(byval alertID as long) as const zstring ptr
declare function wolfSSL_state_string_long(byval ssl as const WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_RSA_generate_key(byval len as long, byval e as culong, byval f as sub(byval as long, byval as long, byval as any ptr), byval data as any ptr) as WOLFSSL_RSA ptr
declare function wolfSSL_d2i_RSAPublicKey(byval r as WOLFSSL_RSA ptr ptr, byval pp as const ubyte ptr ptr, byval len as clong) as WOLFSSL_RSA ptr
declare function wolfSSL_d2i_RSAPrivateKey(byval r as WOLFSSL_RSA ptr ptr, byval derBuf as const ubyte ptr ptr, byval derSz as clong) as WOLFSSL_RSA ptr
declare function wolfSSL_i2d_RSAPublicKey(byval r as WOLFSSL_RSA ptr, byval pp as ubyte ptr ptr) as long
declare function wolfSSL_i2d_RSAPrivateKey(byval r as WOLFSSL_RSA ptr, byval pp as ubyte ptr ptr) as long
declare sub wolfSSL_CTX_set_tmp_rsa_callback(byval ctx as WOLFSSL_CTX ptr, byval f as function(byval as WOLFSSL ptr, byval as long, byval as long) as WOLFSSL_RSA ptr)
declare function wolfSSL_PEM_def_callback(byval name as zstring ptr, byval num as long, byval w as long, byval key as any ptr) as long
declare function wolfSSL_CTX_sess_accept(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_connect(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_accept_good(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_connect_good(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_accept_renegotiate(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_connect_renegotiate(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_hits(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_cb_hits(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_cache_full(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_misses(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_timeouts(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_sess_number(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_add_extra_chain_cert(byval ctx as WOLFSSL_CTX ptr, byval x509 as WOLFSSL_X509 ptr) as clong
declare function wolfSSL_CTX_sess_set_cache_size(byval ctx as WOLFSSL_CTX ptr, byval sz as clong) as clong
declare function wolfSSL_CTX_sess_get_cache_size(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_get_session_cache_mode(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_get_read_ahead(byval ssl as const WOLFSSL ptr) as long
declare function wolfSSL_set_read_ahead(byval ssl as WOLFSSL ptr, byval v as long) as long
declare function wolfSSL_CTX_get_read_ahead(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_set_read_ahead(byval ctx as WOLFSSL_CTX ptr, byval v as long) as long
declare function wolfSSL_CTX_set_tlsext_status_arg(byval ctx as WOLFSSL_CTX ptr, byval arg as any ptr) as clong
declare function wolfSSL_CTX_set_tlsext_opaque_prf_input_callback_arg(byval ctx as WOLFSSL_CTX ptr, byval arg as any ptr) as clong
declare function wolfSSL_CTX_add_client_CA(byval ctx as WOLFSSL_CTX ptr, byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_CTX_set_srp_password(byval ctx as WOLFSSL_CTX ptr, byval password as zstring ptr) as long
declare function wolfSSL_CTX_set_srp_username(byval ctx as WOLFSSL_CTX ptr, byval username as zstring ptr) as long
declare function wolfSSL_CTX_set_srp_strength(byval ctx as WOLFSSL_CTX ptr, byval strength as long) as long
declare function wolfSSL_get_srp_username(byval ssl as WOLFSSL ptr) as zstring ptr
declare function wolfSSL_set_options(byval s as WOLFSSL ptr, byval op as clong) as clong
declare function wolfSSL_get_options(byval s as const WOLFSSL ptr) as clong
declare function wolfSSL_clear_options(byval s as WOLFSSL ptr, byval op as clong) as clong
declare function wolfSSL_clear_num_renegotiations(byval s as WOLFSSL ptr) as clong
declare function wolfSSL_total_renegotiations(byval s as WOLFSSL ptr) as clong
declare function wolfSSL_num_renegotiations(byval s as WOLFSSL ptr) as clong
declare function wolfSSL_SSL_renegotiate_pending(byval s as WOLFSSL ptr) as long

#ifndef WOLFSSL_DH
type WOLFSSL_DH as WOLFSSL_DH
#endif

declare function wolfSSL_set_tmp_dh(byval s as WOLFSSL ptr, byval dh as WOLFSSL_DH ptr) as clong
declare function wolfSSL_set_tlsext_debug_arg(byval s as WOLFSSL ptr, byval arg as any ptr) as clong
declare function wolfSSL_set_tlsext_status_type(byval s as WOLFSSL ptr, byval type as long) as clong
declare function wolfSSL_get_tlsext_status_type(byval s as WOLFSSL ptr) as clong
declare function wolfSSL_set_tlsext_status_exts(byval s as WOLFSSL ptr, byval arg as any ptr) as clong
declare function wolfSSL_get_tlsext_status_ids(byval s as WOLFSSL ptr, byval arg as any ptr) as clong
declare function wolfSSL_set_tlsext_status_ids(byval s as WOLFSSL ptr, byval arg as any ptr) as clong
declare function wolfSSL_get_tlsext_status_ocsp_resp(byval s as WOLFSSL ptr, byval resp as ubyte ptr ptr) as clong
declare function wolfSSL_set_tlsext_status_ocsp_resp(byval s as WOLFSSL ptr, byval resp as ubyte ptr, byval len as long) as clong
declare function wolfSSL_set_tlsext_max_fragment_length(byval s as WOLFSSL ptr, byval mode as ubyte) as long
declare function wolfSSL_CTX_set_tlsext_max_fragment_length(byval c as WOLFSSL_CTX ptr, byval mode as ubyte) as long
declare sub wolfSSL_CONF_modules_unload(byval all as long)
declare function wolfSSL_CONF_get1_default_config_file() as zstring ptr
declare function wolfSSL_get_tlsext_status_exts(byval s as WOLFSSL ptr, byval arg as any ptr) as clong
declare function wolfSSL_get_verify_result(byval ssl as const WOLFSSL ptr) as clong
#define WOLFSSL_DEFAULT_CIPHER_LIST ""

enum
	WOLFSSL_OCSP_URL_OVERRIDE = 1
	WOLFSSL_OCSP_NO_NONCE = 2
	WOLFSSL_OCSP_CHECKALL = 4
	WOLFSSL_CRL_CHECKALL = 1
	WOLFSSL_CRL_CHECK = 2
end enum

enum
	WOLFSSL_OP_MICROSOFT_SESS_ID_BUG = &h00000001
	WOLFSSL_OP_NETSCAPE_CHALLENGE_BUG = &h00000002
	WOLFSSL_OP_NETSCAPE_REUSE_CIPHER_CHANGE_BUG = &h00000004
	WOLFSSL_OP_SSLREF2_REUSE_CERT_TYPE_BUG = &h00000008
	WOLFSSL_OP_MICROSOFT_BIG_SSLV3_BUFFER = &h00000010
	WOLFSSL_OP_MSIE_SSLV2_RSA_PADDING = &h00000020
	WOLFSSL_OP_SSLEAY_080_CLIENT_DH_BUG = &h00000040
	WOLFSSL_OP_TLS_D5_BUG = &h00000080
	WOLFSSL_OP_TLS_BLOCK_PADDING_BUG = &h00000100
	WOLFSSL_OP_TLS_ROLLBACK_BUG = &h00000200
	WOLFSSL_OP_EPHEMERAL_RSA = &h00000800
	WOLFSSL_OP_NO_SSLv3 = &h00001000
	WOLFSSL_OP_NO_TLSv1 = &h00002000
	WOLFSSL_OP_PKCS1_CHECK_1 = &h00004000
	WOLFSSL_OP_PKCS1_CHECK_2 = &h00008000
	WOLFSSL_OP_NETSCAPE_CA_DN_BUG = &h00010000
	WOLFSSL_OP_NETSCAPE_DEMO_CIPHER_CHANGE_BUG = &h00020000
	WOLFSSL_OP_SINGLE_DH_USE = &h00040000
	WOLFSSL_OP_NO_TICKET = &h00080000
	WOLFSSL_OP_DONT_INSERT_EMPTY_FRAGMENTS = &h00100000
	WOLFSSL_OP_NO_QUERY_MTU = &h00200000
	WOLFSSL_OP_COOKIE_EXCHANGE = &h00400000
	WOLFSSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION = &h00800000
	WOLFSSL_OP_SINGLE_ECDH_USE = &h01000000
	WOLFSSL_OP_CIPHER_SERVER_PREFERENCE = &h02000000
	WOLFSSL_OP_NO_TLSv1_1 = &h04000000
	WOLFSSL_OP_NO_TLSv1_2 = &h08000000
	WOLFSSL_OP_NO_COMPRESSION = &h10000000
	WOLFSSL_OP_NO_TLSv1_3 = &h20000000
	WOLFSSL_OP_NO_SSLv2 = &h40000000
	WOLFSSL_OP_ALL = (((((((((WOLFSSL_OP_MICROSOFT_SESS_ID_BUG or WOLFSSL_OP_NETSCAPE_CHALLENGE_BUG) or WOLFSSL_OP_NETSCAPE_REUSE_CIPHER_CHANGE_BUG) or WOLFSSL_OP_SSLREF2_REUSE_CERT_TYPE_BUG) or WOLFSSL_OP_MICROSOFT_BIG_SSLV3_BUFFER) or WOLFSSL_OP_MSIE_SSLV2_RSA_PADDING) or WOLFSSL_OP_SSLEAY_080_CLIENT_DH_BUG) or WOLFSSL_OP_TLS_D5_BUG) or WOLFSSL_OP_TLS_BLOCK_PADDING_BUG) or WOLFSSL_OP_DONT_INSERT_EMPTY_FRAGMENTS) or WOLFSSL_OP_TLS_ROLLBACK_BUG
end enum

declare sub wolfSSL_ERR_print_errors_fp(byval fp as FILE ptr, byval err as long)
declare sub wolfSSL_ERR_print_errors(byval bio as WOLFSSL_BIO ptr)

enum
	WOLFSSL_ERROR_NONE = 0
	WOLFSSL_FAILURE = 0
	WOLFSSL_SUCCESS = 1
	WOLFSSL_SHUTDOWN_NOT_DONE = 2
	WOLFSSL_ALPN_NOT_FOUND = -9
	WOLFSSL_BAD_CERTTYPE = -8
	WOLFSSL_BAD_STAT = -7
	WOLFSSL_BAD_PATH = -6
	WOLFSSL_BAD_FILETYPE = -5
	WOLFSSL_BAD_FILE = -4
	WOLFSSL_NOT_IMPLEMENTED = -3
	WOLFSSL_UNKNOWN = -2
	WOLFSSL_FATAL_ERROR = -1
	WOLFSSL_FILETYPE_ASN1 = CTC_FILETYPE_ASN1
	WOLFSSL_FILETYPE_PEM = CTC_FILETYPE_PEM
	WOLFSSL_FILETYPE_DEFAULT = CTC_FILETYPE_ASN1
	WOLFSSL_VERIFY_NONE = 0
	WOLFSSL_VERIFY_PEER = 1 shl 0
	WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT = 1 shl 1
	WOLFSSL_VERIFY_CLIENT_ONCE = 1 shl 2
	WOLFSSL_VERIFY_POST_HANDSHAKE = 1 shl 3
	WOLFSSL_VERIFY_FAIL_EXCEPT_PSK = 1 shl 4
	WOLFSSL_VERIFY_DEFAULT = 1 shl 9
	WOLFSSL_SESS_CACHE_OFF = &h0000
	WOLFSSL_SESS_CACHE_CLIENT = &h0001
	WOLFSSL_SESS_CACHE_SERVER = &h0002
	WOLFSSL_SESS_CACHE_BOTH = &h0003
	WOLFSSL_SESS_CACHE_NO_AUTO_CLEAR = &h0008
	WOLFSSL_SESS_CACHE_NO_INTERNAL_LOOKUP = &h0100
	WOLFSSL_SESS_CACHE_NO_INTERNAL_STORE = &h0200
	WOLFSSL_SESS_CACHE_NO_INTERNAL = &h0300
	WOLFSSL_ERROR_WANT_READ = 2
	WOLFSSL_ERROR_WANT_WRITE = 3
	WOLFSSL_ERROR_WANT_CONNECT = 7
	WOLFSSL_ERROR_WANT_ACCEPT = 8
	WOLFSSL_ERROR_SYSCALL = 5
	WOLFSSL_ERROR_WANT_X509_LOOKUP = 83
	WOLFSSL_ERROR_ZERO_RETURN = 6
	WOLFSSL_ERROR_SSL = 85
	WOLFSSL_SENT_SHUTDOWN = 1
	WOLFSSL_RECEIVED_SHUTDOWN = 2
	WOLFSSL_MODE_ACCEPT_MOVING_WRITE_BUFFER = 4
	WOLFSSL_R_SSL_HANDSHAKE_FAILURE = 101
	WOLFSSL_R_TLSV1_ALERT_UNKNOWN_CA = 102
	WOLFSSL_R_SSLV3_ALERT_CERTIFICATE_UNKNOWN = 103
	WOLFSSL_R_SSLV3_ALERT_BAD_CERTIFICATE = 104
	WOLF_PEM_BUFSIZE = 1024
end enum

const PEM_BUFSIZE = WOLF_PEM_BUFSIZE
const SSL_R_SSLV3_ALERT_BAD_CERTIFICATE = WOLFSSL_R_SSLV3_ALERT_BAD_CERTIFICATE
const SSL_R_SSLV3_ALERT_CERTIFICATE_UNKNOWN = WOLFSSL_R_SSLV3_ALERT_CERTIFICATE_UNKNOWN
const SSL_R_TLSV1_ALERT_UNKNOWN_CA = WOLFSSL_R_TLSV1_ALERT_UNKNOWN_CA
const SSL_R_SSL_HANDSHAKE_FAILURE = WOLFSSL_R_SSL_HANDSHAKE_FAILURE
const SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER = WOLFSSL_MODE_ACCEPT_MOVING_WRITE_BUFFER
const SSL_RECEIVED_SHUTDOWN = WOLFSSL_RECEIVED_SHUTDOWN
const SSL_SENT_SHUTDOWN = WOLFSSL_SENT_SHUTDOWN
const SSL_ERROR_SSL = WOLFSSL_ERROR_SSL
const SSL_ERROR_ZERO_RETURN = WOLFSSL_ERROR_ZERO_RETURN
const SSL_ERROR_WANT_X509_LOOKUP = WOLFSSL_ERROR_WANT_X509_LOOKUP
const SSL_ERROR_SYSCALL = WOLFSSL_ERROR_SYSCALL
const SSL_ERROR_WANT_ACCEPT = WOLFSSL_ERROR_WANT_ACCEPT
const SSL_ERROR_WANT_CONNECT = WOLFSSL_ERROR_WANT_CONNECT
const SSL_ERROR_WANT_WRITE = WOLFSSL_ERROR_WANT_WRITE
const SSL_ERROR_WANT_READ = WOLFSSL_ERROR_WANT_READ
const SSL_SESS_CACHE_NO_INTERNAL = WOLFSSL_SESS_CACHE_NO_INTERNAL
const SSL_SESS_CACHE_NO_INTERNAL_STORE = WOLFSSL_SESS_CACHE_NO_INTERNAL_STORE
const SSL_SESS_CACHE_NO_INTERNAL_LOOKUP = WOLFSSL_SESS_CACHE_NO_INTERNAL_LOOKUP
const SSL_SESS_CACHE_NO_AUTO_CLEAR = WOLFSSL_SESS_CACHE_NO_AUTO_CLEAR
const SSL_SESS_CACHE_BOTH = WOLFSSL_SESS_CACHE_BOTH
const SSL_SESS_CACHE_SERVER = WOLFSSL_SESS_CACHE_SERVER
const SSL_SESS_CACHE_CLIENT = WOLFSSL_SESS_CACHE_CLIENT
const SSL_SESS_CACHE_OFF = WOLFSSL_SESS_CACHE_OFF
const SSL_VERIFY_FAIL_EXCEPT_PSK = WOLFSSL_VERIFY_FAIL_EXCEPT_PSK
const SSL_VERIFY_POST_HANDSHAKE = WOLFSSL_VERIFY_POST_HANDSHAKE
const SSL_VERIFY_CLIENT_ONCE = WOLFSSL_VERIFY_CLIENT_ONCE
const SSL_VERIFY_FAIL_IF_NO_PEER_CERT = WOLFSSL_VERIFY_FAIL_IF_NO_PEER_CERT
const SSL_VERIFY_PEER = WOLFSSL_VERIFY_PEER
const SSL_VERIFY_NONE = WOLFSSL_VERIFY_NONE
const SSL_FILETYPE_DEFAULT = WOLFSSL_FILETYPE_DEFAULT
const SSL_FILETYPE_PEM = WOLFSSL_FILETYPE_PEM
const SSL_FILETYPE_ASN1 = WOLFSSL_FILETYPE_ASN1
const SSL_FATAL_ERROR = WOLFSSL_FATAL_ERROR
const SSL_UNKNOWN = WOLFSSL_UNKNOWN
const SSL_NOT_IMPLEMENTED = WOLFSSL_NOT_IMPLEMENTED
const SSL_BAD_FILE = WOLFSSL_BAD_FILE
const SSL_BAD_FILETYPE = WOLFSSL_BAD_FILETYPE
const SSL_BAD_PATH = WOLFSSL_BAD_PATH
const SSL_BAD_STAT = WOLFSSL_BAD_STAT
const SSL_BAD_CERTTYPE = WOLFSSL_BAD_CERTTYPE
const SSL_ALPN_NOT_FOUND = WOLFSSL_ALPN_NOT_FOUND
const SSL_SHUTDOWN_NOT_DONE = WOLFSSL_SHUTDOWN_NOT_DONE
const SSL_SUCCESS = WOLFSSL_SUCCESS
const SSL_FAILURE = WOLFSSL_FAILURE
const SSL_ERROR_NONE = WOLFSSL_ERROR_NONE
type wc_psk_client_callback as function(byval ssl as WOLFSSL ptr, byval as const zstring ptr, byval as zstring ptr, byval as ulong, byval as ubyte ptr, byval as ulong) as ulong

declare sub wolfSSL_CTX_set_psk_client_callback(byval ctx as WOLFSSL_CTX ptr, byval cb as wc_psk_client_callback)
declare sub wolfSSL_set_psk_client_callback(byval ssl as WOLFSSL ptr, byval cb as wc_psk_client_callback)
declare function wolfSSL_get_psk_identity_hint(byval ssl as const WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_get_psk_identity(byval ssl as const WOLFSSL ptr) as const zstring ptr
declare function wolfSSL_CTX_use_psk_identity_hint(byval ctx as WOLFSSL_CTX ptr, byval hint as const zstring ptr) as long
declare function wolfSSL_use_psk_identity_hint(byval ssl as WOLFSSL ptr, byval hint as const zstring ptr) as long
type wc_psk_server_callback as function(byval ssl as WOLFSSL ptr, byval as const zstring ptr, byval as ubyte ptr, byval as ulong) as ulong
declare sub wolfSSL_CTX_set_psk_server_callback(byval ctx as WOLFSSL_CTX ptr, byval cb as wc_psk_server_callback)
declare sub wolfSSL_set_psk_server_callback(byval ssl as WOLFSSL ptr, byval cb as wc_psk_server_callback)
declare function wolfSSL_get_psk_callback_ctx(byval ssl as WOLFSSL ptr) as any ptr
declare function wolfSSL_set_psk_callback_ctx(byval ssl as WOLFSSL ptr, byval psk_ctx as any ptr) as long
declare function wolfSSL_CTX_get_psk_callback_ctx(byval ctx as WOLFSSL_CTX ptr) as any ptr
declare function wolfSSL_CTX_set_psk_callback_ctx(byval ctx as WOLFSSL_CTX ptr, byval psk_ctx as any ptr) as long
#define PSK_TYPES_DEFINED
declare sub wolfSSL_ERR_put_error(byval lib as long, byval fun as long, byval err as long, byval file as const zstring ptr, byval line as long)
declare function wolfSSL_ERR_get_error_line(byval file as const zstring ptr ptr, byval line as long ptr) as culong
declare function wolfSSL_ERR_get_error_line_data(byval file as const zstring ptr ptr, byval line as long ptr, byval data as const zstring ptr ptr, byval flags as long ptr) as culong
declare function wolfSSL_ERR_get_error() as culong
declare sub wolfSSL_ERR_clear_error()
declare function wolfSSL_RAND_status() as long
declare function wolfSSL_RAND_pseudo_bytes(byval buf as ubyte ptr, byval num as long) as long
declare function wolfSSL_RAND_bytes(byval buf as ubyte ptr, byval num as long) as long
declare function wolfSSL_CTX_set_options(byval ctx as WOLFSSL_CTX ptr, byval opt as clong) as clong
declare function wolfSSL_CTX_get_options(byval ctx as WOLFSSL_CTX ptr) as clong
declare function wolfSSL_CTX_clear_options(byval ctx as WOLFSSL_CTX ptr, byval opt as clong) as clong
declare function wolfSSL_CTX_check_private_key(byval ctx as const WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_get0_privatekey(byval ctx as const WOLFSSL_CTX ptr) as WOLFSSL_EVP_PKEY ptr
declare sub wolfSSL_ERR_free_strings()
declare sub wolfSSL_ERR_remove_state(byval id as culong)
declare function wolfSSL_clear(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_state(byval ssl as WOLFSSL ptr) as long
declare sub wolfSSL_cleanup_all_ex_data()
declare function wolfSSL_CTX_set_mode(byval ctx as WOLFSSL_CTX ptr, byval mode as clong) as clong
declare function wolfSSL_CTX_clear_mode(byval ctx as WOLFSSL_CTX ptr, byval mode as clong) as clong
declare function wolfSSL_CTX_get_mode(byval ctx as WOLFSSL_CTX ptr) as clong
declare sub wolfSSL_CTX_set_default_read_ahead(byval ctx as WOLFSSL_CTX ptr, byval m as long)
declare function wolfSSL_SSL_get_mode(byval ssl as WOLFSSL ptr) as clong
declare function wolfSSL_CTX_set_default_verify_paths(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_X509_get_default_cert_file_env() as const zstring ptr
declare function wolfSSL_X509_get_default_cert_file() as const zstring ptr
declare function wolfSSL_X509_get_default_cert_dir_env() as const zstring ptr
declare function wolfSSL_X509_get_default_cert_dir() as const zstring ptr
declare function wolfSSL_CTX_set_session_id_context(byval ctx as WOLFSSL_CTX ptr, byval sid_ctx as const ubyte ptr, byval sid_ctx_len as ulong) as long
declare function wolfSSL_get_peer_certificate(byval ssl as WOLFSSL ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_want_read(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_want_write(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_BIO_vprintf(byval bio as WOLFSSL_BIO ptr, byval format as const zstring ptr, byval args as va_list) as long
declare function wolfSSL_BIO_printf(byval bio as WOLFSSL_BIO ptr, byval format as const zstring ptr, ...) as long
declare function wolfSSL_BIO_dump(byval bio as WOLFSSL_BIO ptr, byval buf as const zstring ptr, byval length as long) as long
declare function wolfSSL_ASN1_UTCTIME_print(byval bio as WOLFSSL_BIO ptr, byval a as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_ASN1_GENERALIZEDTIME_print(byval bio as WOLFSSL_BIO ptr, byval asnTime as const WOLFSSL_ASN1_TIME ptr) as long
declare sub wolfSSL_ASN1_GENERALIZEDTIME_free(byval as WOLFSSL_ASN1_TIME ptr)
declare function wolfSSL_ASN1_TIME_check(byval a as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_ASN1_TIME_diff(byval days as long ptr, byval secs as long ptr, byval from as const WOLFSSL_ASN1_TIME ptr, byval to as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_ASN1_TIME_compare(byval a as const WOLFSSL_ASN1_TIME ptr, byval b as const WOLFSSL_ASN1_TIME ptr) as long
declare function wolfSSL_sk_num(byval sk as const WOLFSSL_STACK ptr) as long
declare function wolfSSL_sk_value(byval sk as const WOLFSSL_STACK ptr, byval i as long) as any ptr
declare function wolfSSL_CTX_get_ex_data(byval ctx as const WOLFSSL_CTX ptr, byval idx as long) as any ptr
declare function wolfSSL_CTX_set_ex_data(byval ctx as WOLFSSL_CTX ptr, byval idx as long, byval data as any ptr) as long
declare sub wolfSSL_CTX_sess_set_get_cb(byval ctx as WOLFSSL_CTX ptr, byval f as function(byval ssl as WOLFSSL ptr, byval as const ubyte ptr, byval as long, byval as long ptr) as WOLFSSL_SESSION ptr)
declare sub wolfSSL_CTX_sess_set_new_cb(byval ctx as WOLFSSL_CTX ptr, byval f as function(byval ssl as WOLFSSL ptr, byval as WOLFSSL_SESSION ptr) as long)
declare sub wolfSSL_CTX_sess_set_remove_cb(byval ctx as WOLFSSL_CTX ptr, byval f as sub(byval ctx as WOLFSSL_CTX ptr, byval as WOLFSSL_SESSION ptr))
declare function wolfSSL_i2d_SSL_SESSION(byval sess as WOLFSSL_SESSION ptr, byval p as ubyte ptr ptr) as long
declare function wolfSSL_d2i_SSL_SESSION(byval sess as WOLFSSL_SESSION ptr ptr, byval p as const ubyte ptr ptr, byval i as clong) as WOLFSSL_SESSION ptr
declare function wolfSSL_SESSION_has_ticket(byval session as const WOLFSSL_SESSION ptr) as long
declare function wolfSSL_SESSION_get_ticket_lifetime_hint(byval sess as const WOLFSSL_SESSION ptr) as culong
declare function wolfSSL_SESSION_get_timeout(byval session as const WOLFSSL_SESSION ptr) as clong
declare function wolfSSL_SESSION_get_time(byval session as const WOLFSSL_SESSION ptr) as clong
declare function wolfSSL_CTX_get_ex_new_index(byval idx as clong, byval arg as any ptr, byval a as any ptr, byval b as any ptr, byval c as any ptr) as long
declare function wolfSSL_check_domain_name(byval ssl as WOLFSSL ptr, byval dn as const zstring ptr) as long
declare function wolfSSL_Init() as long
declare function wolfSSL_Cleanup() as long
declare function wolfSSL_lib_version() as const zstring ptr
declare function wolfSSL_OpenSSL_version() as const zstring ptr
declare function wolfSSL_lib_version_hex() as word32
declare function wolfSSL_negotiate(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_set_compression(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_set_timeout(byval ssl as WOLFSSL ptr, byval to as ulong) as long
declare function wolfSSL_CTX_set_timeout(byval ctx as WOLFSSL_CTX ptr, byval to as ulong) as long
declare sub wolfSSL_CTX_set_current_time_cb(byval ctx as WOLFSSL_CTX ptr, byval cb as sub(byval ssl as const WOLFSSL ptr, byval out_clock as WOLFSSL_TIMEVAL ptr))

#ifndef WOLFSSL_X509_CHAIN
type WOLFSSL_X509_CHAIN as WOLFSSL_X509_CHAIN
#endif

declare function wolfSSL_get_peer_chain(byval ssl as WOLFSSL ptr) as WOLFSSL_X509_CHAIN ptr
declare function wolfSSL_get_chain_count(byval chain as WOLFSSL_X509_CHAIN ptr) as long
declare function wolfSSL_get_chain_length(byval chain as WOLFSSL_X509_CHAIN ptr, byval idx as long) as long
declare function wolfSSL_get_chain_cert(byval chain as WOLFSSL_X509_CHAIN ptr, byval idx as long) as ubyte ptr
declare function wolfSSL_get_chain_X509(byval chain as WOLFSSL_X509_CHAIN ptr, byval idx as long) as WOLFSSL_X509 ptr
#define wolfSSL_FreeX509(x509) wolfSSL_X509_free((x509))
declare sub wolfSSL_X509_free(byval x509 as WOLFSSL_X509 ptr)
declare function wolfSSL_get_chain_cert_pem(byval chain as WOLFSSL_X509_CHAIN ptr, byval idx as long, byval buf as ubyte ptr, byval inLen as long, byval outLen as long ptr) as long
declare function wolfSSL_get_sessionID(byval s as const WOLFSSL_SESSION ptr) as const ubyte ptr
declare function wolfSSL_X509_get_serial_number(byval x509 as WOLFSSL_X509 ptr, byval in as ubyte ptr, byval inOutSz as long ptr) as long
declare function wolfSSL_X509_get_subjectCN(byval x509 as WOLFSSL_X509 ptr) as zstring ptr
declare function wolfSSL_X509_get_der(byval x509 as WOLFSSL_X509 ptr, byval outSz as long ptr) as const ubyte ptr
declare function wolfSSL_X509_get_tbs(byval x509 as WOLFSSL_X509 ptr, byval outSz as long ptr) as const ubyte ptr
declare function wolfSSL_X509_notBefore(byval x509 as WOLFSSL_X509 ptr) as const _byte ptr
declare function wolfSSL_X509_notAfter(byval x509 as WOLFSSL_X509 ptr) as const _byte ptr
declare function wolfSSL_X509_version(byval x509 as WOLFSSL_X509 ptr) as long
declare function wolfSSL_cmp_peer_cert_to_file(byval ssl as WOLFSSL ptr, byval fname as const zstring ptr) as long
declare function wolfSSL_X509_get_next_altname(byval cert as WOLFSSL_X509 ptr) as zstring ptr
declare function wolfSSL_X509_add_altname_ex(byval x509 as WOLFSSL_X509 ptr, byval name as const zstring ptr, byval nameSz as word32, byval type as long) as long
declare function wolfSSL_X509_add_altname(byval x509 as WOLFSSL_X509 ptr, byval name as const zstring ptr, byval type as long) as long
declare function wolfSSL_d2i_X509(byval x509 as WOLFSSL_X509 ptr ptr, byval in as const ubyte ptr ptr, byval len as long) as WOLFSSL_X509 ptr
declare function wolfSSL_X509_d2i(byval x509 as WOLFSSL_X509 ptr ptr, byval in as const ubyte ptr, byval len as long) as WOLFSSL_X509 ptr
declare function wolfSSL_i2d_X509(byval x509 as WOLFSSL_X509 ptr, byval out as ubyte ptr ptr) as long
declare function wolfSSL_d2i_X509_CRL(byval crl as WOLFSSL_X509_CRL ptr ptr, byval in as const ubyte ptr, byval len as long) as WOLFSSL_X509_CRL ptr
declare function wolfSSL_d2i_X509_CRL_bio(byval bp as WOLFSSL_BIO ptr, byval crl as WOLFSSL_X509_CRL ptr ptr) as WOLFSSL_X509_CRL ptr
declare function wolfSSL_d2i_X509_CRL_fp(byval file as FILE ptr, byval crl as WOLFSSL_X509_CRL ptr ptr) as WOLFSSL_X509_CRL ptr
declare function wolfSSL_X509_d2i_fp(byval x509 as WOLFSSL_X509 ptr ptr, byval file as FILE ptr) as WOLFSSL_X509 ptr
declare function wolfSSL_X509_load_certificate_file(byval fname as const zstring ptr, byval format as long) as WOLFSSL_X509 ptr
declare function wolfSSL_X509_load_certificate_buffer(byval buf as const ubyte ptr, byval sz as long, byval format as long) as WOLFSSL_X509 ptr
declare function wolfSSL_connect_cert(byval ssl as WOLFSSL ptr) as long

#undef WC_PKCS12
type WC_PKCS12 as WC_PKCS12

declare function wolfSSL_d2i_PKCS12_bio(byval bio as WOLFSSL_BIO ptr, byval pkcs12 as WC_PKCS12 ptr ptr) as WC_PKCS12 ptr
declare function wolfSSL_i2d_PKCS12_bio(byval bio as WOLFSSL_BIO ptr, byval pkcs12 as WC_PKCS12 ptr) as long
declare function wolfSSL_d2i_PKCS12_fp(byval fp as FILE ptr, byval pkcs12 as WOLFSSL_X509_PKCS12 ptr ptr) as WOLFSSL_X509_PKCS12 ptr
declare function wolfSSL_PKCS12_parse(byval pkcs12 as WC_PKCS12 ptr, byval psw as const zstring ptr, byval pkey as WOLFSSL_EVP_PKEY ptr ptr, byval cert as WOLFSSL_X509 ptr ptr, byval ca as WOLFSSL_STACK ptr ptr) as long
declare function wolfSSL_PKCS12_verify_mac(byval pkcs12 as WC_PKCS12 ptr, byval psw as const zstring ptr, byval pswLen as long) as long
declare function wolfSSL_PKCS12_create(byval pass as zstring ptr, byval name as zstring ptr, byval pkey as WOLFSSL_EVP_PKEY ptr, byval cert as WOLFSSL_X509 ptr, byval ca as WOLFSSL_STACK ptr, byval keyNID as long, byval certNID as long, byval itt as long, byval macItt as long, byval keytype as long) as WC_PKCS12 ptr
declare sub wolfSSL_PKCS12_PBE_add()
declare function wolfSSL_SetTmpDH(byval ssl as WOLFSSL ptr, byval p as const ubyte ptr, byval pSz as long, byval g as const ubyte ptr, byval gSz as long) as long
declare function wolfSSL_SetTmpDH_buffer(byval ssl as WOLFSSL ptr, byval b as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_SetEnableDhKeyTest(byval ssl as WOLFSSL ptr, byval enable as long) as long
declare function wolfSSL_SetTmpDH_file(byval ssl as WOLFSSL ptr, byval f as const zstring ptr, byval format as long) as long
declare function wolfSSL_CTX_SetTmpDH(byval ctx as WOLFSSL_CTX ptr, byval p as const ubyte ptr, byval pSz as long, byval g as const ubyte ptr, byval gSz as long) as long
declare function wolfSSL_CTX_SetTmpDH_buffer(byval ctx as WOLFSSL_CTX ptr, byval b as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_SetTmpDH_file(byval ctx as WOLFSSL_CTX ptr, byval f as const zstring ptr, byval format as long) as long
declare function wolfSSL_CTX_SetMinDhKey_Sz(byval ctx as WOLFSSL_CTX ptr, byval keySz_bits as word16) as long
declare function wolfSSL_SetMinDhKey_Sz(byval ssl as WOLFSSL ptr, byval keySz_bits as word16) as long
declare function wolfSSL_CTX_SetMaxDhKey_Sz(byval ctx as WOLFSSL_CTX ptr, byval keySz_bits as word16) as long
declare function wolfSSL_SetMaxDhKey_Sz(byval ssl as WOLFSSL ptr, byval keySz_bits as word16) as long
declare function wolfSSL_GetDhKey_Sz(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_SetMinRsaKey_Sz(byval ctx as WOLFSSL_CTX ptr, byval keySz as short) as long
declare function wolfSSL_SetMinRsaKey_Sz(byval ssl as WOLFSSL ptr, byval keySz as short) as long
declare function wolfSSL_SetTmpEC_DHE_Sz(byval ssl as WOLFSSL ptr, byval sz as word16) as long
declare function wolfSSL_CTX_SetTmpEC_DHE_Sz(byval ctx as WOLFSSL_CTX ptr, byval sz as word16) as long
declare function wolfSSL_get_keyblock_size(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_get_keys(byval ssl as WOLFSSL ptr, byval ms as ubyte ptr ptr, byval msLen as ulong ptr, byval sr as ubyte ptr ptr, byval srLen as ulong ptr, byval cr as ubyte ptr ptr, byval crLen as ulong ptr) as long
declare function wolfSSL_make_eap_keys(byval ssl as WOLFSSL ptr, byval key as any ptr, byval len as ulong, byval label as const zstring ptr) as long

#ifndef iovec
type iovec as iovec
#endif

declare function wolfSSL_writev(byval ssl as WOLFSSL ptr, byval iov as const iovec ptr, byval iovcnt as long) as long
declare function wolfSSL_CTX_UnloadCAs(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_load_verify_buffer_ex(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long, byval userChain as long, byval flags as word32) as long
declare function wolfSSL_CTX_load_verify_buffer(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_load_verify_chain_buffer_format(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_use_certificate_buffer(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_use_PrivateKey_buffer(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_use_PrivateKey_id overload (byval ctx as WOLFSSL_CTX ptr, byval id as const ubyte ptr, byval sz as clong, byval devId as long, byval keySz as clong) as long
declare function wolfSSL_CTX_use_PrivateKey_Id overload (byval ctx as WOLFSSL_CTX ptr, byval id as const ubyte ptr, byval sz as clong, byval devId as long) as long
declare function wolfSSL_CTX_use_PrivateKey_Label(byval ctx as WOLFSSL_CTX ptr, byval label as const zstring ptr, byval devId as long) as long
declare function wolfSSL_CTX_use_certificate_chain_buffer_format(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CTX_use_certificate_chain_buffer(byval ctx as WOLFSSL_CTX ptr, byval in as const ubyte ptr, byval sz as clong) as long
declare function wolfSSL_use_certificate_buffer(byval ssl as WOLFSSL ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_use_certificate_ASN1(byval ssl as WOLFSSL ptr, byval der as const ubyte ptr, byval derSz as long) as long
declare function wolfSSL_use_PrivateKey_buffer(byval ssl as WOLFSSL ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_use_PrivateKey_id overload (byval ssl as WOLFSSL ptr, byval id as const ubyte ptr, byval sz as clong, byval devId as long, byval keySz as clong) as long
declare function wolfSSL_use_PrivateKey_Id overload (byval ssl as WOLFSSL ptr, byval id as const ubyte ptr, byval sz as clong, byval devId as long) as long
declare function wolfSSL_use_PrivateKey_Label(byval ssl as WOLFSSL ptr, byval label as const zstring ptr, byval devId as long) as long
declare function wolfSSL_use_certificate_chain_buffer_format(byval ssl as WOLFSSL ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_use_certificate_chain_buffer(byval ssl as WOLFSSL ptr, byval in as const ubyte ptr, byval sz as clong) as long
declare function wolfSSL_UnloadCertsKeys(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_set_group_messages(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_set_group_messages(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_DTLS_SetCookieSecret(byval ssl as WOLFSSL ptr, byval secret as const _byte ptr, byval secretSz as word32) as long

type IOerrors as long
enum
	WOLFSSL_CBIO_ERR_GENERAL = -1
	WOLFSSL_CBIO_ERR_WANT_READ = -2
	WOLFSSL_CBIO_ERR_WANT_WRITE = -2
	WOLFSSL_CBIO_ERR_CONN_RST = -3
	WOLFSSL_CBIO_ERR_ISR = -4
	WOLFSSL_CBIO_ERR_CONN_CLOSE = -5
	WOLFSSL_CBIO_ERR_TIMEOUT = -6
end enum

enum
	WOLFSSL_SSLV3 = 0
	WOLFSSL_TLSV1 = 1
	WOLFSSL_TLSV1_1 = 2
	WOLFSSL_TLSV1_2 = 3
	WOLFSSL_TLSV1_3 = 4
	WOLFSSL_DTLSV1 = 5
	WOLFSSL_DTLSV1_2 = 6
	WOLFSSL_DTLSV1_3 = 7
	WOLFSSL_USER_CA = 1
	WOLFSSL_CHAIN_CA = 2
end enum

declare function wolfSSL_GetRNG(byval ssl as WOLFSSL ptr) as WC_RNG ptr
declare function wolfSSL_CTX_SetMinVersion(byval ctx as WOLFSSL_CTX ptr, byval version as long) as long
declare function wolfSSL_SetMinVersion(byval ssl as WOLFSSL ptr, byval version as long) as long
declare function wolfSSL_GetObjectSize() as long
declare function wolfSSL_CTX_GetObjectSize() as long
declare function wolfSSL_METHOD_GetObjectSize() as long
declare function wolfSSL_GetOutputSize(byval ssl as WOLFSSL ptr, byval inSz as long) as long
declare function wolfSSL_GetMaxOutputSize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetVersion(byval ssl as const WOLFSSL ptr) as long
declare function wolfSSL_SetVersion(byval ssl as WOLFSSL ptr, byval version as long) as long
declare function wolfSSL_KeyPemToDer alias "wc_KeyPemToDer"(byval pem as const ubyte ptr, byval pemSz as long, byval buff as ubyte ptr, byval buffSz as long, byval pass as const zstring ptr) as long
declare function wolfSSL_CertPemToDer alias "wc_CertPemToDer"(byval pem as const ubyte ptr, byval pemSz as long, byval buff as ubyte ptr, byval buffSz as long, byval type as long) as long

#define wolfSSL_PemPubKeyToDer wc_PemPubKeyToDer
#define wolfSSL_PubKeyPemToDer wc_PubKeyPemToDer
#define wolfSSL_PemCertToDer wc_PemCertToDer

type CallbackCACache as sub(byval der as ubyte ptr, byval sz as long, byval type as long)
type CbMissingCRL as sub(byval url as const zstring ptr)
type CbOCSPIO as function(byval as any ptr, byval as const zstring ptr, byval as long, byval as ubyte ptr, byval as long, byval as ubyte ptr ptr) as long
type CbOCSPRespFree as sub(byval as any ptr, byval as ubyte ptr)
type CallbackMacEncrypt as function(byval ssl as WOLFSSL ptr, byval macOut as ubyte ptr, byval macIn as const ubyte ptr, byval macInSz as ulong, byval macContent as long, byval macVerify as long, byval encOut as ubyte ptr, byval encIn as const ubyte ptr, byval encSz as ulong, byval ctx as any ptr) as long

declare sub wolfSSL_CTX_SetMacEncryptCb(byval ctx as WOLFSSL_CTX ptr, byval cb as CallbackMacEncrypt)
declare sub wolfSSL_SetMacEncryptCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare function wolfSSL_GetMacEncryptCtx(byval ssl as WOLFSSL ptr) as any ptr
type CallbackDecryptVerify as function(byval ssl as WOLFSSL ptr, byval decOut as ubyte ptr, byval decIn as const ubyte ptr, byval decSz as ulong, byval content as long, byval verify as long, byval padSz as ulong ptr, byval ctx as any ptr) as long
declare sub wolfSSL_CTX_SetDecryptVerifyCb(byval ctx as WOLFSSL_CTX ptr, byval cb as CallbackDecryptVerify)
declare sub wolfSSL_SetDecryptVerifyCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare function wolfSSL_GetDecryptVerifyCtx(byval ssl as WOLFSSL ptr) as any ptr
type CallbackEncryptMac as function(byval ssl as WOLFSSL ptr, byval macOut as ubyte ptr, byval content as long, byval macVerify as long, byval encOut as ubyte ptr, byval encIn as const ubyte ptr, byval encSz as ulong, byval ctx as any ptr) as long
declare sub wolfSSL_CTX_SetEncryptMacCb(byval ctx as WOLFSSL_CTX ptr, byval cb as CallbackEncryptMac)
declare sub wolfSSL_SetEncryptMacCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare function wolfSSL_GetEncryptMacCtx(byval ssl as WOLFSSL ptr) as any ptr
type CallbackVerifyDecrypt as function(byval ssl as WOLFSSL ptr, byval decOut as ubyte ptr, byval decIn as const ubyte ptr, byval decSz as ulong, byval content as long, byval verify as long, byval padSz as ulong ptr, byval ctx as any ptr) as long
declare sub wolfSSL_CTX_SetVerifyDecryptCb(byval ctx as WOLFSSL_CTX ptr, byval cb as CallbackVerifyDecrypt)
declare sub wolfSSL_SetVerifyDecryptCtx(byval ssl as WOLFSSL ptr, byval ctx as any ptr)
declare function wolfSSL_GetVerifyDecryptCtx(byval ssl as WOLFSSL ptr) as any ptr
declare function wolfSSL_GetMacSecret(byval ssl as WOLFSSL ptr, byval verify as long) as const ubyte ptr
declare function wolfSSL_GetDtlsMacSecret(byval ssl as WOLFSSL ptr, byval verify as long, byval epochOrder as long) as const ubyte ptr
declare function wolfSSL_GetClientWriteKey(byval ssl as WOLFSSL ptr) as const ubyte ptr
declare function wolfSSL_GetClientWriteIV(byval ssl as WOLFSSL ptr) as const ubyte ptr
declare function wolfSSL_GetServerWriteKey(byval ssl as WOLFSSL ptr) as const ubyte ptr
declare function wolfSSL_GetServerWriteIV(byval ssl as WOLFSSL ptr) as const ubyte ptr
declare function wolfSSL_GetKeySize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetIVSize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetSide(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_IsTLSv1_1(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetBulkCipher(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetCipherBlockSize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetAeadMacSize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetHmacSize(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetHmacType(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_GetPeerSequenceNumber(byval ssl as WOLFSSL ptr, byval seq as word64 ptr) as long
declare function wolfSSL_GetSequenceNumber(byval ssl as WOLFSSL ptr, byval seq as word64 ptr) as long
declare function wolfSSL_GetCipherType(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_SetTlsHmacInner(byval ssl as WOLFSSL ptr, byval inner as _byte ptr, byval sz as word32, byval content as long, byval verify as long) as long

enum
	WOLFSSL_SERVER_END = 0
	WOLFSSL_CLIENT_END = 1
	WOLFSSL_NEITHER_END = 3
	WOLFSSL_BLOCK_TYPE = 2
	WOLFSSL_STREAM_TYPE = 3
	WOLFSSL_AEAD_TYPE = 4
	WOLFSSL_TLS_HMAC_INNER_SZ = 13
end enum

type BulkCipherAlgorithm as long
enum
	wolfssl_cipher_null = 0
	wolfssl_rc4 = 1
	wolfssl_rc2 = 2
	wolfssl_des = 3
	wolfssl_triple_des = 4
	wolfssl_des40 = 5
	wolfssl_aes = 6
	wolfssl_aes_gcm = 7
	wolfssl_aes_ccm = 8
	wolfssl_chacha = 9
	wolfssl_camellia = 10
end enum

type KDF_MacAlgorithm as long
enum
	wolfssl_sha256 = 4
	wolfssl_sha384
	wolfssl_sha512
end enum

declare sub wolfSSL_CTX_SetCACb(byval ctx as WOLFSSL_CTX ptr, byval cb as CallbackCACache)

#ifndef WOLFSSL_CERT_MANAGER
type WOLFSSL_CERT_MANAGER as WOLFSSL_CERT_MANAGER
#endif

declare function wolfSSL_CTX_GetCertManager(byval ctx as WOLFSSL_CTX ptr) as WOLFSSL_CERT_MANAGER ptr
declare function wolfSSL_CertManagerNew_ex(byval heap as any ptr) as WOLFSSL_CERT_MANAGER ptr
declare function wolfSSL_CertManagerNew() as WOLFSSL_CERT_MANAGER ptr
declare sub wolfSSL_CertManagerFree(byval cm as WOLFSSL_CERT_MANAGER ptr)
declare function wolfSSL_CertManager_up_ref(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerLoadCA(byval cm as WOLFSSL_CERT_MANAGER ptr, byval f as const zstring ptr, byval d as const zstring ptr) as long
declare function wolfSSL_CertManagerLoadCABuffer(byval cm as WOLFSSL_CERT_MANAGER ptr, byval in as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CertManagerUnloadCAs(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerVerify(byval cm as WOLFSSL_CERT_MANAGER ptr, byval f as const zstring ptr, byval format as long) as long
declare function wolfSSL_CertManagerVerifyBuffer(byval cm as WOLFSSL_CERT_MANAGER ptr, byval buff as const ubyte ptr, byval sz as clong, byval format as long) as long
declare function wolfSSL_CertManagerCheckCRL(byval cm as WOLFSSL_CERT_MANAGER ptr, byval der as ubyte ptr, byval sz as long) as long
declare function wolfSSL_CertManagerEnableCRL(byval cm as WOLFSSL_CERT_MANAGER ptr, byval options as long) as long
declare function wolfSSL_CertManagerDisableCRL(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare sub wolfSSL_CertManagerSetVerify(byval cm as WOLFSSL_CERT_MANAGER ptr, byval vc as VerifyCallback)
declare function wolfSSL_CertManagerLoadCRL(byval cm as WOLFSSL_CERT_MANAGER ptr, byval path as const zstring ptr, byval type as long, byval monitor as long) as long
declare function wolfSSL_CertManagerLoadCRLFile(byval cm as WOLFSSL_CERT_MANAGER ptr, byval file as const zstring ptr, byval type as long) as long
declare function wolfSSL_CertManagerLoadCRLBuffer(byval cm as WOLFSSL_CERT_MANAGER ptr, byval buff as const ubyte ptr, byval sz as clong, byval type as long) as long
declare function wolfSSL_CertManagerSetCRL_Cb(byval cm as WOLFSSL_CERT_MANAGER ptr, byval cb as CbMissingCRL) as long
declare function wolfSSL_CertManagerFreeCRL(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerCheckOCSP(byval cm as WOLFSSL_CERT_MANAGER ptr, byval der as ubyte ptr, byval sz as long) as long
declare function wolfSSL_CertManagerEnableOCSP(byval cm as WOLFSSL_CERT_MANAGER ptr, byval options as long) as long
declare function wolfSSL_CertManagerDisableOCSP(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerSetOCSPOverrideURL(byval cm as WOLFSSL_CERT_MANAGER ptr, byval url as const zstring ptr) as long
declare function wolfSSL_CertManagerSetOCSP_Cb(byval cm as WOLFSSL_CERT_MANAGER ptr, byval ioCb as CbOCSPIO, byval respFreeCb as CbOCSPRespFree, byval ioCbCtx as any ptr) as long
declare function wolfSSL_CertManagerEnableOCSPStapling(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerDisableOCSPStapling(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerEnableOCSPMustStaple(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_CertManagerDisableOCSPMustStaple(byval cm as WOLFSSL_CERT_MANAGER ptr) as long
declare function wolfSSL_EnableCRL(byval ssl as WOLFSSL ptr, byval options as long) as long
declare function wolfSSL_DisableCRL(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_LoadCRL(byval ssl as WOLFSSL ptr, byval path as const zstring ptr, byval type as long, byval monitor as long) as long
declare function wolfSSL_LoadCRLFile(byval ssl as WOLFSSL ptr, byval file as const zstring ptr, byval type as long) as long
declare function wolfSSL_LoadCRLBuffer(byval ssl as WOLFSSL ptr, byval buff as const ubyte ptr, byval sz as clong, byval type as long) as long
declare function wolfSSL_SetCRL_Cb(byval ssl as WOLFSSL ptr, byval cb as CbMissingCRL) as long
declare function wolfSSL_EnableOCSP(byval ssl as WOLFSSL ptr, byval options as long) as long
declare function wolfSSL_DisableOCSP(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_SetOCSP_OverrideURL(byval ssl as WOLFSSL ptr, byval url as const zstring ptr) as long
declare function wolfSSL_SetOCSP_Cb(byval ssl as WOLFSSL ptr, byval ioCb as CbOCSPIO, byval respFreeCb as CbOCSPRespFree, byval ioCbCtx as any ptr) as long
declare function wolfSSL_EnableOCSPStapling(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_DisableOCSPStapling(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_EnableCRL(byval ctx as WOLFSSL_CTX ptr, byval options as long) as long
declare function wolfSSL_CTX_DisableCRL(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_LoadCRL(byval ctx as WOLFSSL_CTX ptr, byval path as const zstring ptr, byval type as long, byval monitor as long) as long
declare function wolfSSL_CTX_LoadCRLFile(byval ctx as WOLFSSL_CTX ptr, byval path as const zstring ptr, byval type as long) as long
declare function wolfSSL_CTX_LoadCRLBuffer(byval ctx as WOLFSSL_CTX ptr, byval buff as const ubyte ptr, byval sz as clong, byval type as long) as long
declare function wolfSSL_CTX_SetCRL_Cb(byval ctx as WOLFSSL_CTX ptr, byval cb as CbMissingCRL) as long
declare function wolfSSL_CTX_EnableOCSP(byval ctx as WOLFSSL_CTX ptr, byval options as long) as long
declare function wolfSSL_CTX_DisableOCSP(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_SetOCSP_OverrideURL(byval ctx as WOLFSSL_CTX ptr, byval url as const zstring ptr) as long
declare function wolfSSL_CTX_SetOCSP_Cb(byval ctx as WOLFSSL_CTX ptr, byval ioCb as CbOCSPIO, byval respFreeCb as CbOCSPRespFree, byval ioCbCtx as any ptr) as long
declare function wolfSSL_CTX_EnableOCSPStapling(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_DisableOCSPStapling(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_EnableOCSPMustStaple(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_CTX_DisableOCSPMustStaple(byval ctx as WOLFSSL_CTX ptr) as long
declare sub wolfSSL_KeepArrays(byval ssl as WOLFSSL ptr)
declare sub wolfSSL_FreeArrays(byval ssl as WOLFSSL ptr)
declare function wolfSSL_KeepHandshakeResources(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_FreeHandshakeResources(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_UseClientSuites(byval ctx as WOLFSSL_CTX ptr) as long
declare function wolfSSL_UseClientSuites(byval ssl as WOLFSSL ptr) as long

const WOLFSSL_SNI_HOST_NAME = 0
declare function wolfSSL_CTX_UseSNI(byval ctx as WOLFSSL_CTX ptr, type as ubyte , data as any ptr , size as ushort ) as long
declare function wolfSSL_UseSNI(byval ssl as WOLFSSL ptr, type as ubyte , data as any ptr , size as ushort  ) as long

declare function wolfSSL_SetDevId(byval ssl as WOLFSSL ptr, byval devId as long) as long
declare function wolfSSL_UseAsync alias "wolfSSL_SetDevId"(byval ssl as WOLFSSL ptr, byval devId as long) as long
declare function wolfSSL_CTX_SetDevId(byval ctx as WOLFSSL_CTX ptr, byval devId as long) as long
declare function wolfSSL_CTX_UseAsync alias "wolfSSL_CTX_SetDevId"(byval ctx as WOLFSSL_CTX ptr, byval devId as long) as long
declare function wolfSSL_CTX_GetDevId(byval ctx as WOLFSSL_CTX ptr, byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_GetHeap(byval ctx as WOLFSSL_CTX ptr, byval ssl as WOLFSSL ptr) as any ptr

enum
	WOLFSSL_CSR_OCSP = 1
end enum

enum
	WOLFSSL_CSR_OCSP_USE_NONCE = &h01
end enum

enum
	WOLFSSL_CSR2_OCSP = 1
	WOLFSSL_CSR2_OCSP_MULTI = 2
end enum

enum
	WOLFSSL_CSR2_OCSP_USE_NONCE = &h01
end enum

enum
	WOLFSSL_NAMED_GROUP_INVALID = 0
	WOLFSSL_ECC_SECP160K1 = 15
	WOLFSSL_ECC_SECP160R1 = 16
	WOLFSSL_ECC_SECP160R2 = 17
	WOLFSSL_ECC_SECP192K1 = 18
	WOLFSSL_ECC_SECP192R1 = 19
	WOLFSSL_ECC_SECP224K1 = 20
	WOLFSSL_ECC_SECP224R1 = 21
	WOLFSSL_ECC_SECP256K1 = 22
	WOLFSSL_ECC_SECP256R1 = 23
	WOLFSSL_ECC_SECP384R1 = 24
	WOLFSSL_ECC_SECP521R1 = 25
	WOLFSSL_ECC_BRAINPOOLP256R1 = 26
	WOLFSSL_ECC_BRAINPOOLP384R1 = 27
	WOLFSSL_ECC_BRAINPOOLP512R1 = 28
	WOLFSSL_ECC_X25519 = 29
	WOLFSSL_ECC_X448 = 30
	WOLFSSL_ECC_MAX = 30
	WOLFSSL_FFDHE_2048 = 256
	WOLFSSL_FFDHE_3072 = 257
	WOLFSSL_FFDHE_4096 = 258
	WOLFSSL_FFDHE_6144 = 259
	WOLFSSL_FFDHE_8192 = 260
end enum

enum
	WOLFSSL_EC_PF_UNCOMPRESSED = 0
end enum

declare function wolfSSL_DisableExtendedMasterSecret(byval ssl as WOLFSSL ptr) as long
declare function wolfSSL_CTX_DisableExtendedMasterSecret(byval ctx as WOLFSSL_CTX ptr) as long
const WOLFSSL_CRL_MONITOR = &h01
const WOLFSSL_CRL_START_MON = &h02
type HandShakeDoneCb as function(byval ssl as WOLFSSL ptr, byval as any ptr) as long
declare function wolfSSL_SetHsDoneCb(byval ssl as WOLFSSL ptr, byval cb as HandShakeDoneCb, byval user_ctx as any ptr) as long
declare function wolfSSL_PrintSessionStats() as long
declare function wolfSSL_get_session_stats(byval active as ulong ptr, byval total as ulong ptr, byval peak as ulong ptr, byval maxSessions as ulong ptr) as long
declare function wolfSSL_MakeTlsMasterSecret(byval ms as ubyte ptr, byval msLen as word32, byval pms as const ubyte ptr, byval pmsLen as word32, byval cr as const ubyte ptr, byval sr as const ubyte ptr, byval tls1_2 as long, byval hash_type as long) as long
declare function wolfSSL_MakeTlsExtendedMasterSecret(byval ms as ubyte ptr, byval msLen as word32, byval pms as const ubyte ptr, byval pmsLen as word32, byval sHash as const ubyte ptr, byval sHashLen as word32, byval tls1_2 as long, byval hash_type as long) as long
declare function wolfSSL_DeriveTlsKeys(byval key_data as ubyte ptr, byval keyLen as word32, byval ms as const ubyte ptr, byval msLen as word32, byval sr as const ubyte ptr, byval cr as const ubyte ptr, byval tls1_2 as long, byval hash_type as long) as long
declare function wolfSSL_version(byval ssl as WOLFSSL ptr) as long
type Rem_Sess_Cb as sub(byval as WOLFSSL_CTX ptr, byval as WOLFSSL_SESSION ptr)
declare sub wolfSSL_get0_alpn_selected(byval ssl as const WOLFSSL ptr, byval data as const ubyte ptr ptr, byval len as ulong ptr)
declare function wolfSSL_select_next_proto(byval out as ubyte ptr ptr, byval outlen as ubyte ptr, byval in as const ubyte ptr, byval inlen as ulong, byval client as const ubyte ptr, byval client_len as ulong) as long
declare sub wolfSSL_CTX_set_alpn_select_cb(byval ctx as WOLFSSL_CTX ptr, byval cb as function(byval ssl as WOLFSSL ptr, byval out as const ubyte ptr ptr, byval outlen as ubyte ptr, byval in as const ubyte ptr, byval inlen as ulong, byval arg as any ptr) as long, byval arg as any ptr)
declare sub wolfSSL_CTX_set_next_protos_advertised_cb(byval s as WOLFSSL_CTX ptr, byval cb as function(byval ssl as WOLFSSL ptr, byval out as const ubyte ptr ptr, byval outlen as ulong ptr, byval arg as any ptr) as long, byval arg as any ptr)
declare sub wolfSSL_CTX_set_next_proto_select_cb(byval s as WOLFSSL_CTX ptr, byval cb as function(byval ssl as WOLFSSL ptr, byval out as ubyte ptr ptr, byval outlen as ubyte ptr, byval in as const ubyte ptr, byval inlen as ulong, byval arg as any ptr) as long, byval arg as any ptr)
declare sub wolfSSL_get0_next_proto_negotiated(byval s as const WOLFSSL ptr, byval data as const ubyte ptr ptr, byval len as ulong ptr)
declare function wolfSSL_X509_check_host(byval x as WOLFSSL_X509 ptr, byval chk as const zstring ptr, byval chklen as uinteger, byval flags as ulong, byval peername as zstring ptr ptr) as long
declare function wolfSSL_X509_check_ip_asc(byval x as WOLFSSL_X509 ptr, byval ipasc as const zstring ptr, byval flags as ulong) as long

const SSL2_VERSION = &h0002
const SSL3_VERSION = &h0300
const TLS1_VERSION = &h0301
const TLS1_1_VERSION = &h0302
const TLS1_2_VERSION = &h0303
const TLS1_3_VERSION = &h0304
const DTLS1_VERSION = &hFEFF
const DTLS1_2_VERSION = &hFEFD

end extern
