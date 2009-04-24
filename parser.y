%name Sphuck
%token_prefix SPHUCK_
%include {
  public $root;
  public $current;

  function __construct() {
    $this->root = new Node('root');
    $this->current = $this->root;
  }

  function leaf($value) {
    $this->current->add(new Node($value));
  }

  function nonterminal($nonterminal) {
    $nonterminal = new Node($nonterminal);
    $this->current->add($nonterminal);
    $this->current = $nonterminal;
  }
}

decimal ::= uinteger suffix. {
  print '**************';
}

decimal ::= digit digits DOT digits octothorpes suffix. {
  $this->nonterminal('decimal');
  // abstract into a reset_expression() or so
  /* $this->expression = $this->values; */
  /* $this->values->push(A); */
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
  $this->nonterminal('digits');
}

digits ::= digits digit. {
  print 'digits+';
}

octothorpes ::= . {
  print 'octothorpes{0}';
  /* $this->expression = new Stack(); */
  /* $this->values->push($this->expression); */
  $this->nonterminal('octothorpes');
}

octothorpes ::= octothorpes OCTOTHORPE(A). {
  print 'OCTOTHORPE';
  /* $this->expression->push(A); */
  $this->leaf(A);
}  

suffix ::= .

suffix ::= exponent sign digit digits.

digit ::= ZERO(A). {
  print 'ZERO';
  $this->leaf(A);
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
