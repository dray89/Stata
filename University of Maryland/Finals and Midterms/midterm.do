/*Midterm Exam - Debra Ray */
clear all 
set more off 
log using midterm.log, replace
use "C:\Users\dray\Downloads\saversdata.dta"
sum lsavings
sum lsavings if elig==0 & year == 2001
sum lsavings if elig==1 & year == 2001
sum lsavings if elig==0 & year == 2006
sum lsavings if elig==1 & year == 2006

regress lsavings i.elig##i.year if year==2001 | year==2006

sort elig year
bysort elig: gen lsavings1 = lsavings[_n] - lsavings[_n-1]
regress lsavings1 i.elig i.year i.elig##i.year, vce(cluster elig) 

use "C:\Users\dray\Downloads\IVdata.dta", clear

regress y x 
estimates store ols_1
ivregress 2sls y (x = z) 
estimates store iv

regress x z 
test z 

hausman ols_1 iv


