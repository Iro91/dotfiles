include Config.mk
$(info $(WS))
EXE 		 := Bench

SRCS     :=
SRCS     += main.cpp

FLAGS :=
FLAGS +=

LIBS :=

$(EXE) : LDLIBS += -lstdc++fs

$(eval $(call MAKE_EXE,$(EXE),$(SRCS),$(FLAGS),$(LIBS)))
