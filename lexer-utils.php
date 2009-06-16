<?php

function token_array($lexer) {
  $tokens = NULL;
  while ($token = $lexer->next_token()) {
    $tokens[] = array($token->type =>
                      $token->value);
  }
  return $tokens;
  }

class LexerState {
  public $YY_EOF;
  public $yy_count_chars;
  public $yy_count_lines;
  public $yy_reader;
  public $yy_buffer_read;
  public $yy_buffer_index;
  public $yy_buffer_start;
  public $yy_buffer_end;
  public $yychar;
  public $yycol;
  public $yyline;
  public $yy_at_bol;
  public $yy_lexical_state;
  public $yy_last_was_cr;
  public $yyfilename;

  function __construct($lexer) {
    $this->YY_EOF = $lexer->YY_EOF;
    $this->yy_count_chars = $lexer->yy_count_chars;
    $this->yy_count_lines = $lexer->yy_count_lines;
    $this->yy_reader = $lexer->yy_reader;
    $this->yy_buffer_read = $lexer->yy_buffer_read;
    $this->yy_buffer_index = $lexer->yy_buffer_index;
    $this->yy_buffer_start = $lexer->yy_buffer_start;
    $this->yy_buffer_end = $lexer->yy_buffer_end;
    $this->yychar = $lexer->yychar;
    $this->yycol = $lexer->yycol;
    $this->yyline = $lexer->yyline;
    $this->yy_at_bol = $lexer->yy_at_bol;
    $this->yy_lexical_state = $lexer->yy_lexical_state;
    $this->yy_last_was_cr = $lexer->yy_last_was_cr;
    $this->yyfilename = $lexer->yyfilename;
  }
}
