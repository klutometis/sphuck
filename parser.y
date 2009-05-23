%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

expression ::= datum. {
  print "expression ::= datum.\n";
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
}

abbrev_prefix ::= QUOTE. {
  print "abbrev_prefix ::= QUOTE.\n";
}

abbrev_prefix ::= QQUOTE. {
  print "abbrev_prefix ::= QQUOTE.\n";
}

abbrev_prefix ::= UNQUOTE. {
  print "abbrev_prefix ::= UNQUOTE.\n";
}

abbrev_prefix ::= UNQUOTE_SPLICING. {
  print "abbrev_prefix ::= UNQUOTE_SPLICING.\n";
}

vector ::= VECTOR_OPEN vector_elements CLOSE. {
  print "vector ::= VECTOR_OPEN vector_elements CLOSE.\n";
}

vector_elements ::= . {
  print "vector_elements ::= .\n";
}

vector_elements ::= vector_elements datum. {
  print "vector_elements ::= vector_elements datum.\n";
}
