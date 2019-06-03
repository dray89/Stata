***** LM Test Program
***** Takes two arguments: 1) Saved Residual Variable and a macro varlist of regressors.

capture program drop lmtest

program define lmtest
	syntax varlist(fv ts)
	local var "`varlist'"
	local error "`1'"
	local newlist: list var - error
	
	cap drop `error'sq
	gen `error'sq = `error'^2
	reg `error'sq `newlist'
	scalar LM = e(r2)*e(N)
	scalar p`error' = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM, " LM " Pvalue, " pvalue
	
	
end
