%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

expression ::= datum. {
}

datum ::= simple_datum. {
}

datum ::= compound_datum. {
}

simple_datum ::= BOOLEAN(A). {
  $this->datum->push(boolean(is_boolean_true(A)));
}

simple_datum ::= number. {
}

simple_datum ::= CHARACTER(A). {
  // not quite right; refine this; store numeric?
  $this->datum->push(char(A));
}

simple_datum ::= STRING(A). {
  $this->datum->push(string(substr(A, 1, strlen(A) - 1 - 1)));
}

simple_datum ::= symbol. {
}

number ::= NUM_2(A). {
  $this->datum->push(parse_binary(A));
}

number ::= NUM_8(A). {
  $this->datum->push(parse_octal(A));
}

number ::= NUM_10(A). {
  $this->datum->push(parse_decimal(A));
}

number ::= NUM_16(A). {
  $this->datum->push(parse_hex(A));
}

symbol ::= IDENTIFIER(A). {
  $this->datum->push(symbol(A));
}

compound_datum ::= list. {
}

compound_datum ::= vector. {
}

list ::= OPEN list_elements CLOSE. {
}

list ::= OPEN list_elements datum DOT datum CLOSE. {
}

list ::= abbreviation. {
}

list_elements ::= . {
}

list_elements ::= list_elements datum. {
}

abbreviation ::= abbrev_prefix datum. {
}

abbrev_prefix ::= QUOTE. {
}

abbrev_prefix ::= QQUOTE. {
}

abbrev_prefix ::= UNQUOTE. {
}

abbrev_prefix ::= UNQUOTE_SPLICING. {
}

vector ::= VECTOR_OPEN vector_elements CLOSE. {
}

vector_elements ::= . {
}

vector_elements ::= vector_elements datum. {
}
