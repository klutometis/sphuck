%name Sphuck
%token_prefix SPHUCK_

decimal ::= uinteger suffix. {
  print '**************';
}

decimal ::= digit digits DOT(A) digits octothorpes suffix. {
  print 'dot';
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
}

digits ::= digits digit. {
  print 'digits+';
}

octothorpes ::= . {
  print 'octothorpes{0}';
}

octothorpes ::= octothorpes OCTOTHORPE(A). {
  print 'octothorpes+';
  $this->values->push(A);
}  

suffix ::= .

suffix ::= exponent sign digit digits.

digit ::= ZERO(A). {
  $this->values->push(A);
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
