set more off
tsset t
foreach v of varlist rebekah-sebastian {
di "**** VARIABLE: `v' *****"
di "*******************************"
corrgram `v', lags(10)
di ""
di ""
}
