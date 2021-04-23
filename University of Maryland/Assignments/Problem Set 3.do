/*Part I. [30pts]You are interested in estimating the effect of eligibility of 
a scholarship on the probability someone attends college.  People who score 
a 1200 and above on the SAT are eligible to receive a scholarship while those 
below are not. 

1. Write down an equation that uses a regression discontinuity design to 
estimate your question and describe what each parameter measures.

Since scoring above 1200 isn't necessarily deterministic to receiving a scholarship, 
but increases the likelihood of treatment, this is a fuzzy rd problem where the eligibility 
of receiving a scholarship is used as an IV for treatment and we apply 2SLS. 

P(college) = B + BrdTi+ B11(xi - x0) + B12(xi - x0) x Dabove + BwWi + u
Dabove is an instrument for treatment since it is highly correlated to treatment but is not
deterministic of treatment. Brd is the difference in intercepts between the two regressions 
and is the average treatment effect. 

Probability of college attendance is equal to an intercept plus the partial effect 
of the dummy variable representing whether or not the observation is in the treatment group
or not multiplied by the indicator variable for treatment plus the partial 
effect of the running variable and the running variable, which is the 
distance away from the threshhold of an observation plus the partial effect of the control
variables times the value of the control variables plus the residual 
between the estimated value of probability and the actual probability of college 
attendance, u. 

2. What assumptions are necessary to identify the causal effect of 
scholarship eligibility on college attendance?
Regression Discon. assumes treatment assignment is random at the threshold or no 
selection bias is observed at the threshold because the observational variables
cannot perfectly manipulate their treatment status. Another assumption is the 
continutity of conditional regressions, or the expected value of the treatment 
group and the untreated group given x are continuous in x so that any mean 
difference around the cutoff point is due to treatment. Potential outcomes are continuous and 
treatment status is smooth near the threshhold. Decision rule and cutoff are known.

3. Describe how you might use this policy to estimate the effect of college 
attendance on wages?
There might be unobserved heterogeneity between those who receive scholarships and those
who don't which may influence college attendance and wages through college attendance. 
Therefore, the partial effect of scholarship eligibility could be an IV for 
college attendance in another FRD looking at the effect of college attendance on wages since 
scholarship eligibility is determined by a random cutoff amount even though college 
attendance may not be determined randomly but may be endogenous in the model. 

We would find the local average treatment effect by using the discontinuity between 
recipients of scholarships and nonrecipients of scholarships by conducting a 2SLS regression 
of wages on college attendance using the partial effect of scholarship eligibility on college 
attendance as an IV for college attendance since we assume it removes the confounding 
explanatory variables impacting college attendance.


Part II. [80pts] 
*/

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
