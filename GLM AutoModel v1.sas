/**************************************************************/
/* Objective:  Build Auto Model for Deployment in 2018*/
/* Created By: KI */
/* Date		: October 20, 2017 */
/***********************************************************/

options obs=Max macrogen mprint;

libname sasdir "/sas/AutoModel";


/* Read Y and Xs. X variables are YOY change numbers*/
/* The final data load will have 80 variables including auto related, economic, legal, societal and health variables*/

proc import
data file="/sas/AutoModel/AutoData1.csv"
	out=sasdir.AutoData1
	dms=csv
	replace;
	getnames=yes

run;


proc print data =sasdir.AutoData1;
	title 'Auto Data 1 Imported-------------------------';
run;

/* Run Basic Statistics --------------------------------- */

proc freq data =sasdir.AutoData1;
	tables Year;
	title 'Data Freq Years ----------------------------';
run;


proc means data =sasdir.AutoData1;
	vars auto_IncurLoss CPI Man_Ship 
		US_Pop Vehicle_Reg Health_Cov;
	title 'Data Means Years ----------------------------';
run;
	

/* Check Plot of Data to see if linear or other types of relationship */

proc plot data =sasdir.AutoData1;
	plot auto_IncurLoss * (CPI Man_Ship 
		US_Pop Vehicle_Reg Health_Cov);
	title 'Data Plot ----------------------------';
run;


/* Check for mutlicollinearity */

proc corr data =sasdir.AutoData1;
	var CPI Man_Ship US_Pop Vehicle_Reg Health_Cov;
	title 'Check Collinearity----------------------------';
run;





/* Run GLM to identify variables needed */

ods graphics on;

proc glm data =sasdir.AutoData1;
	class Year;

	model auto_IncurLoss = CPI Man_Ship US_Pop Vehicle_Reg Health_Cov;
	title 'Running GLM ---------------------------';
run;

ods graphics off;

quit;

