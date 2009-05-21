%name SphuckFractional
%token_prefix SPHUCK_
%include {
  public $datum;

  function __construct() {
    $this->datum = new Stack();
  }
}

decimal ::= DIGITS_MAYBE_OCTOTHORPES(A) suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(A);
  $exact = has_octothorpes(A);
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DOT DIGITS_MAYBE_OCTOTHORPES(A) suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(sprintf('.%s', A));
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DIGITS(A) DOT DIGITS(B) OCTOTHORPES(C) suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(sprintf('%s.%s%s', A, B, C));
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DIGITS(A) DOT DIGITS(B) suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(sprintf('%s.%s', A, B));
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DIGITS(A) DOT suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(A);
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DIGITS(A) OCTOTHORPES(B) DOT OCTOTHORPES suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(sprintf('%s%s', A, B));
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

decimal ::= DIGITS(A) OCTOTHORPES(B) DOT suffix. {
  $exponent = $this->datum->pop();
  $decimal = digits_to_number(sprintf('%s%s', A, B));
  $exact = false;
  $this->datum->push(mul(real($decimal, $exact),
                         $exponent));
}

suffix ::= . {
  $this->datum->push(integer(1));
}

suffix ::= EXPONENT DIGITS(A). {
  $this->datum->push(real(digits_to_exponent(A),
                          false));
}

suffix ::= EXPONENT PLUS DIGITS. {
  $this->datum->push(real(digits_to_exponent(A),
                          false));
}

suffix ::= EXPONENT MINUS DIGITS. {
  $this->datum->push(real(digits_to_exponent(sprintf('-%s', A)),
                          false));
}
