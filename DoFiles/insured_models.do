
cap log close
log using insured_bootstrap.log, replace

load

use "C:\Users\rayde\Downloads\h196dat\cleaned_data.dta", clear



********************************************************************************
* Set Global Variables
********************************************************************************

global depvar = "ins"
global model1 = "AGE13X HRWAG13X ACTDTY13 RACETHX"
global model2 = "AGE13X HRWAG13X EMPST13 ACTDTY13 RACETHX"
global model3 = "AGE13X EMPST13 ACTDTY13 RACETHX"

**** weight option

global cooksd = "if cooksd < 4/_N"


********************************************************************************
* Bootstrap
********************************************************************************

bsample 3946, strata(unin)

set seed 12345

local list = "regress logit probit"

cap drop *_uhat* *_yhat*

foreach x in `list' {

bootstrap, rep(100) mse: `x' ${depvar} ${model1}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1

bootstrap, rep(100) mse: `x' ${depvar} ${model2}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2

bootstrap, rep(100) mse: `x' ${depvar} ${model3}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3
di "==========================================================================="
}

local list = "regress logit probit"

foreach x in `list' { 
di "============================================================================"
forval a = 1/3 {
	
	stderr `x'_uhat`a'
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
estimates table `x'_1 `x'_2 `x'_3, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
  
sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}

sum `x'_uhat1 `x'_uhat2 `x'_uhat3
}



local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "============================================================"
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "============================================================"

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

di "==========================================================================="

}
}
}


/********************************************************************************
* Controlling for Cooksd
********************************************************************************
================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .57260054
stderr of logit_uhat2 = 0
stderr of logit_uhat3 = 0

================================================================================
PROBIT MODELS
================================================================================


stderr of probit_uhat1 = .1767191
stderr of probit_uhat2 = 0
stderr of probit_uhat3 = 0

*/

local list = "regress logit probit"

cap drop *_uhat* *_yhat*
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${cooksd}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1

`x' ${depvar} ${model2} ${cooksd}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2

`x' ${depvar} ${model3} ${cooksd}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3
di "==========================================================================="
}
}

foreach x in `list' { 
di "============================================================================"
forval a = 1/3 {
	
	stderr `x'_uhat`a'
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
estimates table `x'_1 `x'_2 `x'_3, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
  
sum `x'_yhat1 `x'_yhat2 `x'_yhat3
sum `x'_uhat1 `x'_uhat2 `x'_uhat3

}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "============================================================"
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "============================================================"

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

di "==========================================================================="

}
}
}
/*
********************************************************************************
* Weighted, Clustered with household id
********************************************************************************
================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .0547337
stderr of logit_uhat2 = .06524617
stderr of logit_uhat3 = .07455453

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .02984593
stderr of probit_uhat2 = .03490243
stderr of probit_uhat3 = .03732292

*/

global option = "[pweight=WGTRU13], vce(cluster DUID)"

cap drop *_uhat* *_yhat*
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 

di "==========================================================================="
}
}

foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3 , ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 ${depvar}
}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* Weighted Only
********************************************************************************

/*================================================================================
LOGIT MODELS
================================================================================


stderr of logit_uhat1 = .04021344
stderr of logit_uhat2 = .05160224
stderr of logit_uhat3 = .0588799


================================================================================
PROBIT MODELS
================================================================================


stderr of probit_uhat1 = .02209404
stderr of probit_uhat2 = .02775641
stderr of probit_uhat3 = .029459

*/

cap drop *uhat* *_yhat*
global option = "[pweight=WGTRU13]"

local list = "regress logit probit"
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}
foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}
 
capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

local list = "regress logit probit"
foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 
	di "==========================================================================="
}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
di "==========================================================================="
}
}
}
********************************************************************************
* Clustered Only
********************************************************************************

/*================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .04395157
stderr of logit_uhat2 = .05260167
stderr of logit_uhat3 = .059298

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .02489857
stderr of probit_uhat2 = .02868179
stderr of probit_uhat3 = .03038581

*/


cap drop *_uhat* *_yhat*

global option = ", vce(cluster DUID)"

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}
foreach x in `list' { 
forval a = 1/3 {
	
	stderr `x'_uhat`a'
di "==========================================================================="	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}

}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* No Options
*********************************************************************
***********

/*================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .03024285
stderr of logit_uhat2 = .03762943
stderr of logit_uhat3 = .03845749

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .01663139
stderr of probit_uhat2 = .02079467
stderr of probit_uhat3 = .02040372

*/


cap drop *uhat* *_yhat*

global option = " "

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}

foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {

	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 
}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* Robust Only
********************************************************************************

/*
================================================================================
LOGIT MODELS
================================================================================


stderr of logit_uhat1 = .03194312
stderr of logit_uhat2 = .04098663
stderr of logit_uhat3 = .04618164


================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .0185566
stderr of probit_uhat2 = .02244737
stderr of probit_uhat3 = .02361756

*/


cap drop *_uhat* *_yhat*

global option = ", robust "

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}

foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {

estimates table `x'_1 `x'_2 `x'_3, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
  
sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}

sum `x'_uhat1 `x'_uhat2 `x'_uhat3
di "==========================================================================="
}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}


log close

log using insured.log, replace
use "C:\Users\rayde\Downloads\h196dat\cleaned_data.dta", clear
/*
********************************************************************************
* Controlling for Cooksd
********************************************************************************
================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .57260054
stderr of logit_uhat2 = 0
stderr of logit_uhat3 = 0

================================================================================
PROBIT MODELS
================================================================================


stderr of probit_uhat1 = .1767191
stderr of probit_uhat2 = 0
stderr of probit_uhat3 = 0

*/

local list = "regress logit probit"

cap drop *_uhat* *_yhat*
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${cooksd}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${cooksd}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${cooksd}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}

foreach x in `list' { 
di "============================================================================"
forval a = 1/3 {
	
	stderr `x'_uhat`a'
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
estimates table `x'_1 `x'_2 `x'_3, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
  
sum `x'_yhat1 `x'_yhat2 `x'_yhat3
sum `x'_uhat1 `x'_uhat2 `x'_uhat3

}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "============================================================"
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "============================================================"

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

di "==========================================================================="

}
}
}
/*
********************************************************************************
* Weighted, Clustered with household id
********************************************************************************
================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .0547337
stderr of logit_uhat2 = .06524617
stderr of logit_uhat3 = .07455453

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .02984593
stderr of probit_uhat2 = .03490243
stderr of probit_uhat3 = .03732292

*/

global option = "[pweight=WGTRU13], vce(cluster DUID)"

cap drop *_uhat* *_yhat*
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 

di "==========================================================================="
}
}

foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3 , ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 ${depvar}
}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* Weighted Only
********************************************************************************

/*================================================================================
LOGIT MODELS
================================================================================


stderr of logit_uhat1 = .04021344
stderr of logit_uhat2 = .05160224
stderr of logit_uhat3 = .0588799


================================================================================
PROBIT MODELS
================================================================================


stderr of probit_uhat1 = .02209404
stderr of probit_uhat2 = .02775641
stderr of probit_uhat3 = .029459

*/

cap drop *uhat* *_yhat*
global option = "[pweight=WGTRU13]"

local list = "regress logit probit"
qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}
foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}
 
capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

local list = "regress logit probit"
foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 
	di "==========================================================================="
}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
di "==========================================================================="
}
}
}
********************************************************************************
* Clustered Only
********************************************************************************

/*================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .04395157
stderr of logit_uhat2 = .05260167
stderr of logit_uhat3 = .059298

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .02489857
stderr of probit_uhat2 = .02868179
stderr of probit_uhat3 = .03038581

*/


cap drop *_uhat* *_yhat*

global option = ", vce(cluster DUID)"

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}
foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {
	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}

}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* No Options
*********************************************************************
***********

/*================================================================================
LOGIT MODELS
================================================================================

stderr of logit_uhat1 = .03024285
stderr of logit_uhat2 = .03762943
stderr of logit_uhat3 = .03845749

================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .01663139
stderr of probit_uhat2 = .02079467
stderr of probit_uhat3 = .02040372

*/


cap drop *uhat* *_yhat*

global option = " "

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}

foreach x in `list' { 
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {

	estimates table `x'_1 `x'_2 `x'_3, ///
	  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
	  
	sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}
	sum `x'_uhat1 `x'_uhat2 `x'_uhat3 
}
local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
********************************************************************************
* Robust Only
********************************************************************************

/*
================================================================================
LOGIT MODELS
================================================================================


stderr of logit_uhat1 = .03194312
stderr of logit_uhat2 = .04098663
stderr of logit_uhat3 = .04618164


================================================================================
PROBIT MODELS
================================================================================

stderr of probit_uhat1 = .0185566
stderr of probit_uhat2 = .02244737
stderr of probit_uhat3 = .02361756

*/


cap drop *_uhat* *_yhat*

global option = ", robust "

local list = "regress logit probit"

qui {
foreach x in `list' {

`x' ${depvar} ${model1} ${option}
estimates store `x'_1
predict `x'_uhat1, stdp
predict `x'_yhat1 

`x' ${depvar} ${model2} ${option}
estimates store `x'_2
predict `x'_uhat2, stdp
predict `x'_yhat2 

`x' ${depvar} ${model3} ${option}
estimates store `x'_3
predict `x'_uhat3, stdp
predict `x'_yhat3 
di "==========================================================================="
}
}

foreach x in `list' {
di "==========================================================================="

forval a = 1/3 {
	
	stderr `x'_uhat`a'
	
}
}

capture {
	noisily estat classification
	noisily estat gof 
	noisily estat gof, group(10)
	noisily estat gof, group(10) table
if _rc != 0 {
	di "Caught an Error!"
}
}

foreach x in `list' {

estimates table `x'_1 `x'_2 `x'_3, ///
  stats(N ll r2_p mrse) b(%7.3f) stfmt(%8.2f)
  
sum `x'_yhat1 `x'_yhat2 `x'_yhat3 ${depvar}

sum `x'_uhat1 `x'_uhat2 `x'_uhat3
di "==========================================================================="
}

local list = "regress logit probit"
qui {
forval y = 1/3 {
foreach x in `list' {
	
		estimates restore `x'_`y'
		
		noisily di "========================================================== "
		noisily di "Model `x'_`y' " e(cmdline)
		noisily di "==========================================================="

		count if `x'_yhat`y' > .5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Correct Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di "  "

		count if `x'_yhat`y'<.5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample) 
		scalar y = r(N)
		noisily di "Correct Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y

		noisily di " "
		count if `x'_yhat`y'> .5 & ${depvar}==0 & e(sample)
		scalar x = r(N)
		count if ${depvar}==1 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Success Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
		
		noisily di " "
		count if `x'_yhat`y'<.5 & ${depvar}==1 & e(sample)
		scalar x = r(N)
		count if ${depvar}==0 & e(sample)
		scalar y = r(N)
		noisily di "Incorrect Failure Prediction Rate: " x/y
		noisily di "predicted =" x ", Actual = " y
}
}
}
