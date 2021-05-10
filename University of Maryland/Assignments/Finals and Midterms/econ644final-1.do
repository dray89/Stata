******************************   Part II   *************************************
* Forty questions (1)-(40), one and a half points per question, total 60 points.

/* (1) Create a header for this Do File, starting on line 7, with the title 
"ECON 644 Final Exam," followed by "your name" below on the next line, and today's 
date "Feb 23, 2017" on the next line. */
/*******************ECON 644 Final Exam*************************************
********************Debra Ray *********************************************
*******************Feb 23, 2017********************/

/* (2) Clear Stata's memory. */

clear all
set more off

/* (3) Begin a Log File named econ644final.smcl. */
log using econ644final.log, replace

/* (4) Display the working directory. Change the working directory to your 
desktop, if not already set this way. */
pwd
cd "/Users/mafton/Desktop"
cd "/Users/mafton/Documents/School/Econ 644"

/* (5) Open the dataset CEOsalary.dta. */
use "/Users/mafton/Documents/School/Econ 644/CEOsalary.dta"


/* (6) Obtain a description of the variables in the dataset. What are the name 
and the label of the first variable? */
describe
/*id, unique ceo identifier*/

/* (7) Obtain summary statistics for all the variables in the dataset. Which 
variables in the dataset are string? */

summarize 
/* id, name, gender, sales */
/* (8) List the CEO names that have missing records for the variable daybirth. */
list daybirth name if daybirth==.


/* (9) Create a dummy (indicator) variable named mis which takes the value 1 if
daybirth is missing, zero otherwise. */
generate mis = (daybirth==.)

/* (10) Compute the mean and std. dev. of the variable mis. What percentage of 
the CEOs in the sample have missing records for daybirth? */
summarize mis
codebook mis
codebook daybirth
display 100*(5/177)

/* (11) Create a new variable named daybirth_mz that replaces the missing values
in datebirth with zeros. */
recode daybirth (missing = 0), generate(daybirth_mz)

/* (12) List daybirth and daybirth_mz for the observations that have different 
values for these two variables. */
list daybirth_mz daybirth if daybirth!=daybirth_mz


/* (13) Plot a histogram of the variable age. Use a bin width of 3, plot 
frequencies, and add height labels to the histogram bars. Later please pdf-print
 this graph and attach it with your answers. */

histogram age, width(3) frequency addlabel
/* (14) Compute a 95% confidence interval for the variable age. Can you claim 
with 95% confidence that the population mean age is 50? */
ci means age 
ttest age ==50

/*No, outside the confidence interval*/

/* (15) Compute the correlation between college and age. */
corr college age

/* (16) Estimate a regression of college on age by OLS. Interpret the coefficient
 on age. Is this coefficient statistically significant at the 5% level? */
 regress college age 
/*yes, p = .018*/
/* (17) Run a Breuch-Pagan test of heteroskedasticity. Does the test detect 
heteroskedasticity? */
regress college age
estat hettest
/*yes, p <.01*/
/* (18) Estimate a regression of college on age by Robust-OLS. Does the standard
error of the age coefficient go up or down? */
regress college age, vce(robust)
/* goes up*/
/* (19) Estimate a regression of college on age by WLS using weights equal to
1/(age*(100-age)). Does the age coefficient go up or down? */
 regress college age [aweight=1/(age*(100-age))]
 /*down*/
/* (20) Estimate a regression of college on age and daybirth by OLS. Did the 
adjusted-R-squared go up or down? Would you keep daybirth in the model? */
regress college age daybirth
/*r2 went down; I would not keep daybirth in the model - day of birth 
does not really contribute to the model, largely insignificant and it is missing values
The adj R2 goes down because the added variable daybirth does not contribute to the model
as much as expected*/

/* (21) Estimate a regression of college on age and daybirth by OLS, using all 
the data records available on these variables. (Hint: Use the variables mis and 
daybirth_mz created above.) */

regress college mis age daybirth_mz

/* (22) Estimate a regression of college on age and monthbirth by OLS. */
regress college age monthbirth

/* (23) Run an Ramsey test of model specification. Does the test detect model
misspecification?. */
estat ovtest
/* no functional form mispecification found*/

/* (24) Create a dummy (indicator) variable named female that takes the value 1
if the variable gender is F, and 0 otherwise. */
generate female = (gender=="F")

/* (25) Label the female variable "1 if female, 0 if male". */

label variable female "1 if female, 0 if male"
/* (26) Estimate a regression of college on age, monthbirth, and female by OLS.
Interpret the coefficient on female. */
regress college age monthbirth female
/* women are 11.99 percent less likely to have attended college. */
/* (27) Save the fitted values of the model just estimated. Name the new variable
college_hat. */

predict college_hat
/* (28) Plot college_hat against age. */

twoway (scatter college_hat age)
/* (29) Save the graph as college.gph in the working directory. Later please 
pdf-print this graph and attach it with your answers.*/
graph save Graph "/Users/mafton/Desktop/college.gph",replace

/* (30) Test the hypothesis that the coefficients of age and monthbirth add up
to zero. Can you reject this hypothesis at the 5% level? */

test (age+monthbirth=0)

/*no p greater than .5*/

/* (31) Estimate a regression of college on age, monthbirth, and female by OLS,
reporting standardized (beta) coefficients. Which explanatory variable has
the largest effect on college? */

regress college age monthbirth female, beta
/*female*/

/* (32) Estimate a regression of college on age, monthbirth, female, and an 
interaction between monthbirth and female, by OLS. */

regress college age c.monthbirth##i.female
/* (33) Convert the variable sales from string to numeric,  discarding the 
original variable. */
destring sales, replace

/* (34) Save the current dataset as CEOsalaryNew.dta in the same directory as 
the CEOsalary.dta. */
save "/Users/mafton/Desktop/CEOsalaryNew.dta", replace

/* (35) Export the saved dataset CEOsalaryNew.dta to a space-separated text file
 named CEOsalaryNew.txt, located in the same directory as CEOsalary.dta. */

 export delimited using ceosalaryNew.txt, delimiter(" ") replace
 
/* (36) Attach notes to the new data file that read "Updated version of the 
datafile CEOsalary.dta." */
notes : updated version of the datafile ceosalary.dta

/* (37) Check that the notes read correctly. List the notes attached to the 
datafile CEOsalaryNew.dta. */
notes list _dta

/* (38) Close the Log File. */

log close
/* (39) Execute this Do File to produce the Log File. */

/* (40) View the Log File in Stata, and produce a PDF printout of the Log File. */

