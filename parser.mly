%{
open Compile

%}

%token <int> NUM
%token <string> ID
%token ADD1 SUB1 LPAREN RPAREN LET IN EQUAL EOF

%type <Compile.program> program

%start program

%%

const :
  | NUM { Number($1) }

prim1 :
  | ADD1 { Add1 }
  | SUB1 { Sub1 }

expr :
  | LET ID EQUAL expr IN expr { Let($2, $4, $6) }
  | prim1 LPAREN expr RPAREN { Prim1($1, $3) }
  | const { $1 }
  | ID { Id($1) }

program :
  | expr EOF { $1 }

%%
