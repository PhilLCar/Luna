# File: makefile

.SUFFIXES: .lua .s .c .o .exe .tex .pdf

PDFLATEX=pdflatex
MKFILE_PATH:=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

all: stdio.o
	@echo "Please add $(MKFILE_PATH) to your PATH to use Luna from any folder"
	@echo "You can do this by executing :"
	@echo '	% export PATH=$(MKFILE_PATH):$$PATH'

.s.o.c:
	gcc -c -o $*.s $*.o $*.c

test: ut

ut: @echo "not implemented yet"

clean: cleanrapport
	rm -f *.o *.ir *.exe *.out.s *~ unit-tests/*.s unit-tests/*.exe unit-tests/*~ unit-tests/*.ir

cleanrapport:
	rm -f *.aux *.log *.pdf *.out

cleansubfiles:
	rm -f *.pp.lua *.lir *.out.s *.aux *.log unit-tests/*.s unit-tests/*.ir

cleancompile: cleansubfiles
	rm -f *.exe unit-tests/*.exe

rapport:
	for f in *.tex; do $(PDFLATEX) "$$f"; done
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
	@echo "    cleancompile  : cleans all compiler generated files (keeps the compiler usable)"

h: help
