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

  function testSymbolsAndDot() {
    $this->assertEqual(tokenize('a . b'),
                       array(NULL,
                             array(Lexer::SYMBOL => 'a'),
                             array(Lexer::DOT => '.'),
                             array(Lexer::SYMBOL => 'b')));
  }

  function testBlankString() {
    $this->assertEqual(tokenize('""'),
                       array(NULL,
                             array(Lexer::STRING => '')));
  }

  function testBlankStringInSexp() {
    $this->assertEqual(tokenize('("")'),
                       array(NULL,
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')')));
  }

  function testTwoBlankStringsInSexp() {
    $this->assertEqual(tokenize('("") ("")'),
                       array(NULL,
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')')));
  }

  function testBlankStringAndSpaceInSexp() {
    $this->assertEqual(tokenize('("") (" ")'),
                       array(NULL,
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ' '),
                             array(Lexer::CLOSE => ')')));
  }

  function testTwoStringsInSexp() {
    $this->assertEqual(tokenize('("a") ("b")'),
                       array(NULL,
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => 'a'),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => 'b'),
                             array(Lexer::CLOSE => ')')));
  }

  function testNewline() {
    $this->assertEqual(tokenize('"\n"'),
                       array(NULL,
                             array(Lexer::STRING => '\n')));
  }

  function testPostNewline() {
    $this->assertEqual(tokenize('"aa\n"'),
                       array(NULL,
                             array(Lexer::STRING => 'aa\n')));
  }

  function testPreNewline() {
    $this->assertEqual(tokenize('"\nbb"'),
                       array(NULL,
                             array(Lexer::STRING => '\nbb')));
  }

  function testMedialNewline() {
    $this->assertEqual(tokenize('"aa\nbb"'),
                       array(NULL,
                             array(Lexer::STRING => 'aa\nbb')));
  }

  function testMedialAndPostNewline() {
    $this->assertEqual(tokenize('"aa\nbb\ncc\ndd\n"'),
                       array(NULL,
                             array(Lexer::STRING => 'aa\nbb\ncc\ndd\n')));
  }
}
