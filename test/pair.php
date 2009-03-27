<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../pair.php');

class PairTestCase extends UnitTestCase {
  public $pair;

  function __construct() {
    $this->pair = new Pair(1, new Pair(2, new Pair(3)));
  }

  function testMap() {
    $this->assertEqual(map(function($x) { return $x * 2; }, $this->pair),
                       new Pair(2, new Pair(4, new Pair(6))));
  }

  function testFoldRight() {
    $this->assertEqual
      (fold_right(function($x, $y) { return $x + $y; }, 0, $this->pair),
       6);
  }
}
