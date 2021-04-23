
/*Returns to Education*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\TWOYEAR.dta",clear

reg lwage jc univ exper

/*we wouuld like to test whether beta1=beta2*/

/*generate new variable totalcol = jc+univ*/

gen totalcol = jc+univ 

/*re-estimate the model*/

reg lwage jc totalcol exper

/*MLB salary*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\MLB1.dta",clear

/*run unrestricted model*/
reg lsalary years gamesyr bavg hrunsyr rbisyr

/*run restricted model*/

reg lsalary years gamesyr 

/*Models with quadratics*/

/*Wage and experiene*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\WAGE1.dta",clear

reg wage educ exper tenure

/*wage may increase with experience but at dimishing rate - 
add quadratic term for experience*/

reg wage educ exper expersq tenure

predict fitwage
label var fitwage "Fitted Wage"

/*Scatter plot the relationship between fitted wage and experience*/

twoway (scatter fitwage exper, sort)


/*Models with Interaction Terms*/

/*Exam score and attendance*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\ATTEND.dta",clear

/*to run a model with continious interaction terms use c. prefix on each variable and # between regressors*/

gen priGPA_sq = priGPA*priGPA
gen ACT_sq = ACT*ACT

reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA#c.atndrte

/*evaluate at means of priGPA*/

sum priGPA

/*subtract mean from priGPA*/

gen priGPA_demean = priGPA-2.59

/*re-run regression*/

reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA_demean#c.atndrte

