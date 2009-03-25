sexp.php: sexp.plex
	plex sexp.plex

test: sexp.php
	php test/all.php
