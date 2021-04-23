/*==================================================================
==========
 
 Econ 644
 
Class 9 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 9*/

clear all 
log using class9.log, replace
set more off
use ceosalary.dta
/*Detecting HTRSK by computing conditional variances in sample*/
/*Recode Ceoten into a dummy variable*/
egen float loyal = cut(ceoten), group(2) icodes

/*Compute variance in salary, by loyalty*/
tabstat salary, statistics(var) by(loyal)

/*Create a squared term for ceoten*/
generate ceotensq = ceoten^2

/*Estimate a quadratic model for salary-ceoten*/
regress salary ceoten ceotensq mktval

/*Save the residuals*/
predict uhat, residuals

/*residuals mean, by loyalty*/
tabstat uhat, statistics(mean) by(loyal)

/*MOre loyal CEOs have higher variance and larger 
residuals on average*/

/*Residuals vs Predictor plot*/
rvpplot ceoten, mcolor(black) msymbol(smcircle_hollow)
graph save Graph "/Users/mafton/Documents/School/Econ 644/class 9 graph.gph", replace
/*Beusch Pagen test for HTSK in STATA*/
regress salary ceoten ceotensq mktval
estat hettest

/*or using double hashtag*/

regress salary c.ceoten##c.ceoten mktval
estat hettest

/*Robust OLS estimation Standard Errors in STATA*/
regress salary ceoten ceotensq mktval, vce(robust)

/*WLS in STATA the hard way*/

generate tsalary=salary/sqrt(ceoten)
generate tceoten=ceoten/sqrt(ceoten)
generate tceotensq=ceotensq/sqrt(ceoten)
generate tmktval=mktval/sqrt(ceoten)
generate tcons=1/sqrt(ceoten)

regress tsalary tceoten tceotensq tmktval tcons, noconstant

/*WLS in STATA the easy way*/

regress salary ceoten ceotensq mktval [aweight=1/ceoten]

/*Robust WLS to do valid inference when based on incorrect form of htsk */
regress salary ceoten ceotensq mktval [aweight=1/ceoten], vce(robust)

/*FGLS in STATA*/
regress salary ceoten ceotensq mktval

/*Save the residual*/
predict uhatf, residual 

/*Square and log residuals*/
generate log2= log(uhatf^2) 

/*regress logs of the residuals squared against variables*/
regress log2 ceoten ceotensq mktval

/*Save the fitted values*/
predict log2hat

/*Exponentiate the fitted values*/
generate hhat=exp(log2hat)

/*Estimate the original model using weights*/
regress salary ceoten ceotensq mktval [aweight = 1/hhat]

regress salary ceoten
log close
clear all 
 
