%name SphuckNumber
%token_prefix SPHUCK_
%include {
  public $datum;
  public $radix;

  function __construct($radix) {
    $this->datum = new Stack();
    $this->radix = $radix;
  }
}

num ::= prefix complex. {
  $number = $this->datum->pop();
  $exact = $this->datum->pop();
  // this should allow us to override composite exactness when
  // octothorpes are present; but #e1###? with #e, there is an
  // implicit conversion.
  $number->exact = $exact;
  $this->datum->push($number);
}

complex ::= real. {
  // no op; real already has a nullary imaginary part
}

complex ::= real ASPERAND real. {
  $argument = $this->datum->pop();
  $modulus = $this->datum->pop();
  $this->datum->push(complex(mul($modulus, cosine($argument)),
                             mul($modulus, sine($argument))));
}

complex ::= real PLUS ureal IMAGINARY. {
  $imaginary = $this->datum->pop();
  $real = $this->datum->pop();
  $this->datum->push(complex($real, $imaginary));
}

complex ::= real MINUS ureal IMAGINARY. {
  $imaginary = $this->datum->pop();
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             mul($imaginary,
                                 integer(-1))));
}

complex ::= real PLUS IMAGINARY. {
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             integer(1)));
}

complex ::= real MINUS IMAGINARY. {
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             integer(-1)));
}

complex ::= real IMAGINARY. {
  $imaginary = $this->datum->pop();
  $this->datum->push(complex(zero(),
                             $imaginary));
}

complex ::= PLUS IMAGINARY. {
  $this->datum->push(complex(zero(),
                             integer(1)));
}

complex ::= MINUS IMAGINARY. {
  $this->datum->push(complex(zero(),
                             integer(-1)));
}

real ::= sign ureal. {
  $unsigned_real = $this->datum->pop();
  $sign = $this->datum->pop();
  $this->datum->push(mul($sign, $unsigned_real));
}

ureal ::= uinteger. {
  $integer = $this->datum->pop();
  $this->datum->push(integer($integer));
}

ureal ::= uinteger DIVIDED_BY uinteger. {
  $numerator = $this->datum->pop();
  $denominator = $this->datum->pop();
  $this->datum->push(rational($numerator, $denominator));
}

uinteger ::= DIGITS(A). {
  $this->datum->push(digits_to_number(A, 2));
}

prefix ::= RADIX(A). {
  $this->datum->push(is_exact(A));
}

sign ::= . {
  // positive modifier
  $this->datum->push(integer(1));
}

sign ::= PLUS. {
  // positive modifier
  $this->datum->push(integer(1));
}

sign ::= MINUS. {
  // negative modifier
  $this->datum->push(integer(-1));
}
