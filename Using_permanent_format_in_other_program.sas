/*** Demo7a.1 -- Using Permanent Formats in Other Programs ***/

options fmtsearch=(sasuser.jinjin);

proc sort 
	data=sasuser.fss100; 
	by rank; 
	run;

proc freq 
	data=sasuser.fss100;
	tables leave; 
	by rank;
	format rank $rankf.;
	where rank ne ' ';
run;

quit;
