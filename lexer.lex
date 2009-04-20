<?php
require('jlex.php');

%%

%{
  function token_array() {
    $tokens = NULL;
    foreach ($lexer as $token => $value)
      $tokens[] = array($token => $value);
    return $tokens;
  }
%}

%unicode
%ignorecase
%line
%char
%class SphuckLexer
%function next_token

digit10 = [0-9]
exponent = (e|s|f|d|l)
sign = [+-]?  
suffix = ({exponent}{sign}{digit10}+)?
uinteger10 = {digit10}+\#*
decimal10 = {uinteger10}{suffix}

%%

{decimal10} { return $this->createToken(SphuckParser::SPHUCK_DECIMAL); }
[\n] {}
