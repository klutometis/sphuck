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
"g" { return $this->createToken(SphuckParser::SPHUCK_G); }
"h" { return $this->createToken(SphuckParser::SPHUCK_H); }
"i" { return $this->createToken(SphuckParser::SPHUCK_I); }
"j" { return $this->createToken(SphuckParser::SPHUCK_J); }
"k" { return $this->createToken(SphuckParser::SPHUCK_K); }
"l" { return $this->createToken(SphuckParser::SPHUCK_L); }
"m" { return $this->createToken(SphuckParser::SPHUCK_M); }
"n" { return $this->createToken(SphuckParser::SPHUCK_N); }
"o" { return $this->createToken(SphuckParser::SPHUCK_O); }
"p" { return $this->createToken(SphuckParser::SPHUCK_P); }
"q" { return $this->createToken(SphuckParser::SPHUCK_Q); }
"r" { return $this->createToken(SphuckParser::SPHUCK_R); }
"s" { return $this->createToken(SphuckParser::SPHUCK_S); }
"t" { return $this->createToken(SphuckParser::SPHUCK_T); }
"u" { return $this->createToken(SphuckParser::SPHUCK_U); }
"v" { return $this->createToken(SphuckParser::SPHUCK_V); }
"w" { return $this->createToken(SphuckParser::SPHUCK_W); }
"x" { return $this->createToken(SphuckParser::SPHUCK_X); }
"y" { return $this->createToken(SphuckParser::SPHUCK_Y); }
"z" { return $this->createToken(SphuckParser::SPHUCK_Z); }
"#" { return $this->createToken(SphuckParser::SPHUCK_OCTOTHORPE); }
"+" { return $this->createToken(SphuckParser::SPHUCK_PLUS); }
"-" { return $this->createToken(SphuckParser::SPHUCK_MINUS); }
"." { return $this->createToken(SphuckParser::SPHUCK_DOT); }
"@" { return $this->createToken(SphuckParser::SPHUCK_ASPERAND); }
"/" { return $this->createToken(SphuckParser::SPHUCK_SLASH); }
"#i" { return $this->createToken(SphuckParser::SPHUCK_INEXACT); }
"#d" { return $this->createToken(SphuckParser::SPHUCK_DECIMAL); }
[\n] {}
