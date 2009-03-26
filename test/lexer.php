<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../lexer.php');

class LexerTestCase extends UnitTestCase {
  function testNumbers() {
    $this->assertEqual(token_array(new Lexer('+ 5 4.3 2. .45 -6')),
                       array(array(Lexer::SYMBOL => '+'),
                             array(Lexer::NUMBER => '5'),
                             array(Lexer::NUMBER => '4.3'),
                             array(Lexer::NUMBER => '2.'),
                             array(Lexer::NUMBER => '.45'),
                             array(Lexer::NUMBER => '-6')));
  }

  function testStringsAndSymbols() {
    $this->assertEqual(token_array(new Lexer('(string-append "Hello " "\"" \'Dave "\"")')),
                       array(array(Lexer::OPEN => '('),
                             array(Lexer::SYMBOL => 'string-append'),
                             array(Lexer::STRING => 'Hello '),
                             array(Lexer::STRING => '\"'),
                             array(Lexer::QUOTE => '\''),
                             array(Lexer::SYMBOL => 'Dave'),
                             array(Lexer::STRING => '\"'),
                             array(Lexer::CLOSE => ')')));
  }

  function testSymbolsAndDot() {
    $this->assertEqual(token_array(new Lexer('a . b')),
                       array(array(Lexer::SYMBOL => 'a'),
                             array(Lexer::DOT => '.'),
                             array(Lexer::SYMBOL => 'b')));
  }

  function testBlankString() {
    $this->assertEqual(token_array(new Lexer('""')),
                       array(array(Lexer::STRING => '')));
  }

  function testBlankStringInSexp() {
    $this->assertEqual(token_array(new Lexer('("")')),
                       array(array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')')));
  }

  function testTwoBlankStringsInSexp() {
    $this->assertEqual(token_array(new Lexer('("") ("")')),
                       array(array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')')));
  }

  function testBlankStringAndSpaceInSexp() {
    $this->assertEqual(token_array(new Lexer('("") (" ")')),
                       array(array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ''),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => ' '),
                             array(Lexer::CLOSE => ')')));
  }

  function testTwoStringsInSexp() {
    $this->assertEqual(token_array(new Lexer('("a") ("b")')),
                       array(array(Lexer::OPEN => '('),
                             array(Lexer::STRING => 'a'),
                             array(Lexer::CLOSE => ')'),
                             array(Lexer::OPEN => '('),
                             array(Lexer::STRING => 'b'),
                             array(Lexer::CLOSE => ')')));
  }

  function testNewline() {
    $this->assertEqual(token_array(new Lexer('"\n"')),
                       array(array(Lexer::STRING => '\n')));
  }

  function testPostNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\n"')),
                       array(array(Lexer::STRING => 'aa\n')));
  }

  function testPreNewline() {
    $this->assertEqual(token_array(new Lexer('"\nbb"')),
                       array(array(Lexer::STRING => '\nbb')));
  }

  function testMedialNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\nbb"')),
                       array(array(Lexer::STRING => 'aa\nbb')));
  }

  function testMedialAndPostNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\nbb\ncc\ndd\n"')),
                       array(array(Lexer::STRING => 'aa\nbb\ncc\ndd\n')));
  }
}
