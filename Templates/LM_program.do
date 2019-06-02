***** LM Test Program: Panel Data Fixed Effects

capture program drop lmtest

program define lmtest
	syntax varlist(fv ts)
	local var "`varlist'"
	local dep "`1'"
	local newlist: list var - dep
	
cap drop lmresid*
	xtreg `varlist', vce(cluster stateid) fe
	predict lmresid, resid
	gen lmresidsq = lmresid^2
	reg lmresidsq `newlist'
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue

end
