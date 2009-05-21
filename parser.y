%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

num ::= NUM_2(A). {
  $this->datum->push(parse_binary(A));
}

num ::= NUM_8(A). {
  $this->datum->push(parse_octal(A));
}

num ::= NUM_10(A). {
  $this->datum->push(parse_decimal(A));
}

num ::= NUM_16(A). {
  $this->datum->push(parse_hex(A));
}
