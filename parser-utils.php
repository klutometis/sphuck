<?php

function has_octothorpes($number) {
  return stripos($number, '#') !== false;
}

function is_inexact($radix) {
  return stripos($radix, '#i') !== false;
}

// includes cases, for instance, where no exactness is specified
function is_exact($radix) {
  return !is_inexact($radix);
}

function normalize_digits($digits) {
  return strtr($digits, '#', '0');
}

function digits_to_number($digits, $radix=10) {
  return intval(normalize_digits($digits), $radix);
}

function digits_to_exponent($digits, $base) {
  return floatval(sprintf('%de%s',
                          $base,
                          normalize_digits($digits)));
}

function parse($partiendum, $parser, $parse, $lexer_class) {
  $key = StringReader::put($partiendum);
  $lexer = new $lexer_class(fopen("str://$key", 'r'));
  while ($token = $lexer->next_token()) {
    $parser->$parse($token->type, $token->value);
  }
  $parser->$parse(0);
  // multiple values?
  return $parser->datum->pop();
}

function parse_fractional($fractional) {
  return parse($fractional,
               new SphuckFractionalParser(),
               'SphuckFractional',
               'SphuckFractionalLexer');
}