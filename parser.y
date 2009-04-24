%name Sphuck
%token_prefix SPHUCK_
%include {
  public $datum;
  public $current;

  function __construct() {
    $this->datum = new Stack();
    $this->current = $this->datum;
  }

  function leaf($datum) {
    $this->current->push($datum);
  }

  /* nonterminals to have a label? */
  function nonterminal($nonterminal) {
    $nonterminal = new Stack(array(), $nonterminal);
    $this->datum->push($nonterminal);
    $this->current = $nonterminal;
  }
}

decimal ::= uinteger suffix. {
}

decimal ::= digit digits DOT digits octothorpes suffix. {
  print '@@@@@@@@@@@';
  print $this->datum;
  print '########';
  $octothorpes = $this->datum->pop();
  $fraction = $this->datum->pop();
  $integral = $this->datum->pop();
  $digit = $this->datum->pop();
  // DOT -> inexact
  $exact = #f;
  $decimal = stack_to_decimal(array(new Stack(array($digit)), $integral),
                              array($fraction, $octothorpes));
  $this->datum->push(new Real($exact, $decimal));
}

decimal ::= DOT uinteger suffix. {
}

decimal ::= digit digits octothorpes OCTOTHORPE DOT octothorpes suffix. {
}

uinteger ::= digit digits octothorpes. {
}

digits ::= . {
  $this->nonterminal('digits');
}

digits ::= digits digit. {
}

octothorpes ::= . {
  $this->nonterminal('octothorpes');
}

octothorpes ::= octothorpes OCTOTHORPE(A). {
  $this->leaf(A);
}  

suffix ::= . {
  $this->nonterminal('suffix');
}

suffix ::= exponent sign digit digits. {
  $digits = $this->datum->pop();
  $digit = $this->datum->pop();
  $sign = $this->datum->pop();
  $exponent = $this->datum->pop();
  printf('%s, %s, %s, %s', $digits, $digit, $sign, $exponent);
  print '********';
}

digit ::= ZERO(A). {
  $this->leaf(A);
}

digit ::= ONE(A). {
  $this->leaf(A);
}

digit ::= TWO(A). {
  $this->leaf(A);
}

digit ::= THREE(A). {
  $this->leaf(A);
}

digit ::= FOUR(A). {
  $this->leaf(A);
}

digit ::= FIVE(A). {
  $this->leaf(A);
}

digit ::= SIX(A). {
  $this->leaf(A);
}

digit ::= SEVEN(A). {
  $this->leaf(A);
}

digit ::= EIGHT(A). {
  $this->leaf(A);
}

digit ::= NINE(A). {
  $this->leaf(A);
}

exponent ::= E(A). {
  $this->leaf(A);
}

exponent ::= S(A). {
  $this->leaf(A);
}

exponent ::= F(A). {
  $this->leaf(A);
}

exponent ::= D(A). {
  $this->leaf(A);
}

exponent ::= L(A). {
  $this->leaf(A);
}

sign ::= PLUS(A). {
  $this->leaf(A);
}

sign ::= MINUS(A). {
  $this->leaf(A);
}

sign ::= . {
  $this->nonterminal('sign');
}
