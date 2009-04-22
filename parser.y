%name Sphuck
%token_prefix SPHUCK_

decimal ::= uinteger suffix.

decimal ::= digit digits DOT digits octothorpes suffix.

decimal ::= DOT uinteger suffix.

decimal ::= digit digits octothorpes OCTOTHORPE DOT octothorpes suffix.

uinteger ::= digit digits octothorpes.

digits ::= .

digits ::= digits digit.

octothorpes ::= .

octothorpes ::= octothorpes OCTOTHORPE.

suffix ::= .

suffix ::= exponent sign digit digits.

digit ::= ZERO.

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
