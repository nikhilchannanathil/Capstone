/*************************************************************************************/
/* SAS program is to perform Statistical Test on WHO dataset                        */
/*************************************************************************************/
/* Import the CSV file from the path /folders/myfolders/TOTENV.csv*/
FILENAME REFFILE '/folders/myfolders/TOTENV.csv';

PROC IMPORT DATAFILE=REFFILE DBMS=CSV    /*Type of the input file*/
	OUT=WORK.CSV1;
	/* Name of the new table to import the data*/
	GETNAMES=YES;
RUN;

/*Perfrom descriptive statistics mean on the data set*/
PROC MEANS DATA=WORK.CSV1;
	/* Cleanse and format the input raw data and write the data in to SAS dataset*/
DATA WORK.SAS;
	SET WORK.CSV1;

	/*Create SAS dataset*/
	KEEP Flag count cause;

	/* Copy only these varaibles in to the SAS dataset*/
	/* Cleanse and manipulate data , create Flag to differentiate child and adult records*/
	IF All_age_groups > 0 THEN
		DO Flag='Adult';
			count=All_age_groups - _0_4_years_Total;
		END;
	ELSE
		DO;
			Flag='Adult';
			count=0;
		END;
	OUTPUT;

	IF _0_4_years_Total  >=0 THEN
		DO Flag='Child';
			count=_0_4_years_Total;
		END;
	OUTPUT;
RUN;

/* Perform two-sample T-test, in this test null hypothesis is that is no significant difference
in the mean value of mortality rate between child and adults so HO=0. This test is run at of
significance level of 0.05, ALPHA=.05*/
PROC TTEST DATA=WORK.SAS HO=0 SIDES=2 ALPHA=.05;
	CLASS Flag;
	VAR Count;
RUN;