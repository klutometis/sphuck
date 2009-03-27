<?php

require_once('simpletest/test_case.php');
require_once(dirname(__FILE__) . '/lexer.php');
require_once(dirname(__FILE__) . '/pair.php');

class All extends TestSuite {
  function __construct() {
    parent::__construct();
    $this->add(new LexerTestCase());
    $this->add(new PairTestCase());
  }
}

$suite = new All();
exit ($suite->run(new TextReporter()) ? 0 : 1);
