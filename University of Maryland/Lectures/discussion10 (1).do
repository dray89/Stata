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
;
reg pt t dqtr2-dqtr4;
predict pt_dd, res;

gen l1pt_dd = L1.pt_dd;
gen l2pt_dd = L2.pt_dd;

reg pt_dd l1pt_dd l2pt_dd;


 

