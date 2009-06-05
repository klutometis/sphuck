<?php

class Port {
  public $handle;
  
  function __construct($handle) {
    $this->handle = $handle;
  }
  }

class EOF {
}

function is_eof_object($object) {
  return $object instanceof EOF;
}

$eof = new EOF();
