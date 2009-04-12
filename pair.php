<?php

class Pair {
  public $car;
  public $cdr;
  function __construct($car, $cdr=NULL) {
    $this->car = $car;
    $this->cdr = $cdr;
  }
  function __toString() {
    return sprintf('(%s . %s)',
                   $this->car,
                   nullp($this->cdr) ? 'nil' : $this->cdr);
  }
  }

function map($f, $pair) {
  if (nullp($pair))
    return $pair;
  else
    return cons($f(car($pair)),
                map($f, cdr($pair)));
}

// reserved for memoization
function pair($car, $cdr=NULL) {
  return new Pair($car, $cdr);
}

function fold_right($cons, $nil, $pair) {
  if (nullp($pair))
    return $nil;
  else
    return $cons(car($pair), fold_right($cons, $nil, cdr($pair)));
}

function nullp($pair) {
  return is_null($pair);
}

function car($pair) {
  if (nullp($pair))
    throw new Exception('CARed a null list');
  else
    return $pair->car;
}

// will return NULL in the case of Pair(x, NULL)
function cdr($pair) {
  if (nullp($pair))
    throw new Exception('CDRed a null list');
  else
    return $pair->cdr;
}

function cons($elt, $pair) {
  return new Pair($elt, $pair);
}

// sizeof($array) == 0?
function is_array_null($array) {
  // return is_array($array) && sizeof($array) == 0;
  return is_array($array) && empty($array);
}

function array_car($array) {
  return $array[0];
}

function array_cdr($array) {
  return array_slice($array, 1);
}

function lst() {
  $elts = func_get_args();
  if (is_array_null($elts))
    return NULL;
  else {
    return new Pair(array_car($elts),
                    call_user_func_array('lst', (array_cdr($elts))));
  }
}

function length($list, $length=0) {
  if (is_null($list))
    return $length;
  else
    return length(cdr($list), $length + 1);
}

function set_car($pair, $value) {
  $pair->car = $value;
}

function set_cdr($pair, $value) {
  $pair->cdr = $value;
}

// have to implement full subtlety of eq?; as in, (eq? '(a) '(a)) =>
// #f, etc.
function is_eq($a, $b) {
  return $a == $b // || $a->is_eq($b)
  ;
}

// have to discover function composition
function cadr($pair) {
  car(cdr($pair));
}

function is_pair($object) {
  return $object instanceof Pair;
}
