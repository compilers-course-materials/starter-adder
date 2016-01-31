UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  FORMAT=aout
else
ifeq ($(UNAME), Darwin)
  FORMAT=macho
endif
endif

PKGS=oUnit,extlib,unix
BUILD=ocamlbuild -r -use-ocamlfind

main: main.ml compile.ml runner.ml parser.mly lexer.mll
	$(BUILD) -package $(PKGS) main.native
	mv main.native main

test: compile.ml runner.ml test.ml
	$(BUILD) -package $(PKGS) test.native
	mv test.native test

output/%.run: output/%.o main.c
	clang -g -m32 -o $@ main.c $<

output/%.o: output/%.s
	nasm -f $(FORMAT) -o $@ $<

output/%.s: input/%.adder main
	./main.native $< > $@

clean:
	rm -rf output/*
	rm -f _build/* main.native test.native 
