# Makefile to build D runtime library phobos64.lib for Win64
# Prerequisites:
#	Microsoft Visual Studio
# Targets:
#	make
#		Same as make unittest
#	make phobos64.lib
#		Build phobos64.lib
#	make clean
#		Delete unneeded files created by build process
#	make unittest
#		Build phobos64.lib, build and run unit tests
#	make phobos32mscoff
#		Build phobos32mscoff.lib
#	make unittest32mscoff
#		Build phobos32mscoff.lib, build and run unit tests
#	make cov
#		Build for coverage tests, run coverage tests
#	make html
#		Build documentation

## Memory model (32 or 64)
MODEL=64

## Copy command

CP=cp

## Directory where dmd has been installed

DIR=\dmd2

## Visual C directories
VCDIR=\Program Files (x86)\Microsoft Visual Studio 10.0\VC
SDKDIR=\Program Files (x86)\Microsoft SDKs\Windows\v7.0A

## Flags for VC compiler

#CFLAGS=/Zi /nologo /I"$(VCDIR)\INCLUDE" /I"$(SDKDIR)\Include"
CFLAGS=/O2 /nologo /I"$(VCDIR)\INCLUDE" /I"$(SDKDIR)\Include"

## Location of druntime tree

DRUNTIME=..\druntime
DRUNTIMELIB=$(DRUNTIME)\lib\druntime$(MODEL).lib

## Flags for dmd D compiler

DFLAGS=-conf= -m$(MODEL) -O -release -w -dip25 -I$(DRUNTIME)\import
#DFLAGS=-m$(MODEL) -unittest -g
#DFLAGS=-m$(MODEL) -unittest -cov -g

## Flags for compiling unittests

UDFLAGS=-conf= -g -m$(MODEL) -O -w -dip25 -I$(DRUNTIME)\import

## C compiler, linker, librarian

CC="$(VCDIR)\bin\amd64\cl"
LD="$(VCDIR)\bin\amd64\link"
AR="$(VCDIR)\bin\amd64\lib"
MAKE=make

## D compiler

DMD=$(DIR)\bin\dmd
#DMD=..\dmd
DMD=dmd

## Location of where to write the html documentation files

DOCSRC = ../dlang.org
STDDOC = $(DOCSRC)/html.ddoc $(DOCSRC)/dlang.org.ddoc $(DOCSRC)/std.ddoc $(DOCSRC)/macros.ddoc $(DOCSRC)/std_navbar-prerelease.ddoc project.ddoc

DOC=..\..\html\d\phobos
#DOC=..\doc\phobos

## Zlib library

ZLIB=etc\c\zlib\zlib$(MODEL).lib

.c.obj:
	$(CC) -c $(CFLAGS) $*.c

.cpp.obj:
	$(CC) -c $(CFLAGS) $*.cpp

.d.obj:
	$(DMD) -c $(DFLAGS) $*

.asm.obj:
	$(CC) -c $*

LIB=phobos$(MODEL).lib

targets : $(LIB)

test : test.exe

test.obj : test.d
	$(DMD) -conf= -c -m$(MODEL) test -g -unittest

test.exe : test.obj $(LIB)
	$(DMD) -conf= test.obj -m$(MODEL) -g -L/map

#	ti_bit.obj ti_Abit.obj

# The separation is a workaround for bug 4904 (optlink bug 3372).
# SRCS_1 is the heavyweight modules which are most likely to trigger the bug.
# Do not add any more modules to SRCS_1.
SRC_STD_1_HEAVY= std\stdio.d std\stdiobase.d \
	std\string.d std\format.d \
	std\file.d

SRC_STD_2a_HEAVY= std\array.d std\functional.d std\path.d std\outbuffer.d std\utf.d

SRC_STD_math=std\math.d
SRC_STD_3= std\csv.d std\complex.d std\numeric.d std\bigint.d
SRC_STD_3c= std\datetime.d std\bitmanip.d std\typecons.d

SRC_STD_3a= std\uni.d std\base64.d std\ascii.d \
	std\demangle.d std\uri.d std\metastrings.d std\mmfile.d std\getopt.d

SRC_STD_3b= std\signals.d std\meta.d std\typetuple.d std\traits.d \
	std\encoding.d std\xml.d \
	std\random.d \
	std\exception.d \
	std\compiler.d \
	std\system.d std\concurrency.d std\concurrencybase.d

#can't place SRC_STD_DIGEST in SRC_STD_REST because of out-of-memory issues
SRC_STD_DIGEST= std\digest\crc.d std\digest\sha.d std\digest\md.d \
	std\digest\ripemd.d std\digest\digest.d std\digest\hmac.d

SRC_STD_CONTAINER= std\container\array.d std\container\binaryheap.d \
	std\container\dlist.d std\container\rbtree.d std\container\slist.d \
	std\container\util.d std\container\package.d

SRC_STD_4= std\uuid.d $(SRC_STD_DIGEST)

SRC_STD_ALGO_1=std\algorithm\package.d std\algorithm\comparison.d \
	std\algorithm\iteration.d std\algorithm\mutation.d
SRC_STD_ALGO_2=std\algorithm\searching.d std\algorithm\setops.d \
	std\algorithm\sorting.d std\algorithm\internal.d
SRC_STD_ALGO=$(SRC_STD_ALGO_1) $(SRC_STD_ALGO_2)

SRC_STD_LOGGER= std\experimental\logger\core.d std\experimental\logger\filelogger.d \
	std\experimental\logger\multilogger.d std\experimental\logger\nulllogger.d \
	std\experimental\logger\package.d

SRC_STD_ALLOC_BB= std\experimental\allocator\building_blocks\affix_allocator.d \
	std\experimental\allocator\building_blocks\allocator_list.d \
	std\experimental\allocator\building_blocks\bitmapped_block.d \
	std\experimental\allocator\building_blocks\bucketizer.d \
	std\experimental\allocator\building_blocks\fallback_allocator.d \
	std\experimental\allocator\building_blocks\free_list.d \
	std\experimental\allocator\building_blocks\free_tree.d \
	std\experimental\allocator\building_blocks\kernighan_ritchie.d \
	std\experimental\allocator\building_blocks\null_allocator.d \
	std\experimental\allocator\building_blocks\quantizer.d \
	std\experimental\allocator\building_blocks\region.d \
	std\experimental\allocator\building_blocks\scoped_allocator.d \
	std\experimental\allocator\building_blocks\segregator.d \
	std\experimental\allocator\building_blocks\stats_collector.d \
	std\experimental\allocator\building_blocks\package.d

SRC_STD_ALLOC= std\experimental\allocator\common.d std\experimental\allocator\gc_allocator.d \
	std\experimental\allocator\mallocator.d std\experimental\allocator\mmap_allocator.d \
	std\experimental\allocator\showcase.d std\experimental\allocator\typed.d \
	std\experimental\allocator\package.d \
	$(SRC_STD_ALLOC_BB)

SRC_STD_5a=$(SRC_STD_ALGO_1)
SRC_STD_5b=$(SRC_STD_ALGO_2)

SRC_STD_6a=std\variant.d
SRC_STD_6b=std\syserror.d
SRC_STD_6c=std\zlib.d
SRC_STD_6d=std\stream.d
SRC_STD_6e=std\socket.d
SRC_STD_6f=std\socketstream.d
SRC_STD_6h=std\conv.d
SRC_STD_6i=std\zip.d
SRC_STD_6j=std\cstream.d

SRC_STD_7= \
	std\stdint.d \
	std\json.d \
	std\parallelism.d \
	std\mathspecial.d \
	std\process.d

SRC_STD_ALL= $(SRC_STD_1_HEAVY) $(SRC_STD_2a_HEAVY) \
	$(SRC_STD_math) \
	$(SRC_STD_3) $(SRC_STD_3a) $(SRC_STD_3b) $(SRC_STD_3c) $(SRC_STD_4) \
	$(SRC_STD_6a) \
	$(SRC_STD_6b) \
	$(SRC_STD_6c) \
	$(SRC_STD_6d) \
	$(SRC_STD_6e) \
	$(SRC_STD_6f) \
	$(SRC_STD_CONTAINER) \
	$(SRC_STD_6h) \
	$(SRC_STD_6i) \
	$(SRC_STD_6j) \
	$(SRC_STD_7) \
	$(SRC_STD_LOGGER) \
	$(SRC_STD_ALLOC)

SRC=	unittest.d index.d

SRC_STD= std\zlib.d std\zip.d std\stdint.d std\conv.d std\utf.d std\uri.d \
	std\math.d std\string.d std\path.d std\datetime.d \
	std\csv.d std\file.d std\compiler.d std\system.d \
	std\outbuffer.d std\base64.d \
	std\meta.d std\metastrings.d std\mmfile.d \
	std\syserror.d \
	std\random.d std\stream.d std\process.d \
	std\socket.d std\socketstream.d std\format.d \
	std\stdio.d std\uni.d std\uuid.d \
	std\cstream.d std\demangle.d \
	std\signals.d std\typetuple.d std\traits.d \
	std\getopt.d \
	std\variant.d std\numeric.d std\bitmanip.d std\complex.d std\mathspecial.d \
	std\functional.d std\array.d std\typecons.d \
	std\json.d std\xml.d std\encoding.d std\bigint.d std\concurrency.d \
	std\concurrencybase.d std\stdiobase.d std\parallelism.d \
	std\exception.d std\ascii.d

SRC_STD_REGEX= std\regex\internal\ir.d std\regex\package.d std\regex\internal\parser.d \
	std\regex\internal\tests.d std\regex\internal\backtracking.d \
	std\regex\internal\thompson.d std\regex\internal\kickstart.d \
	std\regex\internal\generator.d

SRC_STD_RANGE= std\range\package.d std\range\primitives.d \
	std\range\interfaces.d

SRC_STD_NET= std\net\isemail.d std\net\curl.d

SRC_STD_C= std\c\process.d std\c\stdlib.d std\c\time.d std\c\stdio.d \
	std\c\math.d std\c\stdarg.d std\c\stddef.d std\c\fenv.d std\c\string.d \
	std\c\locale.d std\c\wcharh.d

SRC_STD_WIN= std\windows\registry.d \
	std\windows\iunknown.d std\windows\syserror.d std\windows\charset.d

SRC_STD_C_WIN= std\c\windows\windows.d std\c\windows\com.d \
	std\c\windows\winsock.d std\c\windows\stat.d

SRC_STD_C_LINUX= std\c\linux\linux.d \
	std\c\linux\socket.d std\c\linux\pthread.d std\c\linux\termios.d \
	std\c\linux\tipc.d

SRC_STD_C_OSX= std\c\osx\socket.d

SRC_STD_C_FREEBSD= std\c\freebsd\socket.d

SRC_STD_INTERNAL= std\internal\cstring.d std\internal\processinit.d \
	std\internal\unicode_tables.d std\internal\unicode_comp.d std\internal\unicode_decomp.d \
	std\internal\unicode_grapheme.d std\internal\unicode_norm.d std\internal\scopebuffer.d \
	std\internal\test\dummyrange.d

SRC_STD_INTERNAL_DIGEST= std\internal\digest\sha_SSSE3.d

SRC_STD_INTERNAL_MATH= std\internal\math\biguintcore.d \
	std\internal\math\biguintnoasm.d std\internal\math\biguintx86.d \
	std\internal\math\gammafunction.d std\internal\math\errorfunction.d

SRC_STD_INTERNAL_WINDOWS= std\internal\windows\advapi32.d

SRC_ETC=

SRC_ETC_C= etc\c\zlib.d etc\c\curl.d etc\c\sqlite3.d \
    etc\c\odbc\sql.d etc\c\odbc\sqlext.d etc\c\odbc\sqltypes.d etc\c\odbc\sqlucode.d

SRC_TO_COMPILE_NOT_STD= \
	$(SRC_STD_REGEX) \
	$(SRC_STD_NET) \
	$(SRC_STD_C) \
	$(SRC_STD_WIN) \
	$(SRC_STD_C_WIN) \
	$(SRC_STD_INTERNAL) \
	$(SRC_STD_INTERNAL_DIGEST) \
	$(SRC_STD_INTERNAL_MATH) \
	$(SRC_STD_INTERNAL_WINDOWS) \
	$(SRC_ETC) \
	$(SRC_ETC_C)

SRC_TO_COMPILE= $(SRC_STD_ALL) \
	$(SRC_STD_ALGO) \
	$(SRC_STD_RANGE) \
	$(SRC_TO_COMPILE_NOT_STD)

SRC_ZLIB= \
	etc\c\zlib\crc32.h \
	etc\c\zlib\deflate.h \
	etc\c\zlib\gzguts.h \
	etc\c\zlib\inffixed.h \
	etc\c\zlib\inffast.h \
	etc\c\zlib\inftrees.h \
	etc\c\zlib\inflate.h \
	etc\c\zlib\trees.h \
	etc\c\zlib\zconf.h \
	etc\c\zlib\zlib.h \
	etc\c\zlib\zutil.h \
	etc\c\zlib\adler32.c \
	etc\c\zlib\compress.c \
	etc\c\zlib\crc32.c \
	etc\c\zlib\deflate.c \
	etc\c\zlib\example.c \
	etc\c\zlib\gzclose.c \
	etc\c\zlib\gzlib.c \
	etc\c\zlib\gzread.c \
	etc\c\zlib\gzwrite.c \
	etc\c\zlib\infback.c \
	etc\c\zlib\inffast.c \
	etc\c\zlib\inflate.c \
	etc\c\zlib\inftrees.c \
	etc\c\zlib\minigzip.c \
	etc\c\zlib\trees.c \
	etc\c\zlib\uncompr.c \
	etc\c\zlib\zutil.c \
	etc\c\zlib\algorithm.txt \
	etc\c\zlib\zlib.3 \
	etc\c\zlib\ChangeLog \
	etc\c\zlib\README \
	etc\c\zlib\win32.mak \
	etc\c\zlib\win64.mak \
	etc\c\zlib\linux.mak \
	etc\c\zlib\osx.mak


DOCS=	$(DOC)\object.html \
	$(DOC)\core_atomic.html \
	$(DOC)\core_bitop.html \
	$(DOC)\core_exception.html \
	$(DOC)\core_memory.html \
	$(DOC)\core_runtime.html \
	$(DOC)\core_simd.html \
	$(DOC)\core_time.html \
	$(DOC)\core_thread.html \
	$(DOC)\core_vararg.html \
	$(DOC)\core_sync_barrier.html \
	$(DOC)\core_sync_condition.html \
	$(DOC)\core_sync_config.html \
	$(DOC)\core_sync_exception.html \
	$(DOC)\core_sync_mutex.html \
	$(DOC)\core_sync_rwmutex.html \
	$(DOC)\core_sync_semaphore.html \
	$(DOC)\std_algorithm.html \
	$(DOC)\std_algorithm_comparison.html \
	$(DOC)\std_algorithm_iteration.html \
	$(DOC)\std_algorithm_mutation.html \
	$(DOC)\std_algorithm_searching.html \
	$(DOC)\std_algorithm_setops.html \
	$(DOC)\std_algorithm_sorting.html \
	$(DOC)\std_array.html \
	$(DOC)\std_ascii.html \
	$(DOC)\std_base64.html \
	$(DOC)\std_bigint.html \
	$(DOC)\std_bitmanip.html \
	$(DOC)\std_concurrency.html \
	$(DOC)\std_compiler.html \
	$(DOC)\std_complex.html \
	$(DOC)\std_container_array.html \
	$(DOC)\std_container_binaryheap.html \
	$(DOC)\std_container_dlist.html \
	$(DOC)\std_container_rbtree.html \
	$(DOC)\std_container_slist.html \
	$(DOC)\std_container.html \
	$(DOC)\std_container_util.html \
	$(DOC)\std_conv.html \
	$(DOC)\std_digest_crc.html \
	$(DOC)\std_digest_sha.html \
	$(DOC)\std_digest_md.html \
	$(DOC)\std_digest_ripemd.html \
	$(DOC)\std_digest_hmac.html \
	$(DOC)\std_digest_digest.html \
	$(DOC)\std_digest_hmac.html \
	$(DOC)\std_cstream.html \
	$(DOC)\std_csv.html \
	$(DOC)\std_datetime.html \
	$(DOC)\std_demangle.html \
	$(DOC)\std_encoding.html \
	$(DOC)\std_exception.html \
	$(DOC)\std_file.html \
	$(DOC)\std_format.html \
	$(DOC)\std_functional.html \
	$(DOC)\std_getopt.html \
	$(DOC)\std_json.html \
	$(DOC)\std_math.html \
	$(DOC)\std_mathspecial.html \
	$(DOC)\std_meta.html \
	$(DOC)\std_mmfile.html \
	$(DOC)\std_numeric.html \
	$(DOC)\std_outbuffer.html \
	$(DOC)\std_parallelism.html \
	$(DOC)\std_path.html \
	$(DOC)\std_process.html \
	$(DOC)\std_random.html \
	$(DOC)\std_range.html \
	$(DOC)\std_range_primitives.html \
	$(DOC)\std_range_interfaces.html \
	$(DOC)\std_regex.html \
	$(DOC)\std_signals.html \
	$(DOC)\std_socket.html \
	$(DOC)\std_socketstream.html \
	$(DOC)\std_stdint.html \
	$(DOC)\std_stdio.html \
	$(DOC)\std_stream.html \
	$(DOC)\std_string.html \
	$(DOC)\std_system.html \
	$(DOC)\std_traits.html \
	$(DOC)\std_typecons.html \
	$(DOC)\std_typetuple.html \
	$(DOC)\std_uni.html \
	$(DOC)\std_uri.html \
	$(DOC)\std_utf.html \
	$(DOC)\std_uuid.html \
	$(DOC)\std_variant.html \
	$(DOC)\std_xml.html \
	$(DOC)\std_zip.html \
	$(DOC)\std_zlib.html \
	$(DOC)\std_net_isemail.html \
	$(DOC)\std_net_curl.html \
	$(DOC)\std_experimental_logger_core.html \
	$(DOC)\std_experimental_logger_filelogger.html \
	$(DOC)\std_experimental_logger_multilogger.html \
	$(DOC)\std_experimental_logger_nulllogger.html \
	$(DOC)\std_experimental_logger.html \
	$(DOC)\std_experimental_allocator_building_blocks_affix_allocator.html \
	$(DOC)\std_experimental_allocator_building_blocks_allocator_list.html \
	$(DOC)\std_experimental_allocator_building_blocks_bitmapped_block.html \
	$(DOC)\std_experimental_allocator_building_blocks_bucketizer.html \
	$(DOC)\std_experimental_allocator_building_blocks_fallback_allocator.html \
	$(DOC)\std_experimental_allocator_building_blocks_free_list.html \
	$(DOC)\std_experimental_allocator_building_blocks_free_tree.html \
	$(DOC)\std_experimental_allocator_building_blocks_kernighan_ritchie.html \
	$(DOC)\std_experimental_allocator_building_blocks_null_allocator.html \
	$(DOC)\std_experimental_allocator_building_blocks_quantizer.html \
	$(DOC)\std_experimental_allocator_building_blocks_region.html \
	$(DOC)\std_experimental_allocator_building_blocks_scoped_allocator.html \
	$(DOC)\std_experimental_allocator_building_blocks_segregator.html \
	$(DOC)\std_experimental_allocator_building_blocks_stats_collector.html \
	$(DOC)\std_experimental_allocator_building_blocks.html \
	$(DOC)\std_experimental_allocator_common.html \
	$(DOC)\std_experimental_allocator_gc_allocator.html \
	$(DOC)\std_experimental_allocator_mmap_allocator.html \
	$(DOC)\std_experimental_allocator_showcase.html \
	$(DOC)\std_experimental_allocator_typed.html \
	$(DOC)\std_experimental_allocator.html \
	$(DOC)\std_windows_charset.html \
	$(DOC)\std_windows_registry.html \
	$(DOC)\std_c_fenv.html \
	$(DOC)\std_c_locale.html \
	$(DOC)\std_c_math.html \
	$(DOC)\std_c_process.html \
	$(DOC)\std_c_stdarg.html \
	$(DOC)\std_c_stddef.html \
	$(DOC)\std_c_stdio.html \
	$(DOC)\std_c_stdlib.html \
	$(DOC)\std_c_string.html \
	$(DOC)\std_c_time.html \
	$(DOC)\std_c_wcharh.html \
	$(DOC)\etc_c_curl.html \
	$(DOC)\etc_c_sqlite3.html \
	$(DOC)\etc_c_zlib.html \
	$(DOC)\etc_c_odbc_sql.html \
	$(DOC)\etc_c_odbc_sqlext.html \
	$(DOC)\etc_c_odbc_sqltypes.html \
	$(DOC)\etc_c_odbc_sqlucode.html \
	$(DOC)\index.html

$(LIB) : $(SRC_TO_COMPILE) \
	$(ZLIB) $(DRUNTIMELIB) win32.mak win64.mak
	$(DMD) -lib -of$(LIB) -Xfphobos.json $(DFLAGS) $(SRC_TO_COMPILE) \
		$(ZLIB) $(DRUNTIMELIB)

UNITTEST_OBJS= \
		unittest1.obj \
		unittest2.obj \
		unittest2a.obj \
		unittestM.obj \
		unittest3.obj \
		unittest3a.obj \
		unittest3b.obj \
		unittest3c.obj \
		unittest4.obj \
		unittest5a.obj \
		unittest5b.obj \
		unittest6a.obj \
		unittest6b.obj \
		unittest6c.obj \
		unittest6d.obj \
		unittest6e.obj \
		unittest6f.obj \
		unittest6g.obj \
		unittest6h.obj \
		unittest6i.obj \
		unittest6j.obj \
		unittest7.obj \
		unittest8.obj

unittest : $(LIB)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest1.obj $(SRC_STD_1_HEAVY)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest2.obj $(SRC_STD_RANGE)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest2a.obj $(SRC_STD_2a_HEAVY)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittestM.obj $(SRC_STD_math)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest3.obj $(SRC_STD_3)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest3a.obj $(SRC_STD_3a)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest3b.obj $(SRC_STD_3b)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest3c.obj $(SRC_STD_3c)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest4.obj $(SRC_STD_4)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest5a.obj $(SRC_STD_5a)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest5b.obj $(SRC_STD_5b)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6a.obj $(SRC_STD_6a)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6b.obj $(SRC_STD_6b)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6c.obj $(SRC_STD_6c)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6d.obj $(SRC_STD_6d)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6e.obj $(SRC_STD_6e)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6f.obj $(SRC_STD_6f)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6g.obj $(SRC_STD_CONTAINER)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6h.obj $(SRC_STD_6h)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6i.obj $(SRC_STD_6i)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest6j.obj $(SRC_STD_6j)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest7.obj $(SRC_STD_7) $(SRC_STD_LOGGER)
	$(DMD) $(UDFLAGS) -c -unittest -ofunittest8.obj $(SRC_TO_COMPILE_NOT_STD)
	$(DMD) $(UDFLAGS) -L/OPT:NOICF -unittest unittest.d $(UNITTEST_OBJS) \
	    $(ZLIB) $(DRUNTIMELIB)
	.\unittest.exe

#unittest : unittest.exe
#	unittest
#
#unittest.exe : unittest.d $(LIB)
#	$(DMD) -conf= unittest -g
#	dmc unittest.obj -g

cov : $(SRC_TO_COMPILE) $(LIB)
	$(DMD) -conf= -m$(MODEL) -cov -unittest -ofcov.exe unittest.d $(SRC_TO_COMPILE) $(LIB)
	cov

html : $(DOCS)

changelog.html: changelog.dd
	$(DMD) -Dfchangelog.html changelog.dd

################### Win32 COFF support #########################

# default to 32-bit compiler relative to the location of the 64-bit compiler,
# link and lib are architecture agnostic
CC32=$(CC)\..\..\cl

# build phobos32mscoff.lib
phobos32mscoff:
	$(MAKE) -f win64.mak "DMD=$(DMD)" "MAKE=$(MAKE)" MODEL=32mscoff "CC=\$(CC32)"\"" "AR=\$(AR)"\"" "VCDIR=$(VCDIR)" "SDKDIR=$(SDKDIR)"

# run unittests for 32-bit COFF version
unittest32mscoff:
	$(MAKE) -f win64.mak "DMD=$(DMD)" "MAKE=$(MAKE)" MODEL=32mscoff "CC=\$(CC32)"\"" "AR=\$(AR)"\"" "VCDIR=$(VCDIR)" "SDKDIR=$(SDKDIR)" unittest

######################################################

$(ZLIB): $(SRC_ZLIB)
	cd etc\c\zlib
	$(MAKE) -f win64.mak MODEL=$(MODEL) zlib$(MODEL).lib "CC=\$(CC)"\"" "LIB=\$(AR)"\"" "VCDIR=$(VCDIR)"
	cd ..\..\..

################## DOCS ####################################

DDOCFLAGS=$(DFLAGS) -version=StdDdoc

$(DOC)\object.html : $(STDDOC) $(DRUNTIME)\src\object.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\object.html $(STDDOC) $(DRUNTIME)\src\object.d -I$(DRUNTIME)\src\

$(DOC)\index.html : $(STDDOC) index.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\index.html $(STDDOC) index.d

$(DOC)\core_atomic.html : $(STDDOC) $(DRUNTIME)\src\core\atomic.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_atomic.html $(STDDOC) $(DRUNTIME)\src\core\atomic.d -I$(DRUNTIME)\src\

$(DOC)\core_bitop.html : $(STDDOC) $(DRUNTIME)\src\core\bitop.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_bitop.html $(STDDOC) $(DRUNTIME)\src\core\bitop.d -I$(DRUNTIME)\src\

$(DOC)\core_exception.html : $(STDDOC) $(DRUNTIME)\src\core\exception.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_exception.html $(STDDOC) $(DRUNTIME)\src\core\exception.d -I$(DRUNTIME)\src\

$(DOC)\core_memory.html : $(STDDOC) $(DRUNTIME)\src\core\memory.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_memory.html $(STDDOC) $(DRUNTIME)\src\core\memory.d -I$(DRUNTIME)\src\

$(DOC)\core_runtime.html : $(STDDOC) $(DRUNTIME)\src\core\runtime.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_runtime.html $(STDDOC) $(DRUNTIME)\src\core\runtime.d -I$(DRUNTIME)\src\

$(DOC)\core_simd.html : $(STDDOC) $(DRUNTIME)\src\core\simd.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_simd.html $(STDDOC) $(DRUNTIME)\src\core\simd.d -I$(DRUNTIME)\src\

$(DOC)\core_time.html : $(STDDOC) $(DRUNTIME)\src\core\time.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_time.html $(STDDOC) $(DRUNTIME)\src\core\time.d -I$(DRUNTIME)\src\

$(DOC)\core_thread.html : $(STDDOC) $(DRUNTIME)\src\core\thread.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_thread.html $(STDDOC) $(DRUNTIME)\src\core\thread.d -I$(DRUNTIME)\src\

$(DOC)\core_vararg.html : $(STDDOC) $(DRUNTIME)\src\core\vararg.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_vararg.html $(STDDOC) $(DRUNTIME)\src\core\vararg.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_barrier.html : $(STDDOC) $(DRUNTIME)\src\core\sync\barrier.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_barrier.html $(STDDOC) $(DRUNTIME)\src\core\sync\barrier.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_condition.html : $(STDDOC) $(DRUNTIME)\src\core\sync\condition.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_condition.html $(STDDOC) $(DRUNTIME)\src\core\sync\condition.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_config.html : $(STDDOC) $(DRUNTIME)\src\core\sync\config.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_config.html $(STDDOC) $(DRUNTIME)\src\core\sync\config.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_exception.html : $(STDDOC) $(DRUNTIME)\src\core\sync\exception.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_exception.html $(STDDOC) $(DRUNTIME)\src\core\sync\exception.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_mutex.html : $(STDDOC) $(DRUNTIME)\src\core\sync\mutex.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_mutex.html $(STDDOC) $(DRUNTIME)\src\core\sync\mutex.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_rwmutex.html : $(STDDOC) $(DRUNTIME)\src\core\sync\rwmutex.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_rwmutex.html $(STDDOC) $(DRUNTIME)\src\core\sync\rwmutex.d -I$(DRUNTIME)\src\

$(DOC)\core_sync_semaphore.html : $(STDDOC) $(DRUNTIME)\src\core\sync\semaphore.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\core_sync_semaphore.html $(STDDOC) $(DRUNTIME)\src\core\sync\semaphore.d -I$(DRUNTIME)\src\

$(DOC)\std_algorithm.html : $(STDDOC) std\algorithm\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm.html $(STDDOC) std\algorithm\package.d

$(DOC)\std_algorithm_comparison.html : $(STDDOC) std\algorithm\comparison.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_comparison.html $(STDDOC) std\algorithm\comparison.d

$(DOC)\std_algorithm_iteration.html : $(STDDOC) std\algorithm\iteration.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_iteration.html $(STDDOC) std\algorithm\iteration.d

$(DOC)\std_algorithm_mutation.html : $(STDDOC) std\algorithm\mutation.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_mutation.html $(STDDOC) std\algorithm\mutation.d

$(DOC)\std_algorithm_searching.html : $(STDDOC) std\algorithm\searching.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_searching.html $(STDDOC) std\algorithm\searching.d

$(DOC)\std_algorithm_setops.html : $(STDDOC) std\algorithm\setops.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_setops.html $(STDDOC) std\algorithm\setops.d

$(DOC)\std_algorithm_sorting.html : $(STDDOC) std\algorithm\sorting.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_algorithm_sorting.html $(STDDOC) std\algorithm\sorting.d

$(DOC)\std_array.html : $(STDDOC) std\array.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_array.html $(STDDOC) std\array.d

$(DOC)\std_ascii.html : $(STDDOC) std\ascii.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_ascii.html $(STDDOC) std\ascii.d

$(DOC)\std_base64.html : $(STDDOC) std\base64.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_base64.html $(STDDOC) std\base64.d

$(DOC)\std_bigint.html : $(STDDOC) std\bigint.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_bigint.html $(STDDOC) std\bigint.d

$(DOC)\std_bitmanip.html : $(STDDOC) std\bitmanip.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_bitmanip.html $(STDDOC) std\bitmanip.d

$(DOC)\std_concurrency.html : $(STDDOC) std\concurrency.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_concurrency.html $(STDDOC) std\concurrency.d

$(DOC)\std_compiler.html : $(STDDOC) std\compiler.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_compiler.html $(STDDOC) std\compiler.d

$(DOC)\std_complex.html : $(STDDOC) std\complex.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_complex.html $(STDDOC) std\complex.d

$(DOC)\std_conv.html : $(STDDOC) std\conv.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_conv.html $(STDDOC) std\conv.d

$(DOC)\std_container_array.html : $(STDDOC) std\container\array.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_array.html $(STDDOC) std\container\array.d

$(DOC)\std_container_binaryheap.html : $(STDDOC) std\container\binaryheap.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_binaryheap.html $(STDDOC) std\container\binaryheap.d

$(DOC)\std_container_dlist.html : $(STDDOC) std\container\dlist.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_dlist.html $(STDDOC) std\container\dlist.d

$(DOC)\std_container_rbtree.html : $(STDDOC) std\container\rbtree.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_rbtree.html $(STDDOC) std\container\rbtree.d

$(DOC)\std_container_slist.html : $(STDDOC) std\container\slist.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_slist.html $(STDDOC) std\container\slist.d

$(DOC)\std_container_util.html : $(STDDOC) std\container\util.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container_util.html $(STDDOC) std\container\util.d

$(DOC)\std_container.html : $(STDDOC) std\container\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_container.html $(STDDOC) std\container\package.d

$(DOC)\std_range.html : $(STDDOC) std\range\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_range.html $(STDDOC) std\range\package.d

$(DOC)\std_range_primitives.html : $(STDDOC) std\range\primitives.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_range_primitives.html $(STDDOC) std\range\primitives.d

$(DOC)\std_range_interfaces.html : $(STDDOC) std\range\interfaces.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_range_interfaces.html $(STDDOC) std\range\interfaces.d

$(DOC)\std_cstream.html : $(STDDOC) std\cstream.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_cstream.html $(STDDOC) std\cstream.d

$(DOC)\std_csv.html : $(STDDOC) std\csv.d
	$(DMD) -c -o- $(DFLAGS) -Df$(DOC)\std_csv.html $(STDDOC) std\csv.d

$(DOC)\std_datetime.html : $(STDDOC) std\datetime.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_datetime.html $(STDDOC) std\datetime.d

$(DOC)\std_demangle.html : $(STDDOC) std\demangle.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_demangle.html $(STDDOC) std\demangle.d

$(DOC)\std_exception.html : $(STDDOC) std\exception.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_exception.html $(STDDOC) std\exception.d

$(DOC)\std_file.html : $(STDDOC) std\file.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_file.html $(STDDOC) std\file.d

$(DOC)\std_format.html : $(STDDOC) std\format.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_format.html $(STDDOC) std\format.d

$(DOC)\std_functional.html : $(STDDOC) std\functional.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_functional.html $(STDDOC) std\functional.d

$(DOC)\std_getopt.html : $(STDDOC) std\getopt.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_getopt.html $(STDDOC) std\getopt.d

$(DOC)\std_json.html : $(STDDOC) std\json.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_json.html $(STDDOC) std\json.d

$(DOC)\std_math.html : $(STDDOC) std\math.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_math.html $(STDDOC) std\math.d

$(DOC)\std_meta.html : $(STDDOC) std\meta.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_meta.html $(STDDOC) std\meta.d

$(DOC)\std_mathspecial.html : $(STDDOC) std\mathspecial.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_mathspecial.html $(STDDOC) std\mathspecial.d

$(DOC)\std_mmfile.html : $(STDDOC) std\mmfile.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_mmfile.html $(STDDOC) std\mmfile.d

$(DOC)\std_numeric.html : $(STDDOC) std\numeric.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_numeric.html $(STDDOC) std\numeric.d

$(DOC)\std_outbuffer.html : $(STDDOC) std\outbuffer.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_outbuffer.html $(STDDOC) std\outbuffer.d

$(DOC)\std_parallelism.html : $(STDDOC) std\parallelism.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_parallelism.html $(STDDOC) std\parallelism.d

$(DOC)\std_path.html : $(STDDOC) std\path.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_path.html $(STDDOC) std\path.d

$(DOC)\std_process.html : $(STDDOC) std\process.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_process.html $(STDDOC) std\process.d

$(DOC)\std_random.html : $(STDDOC) std\random.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_random.html $(STDDOC) std\random.d

$(DOC)\std_range.html : $(STDDOC) std\range\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_range.html $(STDDOC) std\range\package.d

$(DOC)\std_regex.html : $(STDDOC) std\regex\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_regex.html $(STDDOC) std\regex\package.d

$(DOC)\std_signals.html : $(STDDOC) std\signals.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_signals.html $(STDDOC) std\signals.d

$(DOC)\std_socket.html : $(STDDOC) std\socket.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_socket.html $(STDDOC) std\socket.d

$(DOC)\std_socketstream.html : $(STDDOC) std\socketstream.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_socketstream.html $(STDDOC) std\socketstream.d

$(DOC)\std_stdint.html : $(STDDOC) std\stdint.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_stdint.html $(STDDOC) std\stdint.d

$(DOC)\std_stdio.html : $(STDDOC) std\stdio.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_stdio.html $(STDDOC) std\stdio.d

$(DOC)\std_stream.html : $(STDDOC) std\stream.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_stream.html $(STDDOC) std\stream.d

$(DOC)\std_string.html : $(STDDOC) std\string.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_string.html $(STDDOC) std\string.d

$(DOC)\std_system.html : $(STDDOC) std\system.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_system.html $(STDDOC) std\system.d

$(DOC)\std_traits.html : $(STDDOC) std\traits.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_traits.html $(STDDOC) std\traits.d

$(DOC)\std_typecons.html : $(STDDOC) std\typecons.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_typecons.html $(STDDOC) std\typecons.d

$(DOC)\std_typetuple.html : $(STDDOC) std\typetuple.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_typetuple.html $(STDDOC) std\typetuple.d

$(DOC)\std_uni.html : $(STDDOC) std\uni.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_uni.html $(STDDOC) std\uni.d

$(DOC)\std_uri.html : $(STDDOC) std\uri.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_uri.html $(STDDOC) std\uri.d

$(DOC)\std_utf.html : $(STDDOC) std\utf.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_utf.html $(STDDOC) std\utf.d

$(DOC)\std_uuid.html : $(STDDOC) std\uuid.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_uuid.html $(STDDOC) std\uuid.d

$(DOC)\std_variant.html : $(STDDOC) std\variant.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_variant.html $(STDDOC) std\variant.d

$(DOC)\std_xml.html : $(STDDOC) std\xml.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_xml.html $(STDDOC) std\xml.d

$(DOC)\std_encoding.html : $(STDDOC) std\encoding.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_encoding.html $(STDDOC) std\encoding.d

$(DOC)\std_zip.html : $(STDDOC) std\zip.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_zip.html $(STDDOC) std\zip.d

$(DOC)\std_zlib.html : $(STDDOC) std\zlib.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_zlib.html $(STDDOC) std\zlib.d

$(DOC)\std_net_isemail.html : $(STDDOC) std\net\isemail.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_net_isemail.html $(STDDOC) std\net\isemail.d

$(DOC)\std_net_curl.html : $(STDDOC) std\net\curl.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_net_curl.html $(STDDOC) std\net\curl.d

$(DOC)\std_experimental_logger_core.html : $(STDDOC) std\experimental\logger\core.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_logger_core.html $(STDDOC) std\experimental\logger\core.d

$(DOC)\std_experimental_logger_multilogger.html : $(STDDOC) std\experimental\logger\multilogger.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_logger_multilogger.html $(STDDOC) std\experimental\logger\multilogger.d

$(DOC)\std_experimental_logger_filelogger.html : $(STDDOC) std\experimental\logger\filelogger.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_logger_filelogger.html $(STDDOC) std\experimental\logger\filelogger.d

$(DOC)\std_experimental_logger_nulllogger.html : $(STDDOC) std\experimental\logger\nulllogger.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_logger_nulllogger.html $(STDDOC) std\experimental\logger\nulllogger.d

$(DOC)\std_experimental_logger.html : $(STDDOC) std\experimental\logger\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_logger.html $(STDDOC) std\experimental\logger\package.d

$(DOC)\std_experimental_allocator_building_blocks_affix_allocator.html : $(STDDOC) std\experimental\allocator\building_blocks\affix_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_affix_allocator.html \
		$(STDDOC) std\experimental\allocator\building_blocks\affix_allocator.d

$(DOC)\std_experimental_allocator_building_blocks_allocator_list.html : $(STDDOC) std\experimental\allocator\building_blocks\allocator_list.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_allocator_list.html \
		$(STDDOC) std\experimental\allocator\building_blocks\allocator_list.d

$(DOC)\std_experimental_allocator_building_blocks_bitmapped_block.html : $(STDDOC) std\experimental\allocator\building_blocks\bitmapped_block.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_bitmapped_block.html \
		$(STDDOC) std\experimental\allocator\building_blocks\bitmapped_block.d

$(DOC)\std_experimental_allocator_building_blocks_bucketizer.html : $(STDDOC) std\experimental\allocator\building_blocks\bucketizer.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_bucketizer.html \
		$(STDDOC) std\experimental\allocator\building_blocks\bucketizer.d

$(DOC)\std_experimental_allocator_building_blocks_fallback_allocator.html : $(STDDOC) std\experimental\allocator\building_blocks\fallback_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_fallback_allocator.html \
		$(STDDOC) std\experimental\allocator\building_blocks\fallback_allocator.d

$(DOC)\std_experimental_allocator_building_blocks_free_list.html : $(STDDOC) std\experimental\allocator\building_blocks\free_list.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_free_list.html \
		$(STDDOC) std\experimental\allocator\building_blocks\free_list.d

$(DOC)\std_experimental_allocator_building_blocks_free_tree.html : $(STDDOC) std\experimental\allocator\building_blocks\free_tree.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_free_tree.html \
		$(STDDOC) std\experimental\allocator\building_blocks\free_tree.d

$(DOC)\std_experimental_allocator_building_blocks_kernighan_ritchie.html : $(STDDOC) std\experimental\allocator\building_blocks\kernighan_ritchie.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_kernighan_ritchie.html \
		$(STDDOC) std\experimental\allocator\building_blocks\kernighan_ritchie.d

$(DOC)\std_experimental_allocator_building_blocks_null_allocator.html : $(STDDOC) std\experimental\allocator\building_blocks\null_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_null_allocator.html \
		$(STDDOC) std\experimental\allocator\building_blocks\null_allocator.d

$(DOC)\std_experimental_allocator_building_blocks_quantizer.html : $(STDDOC) std\experimental\allocator\building_blocks\quantizer.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_quantizer.html \
		$(STDDOC) std\experimental\allocator\building_blocks\quantizer.d

$(DOC)\std_experimental_allocator_building_blocks_region.html : $(STDDOC) std\experimental\allocator\building_blocks\region.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_region.html \
		$(STDDOC) std\experimental\allocator\building_blocks\region.d

$(DOC)\std_experimental_allocator_building_blocks_scoped_allocator.html : $(STDDOC) std\experimental\allocator\building_blocks\scoped_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_scoped_allocator.html \
		$(STDDOC) std\experimental\allocator\building_blocks\scoped_allocator.d

$(DOC)\std_experimental_allocator_building_blocks_segregator.html : $(STDDOC) std\experimental\allocator\building_blocks\segregator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_segregator.html \
		$(STDDOC) std\experimental\allocator\building_blocks\segregator.d

$(DOC)\std_experimental_allocator_building_blocks_stats_collector.html : $(STDDOC) std\experimental\allocator\building_blocks\stats_collector.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks_stats_collector.html \
		$(STDDOC) std\experimental\allocator\building_blocks\stats_collector.d

$(DOC)\std_experimental_allocator_building_blocks.html : $(STDDOC) std\experimental\allocator\building_blocks\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_building_blocks.html \
		$(STDDOC) std\experimental\allocator\building_blocks\package.d

$(DOC)\std_experimental_allocator_common.html : $(STDDOC) std\experimental\allocator\common.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_common.html $(STDDOC) std\experimental\allocator\common.d

$(DOC)\std_experimental_allocator_gc_allocator.html : $(STDDOC) std\experimental\allocator\gc_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_gc_allocator.html $(STDDOC) std\experimental\allocator\gc_allocator.d

$(DOC)\std_experimental_allocator_mallocator.html : $(STDDOC) std\experimental\allocator\mallocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_mallocator.html $(STDDOC) std\experimental\allocator\mallocator.d

$(DOC)\std_experimental_allocator_mmap_allocator.html : $(STDDOC) std\experimental\allocator\mmap_allocator.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_mmap_allocator.html $(STDDOC) std\experimental\allocator\mmap_allocator.d

$(DOC)\std_experimental_allocator_showcase.html : $(STDDOC) std\experimental\allocator\showcase.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_showcase.html $(STDDOC) std\experimental\allocator\showcase.d

$(DOC)\std_experimental_allocator_typed.html : $(STDDOC) std\experimental\allocator\typed.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator_typed.html $(STDDOC) std\experimental\allocator\typed.d

$(DOC)\std_experimental_allocator.html : $(STDDOC) std\experimental\allocator\package.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_experimental_allocator.html $(STDDOC) std\experimental\allocator\package.d

$(DOC)\std_digest_crc.html : $(STDDOC) std\digest\crc.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_crc.html $(STDDOC) std\digest\crc.d

$(DOC)\std_digest_sha.html : $(STDDOC) std\digest\sha.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_sha.html $(STDDOC) std\digest\sha.d

$(DOC)\std_digest_md.html : $(STDDOC) std\digest\md.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_md.html $(STDDOC) std\digest\md.d

$(DOC)\std_digest_ripemd.html : $(STDDOC) std\digest\ripemd.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_ripemd.html $(STDDOC) std\digest\ripemd.d

$(DOC)\std_digest_digest.html : $(STDDOC) std\digest\digest.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_digest.html $(STDDOC) std\digest\digest.d

$(DOC)\std_digest_hmac.html : $(STDDOC) std\digest\hmac.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_digest_hmac.html $(STDDOC) std\digest\hmac.d

$(DOC)\std_windows_charset.html : $(STDDOC) std\windows\charset.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_windows_charset.html $(STDDOC) std\windows\charset.d

$(DOC)\std_windows_registry.html : $(STDDOC) std\windows\registry.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_windows_registry.html $(STDDOC) std\windows\registry.d

$(DOC)\std_c_fenv.html : $(STDDOC) std\c\fenv.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_fenv.html $(STDDOC) std\c\fenv.d

$(DOC)\std_c_locale.html : $(STDDOC) std\c\locale.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_locale.html $(STDDOC) std\c\locale.d

$(DOC)\std_c_math.html : $(STDDOC) std\c\math.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_math.html $(STDDOC) std\c\math.d

$(DOC)\std_c_process.html : $(STDDOC) std\c\process.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_process.html $(STDDOC) std\c\process.d

$(DOC)\std_c_stdarg.html : $(STDDOC) std\c\stdarg.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_stdarg.html $(STDDOC) std\c\stdarg.d

$(DOC)\std_c_stddef.html : $(STDDOC) std\c\stddef.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_stddef.html $(STDDOC) std\c\stddef.d

$(DOC)\std_c_stdio.html : $(STDDOC) std\c\stdio.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_stdio.html $(STDDOC) std\c\stdio.d

$(DOC)\std_c_stdlib.html : $(STDDOC) std\c\stdlib.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_stdlib.html $(STDDOC) std\c\stdlib.d

$(DOC)\std_c_string.html : $(STDDOC) std\c\string.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_string.html $(STDDOC) std\c\string.d

$(DOC)\std_c_time.html : $(STDDOC) std\c\time.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_time.html $(STDDOC) std\c\time.d

$(DOC)\std_c_wcharh.html : $(STDDOC) std\c\wcharh.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\std_c_wcharh.html $(STDDOC) std\c\wcharh.d

$(DOC)\etc_c_curl.html : $(STDDOC) etc\c\curl.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_curl.html $(STDDOC) etc\c\curl.d

$(DOC)\etc_c_sqlite3.html : $(STDDOC) etc\c\sqlite3.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_sqlite3.html $(STDDOC) etc\c\sqlite3.d

$(DOC)\etc_c_zlib.html : $(STDDOC) etc\c\zlib.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_zlib.html $(STDDOC) etc\c\zlib.d

$(DOC)\etc_c_odbc_sql.html : $(STDDOC) etc\c\odbc\sql.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_odbc_sql.html $(STDDOC) etc\c\odbc\sql.d

$(DOC)\etc_c_odbc_sqlext.html : $(STDDOC) etc\c\odbc\sqlext.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_odbc_sqlext.html $(STDDOC) etc\c\odbc\sqlext.d

$(DOC)\etc_c_odbc_sqltypes.html : $(STDDOC) etc\c\odbc\sqltypes.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_odbc_sqltypes.html $(STDDOC) etc\c\odbc\sqltypes.d

$(DOC)\etc_c_odbc_sqlucode.html : $(STDDOC) etc\c\odbc\sqlucode.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_odbc_sqlucode.html $(STDDOC) etc\c\odbc\sqlucode.d

$(DOC)\etc_c_odbc_sql.html : $(STDDOC) etc\c\odbc\sql.d
	$(DMD) -c -o- $(DDOCFLAGS) -Df$(DOC)\etc_c_odbc_sql.html $(STDDOC) etc\c\odbc\sql.d

######################################################

zip : win32.mak win64.mak posix.mak osmodel.mak $(STDDOC) $(SRC) \
	$(SRC_STD) $(SRC_STD_C) $(SRC_STD_WIN) \
	$(SRC_STD_C_WIN) $(SRC_STD_C_LINUX) $(SRC_STD_C_OSX) $(SRC_STD_C_FREEBSD) \
	$(SRC_ETC) $(SRC_ETC_C) $(SRC_ZLIB) $(SRC_STD_NET) $(SRC_STD_DIGEST) $(SRC_STD_CONTAINER) \
	$(SRC_STD_INTERNAL) $(SRC_STD_INTERNAL_DIGEST) $(SRC_STD_INTERNAL_MATH) \
	$(SRC_STD_INTERNAL_WINDOWS) $(SRC_STD_REGEX) $(SRC_STD_RANGE) $(SRC_STD_ALGO) \
	$(SRC_STD_LOGGER) $(SRC_STD_ALLOC)
	del phobos.zip
	zip32 -u phobos win32.mak win64.mak posix.mak osmodel.mak $(STDDOC)
	zip32 -u phobos $(SRC)
	zip32 -u phobos $(SRC_STD)
	zip32 -u phobos $(SRC_STD_C)
	zip32 -u phobos $(SRC_STD_WIN)
	zip32 -u phobos $(SRC_STD_C_WIN)
	zip32 -u phobos $(SRC_STD_C_LINUX)
	zip32 -u phobos $(SRC_STD_C_OSX)
	zip32 -u phobos $(SRC_STD_C_FREEBSD)
	zip32 -u phobos $(SRC_STD_INTERNAL)
	zip32 -u phobos $(SRC_STD_INTERNAL_DIGEST)
	zip32 -u phobos $(SRC_STD_INTERNAL_MATH)
	zip32 -u phobos $(SRC_STD_INTERNAL_WINDOWS)
	zip32 -u phobos $(SRC_ETC) $(SRC_ETC_C)
	zip32 -u phobos $(SRC_ZLIB)
	zip32 -u phobos $(SRC_STD_NET)
	zip32 -u phobos $(SRC_STD_LOGGER)
	zip32 -u phobos $(SRC_STD_ALLOC)
	zip32 -u phobos $(SRC_STD_DIGEST)
	zip32 -u phobos $(SRC_STD_CONTAINER)
	zip32 -u phobos $(SRC_STD_REGEX)
	zip32 -u phobos $(SRC_STD_RANGE)
	zip32 -u phobos $(SRC_STD_ALGO)

phobos.zip : zip

clean:
	cd etc\c\zlib
	$(MAKE) -f win$(MODEL).mak clean
	cd ..\..\..
	del $(DOCS)
	del $(UNITTEST_OBJS) unittest.obj unittest.exe
	del $(LIB)
	del phobos.json

cleanhtml:
	del $(DOCS)

install: phobos.zip
	$(CP) phobos.lib phobos64.lib $(DIR)\windows\lib
	$(CP) $(DRUNTIME)\lib\gcstub.obj $(DRUNTIME)\lib\gcstub64.obj $(DIR)\windows\lib
	+rd/s/q $(DIR)\src\phobos
	unzip -o phobos.zip -d $(DIR)\src\phobos

auto-tester-build: targets

auto-tester-test: unittest

