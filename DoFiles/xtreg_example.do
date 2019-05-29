***************************************************
* Code Example of using xtreg in Stata and testing OLS Assumptions
* Working with unbalanced panel data 
* Forecasting loan default and early payoff
* Graphing Residuals
* Comparing specifications by tables and graphs
* Testing for autocorrelation
*****************************************************

cap log close
use "data.dta", clear

log using [logfile name].log, replace

********* 
* origin = loan origination year
* year = fiscal year
* group = loan type
*********

xtset origin year

*************************
* Generate dependent variables
* Default Rates and Early Payoff Rates
****************************

gen [dep_var]_a = ln(default)
gen [dep_var]_b = ln(earlypay)

**************************************************
**** Generate Independent Variables
**************************************************

gen farm_income_L1 = L1.farm_income

**** Interest Rate Spread
**** amt05 = weighted average interest rates on loans
**** amt04 = weighted average loan term
**** tbill3yr = 3yr Treasury Bill
**** tbill10yr = 10yr Treasury Bill

gen ln_tbill3yr_gr = ln(tbill3yr/L.tbill3yr)
gen ln_tbill10yr_gr = ln(tbill10yr/L.tbill10yr)

gen ln_tbill3yr = ln(tbill3yr)
gen ln_tbill10yr = ln(tbill10yr)

gen ln_amt05_gr = ln(amt05/L.amt05)

gen spread = (amt05-tbill3yr)/100 
replace spread = (amt05-tbill10yr)/100 if group == 1 | group == 2

gen gr_spread =  ln(amt05/tbill3yr)
replace gr_spread =  ln(amt05/tbill10yr) if group == 1 | group == 2 

gen ln_spread = ln(spread) 

gen interest_elas = ln_amt05_gr - ln_tbill3yr_gr
replace interest_elas = ln_amt05_gr - ln_tbill10yr_gr if group==1 | group==2 

gen termleft = cond(1-(age/amt04)>0, 1-(age/amt04),0)
gen termleft_ln = cond(termleft>0, ln(termleft),0)
gen termleft2 = termleft^2 

foreach x in spread gr_spread interest_elas ln_spread ln_tbill3yr_gr ln_tbill10yr_gr {
	gen `x'_neg = cond(`ind'<0, `x', 0)
	gen `x'_pos = cond(`ind'>0, `x', 0)
}

sum spread gr_spread ln_spread 

**************************************************************
**** Investigate Graphical Relationships
**************************************************************

foreach y in a b {
	foreach x in age termleft spread farm_income inflation gdp_index {

scatter [dep_var]_`y' `x' if age<25
graph export "scatter_`y'`x'.png", as(png) replace

}

graph bar (mean) [dep_var]_`y' if year<2019 , over(year, label(labsize(vsmall) angle(vertical)))
graph export "bar_year`y'.png", as(png) replace

graph bar (mean) [dep_var]_`y', over(age, label(labsize(small)))
graph export "bar_age`y'.png", as(png) replace

hist [dep_var]_`y'
}

********************************************************************************
**** Specifications
*******************************************************************************

**** Base Specification - defaults
global aestimate_1 "spread age age2 inflation"
**** spread between treasury bills and weighted average loan rate not a predictor
**** of consumer defaults

**** Alternative Specifications - defaults
global aestimate_2 "age age2 ln_tbill10yr farm_income farm_income_L1"
global aestimate_3 "termleft_ln farm_income farm_income_L1"
global aestimate_4 "termleft termleft2 tbill10yr farm_income farm_income_L1"

**** Base specification - Early Payoffs
global bestimate_1 "age spread rfarminc_gr rfarminc_grL1"

**** spread between treasury bills and weighted average loan rates are a predictor of
**** consumer early payoffs

**** Alternative Specifications - Early Payoffs
global bestimate_2 "age age2 spread farm_income farm_income_L1"
global bestimate_3 "termleft_ln ln_tbill10yr_gr_neg ln_tbill10yr_gr"
global bestimate_4 "termleft termleft2 spread farm_income"

xtreg [dep_var]_a termleft_ln, vce(cluster origin) fe 
xtreg [dep_var]_b interest_elas, vce(cluster origin) fe 

********************************************************************************
****  Regress using xtreg 
********************************************************************************
		
											
foreach y in a b {	
   forval z = 1/4 {
	  cap drop fitted`y'`z' residual`y'`z'
       qui xtreg [dep_var]_`y' ${`y'estimate_`z'}, vce(cluster origin) fe
		 estimates store estimate`y'`z'
		 display "adjr2_`z' = " e(r2_a) " F-stat = " e(F) " RMSE: " e(rmse)
	     parmest, saving(xtreg`y'`z', replace)	
		 
	     predict fitted`y'`z'
		 predict residual`y'`z', resid
		
	  }
   }
		

esttab estimatea1 estimatea2 estimatea3 estimatea4,  star(.10, .05, .01) stats(r2_a F rmse) ///
	label title("Default Regression Estimates") ///
	nonumbers mtitles("Prior Default Estimate" "Base Default Reestimate" "2019 Reestimate")  ///
        
esttab estimateb1 estimateb2 estimateb3 estimateb4,  star(.10, .05, .01) stats(r2_a F rmse) ///
    label title("Early Payoff Regression Estimates") ///
    nonumbers mtitles("Prior Early Payoff Estimate" "Base Early Payoff Reestimate" "2019 Reestimate")  ///
        


********************************************************************************
***** TEST FOR OLS Assumptions & Autocorrelation
*******************************************************************************

qui {													
foreach y in a b {	
   forval z = 1/4 {
gen uhatsq`y'`z' = uhat`y'`z'^2
reg uhatsq`y'`z' ${`y'estimate_`z'} 
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(dm), LM)
noisily disp "BP Test: LM " LM " Pvalue " pvalue
local avg_uhat = uhatsq`y'`z'/e(N)

}
}
}

													
foreach y in a b {	
   forval z = 1/4 {

gen lag_resid`y'`z' = L.uhat`y'`z'
reg L.uhat`y'`z' lag_resid`y'`z'

}
}

qui {
foreach y in a b {		
forval z = 1/4 {
replace uhat`y'`z' = 0 if uhat`y'`z'==.
scalar uhatsq`y'`z' = uhat`y'`z'^2
scalar avg_uhat`y'`z' = sum(uhatsq`y'`z')/e(N) 
scalar resid_uhat`y'`z' = (uhat`y'`z' - avg_uhat`y'`z')^2 
scalar standard_uhat`y'`z' = sum(resid_uhat`y'`z')/(e(N)) 
noisily di "`y'`z' residuals have a variance of  "standard_uhat`y'`z'

matrix standard_uhat`y'`z' = standard_uhat`y'`z'
putexcel set "estimate_file.csv", sheet(err_var) modify
putexcel B`x' = matrix(standard_uhat`y'`z'), nformat(number_d2)
putexcel A`x' ="standard_error`y'`z'", nformat(number_d2)
local x = 1+`x'
}
}
}

save "xtreg_file.dta", replace
set more off 

use "file.dta", clear

keep parm
sort parm
drop if _n>0

save "form.dta", replace
														
foreach y in a b {	
   forval z = 1/4 {
	     use "xtreg`y'`z'", clear
		 rename estimate `y'estimate_`z'
		 merge m:m variables using "form.dta", nogen
		 save "form.dta", replace
	  }
   }
		
use "output/`program'_file.dta", clear

*******************************************************
* Error Minimization between historical and forecasts
* pct_* = historical rate                               
*******************************************************

gen difPrior_a = pct_a - forecast_prior_a
gen difa3 = pct_a - forecast_new_a
gen difa0 = pct_a - forecast_base_a

tabstat difPrior_a difa0 difa3 if age<25, by(age)

matrix stattotal = r(StatTotal)'
putexcel set "estimate_file.csv", sheet(stattotala) modify
putexcel A1 = matrix(stattotal), names nformat(number_d2)

gen difPrior_b = pct_b - forecast_prior_b
gen difb0 = pct_b - forecast_base_b
gen difb3 = pct_b - forecast_new_b
replace difb3 = 0 if age==1

tabstat difPrior_b difb0 difb3 if age<25, by(age)

matrix stattotal = r(StatTotal)'
putexcel set "estimate_file.csv", sheet(stattotalb) modify
putexcel A1 = matrix(stattotal), names nformat(number_d2)


*******************************************************************************
******* SCATTER OF RESIDUALS & BAR GRAPH MEAN RESIDUALS (over year, age, and origin)
*****************************************************************************

														
foreach y in a b {
   forval z = 1/4 {
		twoway (scatter uhatsq`y'`z' origin) if year<2019
		graph export "`z'`y'_scatter_residorigin.png", as(png) replace
		graph bar (mean) uhatsq`y'`z' if year<2019, over(origin, label(labsize(vsmall) angle(vertical)))
		graph export "`z'`y'_bar_residorigin.png", as(png) replace
}
}
													
foreach y in a b {	
   forval z = 1/4 {
		twoway (scatter uhatsq`y'`z' age) if year<2019
		graph export "`z'`y'_scatter_residage.png", as(png) replace
		graph bar (mean) uhatsq`y'`z' if year<2019, over(age)
		graph export "`z'`y'_bar_residage.png", as(png) replace
}
}

foreach y in a b {	
   forval z = 1/4 {
		twoway (scatter uhatsq`y'`z' year) if year<2019
		graph export "`z'`y'_scatter_residyear.png", as(png) replace
		graph bar (mean) uhatsq`y'`z' if year<2019, over(year)
		graph export "`z'`y'_bar_residyear.png", as(png) replace
}
}

******************************* Graphs by Origination ***************

forval yr = 1992/2018 {
local x = 2018-`yr'+1
 line pct_a forecast_base_a forecast_new_a age if origin==`yr' & age<=25, xline(`x') ///
     legend(tstyle(smbody) margin(right)) ///
     title("Default Rates - `yr' Origination", tstyle(body)) ///
     ytitle("Default Rate", tstyle(body)) lpattern(dash) lcolor(black blue green)
     graph export "default_`yr'.png", as(png) replace
}
*
forval yr = 1992/2018 {
   local xl = 2018-`yr'+1
   line pct_b forecast_base_b forecast_new_b age if origin==`yr' & age<=25, xline(`x') ///
     legend(tstyle(smbody) margin(right)) ///
     title("Early Payoff - `yr' Origination", tstyle(body)) ///
     ytitle("Early Payoff Rate", tstyle(body)) lpattern(dash) lcolor(black blue green)
     graph export "earlypayoff_`yr'.png", as(png) replace
	}   


******************************* Overall Graph Defaults
preserve

collapse (mean) pct_a forecast_base_a forecast_new_a, by(age) 

**** LABEL VARIABLES 

lab var pct_a "Historical Default Rate"
lab var forecast_base_a "Prior Estimated Default Rate"
lab var age "Age"
lab var forecast_new_a "Reestimated Default Rate"
												
line pct_a forecast_base_a forecast_new_a age if age<=25 ///
     legend(tstyle(smbody) symxsize(small) margin(right)) ///
     title("Default Model: Overall", tstyle(body)) ///
     ytitle("Default Rate", tstyle(body)) lpattern(dash) lcolor(black blue)
	 
graph export "Overall Default.png", as(png) replace



******************************* Overall Graph Early Payoffs 

preserve

collapse (mean) pct_b forecast_base_b forecast_new_b, by(age) 

**** LABEL VARIABLES 

lab var pct_b "Historical Early Payoff Rate"
lab var forecast_base_b "Prior Estimated Early Payoff Rate"
lab var age "Age"
lab var forecast_new_b "Reestimated Early Payoff Rate"
													

line pct_b forecast_base_b forecast_new_b age if age<=25 ///
     legend(tstyle(smbody) symxsize(small) margin(right)) ///
     title("Early Payoff Model: Overall", tstyle(body)) ///
     ytitle("Early Payoff Rate", tstyle(body)) lpattern(dash) lcolor(black blue)
	 
graph export "Overall Early Payoff.png", as(png) replace

