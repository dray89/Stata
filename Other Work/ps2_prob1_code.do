clear
set more off

* Part a
freduse UNRATE
gen tq = qofd(daten)
format tq %tq
collapse UNRATE, by(tq)
tsset tq

gen d_unemp = (UNRATE-L.UNRATE)*4
label var d_unemp "annualized change in unemp"

tempfile unemp
save `unemp'

clear
freduse GDPC1 // RGDP
gen tq = qofd(daten)
format tq %tq
tsset tq
gen g_rgdp = ((GDP/L.GDP)^4-1)*100
label var g_rgdp "annualized growth rate"
merge 1:1 tq using `unemp'
keep if tin(1948q1,2007q4)
keep tq g_rgdp d_unemp
sort tq

gen du = d_unemp

* Part a -- be sure to compare model using an equal number of obs
reg d_unemp L(1/2).d_unemp L(0/2).g_rgdp if _n>4
reg d_unemp L.d_unemp L2.d_unemp g_rgdp L.g_rgdp L2.g_rgdp if _n>4

est store base

* Part b
reg d_unemp L.d_unemp L(0/1).g_rgdp if _n>4
est store fewer

reg d_unemp L(1/3).d_unemp L(0/3).g_rgdp if _n>4
est store more

esttab base fewer more, se aic bic

* Part c
gen Per2 = tin(1984q1,2007q4)
reg d_unemp Per2##c.L(1/2).d_unemp Per2##c.L(0/2).g_rgdp
testparm 1.Per2 Per2#c.L(1/2).d_unemp Per2#c.L(0/2).g_rgdp   // reject --> there is a break

* Part d
reg d_u g if !Per2
di -_b[_cons]/_b[g] // --> 4.2

reg d_u g if Per2
di -_b[_cons]/_b[g] // --> 2.6
