#delimit;
clear all;
cap log close;
set more off;


cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\homeworks";
log using PS1Solutions.txt, text replace;

use fertility.dta, clear;

/* Explore the data */
sum agem1;       
sum weeksm1;	 	
gen noWork=(weeksm1==0);	 
tab noWork;
sum weeksm1 if noWork==0;	 
tab morekids;
tab samesex;

/* OLS Regression */
reg weeksm1 morekids;

/* OLS Regression, with controls */
reg weeksm1 morekids black hispan othrace age;	

/* Two Stage Least Squares */
/* First Stage */
reg morekids samesex black hispan othrace age;
predict x_hat, xb;

/* F-test */
test samesex;	

/* Second Stage*/
reg weeksm1 x_hat black hispan othrace age;	

/* Use ivregress to carry out 2sls */
ivregress 2sls weeksm1 black hispan othrace age (morekids=samesex);
		
log close;
