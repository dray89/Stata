/*==================================================================
==========
 
 Econ 644
 
Class 5 & 6 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 5*/

clear all 
log using class5.log, replace
set more off 

import excel ceos.xls, sheet("Sheet1") firstrow
export excel using ceosexport.xls, firstrow(variables) replace
clear

/*Comma-Separated Files*/ 
import delimited ceos.csv
export delimited using ceos.csv, replace
clear

/*Space-Separated Files*/
import delimited CEOsSpace.txt, delimiter(space)
export delimited using ceosspace.txt, delimiter(" ") replace
clear

/*Tab-Separated Files*/
import delimited ceostab.txt, delimiter(tab)
export delimited ceostab.txt, delimiter(tab) replace
clear

/*Fixed Format Files (no dictionary) */

infix str name 1-18 str gender 19-29 salary 30-40 age 41-51 using ceos.raw
outfile using ceos.raw, noquote replace wide rjs
/*no quotes, one line however wide, right justified*/
clear

/*Fixed Format Files with a dictionary*/
infix using CEOs.dct, using(CEOs.raw)
clear

/*SAS XPORT Files*/
import sasxport ceos.xpt
export sasxport ceos.xpt, rename replace
clear

pwd

cd "/Users/mafton/Documents/School/Econ 644/nonstatafiles"

pwd

cd "/Users/mafton/Documents/School/Econ 644"

log close

/*Class 6*/
clear all 
log using class6.log, replace
set more off 
use ceos.dta
regress salary ceoten age grad mktval
/* How does the effect of CEO tenure compare to 0*/
test ( ceoten==0)
/*Note: F (1,n  k  1)  t 2 ; 3.07 = 1.752. nk1
Note: p-value > 0.05, can’t reject H0, it’s possible the effect is zero.*/

/*How does the effect of CEO tenure compare to 20?*/
test ( ceoten==20)
/*Note: p-value > 0.05, can’t reject H0, it’s possible the effect is 20.*/

/* NEED DATA FILES
regress lwage jc univ exper

test (jc = 0)

test (univ = 0)

test (jc = univ)

/*Test for Joint Significance in STATA Hypothesis Type 3*/

regress lsalary years gamesyr bavg hrunsyr rbisyr
test (bavg hrunsyr rbisyr)
corr bavg hrunsyr rbisyr

/*hrunsyr and rbisyr are highly correlated so their standard errors are too high
which is why they are jointly significant but not individually significant.*/

/*Test for model significance in stata*/
regress return dkr eps netinc salary

/*Test for Multiple LCs in Stata*/
regress lprice lassess llotsize lsqrft bdrms

test (lassess-1=llotsize=lsqrft=bdrms=0)
*/
