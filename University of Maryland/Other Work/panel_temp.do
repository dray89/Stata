********************************************************************************
* Panel Data Template
* Fixed Effects: Within-Subject Estimation (Demeaned)
* Fixed Effects with Cluster Robust Standard Errors
* Between Effects: Between-Subject Estimation (Common Average)
* Random Effects: Matrix weighted average of BE and FE
* ML Random Effects: Maximizes the likelihood of the RE model
* Population Average Effects: Specifies a marginal error distribution
* Manual Hausman Test: https://www.stata.com/support/faqs/statistics/between-estimator/
********************************************************************************

cap log close 
log using filename.log, replace

**** Define ID & Time Variables

global id = " "
global time = " "
xtset ${id} ${time}

**** Define Dependent Variable
global dep = " "

**** Define models to test
local model1 = " "
local model2 = " "
local model3 = " "
local model4 = " "
local model5 = " "


********************************************************************************
* Fixed Effects 
********************************************************************************
forval mod = 1/5 {
            cap drop fe*
            eststo fe_`mod': xtreg ${dep} `model`mod'', fe
            predict fe`mod', resid
            stderr fe`mod'

             }
  
********************************************************************************
* Random Effects
********************************************************************************

forval mod = 1/5 {
            cap drop re*
            eststo re_`mod': xtreg ${dep} `model`mod'', re
            predict re`mod', stdp
            stderr re`mod'

             }
********************************************************************************
* Between Effects
********************************************************************************
  
  forval mod = 1/5 {
            cap drop be*
            eststo be_`mod': xtreg ${dep} `model`mod'', be
            predict be`mod', stdp
            stderr be`mod'


             }
********************************************************************************
* ML Random Effects
********************************************************************************
  
    forval mod = 1/5 {
            cap drop mle*
            eststo mle_`mod': xtreg ${dep} `model`mod'', mle
            predict mle`mod', stdp
            stderr mle`mod'

             }
  
********************************************************************************
* Population Average Effects
********************************************************************************
  
    forval mod = 1/5 {
            cap drop pa*
            eststo pa_`mod': xtreg ${dep} `model`mod'', pa
            predict pa`mod', stdp
            stderr pa`mod'
           

             }

local replace "replace"
forval mod = 1/10 {
	estimates table fe_`mod' re_`mod', stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)
	esttab fe_`mod' re_`mod' using guns.csv, `replace' scalars(r2_a r2_w r2_b r2_o F rmse chi2) mtitles(fe_`mod' fe_`mod'_cl re_`mod' ols_`mod')
	local replace "append"
	}

	
**** Residual Analysis
forval mod = 1/10 {

stderr fe`mod' fe`mod'_cl  re`mod' ols`mod'

matrix define stderr`mod' = (fe`mod', fe`mod'_cl,  re`mod' ,ols`mod' )

}

forval mod = 1/10 {

lmtest fe`mod' ${model`mod'}
lmtest fe`mod'_cl ${model`mod'}
lmtest re`mod' ${model`mod'}
lmtest ols`mod' ${model`mod'}

matrix define pvalues`mod' = (pfe`mod', pfe`mod'_cl, pre`mod', pols`mod')

}

matrix pvalues = pvalues1\pvalues2\pvalues3\pvalues4\pvalues5
matrix rownames pvalues = pvalues1 pvalues2 pvalues3 pvalues4 pvalues5
matrix colnames pvalues =  FE FE_Cluster RE OLS

putexcel set "output.csv", sheet(pvalues) modify
putexcel A1 = matrix(pvalues), names nformat(number_d2)

matrix stderr = stderr1\stderr2\stderr3\stderr4\stderr5
matrix rownames stderr = stderr1 stderr2 stderr3 stderr4 stderr5
matrix colnames stderr =  FE FE_Cluster RE OLS

putexcel set "output.csv", sheet(stderr) modify
putexcel A1 = matrix(stderr), names nformat(number_d2)

********************************************************************************
* Manual Hausman Test
* https://www.stata.com/support/faqs/statistics/between-estimator/
********************************************************************************

**** define regressors of interest
local x1 = 
local x2 = 

**** define subject identifier
local i = 

**** define within cross-section regressor of interest (xtreg, be)
egen avg`x1' = mean(`x1'), by(`i')
egen avg`x2' = mean(`x2'), by(`i')

**** define within subject regressor of interest (xtreg, fe)
gen delta`x1' = `x1' - avg`x1'
gen delta`x2' = `x2' - avg`x2'

xtreg `y' avg`x1' delta`x1' avg`x2' delta`x2', re

test avg`x1' = delta`x1'
test avg`x2' = delta`x2', accum
