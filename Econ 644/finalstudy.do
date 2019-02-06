clear all
set more off 
global data "/Users/mafton/Documents/Empirical Analysis II 2018/Homework"
global output "/Users/mafton/Documents/Empirical Analysis II 2018"
log using "$output/Final output.log", replace
use "$data/SMOKE.dta", clear
reg cigs lcigpric lincome educ age agesq restaurn white
di 2*_b[age] + 2*_b[agesq]
gen educsq = educ^2
reg cigs lcigpric lincome educ educsq age agesq restaurn white
di abs(_b[educ]/(2*_b[educsq]))
gen college = (educ>12 & educ<=17)
gen postgrad = (educ>17)
reg cigs lcigpric lincome college postgrad age agesq restaurn white
reg cigs lcigpric lincome college postgrad age agesq restaurn white, robust
predict uhat, resid
gen uhatsq = uhat^2
regress uhatsq lcigpric lincome college postgrad age agesq restaurn white
scalar LM = e(R2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM) 
disp "BP Test: LM = " LM ", p-value = " pvalue
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM) 
disp "BP Test: LM = " LM ", p-value = " pvalue
reg cigs lcigpric lincome college postgrad age agesq restaurn white
estat hettest
estat hettest, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid
reg cigs lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid
replace educ=14 if educ==13.5
gen smoke = (cigs>0)
reg smoke lcigpric lincome educ age agesq restaurn white
di _b[_cons] + 4*_b[lcigpric] + 10*_b[lincome] + 10*_b[educ] + 40*_b[age] + 40^2*_b[agesq] + _b[restaurn] + _b[white]
logit smoke lcigpric lincome educ age agesq i.restaurn i.white
logistic smoke lcigpric lincome educ age agesq i.restaurn i.white 
predict fitted, xb
gen logit_pr = invlogit(fitted)
tabstat logit_pr, by(restaurn) stat(mean) 
margins restaurn
probit smoke lcigpric lincome educ age agesq i.restaurn i.white
tab educ 
margins, at(educ= (6 8 10 12 14 15 16 18)) atmeans
probit smoke lcigpric lincome i.educ age agesq i.restaurn i.white 
margins educ, atmeans
log close
