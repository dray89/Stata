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

load_prog

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
local replace "replace"
forval mod = 1/5 {
            cap drop fe*
            xtreg ${dep} `model`mod'', fe
            estimates store fe_`mod'
			regsave using "panel_results.csv", addlabel(fe`mod') `replace'
            predict fe`mod', resid
            stderr fe`mod'
            local replace "append"

             }
			 
********************************************************************************
* Fixed Effects with Cluster Robust Standard Errors
********************************************************************************

forval mod = 1/5 {
            cap drop fe*_cl
            xtreg ${dep} `model`mod'', fe vce(cluster stateid)
            estimates store fe_`mod'_cl
			regsave using "panel_results.csv", addlabel(fe`mod'_cl) append
            predict fe`mod'_cl, resid
            stderr fe`mod'_cl

             }
  
********************************************************************************
* Random Effects
********************************************************************************

forval mod = 1/5 {
            cap drop re*
            xtreg ${dep} `model`mod'', re
            estimates store re_`mod'
			regsave using "panel_results.csv", addlabel(re`mod') append
            predict re`mod', stdp
            stderr re`mod'
            local replace "append"

             }
********************************************************************************
* Between Effects
********************************************************************************
  
  forval mod = 1/5 {
            cap drop be*
            xtreg ${dep} `model`mod'', be
            estimates store be_`mod'
			regsave using "panel_results.csv", addlabel(be`mod') append
            predict be`mod', stdp
            stderr be`mod'
            local replace "append"

             }
********************************************************************************
* ML Random Effects
********************************************************************************
  
    forval mod = 1/5 {
            cap drop mle*
            xtreg ${dep} `model`mod'', mle
            estimates store mle_`mod'
			regsave using "panel_results.csv", addlabel(mle`mod') append
            predict mle`mod', stdp
            stderr mle`mod'
            local replace "append"

             }
  
********************************************************************************
* Population Average Effects
********************************************************************************
  
    forval mod = 1/5 {
            cap drop pa*
            xtreg ${dep} `model`mod'', pa
            estimates store pa_`mod'
			regsave using "panel_results.csv", addlabel(pa`mod') append
            predict pa`mod', stdp
            stderr pa`mod'
           

             }
  
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
