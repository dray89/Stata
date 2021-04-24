* ivreg28 cert script 1.0.10 CFB 04feb2007
cscript ivreg28 adofile ivreg28
capture log close
set more off
set rmsg on
program drop _all
log using cs_ivreg28,replace
which ivreg28
ivreg28, version 
version 8.2
assert "`e(version)'" == "02.1.22"
use http://fmwww.bc.edu/ec-p/data/hayashi/griliches76.dta,clear
* Hayashi Table 3.3 p.255 uses Blackburn-Neumark sample 
summ
assert _N == 758
xi  i.year
* line 4 of table via ivreg
which ivreg
ivreg lw expr tenure rns smsa _I* (iq s = med kww mrt age)
assert reldif(_b[s],0.172)< 1e-3
assert reldif(_se[s],0.021)< 1e-3
assert reldif(e(rmse),0.380)< 1e-3
savedresults save iv e()
 
* line 4 of table via ivreg28, small
ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) , small
assert reldif(_b[s],0.172)<1e-3
assert reldif(_se[s],0.021)<1e-3
assert reldif(_b[iq],-0.009)<1e-3
assert reldif(_se[iq],0.0047)<1e-3
assert reldif(_b[expr],0.049)<1e-3
assert reldif(_se[expr],0.0082)<1e-3
assert reldif(_b[tenure],0.042)<1e-3
assert reldif(_se[tenure],0.0095)<1e-3
assert reldif(e(rmse),0.379)<1e-3
* 1.0.6: insts order now differs between ivreg, ivreg28
* savedresults comp iv e(), include(macros: insts instd depvar scalar: rmse matrix: b V) tol(1e-7) verbose
savedresults comp iv e(), include(macros: instd depvar scalar: rmse matrix: b V) tol(1e-7) verbose

* line 4 of table to match sargan (large sample stat)
ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) 
assert reldif(e(sargan),13.3)<1e-2
assert e(sargandf)==2
assert reldif(e(sarganp),0.00131)<1e-3
rcof "noi ivreg28 lw expr tenure rns smsa _I* (iq s med kww = mrt age)" == 481

* OLS option
ivreg28 lw expr tenure rns smsa _I*, small
savedresults save ols e()
regress lw expr tenure rns smsa _I*
savedresults comp ols e(), include(macros: depvar scalar: rmse matrix: b V) tol(1e-7) verbose

ivreg lw expr tenure rns smsa _I* (iq =  age) in 1/8
* insuff observations
rcof "noi ivreg28 lw expr tenure rns smsa _I* (iq =  age) in 1/8" == 2001
* ivreg28 lw expr tenure rns smsa _I* (iq=age) in 1/8
* assert "`e(collin)'" == "rns _Iyear_69 _Iyear_70 _Iyear_71 _Iyear_73"

* exact id
ivreg28 lw expr tenure rns smsa _I* (iq =  age)
assert reldif(e(sargan),0.0)<1e-3

* robust option
ivreg  lw expr tenure rns smsa _I* (iq s = med kww mrt age) , robust
savedresults save ivrob e()
ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) , robust small
* 1.0.6: same as above
*savedresults comp ivrob e(), include(macros: insts instd depvar vcetype scalar: rmse matrix: b V) tol(1e-7) verbose
savedresults comp ivrob e(), include(macros: instd depvar vcetype scalar: rmse matrix: b V) tol(1e-7) verbose


* GMM option
which ivgmm0
ivgmm0 lw expr tenure rns smsa _I* (iq s = med kww mrt age)
savedresults save ivgmm e()
ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age), gmm
* 1.0.6: same as above; cannot compare W
* savedresults comp ivgmm e(), include(macros: insts instd depvar scalar: N rmse j matrix: b V W) tol(1e-7) verbose
* savedresults comp ivgmm e(), include(macros: instd depvar scalar: N rmse j matrix: b V W) tol(1e-7) verbose
savedresults comp ivgmm e(), include(macros: instd depvar scalar: N rmse j matrix: b V ) tol(1e-7) verbose


* orthog option
rcof "noi ivreg28  lw expr tenure rns smsa _I* (iq = med kww mrt ), orthog(s)" == 198
ivreg28  lw expr tenure rns smsa _I* (iq = med kww mrt ), orthog(expr)
ivreg28  lw expr tenure rns smsa _I* (iq = med kww ), orthog(expr)
ivreg28  lw expr tenure rns smsa _I* (iq = med kww ), orthog(med)
ivreg28  lw expr tenure rns smsa _I* (iq = med kww ), orthog(med kww)

* cluster option
ivreg lw expr tenure rns smsa _I* (iq s = med kww mrt age) , robust cluster(age)
savedresults save ivclu e()
* 1.0.6: should yield 498? If so cannot execute following line
* rcof "ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) , small robust cluster(age)" == 498
ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) , small robust cluster(age)
* do not compare insts
savedresults comp ivclu e(), include(macros:  instd depvar scalar: N rmse  matrix: b) verbose tol(1e-7)
ivreg lw expr tenure rns smsa (iq s = med kww mrt age) , robust cluster(age)
savedresults save ivclu2 e()
ivreg28 lw expr tenure rns smsa (iq s = med kww mrt age) , small robust cluster(age)
* 1.0.6: similar to above
* savedresults comp ivclu2 e(), include(macros: insts instd depvar scalar: N matrix: b V)  tol(1e-7) verbose
savedresults comp ivclu2 e(), include(macros: instd depvar scalar: N matrix: b V)  tol(1e-7) verbose

* rcof "noi ivreg28 lw expr tenure rns smsa _I* (iq s = med kww mrt age) , gmm robust cluster(age)" == 498

* replay
ivreg28  lw expr tenure rns smsa _I* (iq s = med kww mrt age) , robust
savedresults save replay e()
ivreg28
savedresults comp replay e(), include(macros: insts instd depvar scalar: N matrix: b)  tol(1e-7) verbose

* 1.0.10 test exog regressors
ivreg28  lw  (iq = med kww mrt age) , nocons

* 1.0.10 test xi
xi: ivreg28  lw  (iq = med kww mrt age) i.year
savedresults save ivxi e()
ivreg28  lw  (iq = med kww mrt age) _I*
savedresults comp ivxi e(), include(macros: instd depvar scalar: N matrix: b V)  tol(1e-7) verbose

* 1.0.10 test by
webuse grunfeld, clear
tsset company year
ivreg28 invest (mvalue= kstock)  if company==10
savedresults save ivby e()
by company: ivreg28 invest (mvalue= kstock)
savedresults comp ivby e(), include(macros: instd depvar scalar: N matrix: b V)  tol(1e-7) verbose

/* cannot execute bootstrap, jackknife with prefix syntax under Stata 8.2
* 1.0.10 test bootstrap
set seed 20070203
bootstrap, reps(100) saving(ivbs,replace): ivreg invest (mvalue= kstock) 
set seed 20070203
bootstrap, reps(100) saving(iv2bs,replace): ivreg28 invest (mvalue= kstock) 
use iv2bs,clear
cf _all using ivbs

* 1.0.10 test jackknife
webuse grunfeld, clear
set seed 20070203
jackknife _b _se, eclass: ivreg invest (mvalue= kstock) 
savedresults save ivjk e()
set seed 20070203
jackknife _b _se, eclass: ivreg28 invest (mvalue= kstock), small
savedresults compare ivjk e(), include(macros: depvar scalar: N matrix: b V) tol(1e-7) verbose\
*/

/* cannot execute svy under Stata 8.2
* 1.0.10 test svy (jackknife)
use http://www.stata-press.com/data/r9/hsng2.dta, clear
svyset _n
set seed 20070203
svy: ivreg rent pcturban (hsngval = faminc reg2-reg4), vce(jackknife)
savedresults save ivsj e()
set seed 20070203
svy: ivreg28 rent pcturban (hsngval = faminc reg2-reg4), vce(jackknife)
savedresults compare ivsj e(), include(macros: depvar scalar: N matrix: b V) tol(1e-7) verbose
*/

/* Not available under Stata 8.2
* 1.0.10 test statsby
use http://fmwww.bc.edu/ec-p/data/wooldridge/phillips.dta, clear
tsset year,yearly
egen quin = cut(year),group(7)
statsby _b _se, by(quin) saving(quin,replace): ivreg unem (inf=L.inf L2.inf)
statsby _b _se, by(quin) saving(quin2,replace): ivreg28 unem (inf=L.inf L2.inf), small
use quin2,clear
cf _all using quin

* 1.0.10 test rolling
use http://fmwww.bc.edu/ec-p/data/wooldridge/phillips.dta, clear
tsset year,yearly
rolling, window(10) saving(rolliv,replace): ivreg unem (inf=L.inf L2.inf)
rolling, window(10) saving(rolliv2,replace): ivreg28 unem (inf=L.inf L2.inf), small
use rolliv2
cf _all using rolliv
*/

* 1.0.7 test fweights
use http://fmwww.bc.edu/ec-p/data/hayashi/griliches76.dta,clear
ivreg28 lw80 expr80 tenure80 rns80 smsa80 (s80 = med kww) [fw=age], ffirst gmm
savedresults save fw e()
expand age
ivreg28 lw80 expr80 tenure80 rns80 smsa80 (s80 = med kww), ffirst gmm
savedresults comp fw e(), include(macros: depvar scalar: N matrix: b V) tol(1e-7) verbose
qui duplicates drop

* sw option for within estimator
webuse grunfeld, clear
center invest mvalue kstock time, casewise double
ivreg28  c_invest (c_mvalue=c_kstock c_time) , robust sw i(company) nocons dofminus(10)
ivreg28  c_invest (c_mvalue=c_kstock c_time) , robust gmm sw i(company) nocons dofminus(10)

* ensure no inappropriate dropping of endog. regressors

qui {
g li1 = L.invest
g li2 = L2.invest
g li3 = L3.invest
g lk1 = L.kstock
g lk2 = L2.kstock
g lk3 = L3.kstock
g lk4 = L4.kstock
g lk5 = L5.kstock
g dlk1 = lk1-lk2
}
ivreg invest li2 (li1 lk1 dlk1 = lk2 lk3 lk4 lk5)
overid
savedresults save fabio1 e() 
ivreg28 invest li2 (li1 lk1 dlk1 = lk2 lk3 lk4 lk5), small
assert "`e(collin)'" == ""
savedresults compare fabio1 e(), include(macros: inst instd depvar scalar:N matrix: b) tol(1e-7) 

* HAC option

use http://fmwww.bc.edu/ec-p/data/wooldridge/phillips.dta, clear
tsset year, yearly
which newey
newey cinf unem, lag(2)
savedresults save newey e()
ivreg28 cinf unem, bw(3) kernel(bartlett) robust small
savedresults comp newey e(), include(macros: depvar scalar: N matrix: b V) tol(1e-7) verbose

* equivalence of ivendog and orthog option (Wooldridge 2002, pp.59, 61)

use http://fmwww.bc.edu/ec-p/data/wooldridge/mroz.dta
 ivreg28 lwage exper expersq (educ=age kidslt6 kidsge6)
// CANNOT EXEC WITH ivreg28--NOT SET UP TO RUN > ivreg28
/*
 which ivendog
 ivendog educ
 local rdf = r(df)
 local dwh = r(DWH)
 local dwhp = r(DWHp)
 ivreg28 lwage exper expersq educ (=age kidslt6 kidsge6), orthog(educ)
 assert `rdf' == e(cstatdf)
 assert reldif(`dwh',e(cstat)) < 1.0e-5
 assert reldif(`dwhp',e(cstatp)) < 1.0e-5
*/

* equivalence of coviv+liml and cue options
 ivreg28 lwage exper expersq (educ=age kidslt6 kidsge6), liml coviv
 savedresults save limlcov e()
 ivreg28 lwage exper expersq (educ=age kidslt6 kidsge6), cue
 savedresults comp limlcov e(), include(macros: inst instd depvar scalar: N rmse matrix: b V)  tol(1e-7) verbose
* savedresults save ols e()
ivreg28 lwage exper expersq educ (=age kidslt6 kidsge6),small
* savedresults comp ols e(), include(macros: depvar scalar: N df_r matrix: b V) tol(1e-7) verbose

* ivendog cstat versus ivreg28 cstat
ivreg lwage exper expersq (educ=age kidslt6 kidsge6)
savedresults save ivendog e()
ivendog educ
scalar cstat = r(DWH)
scalar cstatp = r(DWHp)
scalar cstatdf = r(df)
ivreg28 lwage exper expersq educ (=age kidslt6 kidsge6), orthog(educ)
savedresults compare ivendog e(), include(macros: depvar scalar: N df_m) tol(1e-7) verbose
assert reldif(e(cstat),cstat) < 1e-7
assert reldif(e(cstatp),cstatp) < 1e-7
assert cstatdf == e(cstatdf)

use http://fmwww.bc.edu/ec-p/data/hayashi/griliches76.dta,clear
assert _N == 758
xi  i.year
ivreg28 lw s expr tenure rns _I* (iq=kww age), cluster(year)
mat bfwl1 = e(b)
mat Vfwl1 = e(V)
savedresults save nofwl e()
ivreg28 lw s expr tenure rns _I* (iq=kww age), cluster(year) fwl(_I*)
mat bfwl2 = e(b)
mat Vfwl2 = e(V)
savedresults compare nofwl e(), include(scalar: N N_clust rss rmse idstat) tol(1e-7)
assert reldif(bfwl1[1,1],bfwl2[1,1]) < 1e-7
assert reldif(bfwl1[1,2],bfwl2[1,2]) < 1e-7
assert reldif(Vfwl1[1,1],Vfwl2[1,1]) < 1e-7
assert reldif(Vfwl1[1,2],Vfwl2[1,2]) < 1e-7
assert reldif(Vfwl1[2,2],Vfwl2[2,2]) < 1e-7

log close
set more on
set rmsg off