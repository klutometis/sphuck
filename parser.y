%name Sphuck
%token_prefix SPHUCK_

decimal ::= uinteger suffix. { print "decimal\n"; }

decimal ::= DOT digit digits octothorpes suffix.

decimal ::= digit digits DOT digits octothorpes suffix.

decimal ::= digit digits OCTOTHORPE octothorpes DOT octothorpes suffix.

uinteger ::= digit digits octothorpes. { print "uinteger\n"; }

digits ::= .

digits ::= digits digit.

octothorpes ::= .

octothorpes ::= octothorpes OCTOTHORPE(A).  { var_dump(A); }

suffix ::= .

suffix ::= exponent sign digit digits.

digit ::= ZERO(A). { var_dump(A); }

exponent ::= E.

exponent ::= S.

exponent ::= F.

exponent ::= D.

exponent ::= L.

sign ::= PLUS.

sign ::= MINUS.

sign ::= .
