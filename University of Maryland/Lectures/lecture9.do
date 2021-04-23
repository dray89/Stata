/*DEBRA RAY Midterm Review*/
clear all
log close
log using midterm.log, replace
use wage2.dta, clear
set more off
summarize married if urban==1
/*mean=.885 = 88.5% of the sample are both married and live in an urban area.
Therefore the conditional probability of pulling someone who is married given
urban is 88.5%*/
ttest wage=1000
/*reject null; p<.01; mean<1000 with a confidence interval below 1000; it is 
probable that the wage is less than 1000.*/
ci means wage
/*we can say with 95 perc confidence that the mean population wage is between 931 and 983*/
ttest wage, by(urban) level (99)
/*differences between urban and nonurban wage are significant at the 1% level. */
gen hourly_rate = (wage/4)*(1/hours)
tabulate educ
/* 12 years of education and 16 years of education are the most common. most 
people tend to finish high school and less people finish college.
regress lhourly_rate educ*/
/*High t-values = significant*/
/*For every 1 year increase in educ, lhourly_rate increases by .05%*/
/*R-squared = .0658 meaning education only explains about 6% of wage variation
 in the sample - Other variables also contribute and they are contained within 
 the error term. A high or low r-squared doesn't necessarily indicate a better model.
 
 */
regress lhourly_rate educ urban
 /*Yes, the value is contained within the confidence interval.*/
 scalar f = r(F)
 /*Not sure if that is the correct way to run the scalar. but the F statistics
 of regressions are from running a test where all coefficients are equal to zero. 
 When we reject the null, we say that the model has predictive power over the dependent variable 
 small p value.*/
 test urban=0
display sqrt(28.89)

regress lhourly_rate educ
regress lhourly_rate educ urban
display .0529472-0504449
/*the effect of educ on lhourly_rate decreased when we added urban to the regression.
Some of the previously explained variation in the sample that was attributed to educ is no 
longer attributed to educ given the the information contained within the values of urban in 
the same sample*/
