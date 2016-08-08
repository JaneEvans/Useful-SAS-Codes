proc contents
	data = all varnum noprint out = vars;
run;

PROC SQL noprint;
	SELECT name into :varlist SEPARATED BY ' '
	FROM vars
	WHERE TYPE = 2 And NAME ^= "uuid"
	ORDER BY varnum;
	%put nvar &sqlobs.;
	%put &varlist;
QUIT;