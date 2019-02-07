/*Debra Ray, Econ 672, Problem Set 1 */

set more off
set linesize 200
log using "ps1_ray", text replace 

/* ************************************************************************** */
/* LOG FILE for problem set 1 *********************************************** */
/* Debra Ray ******************************************************* */
/* ************************************************************************** */


/* ************************************************************************** */
/* ****************************** QUESTION 1 ******************************** */
/* ************************************************************************** */


/*(a) What is the eﬀect of ﬁnancing college using scholarships instead of student 
loans on the wages of college graduates?

i. What is the outcome variable and what is the treatment?
	The outcome variable is wages, and the treatment variable is using scholarships
	to finance college rather than student loans. 

ii. Deﬁne, in words, the counterfactual outcomes Y0i and Y1i.

	The counterfactual outcome for the control group, Y0i, would be the outcome, wages 
	if the observational unit in the control group was instead treated with a scholarship 
	to finance college. The counterfactual outcome for the treatment group, Y1i, would be 
	the outcome, wages, given that the observational units in the treatment group were instead 
	not treated with the scholarship and, instead, used student loans to pay for college. In other 
	words, it would be the unobserved outcomes had the treated not been treated and the 
	control had been treated instead. 

iii. What plausible causal channel(s) (ie, a causal mechanism) runs directly from 
the treatment to the outcome?

	1) Students treated with a scholarship may have higher graduation rates than the 
	control group, or may graduate faster than the control group.

	2) A scholarship would reduce debt burdens of treated students.
	Lower debt burdens means the treated students can take short-term, lower paying jobs 
	and internships with large companies with high networking benefits. Being able to 
	take those jobs and internships may lead to higher pay later than the control group.

iv. What are possible sources of selection bias in the raw comparison of outcomes 
by treatment status?

	If assignment isn't random:

	1) Merit-based scholarships are linked to student 
	GPA in high school and SAT scores - which might be correlated with performance in
	college and later performance in the workforce. 

	2) Likewise, need-based scholarships would select students with lower income to start with 
	and are less priviledged. This group may have lower potential income outcomes to 
	start with through less family networks to help find high paying jobs or less skills to 
	compete in the job market because their parents didn't have those skills to teach them.

(b) What is the eﬀect of having health insurance on obesity?

i. What is the outcome variable and what is the treatment?
	Health insurance is the treatment variable and the outcome variable is weight/bmi/obesity. 

ii. Deﬁne, in words, the counterfactual outcomes Y0i and Y1i.
	The counterfactual for the control group, Y0i, is the outcome, weight/bmi/obseity, 
	given that these observations were instead treated. The counterfactual for the treatment group, 
	Y1i, is the outcome, weight/bmi/obesity, if the treatment group were instead not treated.

iii. What plausible causal channel(s) (ie, a causal mechanism) runs directly from 
the treatment to the outcome?

	Treated observations may have greater access to care to treat the causes of the 
	obesity. Sometimes, the weight gain is caused by a health condition or habits 
	which a doctor can help treat.

iv. What are possible sources of selection bias in the raw comparison of outcomes 
by treatment status

	Observations with higher BMIs might have different likelihoods of being in the treatment
	or control groups given different causes of the higher BMI. Some medications cause 
	weight gain and those observations with higher BMIs in the treatment group may be
	more likely to have higher BMIs due to greater access to healthcare.

(c) What is the eﬀect of attending a ﬁnancial literacy class on retirement savings?

i. What is the outcome variable and what is the treatment?

	The outcome variable is retirement savings aand the financial literacy class 
	is the treatment.

ii. Deﬁne, in words, the counterfactual outcomes Y0i and Y1i.

	The couterfactual outcome for the treated observations is the retirement savings 
	of the treated group given that they were not treated with the financial literacy 
	class. The counterfactual outcome for the control group is what would have happened 
	if the control group had been treated.

iii. What plausible causal channel(s) (ie, a causal mechanism) runs directly from 
the treatment to the outcome?

		A financial literacy class might promote financial decisions which would
		increase retirement savings and decrease debt.

iv. What are possible sources of selection bias in the raw comparison of outcomes 
by treatment status?

		1) Observations with a greater likelihood of saving for retirement might opt to 
		take a financial literacy class whereas observations with less interest 
		in saving for retirement may not take the class.
		
		2) Observations which have a lower expected retirement savings may take the class 
		versus observations which have a higher expected retirement savings may not
		take the class because they have less of a need for it. 

*/
/* ************************************************************************** */
/* ****************************** QUESTION 2 ******************************** */
/* ************************************************************************** */

/*2. Selection bias (Stata exercise with short answers, 28 points): In this 
exercise, we will work through how random assignment can address selection bias.*/

use ps1selectiondta.dta

/*(a) Suppose that this training program is strictly voluntary, and that only individuals 
with low experience levels volunteer for the program.  Create a dummy variable for whether 
or not an individual volunteers for the program by running the following command: */

gen volunteer = cond(experience<9,1,0)

/*Then, run a cross-tabulation to verify that the data show that only individuals 
with less than 9 years of experience participate in the training program. */

tab experience volunteer

/*Using the generate command, create a variable widgets_nonexp according to this 
data generating process, where only those who volunteer receive training. 
Verify that the mean of this new variable in the entire dataset is 17.86. */

gen widgets_nonexp = 10 + 2*volunteer + .75*experience + u

sum widgets_nonexp

/*According to this data generating process, what is the true eﬀect of training 
on widget-making capabilities? 

	The coefficient, 2, represents the true effect of training on widget 
	making capabilities. The treatment, training, is determined conditional on being
	a volunteer. Since volunteers only have less than 9 years of experience, all 
	experience levels are not equally as likely to be in the treatment group and 
	random selection does not balance out the selection bias between the treatment 
	and control groups. Experience also influences the outcome variable, widgets produced. 
	Therefore, the treatment variable is endogenous to experience. If we did not include 
	experience in the DGP, the equation would suffer from the omitted variables bias. 
	
	By controlling for experience, we reduce the correlation between the error term 
	and the treatment dummy variable and reduce bias in the coeff. on 
	treatment. 
*/

/*What is the eﬀect of an additional year of experience? 

	Each additional year of experience adds .75 more widget making potential to an 
	observation. 

*/
/* Therefore, you instead evaluate the impact of this program using the following 
regression, which omits the variable for experience: reg widgets nonexp volunteer 
*/
reg widgets_nonexp volunteer

/*Please report the evaluation’s ﬁnding of the eﬀect of the training program on 
the number widgets produced by each individual. How does your ﬁnding compare to 
the true eﬀect from your response to (b)? How did selection bias aﬀect your ﬁnding here? 
	
	The coeff is now  -4.79921. Compared to b, it shows that the training has the
	opposite effect and now reduces the number of widgets produced. Because the control group
	has more experienced widget producers, by not controlling for 
	experience, the coefficient on volunteer is negative indicating that the treatment 
	group produces less widgets compared to the control group. In other words, without 
	making the outcome conditional on experience, the regression does not accurately 
	predict the counterfactual for the control group. 

*/

/* You still have a selection problem, in that only inexperienced individuals agree 
to participate in your experiment. Create a dummy variable for random assignment 
into treatment or control groups for those who agree to participate by running 
the following command: gen treatment = randomassignment if volunteer==1 */

gen treatment = randomassignment if volunteer==1

/*Use the command ttest to perform a t−test of the equality of means of a few 
characteristics, by assignment status. */

ttest experience, by(randomassignment)
ttest volunteer, by(randomassignment)
ttest widgets_nonexp, by(randomassignment)
ttest treatment, by (randomassignment)


ttest experience, by(treatment)
ttest volunteer, by(treatment)
ttest widgets_nonexp, by(treatment)

/*Verify that the mean of experience is the 
same for the treatment and control groups, indicating true random assignment. 
*/

ttest experience, by(randomassignment)

/*Answer: Yes, the mean is the same for treatment and control.

Verify also that the selection problem remains: that participants in the experiment 
have lower experience than non-participants.

Answer: The ones who participate in the treatment/training have less experience than the 
group that does not choose to participate and comply with random assignment into treatment. */

ttest randomassignment, by(treatment)
 
 /*Again using the generate command, create a variable widgets exp according to 
 the data generating process from part (b). Be sure to use the treatment variable, 
 rather than the volunteer variable, to reﬂect that only the treatment group received the training. 
*/ 

gen widgets_exp = 10 + 2*treatment + .75*experience + u


/*Verify that the mean of widgets exp among all experimental participants is 15.55.*/
 sum widgets_exp

/*

As before, the researcher is unable to observe experience. Evaluate the impact 
of the treatment in this experiment by running the following regression, 
omitting the variable for experience: reg widgets exp treatment */

reg widgets_exp treatment

/*Please report the eﬀect of the training program on the number widgets produced by each 
individual. Why did the experiment result in diﬀerent ﬁndings than (c)? 
How does your ﬁnding compare to the true eﬀect from the true data generating process in (b)?

2.028788, the coefficient on treatment is closer to the data generating process coefficient in b than c
so the selection bias from omitting experience is now less in absolute value. The selection
bias has turned positive now rather than being negative.

*/

/*Clear the data in Stata, and re-load the dataset again. */
clear all 
use ps1selectiondta.dta


/* Repeat the code for the analyses in question (4) parts (a) through (f), 
but suppose the selection into participation goes in the opposite direction: 
only those with 9 or more years of experience volunteer. */

gen volunteer = cond(experience>=9,1,0)
tab experience volunteer

gen widgets_nonexp = 10 + 2*volunteer + .75*experience + u

sum widgets_nonexp

reg widgets_nonexp volunteer

gen treatment = randomassignment if volunteer==1

ttest experience, by(randomassignment)
ttest volunteer, by(randomassignment)
ttest widgets_nonexp, by(randomassignment)
ttest treatment, by (randomassignment)


ttest experience, by(treatment)
ttest volunteer, by(treatment)
ttest widgets_nonexp, by(treatment)

ttest experience, by(randomassignment)

ttest randomassignment, by(treatment)

gen widgets_exp = 10 + 2*treatment + .75*experience + u

sum widgets_exp

reg widgets_exp treatment

/*How did your results for (c) and (f) change when the selection runs in the opposite direction, and 
why? 

	The results for c became largely positive, so the effect from treatment is overestimated.
	The results for f are underestimated, less than 2 now although not by much - 1.7 */


/*(h) Stepping back from the data and thinking conceptually about this example, 
please describe how the treatment might spill over to workers not assigned to 
the treatment. How would that aﬀect how you interpret the measured treatment 
eﬀect? Also, how would spillover eﬀects inﬂuence the external validity of the 
estimated treatment eﬀects from the experiment?
	
	The treatment might spill over to the workers not assigned to the treatment 
	if the experienced workers shared their knowledge gained from the treatment 
	to the workers in the control group. This would affect how we interpret the 
	measured treatment effect by closing the gap between the control group's mean from 
	nontreatment and the control group's counterfactual mean. Essentially, the control group's
	mean conditional on nontreatment would be overestimated and this would bias
	the coefficient on treatment - it is a non-interaction problem where the treatment units influence
	the outcome of the control units.
	
	The spillover effects would influence the external validity of the estimated 
	treatment effects from the experiment by preventing consistent measurement of the 
	treatment effects. 
	
	*/
	
/* Download the dataset ps1bm.dta from the course website.*/
clear all
use "C:\Users\faith\Downloads\ps1bm.dta" 


/*(a) The dataset includes two dummy variables (0-1 variables) for female and computer skills. 
Using the tab command or the tabsum command, separately tabulate these two variables 
by black and display the percentages of each race group that is female, and the 
percentages of each race group that has computer skills. 
*/

bysort black: tab computerskills, summarize(female)


/*Perform t−tests of the quality of means of each of the two attributes, by race group.*/

ttest computerskills, by(black)
ttest female, by(black)

/*

i. The means of female for resumes with white sounding names and for resumes with black sounding names 
	About 76% of the white group is female and 77% of the black group is female. 

ii. The diﬀerence in the means between the two groups of resumes 

	difference =  -.0106776

iii. The t-statistic for this diﬀerence 
	tstat =   -0.8841

iv. The p-value for the null hypothesis that the two means are equal 	
	pvalue = 0.3767 
	

v. The means of computerskills for resumes with white sounding names and for resumes with black sounding names 
	white mean:  .8086242 
	black mean: .8221766   

vi. The diﬀerence in the means between the two groups of resumes
	difference:   -.0135524 

vii. The t-statistic for this diﬀerence 
	tstat: -1.2188

viii. The p-value for the null hypothesis that the two means are equal 
	pvalue: 0.2230

ix. Do gender and computer skills appear to be balanced across resumes with black sounding names 
and resumes with white sounding names? Why or why not? 

	Yes, the pvalues are not low enough for the means to be statistically different from zero.

(b) Do a similar cross-tabulation of education and number of jobs previously held
 (jobsonresume) with black. Note that these two variable have 5 and 7 possible values, respectively.
 Use the the tab command with the chi2 option to test if education is independent of the
 black variable, and then do the same for jobsonresume and black. */

 tab education black, chi2
 tab jobsonresume black, chi2 

 /*
After conducting these analyses, please report the following in the comments of your do-ﬁle: 

i. The proportion of resumes with black sounding names that have some college or more education 
(that is, the “some college” category as well as the “college degree and more” category”) */

di (493+1760)/2435
/*
ii. The proportion of resumes with white-sounding names that have some college or more education */
di (513+1744)/2435
/*

iii. The Pearson chi2 statistic 

3.4096

iv. The p-value for the null hypothesis that the the education and black are independent of each other 

.492, do not reject null that education and black are independent of eachother

v. The proportion of resumes with black sounding names that have 5 or more previous jobs */

di (275+221+12)/2435
/*
vi. The proportion of resumes with white-sounding names that have 5 or more previous jobs*/

di (258+243+7)/2435
/*
vii. The Pearson chi2 statistic 

	3.5248

viii. The p-value for the null hypothesis that jobsonresume and black are independent of each other 

	.741, do not reject null that jobsonresume and black are independent of each other.

ix. Do the two attributes appear to be balanced across the two groups of resumes? Why or why not? 

	yes, because the pvalues are too large to reject the null that the attributes are different across the two groups.

(c) Why do we care about whether these variables on resume characteristics look similar across the 
two groups of resumes?

	We care that these variables on resume characteristics look similar because we want to randomly assign 
	characteristics to names so we can isolate the effect of racial names on the outcome variable, calls 
	
	\(d) The outcome variable of interest in this study is call. This indicates whether or not a particular 
 resume generated a call-back for a job interview. Using tabulations and t-tests, 
 Do you ﬁnd diﬀerences in call-back rates by race group? */
tab call black, chi2
ttest call, by(black)

/*Run a regression of call on black along with the other covariates you have analyzed above and verify that the 
 eﬀect of black is consistent with what you found through the t-test. 
*/
reg call black education jobsonresume computerskills female
/*
(e) What do you conclude from the results of this experiment? Suppose a councilmember 
you are advising is considering changing the DC government’s hiring processes to omit names 
from job applicant resumes. What does this experiment suggest about the potential consequences of such a policy?

The experiment suggests that names that sound more racially black would receive more call backs
if their names were omitted from the resume.


 While in last question we analyzed data from ﬁctitious job applicants, we will now
 analyze data on real-life individuals. We will use data drawn from the U.S. Current
 Population Survey (CPS), a large on-going labor market study conducted by the Bureau of 
 Labor Statistics; our dataset will include data on 8,891 black and white individuals 
 living in Boston and Chicago in 2001. Download the dataset ps1cps.dta from the course website.
 
 */
 clear all
 use "C:\Users\faith\Downloads\ps1cps.dta" 
 
 /*
(a) The dataset includes a variable on education, which takes on four possible values, for high
 school dropouts, high school graduates, some college, and college degree and more. Create a new
 dummy variable called somecollege that indicates if a respondent has some college or more education
 (that is, the “some college” category as well as the “college degree and more” category).
*/
 gen somecollege = cond(education>=3,1,0)
/*
 What fraction of the full sample has at least some college education?
 .6245642 
 */
 sum somecollege
 
 /*) Perform a t-test for whether or not the mean of omecollege is the same for black
 and white respondents in the sample. */
 
 ttest somecollege, by(black)
 /*
 
 i. What is the mean of this variable for black respondents? 
.5264728 
 
 
 ii. What is the mean of this variable for white respondents? 
 .6419868  
 
 iii. What is the t-statistic and the p-value of this t-test for the hypothesis that the two means are equal?
 
  Pr(|T| > |t|) = 0.0000    t =   8.0785
 
 (c) Perform a chi2 test for whether or not education and black are independent of each other. What is the
 chi2 statistic and the p-value of this test?*/
 
 tab education black, chi2
 
 /*   Pearson chi2(3) = 174.9348   Pr = 0.000

*/
 
/*d) Do you ﬁnd evidence that education diﬀers for blacks and
 whites in the CPS data? Explain. 
 
Yes, differences in means between the education of the two groups is statistically significant.
 
 (e) Calculate the t-statistic for equality of the means in the years of
 experience (yearsexp).*/
 ttest yearsexp, by(black)
 
 /*
 Do you ﬁnd evidence that these variables differ sign for whites and blacks?
 Explain. 
 No the pvalue is too high.
   Pr(|T| > |t|) = 0.3277  */
 
 /*) Discuss your results from (d) and (e). How do your conclusions for the education and experience 
 variables diﬀer? Why do we care about whether these variables look similar by race? 
 
 It looks like while education is statistically different between the two groups but years of experience is not
 statistically different. We care about whether these look similar, because if they do not, then there is selection 
 bias in the characteristic and/or discrimination.
 
 (g) Calculate the t-statistic for equality of the means in whether the individual is employed (employed). */
 
 ttest employed, by(black)  
 
 
/*Do you ﬁnd evidence that this variables diﬀers signiﬁcantly for whites and blacks? 
  t =   7.4598  Pr(|T| > |t|) = 0.0000  
  
  Yes, employment varies significantly by race. 
  
 (h) In light of your results for (f) and (g),what do you think you can conclude about
 racial discrimination in employment from the CPS data? 
 
	Unemployment is higher for minorities over Caucasians, and minorities have a harder
	time finding work. They also have less education on average which makes it more difficult
	for them to find jobs. 
	
 
 How does an experiment like Bertrand and Mullanaithan (2001) address some of the problems that arise from
 using CPS data to analyze racial disparities in employment?
 
 You cannot tell from the CPS data if the higher unemployment is a result of the selection bias into education 
 by the Caucasian group or if the higher unemployment is due to race because random assignment of education does 
 not exist. We cannot isolate the effect of race on unemployment. Bertrand and Mullanaithan randomly assigned 
 education, experience, and number of jobs on resume so that they could isolate the effect of race. 
 
