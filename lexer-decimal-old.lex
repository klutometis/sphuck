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
%class SphuckDecimalLexer
%function next_token

%%

"0" { return $this->createToken(SphuckDecimalParser::SPHUCK_ZERO); }
"1" { return $this->createToken(SphuckDecimalParser::SPHUCK_ONE); }
"2" { return $this->createToken(SphuckDecimalParser::SPHUCK_TWO); }
"3" { return $this->createToken(SphuckDecimalParser::SPHUCK_THREE); }
"4" { return $this->createToken(SphuckDecimalParser::SPHUCK_FOUR); }
"5" { return $this->createToken(SphuckDecimalParser::SPHUCK_FIVE); }
"6" { return $this->createToken(SphuckDecimalParser::SPHUCK_SIX); }
"7" { return $this->createToken(SphuckDecimalParser::SPHUCK_SEVEN); }
"8" { return $this->createToken(SphuckDecimalParser::SPHUCK_EIGHT); }
"9" { return $this->createToken(SphuckDecimalParser::SPHUCK_NINE); }
"d" { return $this->createToken(SphuckDecimalParser::SPHUCK_D); }
"e" { return $this->createToken(SphuckDecimalParser::SPHUCK_E); }
"f" { return $this->createToken(SphuckDecimalParser::SPHUCK_F); }
"l" { return $this->createToken(SphuckDecimalParser::SPHUCK_L); }
"s" { return $this->createToken(SphuckDecimalParser::SPHUCK_S); }
"#" { return $this->createToken(SphuckDecimalParser::SPHUCK_OCTOTHORPE); }
"+" { return $this->createToken(SphuckDecimalParser::SPHUCK_PLUS); }
"-" { return $this->createToken(SphuckDecimalParser::SPHUCK_MINUS); }
"." { return $this->createToken(SphuckDecimalParser::SPHUCK_DOT); }
[\n] {}
