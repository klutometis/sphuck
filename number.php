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
