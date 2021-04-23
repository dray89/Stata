/***DebraRay, My Lecture 7 Do file*///

use "/Users/mafton/Downloads/hprice1.dta", clear

/*Ramsey Reset test for misspecification*/

reg price lotsize sqrft bdrms
ovtest
/*Reject Null*/

/*Try a new model*/

reg lprice llotsize lsqrft lbdrms

ovtest

/*fail to reject null. model more appropriate*/

/*So, for the Ramsey reset test, we just run regression, run ovtest command and check p-value.
If reject, try a new model and run ovtest command again.*/

/*Davidson Mackinnon Test for Misspecification*/
/*run regression*/
reg price lotsize sqrft
/*save fitted values*/
predict price_fit
/*run alternate regression*/
reg price llotsize lsqrft
/*Save fitted values*/
predict lprice_fit
/*run both original and alternate regression with fitted values except switch the fitted values in each model*/
reg price llotsize lsqrft price_fit
reg price lotsize sqrft lprice_fit

/*Determine reject/not reject to find appropriate model*/

/*Use lagged dependent variable as a proxy*/
use "/Users/mafton/Documents/Empirical Analysis II 2018/DTA/CRIME2.DTA", clear
reg lcrmrte unem llawexpc
reg lcrmrte unem llawexpc lcrmrt_1

/*Drop outliers*/
use "/Users/mafton/Downloads/rdchem.dta"
reg rdintens sales profmarg
summarize sales profmarg
scatter rdintens sales
reg rdintens sales profmarg if sales<39709

drop if sales>39708
reg rdintens sales profmarg
