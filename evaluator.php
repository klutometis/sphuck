<?php

// the currency of all this shit are types in quasi-scheme; thus cdr,
// etc. work
function scheval($expression, $environment) {
  if (is_self_evaluating($expression))
    return $expression;
  elseif (is_variable($expression))
    return lookup_variable_value($expression, $environment);
  elseif (is_quoted($expression))
    return text_of_quotation($expression);
  elseif (is_assignment($expression))
    return eval_assignment($expression, $environment);
  elseif (is_definition($expression))
    return eval_definition($expression, $environment);
  elseif (is_if($expression))
    return eval_if($expression, $environment);
  elseif (is_lambda($expression))
    return make_procedure(lambda_parameters($expression),
                          lambda_body($expression),
                          $environment);
  elseif (is_begin($expression))
    return eval_sequence(begin_actions($expression),
                         $environment);
  elseif (is_cond($expression))
    return scheval(cond_to_if($expression),
                   $environment);
  elseif (is_application($expression))
    return apply(scheval(operator($expression), $environment),
                 list_of_values(operands($expression), $environment));
  else
    error("Unknown expression type -- EVAL", $expression);
  }

function apply($procedure, $arguments) {
  if (is_primitive_procedure($procedure))
    return apply_primitive_procedure($procedure, $arguments);
  elseif (is_compound_procedure($procedure))
    return eval_sequence(procedure_body($procedure),
                         extend_environment(procedure_parameters($procedure),
                                            $arguments,
                                            procedure_environment($procedure)));
  else
    error("Unknown procedure type -- APPLY", $procedure);
}

function list_of_values($expressions, $environment) {
  if (are_no_operands($expressions))
    return NULL;
  else
    return cons(scheval(first_operand($expressions),
                     $environment),
                list_of_values(rest_operands($expressions),
                               $environment));
}

function eval_if($expression, $environment) {
  global $false;
  if (scheval(if_predicate($expression), $environment) == $false)
    return scheval(if_alternative($expression), $environment);
  else
    return scheval(if_consequent($expression), $environment);
}

function eval_sequence($expressions, $environment) {
  if (is_last_expression($expressions))
    return scheval(first_expression($expressions),
                   $environment);
  else {
    scheval(first_expression($expressions),
            $environment);
    return eval_sequence(rest_expressions($expressions),
                         $environment);
  }
}

function eval_assignment($expression, $environment) {
  set_variable_value(assignment_variable($expression),
                     scheval(assignment_value($expression),
                          $environment),
                     $environment);
  return symbol('ok');
}

function eval_definition($expression, $environment) {
  define_variable(definition_variable($expression),
                  scheval(definition_value($expression),
                       $environment),
                  $environment);
  return symbol('ok');
}

// had to add an is_null because NULL doesn't evaluate as list
function is_self_evaluating($expression) {
  if (is_number($expression))
    return true;
  elseif(is_string($expression))
    return true;
  elseif(is_null($expression))
    return true;
  else
    return false;
}

function is_variable($expression) {
  return is_symbol($expression);
}

function is_quoted($expression) {
  return is_tagged_list($expression, symbol('quote'));
}

function text_of_quotation($expression) {
  // why the extra car?
  return cadr($expression);
}

function is_tagged_list($expression, $tag) {
  if (is_pair($expression))
    return is_eq(car($expression), $tag);
  else
    return false;
}

function is_assignment($expression) {
  return is_tagged_list($expression, symbol('set!'));
}

function assignment_variable($expression) {
  return cadr($expression);
}

function assignment_value($expression) {
  return caddr($expression);
}

function is_definition($expression) {
  return is_tagged_list($expression, symbol('define'));
}

function definition_variable($expression) {
  if (is_symbol(cadr($expression)))
    return cadr($expression);
  else
    return caadr($expression);
}

function definition_value($expression) {
  if (is_symbol(cadr($expression)))
    return caddr($expression);
  else
    return make_lambda(cdadr($expression),
                       cddr($expression));
}

function is_lambda($expression) {
  return is_tagged_list($expression, symbol('lambda'));
}

function lambda_parameters($expression) {
  return cadr($expression);
}

function lambda_body($expression) {
  return cddr($expression);
}

function make_lambda($parameters, $body) {
  return cons(symbol('lambda'),
              cons($parameters, $body));
}

function is_if($expression) {
  return is_tagged_list($expression, symbol('if'));
}

function if_predicate($expression) {
  return cadr($expression);
}

function if_consequent($expression) {
  return caddr($expression);
}

function if_alternative($expression) {
  if (is_null(cdddr($expression)))
    return $false;
  else
    return cadddr($expression);
}

// need list()
function make_if($predicate, $consequent, $alternative) {
  return lst(symbol('if'),
             $predicate,
             $consequent,
             $alternative);
}

function is_begin($expression) {
  return is_tagged_list($expression, symbol('begin'));
}

function begin_actions($expression) {
  return cdr($expression);
}

function is_last_expression($sequence) {
  return is_null(cdr($sequence));
}

function first_expression($sequence) {
  return car($sequence);
}

function rest_expressions($sequence) {
  return cdr($sequence);
}

function sequence_to_expression($sequence) {
  if (is_null($sequence))
    return $sequence;
  elseif (is_last_expression($sequence))
    return first_expression($sequence);
  else
    return make_begin($sequence);
}

function make_begin($sequence) {
  return cons(symbol('begin'), $sequence);
}

function is_application($expression) {
  return is_pair($expression);
}

function operator($expression) {
  return car($expression);
}

function operands($expression) {
  return cdr($expression);
}

function are_no_operands($operands) {
  return is_null($operands);
}

function first_operand($operands) {
  return car($operands);
}

function rest_operands($operands) {
  return cdr($operands);
}

function is_cond($expression) {
  return is_tagged_list($expression, symbol('cond'));
}

function cond_clauses($expression) {
  return cdr($expression);
}

function is_cond_else_clause($clause) {
  return is_eq(cond_predicate($clause),
               symbol('else'));
}

function cond_predicate($clause) {
  return car($clause);
}

function cond_actions($clause) {
  return cdr($clause);
}

function cond_to_if($expression) {
  return expand_clauses(cond_clauses($expression));
}

// need error()
function expand_clauses($clauses) {
  if (is_null($clauses))
    return $false;
  else {
    $first = car($clauses);
    $rest = cdr($clauses);
    if (cond_else_clause($first)) {
      if (is_null($rest))
        return sequence_to_expression(cond_actions(first));
      else
        error('ELSE clause isn\'t last -- COND->IF', $clauses);
    } else {
      return make_if(cond_predicate($first),
                     sequence_to_expression(cond_actions($first)),
                     // suffers in absence of tail recursion! argument
                     // for machine? or rewrite recursion with a
                     // trampoline:
                     // http://loveandtheft.org/2009/01/20/tail-call-recursion-optimization-in-php/
                     expand_clauses($rest));
    }
  }
}

function is_true($expression) {
  return !is_false($expression);
}

// FALSE singleton?
function is_false($expression) {
  return is_eq($expression, $false);
}

// need list()
function make_procedure($parameters, $body, $environment) {
  return lst(symbol('procedure'),
             $parameters,
             $body,
             $environment);
}

// symbol() function that memoizes symbols?
function is_compound_procedure($procedure) {
  return is_tagged_list($procedure, symbol('procedure'));
}

function procedure_parameters($procedure) {
  return cadr($procedure);
}

function procedure_body($procedure) {
  return caddr($procedure);
}

function procedure_environment($procedure) {
  return cadddr($procedure);
}

function enclosing_environment($environment) {
  return cdr($environment);
}

function first_frame($environment) {
  return car($environment);
}

$the_empty_environment = NULL;

function make_frame($variables, $values) {
  return cons($variables, $values);
}

function frame_variables($frame) {
  return car($frame);
}

function frame_values($frame) {
  return cdr($frame);
}

// need set_car(), set_cdr(); also: could do better with a hash table?
function add_binding_to_frame($variable, $value, $frame) {
  set_car($frame, cons($variable, car($frame)));
  set_cdr($frame, cons($value, cdr($frame)));
}

// need length()
function extend_environment($variables, $values, $base_environment) {
  if (length($variables) == length($values))
    return cons(make_frame($variables, $values), $base_environment);
  else {
    if (length($variables) < length($values))
      error('Too many arguments supplied', $variables, $values);
    else
      error('Too few arguments supplied', $variables, $values);
  }
}

// namespace candidates? trampoline candidates?
function lookup_variable_value($variable, $environment) {
  return lookup_variable_value_env_loop($variable, $environment);
}

function lookup_variable_value_env_loop($variable, $environment) {
  global $the_empty_environment;
  if (is_eq($environment, $the_empty_environment))
    error('Unbound variable', $variable);
  else {
    $frame = first_frame($environment);
    return lookup_variable_value_env_loop_scan($variable,
                                               $environment,
                                               frame_variables($frame),
                                               frame_values($frame));
  }
}

function lookup_variable_value_env_loop_scan($variable,
                                             $environment,
                                             $variables,
                                             $values) {
  // var_dump($variables);
  if (is_null($variables))
    return lookup_variable_value_env_loop($variable,
                                          enclosing_environment($environment));
  elseif (is_eq($variable, car($variables)))
    return car($values);
  else
    return lookup_variable_value_env_loop_scan($variable,
                                               $environment,
                                               cdr($variables),
                                               cdr($values));
}

function set_variable_value($variable, $value, $environment) {
  return set_variable_value_loop($variable, $value, $environment);
}

function set_variable_value_env_loop($variable, $value, $enviroment) {
  global $the_empty_environment;
  if (is_eq($environment, $the_empty_environment))
    error('Unbound variable', $variable);
  else {
    $frame = first_frame($environment);
    set_variable_value_env_loop_scan($variable,
                                     $value,
                                     $environment,
                                     frame_variables($frame),
                                     frame_values($frame));
  }
}

function set_variable_value_env_loop_scan($variable,
                                          $value,
                                          $enviroment,
                                          $variables,
                                          $values) {
  if (is_null($variables))
    return set_variable_value_env_loop($variable,
                                       $value,
                                       enclosing_environment($environment));
  elseif (is_eq($variable, car($variables)))
    return set_car($values, $value);
  else
    return set_variable_value_env_loop_scan($variable,
                                            $value,
                                            $environment,
                                            cdr($variables),
                                            cdr($values));
}

function define_variable($variable,
                         $value,
                         $environment) {
  $frame = first_frame($environment);
  define_variable_scan($variable,
                       $value,
                       $environment,
                       $frame,
                       frame_variables($frame),
                       frame_values($frame));
}

function define_variable_scan($variable,
                              $value,
                              $environment,
                              $frame,
                              $variables,
                              $values) {
  if (is_null($variables))
    add_binding_to_frame($variable, $value, $frame);
  elseif (is_eq($variable, car($variables)))
    set_car($values, $value);
  else
    define_variable_scan($variable,
                         $value,
                         $environment,
                         $frame,
                         cdr($variables),
                         cdr($values));
}

function setup_environment() {
  global $the_empty_environment, $true, $false;
  $initial_environment = extend_environment(primitive_procedure_names(),
                                            primitive_procedure_objects(),
                                            $the_empty_environment);
  define_variable(symbol('true'), $true, $initial_environment);
  define_variable(symbol('false'), $false, $initial_environment);
  return $initial_environment;
}

$the_global_environment = setup_environment();

function is_primitive_procedure($procedure) {
  return is_tagged_list($procedure, symbol('primitive'));
}

function primitive_implementation($procedure) {
  return cadr($procedure);
}

function primitive_procedure_names() {
  global $primitive_procedures;
  return map('car', $primitive_procedures);
}

function primitive_procedure_objects() {
  global $primitive_procedures;
  return map(function($procedure) {
      return lst(symbol('primitive'),
                 cadr($procedure));
    },
    $primitive_procedures);
}

function apply_in_underlying_chandala($procedure, $arguments) {
  return call_user_func($procedure, $arguments);
}

function apply_primitive_procedure($procedure, $arguments) {
  return apply_in_underlying_chandala(primitive_implementation($procedure),
                                      $arguments);
}

$input_prompt = string(';;; M-Eval input:');
$output_prompt = string(';;; M-Eval value:');
$current_input_port = new Port(fopen('php://stdin', 'r'));

// really a readline (fgets); need a read() that stops after one
// expression.
function read($port=NULL) {
  global $current_input_port, $eof;
  // NULL/false ambiguity
  if (!$port)
    $port = $current_input_port;
  $handle = $port->handle;
  if (feof($handle))
    return $eof;
  else {
    // parser persistance?
    $parser = new Parser();
    $parsed = $parser->parse(fgets($handle));
    // legitimate?
    if ($parsed->is_empty())
      return $eof;
    // begging the question of VALUES here, unless we can wrap in
    // (values ...)
    else return array_car($parsed->data);
  }
}

function driver_loop() {
  global $input_prompt,
    $output_prompt,
    $the_global_environment;
  prompt_for_input($input_prompt);
  $input = read();
  if (is_eof_object($input))
    exit(0);
  $output = scheval($input, $the_global_environment);
  announce_output($output_prompt);
  user_print($output);
  driver_loop();
}

function prompt_for_input($string) {
  print "\n\n$string\n";
}

function announce_output($string) {
  printf("\n%s\n", $string);
}

function user_print($object) {
  if (is_compound_procedure($object))
    print lst(symbol('compound-procedure'),
              procedure_parameters($object),
              procedure_body($object),
              symbol('<procedure-body>'));
  else
    print $object;
}

function error() {
  $objects = func_get_args();
  $message = implode(array_map(function($object) {
        return (string) $object;
      }, $objects), ' ');
  throw new Exception($message);
}
