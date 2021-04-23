/*Debra Ray Sept 24 Discussion*/

clear all 
set more off 

log using discussion4.log, replace

use "C:\Users\dray\Downloads\fertility (1).dta"

/*Run 2SLS*/
ivreg2 weeksm1 black hispan othrace age (morekids=samesex)
/*Test for Endogeneity*/
ivendog 
/*OLS estimates not biased by endogeneity*/

/*Run regression with more kids and samesex*/
reg weeksm1 black hispan othrace age morekids 
/*Regress morekids on samesex*/
reg morekids samesex black hispan othrace age 
/*Run Ftest - valid instrument*/
test samesex
/*save residuals*/
predict uhat, resid 
/*Include residuals in regression*/
reg weeksm1 black hispan othrace age morekids uhat
/*residuals do not have a signifant effect on weeksm1 - so no endog bias */
ivreg2 weeksm1 black hispan othrace age (morekids=samesex)
reg weeksm1 black hispan othrace age morekids samesex
