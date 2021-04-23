clear all 

use "/Users/mafton/Downloads/income_democracy.dta"

sum dem_ind, detail 
/*.4990732, .5 */
egen dem_mean = mean(dem_ind)
browse dem_mean 

set more off
sort country
by country: sum dem_ind, detail
by country: egen dem_mean_s = mean(dem_ind)
by country: egen gdp_mean = mean(log_gdppc)

graph twoway (scatter gdp_mean dem_mean_s) (lfit gdp_mean dem_mean_s)

xtset country year

/*string variables not allowed*/

xtset code year

xtreg dem_ind log_gdppc, re vce(cluster code)

xtreg dem_ind log_gdppc, fe vce(cluster code)
/*.63168655*/

xtreg dem_ind log_gdppc i.year, fe vce(cluster code)

xtreg dem_ind log_gdppc i.year age_1 age_2 age_3 age_4 age_5 educ log_pop, fe vce(cluster code)

/*The standard error increase, coef became more insigni. and the coef decreased.*/
