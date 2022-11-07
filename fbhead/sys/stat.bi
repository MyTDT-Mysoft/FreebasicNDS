''
''
'' stat -- header translated with help of SWIG FB wrapper
''
'' NOTICE: This file is part of the FreeBASIC Compiler package and can't
''         be included in other distributions without authorization.
''
''
#ifndef __stat_bi__
#define __stat_bi__

type stat field=1
	st_dev as dev_t
	st_ino as ino_t
	st_mode as mode_t
	st_nlink as nlink_t
	st_uid as uid_t
	st_gid as gid_t
	st_rdev as dev_t
	st_size as off_t
	st_atime as time_t
	st_spare1 as integer
	st_mtime as time_t
	st_spare2 as integer
	st_ctime as time_t
	st_spare3 as integer
	st_blksize as integer
	st_blocks as integer
	st_spare4(0 to 2-1) as integer
end type

#define _IFMT &h0170000
#define _IFDIR &h0040000
#define _IFCHR &h0020000
#define _IFBLK &h0060000
#define _IFREG &h0100000
#define _IFLNK &h0120000
#define _IFSOCK &h0140000
#define _IFIFO &h0010000
#define S_BLKSIZE 1024
#define S_ISUID &h0004000
#define S_ISGID &h0002000
#define S_ISVTX &h0001000
#undef S_IREAD
#define S_IREAD &h0000400
#undef S_IWRITE
#define S_IWRITE &h0000200
#undef S_IEXEC
#define S_IEXEC &h0000100
#define S_ENFMT &h0002000
#define S_IFMT &h0170000
#define S_IFDIR &h0040000
#define S_IFCHR &h0020000
#define S_IFBLK &h0060000
#define S_IFREG &h0100000
#define S_IFLNK &h0120000
#define S_IFSOCK &h0140000
#define S_IFIFO &h0010000
#define S_IRUSR &h0000400
#define S_IWUSR &h0000200
#define S_IXUSR &h0000100
#define S_IRGRP &h0000040
#define S_IWGRP &h0000020
#define S_IXGRP &h0000010
#define S_IROTH &h0000004
#define S_IWOTH &h0000002
#define S_IXOTH &h0000001

#define	S_ISBLK(m)	(((m) and _IFMT) = _IFBLK)
#define	S_ISCHR(m)	(((m) and _IFMT) = _IFCHR)
#define	S_ISDIR(m)	(((m) and _IFMT) = _IFDIR)
#define	S_ISFIFO(m)	(((m) and _IFMT) = _IFIFO)
#define	S_ISREG(m)	(((m) and _IFMT) = _IFREG)
#define	S_ISLNK(m)	(((m) and _IFMT) = _IFLNK)
#define	S_ISSOCK(m)	(((m) and _IFMT) = _IFSOCK)

extern "c"
  declare function stat (as zstring ptr, as stat ptr) as integer
end extern

#endif
