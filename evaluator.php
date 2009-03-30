<?php

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
