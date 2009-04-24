SRC := $(wildcard *.php)
OBJ := lexer.lex.php parser.php

.PHONY: all test clean

all: $(OBJ)

lexer.lex.php: parser.php lexer.lex $(SRC)
	cd lib/JLexPHP-151 && \
	java -cp JLexPHP.jar JLexPHP.Main ../../lexer.lex

parser.php: parser.y lib/lemon-php-151a/lempar.php $(SRC)
	cd lib/lemon-php-151a && \
	./lemon -lPHP ../../parser.y

test: all
	php test/all.php

clean:
	rm -vf $(OBJ)
