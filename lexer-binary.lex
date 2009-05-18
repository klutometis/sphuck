<?php
require('jlex.php');

%%

%{
  function token_array() {
    $tokens = NULL;
    while ($token = $this->next_token()) {
      $tokens[] = array($token->type =>
                        $token->value);
    }
    return $tokens;
  }
%}

%unicode
%ignorecase
%line
%char
%class SphuckBinaryLexer
%function next_token

IMAGINARY = i
ASPERAND = @
DIGITS_2 = [01]+
RADIX_2 = (#b(#e|#i)?|(#e|#i)?#b)
PLUS = \+
MINUS = -
DIVIDED_BY = /
%%

{IMAGINARY} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{ASPERAND} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{DIGITS_2} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{RADIX_2} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{PLUS} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{MINUS} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
{DIVIDED_BY} { return $this->createToken(SphuckBinaryParser::SPHUCK_BINARY_ASPERAND); }
