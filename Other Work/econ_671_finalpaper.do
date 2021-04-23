
load

********************************************************************************
* run logit regression with pweight = WGTSP13
********************************************************************************
sort ${depvar}
cap drop logit_uhat logit_yhat

svyset DUID [pweight= WGTSP13], strata(PID)
svy: logit ${depvar} ${indvar1} ${indvar2}

***********
* Store estimates and predict fitted and errors
***********
cap drop logit_yhat logit_uhat
estimates store logit5
predict logit_yhat, pr 
predict logit_uhat, stdp 

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit1.pdf, replace

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if logit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}
************* run error tests

stderr logit_uhat
lmtest logit_uhat ${indvar1}   ${indvar2}

**** mean standard error increased upon restricting regression based on cooksd
**** 1 failure and 4650 successes completely determined when outliers are removed --

svyset DUID, strata(PID) vce(jackknife)
svy: logit ${depvar} ${indvar1}  ${indvar2}

***********
* Store estimates and predict fitted and errors
***********
cap drop logit_yhat logit_uhat
estimates store logit4
predict logit_yhat, pr 
predict logit_uhat, stdp 

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit2.pdf, replace

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if logit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}
svyset DUID, strata(PID)
svy: logit ${depvar} ${indvar1}    if cooksd < 4/_N
margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit3.pdf, replace

***********
* Store estimates and predict fitted and errors
***********

cap drop logit_yhat logit_uhat
estimates store logit3
predict logit_yhat, pr 
predict logit_uhat, stdp 

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if logit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}

*** run error tests

stderr logit_uhat
lmtest logit_uhat ${indvar1}   ${indvar2}

** mean standard error smaller without clustered standard errors
cap drop logit_uhat logit_yhat

logit ${depvar} ${indvar1}  ${indvar2}
graph export marginsplot_logit4.pdf, replace

***********
* Store estimates and predict fitted and errors
***********
cap drop logit_yhat logit_uhat
estimates store logit2
predict logit_yhat, pr 
predict logit_uhat, stdp 

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if logit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}

*** run error tests
stderr logit_uhat
lmtest logit_uhat ${indvar1} ${indvar2}

***mse smaller without weighting
** mean standard error smaller without clustered standard errors
svyset DUID [pweight= WGTSP13], strata(PID) singleunit(centered)
svy: logit ${depvar} ${indvar1} ${indvar2}
graph export marginsplot_logit5.pdf, replace
***********
* Store estimates and predict fitted and errors
***********
cap drop logit_yhat logit_uhat
estimates store logit1
predict logit_yhat, pr 
predict logit_uhat, stdp 

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if logit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}

*** 88.29% correctly classified
estat classification
*** Do not reject model
estat gof 
estat gof, group(10)
estat gof, group(10) table

*** run error tests
stderr logit_uhat
lmtest logit_uhat ${indvar1} ${indvar2}  

return list
ereturn list 

twoway scatter logit_yhat ${depvar} ${indvar1}, connect(l i) msymbol(i O) sort ylabel(0 1)
svyset DUID [pweight= WGTSP13], strata(PID) vce(bootstrap)
svy: probit ${depvar} ${indvar1} ${indvar2}

***********
* Store estimates and predict fitted and errors
***********
estimates store probit1
cap drop progit_yhat progit_uhat
predict progit_yhat, pr 
predict progit_uhat, stdp

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_progit1.pdf, replace

***********
* correct identifications: low number of correctly identified failures. 
***********
noisily {
di e(cmdline) 
count if progit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if progit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y

count if logit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
di x/y

count if logit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
di x/y
}
*** 88.24% correctly classified
estat classification
*** Do not reject model
estat gof 
estat gof, group(10)
estat gof, group(10) table

hist progit_uhat

*** run error tests
*** probit mse smaller than logit
stderr progit_uhat
lmtest progit_uhat  ${indvar1}   ${indvar2}

estimates table logit1 logit2 logit3 logit4 logit5 probit1, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
 
*** logit fitted values have the same mean as actual
*** probit fitted has larger mean than actual
sum progit_yhat ${depvar}
sum logit_yhat ${depvar}

**logit more highly correlated - both around 30%
corr ${depvar} logit_yhat
corr ${depvar} progit_yhat

