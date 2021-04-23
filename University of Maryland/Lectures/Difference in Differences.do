#delimit;
clear all;
cap log close;

/*****************/
/* LECTURE NOTES */
/*****************/
cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\Lectures\Lecture5";
log using lecture5_example.txt, text replace;
use kielmc, clear;

gen close = dist <=20000;
gen close81 = close*y81;
reg lprice close81 close y81, robust;
reg lprice i.close##i.y81, robust;
reg lprice i.close#i.y81, robust;


gen ldist81 = ldist*y81;
reg lprice ldist81 ldist y81, robust;
reg lprice c.ldist##i.y81, robust;



/*********************/
/* IN CLASS EXERCISE */
/*********************/
use cardkrueger94_test, clear;

/* Generate interaction: Note you need to create an indicator variable for year */
gen y_ind = year - 1;
gen styr = state*year;

/* Diff-in-Diff with interaction we created */
reg empft styr state y_ind, robust;

/* Diff-in-Diff with stata interaction */
reg empft i.state##i.year, robust;


cap log close;
