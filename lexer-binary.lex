<?php
require('jlex.php');

%%

%unicode
%ignorecase
%line
%char
%class SphuckBinaryLexer
%function next_token

IMAGINARY = i
ASPERAND = @
DIGITS_2 = [01]+#*
RADIX_2 = (#b(#e|#i)?|(#e|#i)?#b)
PLUS = \+
MINUS = -
DIVIDED_BY = /
%%

{IMAGINARY} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_IMAGINARY); }
{ASPERAND} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{DIGITS_2} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_DIGITS_2); }
{RADIX_2} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_RADIX_2); }
{PLUS} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_PLUS); }
{MINUS} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_MINUS); }
{DIVIDED_BY} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_DIVIDED_BY); }
