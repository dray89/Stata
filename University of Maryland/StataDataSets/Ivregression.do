
use "WAGE2.DTA", clear

log using wage_ivreg2.log, replace

********************************************************************************
**** Instructional dataset, N=935, cross-sectional data on wages Accompanying 
**** Introductory Econometrics: A Modern Approach, Jeffrey M. Wooldridge, South-Western 
**** College Publishing, (c) 2000 Datasets also accessible from http://wooldridge.swcollege.com.
********************************************************************************

reg educ brthord
test brthord
di "F-stat: " e(F) " Adj-R2: " e(r2_a) " RMSE: " e(rmse)

reg educ sibs
test sibs
di "F-stat: " e(F) " Adj-R2: " e(r2_a) " RMSE: " e(rmse)

***** Siblings has a higher F-stat than brthord

reg educ brthord sibs
test brthord sibs
di "F-stat: " e(F) " Adj-R2: " e(r2_a) " RMSE: " e(rmse)

**** F-stat in regression including both brthord and siblings lower than siblings alone
**** Adj R2 not improved with regression including both brthord and sibs

qui {

ivregress 2sls lwage sibs (educ = brthord)
estimates store e1
noisily di "lwage sibs (educ = brthord) - Chi-2: " e(chi2) " Adj-R2: " e(r2_a) "RMSE: " e(rmse)

ivregress 2sls lwage black tenure (educ= brthord sibs) if e(sample)
estimates store e2
noisily di "lwage black tenure (educ= brthord sibs) - Chi-2: " e(chi2) " Adj-R2: " e(r2_a) " RMSE: " e(rmse)

ivregress 2sls lwage black tenure (educ= sibs) if e(sample)
estimates store e3
noisily di "lwage black tenure (educ= sibs) - Chi-2: " e(chi2) " Adj-R2: " e(r2_a) " RMSE: " e(rmse)

}
**** r2_a improves and chi2 remains the same using only sibs as instrument for education
**** More instruments than endogenous variables; 
**** Inside parenth, the variables are excluded in the 2nd stage but included in the first stage*

estimates table e1 e2 e3, stat(chi2 r2_a rmse) star(.1 .01 .001)
**** The significance of education decreases slightly in magnitude and significance using only sibs as instrument

ivregress 2sls lwage black tenure (educ= brthord sibs) 
estat overid 
**** Test of validity - not overidentified

ivregress 2sls lwage black tenure (educ= sibs) 
estat endogenous 
**** Cannot reject the null that variables are exogenous
estat firststage
**** Exceeds F-stat threshold for relevant instrument and Wald test ratio 

pwcorr lwage educ exper tenure black brthord sibs, star(.01)
corr lwage educ exper tenure black brthord sibs

**** What is the relationship between age, exper, and lwage
sum age exper wage
**** age range 28 - 38
**** exper range 1 - 23

hist age
hist exper 
hist lwage

reg lwage exper age
testparm exper age
testparm exper
testparm age

**** age and exper jointly significant. age individually significant. exper not 
**** individually significant. 

graph bar (mean) wage, over(exper)
graph bar (mean) wage, over(age)

**** What is the relationship between wage, urban, and south?
sum urban south
**** mean of urban .717
**** mean of south .341

reg lwage urban south
testparm urban south
**** urban and south are individually and jointly significant

graph bar (mean) wage, over(urban)
graph bar (mean) wage, over(south)

ivregress 2sls lwage urban south (educ= sibs) 
estat endogenous 
**** Cannot reject the null that variables are exogenous

estat firststage
**** Exceeds F-stat threshold for relevant instrument and Wald test ratio 

ivreg2 lwage married south urban black (educ = sibs brthord) 
**** Sargan stat: Cannot reject the null that the instruments are valid, uncorrelated 
**** with error term and correctly excluded from the estimated equation
**** Underidentification Test: Reject the null that the model is underidentified
**** Weak Identification: Greater than 10% Critical Value, thus instrument relevant

ivreg2 lwage married south urban exper (educ = sibs)
**** Underidentification Test: Reject the null that the model is underidentified
**** Weak Identification: Greater than 10% Critical Value, thus instrument relevant
 
ivreg2 lwage married south urban black exper (educ = brthord) 
**** Underidentification Test: Reject the null that the model is underidentified
**** Weak Identification: F-stat Greater than 10% Critical Value, thus instrument relevant

ivreg2 lwage married south urban exper (educ = sibs black) 
**** Overidentification detected

ivreg2 lwage married urban exper (educ = IQ black) 
**** Reject null of underidentification, F-stat greater than 10% Critical Value
 
log close
