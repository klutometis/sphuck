%declare_class { class Parser }

%include {
  require_once('stack.php');
  require_once('pair.php');
  require_once('symbol.php');
  require_once('string.php');
  require_once('number.php');
 }

%include_class {
  public $values;
  public $expression;

  function __construct() {
    $this->expression = NULL;
    /* (VALUES ...) */
    $this->values = new Stack();
  }
 }

sexpression ::= expressions. {
  printf("sexpression: expression\n");
}

expressions ::= expressions expression.

expressions ::= .

expression ::= NUMBER(N). {
  printf("expression: number: %s\n", N);
  $this->values->push(new Number(intval(N)));
}

expression ::= STRING(S). {
  printf("expression: string: %s\n", S);
  $this->values->push(new String(S));
}

expression ::= SYMBOL(S). {
  printf("expression: symbol: %s\n", S);
  $this->values->push(new Symbol(S));
  /* var_dump($this->yystack); */
}

expression ::= list. {
  printf("expression: list\n");
  $this->values->push($this->expression);
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
  $this->expression = cons($this->values->pop(),
                           $this->expression);
}

/* last member of this tree node; we'll see this first */
list_interior ::= expression. {
  printf("interior: expression\n");
  $this->expression = new Pair($this->values->pop());
}

quoted ::= QUOTE expression.
quasiquoted ::= QUASIQUOTE expression.
unquoted ::= UNQUOTE expression.
unquote_spliced ::= UNQUOTE_SPLICING expression.
