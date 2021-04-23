#delimit;
clear all;
set more off;
cap log close;

cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\Lectures\Lecture3";
use lecture3_examples, clear;

/**************************/ 
/* EXAMPLE 1              */
/* FD Estimator when T =2 */
/**************************/ 

/* Keep two years of data */
keep if year == 1988 | year == 1982;

/* Run/Graph Cross-Section Regressions */
reg fatalityrate beertax if year == 1988;

graph twoway (scatter fatalityrate beertax if year == 1988) 
(lfit fatalityrate beertax if year == 1988), 
text(2.25 1.5 "fatalityrate_hat =  1.86 + 0.44*beertax");
graph export "beeertax_88.pdf", as(pdf) replace;

reg fatalityrate beertax if year == 1982;

graph twoway (scatter fatalityrate beertax if year == 1982) 
(lfit fatalityrate beertax if year == 1982), 
text(2.5 2 "fatalityrate_hat =  2.01 + 0.15*beertax");
graph export "beeertax_82.pdf", as(pdf) replace;


/* Now exploit the fact that we have two years of data */
/* Tell State we are working with panel data */
sort state year;
xtset state year;

/* Create First Difference Variables */
/* Alternative1 => use lag operator (L.) */
bysort state: gen chgbt_1 = beertax - L6.beertax;
bysort state: gen chgfr_1 = fatalityrate - L6.fatalityrate;

/* Alternative2 => take difference between this observation and one before it */
bysort state: gen chgbt_2 = beertax[_n] - beertax[_n-1];
bysort state: gen chgfr_2 = fatalityrate[_n] - fatalityrate[_n-1];

sort state year;

/* Note that these are the same */
sum chgbt_1 chgbt_2 chgfr_1 chgfr_2;

/* Use OLS to regress changes on changes */
reg chgfr_1 chgbt_1;

/* Account for possible heteroskedasticity */
reg chgfr_1 chgbt_1, robust;


/**************************/ 
/* EXAMPLE 2              */
/* FD Estimator when T >2 */
/**************************/ 

use lecture3_examples, clear;

/* Tell State we are working with panel data */
xtset state year;

/* Generate Year Dummies */
tab year, gen(y);

/* Create First Difference Variables */
bysort state: gen chgbt = beertax - L1.beertax;
bysort state: gen chgfr = fatalityrate - L1.fatalityrate;

sort state year;

reg chgfr chgbt y3 y4 y5 y6 y7;

/* Alternative for including year dummies */
reg chgfr chgbt i.year;

/* Account for possible heteroskedasticity and serial correlation */
reg chgfr chgbt, cluster(state) robust;
reg chgfr chgbt i.year, cluster(state) robust;

/****************/ 
/* EXAMPLE 3    */
/* FE Estimator */
/****************/

use lecture3_examples, clear;

/* Tell State we are working with panel data */
xtset state year;

/* Dummy regression include state specific fixed effects */
reg fatalityrate beertax i.state;

/* Alternative for including state fixed effects */
areg fatalityrate beertax, absorb(state);

/* Use xtreg command with fixed effects option */
/* Note: FE is NOT the default for the xtreg command */
xtreg fatalityrate beertax, fe;

/* Account for heterskadasticity/serial correlation with cluster-robust se's */
xtreg fatalityrate beertax, fe vce(cluster state);

/* Easy to include year dummies */
xtreg fatalityrate beertax i.year, fe vce(cluster state);

/* Generate means by state across time ("between equation") */
/* Egen is a new command => it creates a variable that is equal the mean of the variable in ( )*/
egen avgbeerall = mean(beertax);
sum avgbeerall beertax;

/* Using the bysort command with egen allows that mean to change by state */
bysort state: egen avgfr = mean(fatalityrate); 
bysort state: egen avgbt = mean(beertax); 

sum avgbt if state == 1;
sum avgbt if state == 4;

sort state year;


gen demeanfr = fatalityrate - avgfr;
gen demeanbt = beertax - avgbt;

/* FE estimator using demeaned variables */
reg demeanfr demeanbt, vce(cluster state);
xtreg fatalityrate beertax, fe vce(cluster state);



/****************/ 
/* EXAMPLE 4    */
/* RE Estimator */
/****************/
xtreg fatalityrate beertax, re;
xtreg fatalityrate beertax, re vce(cluster state);
xtreg fatalityrate beertax i.year, re vce(cluster state);




cap log close;




