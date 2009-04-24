<?php

class Stack {
  public $data;

  function __construct($data=array(), $label='') {
    $this->data = $data;
    $this->label = $label;
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
    return sprintf("(%s%s)",
                   ($this->label ? "{$this->label}:" : ''),
                   array_reduce($this->data,
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

function stack_to_string() {
  $stacks = func_get_args();
  $merged_stack = call_user_func_array('stack_merge', $stacks);
  return array_reduce($merged_stack->data,
                      function ($x, $y) {
                        return $x . $y;
                      },
                      "");
}

function stack_to_integer() {
  return intval(strtr(call_user_func_array('stack_to_string',
                                           func_get_args()),
                      '#',
                      '0'));
}


function stack_to_decimal($integral, $fraction) {
  return floatval(sprintf('%d.%d',
                          call_user_func_array('stack_to_integer',
                                               $integral),
                          call_user_func_array('stack_to_integer',
                                               $fraction)));
}
