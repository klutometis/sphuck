%name parser
%token_prefix SPHUCK_

decimal ::= uinteger suffix.

uinteger ::= digit.

uinteger ::= uinteger digit.

suffix ::= .

suffix ::= exponent sign digit.

digit ::= ZERO.

exponent ::= E.

sign ::= PLUS.

sign ::= MINUS.

sign ::= .

