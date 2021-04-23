/*==================================================================
==========
 
 Econ 644
 
Class 7 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 7*/


clear all 
log using class7.log, replace
set more off
use ceos.dta
/*Rescale salary*/
generate salarydol = salary*1000
regress salarydol ceoten
/*Rescale ceoten*/
generate ceotenmon = ceoten*12
regress salary ceotenmon

/*Standardizing Regression Coefficients in STATA; z scores*/
regress salary ceoten age grad mktval
regress salary ceoten age grad mktval, beta

/*Note the standardized model does not have an intercept*/

regress salary ceoten age

regress salary ceoten age college

regress salary ceoten age

regress salary ceoten age college grad

test (college grad)

generate ceotensq = ceoten^2

label variable ceotensq "ceoten^2"

generate ceoten_mktval = ceoten*mktval

label variable ceoten_mktval "ceoten*mktval"

generate lsalary = ln(salary)

label variable lsalary "ln(salary)"


/*Create a Random Sample from a Probability Distribution*/
generate stdnorm = rnormal()
/*mean of 3 and std of 10*/
generate norm = rnormal(3,10)
/*degress of freedom 50*/
generate chisq = rchi2(50)
/*120 degrees of freedom*/
generate t = rt(120)

summarize stdnorm norm chisq t

generate fname = word(name,1)

generate lname = word(name,2)

label variable fname "first name"
label variable lname "last name"

generate caplname = upper(lname)

generate fullname = fname+" "+caplname

label variable fullname "full name of CEO"

list fullname in 1/7

drop name fname lname caplname

order fullname, first

save ceosnew.dta, replace

log close 

clear all 
