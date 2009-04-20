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

%%

"0" { return $this->createToken(SphuckParser::SPHUCK_ZERO); }
"1" { return $this->createToken(SphuckParser::SPHUCK_ONE); }
"2" { return $this->createToken(SphuckParser::SPHUCK_TWO); }
"3" { return $this->createToken(SphuckParser::SPHUCK_THREE); }
"4" { return $this->createToken(SphuckParser::SPHUCK_FOUR); }
"5" { return $this->createToken(SphuckParser::SPHUCK_FIVE); }
"6" { return $this->createToken(SphuckParser::SPHUCK_SIX); }
"7" { return $this->createToken(SphuckParser::SPHUCK_SEVEN); }
"8" { return $this->createToken(SphuckParser::SPHUCK_EIGHT); }
"9" { return $this->createToken(SphuckParser::SPHUCK_NINE); }
"a" { return $this->createToken(SphuckParser::SPHUCK_A); }
"b" { return $this->createToken(SphuckParser::SPHUCK_B); }
"c" { return $this->createToken(SphuckParser::SPHUCK_C); }
"d" { return $this->createToken(SphuckParser::SPHUCK_D); }
"e" { return $this->createToken(SphuckParser::SPHUCK_E); }
"f" { return $this->createToken(SphuckParser::SPHUCK_F); }
"#" { return $this->createToken(SphuckParser::SPHUCK_OCTOTHORPE); }
"+" { return $this->createToken(SphuckParser::SPHUCK_POSITIVE); }
"-" { return $this->createToken(SphuckParser::SPHUCK_NEGATIVE); }
"#i" { return $this->createToken(SphuckParser::SPHUCK_INEXACT); }
"#e" { return $this->createToken(SphuckParser::SPHUCK_EXACT); }
"#b" { return $this->createToken(SphuckParser::SPHUCK_RADIX_BINARY); }
"#o" { return $this->createToken(SphuckParser::SPHUCK_RADIX_OCTAL); }
"#d" { return $this->createToken(SphuckParser::SPHUCK_RADIX_DECIMAL); }
"#x" { return $this->createToken(SphuckParser::SPHUCK_RADIX_HEXADECIMAL); }
[\n] {}
