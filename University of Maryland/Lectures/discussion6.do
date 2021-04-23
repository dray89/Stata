log close
clear all 
set more off 
log using disc6.log, replace
use "C:\Users\dray\Downloads\discussion6_data.dta", clear

/*(1) Collapse the data to average test score by the distance variable using the 
collapse command in Stata.  This may be a new command that you haven't used before, 
so I urge you to check the Stata help file (you can type help collapse into the command line).  */

collapse (mean) meantest=testscore, by(distance)

/*(2) After collapsing the data, run two regressions and generate predicted values:*/

/*a) Regress testscore on distance when distance is less than zero*/
regress meantest distance if distance<0
predict fittedless
/*b) Regress testscore on distance when distance is greater than or equal to zero*/
regress meantest distance if distance>=0
predict fittedgreater

/*(3) Generate a scatter plot of testscore and distance and add the predicted values from the regressions in 
(2a) and (2b).*/

twoway (scatter meantest distance, sort) (lfit meantest distance if distance<0)(lfit meantest distance if distance>=0), ytitle(Mean Test Score by Distance) xtitle(Distance) title(Average Test Score by Distance)
