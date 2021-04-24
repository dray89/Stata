
sjlog using outreg1, replace
sysuse auto, clear
regress mpg foreign weight
sjlog close, replace


sjlog using outreg2, replace
outreg
sjlog close, replace

outreg using auto, varlabels replace
outreg using auto, bdec(2 5 2) varlabels replace title(What cars have low mileage?) ctitle("", Base case)

generate weightsq = weight^2
label var weightsq "Weight squared"
regress mpg foreign weight weightsq

outreg using auto, bdec(2 5 2) bfmt(f f e f) ctitle("", Quadratic mpg) varlabels merge replace
regress mpg foreign weight
outreg using auto, se bdec(2 5 2) squarebrack nostars replace tex varlabels title("No t statistics, please"\"We're economists")

regress mpg foreign weight turn
outreg using auto, bdec(2 5 3 2) varlabels replace        ///
starlevels(10 5 1) sigsymbols(+,*,**) summstat(F \ r2_a) ///
summtitle(F statistic \ Adjusted R-squared) summdec(1 2) ///
title(Summary statistics and \ 10% significance level)

tab rep78, gen(repair)
regress mpg foreign weight repair1-repair4
outreg using auto, keep(weight foreign) varlabels replace ///
    note(Coefficients for repair dummy variables not shown)

generate wgt = weight/100
label var wgt "Weight (lbs/100)"
tobit mpg wgt, ll(17)
outreg using auto, replace

outreg using auto, keep(model:) varlabel replace

generate goodrep = rep78==5
regress mpg weight foreign goodrep
test foreign = -goodrep
local F : display %5.2f `r(F)'
local p : display %4.3f `r(p)'

outreg using auto, replace ///
addrows("F test: foreign = -goodrep", "`F'" \ "p-value", "`p'")

sureg (price foreign weight length) (mpg displ = foreign weight)
outreg using auto, varlabels eq_merge replace ///
ctitles("", Price Equation, Mileage Equation, Engine Size Equation) ///
summstat(r2_1, r2_2, r2_3 \ N, N, N) summtitle(R2 \ N)

logit foreign wgt mpg
margins, dydx(*)
outreg using auto, marginal replace

outreg using auto, stat(b b_dfdx ci_dfdx) replace     ///
title("Marginal Effects & Confidence Intervals" \ ///
"Below Coefficients") margstar starloc(3)

regress mpg foreign weight
outreg, bdec(2 5 2) varlabels nodisplay     ///
ctitles("", "Regressions" \ "", "Base case")
regress mpg foreign weight weightsq
outreg, bdec(2 5 2) bfmt(f f e f) varlabels merge ///
ctitles("", "" \ "", "Quadratic mpg") nodisplay

mean mpg foreign weight
outreg using auto, bdec(1 3 0) nostar varlabels merge replace ///
     ctitles("", "Means &" \ "", "Std Errors") multicol(1,2,2) ///
     title(Multi-column ctitles) colwidth(12 7 11 8)

regress mpg foreign weight
outreg using auto, replace varlabels ///
     title("New Fonts for Overhead Slides") addfont(Futura,Didot Bold) ///
     basefont(fs32 fnew1) titlfont(fs40 fnew2) statfont(arial)


logit foreign wgt mpg
test wgt = mpg
local chi2 : display %5.2f `r(chi2)'
local p : display %4.3f `r(p)'
outreg using auto, replace colwidth(12 10) varlabels keep(foreign:)  ///
     addrows("\u0966?{\super 2} test", "`chi2'" \ "{\i p}-value", "`p'") ///
     note(""\"Run at $S_TIME, $S_DATE"\"Using data from $S_FN")      ///$
     title("Greek characters, superscripts, and italics")

mean foreign wgt mpg
outreg using auto, addtable ctitle(Variables, Means, Std Errors) ///
     nostars nosubstat title(Summary Statistics)

regress mpg foreign weight
label var foreign "Car Type {\super 1}"
matrix annotmat = J(3,2,0)
matrix annotmat[1,2] = 1
matrix annotmat[3,1] = 2
outreg using auto, annotate(annotmat) asymbol("{\super 2}", "{\super 3}") ///
     summstat(N) summtitle("{\i N}{\super 4}") ///
     title("Footnotes among the coefficients") ///
     note("{\super 1} First footnote."\  ///
          "{\super 2} Second footnote."\ ///
          "{\super 3} Third footnote."\  ///
          "{\super 4} Fourth footnote.") varlabels replace colwidth(10 10)

outreg using auto, nosubstat stats(b se t p ci_l ci_u) ctitles("mpg",  ///
          "Coef.", "Std. Err.", "t", "P$>|$t$|$", "[95\\% Conf.", "Interval]") ///
          title("Horizontal Output like Stata's {\tt ereturn display}")       ///
          bdec(7) nostar replace tex

outreg, clear

forvalues r = 2/5 {
 quietly regress mpg price weight if rep78==`r'
 outreg, merge varlabels ctitle("", "`r'") nodisplay
 }

outreg using auto, replay replace title(Regressions by Repair Record)

outreg using auto, replay replace title(Regressions by Repair Record)
webuse hsng2, clear
outreg, clear(iv)
outreg, clear(first)
forvalues r = 1/4 {
    quietly ivreg2 rent pcturban (hsngval = faminc) if reg`r', savefirst
    outreg, merge(iv) varlabels ctitle("", "Region `r'") nodisplay
    quietly estimates restore _ivreg2_hsngval
    outreg, merge(first) varlabels ctitle("", "Region `r'") nodisplay
  }

outreg using iv, replay(first) replace ///
     title(First Stage Regressions by Region)
outreg using iv, replay(iv) addtable ///
     title(Instrumental Variables Regression by Region)

