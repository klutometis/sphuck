%declare_class { class Parser }
%include_class { public $expression; }
sexpression ::= expression. { printf("sexpression: expression\n"); }
/* have to get more sophisto in the case of binary, hex, etc. and
   update lexer accordingly; also: booleans, exponents, complex
   numbers; should just fucking follow r5rs now that we have an idea
   as to what we're doing. */
expression ::= NUMBER(N). { printf("expression: number: %s\n", N); $this->expression[] = intval(N); }
expression ::= STRING(S). { printf("expression: string: %s\n", S); }
expression ::= SYMBOL(S). { printf("expression: symbol: %s\n", S); }
expression ::= list. { printf("expression: list\n"); }
expression ::= quoted.
expression ::= quasiquoted.
expression ::= unquoted.
expression ::= unquote_spliced.

list ::= OPEN list_interior CLOSE. { printf("list: open interior close\n"); }

list_interior ::= expression DOT expression. { printf("interior: expression . expression\n"); }
list_interior ::= expression list_interior. { printf("interior: expression interior\n"); }
list_interior ::= expression. { printf("interior: interior expression\n"); }
quoted ::= QUOTE expression.
quasiquoted ::= QUASIQUOTE expression.
unquoted ::= UNQUOTE expression.
unquote_spliced ::= UNQUOTE_SPLICING expression.
