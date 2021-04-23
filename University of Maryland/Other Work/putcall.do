
cap log close
log using putcall.log, replace
use beta.dta

foreach v of varlist ge-nflx {
	bsopm sprice strike, time(time) ir(ir) sigma(beta)
} 

foreach v of varlist aapl-mkt {
	replace `v' = `v'-rf
} 

foreach v of varlist aapl-mkt {
	reg `v' mkt
	display as text "Alpha"
	di _b[_cons]
	generate Alpha`v' = _b[mkt]
	display as text "Beta"
	di _b[mkt]
	generate Beta`v' = _b[mkt]
	display as text "Standard Error"
	dis _se[mkt]
	display as text "Lower Interval"
	di _b[_cons]-(_se[mkt]*sqrt(12)*1.96)
	display as text "Upper Interval"
	di _b[_cons]+(_se[mkt]*sqrt(12)*1.96)
}
	

save beta2.dta, replace
collapse (mean) aapl bhge cgc ge rht tlry uso nflx mkt rf
xpose, varname clear
rename v1 avgreturn
save "C:\Users\dray\Documents\Documents\avgreturn.dta", replace
clear all 
use "C:\Users\dray\Documents\Documents\beta2.dta", clear
collapse (mean) Betaaapl Betabhge Betacgc Betage Betarht Betatlry Betauso Betanflx Betamkt
xpose, varname clear
rename v1 beta
save "C:\Users\dray\Documents\Documents\beta3.dta", replace
clear all 
use beta2.dta
collapse (mean) Alphaaapl Alphabhge Alphacgc Alphage Alpharht Alphatlry Alphauso Alphanflx Alphamkt
xpose, varname clear
rename v1 alpha
save "C:\Users\dray\Documents\Documents\alpha.dta", replace
merge 1:1 _n using "C:\Users\dray\Documents\Documents\avgreturn.dta"
drop _merge
merge 1:1 _n using "C:\Users\dray\Documents\Documents\beta3.dta"

replace _varname = "AAPL" in 1
replace _varname = "BHGE" in 2
replace _varname = "CGC" in 3
replace _varname = "GE" in 4
replace _varname = "RHAT" in 5
replace _varname = "TLRY" in 6
replace _varname = "USO" in 7
replace _varname = "NFLX" in 8
replace _varname = "MKT" in 9

save "C:\Users\dray\Documents\Documents\mergedputcall.dta", replace
twoway (scatter avgreturn beta, mlabel(_varname)), ytitle(Average Return) xtitle(Beta) title(Beta and Average Return)
