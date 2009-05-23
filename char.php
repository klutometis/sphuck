<?php

class Char {
  public $value;

  function __construct($value) {
    $this->value = $value;
  }
  }

function char($char='') {
  return new String($char);
}
