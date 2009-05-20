%name SphuckBinary
%token_prefix SPHUCK_BINARY_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

num_2 ::= prefix_2 complex_2. {
  $number = $this->datum->pop();
  $exact = $this->datum->pop();
  // this should allow us to override composite exactness when
  // octothorpes are present; but #e1###? with #e, there is an
  // implicit conversion.
  $number->exact = $exact;
  $this->datum->push($number);
}

complex_2 ::= real_2. {
  // no op; real already has a nullary imaginary part
}

complex_2 ::= real_2 ASPERAND real_2. {
  $argument = $this->datum->pop();
  $modulus = $this->datum->pop();
  $this->datum->push(complex(mul($modulus, cosine($argument)),
                             mul($modulus, sine($argument))));
}

complex_2 ::= real_2 PLUS ureal_2 IMAGINARY. {
  $imaginary = $this->datum->pop();
  $real = $this->datum->pop();
  $this->datum->push(complex($real, $imaginary));
}

complex_2 ::= real_2 MINUS ureal_2 IMAGINARY. {
  $imaginary = $this->datum->pop();
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             mul($imaginary,
                                 integer(-1))));
}

complex_2 ::= real_2 PLUS IMAGINARY. {
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             integer(1)));
}

complex_2 ::= real_2 MINUS IMAGINARY. {
  $real = $this->datum->pop();
  $this->datum->push(complex($real,
                             integer(-1)));
}

complex_2 ::= real_2 IMAGINARY. {
  $imaginary = $this->datum->pop();
  $this->datum->push(complex(zero(),
                             $imaginary));
}

complex_2 ::= PLUS IMAGINARY. {
  $this->datum->push(complex(zero(),
                             integer(1)));
}

complex_2 ::= MINUS IMAGINARY. {
  $this->datum->push(complex(zero(),
                             integer(-1)));
}

real_2 ::= sign ureal_2. {
  $unsigned_real = $this->datum->pop();
  $sign = $this->datum->pop();
  $this->datum->push(mul($sign, $unsigned_real));
}

ureal_2 ::= uinteger_2. {
  $integer = $this->datum->pop();
  $this->datum->push(integer($integer));
}

ureal_2 ::= uinteger_2 DIVIDED_BY uinteger_2. {
  $numerator = $this->datum->pop();
  $denominator = $this->datum->pop();
  $this->datum->push(rational($numerator, $denominator));
}

uinteger_2 ::= DIGITS_2(A). {
  $this->datum->push(digits_to_number(A, 2));
}

prefix_2 ::= RADIX_2(A). {
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
