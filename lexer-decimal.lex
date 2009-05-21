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
SUFFIX = ([esfdl](\+|-)?[0-9]+)?
ONLY_DIGITS = [0-9]+
MAYBE_DIGITS = [0-9]*
OCTOTHORPES = #+
MAYBE_OCTOTHORPES = #*
DOT = \.
FRACTIONAL = ({DIGITS}{SUFFIX}|{DOT}{DIGITS}{SUFFIX}|{ONLY_DIGITS}{DOT}{MAYBE_DIGITS}{MAYBE_OCTOTHORPES}{SUFFIX}|{ONLY_DIGITS}{OCTOTHORPES}{DOT}{MAYBE_OCTOTHORPES}{SUFFIX})

%%

{IMAGINARY} { return $this->createToken(SphuckNumberParser::SPHUCK_IMAGINARY); }
{ASPERAND} { return $this->createToken(SphuckNumberParser::SPHUCK_ASPERAND); }
{DIGITS} { return $this->createToken(SphuckNumberParser::SPHUCK_DIGITS); }
{RADIX} { return $this->createToken(SphuckNumberParser::SPHUCK_RADIX); }
{PLUS} { return $this->createToken(SphuckNumberParser::SPHUCK_PLUS); }
{MINUS} { return $this->createToken(SphuckNumberParser::SPHUCK_MINUS); }
{DIVIDED_BY} { return $this->createToken(SphuckNumberParser::SPHUCK_DIVIDED_BY); }
{FRACTIONAL} { return $this->createToken(SphuckNumberParser::SPHUCK_FRACTIONAL); }
