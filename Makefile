cToSwiftFolder := ./BNFC_CToSwift/
grammar := Grammar.cf

all: build

build: grammar mapping
	
grammar: $(grammar)
	bnfc -c -m $(grammar) -o CGrammar 
	cd CGrammar && perl -0777 -i -pe 's:union *\n? *{ *\n? *} *u *; *://removed empty union due to swift incompatability:g' Absyn.h
	cd CGrammar && make

mapping:
	make run -f $(cToSwiftFolder)Makefile grammar=$(grammar) outputPath="DPTypeChecker" moduleName="CGrammar" additionalEnumCases="-extra-case 'Type' '\`default\`(CoreType, ReplicationIndex)' -extra-case 'Type' 'unknown' -extra-case 'CoreType' 'unknown'"

CGrammar-clean:
	cd CGrammar && rm -f *.o *.bak *.l *.y Test* Makefile Skeleton.* Printer.*

clean: CGrammar-clean
	cd $(cToSwiftFolder) && make mrproper-clean

mrproper-clean: clean
	cd CGrammar && rm -f Absyn.h Absyn.c Printer.h Printer.c Parser.h Parser.c Lexer.c
	cd DPTypeChecker && rm -f AbstractSyntax.swift CGrammarToSwiftBridge.swift
