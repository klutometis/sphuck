<?php

require_once('simpletest/unit_tester.php');
require_once(dirname(__FILE__) . '/../pair.php');

class PairTestCase extends UnitTestCase {
  public $pair;

  function __construct() {
    $this->list = lst(1, 2, 3);
  }

  function testPairListEquivalence() {
    $this->assertEqual($this->list,
                       new Pair(1, new Pair(2, new Pair(3, NULL))));
  }

  function testMap() {
    $this->assertEqual(map(function($x) { return $x * 2; }, $this->list),
                       lst(2, 4, 6));
  }

  function testFoldRight() {
    $this->assertEqual
      (fold_right(function($x, $y) { return $x + $y; }, 0, $this->list),
       6);
  }
}
