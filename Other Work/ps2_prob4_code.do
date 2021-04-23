freduse GDPC1, clear
gen tq = qofd(daten)
format tq %tq
tsset tq
keep if tin(1984q1, 2007q4)

gen g = ((GDPC1/L.GDPC1)^4 - 1) * 100

corrgram g
arima g if _n > 3, ma(1 2)
est store ma2
predict r_ma2, resid
arima g if _n > 3, ma(1/3)
est store ma3
predict r_ma3, resid
arima g if _n > 3, ar(1 2)
est store ar2
predict r_ar2, resid

esttab ma2 ma3 ar2, stat(N aic bic)

corrgram r_ma2
corrgram r_ar2

* I prefer the ma2 to the AR2 because the residuals look more like WN


******
freduse TB3MS, clear
gen tm = mofd(daten)
format tm %tm
tsset tm
keep if tin(1990m1, 2007m12)

arima TB if _n > 4, ar(1/4)
est store ar4
predict r_ar4, resid
arima TB if _n > 4, ar(1) ma(1) 
est store arma
predict r_arma, resid
arima TB if _n > 4, ar(1/3)
est store ar3
predict r_ar3, resid

esttab ar4 arma ar3, stat(N aic bic)
corrgram r_ar4

* AR4 looks good!


*******************
freduse OPHPBS, clear
gen tq = qofd(daten)
format tq %tq
tsset tq
keep if tin(1984q1, 2007q4)

corrgram OPH

arima OPH if _n > 2, ar(1)
est store ar1
predict r_ar1, resid

arima OPH if _n > 2, ar(1) ma(1)
est store arma
predict r_arma, resid

arima OPH if _n > 2, ar(1 2)
est store ar2
predict r_ar2, resid

esttab ar1 arma ar2, stat(N aic bic)
