%name Sphuck
%token_prefix SPHUCK_

decimal ::= uinteger suffix.

uinteger ::= digit.

uinteger ::= uinteger digit.

uinteger ::= uinteger digit OCTOTHORPE.

suffix ::= .

suffix ::= exponent sign digit.

digit ::= ZERO.

exponent ::= E.

sign ::= PLUS.

sign ::= MINUS.

sign ::= .
