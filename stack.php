<?php

class Stack {
  public $data;

  function __construct($data=array()) {
    $this->data = $data;
  }

  function push($datum) {
    $this->data[] = $datum;
  }

  function pop() {
    if ($this->is_empty())
      error('Popping an empty stack');
    return array_pop($this->data);
  }

  function peek() {
    return $this->data[count($this->data) - 1];
  }

  function is_empty() {
    return !$this->data;
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

function stack_merge() {
  return new Stack(call_user_func_array('array_merge',
                                        array_map(function ($stack) {
                                            return $stack->data;
                                          },
                                          func_get_args())));
}

function stack_to_string($stack) {
  return array_reduce(array_reverse($stack->data),
                      function ($x, $y) {
                        return $x . $y;
                      },
                      "");
}
