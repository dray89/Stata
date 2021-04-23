/*==================================================================
==========
 
 Econ 644
 
Class 8 
 
Debra Ray
 
====================================================================
 ========*/
 
/*Class 8*/

clear all 
log using class8.log, replace
set more off
use ceos.dta

summarize salary

/*Creating Dummy Variables in Stata*/
use ceosalary.dta

generate male = (gender=="M") 

list name gender male in 1/7

tab male
tab male gender
regress salary ceoten male

/*Stata creates all needed explanatory variables using double-hashtag (##).*/
regress salary c.ceoten##male

codebook mstatus

quietly tabulate mstatus, generate (mstatus_)

summarize mstatus_*

regress salary ceoten mstatus_*
/*RECODING VARIABLES*/
/*Describe a variable's contents*/
codebook ceoten

/*Create a binary variable from a continuous variable*/
egen float loyal = cut(ceoten), group(2) icodes

/*Table of Summary Statistics, by New Category*/
tabstat ceoten, statistics( min max count ) by(loyal)

/*Label the Newly Created Variable*/

label variable loyal "above median CEO tenure"

/*Describe the New Variable's Contents*/

codebook loyal 

/*HANDLING DATE VARIABLES*/

/*Create a new variable*/

generate yearbirth=1990-age

/*label the newly created variable*/

label variable yearbirth "year of birth"

/*Create a new variable */
generate birthdate = mdy(monthbirth,daybirth,yearbirth)
label variable birthdate "date of birth"

list birthdate in 1/7

/*Format the date variable*/
format %td birthdate

list birthdate in 1/7

codebook birthdate

summarize sales
describe sales
/*convert from string to numeric*/
destring sales, generate(sales_num)

summarize sales sales_num
describe sales sales_num 

/*If the string variable is made up of letters, then it can be changed from string to numeric 
without changing its letter display. 
what stata does is to assign numeric values together with letter value labels*/

codebook gender

encode gender, generate(gender_num)

codebook gender_num

/*Convert from Numeric to String*/

tostring phone, replace

/*Split the string into substrings*/

generate areacode = substr(phone,1,3) 
generate citycode = substr(phone,4,3) 
generate digits = substr(phone,7,4) 

generate phoneno = "("+areacode+")"+" "+citycode+"-"+digits

drop areacode citycode digits
replace phone = phoneno
drop phoneno
save CEOsalaryNEW.dta, replace 

log close
