lexer.php: lexer.plex
	plex lexer.plex

test: lexer.php
	php test/all.php
