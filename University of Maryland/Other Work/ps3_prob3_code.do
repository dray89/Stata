clear
freduse USACPICORQINMEI GDP GDPPOT
rename USACPI cpi
keep if inrange(year(daten),1960,2009)
gen tq = qofd(daten)
format tq %tq
duplicates report tq
tsset tq

gen pi = 100 * (log(cpi)-log(L.cpi))
gen gap = 100 * (log(GDP)-log(GDPPOT))


* b)
varsoc pi gap, maxlag(16)
reg pi L(1/2).pi L(1/2).gap

esttab, se

* c)
reg pi L(1/2).pi L(1/2).gap

rolling _b _se, window(40)  saving(coeffs, replace): reg pi L(1/2).pi L(1/2).gap
preserve
clear
use coeffs
drop in 1/19
gen gamma1_lb = _stat_3-1.96*_stat_8
gen gamma1_ub = _stat_3+1.96*_stat_8
gen gamma2_lb = _stat_4-1.96*_stat_9
gen gamma2_ub = _stat_4+1.96*_stat_9

tsset end
tsline _stat_3 gamma1*, color(black black black) lp(solid dash dash) ylab(-.3(.1).3) xtitle("Ending Observation") title({&gamma}{sub:1}) name(gamma1, replace)
tsline _stat_4 gamma2*, color(black black black) lp(solid dash dash) ylab(-.3(.1).3) xtitle("Ending Observation") title({&gamma}{sub:2}) name(gamma2, replace)
graph combine gamma1 gamma2


* d)
gen Gamma = _stat_3 + _stat_4
tsline Gamma*, ylab(-.3(.1).3) ytitle({&gamma}={&gamma}{sub:1}+{&gamma}{sub:2}) xtitle("Ending Observation") name(Gamma, replace)
restore

gen D = tq>yq(1973,1)
gen dumgap = D*gap
reg pi L(1/2).pi L(1/2).gap L(1/2).dumgap
test L1.dumgap + L2.dumgap = 0

