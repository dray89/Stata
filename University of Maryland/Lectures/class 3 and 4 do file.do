/*==================================================================
==========
 
 Econ 644
 
Class 3 & 4 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 3*/


clear all 
log using class3.log, replace
set more off

/*Opening Part of An Existing Dataset*/

use name salary using ceos.dta, clear

browse

/*Opening an existing dataset*/

use ceos.dta, clear

describe

summarize

/*list selected variables*/

list name gender salary

/*list a few observations*/

list in 1/5

/*List a few observations for selected variables*/

list name gender salary in 1/5

save ceoscopy.dta, replace

keep if gender == "F" 
save femaleceos.dta, replace

use ceos.dta, clear

/*Graphing the frequency distribution of a variable*/
histogram age, bin(35) frequency addlabel

/*Compute a 95% confidence interval*/
ci means age
ttest age ==54

log close 


/*Class4*/

log using class4.log, replace
clear all 
import excel ceos.xls, sheet("Sheet1") firstrow
clear

/*Comma-Separated Files*/ 
import delimited ceos.csv
clear

/*Space-Separated Files*/
import delimited CEOsSpace.txt, delimiter(space)
clear

/*Tab-Separated Files*/
import delimited ceostab.txt, delimiter(tab)

clear

/*Fixed Format Files (no dictionary) */

infix str name 1-18 str gender 19-29 salary 30-40 age 41-51 using ceos.raw
clear

/*Fixed Format Files with a dictionary*/

infix using CEOs.dct, using(CEOs.raw)

clear

/*SAS XPORT Files*/
import sasxport ceos.xpt

set segmentsize 100m 

query memory 

use ceos.dta, clear

correlate salary ceoten
correlate ceoten age college mktval

/*Estimate a SRM by OLS*/
regress salary ceoten 

twoway (scatter salary ceoten) (lfit salary ceoten) 

log close 


