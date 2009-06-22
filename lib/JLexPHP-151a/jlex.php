<?php # vim:ts=2:sw=2:et:
/*
  Copyright 2006 Wez Furlong, OmniTI Computer Consulting, Inc.
  Based on JLex which is:

       JLEX COPYRIGHT NOTICE, LICENSE, AND DISCLAIMER
  Copyright 1996-2000 by Elliot Joel Berk and C. Scott Ananian 

  Permission to use, copy, modify, and distribute this software and its
  documentation for any purpose and without fee is hereby granted,
  provided that the above copyright notice appear in all copies and that
  both the copyright notice and this permission notice and warranty
  disclaimer appear in supporting documentation, and that the name of
  the authors or their employers not be used in advertising or publicity
  pertaining to distribution of the software without specific, written
  prior permission.

  The authors and their employers disclaim all warranties with regard to
  this software, including all implied warranties of merchantability and
  fitness. In no event shall the authors or their employers be liable
  for any special, indirect or consequential damages or any damages
  whatsoever resulting from loss of use, data or profits, whether in an
  action of contract, negligence or other tortious action, arising out
  of or in connection with the use or performance of this software.
  **************************************************************
*/

class JLexToken {
  public $line;
  public $col;
  public $value;
  public $type;
  public $char;

  function __construct($type,
                       $value = null,
                       $line = null,
                       $col = null,
                       $char = null) {
    $this->line = $line;
    $this->col = $col;
    $this->value = $value;
    $this->type = $type;
    $this->char = $char;
  }
}

class JLexBase {
  public $yy_reader;
  public $yy_buffer;
  public $yy_buffer_read;
  public $yy_buffer_index;
  public $yy_buffer_start;
  public $yy_buffer_end;
  public $yychar = 0;
  public $yycol = 0;
  public $yyline = 0;
  public $yy_at_bol;
  public $yy_lexical_state;
  public $yy_last_was_cr = false;
  public $yy_count_lines = false;
  public $yy_count_chars = false;
  public $yyfilename = null;

  function __construct($stream) {
    $this->yy_reader = $stream;
    $meta = stream_get_meta_data($stream);
    if (!isset($meta['uri'])) {
      $this->yyfilename = '<<input>>';
    } else {
      $this->yyfilename = $meta['uri'];
    }

    $this->yy_buffer = "";
    $this->yy_buffer_read = 0;
    $this->yy_buffer_index = 0;
    $this->yy_buffer_start = 0;
    $this->yy_buffer_end = 0;
    $this->yychar = 0;
    $this->yyline = 0;
    $this->yy_at_bol = true;
  }

  protected function yybegin($state) {
    $this->yy_lexical_state = $state;
  }

  protected function yy_advance() {
    if ($this->yy_buffer_index < $this->yy_buffer_read) {
      return ord($this->yy_buffer[$this->yy_buffer_index++]);
    }
    if ($this->yy_buffer_start != 0) {
      /* shunt */
      $j = $this->yy_buffer_read - $this->yy_buffer_start;
      $this->yy_buffer = substr($this->yy_buffer, $this->yy_buffer_start, $j);
      $this->yy_buffer_end -= $this->yy_buffer_start;
      $this->yy_buffer_start = 0;
      $this->yy_buffer_read = $j;
      $this->yy_buffer_index = $j;

      $data = fread($this->yy_reader, 8192);
      if ($data === false || !strlen($data)) return $this->YY_EOF;
      $this->yy_buffer .= $data;
      $this->yy_buffer_read .= strlen($data);
    }

    while ($this->yy_buffer_index >= $this->yy_buffer_read) {
      $data = fread($this->yy_reader, 8192);
      if ($data === false || !strlen($data)) return $this->YY_EOF;
      $this->yy_buffer .= $data;
      $this->yy_buffer_read .= strlen($data);
    }
    return ord($this->yy_buffer[$this->yy_buffer_index++]);
  }

  protected function yy_move_end() {
    if ($this->yy_buffer_end > $this->yy_buffer_start &&
        $this->yy_buffer[$this->yy_buffer_end-1] == "\n")
      $this->yy_buffer_end--;
    if ($this->yy_buffer_end > $this->yy_buffer_start &&
        $this->yy_buffer[$this->yy_buffer_end-1] == "\r")
      $this->yy_buffer_end--;
  }

  protected function yy_mark_start() {
    if ($this->yy_count_lines || $this->yy_count_chars) {
      if ($this->yy_count_lines) {
        for ($i = $this->yy_buffer_start; $i < $this->yy_buffer_index; ++$i) {
          if ("\n" == $this->yy_buffer[$i] && !$this->yy_last_was_cr) {
            ++$this->yyline;
            $this->yycol = 0;
          }
          if ("\r" == $this->yy_buffer[$i]) {
            ++$yyline;
            $this->yycol = 0;
            $this->yy_last_was_cr = true;
          } else {
            $this->yy_last_was_cr = false;
          }
        }
      }
      if ($this->yy_count_chars) {
        $this->yychar += $this->yy_buffer_index - $this->yy_buffer_start;
        $this->yycol += $this->yy_buffer_index - $this->yy_buffer_start;
      }
      $this->yy_buffer_start = $this->yy_buffer_index;
    }
  }

  protected function yy_mark_end() {
    $this->yy_buffer_end = $this->yy_buffer_index;
  }

  protected function yy_to_mark() {
    #echo "yy_to_mark: setting buffer index to ", $this->yy_buffer_end, "\n";
    $this->yy_buffer_index = $this->yy_buffer_end;
    $this->yy_at_bol = ($this->yy_buffer_end > $this->yy_buffer_start) &&
                ("\r" == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 "\n" == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 2028 /* unicode LS */ == $this->yy_buffer[$this->yy_buffer_end-1] ||
                 2029 /* unicode PS */ == $this->yy_buffer[$this->yy_buffer_end-1]);
  }

  protected function yytext() {
    return substr($this->yy_buffer, $this->yy_buffer_start, 
          $this->yy_buffer_end - $this->yy_buffer_start);
  }

  protected function yylength() {
    return $this->yy_buffer_end - $this->yy_buffer_start;
  }

  static $yy_error_string = array(
    'INTERNAL' => "Error: internal error.\n",
    'MATCH' => "Error: Unmatched input.\n"
  );

  protected function yy_error($code, $fatal) {
    print self::$yy_error_string[$code];
    flush();
    if ($fatal) throw new Exception("JLex fatal error " . self::$yy_error_string[$code]);
  }

  /* creates an annotated token */
  function createToken($type = null) {
    if ($type === null) $type = $this->yytext();
    $tok = new JLexToken($type);
    $this->annotateToken($tok);
    return $tok;
  }

  /* annotates a token with a value and source positioning */
  function annotateToken(JLexToken $tok) {
    $tok->value = $this->yytext();
    $tok->col = $this->yycol;
    $tok->line = $this->yyline;
    $tok->filename = $this->yyfilename;
    $tok->char = $this->yychar;
  }
}
