CXX       := g++
CC        := gcc
CXXFLAGS  := -fpermissive -fPIC -g -std=c++17
CFLAGS    := -fpermissive -fPIC -g -std=c++17
CPPFLAGS  := -Dlinux
DEPFLAGS   = -MT $@ -MMD -MP -MF $(@:.o=.Td)

BLD_DIR   := bld
#######################################################
#
#  Extract "-j <THREADCOUNT>" from the command line
#
PID := $(shell cat /proc/$$$$/status | grep PPid | awk '{print $$2}')
THREADCOUNT := $(shell ps -p ${PID} -f | tail -n1 | grep -oP '\-j *\d+' | sed 's/-j//')
ifeq "$(THREADCOUNT)" ""
THREADCOUNT := 1
endif

# $(info THREADCOUNT: $(THREADCOUNT))

#######################################################

define ARCHIVE_LIBRARY =
rm -f $@
mkdir -p $(@D)
$(AR) $(ARFLAGS) $@ $^
endef

define CREATE_SHARED_LIBRARY =
rm -f $@
mkdir -p $(@D)
$(CXX) $(LDFLAGS) -shared -Wl,--soname=$(@F) $^ $(LOADLIBES) $(LDLIBS) -o $@
endef

define LINK_EXE =
mkdir -p $(@D)
$(CXX) $(LDFLAGS) $+ $(LOADLIBES) $(LDLIBS) -o $@
endef

define COMPILE_CXX_OBJECT =
mkdir -p $(@D)
$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(DEPFLAGS) $(COMPILERFLAGS_) -c $< -o $@
mv -f $(@:.o=.Td) $(@:.o=.d)
endef

define COMPILE_C_OBJECT =
mkdir -p $(@D)
$(CC) $(CPPFLAGS) $(CFLAGS) $(DEPFLAGS) $(COMPILERFLAGS_) -c $< -o $@
mv -f $(@:.o=.Td) $(@:.o=.d)
endef

define CLEAN_TARGET =
rm -f $(OBJS_)
rm -f $(OBJS_:.o=.d)
rm -f $(OBJS_:.o=.Td)
rm -f $(GEN_)
rm -f $(@:%-clean=%)
endef

#######################################################

.PHONY : all clean realclean libs libs-clean generated exes exes-clean

all : generated libs exes

clean : libs-clean exes-clean

realclean : clean

%.o : %.cpp

% : %.cpp

%.o : %.cc

% : %.cc

%.o : %.c

% : %.c

%.o : %

.PRECIOUS : $(BLD_DIR)/%.d

$(BLD_DIR)/%.d : ;

ifeq "$(findstring clean,$(MAKECMDGOALS))" ""
-include generated
endif

$(BLD_DIR)/%.cpp.o : %.cpp $(BLD_DIR)/%.cpp.d
	$(COMPILE_CXX_OBJECT)

$(BLD_DIR)/%.cc.o : %.cc $(BLD_DIR)/%.cc.d
	$(COMPILE_CXX_OBJECT)

$(BLD_DIR)/%.c.o : %.c $(BLD_DIR)/%.c.d
	$(COMPILE_CXX_OBJECT)

#######################################################
# MAKE_EXE
# writes the make rules to link an executable
# as well as a rule to clean the build
# products of the form {EXEPATH}-clean
#
# Args 1 = exe path from workspace root
#      2 = source paths from workspace root
#      3 = user added compiler flags
#      4 = library paths from workspace root
#
# Ex: $(eval $(call MAKE_EXE,\
#                   $(DEVELDIR)/util/buildInfo/print_build_info,\
#                   $(DEVELDIR)/util/buildInfo/print_build_info.cpp,\
#                   -I$(DEVELDIR)/include,\
#                   $(DEVELDIR)/util/buildInfo/libBuildInfo.a))
#
# Use make target variables to add LDFLAGS flags and LDLIBS, e.g.:
#   $(DEVELDIR)/util/buildInfo/print_build_info : LDFLAGS += -L"some-library-path"
#   $(DEVELDIR)/util/buildInfo/print_build_info : LDLIBS  += -lpthread
#
define MAKE_EXE
$(1) : $(2:%=$(BLD_DIR)/%.o)

$(1) : $(4)

$(2:%=$(BLD_DIR)/%.o) : private COMPILERFLAGS_:=$(3)

-include $(2:%=$(BLD_DIR)/%.d)

$(addsuffix -clean,$(1)) : private OBJS_:=$(2:%=$(BLD_DIR)/%.o)

$(addsuffix -clean,$(1)) :
	$$(CLEAN_TARGET)

$(1) :
	$$(LINK_EXE)

exes : $(1)

exes-clean : $(addsuffix -clean,$(1))

endef

#######################################################
# MAKE_LIB
# writes the make rules to archive objects into a static or shared library
# based on .a or .so extension
# as well as a rule to clean the build products of the form $(LIBPATH)-clean
# Args 1 = lib path from workspace root
#      2 = src paths from workspace root
#      3 = user added compiler flags
# Ex: $(eval $(call MAKE_LIB,$(DEVELDIR)/auth/AuthServerLib/libAuthServer.a,\
#                            $(DEVELDIR)/auth/AuthServerLib/AuthServer.cpp,\
#                            -Dlinux -I$(DEVELDIR)/include))
define MAKE_LIB
$(1) :
ifeq ($(filter %.so,$(1)),$(1))
	$$(CREATE_SHARED_LIBRARY)
else
	$$(ARCHIVE_LIBRARY)
endif

$(1) : $(2:%=$(BLD_DIR)/%.o)

$(2:%=$(BLD_DIR)/%.o) : private COMPILERFLAGS_:=$(3)

-include $(2:%=$(BLD_DIR)/%.d)

$(addsuffix -clean,$(1)) : private OBJS_:=$(2:%=$(BLD_DIR)/%.o)

$(addsuffix -clean,$(1)) :
	$$(CLEAN_TARGET)

libs : $(1)

libs-clean : $(addsuffix -clean,$(1))

endef
#######################################################

# COPY_SOURCES_TO_SUBDIR
# Args:
#   1 = name of target library
#   2 = list of target files
#   3 = list of target dir-trees (recursively copied)
#
# The source files must be one directory above the
# target files and dir-trees
# E.g.:
# Target   $(DEVELDIR)/ehs/client/uiLib/qt4/EhsPixmap.cpp
# Source   $(DEVELDIR)/ehs/client/uiLib/EhsPixmap.cpp
#
# The target dir (e.q. "qt4")is created and deleted during
# building and cleaning
#
define COPY_SOURCES_TO_SUBDIR =

generated : $2 $3

$(patsubst %/,%,$(dir $1)) :
	mkdir -p $$@

$2 : $(patsubst %/,%,$(dir $1))
	@cp -fpu $$(subst /$(notdir $(patsubst %/,%,$(dir $1)))/,/,$$@) $$@

$3 : $(patsubst %/,%,$(dir $1))
	@cp -rfpu $$(subst /$(notdir $(patsubst %/,%,$(dir $1)))/,/,$$@) $$@

$(addsuffix -clean,$1) : $(addsuffix -clean,$(patsubst %/,%,$(dir $1)))

.PHONY : $(addsuffix -clean,$(patsubst %/,%,$(dir $1)))
$(addsuffix -clean,$(patsubst %/,%,$(dir $1))) :
	rm -rf $$(subst -clean,,$$@)

endef
#######################################################
