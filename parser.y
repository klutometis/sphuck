%name Sphuck
%token_prefix SPHUCK_
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
/* %right E S F D L. */
/* %left ASPERAND. */
/* %left PLUS MINUS. */
/* %right I. */


number ::= prefix complex. {
}

complex ::= real. {
}

complex ::= real ASPERAND real. {
}

complex ::= real PLUS ureal I. {
}

complex ::= real MINUS ureal I. {
}

complex ::= real PLUS I. {
}

complex ::= real MINUS I. {
}

// complex ::= PLUS ureal I. {
// }

// complex ::= MINUS ureal I. {
// }

complex ::= PLUS I. {
}

complex ::= MINUS I. {
}

real ::= sign ureal. {
}

ureal ::= uinteger. {
}

ureal ::= uinteger SLASH uinteger. {
}

ureal ::= decimal. {
}

decimal ::= uinteger suffix. {
  print 'decimal ::= uinteger suffix.' . "\n";
}

decimal ::= digits digit DOT digits octothorpes suffix. {
  print 'decimal ::= digit digits DOT digits octothorpes suffix.' . "\n";
  $suffix = $this->datum->pop();
  $octothorpes = $this->datum->pop();
  $fraction = $this->datum->pop();
  $integral = $this->datum->pop();
  $digit = $this->datum->pop();
  $exact = #f;
  /* TODO: do this conversion last minute */
  $decimal = stack_to_decimal(array(new Stack(array($digit)), $integral),
                              array($fraction, $octothorpes));
  /* don't have exactitude yet */
  /* $this->datum->push(new Real($exact, mul_real_integer_hack(new Real(true, $decimal), */
  /*                                                           pow_integer_hack(new Integer(true, 10), */
  /*                                                                            $suffix)))); */
  $this->datum->push($decimal * pow(10, $suffix));
}

decimal ::= DOT uinteger suffix. {
  print 'decimal ::= DOT uinteger suffix.' . "\n";
}

decimal ::= digits digit octothorpes OCTOTHORPE DOT octothorpes suffix. {
  print 'decimal ::= digit digits octothorpes OCTOTHORPE DOT octothorpes suffix.' . "\n";
}

uinteger ::= digits digit octothorpes. {
  print 'uinteger ::= digit digits octothorpes.' . "\n";
}

prefix ::= radix exactness. {
}

/* prefix ::= exactness radix. { */
/* } */

digits ::= . {
  print 'digits ::= .' . "\n";
  $this->nonterminal('digits');
}

digits ::= digits digit. {
  print 'digits ::= digits digit.' . "\n";
  $this->promote();
}

octothorpes ::= . {
  print 'octothorpes ::= .' . "\n";
  $this->nonterminal('octothorpes');
}

octothorpes ::= octothorpes OCTOTHORPE(A). {
  print 'octothorpes ::= octothorpes OCTOTHORPE(A).' . "\n";
  $this->leaf(A);
}  

suffix ::= . {
  print 'suffix ::= .' . "\n";
  $this->datum->push(0);
}

suffix ::= exponent sign digits digit. {
  print 'suffix ::= exponent sign digit digits.' . "\n";
  $exponent = $this->datum->pop();
  $digit = $this->datum->pop();
  $sign = $this->datum->pop();
  $precision = $this->datum->pop();
  $this->datum->push(stack_to_exponent($precision,
                                       $sign,
                                       array(new Stack(array($digit)),
                                             $exponent)));
}

digit ::= ZERO(A). {
  print 'digit ::= ZERO(A).' . "\n";
  $this->leaf(A);
}

digit ::= ONE(A). {
  print 'digit ::= ONE(A).' . "\n";
  $this->leaf(A);
}

digit ::= TWO(A). {
  print 'digit ::= TWO(A).' . "\n";
  $this->leaf(A);
}

digit ::= THREE(A). {
  print 'digit ::= THREE(A).' . "\n";
  $this->leaf(A);
}

digit ::= FOUR(A). {
  print 'digit ::= FOUR(A).' . "\n";
  $this->leaf(A);
}

digit ::= FIVE(A). {
  print 'digit ::= FIVE(A).' . "\n";
  $this->leaf(A);
}

digit ::= SIX(A). {
  print 'digit ::= SIX(A).' . "\n";
  $this->leaf(A);
}

digit ::= SEVEN(A). {
  print 'digit ::= SEVEN(A).' . "\n";
  $this->leaf(A);
}

digit ::= EIGHT(A). {
  print 'digit ::= EIGHT(A).' . "\n";
  $this->leaf(A);
}

digit ::= NINE(A). {
  print 'digit ::= NINE(A).' . "\n";
  $this->leaf(A);
}

exponent ::= E(A). {
  print 'exponent ::= E(A).' . "\n";
  $this->leaf(A);
}

exponent ::= S(A). {
  print 'exponent ::= S(A).' . "\n";
  $this->leaf(A);
}

exponent ::= F(A). {
  print 'exponent ::= F(A).' . "\n";
  $this->leaf(A);
}

exponent ::= D(A). {
  print 'exponent ::= D(A).' . "\n";
  $this->leaf(A);
}

exponent ::= L(A). {
  print 'exponent ::= L(A).' . "\n";
  $this->leaf(A);
}

sign ::= PLUS(A). {
  print 'sign ::= PLUS(A).' . "\n";
  $this->leaf(A);
}

sign ::= MINUS(A). {
  print 'sign ::= MINUS(A).' . "\n";
  $this->leaf(A);
}

sign ::= . {
  print 'sign ::= .' . "\n";
  $this->nonterminal('sign');
}

exactness ::= . {
}

exactness ::= INEXACT. {
}

radix ::= . {
}

radix ::= DECIMAL. {
}
