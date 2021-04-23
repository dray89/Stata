

/*Sample Selection Correction*/

*Sample Selection Correction*/

 use "your dir\MROZ.DTA", clear
 
 *how many zeros we have for wages
 
 count if lwage==.
 
 *generate a variable that equals 1 if wage is oberved and zero othervise
 
 gen s = 1 if lwage !=. 
 replace s=0 if s==.
 
 *estimate Probit
 
 probit s nwifeinc educ exper expersq age kidslt6 kidsge6, robust
 predict rhat
 
 generate zhat=invnorm(rhat) 
 
 *calculate inverse Mills Ratio
 
 gen lambda = normalden(zhat)/normal(zhat)

 *use nwifeinc age kidslt6 kidsge6 as exclusion restriction
 
 
 *estimate OLS with Heckman correction
 
reg lwage educ exper expersq lambda, robust

*lambda not significant - no evidence of sample selection

*estimate same regression without Heckman correction
reg lwage educ exper expersq, robust

*Use two-step Heckman model

heckman lwage educ exper expersq, twostep select(nwifeinc age kidslt6 kidsge6)


 use "your dir\trd1986.DTA", clear
 
 *how many missing values we have for wages
 
 count if ln_trade==.
 
 reg ln_trade ln_distance my_d_lang fta colonial religion_same legalsystem_same border cu island, robust
 
 *generate a variable that equals 1 if trade relationship is oberved and zero othervise
 
 gen trade = 1 if ln_trade !=. 
 replace trade=0 if trade==.
 
 *estimate Probit
 
 probit trade ln_distance my_d_lang fta colonial religion_same legalsystem_same border cu island, robust
 predict rhat
 
 generate zhat=invnorm(rhat) 
 
 *calculate inverse Mills Ratio
 
 gen lambda = normalden(zhat)/normal(zhat)

 *use same religion as an exclusion restriction
 
 
 *estimate OLS with Heckman correction
 
reg ln_trade ln_distance my_d_lang fta colonial legalsystem_same border cu island lambda, robust

*lambda  significant -  evidence of sample selection


*Use two-step Heckman model

heckman ln_trade ln_distance my_d_lang fta colonial legalsystem_same border cu, twostep select(ln_distance my_d_lang fta colonial religion_same legalsystem_same border cu) mills(nuhat_hec) 


*Tobit model*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\MROZ.DTA", clear


*our dependent variable is hours; For some women hours>0 for some it is zero

summarize hours
count if hours>0
count if hours==0

histogram hours, normal bin(10) xline(800)

*estimate the model using ols

reg hours nwifeinc educ exper expersq age kidslt6 kidsge6,robust




*estimate the model using tobit

tobit hours nwifeinc educ exper expersq age kidslt6 kidsge6,ll(0)

*tobit reports the beta coefficients for the latent regression model. The marginal effect of say education on hours is simply the corresponding beta_educ, because E(hours|education) is linear in education.
*Thus a 1 extra year of education would increase yearly hours work by about 81 hrs or two weeks .

*Average Partial Effects Scaling Factor(APE)

gen effect = normal((_b[_cons] + _b[nwifeinc]*nwifeinc+ _b[educ]*educ + _b[exper]*exper+ _b[expersq]*expersq+_b[age]*age+_b[kidslt6]*kidslt6+_b[kidsge6]*kidsge6)/_b[/sigma])
mean(effect)
scalar APEscalar = _b[effect]

*then comparable Tobit estimate to OLS are obtained by multiplying Tobit estimates by APE factor

scalar edu_adj = _b[educ]*APEscalar
disp edu_adj

*if we want to the estimated effect of another year of education starting at the average values of 
*all explanatory variables we need to calculate partial average effect PEA

summarize nwifeinc educ exper expersq age kidslt6 kidsge6

scalar aeffect = normal((_b[_cons]+ _b[nwifeinc]*20.12+_b[educ]*12.29 + _b[exper]*10.63+ _b[expersq]*178.04+_b[age]*42.54+_b[kidslt6]*0.238+_b[kidsge6]*1.353)/_b[/sigma])
disp aeffect

*then the partial average effect of education on hours worked is about 49 hours (80.64*0.604)

*finally we can calculate conditinal mean (fitted values) for all outcomes E(hrs|x)

gen hourshat_tobit = normal((_b[_cons] + _b[nwifeinc]*nwifeinc+ _b[educ]*educ + _b[exper]*exper+ _b[expersq]*expersq+_b[age]*age+_b[kidslt6]*kidslt6+_b[kidsge6]*kidsge6)/_b[/sigma])*(_b[_cons] ///
+ _b[nwifeinc]*nwifeinc+ _b[educ]*educ + _b[exper]*exper+ _b[expersq]*expersq+_b[age]*age+_b[kidslt6]*kidslt6+_b[kidsge6]*kidsge6) + _b[/sigma]*normalden((_b[_cons] + _b[nwifeinc]*nwifeinc+ ///
_b[educ]*educ + _b[exper]*exper+ _b[expersq]*expersq+_b[age]*age+_b[kidslt6]*kidslt6+_b[kidsge6]*kidsge6)/_b[/sigma])


*now let us compare fitted values from OLS at respective means for 
reg hours nwifeinc educ exper expersq age kidslt6 kidsge6,robust
predict hourshat

summarize hourshat_tobit hourshat if educ<8
summarize hourshat_tobit hourshat if educ>16

*now with STATA margins command (requires version 13 to run)
*the means of the marginal effects on the expected value of the censored outcome (zero hours in our case), conditional on education being each equal to the mean = 12.29 (recall that E[y*|x) is not linear),
*dydx partial change for a continious variable 
margins, dydx(educ) predict(ystar(0)) at(educ=12.29)

/*outliers*/

use "your dir\RDCHEM.DTA", clear
reg rdintens sales profmarg

/*lets see if there are outliers*/

summarize sales profmarg

scatter  rdintens sales

/*drop sales outlier*/
reg rdintens sales profmarg if sales<39709



/*Outliers*/
use "your dir\RDCHEM.DTA", clear
reg rdintens sales profmarg

/*lets see if there are outliers*/

summarize sales profmarg

scatter  rdintens sales

/*drop sales outlier*/
reg rdintens sales profmarg if sales<39709




/*User written commaands*/

/*tsegen*/

 findit tsegen
 
/*Calculate the mean of the variable invest over a 5-year rolling window that includes the current observation*/

webuse grunfeld, clear
tsegen inv_m5 = rowmean(invest L(1/4).invest)
        
/*To find the minimum and maximum investment within the 5-year window, again ignoring windows with fewer than 3 observations*/

tsegen inv_min5m3 = rowmin(L(0/4).invest, 3)
tsegen inv_max5m3 = rowmax(L(0/4).invest, 3)
        
/*rangestat*/

findit rangestat

/*The example below calculates the mean and standard deviation of the variables price mpg using observations with the same value for rep78*/

sysuse auto, clear
rangestat (min) price mpg (mean) price mpg, interval(rep78 0 0)
        
* by compariosn redo using egen functions

sort rep78 make
by rep78: egen min_price = min(price
by rep78: egen min_mpg   = min(mpg)
by rep78: egen mean_price = mean(price)
by rep78: egen mean_mpg   = mean(mpg)
list rep78 *price* *mpg* if rep78 <= 2, sepby(rep78)

/*tabdisp*/

/* tabdisp displays data in a table*/

 sysuse auto2, clear

 /*List some of the data*/
 list make mpg weight displ rep78 in 1/10

*List some of the data using tabdisp
 tabdisp make, cell(mpg weight displ rep78)

*Make dataset of means of mpg by categories of foreign and rep78
collapse (mean) mpg, by(foreign rep78)

*List the data
list

*List the data using tabdisp
tabdisp foreign rep78, cell(mpg)

/*statsby -  Collect statistics for a command across a by list*/
sysuse auto,clear
statsby mean=r(mean) sd=r(sd) size=r(N), by(rep78):  summarize mpg
sysuse auto,clear
statsby, by(foreign): regress mpg gear turn



/*combineplot - module to combine similar univariate or bivariate plots for different variables*/

findit sliceplot

sysuse auto, clear
set scheme s1color

combineplot mpg price weight headroom: graph box @y, over(rep78)
combineplot mpg price weight headroom: dotplot @y, over(rep78)
combineplot price mpg headroom-gear, combine(imargin(small)): histogram @y, freq yla(, ang(h))
combineplot price mpg weight length: qnorm @y
combineplot price (mpg weight length displacement): scatter @y @x || qfit @y @x,legend(off) ytitle("Price (USD)")
combineplot (mpg price) (rep78 foreign), sequence(a b c d) seqopts(caption(color(red))): graph box @y, over(@x)

/*triplot -  a triangular plot of the three variable*/

findit sliceplot
use triplot
triplot Services Industry Agriculture, max(100)
