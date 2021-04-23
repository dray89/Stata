use "/Users/mafton/Documents/Empirical Analysis II 2018/DTA/CEOSAL2.DTA", clear

/*1. Estimate the model and interpret the coefficients. Which variable(s) can 
be excluded? 
Explain using adjusted R-Squared*/

reg lsalary lsales lmktval profmarg ceoten  comten
reg lsalary lsales lmktval ceoten comten
reg lsalary lsales ceoten comten

/* 2.  Explore the possibility that CEO's tenure and number of years with company 
have diminishing returns to salary. Use RESET test to determine if there is 
functional form misspecification 
in this model*/
reg lsalary lsales lmktval ceotensq comtensq
ovtest

/*reject null of no functional form misspecification*/

/* 3. Re-estimate the model with new variables from (2). How does the fit of 
the model change? Do we need to account for diminishing returns to salary?*/
reg lsalary lsales lmktval profmarg ceoten ceotensq  comten
ovtest 

/*model fits appropriately*/

/*4 is similar to 3*/

/*Davidson-Mackinnon test for misspecification*/
use "/Users/mafton/Documents/Empirical Analysis II 2018/DTA/CEOSAL2.DTA", clear
/*Regress original model and save the fitted values*/
reg lsalary lsales lmktval profmarg ceoten comten
predict yhat1
/*Regress the alternate model and save the fitted values*/
reg lsalary lsales lmktval profmarg ceoten ceotensq comten comtensq
predict yhat2

/*Regress the original model with yhat2*/
reg lsalary lsales lmktval profmarg ceoten comten yhat2

/*Regress the alternate model with yhat1*/
reg lsalary lsales lmktval profmarg ceoten ceotensq comten comtensq yhat1


/*GPA with robust errors*/

 use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\GPA3.DTA", clear
 
 reg cumgpa sat hsperc tothrs female black white
 
 *add option robust
 reg cumgpa sat hsperc tothrs female black white,robust
 
 /*BP Test for HTSK*/
 use "/Users/mafton/Documents/Empirical Analysis II 2018/DTA/hprice1.dta"
/* Run regression*/
 reg price lotsize sqrft bdrms
/*save residuals*/
 predict uhat, resid
 /*square residuals*/
gen uhatsq = uhat^2
/*run regression of squared residuals on explanatory variables*/
reg uhatsq lotsize sqrft bdrms
/*Find LM statistic rather than F statistic*/
/* multiply sample size by r2 to find LM statistic*/
scalar lm = e(r2)*e(N) 
/*find pvalue using chisq distribution at 2 tail using degrees of freeedom of p-1 
where p is the number of parameters*/
scalar pvalue = chi2tail(e(df_m),lm)
disp "Breusch-Pagan test: lm = " lm ", p-value = " pvalue

/*BP Test with logs - known to have less HTSK*/
/*run regression*/
reg lprice lotsize sqrft bdrms
/*save residuals*/
predict ulhat, resid
/*square residuals*/
gen ulhatsq = ulhat^2
/*run regression of residuals squared on explanatory variables*/
reg ulhatsq lotsize sqrft bdrms
/*Find LM statistic using scalar command and multiplying the sample size by the r2*/
scalar LM = e(r2)*e(N)
/*find pvalue using chi square distribution with df_m degrees of freedom p-1 and LM statistic*/
scalar pvalue = chi2tail(e(df_m), LM)
disp "Breusch-Pagan test: LM = " LM ", p-value = " pvalue

/*White Test for HTSK*/
reg uhatsq lotsize sqrft bdrms
gen lotsize_sq = lotsize^2
gen sqrft_sq = sqrft^2
gen bdrms_sq = bdrms^2
gen lotsqft = lotsize*sqrft
gen lotbdrms = lotsize*bdrms
gen sqrbdrms = sqrft*bdrms

/*Regress the squared residuals from the original model by alll interactions and squares*/
regress ulhatsq lotsize sqrft bdrms c.lotsize#c.lotsize c.sqrft#c.sqrft c.lotsize#c.sqrft c.lotsize#c.bdrms c.sqrft#c.bdrms
reg ulhatsq lotsize sqrft bdrms lotsize_sq sqrft_sq lotsqft lotbdrms sqrbdrms
/*Run LM Test*/
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "BP Test: LM = " LM ", p-value = " pvalue
/*BP Test: LM = 6.9624777, p-value = .54068642*/

/*Alternative white Test*/
/*run regression*/
reg lprice lotsize sqrft bdrms
/*save fitted values and square them*/
predict yhat2
gen yhatsq2 = yhat2^2
/*save residuals and square them*/
predict ulhat2, residuals
gen ulhatsq2 = ulhat2^2
/*regress squared residuals on fitted values and fitted values squared*/
reg ulhatsq2 yhat2 yhatsq2
/*Run LM test*/
scalar LM = e(r2)*e(N)
scalar pvalue = chi2tail(e(df_m),LM)
disp "BP test: LM = " LM ", p-value = " pvalue
/* BP test: LM = 1.0767485, p-value = .58369642*/

/*WLS to fix HTSK*/
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

