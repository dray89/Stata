#delimit;
clear all;
cap log close;

cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\Lectures\Lecture7";

use lecture7_example, clear;

/* Regression below the break */
reg testscore distance if distance < 0;
predict yhat1_b, xb;
scalar alpha_b = _b[_cons];
scalar list alpha_b;

/* Regression above the break */
reg testscore distance if distance >=0;
predict yhat1_a, xb;
scalar alpha_a = _b[_cons];
scalar list alpha_a;

/* Treatment Effect */
scalar tau = alpha_a - alpha_b;
scalar list tau;

/* Treatment effect estimated in one regression */
gen trt = (distance >= 0)
gen trt_dist = distance*trt
reg testscore trt trt_dist distance

/* Different bandwidths */
reg testscore trt trt_dist distance if abs(distance) <=.2;
reg testscore trt trt_dist distance if abs(distance) <=.02;


quietly: reg testscore distance if distance < 0 & abs(distance) <=.2;
predict yhat2_b, xb;
reg testscore distance if distance >=0 & abs(distance) <=.2; 
predict yhat2_a, xb;

snapshot save; /* 1 */

collapse (mean) yhat*_a yhat*_b testscore, by(distance);

graph twoway (scatter testscore distance, msymbol(Oh) mcolor(gray)) 
(line yhat1_a distance if distance >=0, lcolor(black) lpattern(_)) 
(line yhat1_b distance if distance <=0, lcolor(black) lpattern(_)), 
xline(0,lcolor(black) lpattern(_)) legend(label(1 "Actual") label(2 "Predicted") order(1 2))
ytitle("Average Test Score") xtitle("Dist to Cutoff");

graph twoway (scatter testscore distance, msymbol(Oh) mcolor(gray)) 
(line yhat1_a distance if distance >=0, lcolor(black) lpattern(_)) 
(line yhat1_b distance if distance <=0, lcolor(black) lpattern(_)) 
if abs(distance)<=.2, xline(0,lcolor(black) lpattern(_)) 
legend(label(1 "Actual") label(2 "Predicted") order(1 2))
ytitle("Average Test Score") xtitle("Dist to Cutoff");

graph twoway (scatter testscore distance, msymbol(Oh) mcolor(gray)) 
(line yhat1_a distance if distance >=0, lcolor(black) lpattern(_)) 
(line yhat1_b distance if distance <=0, lcolor(black) lpattern(_)) 
(line yhat2_a distance if distance >=0, lcolor(green) lpattern(_)) 
(line yhat2_b distance if distance <=0, lcolor(green) lpattern(_)) 
if abs(distance)<=.2, xline(0,lcolor(black) lpattern(_)) 
ytitle("Average Test Score") xtitle("Dist to Cutoff")
legend(label(1 "Actual") label(2 "Predicted, All")  
label(4 "Predicted, h=.2")order(1 2 4));


/* Class Example */
use adkw, clear;


gen dist = (dbirwt - 1500)/100
gen vlbw = (dbirwt < 1500)


gen nvlbw = (1-vlbw)
gen vlbw_dist_b = (vlbw*(dbirwt - 1500))/100
gen vlbw_dist_a = ((1-vlbw)*(dbirwt- 1500))/100

reg death1year vlbw vlbw_dist_a vlbw_dist_b, robust
reg death1year vlbw dist vlbw_dist_a, robust

/* Replicate rdrobust */
/* Note the rdrobust identifies the indicator as above the cutoff */
/* compare output from rdrobust to coefficient on nvlbw */
rdrobust death1year dist, c(0) p(1) kernel(uniform)
scalar bw_b = e(h_l)
scalar bw_a = e(h_r)
reg death1year nvlbw dist vlbw_dist_a if dist>-bw_b & dist<bw_a, robust



