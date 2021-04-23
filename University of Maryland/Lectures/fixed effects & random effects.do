#delimit;
set more off;
clear all;
cap log close;

cd "G:\%Office of Tax Analysis\_Individual Staff\Ramnath\teaching\Econ 645 Fall 2018\discussions";
log using discussion3.txt, text replace;

use income_democracy, clear;

/* What is the mean and median of the index for democracy */
sum dem_ind, detail;


/* Use the egen command to create a variable 
for the mean democracy index across all countries */
egen dem_average=mean(dem_ind);

sum dem_average dem_ind;

/* Use the egen command to create 
a variable that holds the country specific 
mean of the democracy index */
bysort country: egen dem_c_avg=mean(dem_ind);

/* Use the egen command to create a variable 
that holds the country specific mean for the 
log of per capita GDP. */
bysort country: egen gdp_c_avg=mean(log_gdppc);


/* Create a scatter plot of the variables created in
(3) and (4), i.e plot the country-specific average democracy against 
the country-specific average GDP along with the predicted regression line. */
twoway (scatter dem_c_avg gdp_c_avg) (lfit dem_c_avg gdp_c_avg), 
title("Democracy and Income") subtitle("averages 1960-2000") 
ytitle("Democracy Index") xtitle("Log GDP per capita") 
legend(off);

/* Tell state we have panel data */
xtset code year;

/* Use xtreg to run a random effects regression of the
 democracy indicator on the log of per capita gdp. */

 xtreg dem_ind log_gdppc, re vce(cluster code); 

/* Q: Is it reasonable to make the necessary RE assumption
that country specific heterogeneity is unrelated to 
the log of per capita GDP? */
/* A: It is unlikely that country-specific characteristics would be uncorrelated with  
 GDP per capita, therefore, the RE assumption does not seem reasonable for this model */

 /*	Use xtreg to run a fixed effects regression of the 
democracy indicator on the log of per capita gdp. */
xtreg dem_ind log_gdppc, fe vce(cluster code); 

/* Q: What fraction of the variance in the 
error term is due to variance in the country specific fixed effect? */
/* A: From our FE output, we see that rho = .63168655*/

/* Now include year fixed effects (i.e. year dummy variables) 
in the regression. Test that the year variables are 
jointly equal to 0  */
xtreg dem_ind log_gdppc i.year, fe vce(cluster code); 
test i1965.year i1970.year  i1975.year  
i1980.year i1985.year i1990.year i1995.year i2000.year;

/* Include the controls age_1 through age_5, educ,
 and log_pop in your regression fixed effect regression 
 from question (4). */
xtreg dem_ind log_gdppc i.year age_1-age_5, fe vce(cluster code); 
 
/* Q: What happened to the coefficient on per capita GDP? */
/* A: The coefficient is larger but still statistically insignificant */ 
