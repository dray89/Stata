 *  Examples for use in fmrttable help documentation
*
discard
mata: mata clear
set tr off
forvalues n=1/2 {
	capture erase xmpl`n'.doc
}
capture log close
sjlog using hlp_xmpl, replace


* Example 1: basic use
sjlog using frmttable1, replace
matrix A = (100,50\0,50)
matrix list A
sjlog close, replace
sjlog using frmttable2, replace
frmttable, statmat(A)
sjlog close, replace
sjlog using frmttable3, replace
frmttable using xmpl1, statmat(A) sdec(0) title("Payoffs") 	///
	ctitle("","Game 1","Game 2") rtitle("Player 1"\"Player 2")
sjlog close, replace

* Example 2: merge and append
sjlog using frmttable4, replace
matrix B = (25\75)
frmttable, statmat(B) sdec(0)	///
	ctitle("","Game 3") rtitle("Player 1"\"Player 3") merge	
sjlog close, replace
sjlog using frmttable5, replace
matrix C = (90\10)
frmttable, statmat(C) sdec(0) ///
	ctitle("","Game 4") rtitle("Player 2"\"Player 4") merge	
sjlog close, replace
sjlog using frmttable6, replace
matrix D = (100,100,100,100)
frmttable, statmat(D) sdec(0) rtitle("Total") append
sjlog close, replace
sjlog using frmttable7, replace
matrix E = (100,50,25,. \ 0,50,.,90 \ .,.,75,. \ .,.,.,10)
frmttable, statmat(E) sdec(0) addrows("Total", "100", "100", "100", "100") ///
	rtitles("Player 1" \ "Player 2" \ "Player 3" \ "Player 4")	///
	ctitles("", "Game 1", "Game 2", "Game 3", "Game 4") 			///
	title("Payoffs")
sjlog close, replace
	
* Example 3: multi-column titles, border lines, fonts
sjlog using frmttable8, replace
matrix F = (100,50,25,. \ 0,50,.,90 \ .,.,75,. \ .,.,.,10 \ 100,100,100,100)
frmttable using xmpl2, statmat(F) sdec(0) title("Payoffs") replace	///
	ctitles("", "{\ul Day 1}", "", "{\ul Day 2}" ,"" \ 			///
		"", "Game 1", "Game 2", "Game 3", "Game 4") 				///
	multicol(1,2,2;1,4,2) 												///
	rtitles("Player 1" \ "Player 2" \ "Player 3" \ "Player 4" \ "Total")	///
	vlines(010) vlstyle(a) basefont(arial fs10)
sjlog close, replace

* Example 4: Add stars for significance to regression output

sjlog using frmttable9, replace
sysuse auto, clear
regress mpg length weight headroom
matrix b_se = get(_b)', vecdiag(cholesky(diag(vecdiag(get(VCE)))))'
matrix colnames b_se = mpg mpg_se
matrix list b_se
sjlog close, replace
sjlog using frmttable10, replace
frmttable, statmat(b_se) substat(1) sdec(3)
sjlog close, replace

* assign stars for significance using -annotate- option
sjlog using frmttable11, replace
local bc = rowsof(b_se)
matrix stars = J(`bc',2,0)
forvalues k = 1/`bc' {
	matrix stars[`k',2] = 	///
		(abs(b_se[`k',1]/b_se[`k',2]) > invttail(`e(df_r)',0.05/2)) +	///
		(abs(b_se[`k',1]/b_se[`k',2]) > invttail(`e(df_r)',0.01/2))
}
matrix list stars
sjlog close, replace
sjlog using frmttable12, replace
frmttable, statmat(b_se) substat(1) sdec(3)	///
	annotate(stars) asymbol(*,**) varlabels
sjlog close, replace

* do it with -outreg-
sjlog using frmttable13, replace
outreg, se varlabels
sjlog close, replace

* Example 5: Make table of summary statistics & add to regression table

* create column of means & sd
sjlog using frmttable14, replace
matrix mean_sd = J(4,2,.)
local i = 1
foreach v in length weight headroom mpg {
	summ `v' 
	matrix mean_sd[`i',1] = r(mean)
	matrix mean_sd[`i',2] = r(sd)
	local i = `i' + 1
}
matrix rownames mean_sd = length weight headroom mpg
matrix list mean_sd
sjlog close, replace
sjlog using frmttable15, replace
frmttable, statmat(mean_sd) substat(1) varlabels ///
	ctitles("", Summary statistics) merge
sjlog close, replace

* alternative summary stats using -outreg- 
regress mpg length weight headroom
outreg, se varlabels
mean length weight headroom mpg
outreg, se varlabels merge


* Example 6: create complex tables using merge and append
sjlog using frmttable16, replace
sysuse auto, clear
recode headroom (1.5=2) (3.5/5=3), gen(hroom)
sjlog close, replace
outreg, clear(row0)
outreg, clear(row1)
* mata: mata clear is alternative
foreach f in 0 1 {
	foreach h in 2 2.5 3 {
		reg mpg weight if foreign==`f' & hroom==`h'
		outreg, nocons noauto merge(row`f')
	}
}
sjlog using frmttable17, replace
outreg, replay(row0) append(row1) replace rtitle(Domestic \ "" \ Foreign) ///
	ctitle("", "", "Headroom", "" \ "Origin", "<=2.0", "2.5", ">=3.0") ///
	title(Effect of weight on MPG by origin and headroom)
sjlog close, replace

* Example 7: Double statistics
sjlog using frmttable18, replace
matrix conf_int = J(4,3,.)
local i = 1
foreach v in length weight headroom mpg {
	summ `v' 
	matrix conf_int[`i',1] = r(mean)
	matrix conf_int[`i',2] = r(mean) - invttail(r(N)-1, .05/2)*sqrt(r(Var)/r(N))
	matrix conf_int[`i',3] = r(mean) + invttail(r(N)-1, .05/2)*sqrt(r(Var)/r(N))
	local i = `i' + 1
}
matrix rownames conf_int = length weight headroom mpg
matrix list conf_int
sjlog close, replace
sjlog using frmttable19, replace
matrix dcols = (0,0,1)
frmttable, statmat(conf_int) substat(1) doubles(dcols) varlabels ///
	ctitles("",Summary statistics) sdec(0 \ 0 \ 0 \ 0 \ 2 \ 2 \ 1 \ 1)	
sjlog close, replace

mean length weight headroom mpg
outreg, stats(b,ci) nostars varlabels ///
	ctitles("",Summary statistics) bdec(0 0 2 1)
