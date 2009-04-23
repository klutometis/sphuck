%name Sphuck
%token_prefix SPHUCK_
%include {
  public $root;
  public $current;

  function __construct() {
    $this->values = new Stack();
    $this->expression = $this->values;
  }

  // maybe sentinels would be quicker; basically, we're simulating a
  // parse tree; have a bona fide tree structure?
  function push($value) {
    if ($this->values->is_empty()) {
      $this->values->push($value);
      return;
    } else
      $top = $this->values->peek();
    if ($top instanceof Stack)
      $top->push($value);
    else
      $this->values->push($value);
  }

}

decimal ::= uinteger suffix. {
  print '**************';
}

decimal ::= digit digits DOT digits octothorpes suffix. {
  // abstract into a reset_expression() or so
  $this->expression = $this->values;
  $this->values->push(A);
}

decimal ::= DOT uinteger suffix. {
}

decimal ::= digit digits octothorpes OCTOTHORPE DOT octothorpes suffix. {
}

uinteger ::= digit digits octothorpes. {
}

digits ::= . {
  print 'digits{0}';
  // abstract into a promote_expression() or so; simulating a link to
  // the parent; but may actually need the parent and not just the
  // root.
  $this->expression = new Stack();
  $this->values->push($this->expression);
}

digits ::= digits digit. {
  // print 'digits+';
}

octothorpes ::= . {
  print 'octothorpes{0}';
  $this->expression = new Stack();
  $this->values->push($this->expression);
}

octothorpes ::= octothorpes OCTOTHORPE(A). {
  print 'OCTOTHORPE';
  $this->expression->push(A);
}  

suffix ::= .

suffix ::= exponent sign digit digits.

digit ::= ZERO(A). {
  print 'ZERO';
  $this->expression->push(A);
}

digit ::= ONE.

digit ::= TWO.

digit ::= THREE.

digit ::= FOUR.

digit ::= FIVE.

digit ::= SIX.

digit ::= SEVEN.

digit ::= EIGHT.

digit ::= NINE.

exponent ::= E.

exponent ::= S.

exponent ::= F.

exponent ::= D.

exponent ::= L.

sign ::= PLUS.

sign ::= MINUS.

sign ::= .
