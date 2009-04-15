%declare_class { class Parser }

%include {
  require_once('stack.php');
  require_once('pair.php');
  require_once('symbol.php');
  require_once('string.php');
  require_once('number.php');
  /*variable ::= identifier {
    // going to have to handle this in a special way; must do it in the
    // parser?
  }

token ::= character.

character ::= CHARACTER.

delimiter ::= whitespace.

delimiter ::= OPEN.

delimiter ::= CLOSE.

delimiter ::= DOUBLE_QUOTE.

delimiter ::= SEMICOLON.

whitespace ::= SPACE.

whitespace ::= NEWLINE.

atmosphere ::= whitespace.

atmosphere ::= COMMENT.

intertoken_space ::= .

intertoken_space ::= intertoken_space atmosphere.

syntactic_keyword ::= EXPRESSION_KEYWORD.

syntactic_keyword ::= SYNTACTIC_KEYWORD.

string ::= DOUBLE_QUOTE string_element DOUBLE_QUOTE.

string_element ::= .

string_element ::= string_element STRING_ELEMENT.

*/

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

token ::= TRUE. 

token ::= FALSE.

token ::= CHARACTER.

token ::= OPEN.

token ::= CLOSE.

token ::= OPEN_VECTOR.

token ::= QUOTE.

token ::= QUASIQUOTE.

token ::= UNQUOTE.

token ::= UNQUOTE_SPLICING.

identifier ::= identifier_initial.

identifier ::= identifier_peculiar.

identifier_initial ::= initial identifier_initial_subseqeunt.

identifier_initial_subseqeunt ::= .

identifier_initial_subseqeunt ::= identifier_initial_subseqeunt subsequent.

identifier_peculiar ::= peculiar_identifier.

peculiar_identifier ::= POSITIVE.

peculiar_identifier ::= NEGATIVE.

peculiar_identifier ::= ELLIPSIS.

initial ::= letter.

initial ::= SPECIAL_INITIAL.

letter ::= A.

letter ::= B.

letter ::= C.

letter ::= D.

letter ::= E.

letter ::= F.

letter ::= G.

letter ::= H.

letter ::= I.

letter ::= J.

letter ::= K.

letter ::= L.

letter ::= M.

letter ::= N.

letter ::= O.

letter ::= P.

letter ::= Q.

letter ::= R.

letter ::= S.

letter ::= T.

letter ::= U.

letter ::= V.

letter ::= W.

letter ::= X.

letter ::= Y.

letter ::= Z.

subsequent ::= initial.

subsequent ::= DIGIT.

subsequent ::= special_subsequent.

special_subsequent ::= POSITIVE.

special_subsequent ::= NEGATIVE.

special_subsequent ::= DOT.

special_subsequent ::= ASPERAND.
