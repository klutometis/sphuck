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
}

expressions ::= expressions expression. {
}

expressions ::= . {
}

expression ::= NUMBER(N). {
  $this->values->push(new Number(intval(N)));
}

expression ::= STRING(S). {
  $this->values->push(new String(S));
}

expression ::= SYMBOL(S). {
  $this->values->push(new Symbol(S));
}

expression ::= list. {
  $this->values->push($this->expression);
}

expression ::= quoted. {
  $this->values->push(cons(new Symbol('quote'),
                           new Pair($this->values->pop())));
}

expression ::= quasiquoted. {
  $this->values->push(cons(new Symbol('quasiquote'),
                           new Pair($this->values->pop())));
}

expression ::= unquoted. {
  $this->values->push(cons(new Symbol('unquote'),
                           new Pair($this->values->pop())));
}

expression ::= unquote_spliced. {
  $this->values->push(cons(new Symbol('unquote-splicing'),
                           new Pair($this->values->pop())));
}

list ::= OPEN list_interior CLOSE. {
}

list_interior ::= expression DOT expression. {
  $cdr = $this->values->pop();
  $car = $this->values->pop();
  $this->expression = new Pair($car, $cdr);
}

list_interior ::= expression list_interior. {
  $this->expression = cons($this->values->pop(),
                           $this->expression);
}

list_interior ::= expression. {
  $this->expression = new Pair($this->values->pop());
}

quoted ::= QUOTE expression. {
}

quasiquoted ::= QUASIQUOTE expression. {
}
    
unquoted ::= UNQUOTE expression. {
}

unquote_spliced ::= UNQUOTE_SPLICING expression. {
}
