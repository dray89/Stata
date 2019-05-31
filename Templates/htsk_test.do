*******************************************************************************
* Test for presence of heteroskedasticity
* Conditional Variance Test
* Beusch Pagen Test for HTSK
* LM Test for HTSK
*******************************************************************************

global depvar = " "
global indvar = " "
global indvar2 = " "
global htskvar = " "

**** HTSK, Conditional Variance Test
* Check for differences in mean residuals and variance

egen float indhtsk = cut(${htskvar}), group(2) icodes
tabstat ${depvar}, statistics(var) by(indhtsk)
gen ${htskvar}sq = ${htskvar}^2
reg ${depvar} ${htskvar} ${htskvar}sq ${indvar}
predict uhat, resid
tabstat uhat, statistics(mean) by(indhtsk)

rvpplot ${htskvar}, mcolor(black) msymbol(smcircle_hollow)
graph save graph "rvpplot_${htskvar}.png", replace

twoway (scatter uhatsq ${htskvar})
graph export "htsk_${htskvar}.png", as(png) replace

**** Beusch Pagen Test for HTSK
reg ${depvar} ${htskvar} ${htskvar}sq ${indvar}
estat hettest

**** LM Test
reg ${depvar} ${indvar} ${indvar2}
predict uhat, resid								
gen uhatsq = uhat^2
qui reg uhatsq ${indvar} ${indvar2}
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m), LM)
disp "BP Test: LM " LM " Pvalue" pvalue




