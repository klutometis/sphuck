<?php

// worry about exact/inexact later? need parsing support.
class Number {
  public $real;
  public $imaginary;

  function __construct($real, $imaginary=0) {
    $this->real = $real;
    $this->imaginary = $imaginary;
  }

  function __toString() {
    return sprintf('%s%s%si',
                   $this->real,
                   $this->imaginary < 0 ? '' : '+',
                   $this->imaginary);
  }
  }

// reserved for memoization?
function number($real, $imaginary=0) {
  return new Number($real, $imaginary);
}

function is_number($object) {
  return $object instanceof Number;
}

function add($numbers) {
  return fold_right(function($a, $b) {
      return number($a->real + $b->real,
                    $a->imaginary + $b->imaginary);
    },
    number(0),
    $numbers);
}
