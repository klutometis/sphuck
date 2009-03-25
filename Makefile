sexp.php: sexp.plex
	plex sexp.plex

tests: sexp.php
	php test/all.php
