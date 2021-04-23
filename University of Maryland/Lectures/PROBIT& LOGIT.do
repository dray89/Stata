* Marquise McGraw
* ECON 645
* Logit and Probit Modeling Exercise
* SOLUTION


cap log close
cd "C:\Users\Marquise McGraw\Dropbox\Econ 645\Fall 2018\Lecture Notes\2. Logit, Probit and Tobit\101818 make-up class"

log using ecls_lab_class.log, replace

use ecls_lab_class.dta, clear

 // q1
 
codebook

// q2

global tablecovars race_white race_black race_hispanic race_asian ///
	p5numpla p5hmage p5hdage rcdadcoll rcmomcoll w3povrty w3momscr w3dadscr ///
	rcinclvl1 rcinclvl2 rcinclvl3 p5fstamp

fsum $tablecovars , stats(n mean sd)
bysort catholic: fsum $tablecovars, stats(n mean sd)

// rmcovars - race model covariates for regressions
global rmcovars  race_black race_hispanic race_asian

// fmcovars - full model covariates for regressions 
global fmcovars race_black race_hispanic race_asian ///
	p5numpla p5hmage p5hdage rcdadcoll rcmomcoll  w3povrty w3momscr w3dadscr ///
	rcinclvl2 rcinclvl3 p5fstamp

// q3

logit catholic $rmcovars, robust
estimates store logit1

logit catholic $fmcovars, robust
estimates store logit2	

estat classification

// q4

qui logit catholic $rmcovars, robust
margins, dydx(*) post
estimates store mfxlogit1

qui logit catholic $fmcovars, robust
margins, dydx(*) post
estimates store mfxlogit2	

// q5

regress catholic $rmcovars, robust
estimates store lpm1	

regress catholic $fmcovars, robust
estimates store lpm2

// q3-q5 models in one table
esttab logit1 logit2 mfxlogit1 mfxlogit2 lpm1 lpm2, ///
  star se stats(N ll r2_p r2_a)  replace // b(%7.3f) stfmt(%8.2f)
	
log close
