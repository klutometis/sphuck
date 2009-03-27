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
