/*Problem Set 2 - Econ 645*/
set more off 
clear 
cap log close 

log using probset2.log, replace
use "C:\Users\dray\Downloads\Guns.dta"

/*
1) Estimate a pooled OLS regression of ln(vio) on shall. Interpret the coefficient on the variable shall.
Are the results statistically significant?

*/

gen lvio = ln(vio)

reg lvio shall, robust
di [exp(_b[shall])-1]*100
/*Percentage of violent crime decreases by 35.787005% when there is a shall carry law.
The results are statistically significant.*/


*2) Add the variables incarc_rate, density, avginc, and pop to the pooled OLS regression 
*in question 1. What happens to the estimated effect of the variable shall when you add 
*these other regressors?  

reg lvio shall incarc_rate density avginc pop, robust
di [exp(_b[shall])-1]*100
/*The standard error decreases and the absolute value of the coefficient decreases.
The percentage of violent crime decreases by 32.53536% when there is a shall carry law.
 The results are statistically significant.*/
 
 /*4) Use xtset to tell Stata you have panel data. Now, use 
the xtreg command to estimate the same model in question 2 (ln(vio) as outcome; 
shall, incarc_rate, density, avginc, and popas regressors), 
but now accountfor state fixed effects.  Does the estimated effect changeon 
the variable shall? */
 
sort stateid year
xtset stateid year

xtreg lvio (shall incarc_rate density avginc pop), fe robust
di [exp(_b[shall])-1]
/*The effect of shall is no longer statistically significant and 
it is now positive with a larger robust standard error. */

/*5) Re-estimate the model in question 4,but now include
 year fixed effects.  What happened to the coefficient on the variable shall.*/

xtreg lvio (shall incarc_rate density avginc pop i.year), fe robust
di [exp(_b[shall])-1]
/*The coefficient got even smaller and is still not statistically significant.*/
/*

 
 Test whether the year dummiesare jointly equal to zero.  
 Use the results of this test to argue whether or not we should include 
 year fixed effects in our model.*/
testparm i.year

/*We reject the null that the coefficients are not jointly significant. Since 
we reject the null, we do want to use the year dummy variable in the regression
because it may be relevant to the dependent variable. Otherwise, the equation 
may suffer from missing variables bias and may bias our coefficients on included
variables, violating exogeneity assumption.*/

xtreg lvio (shall incarc_rate density avginc pop i.year), fe 
estimates store fe_reg

xtreg lvio (shall incarc_rate density avginc pop), re
estimates store re_reg

/*
6) Test whether the random effects model 
 is consistent using a Wu-Hausman test. Based on the results of the test,
 is the fixed effects model preferred to the random effects model? 
 Why or why not? */

hausman fe_reg re_reg

/*We reject the null that there are no systematic differences in the coefficients. 
Therere, we would use FE versus RE. */ 
