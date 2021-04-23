#delimit;
clear all;
cap log close;
set more off;

cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\discussions";
log using discussion8.text,  text replace;

use employment_08_09.dta, clear;


gen age2 = age*age;
	
gen ln_earnwke = log(earnwke);
	
gen highSchool = educ_lths+educ_hs;
gen college = educ_somecol + educ_aa+educ_bac;
gen gradSchool = educ_adv;
	
gen white = race == 1;
gen black = race == 2;
gen other = race == 3;
		
reg employed age age2 female black other college gradSchool ln_earnwke, robust;
probit employed age age2 female black other college gradSchool ln_earnwke;
margins, dydx(*) post atmeans;

logit employed age age2 female black other college gradSchool ln_earnwke;
margins, dydx(*) post atmeans;
	

log close;
