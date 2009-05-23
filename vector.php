<?php

class Vector {
  public $data;

  function __construct($data) {
    $this->data = $data;
  }

  function __toString() {
    // not quite; members themselves may be vectors, etc.
    return sprintf('#(%s)', implode(' ', array_map('strval',
                                                   $this->data)));
  }
  }

// $data is an array
function vector($data) {
  return new Vector($data);
}
