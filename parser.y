%declare_class { class Parser }

%include {
  require_once('stack.php');
  require_once('pair.php');
  require_once('symbol.php');
  require_once('string.php');
  require_once('number.php');
 }

%include_class {
  public $values;
  public $expression;

  function __construct() {
    $this->expression = NULL;
    /* (VALUES ...) */
    $this->values = new Stack();
  }

  function parse($data) {
    foreach (new Lexer($data) as $token => $value) {
      $this->doParse($token, $value);
    }
    $this->doParse(0, 0);
    $values = $this->values;
    $this->__construct();
    return $values;
  }
 }

token ::= number.

number ::= uintegers.

uintegers ::= digit uinteger suffix.

uinteger ::= .

uinteger ::= uinteger digit.

digit ::= ZERO.

digit ::= ONE.

digit ::= TWO.

digit ::= THREE.

digit ::= FOUR.

digit ::= FIVE.

digit ::= SIX.

digit ::= SEVEN.

digit ::= EIGHT.

digit ::= NINE.

suffix ::= exponent_marker sign digit suffix_digits.

suffix_digits ::= .

suffix_digits ::= suffix_digits digit.

exponent_marker ::= E.

exponent_marker ::= S.

exponent_marker ::= F.

exponent_marker ::= D.

exponent_marker ::= L.

sign ::= PLUS.

sign ::= MINUS.
