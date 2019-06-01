********************************************************************************
* Outliers
* Detect Outliers
* Cook's D
* Run Outlier Robust Regression
********************************************************************************

global depvar = " "
global indvar = " "
global indvar2 = " "
global idvar = " "

********************************************************************************
**** Detect Outliers
********************************************************************************

summarize ${depvar} ${indvar} ${indvar2}

**** Tabulate the five largest and five smallest vallues 
extremes ${depvar} ${indvar} ${indvar2}

**** Graph Outliers
twoway (scatter ${depvar} ${indvar}) (scatter ${depvar} ${indvar2})

graph hbox ${depvar}

reg ${depvar} ${indvar} ${indvar2}
lvr2plot, mlabel(${idvar})

********************************************************************************
**** Cook's D
********************************************************************************
reg ${depvar} ${indvar} ${indvar2}
predict cooksd, cooksd
predict uhat, resid

hist cooksd
sum cooksd, detail
list cooksd ${idvar} if cooksd > r(p95)
sum cooksd if cooksd > 4/_N

********************************************************************************
**** Run Outlier Robust Regression
********************************************************************************
rreg ${depvar} ${indvar} ${indvar2}, gen(weight)
scatter weight uhat

**** calculate appropriate r2
rregfit 
