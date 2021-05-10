/* Debra Ray, Problem Set 2, Program Evaluation */


clear all
set more off
cap log close
log using ps2_ray.log, replace


/* Question 1: Propensity Score Matching

Load in the data using the command: webuse cattaneo2, clear. */

webuse cattaneo2, clear

/* Q1, a) Compute the eﬀect of whether or not a mother smoked during pregnancy 
(mbsmoke) on birthweight (bweight), controlling for an indicator for married, 
an indicator for the baby being the ﬁrst baby, mother being white, a quadratic 
function of a mother’s age, mother’s years of education, mother’s years of education 
squared, and an indicator for whether or not the mother drank alcohol during the 
pregnancy.*/

gen magesq = mage^2
gen medusq = medu^2
regress bweight mbsmoke mmarried fbaby mrace mage magesq medu medusq alcohol

estimates store ols

/* Q1 b) Why might you be worried about interpreting the coeﬃcient on the eﬀect 
of the mother’s smoking status as a truly causal relationship? Explain.

We might not be able to construct a counterfactual appropriately using OLS due to 
treatment endogeneity. Thus, if selection bias is determined by observed characteristics
and there are no unobserved causes of selection bias, we can use propensity score matching 
to first predict treatment using either a logit or probit regression model, find matches using 
the probabilities of treatment within a certain range as comparable indexes, and construct
counterfactuals for treated observations from control group observations with similar 
index scores. OLS, in other words, would only provide the ATE since we would be taking 
averages of the treatment effect across all groups without controlling for probability
of being in the treatment group.

*/

/*Q1 c) Use propensity score matching to answer estimate the eﬀect of whether or 
not a mother smoked during pregnancy on birthweight, controlling for the exact same 
set of control variables. */

teffects psmatch (bweight) (mbsmoke mmarried fbaby mrace mage magesq medu medusq alcohol)
estimates store ate
teffects psmatch (bweight) (mbsmoke mmarried fbaby mrace mage magesq medu medusq alcohol), atet
estimates store atet
/*Do these results diﬀer substantially from the regression results in question 1a?*/

estimates table ols ate atet, se t p

/* OLS provided the most efficient standard errors, and when we ran the psmatch, 
ATE provided the largest standard errors. ATET standard errors improved from ATE.

ATE provided the lowest absolute value of the the treatment effect. ATET provided the highest
absolute value of the treatment effect. OLS coefficient was between that of ATE and ATET. 

All estimates of the treatment effect were reported significant at the .01 level although 
OLS reported a higher absolute value of the T score with ATET following with the second highest 
absolute value of the Tscore. ATE reported the lowest absolute value of the tscore. 

Overall, ATET was closer to the treatment results reported in the OLS regression 
while ATE was outside of the initial confidence interval for the OLS reported 
treatment effect.*/

/*Q1 d) Re-run the teffects psmatch command, adding at the end of the command after 
the comma gen(pscore). */

teffects psmatch (bweight) (mbsmoke mmarried fbaby mrace mage magesq medu medusq alcohol), atet gen(pscore)

/*Now run the command teffects overlap to see the common support graph.*/ 

teffects overlap

/*Save the graph using the command graph export <lastname>.pdf, replace and upload the 
graph separately to ELMS. */

graph export ray.pdf, replace

/*Is there much overlap between the smoking and non-smoking groups? Why does this matter? 
*/

/*There seems to be sufficient overlap between smoking and non-smoking groups. We want
common support in order to perform the matching and build a counterfactual. Without
common support, we don't have sufficient explanatory power over treatment selection 
to remove selection bias using propensity-score matching.*/

/*Q1 e) How does propensity-score matching allow for the separate calculation of the ATE and ATET?*/

/* In nonexperimental data without random assignment, as long as there is sufficient common support, 
propensity score matching allows us to compare treated and control observations based on 
selection on observables to estimate counterfactuals. This allows us to calculate both the 
ATE and the ATET by removing selection bias from the ATE. */

/*Q1 f) What advantages does propensity score matching have over exact cell matching, 
particularly when the number of covariates is high? 

Because exact cell matching suffers from the "curse of dimensionality," propensity score
matching provides a method to match observations for comparison when there are a large
number of covariates acting as qualifying parameters. As the number of qualifying 
parameters increases, the number of possible matches decreases. Propensity scores
turn determinants for treatment into a likelihood estimator. Thus, the propensity-score method 
compares observations with the same likelihood of treatment, increasing the number of potential 
matches from the possibilities in exact cell matching.*/

/* Question 2 IV Regression

(a) Run an OLS regression of loggdp on risk. What do these results suggest? */

use "C:\Users\faith\Downloads\ps2_iv.dta", clear
regress loggdp risk 
di exp(_b[risk]) -1

/*These results suggest that property rights have a positive relationship with 
loggdp at the .01 confidence level. The coefficient on risk is equal to approx .51. 
Thus, the estimated effect of one additional unit increase in property protection on 
gdp is .66.*/

/* Q2(b) Why might you be worried about interpreting the coeﬃcient on the eﬀect 
of property rights on GDP per capita as a truly causal relationship? Explain. 

Becuase it is not possible to exactly quantify risk, the risk measures in the 
regression are approximate index measures on a scale of 1 - 10. Thus, these
estimates are only correlated with risk, and they are not exact. */ 

/*Q2 (c) 

i. What conditions need to be satisﬁed for settler mortality to be a valid instrument 
for property rights? Discuss whether each of these is likely to hold in this context. 
Which of these conditions can you check in the data? 

For settler mortality to be a valid instrument for property rights, the instrumental
variable needs to be both relevant, correlated with the variable it is instrumenting, and 
exogenous, uncorrelated with the error term.
 
In this case, mortality needs to be both correlated with property rights and uncorrelated
with the error term. Exogeneity cannot be tested, but we can test for relevance in the 
first stage regression of the endogenous variable on the excluded instruments. 

To check for relevance, after running the first stage regression, if the F statistic 
is greater than 10, we have a strong enough correlation with the endogenous variable to 
use an IV regression model to estimate the causal effect of property rights on 
GDP. 

In this case, it seems that settler mortality may not be exogenous in the equation as it
may also be a product of GDP. As GDP increases, the death rate should decrease. Because 
there is a relationship between mortality and the outcome variable apart from the 
indirect relationship resulting from the mutual correlation with the instrumented variable, 
the exogeneity assumption may be theoretically unlikely. The relevance assumption 
is likely to hold because it seems likely that mortality rate would be correlated to the 
presence of protective institutions like rule of law which govern property rights.

*/

/*ii. Estimate the ﬁrst stage equation using the regress command. Explain what you ﬁnd. */

regress risk logmort0

/* The F statistic of the regression is greater than 10 and the t-stat on logmort is significant
at the .01 confidence level. The relevance assumption holds. */

/*iii. Use the command ivregress with the first option to run an IV regression of loggdp on 
risk using logmort0 as an instrument.*/

ivregress 2sls loggdp (risk = logmort0), first

/*Verify that the ﬁrst stage results here match the ﬁrst stage you manually estimated 
in 2(c)ii. 

The first stage results are the same.

 */
/*
How do your estimates of the eﬀect of risk on loggdp compare to the estimates 
in 2a? Are the diﬀerences you ﬁnd consistent with the biases you discussed in 2b? 

iv. Now, run the command estat endogeneity to test if the the variable we are assuming 
to be endogenous, risk, might be in fact exogenous. Verify from the p-value of the test 
that you can reject the null hypothesis that risk is exogenous. */

estat endogenous

/* Both the Durbin chi2 and the Wu-Hausman Fstat are significant at the .01 confidence
level. Thus, we can verify that the null hypothesis that risk is exogenous is rejected. */

/*v. Lastly, run the command estat firststage to make sure the instrument isn’t weak. 
What is the R2 and the F-test statistic from the ﬁrst stage? */

estat firststage

/* The Fstat is 22.43 and the adjusted R-sq is .26. */

/* Question 3: Difference in Differences

(a) Calculate the average starting wage (wage_st) separately for restaurants in NJ and PA, 
for each interview wave. */

use "C:\Users\faith\Downloads\ps2_dd.dta", clear

sort state
by state: sum wage_st1 wage_st2


/*i. Calculate the diﬀerence in the average wages between the second 
and ﬁrst interviews. */

scalar wagediffpa = 4.618788 - 4.653636
scalar wagediffnj = 5.082141 - 4.612982

/*ii. Next, calculate the diﬀerence between NJ and PA of the time diﬀerences 
you just computed. */

scalar didwage =wagediffnj - wagediffpa
di didwage

/*iii. What is the interpretation of such a diﬀerence-in-diﬀerences estimate of 
the wage eﬀect? What do your estimates tell you? 

These estimates say that the difference in nj wages over this time period were 
larger than the diff in pa wages over the same time period although it isn't clear 
within what range we expect these estimates can be extended to the population without
standard errors from which to calculate confidence intervals.*/

/*iv. Under what conditions does this provide a valid estimate of the causal impact of a 
minimum wage increase on wages in the fast food industry? 

In order for a difference-in-difference estimator to provide a valid estimate of 
the causal impact of a minimum wage increase on wages, the wage trends in both the 
treatment and control groups need to be the same in the pre-treatment period (Parallel 
Trends Assumption).

(b) 

i. First, calculate the diﬀerence in FTE employment between the second and ﬁrst interviews. 
*/

sort state
by state: sum fte1 fte2

scalar empdiffpa= 18.09848 -20.11364
scalar empdiffnj = 17.56228 - 17.27544

/*
ii. Next, calculate the diﬀerence between NJ and PA of the time diﬀerences you just computed. 
*/

scalar didemp= empdiffnj - empdiffpa
di didemp

/*
iii. What is the interpretation of such a diﬀerence-in-diﬀerences estimate of the employment eﬀect? 
What do your estimates tell you? 

This estimate says that employment in NJ fell but not by as much as PA employment increased.

 */
/*v. Under what conditions does this provide a valid estimate of the causal impact of a minimum 
wage increase on relative employment in the fast food industry? 

The Parallel Trends Assumption must hold. The employment trend in the pretreatment period needs
to be the same for both the treatment and control groups.

(c)  i. To run a regression of this speciﬁcation, we need to reshape the data so each observation is
 at the restaurant-time level (known as a long dataset), rather than the restaurant level
 (known as a wide dataset). Run the following command to do this: */
 
 reshape long empft emppt wage_st fte, i(storeid) j(period) 

/*
 ii. Now estimate DD regressions on wages and employment using this regression 
speciﬁcation. */


regress wage_st period##state
regress empft period##state
di "didwage = " didwage " didemp = " didemp

/*
How do the results compare to the straight-forward diﬀerences in means you 
found in parts 3a and 3b? */

/*The results are similar for wages, but vary more by employment. The coefficient
on the straight-forward differences in means is smaller than the regression. The
standard error is also larger in the employment regression and statistically insignifcant
at the .1 level whereas the wage regression has a smaller confidence interval, smaller 
standard error, and is significant at the .01 confidence level.*/

/*
iii. Repeat the two regressions, entering a dummy variable for whether the restaurant is companyowned 
(“co-owned,” as opposed to franchised) and dummy variables for the four chains in the dataset 
(Burger King, KFC, Roy Rogers, and Wendy’s). You can either use i.chain in the regression command 
to have Stata create the dummies for you, or you can manually create them and include them 
separately in the regression command. */

regress wage_st period##state i.chain
regress empft period##state i.chain

/*
iv. Do the results change when you enter the restaurant-speciﬁc covariates?
Would you have expected the results to change? 
Explain why or why not. 

The coefficients and standard errors remain close to the same on the treatment and period
variables. The adjusted R2 increased and the residual decreased in both regressions. 
The constant decreased in both regressions. 

I would expect the results to change if the restaurant chains were correlated to the 
period or state variable. If they were correlated, in the regression without i.chain, 
the correlated variable would also be an endogenous variable, correlated with the error 
term, and have a bias included in the regression coefficient. Since restaurant chains
are "as good as randomly assigned" to states, periods, employment, and wages, the coeff.
on treatment, period, or state do not change. Instead, the effect is included in the 
regression residual and the constant.


*/

/*
v. Suppose that it turned out that some counties in PA had new regulations that the restaurants 
were trying to comply with exactly during this time period. How would that bias the 
results you have just found? (Hint: Recall that a basic assumption behind the simple 
implementation of DiD is that other characteristics are constant over time.)

PA, as the control variable, serves as the counterfactual for NJ. If those regulations 
are correlated with wages and/or employment, and is missing from the regression, the 
counterfactual would bias the estimate of the treatment effect negatively if the regulations
negatively impact employment given that the coefficient on the treatment effect is positive. Minimum
wage laws may prevent the regulations from putting downward pressure on wages. 
If the regulations were to increase wages, then the treatment effect might be 
understated in the regression.

*/ 

/*
i. Would you expect the DD assumptions to be satisﬁed more easily for the within-NJ 
comparison, than for the NJ vs. PA comparison? Why? 

On the one hand, within NJ comparison might homogenize the regulatory environment,
preventing a need to control for it in a regression aslong as NJ doesn't change
any other regulations impacting wages and employment or the federal govt doesn't
change regulations to which restaurants must adhere. 

On the other hand, the restaurants may not be randomly assigned at the city level or
county level. 

*/

/*
ii. Construct an indicator variable low wage st that equals 1 for restaurants paying 
less than $5.00 before the minimum wage increase. Use the following commands to create 
the variable, and also make the variable carry over into the post period observation for 
each restaurant, and verify that the mean of low wage st is 0.77:*/

gen low_wage_st1 = wage_st<5 if period==1
by storeid, sort: egen low_wage_st = max(low_wage_st1) 

sum low_wage_st if state ==1

/*
iii. Estimate DD regressions for wages and employment using this speciﬁcation 
(comparing high and low-wage restaurants in NJ, before and after the minimum wage increase). 
*/

regress wage_st period##low_wage_st i.chain
regress empft period##low_wage_st i.chain

/*
What is the relative impact of the minimum wage on starting wages and employment within NJ? 

The regression shows both an increase in employment (3.529) and wages (.597). Wages is
still significant at the .01 confidence level. Because the coefficient on employment increased more
than the standard error, the significance of the coefficient on employment increased and 
is significant at the .05 confidence level although still insignificant at the .01 confidence level.

iv. How do your within-NJ estimates compare to those obtained in part (c) for the NJ-PA comparison?
The treatment effects of the minimum wage on starting wages and employment are larger in the
within NJ regression than in the PA-NJ regression. Both regressions show a positive effect on 
employment and wages.

/* Question 4) Regression Discontinuity

(a) What are the potential biases of using OLS?

Selection bias: Although we understand the observable characteristics that determined
treatment assignment (pre-program rural income per capita), there may be unobserved
characteristics determining income.

Measurement Error: Measurement error may not be randomized throughout the treatment
and control groups, thus leading to bias. For example, some income information may be
inaccurate, subject to misreporting.

(b) Discuss how you can use the nature of the implementation of China’s 8-7 Plan 
to design a regression discontinuity evaluation of the above.
What is the running variable, and where is the discontinuity? 

Income is the running variable determining treatment at an arbitrary cutoff point.
Although selection and measurement error may arise under a variety of circumstances
including prior knowledge of the government's stimulas plan leading to manipulation 
of the running variable, the running variable can still be used as an IV for treatment
as long as it meets the exclusion assumption that it is only related to the outcome 
variable through its relationship with treatment, it is exogenous and uncorrelated with
the error term, and it is relevant, correlated with treatment. The discontinuity
is at the cutoff point, the poverty line. The discontinuity separates counties above
and below the poverty line, those which are eligible for treatment, and those which are not.

(c) What does the following graph tell you about about how reasonable this strategy is? 
What additional assumptions must be made for the regression discontinuity strategy to be valid?

There is a discontinuity in poor county status from .2 to over .4. Heterogenous treatment
effects may make this significant if counties which receive treatment underrepresented
income to be assigned into the treatment group. These counties may have lower marginal
effects from treatment than the other counties, meaning that income directly effects
treatment outcome around the cutoff and assignment is no longer as good as random.

The assumptions are that there must be no perfect manipulation of the running variable, 
and the running variable must be exogenous, relevant, and must not directly influence
treatment except through its effect on treatment assignment.

 Treatment Assignment needs to be random around the cutoff variable.If observations are able to 
 perfectly manipulate the running variable to receive treatment or if obs can refuse 
 treatment once assigned, the treatment and control groups would be contaminated by noncompliers.
In other words, those randomly assigned to treatment must receive treatment and 
those randomly assigned to the control group must not receive treatment.

(d)
 Your research assistant creates the following graph plotting the ﬁtted relationship
 between log income growth and pre-program log income per capita, both to the left and 
 to the right of the cutoﬀ. Explain what aspects of the graph describe the treatment 
 eﬀect of the 8-7 Plan.

 The observations above the poverty level experienced lower change in log income per
 capita than the observations below the poverty line. The vertical distance at the cutoff
 represents the treatment effect of the plan which is approximately the vertical distance
 between the point just below .75 and around .62. 
 
 (e) Explain what a researcher can do to ensure that any eﬀects along the discontinuity 
 is due to the policy, and not something else that changes at that same cutoﬀ. What does the 
 following ﬁgure tell you about whether or not this concern applies in this context?

 The demographics of the poor counties and the rich counties at the cutoff vary with the running variable.
Thus, we are concerned about heterogenous treatment effects in missing 
 explanatory variables in the regression for which need to be controlled.
 
 The figures describe different demographic distributions between treatment and control groups.
 Specifically, as poverty increases, minority count increases and the populations become less 
 educated, and overall, more impoverished counties are more likely to have a stronger 
 revolutionary base than higher income counties. If the data was as good as random, 
 the demographics at the cutoff would be similar, but in this case they are not.
