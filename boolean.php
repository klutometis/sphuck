<?php

class Boolean {
  public $value;

  function __construct($value) {
    $this->value = $value;
  }

  function __toString() {
    if ($this->value)
      return '#t';
    else
      return '#f';
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
