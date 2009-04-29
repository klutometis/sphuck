<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../number.php');
require_once(dirname(__FILE__) . '/../stack.php');
require_once(dirname(__FILE__) . '/../parser.php');
require_once(dirname(__FILE__) . '/../lexer.lex.php');
require_once(dirname(__FILE__) . '/../string-reader.php');

class ParserTestCase extends UnitTestCase {
  function testDecimal() {
    $lexer = new SphuckLexer(fopen('str://1234.5e+10', 'r'));
    $parser = new SphuckParser();
    // modify to read one datum
    while($token = $lexer->next_token()) {
      $parser->Sphuck($token->type, $token->value);
    }
    $parser->Sphuck(0);
    $this->assertEqual($parser->datum->pop()->real->real,
                       12345000000000);
  }
}
