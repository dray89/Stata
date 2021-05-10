clear all
set more off 

global data "/Users/mafton/Documents/Empirical Analysis II 2018/Homework"
global output "/Users/mafton/Documents/Empirical Analysis II 2018"

log using "$output/Final output.log", replace
use "$data/SMOKE.dta", clear

**** Generate Variables
gen educsq = educ^2
gen college = (educ>12 & educ<=17)
gen postgrad = (educ>17)

**** Compare with and without educsq
reg cigs lcigpric lincome educ age agesq restaurn white
reg cigs lcigpric lincome educ educsq age agesq restaurn white
di abs(_b[educ]/(2*_b[educsq]))

**** Compare robust and nonrobust standard errors
reg cigs lcigpric lincome college postgrad age agesq restaurn white
predict uhat, resid 
gen uhatsq = uhat^2

reg cigs lcigpric lincome college postgrad age agesq restaurn white, robust
predict uhat_rob, resid
gen uhat_robsq = uhat^2

**** LM Test for heteroskedasticity
regress uhatsq lcigpric lincome college postgrad age agesq restaurn white
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM) 
disp "BP Test: LM = " LM ", p-value = " pvalue

**** estat hettest for heteroskedasticity
reg cigs lcigpric lincome college postgrad age agesq restaurn white
estat hettest
estat hettest, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid

reg cigs lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid

*** Binary OLS Regression
replace educ=14 if educ==13.5
gen smoke = (cigs>0)
reg smoke lcigpric lincome educ age agesq restaurn white

**** Generate Fitted Values
gen fitted2 = _b[_cons] + lcigpric*_b[lcigpric] + lincome*_b[lincome] + educ*_b[educ] + age*_b[age] + agesq*_b[agesq] + restaurn*_b[restaurn] + white*_b[white]
predict fitted, xb 

**** Logit Regression: Restrict in range(0,1)
logit smoke lcigpric lincome educ age agesq i.restaurn i.white
logistic smoke lcigpric lincome educ age agesq i.restaurn i.white 
predict fitted, xb
gen logit_pr = invlogit(fitted)

tabstat logit_pr, by(restaurn) stat(mean) 
margins restaurn

**** Probit Regression: Restrict in range(0,1)
probit smoke lcigpric lincome educ age agesq i.restaurn i.white
tab educ 
margins, at(educ= (6 8 10 12 14 15 16 18)) atmeans
probit smoke lcigpric lincome i.educ age agesq i.restaurn i.white 
margins educ, atmeans

log close
