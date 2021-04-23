#delimit;
set more off;
clear;
cap log close;

/* October 25, 2018 -- Matching */

cd "/Users/shanthi/Desktop/teaching 645/Homeworks/Homework4/";
log using "ps4_soluions.txt", text replace;

/* PART I */
use minwage, clear;
tsset t;

/* Reg gwage232 on gmwage and gcpi */
reg gwage232 gmwage gcpi;

/* Reg gwage232 on gmwage, 12 lags of gmwage, and gcpi */
reg gwage232 gmwage L(1/12).gmwage gcpi;
test L1.gmwage L2.gmwage L3.gmwage L4.gmwage L5.gmwage L6.gmwage L7.gmwage L8.gmwage L9.gmwage L10.gmwage L11.gmwage L12.gmwage;

/* Reg gemp232 on gmwage and gcpi */
reg gemp232 gmwage gcpi;

/* Reg gemp232 on gmwage, 12 lags of gmwage, and gcpi */
reg gemp232 gmwage  L(1/12).gmwage gcpi; 


/* PART II */
use matching_earnings, clear;

reg REDIFF TREAT AGE EDUC MARR;

/* Randomly sort data to ensure matched control is randomly selected */
/* Set seed in order to replicate results */
set seed 123456;
gen u=uniform();
sort u;

/* Generate propensity score using probit regression */
probit TREAT AGE EDUC MARR;
predict pscorea;

/* Propensity Score Matching */
psmatch2 TREAT, outcome(RE78) pscore(pscorea) n(1) common;

/* How many unique controls were matched to the treated */
egen unique_match = group(_n1);
sum unique_match;

/* How many control subjects were matched more than once */
bysort _n1: gen count_match = _N if _n1~=.;
tab count_match;

sort u;

/* Propensity Score Matching with no replacement */
psmatch2 TREAT, outcome(RE78) pscore(pscorea) n(1) common noreplacement;

sort u;

/* Propensity Score Matching with no replacement */
psmatch2 TREAT, outcome(RE78) pscore(pscorea) n(2) common;


cap log close;
