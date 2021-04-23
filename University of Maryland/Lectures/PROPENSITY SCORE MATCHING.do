#delimit;
set more off;
clear;
cap log close;

/* October 25, 2018 -- Matching */

cd "/Users/shanthi/Desktop/teaching 645/Lecture Slides/Lecture 9";
log using "lecture9_example.txt", text replace;

use NSW_data, clear;


/* Randomly sort data to ensure matched control is randomly selected */
/* Set seed in order to replicate results */
set seed 123456;
gen u=uniform();
sort u;

/* Generate propensity score using probit regression */
probit d age agesq educ black married nodegree hisp re74 re75;
predict pscorea;


/* Show distribution of scores by treatment status to illustrate common support */
histogram pscorea, start(0.0) width(0.05) by(d, col(1));

/* Propensity Score Matching */
psmatch2 d, outcome(re78) pscore(pscorea) n(1) common;

/* Replicate first line of output */
reg re78 d;
bysort d: sum re78;

/* Just a t-test of difference in means */
ttest re78, by(d);

/* PSMATCH generates new variables */
desc;


/* Note some observations are used more than once */
tab _n1;

/* Replicate Second line of psmatch output */
reg re78 d if _weight~=. [aw=_weight], robust;

sort u;

/* Try 1-1 matching with no replacement */
psmatch2 d, outcome(re78) pscore(pscorea) n(1) common noreplacement;

/* match with 3 neighbors */
psmatch2 d, outcome(re78) pscore(pscorea) n(3) common;

/* match with 10 neighbors */
psmatch2 d, outcome(re78) pscore(pscorea) n(10) common;

/* Impose maximum distance */
psmatch2 d, outcome(re78) pscore(pscorea) n(1) common caliper(.002);
psmatch2 d, outcome(re78) pscore(pscorea) n(1) common caliper(.01);
psmatch2 d, outcome(re78) pscore(pscorea) n(1) common caliper(.02);

cap log close;
