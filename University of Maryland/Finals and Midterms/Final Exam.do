/*Debra Ray, Final Exam*/

/*Question 1*/
global data "/Users/mafton/Documents/Empirical Analysis II 2018"
global output "/Users/mafton/Documents/Empirical Analysis II 2018"

log using "$output\Final.log", replace

use "/Users/mafton/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/D5360477-2DD3-438E-A6A5-EB8539AC620C/beauty1.dta"

/*Question 2*/
gen lwage = ln(wage)

reg lwage belavg abvavg educ exper if female==1
/*belavg not statistically significant pvalue higher than .05*/

reg lwage belavg abvavg educ exper if female==0
/*belavg statistically significant; pvalue higher than .05*/

/*Question 3*/
reg lwage belavg abvavg educ exper if female==1

test abvavg = belavg

/*pvalue less than .05, lwage between these two groups are not equal*/

/*Question 4. Yes, when relevant variables are omitted some of the effect they have on the dependent
variable will be attributed to the included variables.*/

/*Question 5*/
ovtest
/*We do not reject the null that there are no omitted variables. 
No form misspecification found using the Ramsey test.*/
/*Question 6*/
gen educsq = educ^2

reg lwage belavg abvavg educ exper educsq expersq if female==1

reg lwage belavg abvavg educ exper educsq expersq if female==0

/*Adj R2 increased, educ and exper at first increase lwage and then start to decrease lwage. 
standard errors increased slightly on educ and exper*/

/*Question 7*/
reg lwage female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service
/*Female is statistically significant and there is a decrease in wage compared to men. abvavg isn't significant in the pooled model but below average looks is. So, being good looking doesn't help 
lwage but being considered bad looking hurts lwage.*/
/*Question 8*/
test union goodhlth black married south bigcity smllcity service
/*Jointly Significant. */
/*Question 9*/
predict uhat, resid

gen uhatsq = uhat^2 

reg uhatsq female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service

scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue
/*pvalue less than .05, heteroskedasticity exists p = .008. FGLS.*/

gen luhatsq = ln(uhatsq)

reg luhatsq female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service

predict fitted

gen hhat = exp(fitted)

wls0 lwage female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service, wvar(hhat) type(loge2) noconst graph
/*blk is no longer signif. The standard error went up on blk and so did the coefficient.*/
/*Question 10*/
reg lwage female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service c.female#c.abvavg c.female#c.belavg

predict uhat2, resid

gen uhatsq2 = uhat2^2 

reg uhatsq2 female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service

scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue
/*Heteroskedastic*/
gen luhatsq2 = ln(uhatsq2)

reg luhatsq2 female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service

predict fitted2

gen hhat2 = exp(fitted2)

gen fbelavg = female*belavg
gen fabvavg = female*abvavg
wls0 lwage female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service fabvavg fbelavg , wvar(hhat2) type(loge2) noconst graph

test fbelavg fabvavg
/*Not jointly significant. pvalue too high*/
/*Question 11*/
use "/Users/mafton/Library/Containers/com.apple.mail/Data/Library/Mail Downloads/4F9D7FC9-E4D4-409C-9BF0-D5604BBCB7E2/beauty2.dta", clear

count if wage==.

/*If part of the population is unobserved, there is an endogenous sample selection bias.
There may be selection factors which partly determine the wage. Therefore the estimators may be biased.*/

heckman lwage female belavg abvavg exper expersq educ educsq union goodhlth black married south bigcity smllcity service c.female#c.abvavg c.female#c.belavg, select(south married female bigcity smllcity goodhlth) twostep
/*lambda doesn't seem to be significant so there doesn't seem to be much of a selection problem. The parameters in the lwage model became insignificant.*/

log close
