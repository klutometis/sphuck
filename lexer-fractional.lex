<?php

%%

%unicode
%ignorecase
%line
%char
%class SphuckFractionalLexer
%function next_token

DIGITS = [0-9]+
OCTOTHORPES = #+
RADIX = (#d(#e|#i)?|(#e|#i)?#d)
PLUS = \+
MINUS = -
DIVIDED_BY = /
DOT = \.
EXPONENT = (e|s|f|d|l)
%%

{DIGITS} { return $this->createToken(SphuckFractionalParser::SPHUCK_DIGITS); }
{OCTOTHORPES} { return $this->createToken(SphuckFractionalParser::SPHUCK_OCTOTHORPES); }
{RADIX} { return $this->createToken(SphuckFractionalParser::SPHUCK_RADIX); }
{PLUS} { return $this->createToken(SphuckFractionalParser::SPHUCK_PLUS); }
{MINUS} { return $this->createToken(SphuckFractionalParser::SPHUCK_MINUS); }
{DIVIDED_BY} { return $this->createToken(SphuckFractionalParser::SPHUCK_DIVIDED_BY); }
{DOT} { return $this->createToken(SphuckFractionalParser::SPHUCK_DOT); }
{EXPONENT} { return $this->createToken(SphuckFractionalParser::SPHUCK_EXPONENT); }
