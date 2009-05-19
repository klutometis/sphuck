<?php

// php doesn't do typed parameters, so we'll have to juggle them,
// anyway.
class Number {
  public $exact;
  public $numerator;
  public $denominator;
  public $imaginary;
  public $production;           // for non-rational reals and above

  function __construct($exact = NULL,
                       $numerator = NULL,
                       $denominator = NULL,
                       $imaginary = NULL,
                       $production = NULL) {
    $this->exact = $exact;
    $this->numerator = $numerator;
    $this->denominator = $denominator;
    $this->imaginary = $imaginary;
    $this->production = $production;
  }

  function __toString() {
    return sprintf("%s%s%s%si",
                   $this->exact ? '#e' : '#i',
                   real_to_string($this),
                   signum($this),
                   real_to_string(imag_part($this)));
  }
}

function zero() {
  return integer(0, 1);
}

// simulates an infinite zero production when the imaginary is really
// NaN for the sake of arithmetic; is there a case when imaginary NaN
// is actually desirable? this is where shit breaks down.
function imag_part($number) {
  if (is_number($number->imaginary))
    return $number->imaginary;
  else
    return zero();
}

function real_part($number) {
  return rational($number->numerator,
                  $number->denominator,
                  $number->exact);
}

function integer($integer, $exact=true) {
  return new Number($exact,
                    $integer,
                    1);
}

function rational($numerator, $denominator, $exact=true) {
  return new Number($exact,
                    $numerator,
                    $denominator);
}

function complex($real, $imaginary, $exact=true) {
  return new Number($exact,
                    $real->numerator,
                    $real->denominator,
                    $imaginary);
}

function gcd($a, $b) {
  if ($b = 0)
    return $a;
  else
    return gcd($b, $a % $b);
}

function reduce($rational) {
  $gcd = gcd($rational->numerator, $rational->denominator);
  return rational($rational->numerator / $gcd,
                  $rational->denominator / $gcd,
                  $rational->exact);
}

function rat_add($augend, $addend) {
  return rational($augend->numerator * $addend->denominator +
                  $addend->numerator * $augend->denominator,
                  $augend->denominator * $addend->denominator,
                  $augend->exact && $addend->exact);
}

function rat_sub($minuend, $subtrahend) {
  return rational($minuend->numerator * $subtrahend->denominator -
                  $subtrahend->numerator * $minuend->denominator,
                  $minuend->denominator * $subtrahend->denominator,
                  $minuend->exact && $subtrahend->exact);
}

function rat_mul($multiplicand, $multiplier) {
  return rational($multiplicand->numerator * $multiplier->numerator,
                  $multiplicand->denominator * $multiplier->denominator,
                  $multiplicand->exact && $multiplier->exact);
}

function rat_div($dividend, $divisor) {
  return rational($dividend->numerator * $divisor->denominator,
                  $dividend->denominator * $divisor->numerator,
                  $dividend->exact && $divisor->exact);
}

function add($augend, $addend) {
  $a = $augend;
  $b = imag_part($augend);
  $c = $addend;
  $d = imag_part($addend);
  return complex(rat_add($a, $c),
                 rat_add($b, $d));
}

function sub($minuend, $subtrahend) {
  $a = $minuend;
  $b = imag_part($minuend);
  $c = $subtrahend;
  $d = imag_part($subtrahend);
  return complex(rat_sub($a, $c),
                 rat_sub($b, $d));
}

function mul($multiplicand, $multiplier) {
  $a = $multiplicand;
  $b = imag_part($multiplicand);
  $c = $multiplier;
  $d = imag_part($multiplier);
  return complex(rat_sub(rat_mul($a, $c),
                         rat_mul($b, $d)),
                 rat_add(rat_mul($b, $c),
                         rat_mul($a, $d)));
}

function div($dividend, $divisor) {
  $a = $dividend;
  $b = imag_part($dividend);
  $c = $divisor;
  $d = imag_part($divisor);
  return complex(rat_div(rat_add(rat_mul($a, $c),
                                 rat_mul($b, $d)),
                         rat_add(rat_mul($c, $c),
                                 rat_mul($d, $d))),
                 rat_div(rat_sub(rat_mul($b, $c),
                                 rat_mul($a, $d)),
                         rat_add(rat_mul($c, $c),
                                 rat_mul($d, $d))));
}

function number_to_real($number) {
  return $number->numerator / $number->denominator;
}

function cosine($number) {
  // ignoring imaginary part for now
  return cos(number_to_real($number));
}

function sine($number) {
  // ignoring imaginary part for now
  return sin(number_to_real($number));
}

function real_to_string($number) {
  return is_number($number)
    ? sprintf('%s/%s',
              $number->numerator,
              $number->denominator)
    : 'NaN';
}

function is_negative($number) {
  return is_number($number) &&
    $number->numerator < 0;
}

function is_positive($number) {
  return is_number($number) &&
    $number->numerator > 0;
}

// 0's signum is positive for n+0i; NaN's is <space> for the same
// reason
function signum($number) {
  return is_number($number)
    ? (is_positive($number)
       ? '+'
       : '-')
    : ' ';
}

function is_zero($number) {
  return $number->numerator == 0;
}

// $number implicitly Number, no error checking?
function is_schinteger($number) {
  return is_zero($number->imaginary);
}

function is_rational($object) {
  return $object instanceof Rational;
}

function is_schreal($object) {
  return $object instanceof Real;
}

function is_complex($object) {
  return $object instanceof Complex;
}

function is_number($object) {
  return $object instanceof Number &&
    !(is_null($object->numerator) ||
      is_null($object->denominator));
}

// until we support the whole number stack
function mul_real_integer_hack($real, $integer) {
  return new Real(true, $real->real * $integer->numerator);
}

// until we support the whole number stack
function pow_integer_hack($base, $exponent) {
  return new Integer(true, pow($base->numerator, $exponent->numerator));
}
