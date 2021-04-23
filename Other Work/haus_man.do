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
