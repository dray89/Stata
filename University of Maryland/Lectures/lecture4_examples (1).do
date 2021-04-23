#delimit;
clear all;
cap log close;


cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\Lectures\Lecture4";
log using lecture4_example.txt, text replace;
use seatbelts, clear;

sort fips year;
xtset fips year;

gen pct_sb_use=sb_useage*100;
histogram pct_sb_use if year<=1990, bin(10) title("If 1983<=year<=1990");
graph export hist_1.png, as(png) replace;
histogram pct_sb_use if year<=1997 & year>1990, bin(10) title("If 1990<year<=1997");
graph export hist_2.png, as(png) replace;

bysort year: egen mean_sbuse=mean(pct_sb_use);
bysort year: egen mean_fatality=mean(fatalityrate);
twoway (connected mean_sbuse year, yaxis(1)) (connected mean_fatality year, yaxis(2));
graph export sbusefr.png, as(png) replace;

xtreg fatalityrate sb_useage, fe;
estimates store fe_reg;

xtreg fatalityrate sb_useage, re;
estimates store re_reg;

hausman fe_reg re_reg;

xtreg fatalityrate sb_useage, fe vce(cluster state);
xtreg fatalityrate sb_useage speed65 speed70 ba08 drinkage21 income, fe vce(cluster state);
xtreg fatalityrate sb_useage speed65 speed70 ba08 drinkage21 income i.year, fe vce(cluster state);
testparm i.year;

ivregress 2sls fatalityrate (sb_useage = primary secondary), vce(cluster state);

ivreg2 fatalityrate (sb_useage = primary secondary), robust cluster(state);
ivreg2 fatalityrate speed65 speed70 ba08 drinkage21 income (sb_useage = primary secondary), robust cluster(state);
ivreg2 fatalityrate speed65 speed70 ba08 drinkage21 income i.fips i.year (sb_useage = primary secondary), robust cluster(state);



