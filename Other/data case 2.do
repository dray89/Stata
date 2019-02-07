/*Debra Ray Data Case 2*/

clear all 
log using "C:\Users\dray\Documents\Documents\datacase2.log", replace
 use "C:\Users\dray\Documents\Documents\data case 2.dta", clear
 
foreach v of varlist aapl-mkt {
	replace `v' = `v'-rf
} 

foreach v of varlist aapl-mkt {
	reg `v' mkt
	display as text "Alpha"
	di _b[_cons]
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
	
/*BA has a pretty good alpha but the others didn't perform all that better than MKT. 
*/
save "C:\Users\dray\Documents\Documents\data case 2-2.dta", replace
collapse (mean) aapl adsk ba cat ebay gs hsy ibm jpm wmt rf mkt
xpose, varname clear
rename v1 avgreturn
save "C:\Users\dray\Documents\Documents\avgreturndatacase2.dta", replace
clear all 
use "C:\Users\dray\Documents\Documents\data case 2-2.dta", clear
collapse (mean) Betaaapl Betaadsk Betaba Betacat Betaebay Betags Betahsy Betaibm Betajpm Betawmt
xpose, varname clear
rename v1 beta
save "C:\Users\dray\Documents\Documents\betadatacase2.dta", replace
merge 1:1 _n using "C:\Users\dray\Documents\Documents\avgreturndatacase2.dta"

replace _varname = "AAPL" in 1
replace _varname = "ADSK" in 2
replace _varname = "BA" in 3
replace _varname = "CAT" in 4
replace _varname = "EBAY" in 5
replace _varname = "" in 6
replace _varname = "HSY" in 7
replace _varname = "IBM" in 8
replace _varname = "JPM" in 9
replace _varname = "WMT" in 10
replace _varname = "RF" in 11
replace _varname = "MKT" in 12
replace _varname = "GS" in 6
	save "C:\Users\dray\Documents\Documents\mergedatacase.dta", replace
twoway (scatter avgreturn beta, mlabel(_varname)), ytitle(Average Return) xtitle(Beta) title(Beta and Average Return)
