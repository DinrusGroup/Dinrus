# get OS and MODEL
include osmodel.mak

ifeq (,$(TARGET_CPU))
    $(info no cpu specified, assuming X86)
    TARGET_CPU=X86
endif

ifeq (X86,$(TARGET_CPU))
    TARGET_CH = $C/code_x86.h
    TARGET_OBJS = cg87.o cgxmm.o cgsched.o cod1.o cod2.o cod3.o cod4.o ptrntab.o
else
    ifeq (stub,$(TARGET_CPU))
        TARGET_CH = $C/code_stub.h
        TARGET_OBJS = platform_stub.o
    else
        $(error unknown TARGET_CPU: '$(TARGET_CPU)')
    endif
endif

INSTALL_DIR=../../install
SYSCONFDIR=/etc
PGO_DIR=$(abspath pgo)

C=backend
TK=tk
ROOT=root

ifeq (osx,$(OS))
    export MACOSX_DEPLOYMENT_TARGET=10.3
endif

#ifeq (osx,$(OS))
#	HOST_CC=clang++
#else
	HOST_CC=g++
#endif
CC=$(HOST_CC)
AR=ar
GIT=git

HOST_DC?=
ifneq (,$(HOST_DC))
  $(warning ========== Use HOST_DMD instead of HOST_DC ========== )
  HOST_DMD=$(HOST_DC)
endif

# Host D compiler for bootstrapping
ifeq (,$(AUTO_BOOTSTRAP))
  # No bootstrap, a $(HOST_DC) installation must be available
  HOST_DMD?=dmd
  HOST_DMD_PATH=$(abspath $(shell which $(HOST_DMD)))
  ifeq (,$(HOST_DMD_PATH))
    $(error '$(HOST_DMD)' not found, get a D compiler or make AUTO_BOOTSTRAP=1)
  endif
  HOST_DMD_RUN:=$(HOST_DMD)
else
  # Auto-bootstrapping, will download dmd automatically
  HOST_DMD_VER=2.067.1
  HOST_DMD_ROOT=/tmp/.host_dmd-$(HOST_DMD_VER)
  # dmd.2.067.1.osx.zip or dmd.2.067.1.freebsd-64.zip
  HOST_DMD_ZIP=dmd.$(HOST_DMD_VER).$(OS)$(if $(filter $(OS),freebsd),-$(MODEL),).zip
  # http://downloads.dlang.org/releases/2.x/2.067.1/dmd.2.067.1.osx.zip
  HOST_DMD_URL=http://downloads.dlang.org/releases/2.x/$(HOST_DMD_VER)/$(HOST_DMD_ZIP)
  HOST_DMD=$(HOST_DMD_ROOT)/dmd2/$(OS)/$(if $(filter $(OS),osx),bin,bin$(MODEL))/dmd
  HOST_DMD_PATH=$(HOST_DMD)
  HOST_DMD_RUN=$(HOST_DMD) -conf=$(dir $(HOST_DMD))dmd.conf
endif

# Compiler Warnings
ifdef ENABLE_WARNINGS
WARNINGS := -Wall -Wextra \
	-Wno-attributes \
	-Wno-char-subscripts \
	-Wno-deprecated \
	-Wno-empty-body \
	-Wno-format \
	-Wno-missing-braces \
	-Wno-missing-field-initializers \
	-Wno-overloaded-virtual \
	-Wno-parentheses \
	-Wno-reorder \
	-Wno-return-type \
	-Wno-sign-compare \
	-Wno-strict-aliasing \
	-Wno-switch \
	-Wno-type-limits \
	-Wno-unknown-pragmas \
	-Wno-unused-function \
	-Wno-unused-label \
	-Wno-unused-parameter \
	-Wno-unused-value \
	-Wno-unused-variable
# GCC Specific
ifeq ($(HOST_CC), g++)
WARNINGS := $(WARNINGS) \
	-Wno-logical-op \
	-Wno-narrowing \
	-Wno-unused-but-set-variable \
	-Wno-uninitialized
endif
# Clang Specific
ifeq ($(HOST_CC), clang++)
WARNINGS := $(WARNINGS) \
	-Wno-tautological-constant-out-of-range-compare \
	-Wno-tautological-compare \
	-Wno-constant-logical-operand \
	-Wno-self-assign -Wno-self-assign
# -Wno-sometimes-uninitialized
endif
else
# Default Warnings
WARNINGS := -Wno-deprecated -Wstrict-aliasing
# Clang Specific
ifeq ($(HOST_CC), clang++)
WARNINGS := $(WARNINGS) \
    -Wno-logical-op-parentheses \
    -Wno-dynamic-class-memaccess \
    -Wno-switch
endif
endif

OS_UPCASE := $(shell echo $(OS) | tr '[a-z]' '[A-Z]')

MMD=-MMD -MF $(basename $@).deps

# Default compiler flags for all source files
CFLAGS := $(WARNINGS) \
	-fno-exceptions -fno-rtti \
	-D__pascal= -DMARS=1 -DTARGET_$(OS_UPCASE)=1 -DDM_TARGET_CPU_$(TARGET_CPU)=1 \
	$(MODEL_FLAG)
# GCC Specific
ifeq ($(HOST_CC), g++)
CFLAGS := $(CFLAGS) \
    -std=gnu++98
endif
# Default D compiler flags for all source files
DFLAGS=

ifneq (,$(DEBUG))
ENABLE_DEBUG := 1
endif
ifneq (,$(RELEASE))
ENABLE_RELEASE := 1
endif

# Append different flags for debugging, profiling and release.
ifdef ENABLE_DEBUG
CFLAGS += -g -g3 -DDEBUG=1 -DUNITTEST
DFLAGS += -g -debug -unittest
endif
ifdef ENABLE_RELEASE
CFLAGS += -O2
DFLAGS += -O -release -inline
endif
ifdef ENABLE_PROFILING
CFLAGS  += -pg -fprofile-arcs -ftest-coverage
endif
ifdef ENABLE_PGO_GENERATE
CFLAGS  += -fprofile-generate=${PGO_DIR}
endif
ifdef ENABLE_PGO_USE
CFLAGS  += -fprofile-use=${PGO_DIR} -freorder-blocks-and-partition
endif
ifdef ENABLE_LTO
CFLAGS  += -flto
endif

# Uniqe extra flags if necessary
DMD_FLAGS  := -I$(ROOT) -Wuninitialized
GLUE_FLAGS := -I$(ROOT) -I$(TK) -I$(C)
BACK_FLAGS := -I$(ROOT) -I$(TK) -I$(C) -I. -DDMDV2=1
ROOT_FLAGS := -I$(ROOT)

ifeq ($(OS), osx)
ifeq ($(MODEL), 64)
D_OBJC := 1
endif
endif


DMD_SRCS=$(addsuffix .d,access aggregate aliasthis apply argtypes arrayop	\
	arraytypes attrib backend builtin canthrow clone complex cond constfold	\
	cppmangle ctfeexpr dcast dclass declaration delegatize denum dimport	\
	dinifile dinterpret dmacro dmangle dmodule doc dscope dstruct dsymbol	\
	dtemplate dunittest dversion entity errors escape expression func	\
	globals hdrgen id identifier impcnvtab imphint init inline intrange	\
	json lexer lib link mars mtype nogc nspace opover optimize parse sapply	\
	sideeffect statement staticassert target tokens traits utf visitor \
	typinf irstate toelfdebug toctype)

ifeq ($(D_OBJC),1)
	DMD_SRCS += objc.d
else
	DMD_SRCS += objc_stubs.d
endif

ROOT_SRCS = $(addsuffix .d,$(addprefix $(ROOT)/,aav array file filename	\
	longdouble man outbuffer port response rmem rootobject speller	\
	stringtable))

GLUE_OBJS = glue.o msc.o s2ir.o todt.o e2ir.o tocsym.o toobj.o \
	toir.o iasm.o


ifeq ($(D_OBJC),1)
	GLUE_OBJS += objc_glue.o
else
	GLUE_OBJS += objc_glue_stubs.o
endif

ifeq (osx,$(OS))
    DMD_SRCS += libmach.d scanmach.d
else
    DMD_SRCS += libelf.d scanelf.d
endif

BACK_OBJS = go.o gdag.o gother.o gflow.o gloop.o var.o el.o \
	glocal.o os.o nteh.o evalu8.o cgcs.o \
	rtlsym.o cgelem.o cgen.o cgreg.o out.o \
	blockopt.o cg.o type.o dt.o \
	debug.o code.o ee.o symbol.o \
	cgcod.o cod5.o outbuf.o \
	bcomplex.o aa.o ti_achar.o \
	ti_pvoid.o pdata.o cv8.o backconfig.o \
	divcoeff.o dwarf.o \
	ph2.o util2.o eh.o tk.o strtold.o \
	$(TARGET_OBJS)

ifeq (osx,$(OS))
	BACK_OBJS += machobj.o
else
	BACK_OBJS += elfobj.o
endif

SRC = win32.mak posix.mak osmodel.mak aggregate.h aliasthis.h arraytypes.h	\
	attrib.h complex_t.h cond.h ctfe.h ctfe.h declaration.h dsymbol.h	\
	enum.h errors.h expression.h globals.h hdrgen.h identifier.h idgen.d	\
	import.h init.h intrange.h json.h lexer.h lib.h macro.h	\
	mars.h module.h mtype.h nspace.h objc.h parse.h                         \
	scope.h statement.h staticassert.h target.h template.h tokens.h utf.h	\
	version.h visitor.h libomf.d scanomf.d libmscoff.d scanmscoff.d         \
	$(DMD_SRCS)

ROOT_SRC = $(addprefix $(ROOT)/,aav.h array.h file.h filename.h		\
	longdouble.h newdelete.c object.h outbuffer.h port.h rmem.h	\
	root.h stringtable.h)

GLUE_SRC = glue.c msc.c s2ir.c todt.c e2ir.c tocsym.c \
	toobj.c tocvdebug.c toir.h toir.c \
	irstate.h iasm.c \
	toelfdebug.d libelf.d scanelf.d libmach.d scanmach.d \
	tk.c eh.c gluestub.d objc_glue.c objc_glue_stubs.c

BACK_SRC = \
	$C/cdef.h $C/cc.h $C/oper.h $C/ty.h $C/optabgen.c \
	$C/global.h $C/code.h $C/type.h $C/dt.h $C/cgcv.h \
	$C/el.h $C/iasm.h $C/rtlsym.h \
	$C/bcomplex.c $C/blockopt.c $C/cg.c $C/cg87.c $C/cgxmm.c \
	$C/cgcod.c $C/cgcs.c $C/cgcv.c $C/cgelem.c $C/cgen.c $C/cgobj.c \
	$C/cgreg.c $C/var.c $C/strtold.c \
	$C/cgsched.c $C/cod1.c $C/cod2.c $C/cod3.c $C/cod4.c $C/cod5.c \
	$C/code.c $C/symbol.c $C/debug.c $C/dt.c $C/ee.c $C/el.c \
	$C/evalu8.c $C/go.c $C/gflow.c $C/gdag.c \
	$C/gother.c $C/glocal.c $C/gloop.c $C/newman.c \
	$C/nteh.c $C/os.c $C/out.c $C/outbuf.c $C/ptrntab.c $C/rtlsym.c \
	$C/type.c $C/melf.h $C/mach.h $C/mscoff.h $C/bcomplex.h \
	$C/cdeflnx.h $C/outbuf.h $C/token.h $C/tassert.h \
	$C/elfobj.c $C/cv4.h $C/dwarf2.h $C/exh.h $C/go.h \
	$C/dwarf.c $C/dwarf.h $C/aa.h $C/aa.c $C/tinfo.h $C/ti_achar.c \
	$C/ti_pvoid.c $C/platform_stub.c $C/code_x86.h $C/code_stub.h \
	$C/machobj.c $C/mscoffobj.c \
	$C/xmm.h $C/obj.h $C/pdata.c $C/cv8.c $C/backconfig.c $C/divcoeff.c \
	$C/md5.c $C/md5.h \
	$C/ph2.c $C/util2.c \
	$(TARGET_CH)

TK_SRC = \
	$(TK)/filespec.h $(TK)/mem.h $(TK)/list.h $(TK)/vec.h \
	$(TK)/filespec.c $(TK)/mem.c $(TK)/vec.c $(TK)/list.c

STRING_IMPORT_FILES = verstr.h SYSCONFDIR.imp

DEPS = $(patsubst %.o,%.deps,$(DMD_OBJS) $(GLUE_OBJS) $(BACK_OBJS))

all: dmd

auto-tester-build: dmd checkwhitespace
.PHONY: auto-tester-build

glue.a: $(GLUE_OBJS)
	$(AR) rcs glue.a $(GLUE_OBJS)

backend.a: $(BACK_OBJS)
	$(AR) rcs backend.a $(BACK_OBJS)

ifdef ENABLE_LTO
dmd: $(DMD_SRCS) $(ROOT_SRCS) newdelete.o $(GLUE_OBJS) $(BACK_OBJS) $(STRING_IMPORT_FILES) $(HOST_DMD_PATH)
	CC=$(HOST_CC) $(HOST_DMD_RUN) -of$@ $(MODEL_FLAG) -vtls -J. -L-lstdc++ $(DFLAGS) $(filter-out $(STRING_IMPORT_FILES) $(HOST_DMD_PATH),$^)
else
dmd: $(DMD_SRCS) $(ROOT_SRCS) newdelete.o glue.a backend.a $(STRING_IMPORT_FILES) $(HOST_DMD_PATH)
	CC=$(HOST_CC) $(HOST_DMD_RUN) -of$@ $(MODEL_FLAG) -vtls -J. -L-lstdc++ $(DFLAGS) $(filter-out $(STRING_IMPORT_FILES) $(HOST_DMD_PATH),$^)
endif

clean:
	rm -f newdelete.o $(GLUE_OBJS) $(BACK_OBJS) dmd optab.o id.o	\
		idgen $(idgen_output) optabgen $(optabgen_output)	\
		verstr.h SYSCONFDIR.imp core *.cov *.deps *.gcda *.gcno *.a
	@[ ! -d ${PGO_DIR} ] || echo You should issue manually: rm -rf ${PGO_DIR}

######## Download and install the last dmd buildable without dmd

ifneq (,$(AUTO_BOOTSTRAP))
$(HOST_DMD_PATH):
	mkdir -p ${HOST_DMD_ROOT}
	TMPFILE=$$(mktemp deleteme.XXXXXXXX) && curl -fsSL ${HOST_DMD_URL} > $${TMPFILE}.zip && \
		unzip -qd ${HOST_DMD_ROOT} $${TMPFILE}.zip && rm $${TMPFILE}.zip
endif

######## generate a default dmd.conf

define DEFAULT_DMD_CONF
[Environment32]
DFLAGS=-I%@P%/../../druntime/import -I%@P%/../../phobos -L-L%@P%/../../phobos/generated/$(OS)/release/32$(if $(filter $(OS),osx),, -L--export-dynamic)

[Environment64]
DFLAGS=-I%@P%/../../druntime/import -I%@P%/../../phobos -L-L%@P%/../../phobos/generated/$(OS)/release/64$(if $(filter $(OS),osx),, -L--export-dynamic)
endef

export DEFAULT_DMD_CONF

dmd.conf:
	[ -f $@ ] || echo "$$DEFAULT_DMD_CONF" > $@

######## optabgen generates some source

optabgen: $C/optabgen.c $C/cc.h $C/oper.h
	$(CC) $(CFLAGS) -I$(TK) $< -o optabgen
	./optabgen

optabgen_output = debtab.c optab.c cdxxx.c elxxx.c fltables.c tytab.c
$(optabgen_output) : optabgen

######## idgen generates some source

idgen_output = id.h id.d
$(idgen_output) : idgen

idgen: idgen.d $(HOST_DMD_PATH)
	CC=$(HOST_CC) $(HOST_DMD_RUN) $<
	./idgen

#########
# STRING_IMPORT_FILES
#
# Create (or update) the verstr.h file.
# The file is only updated if the VERSION file changes, or, only when RELEASE=1
# is not used, when the full version string changes (i.e. when the git hash or
# the working tree dirty states changes).
# The full version string have the form VERSION-devel-HASH(-dirty).
# The "-dirty" part is only present when the repository had uncommitted changes
# at the moment it was compiled (only files already tracked by git are taken
# into account, untracked files don't affect the dirty state).
VERSION := $(shell cat ../VERSION)
ifneq (1,$(RELEASE))
VERSION_GIT := $(shell printf "`$(GIT) rev-parse --short HEAD`"; \
       test -n "`$(GIT) status --porcelain -uno`" && printf -- -dirty)
VERSION := $(addsuffix -devel$(if $(VERSION_GIT),-$(VERSION_GIT)),$(VERSION))
endif
$(shell test \"$(VERSION)\" != "`cat verstr.h 2> /dev/null`" \
		&& printf \"$(VERSION)\" > verstr.h )
$(shell test $(SYSCONFDIR) != "`cat SYSCONFDIR.imp 2> /dev/null`" \
		&& printf '$(SYSCONFDIR)' > SYSCONFDIR.imp )

#########

$(GLUE_OBJS) : $(idgen_output)
$(BACK_OBJS) : $(optabgen_output)


# Specific dependencies other than the source file for all objects
########################################################################
# If additional flags are needed for a specific file add a _CFLAGS as a
# dependency to the object file and assign the appropriate content.

cg.o: fltables.c

cgcod.o: cdxxx.c

cgelem.o: elxxx.c

debug.o: debtab.c

iasm.o: CFLAGS += -fexceptions

var.o: optab.c tytab.c


# Generic rules for all source files
########################################################################
# Search the directory $(C) for .c-files when using implicit pattern
# matching below.
vpath %.c $(C)

$(BACK_OBJS): %.o: %.c posix.mak
	@echo "  (CC)  BACK_OBJS  $<"
	$(CC) -c $(CFLAGS) $(BACK_FLAGS) $(MMD) $<

$(GLUE_OBJS): %.o: %.c posix.mak
	@echo "  (CC)  GLUE_OBJS  $<"
	$(CC) -c $(CFLAGS) $(GLUE_FLAGS) $(MMD) $<

newdelete.o: %.o: $(ROOT)/%.c posix.mak
	@echo "  (CC)  ROOT_OBJS  $<"
	$(CC) -c $(CFLAGS) $(ROOT_FLAGS) $(MMD) $<


-include $(DEPS)

######################################################

install: all
	$(eval bin_dir=$(if $(filter $(OS),osx), bin, bin$(MODEL)))
	mkdir -p $(INSTALL_DIR)/$(OS)/$(bin_dir)
	cp dmd $(INSTALL_DIR)/$(OS)/$(bin_dir)/dmd
	cp ../ini/$(OS)/$(bin_dir)/dmd.conf $(INSTALL_DIR)/$(OS)/$(bin_dir)/dmd.conf
	cp backendlicense.txt $(INSTALL_DIR)/dmd-backendlicense.txt
	cp boostlicense.txt $(INSTALL_DIR)/dmd-boostlicense.txt

######################################################

checkwhitespace: $(HOST_DMD_PATH)
	CC=$(HOST_CC) $(HOST_DMD_RUN) -run checkwhitespace $(SRC) $(GLUE_SRC) $(ROOT_SRCS)

######################################################

gcov:
	gcov $(filter %.c,$(SRC) $(GLUE_SRC))

######################################################

zip:
	-rm -f dmdsrc.zip
	zip dmdsrc $(SRC) $(ROOT_SRCS) $(GLUE_SRC) $(BACK_SRC) $(TK_SRC)

######################################################

../changelog.html: ../changelog.dd $(HOST_DMD_PATH)
	$(HOST_DMD_RUN) -Df$@ $<

#############################

.DELETE_ON_ERROR: # GNU Make directive (delete output files on error)
