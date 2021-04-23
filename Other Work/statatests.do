********************************
* Mis-specification / Functional Form Tests
* Test that nonlinearities are correctly identified in the functional form
* Mizon-Richard Test: Nest both functional forms together in one model and conduct F-test
* Davidson-Mackinnon Test: Nest the fitted values of the nonlinear functional form in the linear model and conduct F-test
* Ramsey (RESET) Functional Form Test: Tests whether a nonlinear functional form has statistical power in explaining the dependent variable
********************************

global depvar = " "
global indvar = " "
global indvar2 = " "

**** Mizon-Richard Test for Mis-specification
generate l${indvar} = ln(${indvar})
generate l${indvar2} = ln(${indvar2})

global lindvars = "l${indvar} l${indvar2}"

regress ${depvar} ${indvar} ${indvar2} ${lindvars}

test ${lindvars}

**** Davidson-Mackinnon Test for Mis-specification in Stata
regress ${depvar} ${lindvars}
predict yhat
regress ${depvar} ${indvar} ${indvar2} yhat

test yhat

**** Ramsey Functional Form Test

regress ${depvar} ${indvar} ${indvar2} 
estat ovtest


