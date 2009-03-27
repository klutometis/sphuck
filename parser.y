%declare_class { class Parser }
%include {
  require_once('stack.php');
  require_once('list.php');
 }
%include_class {
  public $values;
  public $expression;

  function __construct() {
    $this->expression = new Lst();
    $this->values = new Stack();
  }
 }

sexpression ::= expression. {
  printf("sexpression: expression\n");
}

expression ::= NUMBER(N). {
  printf("expression: number: %s\n", N);
  $this->values->push(intval(N));
}

expression ::= STRING(S). {
  printf("expression: string: %s\n", S);
  $this->values->push(S);
}

expression ::= SYMBOL(S). {
  printf("expression: symbol: %s\n", S);
  $this->values->push('s: ' . S);
  /* var_dump($this->yystack); */
}

expression ::= list. {
  printf("expression: list\n");
  $this->values->push($this->expression);
  /* var_dump($this->yystack); */
}

expression ::= quoted.
expression ::= quasiquoted.
expression ::= unquoted.
expression ::= unquote_spliced.

/* we'll see this before the expression list */
list ::= OPEN list_interior CLOSE. {
  printf("list: open interior close\n");
}

list_interior ::= expression DOT expression. {
  printf("interior: expression . expression\n");
}

/* an internal member of this tree node */
list_interior ::= expression list_interior. {
  printf("interior: expression interior\n");
  $this->expression->cons(array_pop($this->values));
}

/* last member of this tree node; we'll see this first */
list_interior ::= expression. {
  printf("interior: expression\n");
  $this->expression = new Lst(array_pop($this->values));
}

quoted ::= QUOTE expression.
quasiquoted ::= QUASIQUOTE expression.
unquoted ::= UNQUOTE expression.
unquote_spliced ::= UNQUOTE_SPLICING expression.
