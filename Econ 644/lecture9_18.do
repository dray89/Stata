
/*fitting linear probability model*/

use "your dir\MROZ.DTA", clear

reg inlf nwifeinc educ exper expersq age kidslt kidsge6

/*logit model*/

use "https://stats.idre.ucla.edu/stat/stata/dae/binary.dta", clear


*obtain descriptive statistics
summarize gre gpa
tab rank 
tab admit
tab admit rank

/*run LPM*/

reg admit gre gpa i.rank, robust

/*run logit*/

logit admit gre gpa i.rank, robust



*For every one unit change in gre, the log odds of admission (versus non-admission) increases by 0.002.
*For a one unit increase in gpa, the log odds of being admitted to graduate school increases by 0.804.
*The indicator variables for rank have a slightly different interpretation. 
*For example, having attended an undergraduate institution with rank of 2, 
*versus an institution with a rank of 1, decreases the log odds of admission by 0.675.

/*predit probabilities at means of all variables*/

margins rank, atmeans

*predicted probability of being accepted into a graduate program is 0.51 
*for the highest prestige undergraduate institutions (rank=1), 
*and 0.18 for the lowest ranked institutions (rank=4), holding gre and gpa at their means.

/*predit probabilities with a range*/


margins , at(gre=(200(100)800))  vsquish

*the mean predicted probability of being accepted is only 0.167 if one's GRE score is 200 
*and increases to 0.414 if one's GRE score is 800 (averaging across the sample values of gpa and rank).

*can also run probit

probit admit gre gpa i.rank, robust

*margins results are similar

*Poisson Model

use "https://stats.idre.ucla.edu/stat/stata/dae/poisson_sim", clear

sum num_awards math

tabstat num_awards, by(prog) stats(mean sd n)

histogram num_awards, discrete freq scheme(s1mono)

*estimate the model*/

poisson num_awards i.prog math, vce(robust)

*interpretation:

*increase in math score by 1 point increases the awards (incident) rate by 100*[exp(0.07)-1]=7.25%

*ask for incident ratios directly
poisson num_awards i.prog math, irr vce(robust)

* incident rate for 2.prog is 2.96 times the incident rate for the reference group (1.prog).  
*the incident rate for 3.prog is 1.45 times the incident rate for the reference group holding the other variables constant.  

*margins

margins prog, atmeans

margins, at(math=(35(10)75)) vsquish

*run negative binomial to test for overdispersion

nbreg num_awards i.prog math

*Likelihood-ratio test of alpha=0:  chibar2(01) =    1.69 Prob>=chibar2 = 0.097 - no evidence of overdispersion


/*Sample Selection Correction*/

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
