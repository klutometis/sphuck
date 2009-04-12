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

  function heynow($data) {
    foreach (new Lexer($data) as $token => $value) {
      $this->doParse($token, $value);
    }
    $this->doParse(0, 0);
    return $this->values;
  }
 }

sexpression ::= expressions. {
}

expressions ::= expressions expression. {
}

expressions ::= . {
}

expression ::= NUMBER(N). {
  $this->values->push(number(intval(N)));
}

expression ::= STRING(S). {
  $this->values->push(string(S));
}

expression ::= SYMBOL(S). {
  $this->values->push(string(S));
}

expression ::= list. {
  $this->values->push($this->expression);
}

expression ::= quoted. {
  $this->values->push(cons(symbol('quote'),
                           pair($this->values->pop())));
}

expression ::= quasiquoted. {
  $this->values->push(cons(symbol('quasiquote'),
                           pair($this->values->pop())));
}

expression ::= unquoted. {
  $this->values->push(cons(symbol('unquote'),
                           pair($this->values->pop())));
}

expression ::= unquote_spliced. {
  $this->values->push(cons(symbol('unquote-splicing'),
                           pair($this->values->pop())));
}

list ::= OPEN list_interior CLOSE. {
}

list_interior ::= expression DOT expression. {
  $cdr = $this->values->pop();
  $car = $this->values->pop();
  $this->expression = pair($car, $cdr);
}

list_interior ::= expression list_interior. {
  $this->expression = cons($this->values->pop(),
                           $this->expression);
}

list_interior ::= expression. {
  $this->expression = pair($this->values->pop());
}

quoted ::= QUOTE expression. {
}

quasiquoted ::= QUASIQUOTE expression. {
}
    
unquoted ::= UNQUOTE expression. {
}

unquote_spliced ::= UNQUOTE_SPLICING expression. {
}
