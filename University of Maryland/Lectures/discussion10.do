/*Debra Ray Discussion 10*/
clear all
set more off

use "C:\Users\dray\Downloads\agg_pt.dta", clear
sort year 
gen yr_qtr = yq(year, qtr)
format yr_qtr %tq

tsset yr_qtr

twoway (scatter pt yr_qtr, sort), ytitle(Personal Current Tax Receipts) //
xtitle(Time) title(Personal Income over Time)

gen pt_1=L1.pt
gen pt_2=L2.pt

regress pt pt_1 pt_2, robust

tab qtr, gen(dqtr)


gen t = _n
regress pt pt_1 pt_2 i.qtr t
regress pt i.qtr, robust
predict yresid2, resid
regress pt_1 i.qtr, robust
predict wresid2, resid
regress pt_2 i.qtr, robust
predict xresid2, resid

regress yresid2 wresid2 xresid2, robust

regress pt pt_1 pt_2 t qtr_1 qtr_2 qtr_3, robust
predict pt_det, resid

gen pt_det_1 = L1.pt_det
gen pt_det_2 = L2.pt_det
reg pt_det pt_det_1 pt_det_2, robust
regress pt pt_1 pt_2 t qtr_1 qtr_2 qtr_3, robust
twoway (scatter pt_det yr_qtr, sort), ytitle(Detrended Personal Current Tax Receipts) xtitle(Time) title(Personal Income over Time)

