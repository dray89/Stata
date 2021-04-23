cap log close
use "C:\Users\rayde\iCloudDrive\School\StataDataSets\Guns.dta", clear
log using balanced_panel.log, replace
set more off 

********************************************************************************
**** Balanced Panel Data Model
**** Guns.dta: The effect of guns on crime
**** Balanced panel data on 50 US states and DC from 1977 - 1999. From "Shooting
**** Down the 'More Guns Less Crime' Hypothesis" by Prof. John Donohue, Published
**** in Stanford Law Review, 2003, Vol. 55, 1193 - 1312.
********************************************************************************

**** On average, FE models are more likely to underpredict violent crime in states with "shall" before 1995.
**** After 1995, a large drop in actual values makes it more likely that the model will overpredict "shall" 
**** Models 4 - 8 capture more variation in crime rates by year than models 1 - 3 and 9, likely due to percent population composition variables.
**** The models fail to find a statistically significant relationship between "shall" and violent crime.

**** Avg standard error in the FE regressions are lower than RE and OLS
**** Avg standard error in the FE regressions are lowest with no difference between cluster and unclustered errors
**** OLS has the highest average standard errors
**** FE and RE had comparable probabilities of htsk overall and on average, RE P-values are slightly higher than FE
**** OLS had the highest average probability of htsk
**** No difference in average probability of htsk between FE and FE_CL models
**** FE with year dummies have larger average errors than continuous year variable

load

xtset stateid year 
gen lvio = ln(vio)

**** Define models to test
global dep = "lvio"

global model1 = "shall"
**** lowest average resid across all estimation methods
global model2 = "shall incarc_rate density avginc pop"
global model3 = "shall incarc_rate"
**** Third lowest average resid across all estimation methods

global model4 = "shall incarc_rate pb1064 pw1064 pm1029 pop avginc density"
**** Second lowest average resid across all estimation methods
**** Lowest average resid for FE regressions
**** High htsk probability

global model5 = "shall incarc_rate pop pb1064 pw1064 pm1029"
global model6 = "shall incarc_rate avginc pop pb1064 pw1064 pm1029"
global model7 = "shall incarc_rate pb1064 pw1064 pm1029"
global model8 = "shall incarc_rate pw1064 pm1029"
global model9 = "shall incarc_rate pm1029"

**** Run Fixed Effects

forval mod = 1/9 {
            cap drop fe`mod'
            eststo fe_`mod': xtreg ${dep} ${model`mod'}, be
	
            predict fe`mod', stdp
            stderr fe`mod'
			
     
             }
**** Run Fixed Effects with cluster robust standard errors
forval mod = 1/9 {
            cap drop fe`mod'_cl
			cap drop fe`mod'fit 
            eststo fe_`mod'_cl: xtreg ${dep} ${model`mod'}, be
			predict fe`mod'fit 
            predict fe`mod'_cl, resid
            stderr fe`mod'_cl
			
             }
**** Top 3 Fixed Effects Regressions to minimize the probability of error
* shall incarc_rate pb1064 pw1064 pm1029 pop avginc density
* shall
* shall incarc_rate

**** Top 3 FE Regressions to minimize htsk
* shall incarc_rate
* shall
* shall incarc_rate pm1029
			 
**** Run Fixed Effects with cluster robust standard errors and i.year
forval mod = 1/9 {
            cap drop fe`mod'_i
			cap drop fittedi`mod'
            eststo fe_`mod'_i: xtreg ${dep} ${model`mod'} i.year, fe
            predict fe`mod'_i, resid
			predict fittedi`mod'
            stderr fe`mod'_i
			
             }
			 
**** Dummy year variables are significant but increase error

**** Run Fixed Effects with cluster robust standard errors and continuous year			 
forval mod = 1/9 {
            cap drop fe`mod'_yr fitted`mod'
            eststo fe_`mod'_yr: xtreg ${dep} ${model`mod'} year, fe vce(cluster stateid)
            predict fitted`mod'
			predict fe`mod'_yr, resid
            stderr fe`mod'_yr 
			
             }
**** Top 3 models with lowest avg resids for continuous year FE regressions
* shall incarc_rate pm1029
* shall
* shall incarc_rate pop pb1064 pw1064 pm1029

**** Top 3 models to minimize htsk 
* shall incarc_rate
* shall incarc_rate pm1029
* shall incarc_rate avginc pop pb1064 pw1064 pm1029

**** Run Random Effects 
qui {
forval mod = 1/9 {
            cap drop re`mod'_xb
			cap drop re`mod'
            eststo re_`mod': xtreg ${dep} ${model`mod'}, re
			noisily xttest0
            predict re`mod'_xb 
			gen re`mod' = ${dep} - re`mod'_xb
            stderr re`mod'
}
             }
**** Run OLS Regressions
forval mod = 1/9 {
            cap drop ols`mod'
            eststo ols_`mod': reg ${dep} ${model`mod'}, robust
            predict ols`mod', resid
            stderr ols`mod'

             }
**** Compare Coefficients

local replace "replace"
forval mod = 1/9 {
	estimates table fe_`mod' fe_`mod'_cl re_`mod' ols_`mod' fe_`mod'_yr fe_`mod'_i, stats(r2_a r2_w r2_b r2_o F rmse chi2) star(.05 .01 .001)
	esttab fe_`mod' fe_`mod'_cl re_`mod' ols_`mod' fe_`mod'_yr fe_`mod'_i using guns.csv, `replace' scalars(r2_a r2_w r2_b r2_o F rmse chi2) mtitles(fe_`mod' fe_`mod'_cl re_`mod' ols_`mod')
	local replace "append"
	}

**** Coefficients are more consistent in regressions excluding avginc and pop
**** Including year or i.year in FE regressions causes large changes in the coeff on shall, and reduces the significance
**** Larger differences in coefficients excluding year and stateid

**** Hausman Test For Consistency
forval mod = 1/9 {
	lrtest  fe_9 fe_4
}

**** Residual Analysis
forval mod = 1/9 {
	foreach residual in fe`mod' fe`mod'_cl re`mod' ols`mod' fe`mod'_yr fe`mod'_i {
		qui reg `residual' L1.`residual'
		local dep = e(depvar)
		noisily di "`dep' has a F = " e(F) " and r2_a = " e(r2_a)
}
}

**** All residuals exhibit autocorrelation

forval mod = 1/9 {
stderr fe`mod' fe`mod'_cl re`mod' ols`mod' fe`mod'_yr fe`mod'_i
matrix define stderr`mod' = (fe`mod', fe`mod'_cl,  re`mod' ,ols`mod', fe`mod'_yr, fe`mod'_i )
}

forval mod = 1/9 {

lmtest fe`mod' ${model`mod'}
lmtest fe`mod'_cl ${model`mod'}
lmtest re`mod' ${model`mod'}
lmtest ols`mod' ${model`mod'}
lmtest fe`mod'_yr ${model`mod'}
lmtest fe`mod'_i ${model`mod'}

matrix define pvalues`mod' = (pfe`mod', pfe`mod'_cl, pre`mod', pols`mod', pfe`mod'_yr , pfe`mod'_i)

}
putexcel set "output5.csv", replace 

matrix pvalues = pvalues1\pvalues2\pvalues3\pvalues4\pvalues5\pvalues6\pvalues7\pvalues8\pvalues9
matrix rownames pvalues = pvalues1 pvalues2 pvalues3 pvalues4 pvalues5 pvalues6 pvalues7 pvalues8 pvalues9
matrix colnames pvalues =  FE FE_Cluster RE OLS FE-YR FE-IYR

putexcel set "output5.csv", sheet(pvalues) modify
putexcel A1 = matrix(pvalues), names nformat(number_d2)

matrix stderr = stderr1\stderr2\stderr3\stderr4\stderr5\stderr6\ stderr7\ stderr8\ stderr9
matrix rownames stderr = stderr1 stderr2 stderr3 stderr4 stderr5 stderr6 stderr7 stderr8 stderr9
matrix colnames stderr = FE FE_Cluster RE OLS FE-YR FE-IYR

putexcel set "output5.csv", sheet(stderr) modify
putexcel A1 = matrix(stderr), names nformat(number_d2)

matrix list stderr
matrix list pvalues 

forval mod = 1/9 {

bysort shall: sum fe`mod' fe`mod'_cl re`mod' ols`mod' fe`mod'_yr fe`mod'_i
di sum(fe_yr)/e(N) 

}
**** On average, FE models are more likely to underpredict violent crime in states with Shall 
**** Avg standard error in the FE regressions are lower than RE and OLS
**** Avg standard error in the FE regressions are lowest with no difference between cluster and unclustered errors
**** OLS has the highest average standard errors
**** FE and RE had comparable probabilities of htsk overall and on average, RE P-values are slightly higher than FE
**** OLS had the highest average probability of htsk
**** No difference in average probability of htsk between FE and FE_CL models
**** FE with year dummies have larger average errors than continuous year variable

********************************************************************************
**** Check specification
**** natural log variables are not significant
********************************************************************************
**** Create natural log variables
gen lincarc = ln(incarc_rate)
gen lpb = ln(pb1064)
gen lpw = ln(pw1064)
gen lpm = ln(pm1029)
gen lpop = ln(pop)
gen lavginc = ln(avginc)
gen ldensity = ln(density)

xtreg lvio shall lincarc lpb lpw lpm lpop lavginc ldensity, vce(cluster stateid) fe
predict se, resid

xtreg lvio shall lincarc lpop lavginc ldensity, vce(cluster stateid) fe
predict se2, res

stderr se se2 

local mod1 = "shall lincarc lpb lpw lpm lpop lavginc ldensity"
local mod2 = "shall lincarc lpop lavginc ldensity"

lmtest se `mod1'
lmtest se2 `mod2'
