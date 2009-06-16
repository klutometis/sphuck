<?php

class StringReader {
  public $string;
  public $length;
  public $index;
  // imitates global
  public static $references;
  static function put($value) {
    StringReader::$references[] = $value;
    return sizeof(StringReader::$references) - 1;
  }
  function stream_open($path, $mode, $options, &$opened_path) {
    $key = parse_url($path, PHP_URL_HOST);
    $this->string = StringReader::$references[$key];
    $this->length = strlen($this->string);
    return true;
  }
  function stream_read($count) {
    $substr = substr($this->string, $this->index, $count);
    $this->index = min($this->index + $count, $this->length);
    return $substr;
  }
  function stream_eof() {
    return $this->index >= $this->length;
  }
  function stream_seek($offset, $whence=SEEK_SET) {
    switch($whence) {
    case SEEK_SET:
      $this->index = $offset;
      break;
    case SEEK_CUR:
      $this->index += $offset;
      break;
    case SEEK_END:
      $this->index = $this->length + $offset;
      break;
    }
    return true;
  }
  function stream_tell() {
    return $this->index;
  }
  }

stream_wrapper_register('str', 'StringReader');
