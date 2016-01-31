UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  FORMAT=aout
else
ifeq ($(UNAME), Darwin)
  FORMAT=macho
endif
endif


main: main.ml compile.ml runner.ml parser.mly lexer.mll
	ocamlbuild -r -use-ocamlfind -package oUnit,extlib,unix  main.native
	mv main.native main

test: compile.ml runner.ml test.ml
	ocamlbuild -r -use-ocamlfind -package oUnit,extlib,unix  test.native
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
