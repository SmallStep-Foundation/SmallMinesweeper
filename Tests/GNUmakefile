#
# SmallMinesweeper unit tests
# Build from SmallMinesweeper: make -f Tests/GNUmakefile
# Run: ./Tests/obj/test_SmallMinesweeper
#

include $(GNUSTEP_MAKEFILES)/common.make

SMALLSTEP_FRAMEWORK := $(shell find ../../SmallStepLib -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

TOOL_NAME = test_SmallMinesweeper
test_SmallMinesweeper_OBJC_FILES = \
	SmallMinesweeperTests.m \
	../App/AppDelegate.m \
	../UI/MinesweeperWindow.m \
	../UI/MinesweeperGridView.m

test_SmallMinesweeper_INCLUDE_DIRS = -I.. -I../App -I../UI
test_SmallMinesweeper_INCLUDE_DIRS += -I../../SmallStepLib/SmallStep/Core -I../../SmallStepLib/SmallStep/Platform/Linux
test_SmallMinesweeper_INCLUDE_DIRS += -I../../SmallStepLib/Tests
test_SmallMinesweeper_TOOL_LIBS = -lSmallStep -lgnustep-gui -lgnustep-base -lobjc
test_SmallMinesweeper_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined

before-all::
	$(MAKE) -C ../../SmallStepLib
	$(MAKE) -C ..

include $(GNUSTEP_MAKEFILES)/tool.make
