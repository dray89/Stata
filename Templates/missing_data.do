********************************************************************************
* Missing Data
* Remodel with an indicator variable for the missing values
* Variable Generation, Math Computation
* Rectangularize Dataset
********************************************************************************

global depvar = " "
global indvar = " "
global indvar2 = " "
global incomplete = " "

********************************************************************************
**** Remodel with an indicator variable for the missing values
********************************************************************************

reg ${depvar} ${indvar} ${indvar2} ${incomplete}
summarize ${depvar} ${indvar} ${indvar2} ${incomplete}
codebook ${incomplete}

generate miss_ind = (${incomplete}==.)

**** Recode the variable with incomplete data turning all missing values to zeros
recode ${incomplete} (miss_ind = 0), prefix(mz_)
list ${incomplete} mz_${incomplete} if ${incomplete}!= mz_${incomplete}


**** Run Regression including the recoded variable and an indicator for the missing data
reg ${depvar} ${indvar} ${indvar2} mz_${incomplete} miss_ind


********************************************************************************
**** Variable Generation, Math Computation
********************************************************************************

egen add_rows = rowtotal(${indvar} ${indvar2} ${incomplete}) 
egen avg_rows = rowmean(${indvar} ${indvar2} ${incomplete})
egen count_miss = rowmiss(${indvar} ${indvar2} ${incomplete})

gen newvar = cond(${incomplete}< 1, 1, 0) if ${incomplete}!=0
gen newvar = (${incomplete}< 1) if ${incomplete}!=0

********************************************************************************
**** Rectangularize Dataset
********************************************************************************

fillin ${indvar} ${incomplete}

**** If applicable:
replace ${indvar2} = 0 if _fillin
