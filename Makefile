.PHONY: test

lexer.php: lexer.plex
	plex lexer.plex

test:
	php test/all.php
