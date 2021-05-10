#delimit;
set more off;
clear;
cap log close;

/* October 4, 2018 -- Solutions to Stata portion of midterm exam */

cd "/Users/shanthi/Desktop";
log using "midtermsolutions.txt", text replace;

use saversdata, clear;

/* Find the mean log savings in 2001 and 2006 */
/* There are many ways of solving this problem -- 
I am using the table command */
table elig year if year == 2001 | year == 2006, c(mean lsavings);

/* Estiamte a diff-in-diff model */
gen post_ind = .
replace post_ind = 1 if (year == 2006)
replace post_ind = 0 if (year == 2001)

gen post_elig = post_ind*elig

reg lsavings post_elig post_ind elig

/* Alternatively you can run with interactions */
reg lsavings i.post_ind##i.elig;

/* Run with all years */
reg lsavings i.year##i.elig;


use IVdata, clear;

reg y x;
estimates store ols_reg;
ivregress 2sls y (x=z);
estimates store iv_reg;

/* Weak Instrument test */
reg x z;
test z;

/* Alteratively */
ivreg2 y (x=z);

hausman iv_reg ols_reg;


cap log close;
