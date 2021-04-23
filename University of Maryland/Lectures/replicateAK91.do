#delimit;
set more off;
clear;
cap log close;

/* September 6, 2018 -- IV class exercise based on Angrist and Krueger (1991) */

cd "/Users/shanthi/Desktop/teaching 645/Lecture Slides/Lecture 2/Stata Examples/Angrist Krueger Example";
log using "AKexample.txt", text replace;

/* Some data management commands */
/* 1:1 reflects that fact that each observation has a unique observation within the id variable */ 
use AKdata_merge11, clear;
merge 1:1 id using AKdata_merge21;
drop _merge;
save AKdata_merge1, replace;

use AKdata_merge12, clear;
merge 1:1 id using AKdata_merge22;
drop _merge;

append using "AKdata_merge1";


use AKdata, clear;
gen ageqsq= ageq^2;

tab qob, gen(q);
tab yob, gen(b);

/* Rename dummies to match YOB */
forvalues x = 1/10 {;
	local k = `x' + 29;
	rename b`x' b`k';
};


/* Two Stage Least Squares */
reg educ q1;
predict ed_hat, xb;
reg lwklwge ed_hat;

/* Alternatively */
reg educ q1;
scalar b1 = _b[q1];

reg lwklwge q1;
scalar b2 = _b[q1];

disp b2/b1;  

/* 
NOTE: for whatever reason showing this fraction not work during class (though it works on my home computer)
The point was just to show you the 2SLS is equal to the ratio of betas from regressing X on Z and Y on Z 
*/


/* Interact yob with qob */
forvalues q = 1/4 {;
	forvalues b = 30/39 {;
		gen q`q'b`b'= q`q'*b`b';
	};
};

/* ivregress command */
ivregress 2sls lwklwge (educ = q1);


/* Replicates Paper Table V */
/** Col 1 3 ***/
reg lwklwge educ b30-b38; 
reg lwklwge educ b30-b38 ageq ageqsq; 

/** Col 2 4 ***/
ivregress 2sls lwklwge b30-b38 (educ = q1b30-q1b39 q2b30-q2b39 q3b30-q3b39);
ivregress 2sls lwklwge b30-b38 ageq ageqsq (educ = q1b30-q1b39 q2b30-q2b39 q3b30-q3b39);

/* 
NOTE: rather than creating interactions you can type 
ivregress 2sls lwklwge b30-b38 (educ = i.qob#i.yob);
*/

/* Using ivreg2 */ 
ivreg2 lwklwge b30-b38 (educ = q1b30-q1b39 q2b30-q2b39 q3b30-q3b39);

/* Testing Over-identifying Restrictions */
/* Test statistic nR^2 ~ X(q) */
/* Calculate Test Statistic */
/* Note: there is no need to calculate this by hand as ivreg2 includes as output */
/* This is meant to be illustrative to show what you are testing */
ivreg2 lwklwge b30-b38 (educ = q1b30-q1b39 q2b30-q2b39 q3b30-q3b39);
predict rez, res;

/* Regress Residuals on all exogenous variables */
reg rez b30-b38 q1b30-q1b39 q2b30-q2b39 q3b30-q3b39;
scalar R2 = e(r2);   		/* save R^2 from regression */
scalar nob = e(N);   		/* Save number of observations from regression */
scalar Stest = nob*R2;  	/* create test statistic */
disp Stest;  				/* display test statistic */

/* First Stage F-Test for weak instruments */
/* Note: there is no need to calculate this by hand as ivreg2 includes as output */
/* This is meant to be illustrative to show what you are testing */

/* First stage regression */
reg educ q1b30-q1b39 q2b30-q2b39 q3b30-q3b39 b30-b38;

/* Test instruments are jointly = 0 */
test q1b30 q1b31 q1b32 q1b33 q1b34 q1b35 q1b36 q1b37 q1b38 q1b39
q2b30 q2b31 q2b32 q2b33 q2b34 q2b35 q2b36 q2b37 q2b38 q2b39 
q3b30 q3b31 q3b32 q3b33 q3b34 q3b35 q3b36 q3b37 q3b38 q3b39;


log close;







