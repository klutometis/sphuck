OBJ := lexer.lex.php parser.php

.PHONY: all test clean

all: $(OBJ)

lexer.lex.php: parser.php lexer.lex
	java -cp JLexPHP.jar JLexPHP.Main lexer.lex

parser.php: parser.y
	./lemon -lPHP parser.y

test: all
	php test/all.php

clean:
	rm -vf $(OBJ)
