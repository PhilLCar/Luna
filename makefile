# File: makefile

.SUFFIXES: .lua .s .c .o .exe .tex .pdf

PDFLATEX = pdflatex
CC     := gcc
LUAC   := ./luna
CFLAGS := -Wall -Wstrict-prototypes -Wextra -pedantic -fPIC 
LFLAGS := -lib

MKFILE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
LIB         := library
CSRC        := $(LIB)/c
SSRC        := $(LIB)/asm
LSRC        := $(LIB)/lua
OBJ         := $(LIB)/o


CFILES := $(wildcard $(CSRC)/*.c)
SFILES := $(wildcard $(SSRC)/*.s)
LFILES := $(wildcard $(LSRC)/*.lua)

OBJL := $(patsubst $(LSRC)/%.lua, $(OBJ)/%.o, $(LFILES))
OBJC := $(patsubst $(CSRC)/%.c, $(OBJ)/%.o, $(CFILES))
OBJS := $(patsubst $(SSRC)/%.s, $(OBJ)/%.o, $(SFILES))

all: lib
	@echo "You can add $(MKFILE_PATH) to your PATH to use Luna from any folder"
	@echo "You can do this by executing :"
	@echo '	% export PATH=$(MKFILE_PATH):$$PATH'

lib: rmlib $(OBJL) $(OBJC) $(OBJS) #$(LIB)/shared/baselib.so

$(OBJ)/%.o: $(CSRC)/%.c
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/%.o: $(SSRC)/%.s
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ)/%.o: $(LSRC)/%.lua
	@$(LUAC) $(LFLAGS) $< $@

#$(LIB)/shared/baselib.so:
#	$(CC) $(CFLAGS) -shared -O -g $(CFILES) $(SFILES) -o baselib.so

rmlib:
	@$(RM) $(OBJ)/*.o $(LIB)/.lib

test: ut

ut: cleancompile lib
	@./run-unit-tests.lua

clean: cleancompile cleanrapport

cleancompile:
	@$(RM) unit-tests/*.s unit-tests/*.exe unit-tests/*.lir unit-tests/*.pp.lua

cleanrapport:
	@$(RM) doc/*.aux doc/*.log doc/*.pdf doc/*.out

cleansubfiles:
	@$(RM) doc/*.aux doc/*.log doc/*.out unit-tests/*.s unit-tests/*.lir unit-tests/*.pp.lua

rapport:
	@for f in doc/*.tex; do $(PDFLATEX) "$$f"; done
	make cleansubfiles

.tex.pdf:
	$(PDFLATEX) $*.tex
	make cleansubfiles

help:
	@echo "MAKE COMMANDS"
	@echo ""
	@echo "Compiling"
	@echo "========="
	@echo "    all     : compiles the compiler's source files"
	@echo "    test    : compiles and runs all unitary tests"
	@echo "    rapport : compiles .tex files to pdf"
	@echo ""
	@echo "Cleaning"
	@echo "========"
	@echo "    clean         : cleans all generated files"
	@echo "    cleanrapport  : cleans .tex related subfiles"
	@echo "    cleansubfiles : cleans byproducts of compiling (.ir, .out.s, .log and .aux files)"
	@echo "    cleancompile  : cleans all unit-tests generated files"

h: help
