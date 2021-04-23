/*Ramsey RESET test for misspecification*/


use "your dir\HPRICE1.DTA", clear

reg price lotsize sqrft bdrms

ovtest 

*reject null bc p=.0076, so model IS misspecified
*but you don't know what variables you need, only that your model isn't great

reg lprice llotsize lsqrft bdrms

ovtest 

*now p=.0692, so fail to reject the null, so this log model is appropriate

/*Davidson and McKinnon Test for misspecification*/

reg price lotsize sqrft 
predict price_fit

reg price llotsize lsqrft
predict lprice_fit

reg price llotsize lsqrft price_fit
reg price lotsize sqrft  lprice_fit

*bc price_fit is sign. and lprice_fit isn't, the first linear model is more
*appropriate

/*Using lagged dependent variable as proxy*/
use "your dir\CRIME2.DTA", clear

reg lcrmrte unem llawexpc
reg lcrmrte unem llawexpc lcrmrt_1

/*Outliers*/
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



