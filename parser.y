%name Sphuck
%token_prefix SPHUCK_

decimal ::= uinteger suffix.

uinteger ::= digit digits octothorpes.

digits ::= .

digits ::= digits digit.

octothorpes ::= .

octothorpes ::= octothorpes OCTOTHORPE.

suffix ::= .

suffix ::= exponent sign suffix_digits.

suffix_digits ::= digit.

suffix_digits ::= suffix_digits digit.

digit ::= ZERO.

exponent ::= E.

exponent ::= S.

exponent ::= F.

exponent ::= D.

exponent ::= L.

sign ::= PLUS.

sign ::= MINUS.

sign ::= .
