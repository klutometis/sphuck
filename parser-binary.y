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
}

num_2 ::= prefix_2 complex_2.

complex_2 ::= real_2.

complex_2 ::= real_2 ASPERAND real_2.

complex_2 ::= real_2 PLUS ureal_2 IMAGINARY.

complex_2 ::= real_2 MINUS ureal_2 IMAGINARY.

complex_2 ::= real_2 PLUS IMAGINARY.

complex_2 ::= real_2 MINUS IMAGINARY.

complex_2 ::= real_2 IMAGINARY.

complex_2 ::= PLUS IMAGINARY.

complex_2 ::= MINUS IMAGINARY.

real_2 ::= sign ureal_2.

ureal_2 ::= uinteger_2.

ureal_2 ::= uinteger_2 DIVIDED_BY uinteger_2.

uinteger_2 ::= DIGITS_2.

prefix_2 ::= RADIX_2.

sign ::= .

sign ::= PLUS.

sign ::= MINUS.
