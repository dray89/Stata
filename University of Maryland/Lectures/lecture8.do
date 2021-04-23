/*Discussion 6*/

/*1. Estimate the model and interpret the coefficients. Which variable(s) can 
be excluded? 
Explain using adjusted R-Squared*/

reg lsalary lsales lmktval profmarg ceoten comten

/* 2.  Explore the possibility that CEO's tenure and number of years with company 
have diminishing returns to salary. Use RESET test to determine if there is 
functional form misspecification 
in this model*/

ovtest 
/*reject null of no functional form misspecification*/

/* 3. Re-estimate the model with new variables from (2). How does the fit of 
the model change? Do we need to account for diminishing returns to salary?*/
reg lsalary lsales lmktval profmarg ceoten ceotensq  comten
ovtest 
/*model fits appropriately*/

/*4 is similar to 3*/

/*5 Use Davidson-MacKinnon test to determine whether the initial or model 
in (2) is preferred. */
reg lsalary lsales lmktval profmarg ceoten comten
predict yhat1

reg lsalary lsales lmktval profmarg ceoten ceotensq comten comtensq 
predict yhat2

reg lsalary lsales lmktval profmarg ceoten comten yhat2
reg lsalary lsales lmktval profmarg ceoten ceotensq comten comtensq yhat1

/*We prefer the second model as ovtest confirmed earlier*/
****Any d-M test w/ nest models will show yhat2 as omitted bc of colinearity
****To actually get estimates, need non-nested models****

/*GPA with robust errors*/

 use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\GPA3.DTA", clear
 
 reg cumgpa sat hsperc tothrs female black white
 
 *add option robust
 reg cumgpa sat hsperc tothrs female black white,robust
 
 /*Breusch-Pagan (BP) test*/
 
 
 use "your dir\HPRICE1.DTA", clear
 
reg price lotsize sqrft bdrms

/*obtain residuals*/
predict uhat, resid

/*obtain squared residuals*/

gen uhat_sq = uhat^2

/*regress u_hat_sq on the explanatory variables*/

reg uhat_sq lotsize sqrft bdrms
***wanna make sure correlation between all these variabes and uhat_sq = 0
***use F-test

/*we can also calculate LM statistic*/

scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

/*F-stat 5.34 with p-value of 0.0020, LM- stat 14.09 with p-value 0.002 - we reject null of no heteroskedasticity*/

/* BP Test now using log of price - models with logs are known to have smaller degree of 
heteroskedasticity*/
reg lprice lotsize sqrft bdrms

/*obtain residuals*/
predict ulhat, resid

/*obtain squared residuals*/

gen ulhat_sq = ulhat^2

/*regress uhat_sq on the explanatory variables*/

reg ulhat_sq lotsize sqrft bdrms

/*we can also calculate LM statistic*/

scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

* we now not able to reject the null - i.e. the model has no heteroskedasticity

/*White Test*/

*squares
gen lotsize_sq = lotsize^2
gen sqrft_sq = sqrft^2
gen bdrms_sq = bdrms^2

*interactions
gen lotsqft = lotsize*sqrft
gen lotbrms = lotsize*bdrms
gen sqrbrms = sqrft *bdrms

*run regression
reg ulhat_sq lotsize sqrft bdrms lotsize_sq sqrft_sq bdrms_sq lotsqft lotbrms sqrbrms

*obtain LM-stat
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

* we now not able to reject the null - i.e. the model has no heteroskedasticity

/*Alternative White Test*/
reg lprice lotsize sqrft bdrms

*obtain fitted values and their squares

predict yhat
gen yhat_sq = yhat^2

/*regress ulhat_sq on fitted values and their squares*/
reg ulhat_sq yhat yhat_sq 

*obtain LM-stat
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

*same conclusion as above

/*weighted least squares in STATA*/

*install package wls0 
findit wls0

use "https://stats.idre.ucla.edu/stat/stata/ado/analysis/hetdata", clear

regress exp age ownrent income incomesq

rvpplot income, yline(0) scheme(lean1)

*The residual versus income plot shows clear evidence of heteroscedasticity.
* Let's try a WLS weighting proportional to income. 
*The WLS type, abse, uses the absolute value of the residuals and in this case no constant.

wls0 exp age ownrent income incomesq, wvar(income) type(abse) noconst graph

*can try for different weighting variables
wls0 exp age ownrent income incomesq, wvar(income incomesq) type(abse) noconst graph

*can try for different WLS type (e.g. log of squared of residuls)
wls0 exp age ownrent income incomesq, wvar(income incomesq) type(loge2) graph


/*FGLS*/

*Run OLS and obtain residuals 
regress exp age ownrent income incomesq
predict uhat, resid

*create log of squared residuals

gen lnuhatsq = ln(uhat^2)

*Run OLS with lnuhatsq and obtaim fitted values g

reg lnuhatsq age ownrent income incomesq
predict g

*generate h_hat

gen hhat = exp(g)

*estimate the model with WLS using weight hhat
wls0 exp age ownrent income incomesq, wvar(hhat) type(abse) noconst graph


