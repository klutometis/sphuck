SRC := $(wildcard *.php)
LEX := $(patsubst %.lex,%.lex.php,$(wildcard *.lex))
PARSE := $(patsubst %.y,%.php,$(wildcard *.y))

.PHONY: all test clean decimal

all: $(LEX) $(PARSE)

%.lex.php : %.lex
	cd lib/JLexPHP-151 && \
	java -cp JLexPHP.jar JLexPHP.Main ../../$<

%.php : %.y
	cd lib/lemon-php-151a && \
	./lemon -lPHP ../../$<

test: all
	php test/all.php

clean:
	rm -vf $(OBJ)
