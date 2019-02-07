log using "AKdata.txt", replace 
merge 1:1 id using AKdata_merge22
tab _merge 

gen ageqsq = ageq^2

tab qob, gen(q) 
tab yob, gen(b) 

gen q1 = (qob == 1) 

gen q2 = 

reg educ q1

predict ed_hat, ab

ivregress 2sls lwklwge 

forvalues x = 1/10 

ivreg2 lwklwge b30-b38 

/*end of class exercise

1) Use birthord as an IV for educ in the following regression ln(wage) = B0 + B1educ + e
2) Now include sibs as another exogenous variable
3) Run following 
	A) educ = Bo + B1birthord + e 
	B) ln(wage) = B0 + B1birthord + B2sibs + u  
4) compare with q2
5) Use both sibs and birthord as IVs for educ, control for race and tenure. 
*/

infile wage educ exper tenure black sibs birthord using "wagers.txt" 

gen wage = ln(wage)

ivregress 2sls lwage (educ=birthord) 

ivregress 2sls lwage sibs(educ = birthord)

ivregress 2sls lwage race tenure (educ= birthord sibs) 

/*more instruments than endogenous variables; inside the variables are excluded
 in the 2nd stage but it is the first stage*/
test birthord sibs
