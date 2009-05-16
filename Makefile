SRC := $(wildcard *.php)
OBJ := lexer-decimal.lex.php lexer.lex.php parser-decimal.php parser.php

.PHONY: all test clean decimal

all: $(OBJ)

decimal: lexer-decimal.lex.php parser-decimal.php

lexer-decimal.lex.php: parser-decimal.php lexer-decimal.lex
	cd lib/JLexPHP-151 && \
	java -cp JLexPHP.jar JLexPHP.Main ../../lexer-decimal.lex

lexer.lex.php: parser.php lexer.lex
	cd lib/JLexPHP-151 && \
	java -cp JLexPHP.jar JLexPHP.Main ../../lexer.lex

parser-decimal.php: parser-decimal.y lib/lemon-php-151a/lempar.php
	cd lib/lemon-php-151a && \
	./lemon -lPHP ../../parser-decimal.y

parser.php: parser.y lib/lemon-php-151a/lempar.php
	cd lib/lemon-php-151a && \
	./lemon -lPHP ../../parser.y

test: all
	php test/all.php

clean:
	rm -vf $(OBJ)
