********************************************************************************
* Panel Data
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
  
  