<?php

function token_array($lexer) {
  $tokens = NULL;
  while ($token = $lexer->next_token()) {
    $tokens[] = array($token->type =>
                      $token->value);
  }
  return $tokens;
  }
