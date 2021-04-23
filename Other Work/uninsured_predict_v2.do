cap log close
log using "uninsured_wage_gr4-1.log", replace
load

use "C:\Users\rayde\Downloads\h196dat\cleaned_data.dta", clear

*********** Set Global Variables

global depvar = "unin"
global indvar1 = "age child military" 
global indvar2 = "i.race"
global indvar3 = "employed"
global indvar4 = "i.wage_gr4"

global model1 = "${indvar1} ${indvar2} ${indvar3} ${indvar4}"
global model2 = "${indvar1} ${indvar2} ${indvar3}"
global model3 = "${indvar1} ${indvar2} ${indvar4}"
global model4 = "${indvar1} ${indvar2}"
global model5 = "${indvar1} ${indvar2} ${indvar3} ${indvar4} "

global cooksd = "if cooksd < 4/_N"

**** weight option

global option = "[pweight=WGTRU13], vce(cluster DUID)"

********************************************************************************
* Probit MODEL 1: EMPLOYED AND WAGE INCLUDED IN REGRESSION
********************************************************************************
sort ${depvar}
cap drop probit_uhat* probit_yhat*

probit ${depvar} ${model1} ${option}

***********
* Store estimates and predict fitted and errors
***********

estimates store probit1
predict probit_yhat1, pr 
predict probit_uhat1, stdp 

hist probit_uhat1
graph export "probit1_hist.png", replace

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_probit1.pdf, replace

**** mean standard error increased upon restricting regression based on cooksd
**** 1 failure and 4650 successes completely determined when outliers are removed --

********************************************************************************
* probit MODEL 2: WAGE EXCLUDED IN REGRESSION
********************************************************************************

probit ${depvar} ${model2} ${option}

***********
* Store estimates and predict fitted and errors
***********

estimates store probit2
predict probit_yhat2, pr 
predict probit_uhat2, stdp 

hist probit_uhat2
graph export "probit2.png", replace

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_probit2.pdf, replace

********************************************************************************
* probit MODEL 3: EMPLOYED EXCLUDED IN REGRESSION
********************************************************************************

probit ${depvar} ${model3} ${option}

margins, dydx(*) 

***********
* Store estimates and predict fitted and errors
***********

estimates store probit3
predict probit_yhat3, pr 
predict probit_uhat3, stdp 

hist probit_uhat3
graph export "probit3.png", replace

***********
* correct identifications: low number of correctly identified failures. 
***********

********************************************************************************
* probit MODEL 4: EMPLOYED AND WAGE EXCLUDED IN REGRESSION
********************************************************************************

probit ${depvar} ${model4} ${option}

margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_probit4.pdf, replace

***********
* Store estimates and predict fitted and errors
***********

estimates store probit4
predict probit_yhat4, pr 
predict probit_uhat4, stdp 

hist probit_uhat4
graph export "probit4.png", replace

***********
* correct identifications: low number of correctly identified failures. 
***********

***mse smaller without weighting
** mean standard error smaller without clustered standard errors

********************************************************************************
* probit MODEL 5: Interaction between age and employed included
********************************************************************************

probit ${depvar} ${model5} ${option}

***********
* Store estimates and predict fitted and errors
***********

estimates store probit5
predict probit_yhat5, pr 
predict probit_uhat5, stdp
 
margins, dydx(*) atmeans
margins, dydx(*) 
marginsplot
graph export marginsplot_probit5.pdf, replace

hist probit_uhat5
graph export "probit5.png", replace

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

twoway scatter probit_yhat5 ${depvar} ${indvar1}, connect(l i) msymbol(i O) sort ylabel(0 1)

********************************************************************************
* LOGIT MODEL 1: ALL VARIABLES
********************************************************************************

logit ${depvar} ${indvar1} ${indvar2} ${indvar3}  ${indvar4} ${option} 

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

estimates table probit1 probit2 probit3 probit4 probit5 probit1, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
 
*** probit fitted values have the same mean as actual
*** probit fitted has larger mean than actual
sum progit_yhat ${depvar}

**probit more highly correlated - both around 30%

********************************************************************************
* Run Error Analysis
********************************************************************************
corr ${depvar} progit_yhat
sum progit_yhat ${depvar}

forval x = 1/5 {
corr ${depvar} probit_yhat`x'
sum probit_yhat`x' ${depvar}
}

forval x = 1/5 {
	
noisily	stderr probit_uhat`x'
	
}
stderr progit_uhat
*** probit mse smaller than probit
lmtest progit_uhat  ${indvar1}   ${indvar2}  ${indvar3}  ${indvar4}

forval x = 1/5 {

lmtest probit_uhat`x' ${model`x'}

}

***********
* correct identifications: low number of correctly identified failures. 
***********

forval x = 1/11 {
noisily di " "
noisily di "MODEL `x' : ${depvar} ${model`x'}"
noisily di " "

count if probit_yhat`x' > .95 & ${depvar}==1
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Correct Success Prediction Rate: " x/y

noisily di "  "

count if probit_yhat`x'<.05 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==0
scalar y = r(N)
noisily di "Correct Failure Prediction Rate: " x/y

noisily di " "
count if probit_yhat`x' > .95 & ${depvar}==0
scalar x = r(N)
count if ${depvar}==1
scalar y = r(N)
noisily di "Incorrect Success Prediction Rate: " float(x/y)

noisily di " "
count if probit_yhat`x'<.05 & ${depvar}==1
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
scatter ins probit_uhat`x'
graph export "scatter`x'.png"
}

forval x = 1/5 {
graph bar probit_uhat`x' , over(ins)
graph export "bar`x'.png", replace
}