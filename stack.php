<?php

class Stack {
  public $data = array();

  function push($datum) {
    $this->data[] = $datum;
  }

  function pop() {
    if ($this->is_empty())
      error('fuck you');
    return array_pop($this->data);
  }

  function peek() {
    return $this->data[count($this->data) - 1];
  }

  function is_empty() {
    return count($this->data) == 0;
  }

  function __toString() {
    // return implode("\n", array_map('strval', $this->data));
    return sprintf("(%s)", array_reduce($this->data,
                                        function ($x, $y) {
                                          return $x . $y;
                                        },
                                        ""));
  }
  }
