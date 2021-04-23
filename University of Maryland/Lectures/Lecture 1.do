/* Lecture 1 */

#delimit; /*Tells stata end of line, just for do file*/

clear all;

set more off;

capture log close; /*let's you error in the middle, if there is a log open, 
close it. If not, don't worry about it.*/

describe;

label var dist_cod "District Code";
label var district "District Name";
sort county;
sort county enrl tot;
gsort +county -enrl_tot; /*ascending +, descending -*/

summarize enrl_tot;

summarize enrl_tot, detail;

/*show more detail like percentiles. */

tab stat enrl_tot,  stats(mean sd);

summarize enrl_tot if enrl_tot>=1000;

summarize enrl_tot if county ~= "Los Angeles" /*same thing as exclamation point =*/

/*Regress test scores on student teacher ratio*/

reg testscr str

/*With robust std errors*/

reg testscr str, robust

/*Add ESL percentage*/

reg testscr str el_pct

/* recreate FWL result: Recovering B1 by using the two residual regressions*/
reg str el_pct
predict uhat, resid
reg el_pct testscr
predict uhat2, resid

reg uhat uhat2 
/* predict yhat from #1 and graph observation w/ predicted line*/
reg testscr str
predict yhat

graph twoway (scatter testscr str) (line yhat str)

log close

sysdir /*downloads go to plus*/
