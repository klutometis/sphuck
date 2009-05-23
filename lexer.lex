<?php

%%

%{
  public static $KEYWORDS =
      array('else',
            '=>',
            'define',
            'unquote',
            'unquote-splicing',
            'quote',
            'lambda',
            'if',
            'set!',
            'begin',
            'cond',
            'and',
            'or',
            'case',
            'let',
            'let*',
            'letrec',
            'do',
            'delay',
            'quasiquote',
            );

  function token_array() {
    $tokens = NULL;
    while ($token = $this->next_token()) {
      $tokens[] = array($token->type =>
                        $token->value);
    }
    return $tokens;
  }
%}

%unicode
%ignorecase
%line
%char
%class SphuckLexer
%function next_token

TOKEN = ({IDENTIFIER}|{BOOLEAN}|{NUMBER}|{CHARACTER}|{STRING}|{OPEN}|{CLOSE}|{OPEN_VECTOR}|{QUOTE}|{QQUOTE}|{UNQUOTE}|{UNQUOTE_SPLICING}|{DOT})
OPEN = \(
CLOSE = \)
OPEN_VECTOR = #\(
QUOTE = '
QQUOTE = `
UNQUOTE = ,
UNQUOTE_SPLICING = ,@
DOT = \.
DELIMITER = ({WHITESPACE}|\(|\)|"|;)
WHITESPACE = [ \n]
COMMENT = ;.*
ATMOSPHERE = ({WHITESPACE}|{COMMENT})
INTERTOKEN_SPACE = {ATMOSPHERE}*

IDENTIFIER = ({INITIAL}{SUBSEQUENT}*|{PECULIAR_IDENTIFIER})
INITIAL = ({LETTER}|{SPECIAL_INITIAL})
LETTER = [a-z]

SPECIAL_INITIAL = [!$%&*/:<=>?^_~]
SUBSEQUENT = ({INITIAL}|{DIGIT}|{SPECIAL_SUBSEQUENT})
DIGIT = [0-9]
SPECIAL_SUBSEQUENT = [+\-.@]
PECULIAR_IDENTIFIER = (\+|-|\.\.\.)

SYNTACTIC_KEYWORD = ({EXPRESSION_KEYWORD}|else|=>|define|unquote|unquote-splicing)
EXPRESSION_KEYWORD = (quote|lambda|if|set!|begin|cond|and|or|case|let|let\*|letrec|do|delay|quasiquote)

BOOLEAN = (#t|#f)
CHARACTER = \#\\(.|{CHARACTER_NAME})
CHARACTER_NAME = (space|newline)

STRING = \"{STRING_ELEMENT}*\"
STRING_ELEMENT = ([^\"\\]|\\\"|\\\\) // need some lookahead here, don't we?

NUMBER = {NUM_2}|{NUM_8}|{NUM_10}|{NUM_16}

NUM_2 = {PREFIX_2}{COMPLEX_2}
NUM_8 = {PREFIX_8}{COMPLEX_8}
NUM_10 = {PREFIX_10}{COMPLEX_10}
NUM_16 = {PREFIX_16}{COMPLEX_16}
COMPLEX_2 = ({REAL_2}|{REAL_2}\@{REAL_2}|{REAL_2}\+{UREAL_2}i|{REAL_2}-{UREAL_2}i|{REAL_2}\+i|{REAL_2}-i|\+{UREAL_2}i|-{UREAL_2}i|\+i|-i)
COMPLEX_8 = ({REAL_8}|{REAL_8}\@{REAL_8}|{REAL_8}\+{UREAL_8}i|{REAL_8}-{UREAL_8}i|{REAL_8}\+i|{REAL_8}-i|\+{UREAL_8}i|-{UREAL_8}i|\+i|-i)
COMPLEX_10 = ({REAL_10}|{REAL_10}\@{REAL_10}|{REAL_10}\+{UREAL_10}i|{REAL_10}-{UREAL_10}i|{REAL_10}\+i|{REAL_10}-i|\+{UREAL_10}i|-{UREAL_10}i|\+i|-i)
COMPLEX_16 = ({REAL_16}|{REAL_16}\@{REAL_16}|{REAL_16}\+{UREAL_16}i|{REAL_16}-{UREAL_16}i|{REAL_16}\+i|{REAL_16}-i|\+{UREAL_16}i|-{UREAL_16}i|\+i|-i)
REAL_2 = {SIGN}{UREAL_2}
REAL_8 = {SIGN}{UREAL_8}
REAL_10 = {SIGN}{UREAL_10}
REAL_16 = {SIGN}{UREAL_16}
UREAL_2 = ({UINTEGER_2}|{UINTEGER_2}/{UINTEGER_2})
UREAL_8 = ({UINTEGER_8}|{UINTEGER_8}/{UINTEGER_8})
UREAL_10 = ({UINTEGER_10}|{UINTEGER_10}/{UINTEGER_10}|{DECIMAL_10})
DECIMAL_10 = ({UINTEGER_10}{SUFFIX}|\.{DIGIT_10}+#*{SUFFIX}|{DIGIT_10}+\.{DIGIT_10}*#*{SUFFIX}|{DIGIT_10}+#+\.#*{SUFFIX})
UREAL_16 = ({UINTEGER_16}|{UINTEGER_16}/{UINTEGER_16})
UINTEGER_2 = {DIGIT_2}+#*
UINTEGER_8 = {DIGIT_8}+#*
UINTEGER_10 = {DIGIT_10}+#*
UINTEGER_16 = {DIGIT_16}+#*
PREFIX_2 = ({EXACTNESS}{RADIX_2}|{RADIX_2}{EXACTNESS})
PREFIX_8 = ({EXACTNESS}{RADIX_8}|{RADIX_8}{EXACTNESS})
PREFIX_10 = ({EXACTNESS}{RADIX_10}|{RADIX_10}{EXACTNESS})
PREFIX_16 = ({EXACTNESS}{RADIX_16}|{RADIX_16}{EXACTNESS})

SUFFIX = ({EXPONENT_MARKER}{SIGN}{DIGIT_10}+)?
EXPONENT_MARKER = [esfdl]
SIGN = (\+|-)?
EXACTNESS = (#i|#e)?
RADIX_2 = #b
RADIX_8 = #o
RADIX_10 = (#d)?
RADIX_16 = #x
DIGIT_2 = [01]
DIGIT_8 = [0-7]
DIGIT_10 = [0-9]
DIGIT_16 = [0-9a-f]
%%

{IDENTIFIER} { return $this->createToken(SphuckParser::SPHUCK_IDENTIFIER); }
{BOOLEAN} { return $this->createToken(SphuckParser::SPHUCK_BOOLEAN); }
{NUM_2} { return (SphuckParser::SPHUCK_NUM_2); }
{NUM_8} { return $this->createToken(SphuckParser::SPHUCK_NUM_8); }
{NUM_10} { return $this->createToken(SphuckParser::SPHUCK_NUM_10); }
{NUM_16} { return $this->createToken(SphuckParser::SPHUCK_NUM_16); }
{CHARACTER} { return $this->createToken(SphuckParser::SPHUCK_CHARACTER); }
{STRING} { return $this->createToken(SphuckParser::SPHUCK_STRING); }
{OPEN} { return $this->createToken(SphuckParser::SPHUCK_OPEN); }
{CLOSE} { return $this->createToken(SphuckParser::SPHUCK_CLOSE); }
{OPEN_VECTOR} { return $this->createToken(SphuckParser::SPHUCK_); }
{QUOTE} { return $this->createToken(SphuckParser::SPHUCK_QUOTE); }
{QQUOTE} { return $this->createToken(SphuckParser::SPHUCK_QQUOTE); }
{UNQUOTE} { return $this->createToken(SphuckParser::SPHUCK_UNQUOTE); }
{UNQUOTE_SPLICING} { return $this->createToken(SphuckParser::SPHUCK_UNQUOTE_SPLICING); }
{DOT} { return $this->createToken(SphuckParser::SPHUCK_DOT); }
{INTERTOKEN_SPACE} {}
