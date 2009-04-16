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

token ::= identifier.

token ::= boolean.

token ::= number.

token ::= CHARACTER.

token ::= STRING.

token ::= OPEN.

token ::= CLOSE.

token ::= OPEN_VECTOR.

token ::= QUOTE.

token ::= QUASIQUOTE.

token ::= UNQUOTE.

token ::= UNQUOTE_SPLICING.

identifier ::= identifier_initial.

identifier ::= identifier_peculiar.

identifier_initial ::= initial identifier_initial_subsequent.

identifier_initial_subsequent ::= .

identifier_initial_subsequent ::= identifier_initial_subsequent subsequent.

identifier_peculiar ::= peculiar_identifier.

peculiar_identifier ::= POSITIVE.

peculiar_identifier ::= NEGATIVE.

peculiar_identifier ::= ELLIPSIS.

initial ::= letter.

initial ::= SPECIAL_INITIAL.

letter ::= LETTER.

letter ::= A.

letter ::= B.

letter ::= C.

letter ::= D.

letter ::= E.

letter ::= F.

letter ::= I.

letter ::= L.

letter ::= S.

subsequent ::= initial.

subsequent ::= digit.

subsequent ::= special_subsequent.

special_subsequent ::= POSITIVE.

special_subsequent ::= NEGATIVE.

special_subsequent ::= DOT.

special_subsequent ::= ASPERAND.

boolean ::= TRUE.

boolean ::= FALSE.

number ::= uintegers.

uintegers ::= digit uinteger.

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
