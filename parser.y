%declare_class { class Parser }
%include_class {
  public $expressions;
  public $current;
 }

sexpression ::= expression. {
  printf("sexpression: expression\n");
}

expression ::= NUMBER(N). {
  printf("expression: number: %s\n", N);
  $this->current[] = intval(N);
}

expression ::= STRING(S). {
  printf("expression: string: %s\n", S);
  $this->current[] = S;
}

expression ::= SYMBOL(S). {
  printf("expression: symbol: %s\n", S);
  $this->current[] = 's: ' . S;
}

expression ::= list. {
  printf("expression: list\n");
}

expression ::= quoted.
expression ::= quasiquoted.
expression ::= unquoted.
expression ::= unquote_spliced.

list ::= OPEN list_interior CLOSE. {
  printf("list: open interior close\n");
  $this->expressions[] = $this->current;
}

list_interior ::= expression DOT expression. { printf("interior: expression . expression\n"); }
list_interior ::= expression list_interior. { printf("interior: expression interior\n"); }
list_interior ::= expression. { printf("interior: interior expression\n"); }
quoted ::= QUOTE expression.
quasiquoted ::= QUASIQUOTE expression.
unquoted ::= UNQUOTE expression.
unquote_spliced ::= UNQUOTE_SPLICING expression.
