<?php

class Boolean {
  public $value;

  function __construct($value) {
    $this->value = $value;
  }
  }

$true = new Boolean(true);
$false = new Boolean(false);

function boolean($value) {
  if ($value)
    return $true;
  else
    return $false;
}
