#delimit;
clear all;
cap log close;


cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\Lectures\Lecture4";
log using lecture4_reshape.txt, text replace;
use rental_wide, clear;

/*Reshape data from wide to long */
reshape long pop rent avginc pctstu, i(city) j(year);

xtset city year;

gen lnrent = ln(rent);
xtreg lnrent avginc pctstu, fe;
estimates store fe_reg;

xtreg lnrent avginc pctstu, re;
estimates store re_reg;

/* Hausman Test */
hausman fe_reg re_reg;

estimates clear;

reshape wide pop lnrent rent avginc pctstu, i(city) j(year);
