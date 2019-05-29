clear
cap log close 
set more off

use minwage.dta
tsset t

/*
1.	Run a regression of gwage232 on gmwage, gcpi. Do the sign and magnitude of 
the estimated coefficient on gmwage make sense to you? Explain. Is it statistically significant? */

regress gwage232 gmwage gcpi
browse gwage232 gmwage gcpi


/*Since the minimum wage in sector 232 is already higher than the federal minimum wage, 
it makes sense that an increase in the federal minimum wage would have less of an impact 
on the min wage in that sector. It is statistically significant. But, the change in the 
minimum wage in sector 232 may not be due to the federal minimum wage increase at all and 
may be due to other covariants. 1) gcpi may be endogenous 2) because we didn't account for the
 natural trend in sector 232 and remove that from the effect of gmwage on gwage232, we have biased 
 the coefficient.3) we may be missing other variables that may be impacting wages like changes in union
 contracts*/

/*
2.	Add lags 1 – 12 of gmwage to the equation from (1).  Do you think it is necessary to
 include these lags to estimate the long run effect of minimum wage growth on wage growth in sector 232? Explain.*/

regress gwage232 gcpi gmwage L(1/12).gmwage
testparm L(1/12).gmwage

/* The shortrun propensity = .1493019 with a high Tvalue, low standard error and a significant pvalue; 
The joint test for significance - fstatistic is only almost significant at the .05 level. 
The Rsq and Adj Rsq both increase when we add the additional time lags,
 so more effects on y are explained by this regression but may have biased
 coefficients and we may be overestimating the Rsq of this regression by not 
 proproperly accounting for the natural trend in sector 232. */

forval x = 1/12 {
gen sub`x' = gmwage_`x' - gmwage

}
regress gwage232 gcpi gmwage sub1-sub12

/* The long run propensity is .197599  which is also the sum of the coefficients on 
the regression of gwage232 onto the lagged variables and gmwage and gcpi and is statistically significant at 
the .01 significance level */

/* Detrended Regression*/
gen tsq = t^2

regress gwage232 gcpi gmwage L(1/12).gmwage t tsq
/* Short Run propensity =  .1507736 */

test gmwage L(1/12).gmwage
test t tsq
test gmwage L(1/12).gmwage

/* Long Run Propensity*/
regress gwage232 gcpi gmwage sub1-sub12 t tsq

/* Obtain actual R2*/


regress gwage232 t tsq
predict yresid, resid
regress gcpi t tsq
predict wresid, resid
regress gmwage t tsq
predict xresid, resid

forval x = 1/12 {
	reg L`x'.gmwage t tsq
	predict xresid`x', resid
}

regress yresid wresid xresid residx1-residx12

/*	Run the regression of gemp232 on gmwage, gcpi. Does minimum wage growth appear to have a contemporaneous effect on gemp232? */

/*Employment Regression*/

regress gemp232 gmwage gcpi
/*The minimum wage does not seem to have a statistically sign 
effect on employment contemporaneously since the coefficients are small in 
magnitude and the pvalues are insignificant and the adj r2 is actually
negative *//*

4.	Add lags 1-12 to the employment growth equation in (3). 
Does growth in the minimum wage have a statistically significant effect on employment growth, 
either in the short or long run? Explain. 

*/
regress gemp232 gcpi gmwage L(1/12).gmwage

/*The short run propensity is not significant and equal to -.0042524  */

test gmwage L(1/12).gmwage
/*the effect of the lagged growth in the minimum wage on gemp232 are not 
jointly or individually significant. */

estimates store gmwage
coefplot gmwage

/*The coefplot doesn't show any large differences in magnitude between the 
coefficients*/
regress gemp232 gcpi gmwage sub1-sub12
/*The long run propensity is not significant and equal to .0257437 therefore, it is unlikely
that minimum wage changes impact employment growth in sector 232*/

/*Detrend*/
regress gemp232 gcpi gmwage L(1/12).gmwage t tsq
regress gemp232 gcpi gmwage sub1-sub12 t tsq
regress gemp232 t tsq
predict yresidemp, resid
regress yresidemp wresid residx0-residx12

/*Detrending doesn't have much of an effect on the significance of the regression*/

/*Part II*/
clear all 
use matching_earnings.dta

/*
2.	Now estimate your propensity score matching model using one-to-one nearest neighbor 
matching with replacement. Don’t forget to set your random seed! */
set seed 123456
gen u = uniform()
sort u
probit treat age educ marr re75
predict pscorea

histogram pscorea, start(0.0) width(0.05) by(TREAT, col(1))

browse treat pscorea
gen p1 = 1 if pscorea>.5
replace p1 = 0 if pscorea<.5
tab treat p1

psmatch2 treat, outcome(RE78) pscore(pscorea) n(1) common
/*	Does participation in the program appear to be randomly assigned? How would you test this? */
/*To test for random assignment, we need to construct counterfactuals of untreated outcomes
for treated observations. The counterfactual is a weighted average of the observed untreated outcomes.
*/
histogram pscorea, start(0.0) width(0.05) by(TREAT, col(1))
/* We show a poor common support problem in the histogram - we can use the "common" command to
concentrate on the overalapping populations although when we do this we 
will possibly throw out useful information for people near the boundaries and it might
be unclear what we are estimating.
In the histogram it looks like some of the participants might be more likely to be in the treatment group than others meaning the treatment group
may not be completely randomly assigned.*/
ttest RE78, by(treat)
reg RE78 treat
bysort treat: sum RE78
/*Income is a determining factor of being in the treatment group
 but we only really need random assignment within the treatment group*/

/*How many unique control subjects were matched to the treated? 
How many control subjects were matched more than once? */
tab _weight treat

/*	Repeat propensity score matching, but now with no replacement. How did the results change?*/

psmatch2 treat, outcome(RE78) pscore(pscorea) n(1) common noreplacement
tab _weight treat
/*no replacement has a negative ATT difference btwn treated and controls.
 the ATT for controls increased and SE of ATT for controls decreased and 
 184 controls were matched to 184 treated. */
 
/*	Repeat propensity score matching with replacement, but now use 2 matches for each treated subject.  How did the results change?*/
psmatch2 treat, outcome(RE78) pscore(pscorea) n(2) common

/*from noreplacement, the control ATT decreased and the standard error increased. 
From 1 match, the SE decreased while the ATT increased. no replacement has a negative ATT
difference between treated and controls. the difference is greater on use 1 match
per treated subject rather than 2. */ 
