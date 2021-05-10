/*Debra Ray Data Case 2*/
cap log close
use "C:\Users\faith\iCloudDrive\School\StataDataSets\data case 2.dta", clear
log using "C:\Users\faith\Documents\Cleaned Stata Files\datacase2.log", replace
 
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
save "C:\Users\faith\iCloudDrive\School\StataDataSets\datacase2-2.dta", replace
collapse (mean) aapl adsk ba cat ebay gs hsy ibm jpm wmt rf mkt
xpose, varname clear
rename v1 avgreturn
save "C:\Users\faith\iCloudDrive\School\StataDataSets\avgreturndatacase2.dta", replace
clear all 
use "C:\Users\faith\iCloudDrive\School\StataDataSets\datacase2-2.dta", clear
collapse (mean) Betaaapl Betaadsk Betaba Betacat Betaebay Betags Betahsy Betaibm Betajpm Betawmt
xpose, varname clear
rename v1 beta
save "C:\Users\faith\iCloudDrive\School\StataDataSets\betadatacase2.dta", replace
merge 1:1 _n using "C:\Users\faith\iCloudDrive\School\StataDataSets\avgreturndatacase2.dta"

replace _varname = "AAPL" in 1
replace _varname = "ADSK" in 2
replace _varname = "BA" in 3
replace _varname = "CAT" in 4
replace _varname = "EBAY" in 5
replace _varname = "GS" in 6
replace _varname = "HSY" in 7
replace _varname = "IBM" in 8
replace _varname = "JPM" in 9
replace _varname = "WMT" in 10
replace _varname = "RF" in 11
replace _varname = "MKT" in 12


save "C:\Users\faith\iCloudDrive\School\StataDataSets\mergedatacase.dta", replace
twoway (scatter avgreturn beta, mlabel(_varname)), ytitle(Average Return) xtitle(Beta) title(Beta and Average Return)
log close
