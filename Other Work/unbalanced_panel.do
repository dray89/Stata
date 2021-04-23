********************************************************************************
* Unbalanced Panel Data Models
* Income_Democracy.dta: The effect of democracy on income
********************************************************************************
cap log close 

set more off

use "C:\Users\rayde\iCloudDrive\School\StataDataSets\income_democracy.dta", clear

log using unbalanced_panel.log, replace

********************************************************************************
**** Income_Democracy.dta: The effect of democracy on income
**** Unbalanced panel data on 195 countries from 1960 - 2000. From "Income & Democracy"
**** By Prof. Daron Acemoglu, Published in American Economic Review, 2008, 98:3: 808-842
********************************************************************************


load

**** Define ID & Time Variables

global id = "code"
global time = "year"
xtset ${id} ${time}

**** Define Dependent Variable
global dep = "dem_ind"

generate miss_educ = (educ==.)
generate miss_gdp  = (log_gdppc == . )
generate miss_pop  = (log_pop == .)

sum code dem_ind if miss_gdp !=0 & miss_educ !=0
**** 224 observations left after accounting for missing values
**** Education, Dem_ind, GDP, and POP all contain missing values


**** Recode the variable with incomplete data turning all missing values to zeros
recode educ (. = 0), prefix(mz_)
recode log_gdppc (. = 0), prefix(mz_)
recode log_pop (.=0), prefix(mz_)
 
**** Run Regression including the recoded variable and an indicator for the missing data
**** mz_${incomplete} miss_ind

********************************************************************************
**** Define models to test
********************************************************************************

global model1 = "i.year mz_educ miss_educ mz_log_gdppc miss_gdp mz_log_pop miss_pop"
global model2 = "i.year mz_log_gdppc miss_gdp mz_educ miss_educ"
global model3 = "i.year mz_educ miss_educ"
global model4 = "i.year mz_log_gdppc miss_gdp"
global model5 = "mz_log_gdppc miss_gdp mz_educ miss_educ"
global model6 = "mz_log_gdppc miss_gdp"


forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			capture noisily: testparm i.year
			predict fe`mod', resid
            stderr fe`mod'
			}
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

global model1 = "year mz_educ miss_educ mz_log_gdppc miss_gdp mz_log_pop miss_pop" 
global model2 = "year mz_log_gdppc miss_gdp mz_log_pop miss_pop"
global model3 = "year mz_educ miss_educ mz_log_pop miss_pop" 
global model4 = "year mz_educ miss_educ"
global model5 = "mz_educ miss_educ mz_log_pop miss_pop"
global model6 = "mz_log_gdppc miss_gdp mz_log_pop miss_pop"

forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			capture noisily testparm year
			capture noisily testparm mz_log_pop miss_pop
			else display "skip"
            predict fe`mod', resid
            stderr fe`mod'

             }
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

**** Continuous year variable holds less statistical power than year dummy variables based on testparm
**** mz_log_pop & miss_pop are not jointly significant when included with i.year variables but are jointly significant when included with only continuous year variable

global model1 = "year educ log_gdppc log_pop"
global model2 = "year educ log_gdppc"
global model3 = "year log_gdppc log_pop"
global model4 = "year log_pop"
global model5 = "year educ log_pop"
global model6 = "year educ"

forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			capture noisily testparm year
            predict fe`mod', resid
            stderr fe`mod'

             }
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

**** Year loses statistical power when included with education
**** log_pop loses statistical power when included with other variables

global model1 = "i.year educ log_gdppc log_pop"
global model2 = "i.year educ log_gdppc"
global model3 = "i.year log_gdppc log_pop"
global model4 = "i.year educ log_pop"
global model5 = "educ log_gdppc"
global model6 = "educ"

forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			capture noisily testparm i.year
			capture noisily testparm log_gdppc log_pop
			capture noisily testparm educ log_pop
            predict fe`mod', resid
            stderr fe`mod'

             }
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

**** model including i.year and without missing variable controls have a lower statistical probability of bias

global model1 = "i.year educ log_gdppc"
global model2 = "i.year educ"
global model3 = "i.year log_gdppc"
global model4 = "log_gdppc educ"
global model5 = "log_gdppc"
global model6 = "educ"

forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			capture noisily testparm i.year
			capture noisily testparm log_gdppc educ
			capture noisily testparm i.year educ
			cap noisily testparm i.year log_gdppc
            predict fe`mod', resid
            stderr fe`mod'

             }
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

********************************************************************************

sum dem_ind, detail

bysort country: sum dem_ind, detail
bysort country: egen gdp_mean = mean(log_gdppc)
bysort country: egen dem_mean_s = mean(dem_ind)

graph twoway (scatter gdp_mean dem_mean_s) (lfit gdp_mean dem_mean_s)
	
********************************************************************************
* Fixed Effects 
********************************************************************************

forval mod = 1/6 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, fe
			cap noisily testparm i.year
            predict fe`mod', resid
            stderr fe`mod'

             }
			 
estimates table fe_1 fe_2 fe_3 fe_4 fe_5 fe_6, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)

********************************************************************************
* Random Effects
********************************************************************************

forval mod = 1/6 {
            cap drop re`mod'
            eststo re_`mod': xtreg ${dep} ${model`mod'}, re
            predict re`mod', stdp
            stderr re`mod'

             }
local replace "replace"
forval mod = 1/6 {
	estimates table fe_`mod' re_`mod', stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)
	esttab fe_`mod' re_`mod' using dem.csv, `replace' scalars(r2_a r2_w r2_b r2_o F rmse chi2) mtitles(fe_`mod' fe_`mod'_cl re_`mod' ols_`mod')
	local replace "append"
	}

****** Consistency 
forval mod = 1/6 {

	hausman fe_`mod' re_`mod'

}

**** Residual Analysis

qui {
forval mod = 1/6 {
	foreach residual in fe`mod' re`mod' {
		cap drop lag
		bysort year: gen lag = `residual'[_n-1]
		reg `residual' lag
		local dep = e(depvar)
		noisily di "`dep' has a F = " e(F) " and r2_a = " e(r2_a)

		}

		}

		}
**** low f values, no autocorrelation detected
forval mod = 1/6 {

stderr fe`mod' re`mod' 

matrix define stderr`mod' = (fe`mod',  re`mod')


}

forval mod = 1/6 {
	foreach m in fe re {

	lmtest `m'`mod' ${model`mod'}

}

}
forval mod = 1/6 {

	matrix define pvalues`mod' = (pfe`mod',  pre`mod')

}


matrix pvalues = pvalues1\pvalues2\pvalues3\pvalues4\pvalues5\pvalues6
matrix rownames pvalues = pvalues1 pvalues2 pvalues3 pvalues4 pvalues5 pvalues6
matrix colnames pvalues =  FE RE

putexcel set "dem_output1.csv", sheet(pvalues) modify
putexcel A1 = matrix(pvalues), names nformat(number_d2)

matrix stderr = stderr1\stderr2\stderr3\stderr4\stderr5\stderr6
matrix rownames stderr = stderr1 stderr2 stderr3 stderr4 stderr5 stderr6
matrix colnames stderr =  FE RE

putexcel set "dem_output1.csv", sheet(stderr) modify
putexcel A1 = matrix(stderr), names nformat(number_d2)

matrix list stderr
matrix list pvalues 
