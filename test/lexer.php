<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../sexp.php');

class LexerTestCase extends UnitTestCase {
  function testNumbers() {
    $this->assertEqual(tokenize('+ 5 4.3 2. .45 -6'),
                       array(NULL,
                             array(Lexer::SYMBOL => '+'),
                             array(Lexer::NUMBER => '5'),
                             array(Lexer::NUMBER => '4.3'),
                             array(Lexer::NUMBER => '2.'),
                             array(Lexer::NUMBER => '.45'),
                             array(Lexer::NUMBER => '-6')));
  }

  function testStringsAndSymbols() {
    $this->assertEqual(tokenize('(string-append "Hello " "\"" \'Dave "\"")'),
                       array(NULL,
                             array(Lexer::OPEN => '('),
                             array(Lexer::SYMBOL => 'string-append'),
                             array(Lexer::STRING => 'Hello '),
                             array(Lexer::STRING => '\"'),
                             array(Lexer::QUOTE => '\''),
                             array(Lexer::SYMBOL => 'Dave'),
                             array(Lexer::STRING => '\"'),
                             array(Lexer::CLOSE => ')')));
  }
}

// var_dump(tokenize('a . b'));
// var_dump(tokenize('""'));
// var_dump(tokenize('("")'));
// var_dump(tokenize('("") ("")'));
// var_dump(tokenize('("") (" ")'));
// var_dump(tokenize('("a") ("b")'));
// var_dump(tokenize('"\""'));
// var_dump(tokenize('"\n"'));
// var_dump(tokenize('"aa\n"'));
// var_dump(tokenize('"\nbb"'));
// var_dump(tokenize('"aa\nbb"'));

$test = new LexerTestCase();
exit ($test->run(new TextReporter()) ? 0 : 1);
