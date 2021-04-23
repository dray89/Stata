/*CEO Salary and Return to Equity*/
/*CEO Salary and Return to Equity*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\CEOSAL1.dta",clear

*estimate the model

reg salary roe

*obtain fitted values and residuals 
predict fitted ///fitted is the new variable name, it assumes fitted
predict resid, residuals ///resid is the new name, residuals specifies residuals

reg lsalary roe

*examine first 15 observations

list roe salary fitted resid in 1/15

*log-log model

reg lsalary lsales

/*Wage and Education*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\WAGE1.dta",clear

/*we already have log of wage - lwage, but what if we did not*/

gen lgwage = ln(wage)

reg lgwage educ


/*log files*/

*Begin recording your Stata session in mylog.smcl
log using mylog

*As above, but use a text format that can be read by a word processor
log using mylog, text

*Save a subset of output to mylog2.smcl while mylog.smcl is still open
log using mylog2, name(mylog2)

*Close mylog2.smcl and keep mylog.smcl open
log close mylog2

*append to the existing log
log using mylog, append
