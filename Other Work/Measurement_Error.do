*******************************************************************************
* Measurement Error Examples
* Measurement Error in Dependent Variable
* Measurement Error in Independent Variable
*******************************************************************************

global depvar = " "
global indvar = " "
global indvar2 = " "

**** Measurement error in dependent variable
regress ${depvar} ${indvar} ${indvar2}
gen e = rnormal(0,100)
gen ${depvar}_obs = ${depvar} + e
reg ${depvar}_obs ${indvar} ${indvar2}

**** Measurement Error in the explanatory variable & Attenuation Bias
regress ${depvar} ${indvar} ${indvar2}
generate er = rnormal(0,10)
generate ${indvar}_obs = ${indvar} + er
reg ${depvar} ${indvar}_obs ${indvar2}


