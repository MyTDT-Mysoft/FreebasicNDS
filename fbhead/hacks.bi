type GlobalData field=1
  ErrNum as integer
  Stdin_ as file ptr
  Stdout_ as file ptr 
  Stderr_ as file ptr
end type

extern as GlobalData ptr crt alias "_impure_ptr"

#undef stdin
#define stdin crt->Stdin_
#undef stdout
#define stdout crt->Stdout_
#undef stderr
#define stderr crt->stderr_

#ifndef write_
declare function write_ cdecl alias "write" (fd as integer,s as any ptr,_len as integer) as integer
#endif

#define as2(tt,p1,p2) p1 as tt,p2 as tt
#define as3(tt,p1,p2,p3) p1 as tt,p2 as tt,p3 as tt
#define as4(tt,p1,p2,p3,p4) p1 as tt,p2 as tt,p3 as tt,p4 as tt
#define as5(tt,p1,p2,p3,p4,p5) p1 as tt,p2 as tt,p3 as tt,p4 as tt,p5 as tt
#define as6(tt,p1,p2,p3,p4,p5,p6) p1 as tt,p2 as tt,p3 as tt,p4 as tt,p5 as tt,p6 as tt
#define as7(t,a,b,c,d,e,f,g) a as t,b as t,c as t,d as t,e as t,f as t,g as t
#define as8(t,a,b,c,d,e,f,g,h) a as t,b as t,c as t,d as t,e as t,f as t,g as t,h as t
#define as9(t,a,b,c,d,e,f,g,h,i) a as t,b as t,c as t,d as t,e as t,f as t,g as t,h as t,i as t
#macro UndefAll()
#undef P1
#undef P1
#undef P2
#undef P2
#undef P3
#undef P3
#undef P4
#undef P4
#undef P5
#undef P5
#undef P6
#undef P6
#undef P7
#undef P7
#undef P8
#undef P8
#undef P9
#undef P9
#undef P10
#undef P10
#undef P11
#undef P11
#undef P12
#undef P12
#undef P13
#undef P13
#undef P14
#undef P14
#undef P15
#undef P15
#endmacro
