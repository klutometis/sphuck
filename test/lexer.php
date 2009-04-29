<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../parser.php');
require_once(dirname(__FILE__) . '/../lexer.lex.php');
require_once(dirname(__FILE__) . '/../string-reader.php');

// test all symbols?
class LexerTestCase extends UnitTestCase {
  function testDecimal() {
    $lexer = new SphuckLexer(fopen('str://1234.5e+10', 'r'));
    $this->assertEqual($lexer->token_array(),
                       array(array(SphuckParser::SPHUCK_ONE => 1),
                             array(SphuckParser::SPHUCK_TWO => 2),
                             array(SphuckParser::SPHUCK_THREE => 3),
                             array(SphuckParser::SPHUCK_FOUR => 4),
                             array(SphuckParser::SPHUCK_DOT => '.'),
                             array(SphuckParser::SPHUCK_FIVE => 5),
                             array(SphuckParser::SPHUCK_E => 'e'),
                             array(SphuckParser::SPHUCK_PLUS => '+'),
                             array(SphuckParser::SPHUCK_ONE => 1),
                             array(SphuckParser::SPHUCK_ZERO => 0)));
  }
}
