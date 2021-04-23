log close
clear all 
set more off

*  Setup the environment
**************************************
global data "/Users/mafton/Documents/Empirical Analysis II 2018/Homework"
global output "/Users/mafton/Documents/Empirical Analysis II 2018"

log using "$output\Final output.log", replace

**************************************
* Open data
**************************************
use "$data/SMOKE.dta", clear


**************************************
* Q1 
**************************************
reg cigs lcigpric lincome educ age agesq restaurn white

**************************************
* Q2 
**************************************
/*
The coefficients that are statistically significant at 
the 5% significance level are: educ, age, agesq, and restaurn.
We can conclude that from the t-statistics which are greater than
approximately 2 or less than -2. Alternatively, we can also
come to the same conclusion by looking at the 95% CI in the output.
For the variables listed above, the CI excludes the value of 0.
*/

**************************************
* Q3 
**************************************
/*
F-statistic of 6.38 or p-value of 0 tells us that
the null hypothesis that all coefficients are jointly insignificant
(or equal to 0) is rejected. So, the model appears to be valid.
*/
**************************************
* Q4 
**************************************
/*
The R-squared of this regression is 0.0529 (or 5.3%).
It is small so our explanatory variables can only
explain 5.3% of the variation in the number of cigarettes
smoked.
*/

**************************************
* Q5 
**************************************
di 2*_b[age]+2*_b[agesq]*2

* recall that dcigs= beta1*dage + 2*_beta2*age*dage 
* 2 year increase in age leads to an increase of
* 1.5 cigarettes 
* 
**************************************
* Q6 
**************************************
gen educsq = educ*educ
reg cigs lcigpric lincome educ educsq age agesq restaurn white

**************************************
* Q6.1
**************************************
/* 
The model produces a positive coefficient for educ and a 
negative one for educsq. So, this confirms that the number 
of cigarettes smoked per day increases with education 
but at a decreasing rate. In other words, the impact decreases
as one increases years of education.
*/

**************************************
* Q6.2
**************************************
/*
In the previous model, the estimate for educ was -.5.
So, there was a negative correlation between education
and number of cigarettes smoked. In the new model, we
see that the estimate for educ and educsq are approximately 
2.8 and -.13, respectively. So, initially educ has a positive
effect on smoking but as educ increases the effect gets 
smaller and smaller.
*/

**************************************
* Q6.2
**************************************
di abs(_b[educ]/(2*_b[educsq]))

* After about 10.6 years of education, the effect of 
* education on smoking changes sign!

**************************************
* Q7 
**************************************
gen college = (educ>12 & educ<=17)
gen postgrad = (educ>17)
* or generate a categorical variable educlevel
* gen educlevel = 0 if educ<=12
* replace educlevel = 1 if (educ>12 & educ<=17)
* replace educlevel = 2 if educ>17
reg cigs lcigpric lincome college postgrad age agesq restaurn white
* reg cigs lcigpric lincome i.educlevel age agesq restaurn white
/*
The estimate for some college is about -2.4 and the estimate for 
post-graduate is abbout -5.6. Hence, compared to individuals with less
than college education, individuals that have some college experience
smoke 2.4 less cigarettes per day and individuals with post-graduate
education smoke 5.6 less cigarettes per day.
*/

**************************************
* Q8.1
**************************************
reg cigs lcigpric lincome college postgrad age agesq restaurn white, robust

predict uhat,  resid
gen uhatsq = uhat^2

regress uhatsq lcigpric lincome college postgrad age agesq restaurn white

scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

/* 
Given that the LM test statistic is greater than the critical value, 
we reject the null hypothesis that all coefficients in the last
regression are zero. Hence, we reject homoskedasticity.
*/

**************************************
* Q8.2
**************************************
reg cigs lcigpric lincome college postgrad age agesq restaurn white

estat hettest
estat hettest, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, fstat
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid 

* Same conclusion as 9.1 with any of the tests above.
**************************************
* Q8.3
**************************************
* To replicate the test in 8.1, this is the option needed:
reg cigs lcigpric lincome college postgrad age agesq restaurn white
estat hettest lcigpric lincome college postgrad age agesq restaurn white, iid

**************************************
* Q9
**************************************
replace educ=14 if educ==13.5

**************************************
* Q10
**************************************
gen smoke = (cigs>0)
reg smoke lcigpric lincome educ age agesq restaurn white

**************************************
* Q11
**************************************
/*
Probability of an individual in an area with smoking restrictions
at restaurants is approximately 10% lower than an individual in an
area without such restrictions.
*/

**************************************
* Q12
**************************************
di _b[_cons] + 4*_b[lcigpric] + 10*_b[lincome] + 10*_b[educ] + ///
	40*_b[age] + 40*40*_b[agesq] + 1*_b[restaurn] + 1*_b[white] 

**************************************
* Q13
**************************************
logit smoke lcigpric lincome educ age agesq i.restaurn i.white, or

**************************************
* Q14
**************************************
/* 
With odds ratio the estimates are always positive as they represent marginal odds. 
To accurately interpret the odds ratio coefficient:
(_beta - 1)*100. Negative sign indicates decrease in odds- 
happens with estimate < 1. Positive sign indicates increase in odds- happens with estimate  >1. 

The coefficient for "restaurn" appears to have the largest impact 
on the probability of smoking: odds of smoking decreases by about 36.7%
for individuals living in an area with smoking restrictions.
*/

**************************************
* Q15
**************************************
/* 
The odds of smoking decreases by 13% with each year of education.
*/

**************************************
* Q16
**************************************
predict fitted, xb
gen logit_pr = invlogit(fitted)
tabstat logit_pr, by(restaurn) stat(mean)

* You can check your work with the following command:
margins restaurn

**************************************
* Q17
**************************************
probit smoke lcigpric lincome educ age agesq i.restaurn i.white


**************************************
* Q18
**************************************

*get all values of educ 
tab educ 

margins, at(educ= (6 8 10 12 14 15 16 18)) atmeans

* Also will be accepted. However, this is assuming education is categorical!
* So it will give different estimates as in the regression it is included
* as a bunch of dummies, which is different from including as a continuous
* variable.
probit smoke lcigpric lincome i.educ age agesq i.restaurn i.white
margins educ, atmeans

**************************************

log close

*EOF
