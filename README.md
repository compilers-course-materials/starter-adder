#Adder

![An adder](https://upload.wikimedia.org/wikipedia/commons/2/28/Loch_Shin_adder.JPG)

In this assignment you'll implement a compiler for a small language called
Adder (because it primarily adds things).

## The Adder Language

In each of the next several assignments, we'll introduce a language that we'll
implement.  We'll start small, and build up features incrementally.  We're
starting with Adder, which has just a few features – defining variables, and
primitive operations on numbers.

There are a few pieces that go into defining a language for us to compile.

- A description of the concrete syntax – the text the programmer writes

- A description of the abstract syntax – how to express what the
  programmer wrote in a data structure our compiler uses.

- The _semantics_—or description of the behavior—of the abstrac
  syntax, so our compiler knows what the code it generates should do.

]

### Concrete Syntax

The concrete syntax of Adder is:

```
<expr> :=
  | <number>
  | <identifier>
  | let <bindings> in <expr>
  | add1(<expr>)
  | sub1(<expr>)

<bindings> :=
  | <identifier> = <expr>
  | <identifier> = <expr>, <bindings>
}
```

Here, a `let` expression can have one _or more_ bindings.


### Abstract Syntax


The abstract syntax of Adder is an OCaml datatype, and corresponds nearly
one-to-one with the concrete syntax.

```
type prim1 =
  | Add1
  | Sub1

type expr =
  | Number of int
  | Prim1 of prim1 * expr
  | Let of (string * expr) list * expr
  | Id of string
```


### Semantics

An Adder program always evaluates to a single integer.  `Number`s evaluate to
themselves (so a program just consisting of `Number(5)` should evaluate to the
integer `5`).  Primitive expressions perform addition or subtraction by one on
their argument.  Let bindings should evaluate all the binding expressions to
values one by one, and after each, map from the given name to the
corresponding value in both the rest of the bindings, and in the body of the
let expression.  Identifiers evaluate to whatever their current mapped value
is.  There are several examples further down.

The compiler should signal an error if:

- There is a binding list containing two or more bindings with the same name
- An identifier is unbound (there is no surrounding let binding for it)


Here are some examples of Adder programs:

| Concrete Syntax | Abstract Syntax | Answer |
------------------|-----------------|---------
| 5               | `Number(5)`     | 5      |
| sub1(add1(sub1(5))) | `Prim1(Sub1, Prim1(Add1, Prim1(Sub1, Number(5))))` | 4 |
| let x = 5, y = sub1(x) in sub1(y) | `Let([("x", Number(5)), ("y", Prim1(Sub1(Id("x"))))], Prim1(Sub1("y")))` | 3 |

## Implementing a Compiler for Adder}

You've been given a starter codebase that has several pieces of
infrastructure:

@itemlist[

@item{A parser for Adder (@tt{parser.mly} and @tt{lexer.mll}), which takes
concrete syntax (text files) and turns it into instances of the @tt{program}
datatype.}

@item{A main program (@tt{main.ml}) that uses the parser and compiler to produce
assembly code from an input Adder text file.}

@item{A @tt{Makefile} that builds @tt{main.ml}, builds a tester for Adder that
you will modify (@tt{test.ml}), and manipulates assembly programs created by
the Adder compiler.}

@item{An OCaml program (@tt{runner.ml}) that works in concert with the
@tt{Makefile} to allow you to compile and run an Adder program from within
OCaml, which is quite useful for testing.}

]

All of your edits—which will be to write the compiler for Adder, and test
it—will happen in @tt{test.ml} and @tt{compile.ml}.

### Writing the Compiler

The primary task of writing the Adder compiler is simple to state: take an
instance of the @tt{program} datatype and turn it into a list of assembly
instructions.  The provided compiler skeleton is set up to do just this,
broken up over a few functions.

The first is

```
compile : program -> instruction list
```

which takes a @tt{program} value (abstract syntax) and turns it into a list of
assembly instructions, represented by the @tt{instruction} type.  Then you
need to implement

```
to_asm_string : instruction list -> string
```

which renders the instruction datatype into a string representation of the
instructions.  This second step is straightforward, but forces you to
understand the syntax of the assembly code you are generating.  Most of the
compiler concepts happen in the first step, that of generating assembly
instructions from abstract syntax.




