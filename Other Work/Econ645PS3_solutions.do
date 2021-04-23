#delimit;
clear all;
cap log close;
set more off;


cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\homeworks\Homework3";
log using PS3Solutions.txt, text replace;

use corpus_christi.dta, clear;

/* Question 1 */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;

/* Question 2 */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust;

/* Question 3 */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;
predict accept_hat;
sum accept_hat, det;
count if accept_hat > 1 | accept_hat < 0;

/* Question 4 */
probit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;
logit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;

/* Question 5 */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;

probit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;
margins, dydx (age);

logit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15;
margins, dydx (age);


cap log close;
