<?php

// the currency of all this shit are types in quasi-scheme; thus cdr,
// etc. work
function eval($expression, $environment) {
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
    return eval(cond_to_if($expression),
                $environment);
  elseif (is_application($expression))
    return apply(eval(operator($expression), $environment),
                 list_of_values(operands($expression), $environment));
  else
    error("Unknown expression type -- EVAL", $expression);
  }

function apply($procedure, $arguments) {
  if (is_primitive_procedure($procedure))
    apply_primitive_procedure($procedure);
  elseif (is_compound_procedure($procedure))
    eval_sequence(procedure_body($procedure),
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
    return cons(eval(first_operand($expressions),
                     $environment),
                list_of_values(rest_operands($expressions),
                               $environment));
}

function eval_if($expression, $environment) {
  if (eval(if_predicate($expression), $environment))
    return eval(if_consequent($expression), $environment);
  else
    return eval(if_alternative($expression), $environment);
}

function eval_sequence($expressions, $environment) {
  if (is_last_expression($expressions))
    return eval(first_expression($expressions));
  else {
    eval(first_expression($expressions));
    return eval_sequence(rest_expressions($expressions),
                         $environment);
  }
}

function eval_assignment($expression, $environment) {
  set_variable_value(assignment_variable($expression),
                     eval(assignment_value($expression),
                          $environment),
                     $environment);
}

function eval_definition($expression, $environment) {
  define_variable(definition_variable($expression),
                  eval(definition_value($expression),
                       $environment),
                  $environment);
}

function is_self_evaluating($expression) {
  if (is_number($expression))
    return true;
  elseif(is_string($expression))
    return true;
  else
    return false;
}

// is_symbol needs work (have symbol type)
function is_variable($expression) {
  return is_symbol($expression);
}

function is_quoted($expression) {
  return is_tagged_list($expression, new Symbol('quote'));
}

// can cadr Pairs; what about composition of car and cdr?
function text_of_quotation($expression) {
  return cadr($expression);
}

// need is_pair; need is_eq; in fact: just implement the disjoint type
// predicates; how much of r5rs implement in PHP: whatever is needed
// for the non-metacircular evaluator; the rest in scheme, where
// possible? why not all in php, export to interpreter? cadr, caddr,
// caadr. should new Symbol('x') be replaced with a generic quote
// mechanism? whereby quote(string) -> symbol; quote(pair) -> pair?
function is_tagged_list($expression, $tag) {
  if (is_pair($expression))
    return is_eq(car($expression), $tag);
  else
    return false;
}

function is_assignment($expression, $tag) {
  return is_tagged_list($expression, new Symbol('set!'));
}

function assignment_variable($expression) {
  return cadr($expression);
}

function assignment_value($expression) {
  return caddr($expression);
}

function is_definition($expression) {
  return is_tagged_list($expression, new Symbol('define'));
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
  return is_tagged_list($expression, new Symbol('lambda'));
}

function lambda_parameters($expression) {
  return cadr($expression);
}

function lambda_body($expression) {
  return cddr($expression);
}

function make_lambda($parameters, $body) {
  return cons(new Symbol('lambda'),
              cons($parameters, $body));
}

function is_if($expression) {
  return is_tagged_list($expression, new Symbol('if'));
}

function if_predicate($expression) {
  return cadr($expression);
}

function if_consequent($expression) {
  return caddr($expression);
}

function if_alternative($expression) {
  if (is_null(cdddr($expression)))
    return new Boolean(false);
  else
    return cadddr($expression);
}

// need list()
function make_if($predicate, $consequent, $alternative) {
  return list(new Symbol('if'),
              $predicate,
              $consequent,
              $alternative);
}

function is_begin($expression) {
  return is_tagged_list($expression, new Symbol('begin'));
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
  return cons(new Symbol('begin'), $sequence);
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
  return is_tagged_list($expression, new Symbol('cond'));
}

function cond_clauses($expression) {
  return cdr($expression);
}

function is_cond_else_clause($clause) {
  return is_eq(cond_predicate($clause),
               new Symbol('else'));
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
    return new Boolean(false);
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
  return is_eq($expression, new Boolean(false));
}

// need list()
function make_procedure($parameters, $body, $environment) {
  return list(new Symbol('procedure'),
              $parameters,
              $body,
              $environment);
}

// symbol() function that memoizes symbols?
function is_compound_procedure($procedure) {
  return is_tagged_list($procedure, new Symbol('procedure'));
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

function lookup_variable_value($variable, $environment) {
  
}
