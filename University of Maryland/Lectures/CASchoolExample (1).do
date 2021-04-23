/*
University of Maryland
Econ 645, Fall 2018

Shanthi Ramnath
Aug 30, 2018

This file introduces some basic commands in Stata.

*/

/*
(1) Set delimiter to ";" to let Stata know the end of a line (optional)
(2) Clear all information from Stata's memory.
(3) Set more off. 
(4) Allows you to run the "log close" command even if there is no log open 
*/

#delimit;
clear all;
set more off;
capture log close;

/*
(1) Change directory to desired place -- note this will look different depending on if you have a PC or mac
(2) Start a log file containing the output for this program.  
(3) Use the Stata data file caschool.dta. -- the clear option ensures that you close any datasets that may already be open
*/

cd "/Users/shanthi/Desktop/teaching 645/CA example";
log using CASchoolExample.txt, text replace;
use caschool.dta, clear;


/* 
(1) Describe the dataset
(2) Describe two specific variables 
*/
describe;
describe dist_cod county;


/*
(1) Label the 'dist_cod' variable as 'District Code'.
(2) Label the 'district' variable as 'District Name'.
(3) Describe the variables in the dataset.
*/

label var dist_cod "District Code";
label var district "District Name";
describe;

/*
(1) Sort the data alphabetically (from A to Z) based on the county name ('county'). The -sort- command sorts in ascending order.
(2) Sort the data alphabetically (from A to Z) first based on the county name ('county'), 
then, within county, by districts in ascending order (with the smallest enrollment ('enrl_tot') listed first then on to the largest enrollment last).
(3) Same as (2) but sort districts from largest enrollment to smallest enrollment.  
The -gsort- command sorts the variable 'x' in ascending order if written '+x' and descending order if written '-x'.
*/

sort county;
sort county enrl_tot;
gsort +county -enrl_tot;



/*
There are a number of ways to produce summary statistics.  
(1) Summarize the total enrollment level (enrl_tot) across the school districts in the dataset.
(2) Summarize (with more detail) the total enrollment level (enrl_tot) across the school districts in the dataset.  Adding ", detail" produces percentiles, e.g., the 25th percentile, the median, the 99th percentile), the variance, skewness, and kurtosis.)
(3) Summarize (using the command 'tabstat', which displays a table of summary statistics) the total enrollment level (enrl_tot) across the school districts in the dataset.  You can choose the particular statistics you want displayed.  I have chosen the mean; standard deviation; the min; the max; the 10th, 25th, 50th (median), 75th, and 90th percentiles.
*/
summarize enrl_tot;
summarize enrl_tot, detail;
tabstat enrl_tot, stats(mean sd min p10 p25 p50 p75 p90 max);

/*
(1) Summarize the total enrollment level (enrl_tot) across school districts in Los Angeles County.
(2) Produce the mean, standard deviation, min, median, and max enrollment (enrl_tot) across the school districts in Los Angeles County.
(3) Summarize the total enrollment level (enrl_tot) across school districts NOT in Los Angeles County.
(4) Summarize the total enrollment level (enrl_tot) across school districts in Los Angeles County and Orange County.  (Note, the code is saying to use the observation if the county is Los Angeles or if the county is Orange.  If you tried instead to use '&' instead of '|', you would have no observations, for there are no districts that are defined simultaneously to be in Los Angeles County and Orange County.)
*/
summarize enrl_tot if county == "Los Angeles";
tabstat enrl_tot if county == "Los Angeles", stats(mean sd min p50 max);
summarize enrl_tot if county ~= "Los Angeles";
summarize enrl_tot if (county == "Los Angeles" | county == "Orange");

/*
(8) Summarize the total enrollment level (enrl_tot) across school districts with an enrollment of at least 1,000 students.
(9) Summarize the total enrollment level (enrl_tot) across school districts with an enrollment of between 1,000 and 2,000 students (inclusive).
(10) Summarize the total enrollment level (enrl_tot) across school districts NOT in Los Angeles County with an enrollment of between 1,000 and 2,000 students (inclusive).
*/

summarize enrl_tot if enrl_tot >= 1000;
summarize enrl_tot if (enrl_tot >= 1000 & enrl_tot <= 2000);
summarize enrl_tot if county != "Los Angeles" & (enrl_tot >= 1000 & enrl_tot <= 2000);


/* 
(1) Regress student test scores on student to teacher ratio
(2) Same regression with robust standard errors
(2) Same regression with robust standard errors and the percentage of ESL students
*/

reg testscr str;
reg testscr str, robust;
reg testscr str el_pct, robust;

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



/*
(1) Close the log file.
*/
log close

/*
END OF PROGRAM
*/
