<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../parser.php');
require_once(dirname(__FILE__) . '/../lexer.php');

class LexerTestCase extends UnitTestCase {
  function testNumbers() {
    $this->assertEqual(token_array(new Lexer('+ 5 4.3 2. .45 -6')),
                       array(array(Parser::SYMBOL => '+'),
                             array(Parser::NUMBER => '5'),
                             array(Parser::NUMBER => '4.3'),
                             array(Parser::NUMBER => '2.'),
                             array(Parser::NUMBER => '.45'),
                             array(Parser::NUMBER => '-6')));
  }

  function testStringsAndSymbols() {
    $this->assertEqual(token_array(new Lexer('(string-append "Hello " "\"" \'Dave "\"")')),
                       array(array(Parser::OPEN => '('),
                             array(Parser::SYMBOL => 'string-append'),
                             array(Parser::STRING => 'Hello '),
                             array(Parser::STRING => '\"'),
                             array(Parser::QUOTE => '\''),
                             array(Parser::SYMBOL => 'Dave'),
                             array(Parser::STRING => '\"'),
                             array(Parser::CLOSE => ')')));
  }

  function testSymbolsAndDot() {
    $this->assertEqual(token_array(new Lexer('a . b')),
                       array(array(Parser::SYMBOL => 'a'),
                             array(Parser::DOT => '.'),
                             array(Parser::SYMBOL => 'b')));
  }

  function testBlankString() {
    $this->assertEqual(token_array(new Lexer('""')),
                       array(array(Parser::STRING => '')));
  }

  function testBlankStringInSexp() {
    $this->assertEqual(token_array(new Lexer('("")')),
                       array(array(Parser::OPEN => '('),
                             array(Parser::STRING => ''),
                             array(Parser::CLOSE => ')')));
  }

  function testTwoBlankStringsInSexp() {
    $this->assertEqual(token_array(new Lexer('("") ("")')),
                       array(array(Parser::OPEN => '('),
                             array(Parser::STRING => ''),
                             array(Parser::CLOSE => ')'),
                             array(Parser::OPEN => '('),
                             array(Parser::STRING => ''),
                             array(Parser::CLOSE => ')')));
  }

  function testBlankStringAndSpaceInSexp() {
    $this->assertEqual(token_array(new Lexer('("") (" ")')),
                       array(array(Parser::OPEN => '('),
                             array(Parser::STRING => ''),
                             array(Parser::CLOSE => ')'),
                             array(Parser::OPEN => '('),
                             array(Parser::STRING => ' '),
                             array(Parser::CLOSE => ')')));
  }

  function testTwoStringsInSexp() {
    $this->assertEqual(token_array(new Lexer('("a") ("b")')),
                       array(array(Parser::OPEN => '('),
                             array(Parser::STRING => 'a'),
                             array(Parser::CLOSE => ')'),
                             array(Parser::OPEN => '('),
                             array(Parser::STRING => 'b'),
                             array(Parser::CLOSE => ')')));
  }

  function testNewline() {
    $this->assertEqual(token_array(new Lexer('"\n"')),
                       array(array(Parser::STRING => '\n')));
  }

  function testPostNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\n"')),
                       array(array(Parser::STRING => 'aa\n')));
  }

  function testPreNewline() {
    $this->assertEqual(token_array(new Lexer('"\nbb"')),
                       array(array(Parser::STRING => '\nbb')));
  }

  function testMedialNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\nbb"')),
                       array(array(Parser::STRING => 'aa\nbb')));
  }

  function testMedialAndPostNewline() {
    $this->assertEqual(token_array(new Lexer('"aa\nbb\ncc\ndd\n"')),
                       array(array(Parser::STRING => 'aa\nbb\ncc\ndd\n')));
  }
}
