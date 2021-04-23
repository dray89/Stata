#delimit;
clear all;
cap log close;
set more off;

cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\discussions";
log using discussion10.text,  text replace;

use agg_pt, clear;

/* Create a time variable that indexes both year and quarter */
gen yr_qtr = yq(year,qtr);
format yr_qtr %tq;


/* Use this variable and the tsset command */
tsset yr_qtr;

/* Plot pt over time */
graph twoway (line pt yr_qtr);

/*Generate lagged pt */
gen l1pt = L1.pt;
gen l2pt = L2.pt;

/* Reg pt on two lags of itself */
reg pt l1pt l2pt;

/* Detrend/Remove Seasonality from PT */
gen t = _n;
tab qtr, gen(dqtr);
reg pt t dqtr2-dqtr4;
predict pt_dd, res;

gen l1pt_dd = L1.pt_dd;
gen l2pt_dd = L2.pt_dd;

reg pt_dd l1pt_dd l2pt_dd;


/* Frisch-Waugh-Lovell Theorem */
reg testscr el_pct, robust;
predict y_purge, res;

reg str el_pct, robust;
predict x_purge, res;

reg y_purge x_purge, robust;

/* 
(1) Regress student test scores on student to teacher ratio
(2  Predict the fitted values for test scores 
(3) Graph fitted values with original data
*/
reg testscr str, robust;
predict testscr_hat, xb;
graph twoway (scatter testscr str) (line testscr_hat str);

/*
(1) Save as a stata graph 
(2) Save as a pdf file
*/
graph save CAgraph, replace;
graph export "CAgraph.pdf", as(pdf) replace;


 

