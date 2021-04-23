/*Hypothesis Testing */

/*Hourly Wage*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\WAGE1.dta",clear

reg lwage educ exper tenure
tdemo 522 2 0.05
tdemo 522 1 0.05

/*Housing Prices and Air Pollution*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\HPRICE2.dta",clear

gen ldist = ln(dist)
reg lprice lnox ldist rooms stratio

/*Model of firmsë R&D expenditures*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\RDCHEM.dta",clear

reg lrd lsales profmarg 

/*Returns to Education*/
use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\TWOYEAR.dta",clear

reg lwage jc univ exper

/*we wouuld like to test whether beta1=beta2*/

/*generate new variable totalcol = jc+univ*/

gen totalcol = jc+univ 

/*re-estimate the model*/

reg lwage jc totalcol exper


