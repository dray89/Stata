**** Define models to test
global dep = "lvio"
global id = "stateid"
local replace "replace"

local model1 = "shall"
local model2 = "shall incarc_rate density avginc pop"
local model5 = "shall incarc_rate"
local model6 = "shall incarc_rate pb1064 pw1064 pm1029 pop avginc density"
local model7 = "shall incarc_rate pop pb1064 pw1064 pm1029"
local model8 = "shall incarc_rate avginc pop pb1064 pw1064 pm1029"
local model9 = "shall incarc_rate avginc density pop pb1064 pw1064 pm1029"
local model10 = "shall incarc_rate pb1064 pw1064 pm1029"
local model11 = "shall incarc_rate pw1064 pm1029"
local model12 = "shall incarc_rate pm1029"

forval mod = 1/12 {
            cap drop fe*
            xtreg ${dep} `model`mod'', fe
            estimates store fe_`mod'
			regsave using "balanced_panel_res.csv", addlabel(fe`mod') `replace'
            predict fe`mod', resid
            stderr fe`mod'
            local replace "append"

             }
  
forval mod = 1/12 {
            cap drop fe*_cl
            xtreg ${dep} `model`mod'', fe vce(cluster stateid)
            estimates store fe_`mod'_cl
			regsave using "balanced_panel_res.csv", addlabel(fe`mod'_cl) append
            predict fe`mod'_cl, resid
            stderr fe`mod'_cl

             }
  

forval mod = 1/12 {
            cap drop re*
            xtreg ${dep} `model`mod'', re
            estimates store re_`mod'
			regsave using "balanced_panel_res.csv", addlabel(re`mod') append
            predict re`mod', stdp
            stderr re`mod'
            local replace "append"

             }
  
  forval mod = 1/12 {
            cap drop be*
            xtreg ${dep} `model`mod'', be
            estimates store be_`mod'
			regsave using "balanced_panel_res.csv", addlabel(be`mod') append
            predict be`mod', stdp
            stderr be`mod'
            local replace "append"

             }
  
    forval mod = 1/12 {
            cap drop mle*
            xtreg ${dep} `model`mod'', mle
            estimates store mle_`mod'
			regsave using "balanced_panel_res.csv", addlabel(mle`mod') append
            predict mle`mod', stdp
            stderr mle`mod'
            local replace "append"

             }
  
  
    forval mod = 1/12 {
            cap drop pa*
            xtreg ${dep} `model`mod'', pa
            estimates store pa_`mod'
			regsave using "balanced_panel_res.csv", addlabel(pa`mod') append
            predict pa`mod', stdp
            stderr pa`mod'
           

             }
  
  