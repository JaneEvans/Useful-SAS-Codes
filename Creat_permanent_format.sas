x "cd C:\Users\GeJ\Desktop\SAS";
libname sasuser " C:\Users\GeJ\Desktop\SAS\jinjin";

proc format
	library = sasuser.jinjin;
	value  rankfmt	1 = "Professor"
					2 = "assoc. Prof."
					3 = "asst. Prof."
					4 = "instructor or lecturer"
					5 = "other"
			;
run;


data 	dall
		dprof (keep = compens compens5)
		dnprof (keep = item1-item33);
	
		set sasuser.fss100;
		
		array compvar(5)
			item13
			item15
			item27
			item29
			item30
		;

		compens = 0;
		do i = 1 to 5;
			if compvar(i) = 9 then call missing(compvar(i));
			compens = compens + compvar(i);
		end;

		compens5 = round((compens/5),1);

		length prof $3;
		 if rank in (1,2,3) then prof = "Yes";
		 	else if rank in (4,5) then prof = "No";

		output dall;

		if prof = "Yes" then output dprof;
			else if prof = "No" then output dnprof;

run;

options fmtsearch = (sasuser.jinjin);

proc freq
	data = dall;
	table rank;
	format rank rankfmt.;
run;

proc gchar
	data = dall;
	hbar compens;
run;

quit;

data d1;
	set sasuser.fss100;
	array item(*) item1-item33;
	do i =1 to dim(item);
		if item(i) > 5 then call missing(item(i));
	end;
	drop i;

	instruct = item18 + item19 + item22 + item24 + item28;
	compens = item13 + item15 + item27 + item29 + item30;

run;

proc format library=sasuser.jinjin;
	value $sfmt 1='M'
				2='F'
	;
run;

options fmtsearch = (sasuser.jinjin);

ods rtf file = ".\fss100.rtf";

proc tabulate
	data = d1;
	class rank gender;
	var instruct;
	table instruct*(n*f = 5.0 mean*f = 5.1 std*f = 5.2), (rank all)*(gender all);
	table instruct*(n*f = 5.0 mean*f = 5.1 std*f = 5.2), (rank)*(gender);
	table (rank all)*(gender all), instruct*(n*f = 5.0 mean*f = 5.1 std*f = 5.2);
	table (rank all)*(gender all), instruct*(n*f = 5.0 mean*f = 5.1 std*f = 5.2 colpctsum*f =5.2);

	format rank rankfmt. sex $sfmt.;
run;

proc corr
	data = d1;
	var compens instruct;
run;

ods rtf close;

proc gplot
	data = d1;
	plot compens*instruct;
	plot compens*instruct = gender;
	format gender $sfmt.;
run;

quit;
