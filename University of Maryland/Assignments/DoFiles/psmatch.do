
clear all 
use matching_earnings.dta

/*
2.	Now estimate your propensity score matching model using one-to-one nearest neighbor 
matching with replacement. Don’t forget to set your random seed! */
set seed 123456
gen u = uniform()
sort u
probit treat age educ marr re75
predict pscorea

histogram pscorea, start(0.0) width(0.05) by(TREAT, col(1))

browse treat pscorea
gen p1 = 1 if pscorea>.5
replace p1 = 0 if pscorea<.5
tab treat p1

psmatch2 treat, outcome(RE78) pscore(pscorea) n(1) common
/*	Does participation in the program appear to be randomly assigned? How would you test this? */
/*To test for random assignment, we need to construct counterfactuals of untreated outcomes
for treated observations. The counterfactual is a weighted average of the observed untreated outcomes.
*/
histogram pscorea, start(0.0) width(0.05) by(TREAT, col(1))
/* We show a poor common support problem in the histogram - we can use the "common" command to
concentrate on the overalapping populations although when we do this we 
will possibly throw out useful information for people near the boundaries and it might
be unclear what we are estimating.
In the histogram it looks like some of the participants might be more likely to be in the treatment group than others meaning the treatment group
may not be completely randomly assigned.*/
ttest RE78, by(treat)
reg RE78 treat
bysort treat: sum RE78
/*Income is a determining factor of being in the treatment group
 but we only really need random assignment within the treatment group*/

/*How many unique control subjects were matched to the treated? 
How many control subjects were matched more than once? */
tab _weight treat

/*	Repeat propensity score matching, but now with no replacement. How did the results change?*/

psmatch2 treat, outcome(RE78) pscore(pscorea) n(1) common noreplacement
tab _weight treat
/*no replacement has a negative ATT difference btwn treated and controls.
 the ATT for controls increased and SE of ATT for controls decreased and 
 184 controls were matched to 184 treated. */
 
/*	Repeat propensity score matching with replacement, but now use 2 matches for each treated subject.  How did the results change?*/
psmatch2 treat, outcome(RE78) pscore(pscorea) n(2) common

/*from noreplacement, the control ATT decreased and the standard error increased. 
From 1 match, the SE decreased while the ATT increased. no replacement has a negative ATT
difference between treated and controls. the difference is greater on use 1 match
per treated subject rather than 2. */ 
