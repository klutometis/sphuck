<?php

// php doesn't do typed parameters, so we'll have to juggle them,
// anyway.
class Number {
  public $exact;
}

class Complex extends Number {
  public $real;
  public $imaginary;

  function __construct($exact, $real, $imaginary) {
  }
}

class Real extends Complex {
  function __construct($exact, $real) {
    $this->exact = $exact;
    $this->real = $real;
  }
  
  function __toString() {
    return strval($this->real);
  }
}

class Rational extends Real {
  public $numerator;
  public $denominator;

  function __construct($exact, $numerator, $denominator) {
  }
}

class Integer extends Rational {
  function __construct($exact, $numerator) {
  }
}

// shouldn't we do these with computation? i.e. (integer 1+0i) => #t
function is_schinteger($object) {
  return $object instanceof Integer;
}

function is_rational($object) {
  return $object instanceof Rational;
}

function is_schreal($object) {
  return $object instanceof Real;
}

function is_complex($object) {
  return $object instanceof Complex;
}

function is_number($object) {
  return $object instanceof Number;
}
