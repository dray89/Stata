* ECON 645
* Limited Dependent Variables Model Exercise

cd "C:\Users\Marquise McGraw\Dropbox\Econ 645\Fall 2018\Lecture Notes\2. Logit, Probit and Tobit\STATA"

drop _all 
capture log close
log using LDVexercise.log, replace

********** OVERVIEW OF mus14bin.do **********

* STATA Program 
* copyright C 2008 by A. Colin Cameron and Pravin K. Trivedi 
* used for "Microeconometrics Using Stata" 
* by A. Colin Cameron and Pravin K. Trivedi (2008)
  
* EXAMPLE
* 14.5 HYPOTHESIS AND SPECIFICATION TESTS
* 14.6 GOODNESS OF FIT AND PREDICTION
* 14.7 MARGINAL EFFECTS 


* To run this program you need data file 
*   mus14data.dta 
* in your directory
* Stata user-written command
*   margeff
* is used

* Data Set comes from HRS 2000

/*We analyze data on supplementary health insurance coverage. Initial analysis estimates the parameters of the
models forthcoming.

Data description

The data come from wave 5 (2002) of the Health and Retirement Study (HRS), a panel survey sponsored by
the National Institute of Aging. The sample is restricted to Medicare beneficiaries. The HRS contains
information on a variety of medical service uses. The elderly can obtain supplementary insurance coverage
either by purchasing it themselves or by joining employer-sponsored plans. We use the data to analyze the
purchase of private insurance (ins) from any source, including private markets or associations. The
insurance coverage broadly measures both individually purchased and employer-sponsored private
supplementary insurance, and includes Medigap plans and other policies.

Explanatory variables include health status, socioeconomic characteristics, and spouse-related
information. Self-assessed health-status information is used to generate a dummy variable (hstatusg) that
measures whether health status is good, very good, or excellent. Other measures of health status are the
number of limitations (up to five) on activities of daily living (adl) and the total number of chronic
conditions (chronic). Socioeconomic variables used are age, gender, race, ethnicity, marital status, years
of education, and retirement status (respectively, age, female, white, hisp, married, educyear,
retire); household income (hhincome); and log household income if positive (linc). Spouse
retirement status (sretire) is an indicator variable equal to 1 if a retired spouse is present.
For conciseness, we use global macros to create variable lists. *?

Another good resource on MEs: https://www3.nd.edu/~rwilliam/stats/Margins01.pdf

*/
********** SETUP

set more off
clear all
 
* Load data
use mus14data.dta, clear


* Interaction variables
drop age2 agefem agechr agewhi

* Summary statistics of variables
global xlist age hstatusg hhincome educyear married hisp
generate linc = ln(hhinc)
global extralist linc female white chronic adl sretire
summarize ins retire $xlist $extralist

* Logit regression
logit ins retire $xlist
 
* Estimation of several models
quietly logit ins retire $xlist
estimates store blogit
quietly probit ins retire $xlist 
estimates store bprobit
quietly regress ins retire $xlist 
estimates store bols
quietly logit ins retire $xlist, robust
estimates store blogitr
quietly probit ins retire $xlist, robust
estimates store bprobitr
quietly regress ins retire $xlist, robust
estimates store bolsr

* Table for comparing models - with t stats instead of ses
esttab blogit blogitr bprobit bprobitr bols bolsr using testtable.csv , ///
  se stats(N ll r2_p r2_a) // b(%7.3f) stfmt(%8.2f)
   
* Table for comparing models - with standard errors as normal
estimates table blogit blogitr bprobit bprobitr bols bolsr, ///
  stats(N ll r2_p r2_a) b(%7.3f) stfmt(%8.2f)

   
  ********** HYPOTHESIS AND SPECIFICATION TESTS

* Wald test for zero interactions
/* Note: A Wald test simply generalizes the usual "t-test" to 
multiple variables. */

generate age2 = age*age
generate agefem = age*female
generate agechr = age*chronic
generate agewhi = age*white
global intlist age2 agefem agechr agewhi
quietly logit ins retire $xlist $intlist
test $intlist 

* Likelihood Ratio test
/*In statistics, a likelihood ratio test (LR test) is 
a statistical test used for comparing the goodness of fit 
of two statistical models — a null model against an 
alternative model. The test is based on the likelihood ratio, 
which expresses how many times more likely the data are 
under one model than the other. This likelihood ratio, 
or equivalently its logarithm, can then be used to compute 
a p-value, or compared to a critical value to decide whether 
or not to reject the null model. 
*/

quietly logit ins retire $xlist $intlist
estimates store B 
quietly logit ins retire $xlist
lrtest B 

********** GOODNESS OF FIT AND PREDICTION

* Comparing fitted probability and dichotomous outcome
quietly logit ins retire $xlist
estat classification

* Calculate and summarize fitted probabilities
quietly logit ins hhincome
predict plogit, pr
quietly probit ins hhincome  
predict pprobit, pr
quietly regress ins hhincome
predict pols, xb
summarize ins plogit pprobit pols

* Following gives Figure mus14fig1.eps
sort hhincome
graph twoway (scatter ins hhincome, msize(vsmall) jitter(3)) /*
  */ (line plogit hhincome, clstyle(p1)) /*
  */ (line pprobit hhincome, clstyle(p2)) /*
  */ (line pols hhincome, clstyle(p3)), /*
  */ scale (1.2) plotregion(style(none)) /*
  */ title("Predicted Probabilities Across Models") /*
  */ xtitle("HHINCOME (hhincome)", size(medlarge)) xscale(titlegap(*5)) /* 
  */ ytitle("Predicted probability", size(medlarge)) yscale(titlegap(*5)) /*
  */ legend(pos(1) ring(0) col(1)) legend(size(small)) /*
  */ legend(label(1 "Actual Data (jittered)") label(2 "Logit") /*
  */         label(3 "Probit") label(4 "OLS"))

graph export mus14fig1_modelcompare.pdf, replace

********** MARGINAL EFFECTS 
quietly logit ins retire $xlist
// Average marginal effect over all covariates at the specified values (MER)
margins, dydx(*) at(age=65 retire=0 hstatusg=1 hhincome=50 educyear=17 married=1 hisp=0)

// MERs at a variety of ages
quietly logit ins retire $xlist
margins, dydx(hisp) at(age=(50 60 70 80))
marginsplot
graph export mus14fig2_mer_hisp_age_compare.pdf, replace

* Marginal effects (MEM) after logit
quietly logit ins retire $xlist 
margins, dydx(*) atmeans  // (MEM)

* Marginal effects (AME) after logit
quietly logit ins retire $xlist 
margins, dydx(*) //(AME)

*************** MARGINAL EFFECTS COMPARED TO OLS

*** COMPARING MODELS WITH AVERAGE MARGINAL EFFECTS ***

quietly logit ins retire $xlist
margins, dydx(*) post
estimates store blogit
quietly probit ins retire $xlist 
margins, dydx(*) post
estimates store bprobit
quietly regress ins retire $xlist
estimates store bols
quietly logit ins retire $xlist, robust
margins, dydx(*) post
estimates store blogitr
quietly probit ins retire $xlist, robust
margins, dydx(*) post
estimates store bprobitr
quietly regress ins retire $xlist, robust
margins, dydx(*) post
estimates store bolsr

* Table for comparing models - average marginal effects
estimates table blogit blogitr bprobit bprobitr bols bolsr, ///
  se stats(N ll r2_p r2_a) b(%7.3f) stfmt(%8.2f)
  
  
** COMPARING MODELS WITH MARGINAL EFFECTS AT MEAN VALUES
*** COMPARING MODELS WITH AVERAGE MARGINAL EFFECTS ***

quietly logit ins retire $xlist
margins, dydx(*) atmeans post
estimates store blogit
quietly probit ins retire $xlist 
margins, dydx(*) atmeans post
estimates store bprobit
quietly regress ins retire $xlist
estimates store bols
quietly logit ins retire $xlist, robust
margins, dydx(*) atmeans post
estimates store blogitr
quietly probit ins retire $xlist, robust
margins, dydx(*) atmeans post
estimates store bprobitr
quietly regress ins retire $xlist, robust
margins, dydx(*) atmeans post
estimates store bolsr

* Table for comparing models - marginal effects atmeans
estimates table blogit blogitr bprobit bprobitr bols bolsr, ///
  stats(N ll r2_p r2_a) b(%7.3f) stfmt(%8.2f)
