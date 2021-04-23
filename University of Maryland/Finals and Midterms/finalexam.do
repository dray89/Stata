cap log close
clear all 
log using finalexam.log, replace
use "C:\Users\dray\Downloads\RDdata.dta"

/*a) Effect of elig on the probability of college attendance */

gen D_above = 1 if testscore >=0
replace D_above = 0 if testscore<0
gen trt_test = testscore*D_above
gen sample = 1 if abs(testscore)<=2
replace sample = 0 if abs(testscore)>2

regress attnd_college D_above trt_test wage if sample==1

reg attnd_college testscore wage trt_test if sample==1 
predict yhat2_b, xb
reg attnd_college testscore wage trt_test if sample==1
predict yhat2_a, xb

graph twoway (scatter attnd_college testscore, msymbol(Oh) mcolor(gray))  (line yhat2_a testscore if testscore>=0, lcolor(green) lpattern(_)) (line yhat2_b testscore if testscore<0, lcolor(green) lpattern(_)) if abs(testscore)<=2, xline(0,lcolor(black) lpattern(_)) ytitle("Average Test Score") xtitle("Dist to Cutoff")legend(label(1 "Actual") label(2 "Predicted, All")  label(4 "Predicted, h=2")order(1 2 4))
clear all
use "C:\Users\dray\Downloads\RDdata.dta"

gen D_above = 1 if testscore >=0
replace D_above = 0 if testscore<0
gen trt_test = testscore*D_above
gen sample = 1 if abs(testscore)<=10
replace sample = 0 if abs(testscore)>10


ivregress 2sls attnd_college (testscore=D_above) wages if sample ==1, first

clear all 
use "C:\Users\dray\Downloads\matchingdata.dta"

set seed 123456
gen u=uniform()
sort u
probit d age black hisp nodegree marr re74 re75
predict pscorea
psmatch2 d, outcome(re78) pscore(pscorea) n(3) common
histogram pscorea, start(0.0) width(0.05) by(d, col(1))
