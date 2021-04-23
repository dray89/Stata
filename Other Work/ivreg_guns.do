**** Try IVregress
qui {
cap drop iv_re*
ivreg2 lvio shall incarc_rate year (stateid = pm1029 pw1064 pb1064 density pop avginc)
ivendog
estimates store iv1

	predict iv_resid1, resid
	gen iv_resid1sq = iv_resid1^2
	reg iv_resid1sq shall incarc_rate year

	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
	
ivreg2 lvio shall incarc_rate year density pop avginc (stateid = pm1029 pw1064 pb1064)
ivendog 
estimates store iv2

	predict iv_resid2, resid
	gen iv_resid2sq = iv_resid2^2
	reg iv_resid2sq shall incarc_rate year density pop avginc
	
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
	
ivreg2 lvio shall incarc_rate stateid (avginc = pm1029 )
estimates store iv3
predict iv_resid3, resid

	gen iv_resid3sq = iv_resid3^2
	reg iv_resid3sq shall incarc_rate stateid 
	
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
	
ivreg2 lvio shall incarc_rate year stateid (avginc = pb1064 )
ivendog 
estimates store iv4
predict iv_resid4, resid

	gen iv_resid4sq = iv_resid4^2
	reg iv_resid4sq shall incarc_rate year stateid
	
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
	
ivreg2 lvio shall incarc_rate (avginc = pm1029 )
estimates store iv5
predict iv_resid5, resid

	gen iv_resid5sq = iv_resid5^2
	reg iv_resid5sq shall incarc_rate 
	
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
	
ivreg2 lvio shall incarc_rate year (avginc = pm1029 )
estimates store iv6
predict iv_resid6, resid

	gen iv_resid6sq = iv_resid5^2
	reg iv_resid6sq shall incarc_rate year
	
	scalar LM = e(r2)*e(N)
	scalar pvalue = chi2tail(e(df_m), LM)
	noisily disp "BP Test: LM " LM " Pvalue" pvalue
}

forval x = 1/6 {
stderr iv_resid`x'
}

