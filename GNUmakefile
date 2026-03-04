# GNUmakefile for SmallMinesweeper (Linux/GNUstep)
#
# Simple Minesweeper game. Uses SmallStepLib for app lifecycle, menus,
# and window style.
#
# Build SmallStepLib first: cd ../SmallStepLib && make && make install
# Then: make

include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = SmallMinesweeper

SmallMinesweeper_OBJC_FILES = \
	main.m \
	App/AppDelegate.m \
	UI/MinesweeperWindow.m \
	UI/MinesweeperGridView.m

SmallMinesweeper_HEADER_FILES = \
	App/AppDelegate.h \
	UI/MinesweeperWindow.h \
	UI/MinesweeperGridView.h

SmallMinesweeper_INCLUDE_DIRS = \
	-I. \
	-IApp \
	-IUI \
	-I../SmallStepLib/SmallStep/Core \
	-I../SmallStepLib/SmallStep/Platform/Linux

# SmallStep framework (from SmallStepLib)
SMALLSTEP_FRAMEWORK := $(shell find ../SmallStepLib -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

SmallMinesweeper_LIBRARIES_DEPEND_UPON = -lobjc -lgnustep-gui -lgnustep-base
SmallMinesweeper_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined
SmallMinesweeper_ADDITIONAL_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -lSmallStep
SmallMinesweeper_TOOL_LIBS = -lSmallStep -lobjc

include $(GNUSTEP_MAKEFILES)/application.make
