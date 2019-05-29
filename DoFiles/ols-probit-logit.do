

clear all
cap log close
set more off

log using PS3.txt, text replace

use corpus_christi.dta, clear

/*1. Using the Corpus Christi data, estimate a linear probability model of 
the probability of acceptance into JTPA at Corpus Christi conditional on 
race/ethnicity, age and years of completed schooling. Report and discuss 
the coefficient estimates. */

regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust

/*2. Estimate the standard errors normally and 
using the robust option. How big are the differences, if any? Which standard 
errors are larger? */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust

/*Robust Standard Errors are larger but the differences are not "big"*/

/*3. Using the estimated coefficients from the Question 1, generate predicted 
participation probabilities. Do any of these probabilities lie outside [0, 1]?
If so, do the observations corresponding to these values show any particular 
patterns in the values of the variables? */
regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15
estimates store ols
predict fitted 
tab fitted if fitted<0 | fitted>1

/*No values lie outside of 0, 1 - Very few of those variables are significant - the only one 
that is statistically significant is education under 10 years which decreases the 
probability of acceptance into the program versus the base dummy, 12 years of 
education exactly.*/

/*4. Estimate probit and logit models of acceptance into JTPA in Corpus Christi 
conditional on race/ethnicity, age and years of completed schooling using 
these data. Are the probit and logit coefficient estimates similar to one 
another and to the LPM estimates? Should they be? Explain why or why not. */

probit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15
estimates store probit
logit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15
estimates store logit

estimates table ols probit logit, stats(N ll r2_p r2_a F rmse) b(%7.3f) stfmt(%8.2f) star(.10, .05, .01)

/* The coefficients are not consistent across the three estimations but 
the p-values are similar in that they all indicate that education under ten years
is the only statistically significant predictor variable.*/

/*5. Calculate the mean partial derivatives (a.k.a. marginal effects or average 
partial effects) of the conditional probabilities of participation with 
respect to age for the LPM, logit and probit models. Explain in words 
what these derivatives mean. */

regress accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust
probit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust
margins, dydx(*)
logit accept black hisp othrace age edlt10 ed10_11 ed13_15 edgt15, robust
margins, dydx(*)

/*The AME is equal to the sum of all the marginal effects for a variable divided by 
the number of possibilities yielding the average marginal effect across the entire 
variable. Since probit and logit models are not linear, these values will be different
than the coefficients in the probit and logit regressions. */

cap log close
