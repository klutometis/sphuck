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

function cdr($pair) {
  if (nullp($pair))
    throw new Exception('CDRed a null list');
  else
    return $pair->cdr;
}

function cons($elt, $pair) {
  return new Pair($elt, $pair);
}
