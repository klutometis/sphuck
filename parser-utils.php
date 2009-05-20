<?php

function is_inexact($radix) {
  return stripos($radix, '#i') !== false;
}

// includes cases, for instance, where no exactness is specified
function is_exact($radix) {
  return !is_inexact($radix);
}

function normalize_digits($digits) {
  return strtr($digits, '#', '0');
}

function digits_to_number($digits, $radix) {
  return intval(normalize_digits($digits), $radix);
}
