/*Debra Ray, Problem Set 2*/
set more off 
clear 
cap log close 

log using probset2.log, replace
use "C:\Users\dray\Downloads\Guns.dta"

gen lvio = ln(vio)

reg lvio shall, robust
di [exp(_b[shall])-1]*100
/*Percentage of violent crime decreases by 35.787005% when there is a shall carry law.
The results are statistically significant.*/

reg lvio shall incarc_rate density avginc pop, robust
di [exp(_b[shall])-1]*100
/*The standard error decreases and the absolute value of the coefficient decreases.
The percentage of violent crime decreases by 32.53536% when there is a shall carry law.
 The results are statistically significant.*/
sort stateid year
xtset stateid year

xtreg lvio (shall incarc_rate density avginc pop), fe robust
di [exp(_b[shall])-1]
/*The effect of shall is no longer statistically significant and 
it is now positive with a larger robust standard error. */
xtreg lvio (shall incarc_rate density avginc pop i.year), fe robust
di [exp(_b[shall])-1]
/*The coefficient got even smaller and is still not statistically significant.*/

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

hausman fe_reg re_reg

/*We reject the null that there are no systematic differences in the coefficients. 
Therere, we would use FE versus RE. */ 
