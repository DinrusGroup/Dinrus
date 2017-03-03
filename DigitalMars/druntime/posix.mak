# This makefile is designed to be run by gnu make.
# The default make program on FreeBSD 8.1 is not gnu make; to install gnu make:
#    pkg_add -r gmake
# and then run as gmake rather than make.

QUIET:=@

OS:=
uname_S:=$(shell uname -s)
ifeq (Darwin,$(uname_S))
	OS:=osx
endif
ifeq (Linux,$(uname_S))
	OS:=linux
endif
ifeq (FreeBSD,$(uname_S))
	OS:=freebsd
endif
ifeq (OpenBSD,$(uname_S))
	OS:=openbsd
endif
ifeq (Solaris,$(uname_S))
	OS:=solaris
endif
ifeq (SunOS,$(uname_S))
	OS:=solaris
endif
ifeq (,$(OS))
	$(error Unrecognized or unsupported OS for uname: $(uname_S))
endif

DMD?=dmd
INSTALL_DIR=../install

DOCDIR=doc
IMPDIR=import

MODEL:=default
ifneq (default,$(MODEL))
	MODEL_FLAG:=-m$(MODEL)
endif
override PIC:=$(if $(PIC),-fPIC,)

ifeq (osx,$(OS))
	DOTDLL:=.dylib
	DOTLIB:=.a
else
	DOTDLL:=.so
	DOTLIB:=.a
endif

DFLAGS=$(MODEL_FLAG) -O -release -inline -w -Isrc -Iimport $(PIC)
UDFLAGS=$(MODEL_FLAG) -O -release -w -Isrc -Iimport $(PIC)
DDOCFLAGS=-c -w -o- -Isrc -Iimport -version=CoreDdoc

CFLAGS=$(MODEL_FLAG) -O $(PIC)

ifeq (osx,$(OS))
    ASMFLAGS =
else
    ASMFLAGS = -Wa,--noexecstack
endif

OBJDIR=obj/$(MODEL)
DRUNTIME_BASE=druntime-$(OS)$(MODEL)
DRUNTIME=lib/lib$(DRUNTIME_BASE).a
DRUNTIMESO=lib/lib$(DRUNTIME_BASE).so
DRUNTIMESOOBJ=lib/lib$(DRUNTIME_BASE)so.o
DRUNTIMESOLIB=lib/lib$(DRUNTIME_BASE)so.a

DOCFMT=

include mak/COPY
COPY:=$(subst \,/,$(COPY))

include mak/DOCS
DOCS:=$(subst \,/,$(DOCS))

include mak/IMPORTS
IMPORTS:=$(subst \,/,$(IMPORTS))

include mak/MANIFEST
MANIFEST:=$(subst \,/,$(MANIFEST))

include mak/SRCS
SRCS:=$(subst \,/,$(SRCS))

# NOTE: trace.d and cover.d are not necessary for a successful build
#       as both are used for debugging features (profiling and coverage)
# NOTE: a pre-compiled minit.obj has been provided in dmd for Win32	 and
#       minit.asm is not used by dmd for Linux

OBJS= $(OBJDIR)/errno_c.o $(OBJDIR)/threadasm.o

######################## All of'em ##############################

ifeq (linux,$(OS))
target : import copy dll $(DRUNTIME) doc
else
target : import copy $(DRUNTIME) doc
endif

######################## Doc .html file generation ##############################

doc: $(DOCS)

$(DOCDIR)/object.html : src/object_.d
	$(DMD) $(DDOCFLAGS) -Df$@ $(DOCFMT) $<

$(DOCDIR)/core_%.html : src/core/%.di
	$(DMD) $(DDOCFLAGS) -Df$@ $(DOCFMT) $<

$(DOCDIR)/core_%.html : src/core/%.d
	$(DMD) $(DDOCFLAGS) -Df$@ $(DOCFMT) $<

$(DOCDIR)/core_sync_%.html : src/core/sync/%.d
	$(DMD) $(DDOCFLAGS) -Df$@ $(DOCFMT) $<

######################## Header .di file generation ##############################

import: $(IMPORTS)

$(IMPDIR)/core/sync/%.di : src/core/sync/%.d
	@mkdir -p `dirname $@`
	$(DMD) -c -o- -Isrc -Iimport -Hf$@ $<

######################## Header .di file copy ##############################

copy: $(COPY)

$(IMPDIR)/%.di : src/%.di
	@mkdir -p `dirname $@`
	cp $< $@

$(IMPDIR)/%.d : src/%.d
	@mkdir -p `dirname $@`
	cp $< $@

################### C/ASM Targets ############################

$(OBJDIR)/%.o : src/rt/%.c
	@mkdir -p `dirname $@`
	$(CC) -c $(CFLAGS) $< -o$@

$(OBJDIR)/errno_c.o : src/core/stdc/errno.c
	@mkdir -p `dirname $@`
	$(CC) -c $(CFLAGS) $< -o$@

$(OBJDIR)/threadasm.o : src/core/threadasm.S
	@mkdir -p $(OBJDIR)
	$(CC) $(ASMFLAGS) -c $(CFLAGS) $< -o$@

######################## Create a shared library ##############################

$(DRUNTIMESO) $(DRUNTIMESOLIB) dll: override PIC:=-fPIC
$(DRUNTIMESO) $(DRUNTIMESOLIB) dll: DFLAGS+=-version=Shared
dll: $(DRUNTIMESOLIB)

$(DRUNTIMESO): $(OBJS) $(SRCS)
	$(DMD) -shared -debuglib= -defaultlib= -of$(DRUNTIMESO) $(DFLAGS) $(SRCS) $(OBJS) -L-ldl

$(DRUNTIMESOLIB): $(OBJS) $(SRCS)
	$(DMD) -c -fPIC -of$(DRUNTIMESOOBJ) $(DFLAGS) $(SRCS)
	$(DMD) -lib -of$(DRUNTIMESOLIB) $(DRUNTIMESOOBJ) $(OBJS)

################### Library generation #########################

$(DRUNTIME): $(OBJS) $(SRCS)
	$(DMD) -lib -of$(DRUNTIME) -Xfdruntime.json $(DFLAGS) $(SRCS) $(OBJS)

UT_MODULES:=$(patsubst src/%.d,$(OBJDIR)/%,$(SRCS))
ADDITIONAL_TESTS:=test/init_fini
ADDITIONAL_TESTS+=$(if $(findstring $(OS),linux),test/shared,)

unittest : $(UT_MODULES) $(addsuffix /.run,$(ADDITIONAL_TESTS))
	@echo done

ifeq ($(OS),freebsd)
DISABLED_TESTS =
else
DISABLED_TESTS =
endif

$(addprefix $(OBJDIR)/,$(DISABLED_TESTS)) :
	@echo $@ - disabled

ifneq (linux,$(OS))

$(OBJDIR)/test_runner: $(OBJS) $(SRCS) src/test_runner.d
	$(DMD) $(UDFLAGS) -version=druntime_unittest -unittest -of$@ src/test_runner.d $(SRCS) $(OBJS) -debuglib= -defaultlib=

else

UT_DRUNTIME:=$(OBJDIR)/lib$(DRUNTIME_BASE)-ut$(DOTDLL)

$(UT_DRUNTIME): override PIC:=-fPIC
$(UT_DRUNTIME): UDFLAGS+=-version=Shared
$(UT_DRUNTIME): $(OBJS) $(SRCS)
	$(DMD) $(UDFLAGS) -shared -version=druntime_unittest -unittest -of$@ $(SRCS) $(OBJS) -L-ldl -debuglib= -defaultlib=

$(OBJDIR)/test_runner: $(UT_DRUNTIME) src/test_runner.d
	$(DMD) $(UDFLAGS) -of$@ src/test_runner.d -L$(UT_DRUNTIME) -debuglib= -defaultlib=

endif

# macro that returns the module name given the src path
moduleName=$(subst rt.invariant,invariant,$(subst object_,object,$(subst /,.,$(1))))

$(OBJDIR)/% : $(OBJDIR)/test_runner
	@mkdir -p $(dir $@)
# make the file very old so it builds and runs again if it fails
	@touch -t 197001230123 $@
# run unittest in its own directory
	$(QUIET)$(RUN) $(OBJDIR)/test_runner $(call moduleName,$*)
# succeeded, render the file new again
	@touch $@

test/init_fini/.run: $(DRUNTIME)
test/shared/.run: $(DRUNTIMESO)

test/%/.run: test/%/Makefile
	$(QUIET)$(MAKE) -C test/$* MODEL=$(MODEL) OS=$(OS) DMD=$(abspath $(DMD)) \
		DRUNTIME=$(abspath $(DRUNTIME)) DRUNTIMESO=$(abspath $(DRUNTIMESO)) QUIET=$(QUIET)

detab:
	detab $(MANIFEST)
	tolf $(MANIFEST)

zip: druntime.zip

druntime.zip: $(MANIFEST) $(DOCS) $(IMPORTS)
	rm -rf $@
	zip $@ $^

install: target
	mkdir -p $(INSTALL_DIR)/html
	cp -r doc/* $(INSTALL_DIR)/html/
	mkdir -p $(INSTALL_DIR)/import
	cp -r import/* $(INSTALL_DIR)/import/
	mkdir -p $(INSTALL_DIR)/lib
	cp -r lib/* $(INSTALL_DIR)/lib/
	cp LICENSE $(INSTALL_DIR)/druntime-LICENSE.txt

clean: $(addsuffix /.clean,$(ADDITIONAL_TESTS))
	rm -rf obj lib $(IMPDIR) $(DOCDIR) druntime.zip

test/%/.clean: test/%/Makefile
	$(MAKE) -C test/$* clean
