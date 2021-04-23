/*==================================================================
==========
 
 Econ 644
 
Class 10 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 10*/

clear all 
log using class10.log, replace
set more off
use ceosalary.dta
/*Mizon-Richard Test in STATA*/
generate lceoten=log(ceoten)
generate lmktval=log(mktval)
regress salary ceoten mktval lceoten lmktval
test (lceoten lmktval)

/*Note: Log terms jointly significant. 
Level-level spec. rejected.*/

/*Davidson-Mackinnon Test in STATA*/
regress salary lceoten lmktval
predict yhat
regress salary ceoten mktval yhat
/*Note: Y-hat significant. Level-level spec. rejected.*/

/*Ramsey Test in STATA*/
regress salary ceoten mktval
estat ovtest
/*Can reject H0. This model has the wrong 
functional form.*/

regress salary c.ceoten##c.ceoten mktval
estat ovtest
/*Cannot reject null will quadratic specification included*/

/*Measurement error in dependent variable*/
regress salary ceoten mktval
generate e = rnormal(0,100)
generate salary_obs=salary+e
regress salary_obs ceoten mktval

/*Note: The coefficients are very similar, but standard errors increase.*/

/*Measurement error in the explanatory variable*/
regress salary ceoten mktval
generate er = rnormal(0,10)
generate ceoten_obs=ceoten+er
regress salary ceoten_obs mktval
/*Note: The coefficient on the mis-measured 
variable has attenuation bias, coef of mktval less
affected.*/

/*Missing Data*/
regress salary ceoten mktval monthbirth
summarize salary ceoten mktval monthbirth
codebook monthbirth
generate m=(monthbirth==.)
recode monthbirth (missing=0), prefix(mz_)
list monthbirth mz_monthbirth if monthbirth!=mz_monthbirth
regress salary m ceoten mktval mz_monthbirth
/*Note: This model allows the use of all observations. 
It does not throw out all the observations that have 
missing monthbirth, but have complete data on 
the other variables.*/

/*Outliers*/
summarize salary, detail
histogram salary, width(100) frequency
graph save Graph class10.gph
graph hbox salary
graph save Graph class10-1.gph
regress salary c.ceoten##c.ceoten mktval if salary<5000

/*robust regression*/
rreg salary c.ceoten##c.ceoten mktval
/*Intuition: Put more weight on estimates
 that are not highly influenced by the outliers.*/

log close
clear all 



