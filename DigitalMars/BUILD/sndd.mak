ORIGIN		= Digital Mars C++
ORIGIN_VER	= Version 7.22
VERSION		= DEBUG

!IFDEF SUB_DEBUG
DEBUG		= $(SUB_DEBUG)
NDEBUG		= !$(SUB_DEBUG)
!ELSE
DEBUG		= 1
NDEBUG		= 0
!ENDIF

PROJ		= SNDD
APPTYPE		= WIN32 LIB
PROJTYPE	= LIB

CC		= SC
CPP		= SPP
JAVAC		= sj
MAKE		= SMAKE
RC		= RCC
HC		= HC31
ASM		= SC
DISASM		= OBJ2ASM
LNK		= LINK
DLLS		= 

HEADERS		= ..\INCLUDE\semlock.h ..\INCLUDE\ehsup.h ..\INCLUDE\mt.h  \
		..\INCLUDE\dbgint.h 

!IF $(DEBUG)
O	= SNDD
!IF EXIST (SNDD)
CREATEOUTPUTDIR	=
!ELSE
CREATEOUTPUTDIR	= if not exist $O\*.* md $O
!ENDIF
TARGETDIR	= ..\..\LIB
!IF EXIST (..\..\LIB)
CREATETARGETDIR	=
!ELSE
CREATETARGETDIR	= if not exist $(TARGETDIR)\*.* md $(TARGETDIR)
!ENDIF

SYMROOT		=  SNDD\precomp 
SYMS		= $(SYMROOT).SYM 
LIBS		= ..\win32\trace.lib SNDUNID.lib sccrt70d.LIB  \
		snddasm.lib snddcpp.lib 

CFLAGS		=  -HIprecomp.h -Ae -Ar -r -mn -NL -ND -5 -a8 -c -H -HDSNDD -HO- -wx -w- -w12 -g 
CFLAGS_1	=  -Ae -Ar -r -mn -f -NL -ND -5 -a8 -c -wx -w- -w12 -g
DEFINES_1	= -D_MT -D_MBCS -D_DEBUG -D_CRTLBD -D_DLL
LFLAGS		=  /CO /NOI /DE /PACKF /XN /A:512
DEFINES		= -D_MT -D_DEBUG -D_CRTBLD -D_DLL -D_MBCS=1
!ELSE
O	= SND
!IF EXIST (SND)
CREATEOUTPUTDIR	=
!ELSE
CREATEOUTPUTDIR	= if not exist $O\*.* md $O
!ENDIF
TARGETDIR	= ..\..\LIB
!IF EXIST (..\..\LIB)
CREATETARGETDIR	=
!ELSE
CREATETARGETDIR	= if not exist $(TARGETDIR)\*.* md $(TARGETDIR)
!ENDIF

SYMROOT		=  SND\precomp 
SYMS		= $(SYMROOT).SYM 
LIBS		= ..\win32\trace.lib SNDUNID.lib sccrt70d.LIB  \
		snddasm.lib snddcpp.lib 

CFLAGS		=  -HIprecomp.h -Ae -Ar -r -mn -o+time -NL -ND -5 -a8 -Nc -c -H -HDSND -HO- -wx -w- -w12 
CFLAGS_1	=  -r -mn -o+time -f -NL -5 -a8 -Nc -c -wx -w- -w12
DEFINES_1	= -D_MT -D_MBCS
LFLAGS		=  /NOI /DE /E /PACKF /XN /A:512
DEFINES		= -D_MT -D_MBCS=1
!ENDIF

HFLAGS		= $(CFLAGS) 
MFLAGS		= MASTERPROJ=SNDD 
LIBFLAGS	=  /C /NOI 
RESFLAGS	=  -32 
DEBUGGERFLAGS	=  
AFLAGS		= $(CFLAGS) 
HELPFLAGS	= 

MODEL		= N

PAR		= PROJS BATS OBJS

RCDEFINES	= 

INCLUDES	= -I..\INCLUDE -I..\..\INCLUDE

INCLUDEDOBJS	=  snn\tlsseg.obj 

OBJS		=  $O\_dup.OBJ  $O\_fcvt.OBJ  $O\_fgtchar.OBJ  \
		 $O\_fopen.OBJ  $O\_fptchar.OBJ  $O\_ismbbld.OBJ  $O\_ismbbtl.OBJ  \
		 $O\_itoa.OBJ  $O\_ltoa.OBJ  $O\_main.OBJ  $O\_memicmp.OBJ  \
		 $O\_printf.OBJ  $O\_strdup.OBJ  $O\_strerro.OBJ  $O\_strrev.OBJ  \
		 $O\arcerr.OBJ  $O\asctime.OBJ  $O\asin.OBJ  $O\assert.OBJ  \
		 $O\atan.OBJ  $O\atexit.OBJ  $O\atof.OBJ  $O\charmax.OBJ  \
		 $O\clock.OBJ  $O\commit.OBJ  $O\constart.OBJ  $O\controlc.OBJ  \
		 $O\coreleft.OBJ  $O\cprintf.OBJ  $O\cputype.OBJ  $O\creat.OBJ  \
		 $O\critical.OBJ  $O\crtinit.OBJ  $O\cscanf.OBJ  $O\ctime.OBJ  \
		 $O\ctype.OBJ  $O\dclass.OBJ  $O\disk.OBJ  $O\dllopen.OBJ  \
		 $O\dllstart.OBJ  $O\dosclose.OBJ  $O\dosdate.OBJ  $O\doserr.OBJ  \
		 $O\dosopen.OBJ  $O\ecvt.OBJ  $O\eof.OBJ  $O\exec2.OBJ  \
		 $O\execl.OBJ  $O\execle.OBJ  $O\execlp.OBJ  $O\execlpe.OBJ  \
		 $O\execv.OBJ  $O\execve.OBJ  $O\execvp.OBJ  $O\execvpe.OBJ  \
		 $O\exit.OBJ  $O\exitstat.OBJ  $O\exp.OBJ  $O\expand.OBJ  \
		 $O\fatexit.OBJ  $O\fclose.OBJ  $O\fcloseal.OBJ  $O\fcvt.OBJ  \
		 $O\fdivp.OBJ  $O\fdopen.OBJ  $O\feexcept.OBJ  $O\fflush.OBJ  \
		 $O\fgetchar.OBJ  $O\fgets.OBJ  $O\filelen.OBJ  $O\find.OBJ  \
		 $O\floatcvt.OBJ  $O\fltenv.OBJ  $O\fltused.OBJ  $O\flush.OBJ  \
		 $O\flushall.OBJ  $O\fmacros.OBJ  $O\fmbyte.OBJ  $O\fmt.OBJ  \
		 $O\fopen.OBJ  $O\fplock.OBJ  $O\fpsig.OBJ  $O\fputchar.OBJ  \
		 $O\fputs.OBJ  $O\fread.OBJ  $O\freopen.OBJ  $O\fsopen.OBJ  \
		 $O\fwrite.OBJ  $O\gcvt.OBJ  $O\getchar.OBJ  $O\getdate.OBJ  \
		 $O\getftime.OBJ  $O\getpid.OBJ  $O\gets.OBJ  $O\gettime.OBJ  \
		 $O\hyper.OBJ  $O\ieee.OBJ  $O\initmbcp.OBJ  $O\isalnum.OBJ  \
		 $O\isalpha.OBJ  $O\isascii.OBJ  $O\iscntrl.OBJ  $O\iscsym.OBJ  \
		 $O\iscsymf.OBJ  $O\isdigit.OBJ  $O\isgraph.OBJ  $O\islower.OBJ  \
		 $O\isprint.OBJ  $O\ispunct.OBJ  $O\isspace.OBJ  $O\isupper.OBJ  \
		 $O\isxdigit.OBJ $O\isblank.obj  $O\jmp.OBJ  $O\lconv.OBJ  $O\lfind.OBJ  \
		 $O\log.OBJ  $O\lsearch.OBJ  $O\matherr.OBJ  $O\mbctype.OBJ  \
		 $O\mbstowcs.OBJ  $O\mbstring.OBJ  $O\mbyte.OBJ  $O\memccpy.OBJ  \
		 $O\memcmp.OBJ  $O\memset.OBJ  $O\mktemp.OBJ  $O\okbigbuf.OBJ  \
		 $O\onexit.OBJ  $O\perror.OBJ  $O\poly.OBJ  $O\pow.OBJ  \
		 $O\printf.OBJ  $O\putchar.OBJ  $O\puts.OBJ  $O\qsort.OBJ  \
		 $O\rand.OBJ  $O\response.OBJ  $O\rmtmp.OBJ  $O\round.OBJ  \
		 $O\scanf.OBJ  $O\semlock.OBJ  $O\setargv.OBJ  $O\seterrno.OBJ  \
		 $O\setjmp.OBJ  $O\setlc.OBJ  $O\setmbcp.OBJ  $O\setmode.OBJ  \
		 $O\setnterr.OBJ  $O\signal.OBJ  $O\sin.OBJ  $O\sleep.OBJ  \
		 $O\sopenf.OBJ  $O\sound.OBJ  $O\spawn.OBJ  $O\spawnl.OBJ  \
		 $O\spawnle.OBJ  $O\spawnlp.OBJ  $O\spawnlpe.OBJ  $O\spawnv.OBJ  \
		 $O\spawnve.OBJ  $O\spawnvp.OBJ  $O\spawnvpe.OBJ  $O\splitpat.OBJ  \
		 $O\sqrt.OBJ  $O\stack.OBJ  $O\stckaval.OBJ  $O\strcspn.OBJ  \
		 $O\strdup.OBJ  $O\strerror.OBJ  $O\strf.OBJ  $O\strfunc.OBJ  \
		 $O\strlwr.OBJ  $O\strnset.OBJ  $O\strrev.OBJ  $O\strset.OBJ  \
		 $O\strspn.OBJ  $O\strstr.OBJ  $O\strtod.OBJ  $O\strtof.OBJ  \
		 $O\strtok.OBJ  $O\strtol.OBJ  $O\strtoull.OBJ  $O\strupr.OBJ  \
		 $O\strxfrm.OBJ  $O\swab.OBJ  $O\system.OBJ  $O\tabsize.OBJ  \
		 $O\tan.OBJ  $O\tchar.OBJ  $O\time3.OBJ  $O\tlsdata.OBJ  \
		 $O\tmpnam.OBJ  $O\toascii.OBJ  $O\tolower.OBJ  $O\trigerr.OBJ  \
		 $O\umask.OBJ  $O\ungetc.OBJ  $O\unlink.OBJ  $O\unmangle.OBJ  \
		 $O\utime.OBJ  $O\vprintf.OBJ  $O\w32sver.OBJ  $O\winstart.OBJ  \
		 $O\xcfilter.OBJ  $O\disp.OBJ  $O\scver.OBJ  $O\alloca.OBJ  \
		 $O\purevirt.OBJ  $O\VEDBGHK.OBJ  $O\_ALLOCA.OBJ  $O\decdata.OBJ  \
		 $O\fgetwc.OBJ  $O\fgetws.OBJ  $O\flushwbu.OBJ  $O\FPUTWC.OBJ  \
		 $O\FPUTWS.OBJ  $O\getws.OBJ  $O\isctype.OBJ  $O\iswctype.OBJ  \
		 $O\ITOW.OBJ  $O\LCAPI32.OBJ  $O\LCCRTDR.OBJ  $O\LCCRTFL.OBJ  \
		 $O\LCCRTPC.OBJ  $O\LCDELFL.OBJ  $O\LCFNDFL.OBJ  $O\LCGETCD.OBJ  \
		 $O\LCGETCL.OBJ  $O\LCGETFA.OBJ  $O\LCGETMF.OBJ  $O\LCMOVFL.OBJ  \
		 $O\LCRMVDR.OBJ  $O\LCSETCD.OBJ  $O\LCSETFA.OBJ  $O\LTOW.OBJ  \
		 $O\MBTOWC.OBJ  $O\NLSDATA.OBJ  $O\NULDATA.OBJ  $O\PUTWS.OBJ  \
		 $O\SETCHARS.OBJ  $O\STRCOLL.OBJ  $O\STRICOLL.OBJ  $O\STRNCOLL.OBJ  \
		 $O\STRNICOL.OBJ  $O\TIMDATA.OBJ  $O\TNODATA.OBJ  $O\TOWUPPER.OBJ  \
		 $O\ULTOW.OBJ  $O\UNGETWC.OBJ  $O\_ISMBSLD.OBJ  $O\_ISMBSTL.OBJ  \
		 $O\ISMBALNU.OBJ  $O\ISMBALPH.OBJ  $O\ISMBBYTE.OBJ  $O\ISMBCL0.OBJ  \
		 $O\ISMBCL1.OBJ  $O\ISMBCL2.OBJ  $O\ISMBDIGI.OBJ  $O\ISMBGRAP.OBJ  \
		 $O\ISMBHIRA.OBJ  $O\ISMBKATA.OBJ  $O\ISMBLEGA.OBJ  $O\ISMBLOWE.OBJ  \
		 $O\ISMBPRIN.OBJ  $O\ISMBPUNC.OBJ  $O\ISMBSPAC.OBJ  $O\ISMBSYMB.OBJ  \
		 $O\ISMBUPPE.OBJ  $O\MBBTOMBC.OBJ  $O\MBBTYPE.OBJ  $O\MBCCPY.OBJ  \
		 $O\MBCLEN.OBJ  $O\MBCPINFO.OBJ  $O\MBJISJMS.OBJ  $O\MBJMSJIS.OBJ  \
		 $O\MBLEN.OBJ  $O\MBSBTYPE.OBJ  $O\MBSCMP.OBJ  $O\MBSCOLL.OBJ  \
		 $O\MBSCSPN.OBJ  $O\MBSDEC.OBJ  $O\MBSICOLL.OBJ  $O\MBSINC.OBJ  \
		 $O\MBSLEN.OBJ  $O\MBSLWR.OBJ  $O\MBSNBCAT.OBJ  $O\MBSNBCMP.OBJ  \
		 $O\MBSNBCNT.OBJ  $O\MBSNBCOL.OBJ  $O\MBSNBCPY.OBJ  $O\MBSNBICO.OBJ  \
		 $O\MBSNBSET.OBJ  $O\MBSNCAT.OBJ  $O\MBSNCCNT.OBJ  $O\MBSNCMP.OBJ  \
		 $O\MBSNCOLL.OBJ  $O\MBSNCPY.OBJ  $O\MBSNEXTC.OBJ  $O\MBSNICMP.OBJ  \
		 $O\MBSNICOL.OBJ  $O\MBSNINC.OBJ  $O\MBSNSET.OBJ  $O\MBSREV.OBJ  \
		 $O\MBSSET.OBJ  $O\MBSSPN.OBJ  $O\MBSSPNP.OBJ  $O\MBSSTR.OBJ  \
		 $O\MBSTOK.OBJ  $O\MBSTRLEN.OBJ  $O\MBSUPR.OBJ  $O\MBTOHIRA.OBJ  \
		 $O\MBTOKATA.OBJ  $O\MBTOLOWE.OBJ  $O\w32fater.OBJ \
		 $O\fwide.obj $O\wmem.obj $O\thunk.obj

RCFILES		= 

RESFILES	= 

HELPFILES	= 

PROJS		= TLSSEG.MAK SNDUNID.PRJ snddasm.prj  \
		snddcpp.prj 

BATS		= 

PRECOMPILE	=  TLSSEG?PMAK  SNDUNID?PPRJ  snddasm?Pprj  \
		 snddcpp?Pprj  sccrt70d?Pprj  copylibd?Pmak  trace?Pmak 

POSTCOMPILE	= 

POSTLINK	= 

.SUFFIXES: .C .CP .CPP .CXX .CC .H .HPP .HXX .COM .EXE .DLL .LIB .RTF .DLG .ASM .RES .RC .OBJ 

.C.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.c

.CPP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cpp

.CXX.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cxx

.CC.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cc

.CP.OBJ:
	$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.cp

.H.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -oSNDD\$(*B).sym $*.h

.HPP.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -oSNDD\$(*B).sym $*.hpp

.HXX.SYM:
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF -oSNDD\$(*B).sym $*.hxx

.C.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)   $*.c   -o$*.lst

.CPP.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.cpp -o$*.lst

.CXX.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.cxx -o$*.lst

.CP.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)  $*.cp  -o$*.lst

.CC.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES)  $*.cc  -o$*.lst

.ASM.EXP:
	$(CPP) $(CFLAGS) $(DEFINES) $(INCLUDES) $*.asm -o$*.lst

.OBJ.COD:
	$(DISASM) $*.OBJ -c

.RTF.HLP:
	$(HC) $(HELPFLAGS) $*.HPJ

.ASM.OBJ:
	$(ASM) $(AFLAGS) $(DEFINES) $(INCLUDES) -o$*.obj $*.asm

.RC.RES: 
	$(RC) $(RCDEFINES) $(RESFLAGS) $(INCLUDES) $*.rc -o$*.res

.DLG.RES:
	echo ^#include "windows.h" >$$$*.rc
	echo ^IF EXIST "$*.h" >>$$$*.rc
	echo ^#include "$*.h" >>$$$*.rc
	echo ^#include "$*.dlg" >>$$$*.rc
	$(RC) $(RCDEFINES) $(RESFLAGS) $(INCLUDES) $$$*.rc
	-del $*.res
	-ren $$$*.res $*.res



all:	noteout createdir $(PRECOMPILE) $(SYMS) $(OBJS) $(INCLUDEDOBJS) $(POSTCOMPILE) $(TARGETDIR)\SNDD.LIB $(POSTLINK) _done


all2:	createdir $(PRECOMPILE) $(SYMS) $(OBJS) $(INCLUDEDOBJS) $(POSTCOMPILE) $(TARGETDIR)\SNDD.LIB $(POSTLINK) _done

noteout:
	REM Output to $O

createdir:
	$(CREATEOUTPUTDIR)
	$(CREATETARGETDIR)

$(TARGETDIR)\SNDD.LIB: $(SYMS) $(OBJS) $(INCLUDEDOBJS)
		lib -c $(TARGETDIR)\SNDD.lib \
				@<<
			$(OBJS) $(INCLUDEDOBJS) $(LIBS)
<<
			-echo $(TARGETDIR)\SNDD.LIB built

_done:
		REM  Project is up to date

buildall:	clean	all


clean:
		-del $(TARGETDIR)\$$SCW$$.LIB
		-del $(TARGETDIR)\SNDD.CLE
		-del $O\SCPH.SYM
		-del SNDD.dpd
		-del $(OBJS)
		-del $(SYMROOT).SYM
		-del $(SYMROOT).PCO
		$(MAKE) -fsccrt70d.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -fsndunid.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -fsnddasm.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -fsnddcpp.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -ftrace.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -ftlsseg.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@
		$(MAKE) -fcopylibd.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)" $@

cleanres:

res:		cleanres $(RCFILES) all



sccrt70d?Pprj:
		$(MAKE) -fsccrt70d.mak "SUB_DEBUG=$(DEBUG)"

SNDUNID?PPRJ:
		$(MAKE) -fsndunid.mak "SUB_DEBUG=$(DEBUG)"

snddasm?Pprj:
		$(MAKE) -fsnddasm.mak "SUB_DEBUG=$(DEBUG)"

snddcpp?Pprj:
		$(MAKE) -fsnddcpp.mak "SUB_DEBUG=$(DEBUG)"


trace?Pmak:
		$(MAKE) -ftrace.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)"

TLSSEG?PMAK:
		$(MAKE) -fTLSSEG.MAK $(MFLAGS) "SUB_DEBUG=$(DEBUG)"

copylibd?Pmak:
		$(MAKE) -fcopylibd.mak $(MFLAGS) "SUB_DEBUG=$(DEBUG)"




!IF EXIST (SNDD.dpd)
!INCLUDE SNDD.dpd
!ENDIF



$O\_exit.obj:	..\core32\_exit.c
		$(CC) $(CFLAGS) $(INCLUDES) -o$O\_exit.obj ..\core32\_exit.c


$O\_exit2.obj:	..\core32\_exit2.c
		$(CC) $(CFLAGS) $(INCLUDES) -o$O\_exit2.obj ..\core32\_exit2.c


$O\_dup.OBJ:	..\core\_dup.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_dup.obj ..\core\_dup.c



$O\_fcvt.OBJ:	..\core\_fcvt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_fcvt.obj ..\core\_fcvt.c



$O\_fgtchar.OBJ:	..\core\_fgtchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_fgtchar.obj ..\core\_fgtchar.c



$O\_fopen.OBJ:	..\core\_fopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_fopen.obj ..\core\_fopen.c



$O\_fptchar.OBJ:	..\core\_fptchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_fptchar.obj ..\core\_fptchar.c



$O\_ismbbld.OBJ:	..\core\_ismbbld.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ismbbld.obj ..\core\_ismbbld.c



$O\_ismbbtl.OBJ:	..\core\_ismbbtl.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ismbbtl.obj ..\core\_ismbbtl.c



$O\_itoa.OBJ:	..\core\_itoa.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_itoa.obj ..\core\_itoa.c



$O\_ltoa.OBJ:	..\core\_ltoa.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ltoa.obj ..\core\_ltoa.c



$O\_main.OBJ:	..\core\_main.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_main.obj ..\core\_main.c



$O\_memicmp.OBJ:	..\core\_memicmp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_memicmp.obj ..\core\_memicmp.c



$O\_printf.OBJ:	..\core\_printf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_printf.obj ..\core\_printf.c



$O\_strdup.OBJ:	..\core\_strdup.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_strdup.obj ..\core\_strdup.c



$O\_strerro.OBJ:	..\core\_strerro.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_strerro.obj ..\core\_strerro.c



$O\_strrev.OBJ:	..\core\_strrev.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_strrev.obj ..\core\_strrev.c



$O\arcerr.OBJ:	..\core\arcerr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\arcerr.obj ..\core\arcerr.c



$O\asctime.OBJ:	..\core\asctime.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\asctime.obj ..\core\asctime.c



$O\asin.OBJ:	..\core\asin.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\asin.obj ..\core\asin.c



$O\assert.OBJ:	..\core\assert.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\assert.obj ..\core\assert.c



$O\atan.OBJ:	..\core\atan.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\atan.obj ..\core\atan.c



$O\atexit.OBJ:	..\core\atexit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\atexit.obj ..\core\atexit.c



$O\atof.OBJ:	..\core\atof.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\atof.obj ..\core\atof.c



$O\charmax.OBJ:	..\core\charmax.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\charmax.obj ..\core\charmax.c



$O\clock.OBJ:	..\win32\clock.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\clock.obj ..\win32\clock.c



$O\commit.OBJ:	..\core\commit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\commit.obj ..\core\commit.c



$O\constart.OBJ:	..\win32\constart.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\constart.obj ..\win32\constart.c



$O\controlc.OBJ:	..\win32\controlc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\controlc.obj ..\win32\controlc.c



$O\coreleft.OBJ:	..\win32\coreleft.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\coreleft.obj ..\win32\coreleft.c



$O\cprintf.OBJ:	..\core\cprintf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\cprintf.obj ..\core\cprintf.c



$O\cputype.OBJ:	..\core32\cputype.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\cputype.obj ..\core32\cputype.c



$O\creat.OBJ:	..\core\creat.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\creat.obj ..\core\creat.c



$O\critical.OBJ:	..\win32\critical.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\critical.obj ..\win32\critical.c



$O\crtinit.OBJ:	..\win32\crtinit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\crtinit.obj ..\win32\crtinit.c



$O\cscanf.OBJ:	..\core\cscanf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\cscanf.obj ..\core\cscanf.c



$O\ctime.OBJ:	..\core\ctime.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ctime.obj ..\core\ctime.c



$O\ctype.OBJ:	..\core\ctype.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ctype.obj ..\core\ctype.c



$O\dclass.OBJ:	..\core32\dclass.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dclass.obj ..\core32\dclass.c



$O\disk.OBJ:	..\core\disk.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\disk.obj ..\core\disk.c



$O\dllopen.OBJ:	..\win32\dllopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dllopen.obj ..\win32\dllopen.c



$O\dllstart.OBJ:	..\win32\dllstart.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dllstart.obj ..\win32\dllstart.c



$O\dosclose.OBJ:	..\win32\dosclose.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dosclose.obj ..\win32\dosclose.c



$O\dosdate.OBJ:	..\win32\dosdate.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dosdate.obj ..\win32\dosdate.c



$O\doserr.OBJ:	..\win32\doserr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\doserr.obj ..\win32\doserr.c



$O\dosopen.OBJ:	..\win32\dosopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\dosopen.obj ..\win32\dosopen.c



$O\ecvt.OBJ:	..\core\ecvt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ecvt.obj ..\core\ecvt.c



$O\eof.OBJ:	..\core\eof.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\eof.obj ..\core\eof.c



$O\exec2.OBJ:	..\win32\exec2.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\exec2.obj ..\win32\exec2.c



$O\execl.OBJ:	..\core\execl.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execl.obj ..\core\execl.c



$O\execle.OBJ:	..\core\execle.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execle.obj ..\core\execle.c



$O\execlp.OBJ:	..\core\execlp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execlp.obj ..\core\execlp.c



$O\execlpe.OBJ:	..\core\execlpe.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execlpe.obj ..\core\execlpe.c



$O\execv.OBJ:	..\core\execv.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execv.obj ..\core\execv.c



$O\execve.OBJ:	..\core\execve.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execve.obj ..\core\execve.c



$O\execvp.OBJ:	..\core\execvp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execvp.obj ..\core\execvp.c



$O\execvpe.OBJ:	..\core\execvpe.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\execvpe.obj ..\core\execvpe.c



$O\exit.OBJ:	..\core\exit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\exit.obj ..\core\exit.c



$O\exitstat.OBJ:	..\core\exitstat.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\exitstat.obj ..\core\exitstat.c



$O\exp.OBJ:	..\core\exp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\exp.obj ..\core\exp.c



$O\expand.OBJ:	..\win32\expand.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\expand.obj ..\win32\expand.c



$O\fatexit.OBJ:	..\core\fatexit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fatexit.obj ..\core\fatexit.c



$O\fclose.OBJ:	..\core\fclose.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fclose.obj ..\core\fclose.c



$O\fcloseal.OBJ:	..\core\fcloseal.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fcloseal.obj ..\core\fcloseal.c



$O\fcvt.OBJ:	..\core\fcvt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fcvt.obj ..\core\fcvt.c



$O\fdivp.OBJ:	..\core\fdivp.c
		$(CC) $(CFLAGS_1) $(DEFINES_1) $(INCLUDES) -o$O\fdivp.obj ..\core\fdivp.c



$O\fdopen.OBJ:	..\core\fdopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fdopen.obj ..\core\fdopen.c



$O\feexcept.OBJ:	..\core\feexcept.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\feexcept.obj ..\core\feexcept.c



$O\fflush.OBJ:	..\core\fflush.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fflush.obj ..\core\fflush.c



$O\fgetchar.OBJ:	..\core\fgetchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fgetchar.obj ..\core\fgetchar.c



$O\fgets.OBJ:	..\core\fgets.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fgets.obj ..\core\fgets.c



$O\filelen.OBJ:	..\win32\filelen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\filelen.obj ..\win32\filelen.c



$O\find.OBJ:	..\win32\find.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\find.obj ..\win32\find.c



$O\floatcvt.OBJ:	..\core\floatcvt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\floatcvt.obj ..\core\floatcvt.c



$O\fltenv.OBJ:	..\core\fltenv.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fltenv.obj ..\core\fltenv.c



$O\fltused.OBJ:	..\core\fltused.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fltused.obj ..\core\fltused.c



$O\flush.OBJ:	..\core\flush.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\flush.obj ..\core\flush.c



$O\flushall.OBJ:	..\core\flushall.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\flushall.obj ..\core\flushall.c



$O\fmacros.OBJ:	..\core\fmacros.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fmacros.obj ..\core\fmacros.c



$O\fmbyte.OBJ:	..\core\fmbyte.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fmbyte.obj ..\core\fmbyte.c



$O\fmt.OBJ:	..\core\fmt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fmt.obj ..\core\fmt.c



$O\fopen.OBJ:	..\core\fopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fopen.obj ..\core\fopen.c



$O\fplock.OBJ:	..\win32\fplock.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fplock.obj ..\win32\fplock.c



$O\fpsig.OBJ:	..\core\fpsig.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fpsig.obj ..\core\fpsig.c



$O\fputchar.OBJ:	..\core\fputchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fputchar.obj ..\core\fputchar.c



$O\fputs.OBJ:	..\core\fputs.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fputs.obj ..\core\fputs.c



$O\fread.OBJ:	..\core\fread.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fread.obj ..\core\fread.c



$O\freopen.OBJ:	..\core\freopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\freopen.obj ..\core\freopen.c



$O\fsopen.OBJ:	..\core\fsopen.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fsopen.obj ..\core\fsopen.c



$O\fwide.OBJ:	..\core\fwide.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fwide.obj ..\core\fwide.c



$O\fwrite.OBJ:	..\core\fwrite.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fwrite.obj ..\core\fwrite.c



$O\gcvt.OBJ:	..\core\gcvt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\gcvt.obj ..\core\gcvt.c



$O\getchar.OBJ:	..\core\getchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\getchar.obj ..\core\getchar.c



$O\getdate.OBJ:	..\win32\getdate.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\getdate.obj ..\win32\getdate.c



$O\getftime.OBJ:	..\win32\getftime.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\getftime.obj ..\win32\getftime.c



$O\getpid.OBJ:	..\core\getpid.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\getpid.obj ..\core\getpid.c



$O\gets.OBJ:	..\core\gets.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\gets.obj ..\core\gets.c



$O\gettime.OBJ:	..\win32\gettime.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\gettime.obj ..\win32\gettime.c



$O\hyper.OBJ:	..\core\hyper.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\hyper.obj ..\core\hyper.c



$O\ieee.OBJ:	..\core\ieee.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ieee.obj ..\core\ieee.c



$O\initmbcp.OBJ:	..\core\initmbcp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\initmbcp.obj ..\core\initmbcp.c



$O\isalnum.OBJ:	..\core\isalnum.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isalnum.obj ..\core\isalnum.c



$O\isalpha.OBJ:	..\core\isalpha.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isalpha.obj ..\core\isalpha.c



$O\isascii.OBJ:	..\core\isascii.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isascii.obj ..\core\isascii.c



$O\isblank.OBJ:	..\core\isblank.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isblank.obj ..\core\isblank.c



$O\iscntrl.OBJ:	..\core\iscntrl.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\iscntrl.obj ..\core\iscntrl.c



$O\iscsym.OBJ:	..\core\iscsym.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\iscsym.obj ..\core\iscsym.c



$O\iscsymf.OBJ:	..\core\iscsymf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\iscsymf.obj ..\core\iscsymf.c



$O\isdigit.OBJ:	..\core\isdigit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isdigit.obj ..\core\isdigit.c



$O\isgraph.OBJ:	..\core\isgraph.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isgraph.obj ..\core\isgraph.c



$O\islower.OBJ:	..\core\islower.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\islower.obj ..\core\islower.c



$O\isprint.OBJ:	..\core\isprint.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isprint.obj ..\core\isprint.c



$O\ispunct.OBJ:	..\core\ispunct.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ispunct.obj ..\core\ispunct.c



$O\isspace.OBJ:	..\core\isspace.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isspace.obj ..\core\isspace.c



$O\isupper.OBJ:	..\core\isupper.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isupper.obj ..\core\isupper.c



$O\isxdigit.OBJ:	..\core\isxdigit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isxdigit.obj ..\core\isxdigit.c



$O\jmp.OBJ:	..\core32\jmp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\jmp.obj ..\core32\jmp.c



$O\lconv.OBJ:	..\core\lconv.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\lconv.obj ..\core\lconv.c



$O\lfind.OBJ:	..\core\lfind.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\lfind.obj ..\core\lfind.c



$O\log.OBJ:	..\core\log.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\log.obj ..\core\log.c



$O\lsearch.OBJ:	..\core\lsearch.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\lsearch.obj ..\core\lsearch.c



$O\matherr.OBJ:	..\core\matherr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\matherr.obj ..\core\matherr.c



$O\mbctype.OBJ:	..\core\mbctype.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\mbctype.obj ..\core\mbctype.c



$O\mbstowcs.OBJ:	..\core\mbstowcs.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\mbstowcs.obj ..\core\mbstowcs.c



$O\mbstring.OBJ:	..\core\mbstring.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\mbstring.obj ..\core\mbstring.c



$O\mbyte.OBJ:	..\core\mbyte.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\mbyte.obj ..\core\mbyte.c



$O\memccpy.OBJ:	..\core\memccpy.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\memccpy.obj ..\core\memccpy.c



$O\memcmp.OBJ:	..\core32\memcmp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\memcmp.obj ..\core32\memcmp.c



$O\memset.OBJ:	..\core32\memset.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\memset.obj ..\core32\memset.c



$O\mktemp.OBJ:	..\core\mktemp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\mktemp.obj ..\core\mktemp.c



$O\okbigbuf.OBJ:	..\core\okbigbuf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\okbigbuf.obj ..\core\okbigbuf.c



$O\onexit.OBJ:	..\core\onexit.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\onexit.obj ..\core\onexit.c



$O\perror.OBJ:	..\core\perror.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\perror.obj ..\core\perror.c



$O\poly.OBJ:	..\core\poly.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\poly.obj ..\core\poly.c



$O\pow.OBJ:	..\core\pow.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\pow.obj ..\core\pow.c



$O\printf.OBJ:	..\core\printf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\printf.obj ..\core\printf.c



$O\putchar.OBJ:	..\core\putchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\putchar.obj ..\core\putchar.c



$O\puts.OBJ:	..\core\puts.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\puts.obj ..\core\puts.c



$O\qsort.OBJ:	..\core\qsort.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\qsort.obj ..\core\qsort.c



$O\rand.OBJ:	..\core\rand.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\rand.obj ..\core\rand.c



$O\response.OBJ:	..\core\response.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\response.obj ..\core\response.c



$O\rmtmp.OBJ:	..\core\rmtmp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\rmtmp.obj ..\core\rmtmp.c



$O\round.OBJ:	..\core\round.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\round.obj ..\core\round.c



$O\scanf.OBJ:	..\core\scanf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\scanf.obj ..\core\scanf.c



$O\semlock.OBJ:	..\win32\semlock.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\semlock.obj ..\win32\semlock.c



$O\setargv.OBJ:	..\win32\setargv.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setargv.obj ..\win32\setargv.c



$O\seterrno.OBJ:	..\core\seterrno.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\seterrno.obj ..\core\seterrno.c



$O\setjmp.OBJ:	..\core\setjmp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setjmp.obj ..\core\setjmp.c



$O\setlc.OBJ:	..\core\setlc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setlc.obj ..\core\setlc.c



$O\setmbcp.OBJ:	..\core\setmbcp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setmbcp.obj ..\core\setmbcp.c



$O\setmode.OBJ:	..\core\setmode.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setmode.obj ..\core\setmode.c



$O\setnterr.OBJ:	..\win32\setnterr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\setnterr.obj ..\win32\setnterr.c



$O\signal.OBJ:	..\core\signal.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\signal.obj ..\core\signal.c



$O\sin.OBJ:	..\core\sin.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\sin.obj ..\core\sin.c



$O\sleep.OBJ:	..\core\sleep.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\sleep.obj ..\core\sleep.c



$O\sopenf.OBJ:	..\core\sopenf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\sopenf.obj ..\core\sopenf.c



$O\sound.OBJ:	..\win32\sound.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\sound.obj ..\win32\sound.c



$O\spawn.OBJ:	..\core\spawn.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawn.obj ..\core\spawn.c



$O\spawnl.OBJ:	..\core\spawnl.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnl.obj ..\core\spawnl.c



$O\spawnle.OBJ:	..\core\spawnle.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnle.obj ..\core\spawnle.c



$O\spawnlp.OBJ:	..\core\spawnlp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnlp.obj ..\core\spawnlp.c



$O\spawnlpe.OBJ:	..\core\spawnlpe.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnlpe.obj ..\core\spawnlpe.c



$O\spawnv.OBJ:	..\core\spawnv.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnv.obj ..\core\spawnv.c



$O\spawnve.OBJ:	..\core\spawnve.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnve.obj ..\core\spawnve.c



$O\spawnvp.OBJ:	..\core\spawnvp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnvp.obj ..\core\spawnvp.c



$O\spawnvpe.OBJ:	..\core\spawnvpe.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\spawnvpe.obj ..\core\spawnvpe.c



$O\splitpat.OBJ:	..\core\splitpat.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\splitpat.obj ..\core\splitpat.c



$O\sqrt.OBJ:	..\core\sqrt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\sqrt.obj ..\core\sqrt.c



$O\stack.OBJ:	..\core\stack.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\stack.obj ..\core\stack.c



$O\stckaval.OBJ:	..\core32\stckaval.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\stckaval.obj ..\core32\stckaval.c



$O\strcspn.OBJ:	..\core\strcspn.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strcspn.obj ..\core\strcspn.c



$O\strdup.OBJ:	..\core\strdup.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strdup.obj ..\core\strdup.c



$O\strerror.OBJ:	..\core\strerror.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strerror.obj ..\core\strerror.c



$O\strf.OBJ:	..\core\strf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strf.obj ..\core\strf.c



$O\strfunc.OBJ:	..\core32\strfunc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strfunc.obj ..\core32\strfunc.c



$O\strlwr.OBJ:	..\core\strlwr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strlwr.obj ..\core\strlwr.c



$O\strnset.OBJ:	..\core\strnset.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strnset.obj ..\core\strnset.c



$O\strrev.OBJ:	..\core\strrev.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strrev.obj ..\core\strrev.c



$O\strset.OBJ:	..\core\strset.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strset.obj ..\core\strset.c



$O\strspn.OBJ:	..\core\strspn.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strspn.obj ..\core\strspn.c



$O\strstr.OBJ:	..\core\strstr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strstr.obj ..\core\strstr.c



$O\strtod.OBJ:	..\core\strtod.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strtod.obj ..\core\strtod.c



$O\strtof.OBJ:	..\core\strtof.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strtof.obj ..\core\strtof.c



$O\strtok.OBJ:	..\core32\strtok.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strtok.obj ..\core32\strtok.c



$O\strtol.OBJ:	..\core\strtol.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strtol.obj ..\core\strtol.c



$O\strtoull.OBJ:	..\core32\strtoull.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strtoull.obj ..\core32\strtoull.c



$O\strupr.OBJ:	..\core\strupr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strupr.obj ..\core\strupr.c



$O\strxfrm.OBJ:	..\core\strxfrm.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\strxfrm.obj ..\core\strxfrm.c



$O\swab.OBJ:	..\core\swab.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\swab.obj ..\core\swab.c



$O\system.OBJ:	..\core\system.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\system.obj ..\core\system.c



$O\tabsize.OBJ:	..\core\tabsize.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tabsize.obj ..\core\tabsize.c



$O\tan.OBJ:	..\core\tan.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tan.obj ..\core\tan.c



$O\tchar.OBJ:	..\core\tchar.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tchar.obj ..\core\tchar.c



$O\thunk.OBJ:	..\win32\thunk.cpp
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -H- -o$O\thunk.obj ..\win32\thunk.cpp



$O\time3.OBJ:	..\core\time3.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\time3.obj ..\core\time3.c



$O\tlsdata.OBJ:	..\win32\tlsdata.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tlsdata.obj ..\win32\tlsdata.c



$O\tmpnam.OBJ:	..\core\tmpnam.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tmpnam.obj ..\core\tmpnam.c



$O\toascii.OBJ:	..\core\toascii.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\toascii.obj ..\core\toascii.c



$O\tolower.OBJ:	..\core\tolower.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\tolower.obj ..\core\tolower.c



$O\trigerr.OBJ:	..\core\trigerr.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\trigerr.obj ..\core\trigerr.c



$O\umask.OBJ:	..\core\umask.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\umask.obj ..\core\umask.c



$O\ungetc.OBJ:	..\core\ungetc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ungetc.obj ..\core\ungetc.c



$O\unlink.OBJ:	..\win32\unlink.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\unlink.obj ..\win32\unlink.c



$O\unmangle.OBJ:	..\core\unmangle.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\unmangle.obj ..\core\unmangle.c



$O\utime.OBJ:	..\win32\utime.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\utime.obj ..\win32\utime.c



$O\vprintf.OBJ:	..\core\vprintf.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\vprintf.obj ..\core\vprintf.c



$O\w32sver.OBJ:	..\win32\w32sver.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\w32sver.obj ..\win32\w32sver.c



$O\winstart.OBJ:	..\win32\winstart.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\winstart.obj ..\win32\winstart.c



$O\xcfilter.OBJ:	..\win32\xcfilter.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\xcfilter.obj ..\win32\xcfilter.c



$O\disp.OBJ:	..\win32\disp.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\disp.obj ..\win32\disp.c



$O\scver.OBJ:	..\core\scver.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\scver.obj ..\core\scver.c



$O\alloca.OBJ:	..\core\alloca.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\alloca.obj ..\core\alloca.c



$O\purevirt.OBJ:	..\core\purevirt.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\purevirt.obj ..\core\purevirt.c



$O\VEDBGHK.OBJ:	..\win32\VEDBGHK.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\VEDBGHK.obj ..\win32\VEDBGHK.C



$O\_ALLOCA.OBJ:	..\core\_ALLOCA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ALLOCA.obj ..\core\_ALLOCA.C



$O\decdata.OBJ:	..\core\decdata.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\decdata.obj ..\core\decdata.c



$O\fgetwc.OBJ:	..\core\fgetwc.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fgetwc.obj ..\core\fgetwc.c



$O\fgetws.OBJ:	..\core\fgetws.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\fgetws.obj ..\core\fgetws.c



$O\flushwbu.OBJ:	..\core\flushwbu.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\flushwbu.obj ..\core\flushwbu.c



$O\FPUTWC.OBJ:	..\core\FPUTWC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\FPUTWC.obj ..\core\FPUTWC.C



$O\FPUTWS.OBJ:	..\core\FPUTWS.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\FPUTWS.obj ..\core\FPUTWS.C



$O\getws.OBJ:	..\core\getws.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\getws.obj ..\core\getws.c



$O\isctype.OBJ:	..\core\isctype.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\isctype.obj ..\core\isctype.c



$O\iswctype.OBJ:	..\core\iswctype.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\iswctype.obj ..\core\iswctype.c



$O\ITOW.OBJ:	..\core32\ITOW.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ITOW.obj ..\core32\ITOW.C



$O\LCAPI32.OBJ:	..\core\LCAPI32.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCAPI32.obj ..\core\LCAPI32.C



$O\LCCRTDR.OBJ:	..\core\LCCRTDR.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCCRTDR.obj ..\core\LCCRTDR.C



$O\LCCRTFL.OBJ:	..\core\LCCRTFL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCCRTFL.obj ..\core\LCCRTFL.C



$O\LCCRTPC.OBJ:	..\core\LCCRTPC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCCRTPC.obj ..\core\LCCRTPC.C



$O\LCDELFL.OBJ:	..\core\LCDELFL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCDELFL.obj ..\core\LCDELFL.C



$O\LCFNDFL.OBJ:	..\core\LCFNDFL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCFNDFL.obj ..\core\LCFNDFL.C



$O\LCGETCD.OBJ:	..\core\LCGETCD.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCGETCD.obj ..\core\LCGETCD.C



$O\LCGETCL.OBJ:	..\core\LCGETCL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCGETCL.obj ..\core\LCGETCL.C



$O\LCGETFA.OBJ:	..\core\LCGETFA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCGETFA.obj ..\core\LCGETFA.C



$O\LCGETMF.OBJ:	..\core\LCGETMF.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCGETMF.obj ..\core\LCGETMF.C



$O\LCMOVFL.OBJ:	..\core\LCMOVFL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCMOVFL.obj ..\core\LCMOVFL.C



$O\LCRMVDR.OBJ:	..\core\LCRMVDR.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCRMVDR.obj ..\core\LCRMVDR.C



$O\LCSETCD.OBJ:	..\core\LCSETCD.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCSETCD.obj ..\core\LCSETCD.C



$O\LCSETFA.OBJ:	..\core\LCSETFA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LCSETFA.obj ..\core\LCSETFA.C



$O\LTOW.OBJ:	..\core32\LTOW.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\LTOW.obj ..\core32\LTOW.C



$O\MBTOWC.OBJ:	..\core\MBTOWC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBTOWC.obj ..\core\MBTOWC.C



$O\NLSDATA.OBJ:	..\core\NLSDATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\NLSDATA.obj ..\core\NLSDATA.C



$O\NULDATA.OBJ:	..\core\NULDATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\NULDATA.obj ..\core\NULDATA.C



$O\PUTWS.OBJ:	..\core\PUTWS.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\PUTWS.obj ..\core\PUTWS.C



$O\SETCHARS.OBJ:	..\core\SETCHARS.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\SETCHARS.obj ..\core\SETCHARS.C



$O\STRCOLL.OBJ:	..\core\STRCOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\STRCOLL.obj ..\core\STRCOLL.C



$O\STRICOLL.OBJ:	..\core\STRICOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\STRICOLL.obj ..\core\STRICOLL.C



$O\STRNCOLL.OBJ:	..\core\STRNCOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\STRNCOLL.obj ..\core\STRNCOLL.C



$O\STRNICOL.OBJ:	..\core\STRNICOL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\STRNICOL.obj ..\core\STRNICOL.C



$O\TIMDATA.OBJ:	..\core\TIMDATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\TIMDATA.obj ..\core\TIMDATA.C



$O\TNODATA.OBJ:	..\core\TNODATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\TNODATA.obj ..\core\TNODATA.C



$O\TOWUPPER.OBJ:	..\core\TOWUPPER.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\TOWUPPER.obj ..\core\TOWUPPER.C



$O\ULTOW.OBJ:	..\core32\ULTOW.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ULTOW.obj ..\core32\ULTOW.C



$O\UNGETWC.OBJ:	..\core\UNGETWC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\UNGETWC.obj ..\core\UNGETWC.C



$O\_ISMBSLD.OBJ:	..\CORE\_ISMBSLD.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ISMBSLD.obj ..\CORE\_ISMBSLD.C



$O\_ISMBSTL.OBJ:	..\CORE\_ISMBSTL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\_ISMBSTL.obj ..\CORE\_ISMBSTL.C



$O\ISMBALNU.OBJ:	..\CORE\ISMBALNU.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBALNU.obj ..\CORE\ISMBALNU.C



$O\ISMBALPH.OBJ:	..\CORE\ISMBALPH.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBALPH.obj ..\CORE\ISMBALPH.C



$O\ISMBBYTE.OBJ:	..\CORE\ISMBBYTE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBBYTE.obj ..\CORE\ISMBBYTE.C



$O\ISMBCL0.OBJ:	..\CORE\ISMBCL0.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBCL0.obj ..\CORE\ISMBCL0.C



$O\ISMBCL1.OBJ:	..\CORE\ISMBCL1.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBCL1.obj ..\CORE\ISMBCL1.C



$O\ISMBCL2.OBJ:	..\CORE\ISMBCL2.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBCL2.obj ..\CORE\ISMBCL2.C



$O\ISMBDIGI.OBJ:	..\CORE\ISMBDIGI.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBDIGI.obj ..\CORE\ISMBDIGI.C



$O\ISMBGRAP.OBJ:	..\CORE\ISMBGRAP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBGRAP.obj ..\CORE\ISMBGRAP.C



$O\ISMBHIRA.OBJ:	..\CORE\ISMBHIRA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBHIRA.obj ..\CORE\ISMBHIRA.C



$O\ISMBKATA.OBJ:	..\CORE\ISMBKATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBKATA.obj ..\CORE\ISMBKATA.C



$O\ISMBLEGA.OBJ:	..\CORE\ISMBLEGA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBLEGA.obj ..\CORE\ISMBLEGA.C



$O\ISMBLOWE.OBJ:	..\CORE\ISMBLOWE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBLOWE.obj ..\CORE\ISMBLOWE.C



$O\ISMBPRIN.OBJ:	..\CORE\ISMBPRIN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBPRIN.obj ..\CORE\ISMBPRIN.C



$O\ISMBPUNC.OBJ:	..\CORE\ISMBPUNC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBPUNC.obj ..\CORE\ISMBPUNC.C



$O\ISMBSPAC.OBJ:	..\CORE\ISMBSPAC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBSPAC.obj ..\CORE\ISMBSPAC.C



$O\ISMBSYMB.OBJ:	..\CORE\ISMBSYMB.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBSYMB.obj ..\CORE\ISMBSYMB.C



$O\ISMBUPPE.OBJ:	..\CORE\ISMBUPPE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\ISMBUPPE.obj ..\CORE\ISMBUPPE.C



$O\MBBTOMBC.OBJ:	..\CORE\MBBTOMBC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBBTOMBC.obj ..\CORE\MBBTOMBC.C



$O\MBBTYPE.OBJ:	..\CORE\MBBTYPE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBBTYPE.obj ..\CORE\MBBTYPE.C



$O\MBCCPY.OBJ:	..\CORE\MBCCPY.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBCCPY.obj ..\CORE\MBCCPY.C



$O\MBCLEN.OBJ:	..\CORE\MBCLEN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBCLEN.obj ..\CORE\MBCLEN.C



$O\MBCPINFO.OBJ:	..\CORE\MBCPINFO.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBCPINFO.obj ..\CORE\MBCPINFO.C



$O\MBJISJMS.OBJ:	..\CORE\MBJISJMS.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBJISJMS.obj ..\CORE\MBJISJMS.C



$O\MBJMSJIS.OBJ:	..\CORE\MBJMSJIS.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBJMSJIS.obj ..\CORE\MBJMSJIS.C



$O\MBLEN.OBJ:	..\CORE\MBLEN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBLEN.obj ..\CORE\MBLEN.C



$O\MBSBTYPE.OBJ:	..\CORE\MBSBTYPE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSBTYPE.obj ..\CORE\MBSBTYPE.C



$O\MBSCMP.OBJ:	..\CORE\MBSCMP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSCMP.obj ..\CORE\MBSCMP.C



$O\MBSCOLL.OBJ:	..\CORE\MBSCOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSCOLL.obj ..\CORE\MBSCOLL.C



$O\MBSCSPN.OBJ:	..\CORE\MBSCSPN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSCSPN.obj ..\CORE\MBSCSPN.C



$O\MBSDEC.OBJ:	..\CORE\MBSDEC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSDEC.obj ..\CORE\MBSDEC.C



$O\MBSICOLL.OBJ:	..\CORE\MBSICOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSICOLL.obj ..\CORE\MBSICOLL.C



$O\MBSINC.OBJ:	..\CORE\MBSINC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSINC.obj ..\CORE\MBSINC.C



$O\MBSLEN.OBJ:	..\CORE\MBSLEN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSLEN.obj ..\CORE\MBSLEN.C



$O\MBSLWR.OBJ:	..\CORE\MBSLWR.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSLWR.obj ..\CORE\MBSLWR.C



$O\MBSNBCAT.OBJ:	..\CORE\MBSNBCAT.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBCAT.obj ..\CORE\MBSNBCAT.C



$O\MBSNBCMP.OBJ:	..\CORE\MBSNBCMP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBCMP.obj ..\CORE\MBSNBCMP.C



$O\MBSNBCNT.OBJ:	..\CORE\MBSNBCNT.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBCNT.obj ..\CORE\MBSNBCNT.C



$O\MBSNBCOL.OBJ:	..\CORE\MBSNBCOL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBCOL.obj ..\CORE\MBSNBCOL.C



$O\MBSNBCPY.OBJ:	..\CORE\MBSNBCPY.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBCPY.obj ..\CORE\MBSNBCPY.C



$O\MBSNBICO.OBJ:	..\CORE\MBSNBICO.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBICO.obj ..\CORE\MBSNBICO.C



$O\MBSNBSET.OBJ:	..\CORE\MBSNBSET.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNBSET.obj ..\CORE\MBSNBSET.C



$O\MBSNCAT.OBJ:	..\CORE\MBSNCAT.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNCAT.obj ..\CORE\MBSNCAT.C



$O\MBSNCCNT.OBJ:	..\CORE\MBSNCCNT.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNCCNT.obj ..\CORE\MBSNCCNT.C



$O\MBSNCMP.OBJ:	..\CORE\MBSNCMP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNCMP.obj ..\CORE\MBSNCMP.C



$O\MBSNCOLL.OBJ:	..\CORE\MBSNCOLL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNCOLL.obj ..\CORE\MBSNCOLL.C



$O\MBSNCPY.OBJ:	..\CORE\MBSNCPY.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNCPY.obj ..\CORE\MBSNCPY.C



$O\MBSNEXTC.OBJ:	..\CORE\MBSNEXTC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNEXTC.obj ..\CORE\MBSNEXTC.C



$O\MBSNICMP.OBJ:	..\CORE\MBSNICMP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNICMP.obj ..\CORE\MBSNICMP.C



$O\MBSNICOL.OBJ:	..\CORE\MBSNICOL.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNICOL.obj ..\CORE\MBSNICOL.C



$O\MBSNINC.OBJ:	..\CORE\MBSNINC.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNINC.obj ..\CORE\MBSNINC.C



$O\MBSNSET.OBJ:	..\CORE\MBSNSET.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSNSET.obj ..\CORE\MBSNSET.C



$O\MBSREV.OBJ:	..\CORE\MBSREV.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSREV.obj ..\CORE\MBSREV.C



$O\MBSSET.OBJ:	..\CORE\MBSSET.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSSET.obj ..\CORE\MBSSET.C



$O\MBSSPN.OBJ:	..\CORE\MBSSPN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSSPN.obj ..\CORE\MBSSPN.C



$O\MBSSPNP.OBJ:	..\CORE\MBSSPNP.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSSPNP.obj ..\CORE\MBSSPNP.C



$O\MBSSTR.OBJ:	..\CORE\MBSSTR.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSSTR.obj ..\CORE\MBSSTR.C



$O\MBSTOK.OBJ:	..\CORE\MBSTOK.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSTOK.obj ..\CORE\MBSTOK.C



$O\MBSTRLEN.OBJ:	..\CORE\MBSTRLEN.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSTRLEN.obj ..\CORE\MBSTRLEN.C



$O\MBSUPR.OBJ:	..\CORE\MBSUPR.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBSUPR.obj ..\CORE\MBSUPR.C



$O\MBTOHIRA.OBJ:	..\CORE\MBTOHIRA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBTOHIRA.obj ..\CORE\MBTOHIRA.C



$O\MBTOKATA.OBJ:	..\CORE\MBTOKATA.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBTOKATA.obj ..\CORE\MBTOKATA.C



$O\MBTOLOWE.OBJ:	..\CORE\MBTOLOWE.C
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\MBTOLOWE.obj ..\CORE\MBTOLOWE.C



$O\w32fater.OBJ:	..\win32\w32fater.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\w32fater.obj ..\win32\w32fater.c


$O\wmem.obj:	..\core\wmem.c
		$(CC) $(CFLAGS) $(DEFINES) $(INCLUDES) -o$O\wmem.obj ..\core\wmem.c


$(SYMROOT).SYM: ..\include\precomp.h
	$(CC) $(HFLAGS) $(DEFINES) $(INCLUDES) -HF$(SYMROOT).SYM -o$(SYMROOT).PCO ..\include\precomp.h



