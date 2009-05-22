%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

token ::= number. {
}

token ::= IDENTIFIER(A). {
  $this->datum->push(symbol(A));
}

token ::= BOOLEAN(A). {
  $this->datum->push(boolean(is_boolean_true(A)));
}

token ::= STRING(A). {
  $this->datum->push(string(substr(A, 1, strlen(A) - 1 - 1)));
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
