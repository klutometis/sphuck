%name SphuckBinary
%token_prefix SPHUCK_BINARY_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }

  function leaf($datum) {
    $this->datum->push($datum);
  }

  function nonterminal($nonterminal) {
    $this->datum->push(new Stack(array(), $nonterminal));
  }

  function promote() {
    $token = $this->datum->pop();
    $this->datum->peek()->push($token);
  }

  function is_inexact($radix) {
    return stripos($radix, '#i') !== false;
  }

  // includes cases, for instance, where no exactness is specified
  function is_exact($radix) {
    return !$this->is_inexact($radix);
  }

  function normalize_digits($digits) {
    return strtr($digits, '#', '0');
  }

  function binary_digits_to_number($digits) {
    return intval($this->normalize_digits($digits), 2);
  }
}

num_2 ::= prefix_2 complex_2. {
  print "num_2 ::= prefix_2 complex_2.\n";
  $number = $this->datum->pop();
  $exact = $this->datum->pop();
  $number->exact = $exact;
  $this->datum->push($number);
}

complex_2 ::= real_2. {
  print "complex_2 ::= real_2.\n";
}

complex_2 ::= real_2 ASPERAND real_2. {
  print "complex_2 ::= real_2 ASPERAND real_2.\n";
}

complex_2 ::= real_2 PLUS ureal_2 IMAGINARY. {
  print "complex_2 ::= real_2 PLUS ureal_2 IMAGINARY.\n";
  $imaginary = $this->datum->pop();
  $real = $this->datum->pop();
  $this->datum->push(complex($real, $imaginary));
}

complex_2 ::= real_2 MINUS ureal_2 IMAGINARY. {
  print "complex_2 ::= real_2 MINUS ureal_2 IMAGINARY.\n";
}

complex_2 ::= real_2 PLUS IMAGINARY. {
  print "complex_2 ::= real_2 PLUS IMAGINARY.\n";
}

complex_2 ::= real_2 MINUS IMAGINARY. {
  print "complex_2 ::= real_2 MINUS IMAGINARY.\n";
}

complex_2 ::= real_2 IMAGINARY. {
  print "complex_2 ::= real_2 IMAGINARY.\n";
}

complex_2 ::= PLUS IMAGINARY. {
  print "complex_2 ::= PLUS IMAGINARY.\n";
}

complex_2 ::= MINUS IMAGINARY. {
  print "complex_2 ::= MINUS IMAGINARY.\n";
}

real_2 ::= sign ureal_2. {
  print "real_2 ::= sign ureal_2.\n";
  $unsigned_real = $this->datum->pop();
  $sign = $this->datum->pop();
  $this->datum->push(mul($sign, $unsigned_real));
}

ureal_2 ::= uinteger_2. {
  print "ureal_2 ::= uinteger_2.\n";
  $integer = $this->datum->pop();
  $this->datum->push(integer($integer));
}

ureal_2 ::= uinteger_2 DIVIDED_BY uinteger_2. {
  print "ureal_2 ::= uinteger_2 DIVIDED_BY uinteger_2.\n";
  $numerator = $this->datum->pop();
  $denominator = $this->datum->pop();
  $this->datum->push(rational($numerator, $denominator));
}

uinteger_2 ::= DIGITS_2(A). {
  print "uinteger_2 ::= DIGITS_2.\n";
  $this->datum->push($this->binary_digits_to_number(A));
}

prefix_2 ::= RADIX_2(A). {
  print "prefix_2 ::= RADIX_2.\n";
  $this->datum->push($this->is_exact(A));
}

sign ::= . {
  print "sign ::= .\n";
  // positive modifier
  $this->datum->push(integer(1));
}

sign ::= PLUS. {
  print "sign ::= PLUS.\n";
  // positive modifier
  $this->datum->push(integer(1));
}

sign ::= MINUS. {
  print "sign ::= MINUS.\n";
  // negative modifier
  $this->datum->push(integer(-1));
}
