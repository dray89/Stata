cap log close
log using "PID_clusters.log", replace
load

*********** Set Global Variables

global depvar = "ins"
global indvar1 = "military age child"
global indvar2 = "i.race"
global indvar3 = "employed"
global indvar4 = "wage"

global model1 = "${indvar1} ${indvar2} ${indvar3} ${indvar4}"
global model2 = "${indvar1} ${indvar2} ${indvar3}"
global model3 = "${indvar1} ${indvar2} ${indvar4}"
global model4 = "${indvar1} ${indvar2}"
global model5 = "${indvar1} ${indvar2} ${indvar3} i.wage_gr4 "

**** restricting to cooksd creates collinearity
global cooksd = "if cooksd < 4/_N"

**** weight option

global option = ", vce(cluster DUPERSID)"
********************************************************************************
* LOGIT MODEL 1: EMPLOYED AND WAGE INCLUDED IN REGRESSION
********************************************************************************
sort ${depvar}
cap drop logit_uhat* logit_yhat*

logit ${depvar} ${model1} ${option}

***********
* Store estimates and predict fitted and errors
***********

estimates store logit1
predict logit_yhat1, pr 
predict logit_uhat1, stdp 

hist logit_uhat1
graph export "logit1_hist.png", replace

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit1.pdf, replace

**** mean standard error increased upon restricting regression based on cooksd
**** 1 failure and 4650 successes completely determined when outliers are removed --

********************************************************************************
* LOGIT MODEL 2: WAGE EXCLUDED IN REGRESSION
********************************************************************************

logit ${depvar} ${model2} ${option}

***********
* Store estimates and predict fitted and errors
***********

estimates store logit2
predict logit_yhat2, pr 
predict logit_uhat2, stdp 

hist logit_uhat2
graph export "logit2.png", replace

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit2.pdf, replace

********************************************************************************
* LOGIT MODEL 3: EMPLOYED EXCLUDED IN REGRESSION
********************************************************************************

logit ${depvar} ${model3} ${option}

margins, dydx(*) 

***********
* Store estimates and predict fitted and errors
***********

estimates store logit3
predict logit_yhat3, pr 
predict logit_uhat3, stdp 

hist logit_uhat3
graph export "logit3.png", replace

***********
* correct identifications: low number of correctly identified failures. 
***********

********************************************************************************
* LOGIT MODEL 4: EMPLOYED AND WAGE EXCLUDED IN REGRESSION
********************************************************************************

logit ${depvar} ${model4} ${option}

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit4.pdf, replace

***********
* Store estimates and predict fitted and errors
***********

estimates store logit4
predict logit_yhat4, pr 
predict logit_uhat4, stdp 

hist logit_uhat4
graph export "logit4.png", replace

***********
* correct identifications: low number of correctly identified failures. 
***********

***mse smaller without weighting
** mean standard error smaller without clustered standard errors

********************************************************************************
* LOGIT MODEL 5: Interaction between age and employed included
********************************************************************************

logit ${depvar} ${model5} ${option}
***********
* Store estimates and predict fitted and errors
***********

estimates store logit5
predict logit_yhat5, pr 
predict logit_uhat5, stdp
 
margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_logit5.pdf, replace

hist logit_uhat5
graph export "logit5.png", replace

*** 88.29% correctly classified

*** Do not reject model
capture {
	estat classification
	estat gof 
	estat gof, group(10)
	estat gof, group(10) table
if _rc != 0 {
	else di "Caught an Error!"
}
}

return list
ereturn list 

twoway scatter logit_yhat5 ${depvar} ${indvar1}, connect(l i) msymbol(i O) sort ylabel(0 1)

********************************************************************************
* PROGIT MODEL 1: ALL VARIABLES
********************************************************************************

probit ${depvar} ${indvar1} ${indvar2} ${indvar3}  ${indvar4} ${option} 

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


capture {
	estat classification
	estat gof 
	estat gof, group(10)
	estat gof, group(10) table
if _rc != 0 {
	else di "Caught an Error!"
}
}


hist progit_uhat

estimates table logit1 logit2 logit3 logit4 logit5 probit1, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
 
*** logit fitted values have the same mean as actual
*** probit fitted has larger mean than actual
sum progit_yhat ${depvar}

**logit more highly correlated - both around 30%

********************************************************************************
* Run Error Analysis
********************************************************************************
corr ${depvar} progit_yhat
sum progit_yhat ${depvar}

forval x = 1/5 {
corr ${depvar} logit_yhat`x'
sum logit_yhat`x' ${depvar}
}

forval x = 1/5 {
	
noisily	stderr logit_uhat`x'
	
}
stderr progit_uhat
*** probit mse smaller than logit
lmtest progit_uhat  ${indvar1}   ${indvar2}  ${indvar3}  ${indvar4}

forval x = 1/5 {

lmtest logit_uhat`x' ${model`x'}

}

***********
* correct identifications: low number of correctly identified failures. 
***********

forval x = 1/5 {
noisily di " "
noisily di "MODEL `x' : ${depvar} ${model`x'}"
noisily di " "

count if logit_yhat`x' > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Correct Success Prediction Rate: " x/y

noisily di "  "

count if logit_yhat`x'<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
noisily di "Correct Failure Prediction Rate: " x/y

noisily di " "
count if logit_yhat`x' > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Incorrect Success Prediction Rate: " float(x/y)

noisily di " "
count if logit_yhat`x'<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
noisily di "Incorrect Failure Prediction Rate: " x/y
}
***********
* correct identifications: low number of correctly identified failures. 
***********
forval a = 1/1 {
noisily di " "
noisily di "MODEL Progit : ${depvar} ${model1}"
noisily di " "

count if progit_yhat > .5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Correct Success Prediction Rate: " x/y

noisily di "  "

count if progit_yhat<.5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
noisily di "Correct Failure Prediction Rate: " x/y

noisily di "  "

count if progit_yhat > .5 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Incorrect Success Prediction Rate: " float(x/y)

noisily di "  "

count if progit_yhat<.5 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
noisily di "Incorrect Failure Prediction Rate: " x/y
noisily di "  "
}

forval x = 1/5 {
scatter ins logit_uhat`x'
graph export "scatter`x'.png"
}

forval x = 1/5 {
graph bar logit_uhat`x' , over(ins)
graph export "bar`x'.png", replace
}