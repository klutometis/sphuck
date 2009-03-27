<?php

class Symbol {
  public $symbol;

  function __construct($symbol) {
    $this->symbol = $symbol;
  }

  function __toString() {
    return $this->symbol;
  }
  }
