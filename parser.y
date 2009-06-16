%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;
  public $callback;

  function __construct($callback) {
    $this->datum = new Stack();
    $this->callback = $callback;
  }
}
%parse_accept {
  // optional callback mechanism for putting token back in stream
  print "%parse_accept\n";
  /* global $token; */
  /* var_dump($token); */
  /* printf('-strlen($token->value): %s; $token->value: %s' . "\n", */
  /*        -strlen($token->value), */
  /*        $token->value); */
  /* if ($token) */
  /*   $this->lexer->fseek(-strlen($token->value), SEEK_CUR); */
  /* $this->Sphuck(0); */
  /* if ($token) */
  /*   $this->lexer->fseek($token->char, SEEK_SET); */
  /* if ($token) */
  /*   $this->Sphuck($token->type, $token->value); */
  /* $this->lexer->restore_state(); */
  call_user_func($this->callback);
  /* $this->Sphuck(0); */
}

legendum ::= datum. {
  // legendum < lego, -i: "[thing] to be read"
  print "legendum ::= datum.\n";
}

datum ::= simple_datum. {
  print "datum ::= simple_datum.\n";
}

datum ::= compound_datum. {
  print "datum ::= compound_datum.\n";
}

simple_datum ::= BOOLEAN(A). {
  print "simple_datum ::= BOOLEAN(A).\n";
  $this->datum->push(boolean(is_boolean_true(A)));
}

simple_datum ::= number. {
  print "simple_datum ::= number.\n";
}

simple_datum ::= CHARACTER(A). {
  print "simple_datum ::= CHARACTER(A).\n";
  // not quite right; refine this; store numeric?
  $this->datum->push(char(A));
}

simple_datum ::= STRING(A). {
  print "simple_datum ::= STRING(A).\n";
  $this->datum->push(string(substr(A, 1, strlen(A) - 1 - 1)));
}

simple_datum ::= symbol. {
  print "simple_datum ::= symbol.\n";
}

number ::= NUM_2(A). {
  print "number ::= NUM_2(A).\n";
  $this->datum->push(parse_binary(A));
}

number ::= NUM_8(A). {
  print "number ::= NUM_8(A).\n";
  $this->datum->push(parse_octal(A));
}

number ::= NUM_10(A). {
  print "number ::= NUM_10(A).\n";
  $this->datum->push(parse_decimal(A));
}

number ::= NUM_16(A). {
  print "number ::= NUM_16(A).\n";
  $this->datum->push(parse_hex(A));
}

symbol ::= IDENTIFIER(A). {
  print "symbol ::= IDENTIFIER(A).\n";
  $this->datum->push(symbol(A));
}

compound_datum ::= list. {
  print "compound_datum ::= list.\n";
}

compound_datum ::= vector. {
  print "compound_datum ::= vector.\n";
}

list ::= OPEN list_elements CLOSE. {
  print "list ::= OPEN list_elements CLOSE.\n";
}

list ::= OPEN list_elements datum DOT datum CLOSE. {
  print "list ::= OPEN list_elements datum DOT datum CLOSE.\n";
  $cdr = $this->datum->pop();
  $car = $this->datum->pop();
  $rest = $this->datum->pop();
  $this->datum->push(append($rest, cons($car, $cdr)));
}

list ::= abbreviation. {
  print "list ::= abbreviation.\n";
}

list_elements ::= . {
  // push NIL
  print "list_elements ::= .\n";
  $this->datum->push(NULL);
}

list_elements ::= list_elements datum. {
  print "list_elements ::= list_elements datum.\n";
  $car = $this->datum->pop();
  $cdr = $this->datum->pop();
  $this->datum->push(cons($car, $cdr));
}

abbreviation ::= abbrev_prefix datum. {
  print "abbreviation ::= abbrev_prefix datum.\n";
  $datum = $this->datum->pop();
  $prefix = $this->datum->pop();
  $this->datum->push(lst($prefix, $datum));
}

abbrev_prefix ::= QUOTE. {
  print "abbrev_prefix ::= QUOTE.\n";
  $this->datum->push(symbol('quote'));
}

abbrev_prefix ::= QQUOTE. {
  print "abbrev_prefix ::= QQUOTE.\n";
  $this->datum->push(symbol('quasiquote'));
}

abbrev_prefix ::= UNQUOTE. {
  print "abbrev_prefix ::= UNQUOTE.\n";
  $this->datum->push(symbol('unquote'));
}

abbrev_prefix ::= UNQUOTE_SPLICING. {
  print "abbrev_prefix ::= UNQUOTE_SPLICING.\n";
  $this->datum->push(symbol('unquote-splicing'));
}

abbrev_prefix ::= QUOTE_SYNTAX. {
  print "abbrev_prefix ::= QUOTE_SYNTAX.\n";
  $this->datum->push(symbol('syntax'));
}

vector ::= OPEN_VECTOR vector_elements CLOSE. {
  print "vector ::= OPEN_VECTOR vector_elements CLOSE.\n";
  $data = $this->datum->pop();
  $this->datum->push(vector($data));
}

vector_elements ::= . {
  print "vector_elements ::= .\n";
  $this->datum->push(array());
}

vector_elements ::= vector_elements datum. {
  print "vector_elements ::= vector_elements datum.\n";
  $datum = $this->datum->pop();
  // have to pop, otherwise calls-by-value
  $vector = $this->datum->pop();
  array_push($vector, $datum);
  $this->datum->push($vector);
}
