<?php

%%

%unicode
%ignorecase
%line
%char
%class SphuckDecimalLexer
%function next_token

IMAGINARY = i
ASPERAND = @
DIGITS = [0-9]+#*
RADIX = (#d(#e|#i)?|(#e|#i)?#d)
PLUS = \+
MINUS = -
DIVIDED_BY = /
%%

{IMAGINARY} { return $this->createToken(SphuckNumberParser::SPHUCK_IMAGINARY); }
{ASPERAND} { return $this->createToken(SphuckNumberParser::SPHUCK_ASPERAND); }
{DIGITS} { return $this->createToken(SphuckNumberParser::SPHUCK_DIGITS); }
{RADIX} { return $this->createToken(SphuckNumberParser::SPHUCK_RADIX); }
{PLUS} { return $this->createToken(SphuckNumberParser::SPHUCK_PLUS); }
{MINUS} { return $this->createToken(SphuckNumberParser::SPHUCK_MINUS); }
{DIVIDED_BY} { return $this->createToken(SphuckNumberParser::SPHUCK_DIVIDED_BY); }
