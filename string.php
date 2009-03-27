<?php

class String {
  public $string;

  function __construct($string='') {
    $this->string = $string;
  }
  
  function __toString() {
    return sprintf('"%s"', $this->string);
  }
  }
