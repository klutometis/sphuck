<?php

class StringReader {
  public $string;
  public $length;
  public $index;
  function stream_open($path, $mode, $options, &$opened_path) {
    $this->string = parse_url($path, PHP_URL_HOST);
    $this->length = strlen($this->string);
    return true;
  }
  function stream_read($count) {
    $substr = substr($this->string, $this->index, $count);
    $this->index += $count;
    return $substr;
  }
  function stream_eof() {
    return $this->index >= $this->length;
  }
  }

stream_wrapper_register('str', 'StringReader');
