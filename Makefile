OBJ := lexer.php parser.php

.PHONY: all test

all: $(OBJ)

lexer.php: parser.php lexer.plex
	plex lexer.plex

parser.php: parser.y
	phplemon parser.y

test: all
	php test/all.php
