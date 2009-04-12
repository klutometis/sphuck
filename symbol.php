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

$symbol_table = array();

function symbol($name) {
  global $symbol_table;
  if (array_key_exists($name, $symbol_table))
    return $symbol_table[$name];
  else {
    $symbol = new Symbol($name);
    $symbol_table[$name] = $symbol;
    return $symbol;
  }
}

function is_symbol($object) {
  return $object instanceof Symbol;
}
