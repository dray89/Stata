/*==================================================================
==========
 
 Econ 644
 
Class 1 and 2 
 
Debra Ray
 
====================================================================
 ========*/
 
clear all 
log using Class1.log, replace
use ceos.dta, clear
set more off 

describe
browse

/*Display notes*/ 

notes list _dta

/*Create Histogram*/

histogram salary, bin(25) frequency addlabel
graph save Graph "/Users/mafton/Documents/School/Econ 644/class1histogram1.gph", replace

histogram salary, bin(25) fraction addlabel
graph save Graph "/Users/mafton/Documents/School/Econ 644/class1histogram2.gph", replace
graph hbox salary
graph save Graph "/Users/mafton/Documents/School/Econ 644/class1hbox1.gph", replace
 
list salary if salary >=2000
edit
replace salary = 529 in 103

log close
log using class2.log, replace
clear all

use ceos.dta, clear

set more off

/*Here we compute probabilities for the binary distribution wth posiible values 0,1 and probabilities .3&.7*/

display binomial(1,0,0.7)
display binomial(1,1,0.7)
display 1,0,0.7

/*Compute probabilities for the univariate standard normal distribution N(0,1), i.e., mean zero and variance one.*/
display normal(0)
display normal(1.645) - normal(-1.645)
display normal(1.96) - normal(-1.96)
display normal(4) - normal(-4)

/*Compute probabilities for the bi-variate standard normal distribution, i.e., two independent standard normals.*/

display binormal(0,0,0)

/*Draw a random sample from the N(3,16) distribution, i.e., mean 3 and variance 16, or standard deviation 4.*/
drawnorm x, n(100000) means(3) sds(4)

/*Plot the distribution of variable x*/
histogram x, bin(5)
 graph save Graph "/Users/mafton/Documents/School/Econ 644/class2histogram.gph", replace
histogram x, bin(50)
graph save Graph "/Users/mafton/Documents/School/Econ 644/class2histogram2.gph", replace
display x
summarize x
browse x

drawnorm y, n(100000) means(3) sds(4)

/*Make a box plot for variable x*/
graph hbox x
histogram x, bin(50)
graph hbox x

/*Create a new variable*/
generate s = (x-3)/4
generate s2 = (x-3)/4

/*Draw a random sample from the standard normal distribution*/

drawnorm z
drawnorm z2

/*Here we create random 0-1 numbers. We use these to assign treatment (1) to 70%
 of observations, so 30% will be controls (0).*/
generate t = rbinomial(1,0.7)
generate t2 = rbinomial(1, .7)
browse t2

/*Plot the distribution of variable t*/
histogram t, discrete width(.2) fraction addlabel
histogram t, discrete width(0.2) fraction
histogram t, discrete width(.2) fraction addlabel

/*Plot the histograms for the treated z and control z compare summary stats*/
histogram z, by(t)
histogram z
 by t, sort: summarize z
summarize z
by t, sort: summarize z
count if t!=0
count if t!=1

count if z>0
count if z<0
count if z==0

/*Computing Mean, Median, Standard Deviation, Min, Max*/

summarize

/*Graph a Scatterplot of (s,z) for the First 200 Observations*/
twoway (scatter z s in 1/200)
twoway (scatter s x in 1/200) 

correlate x s
correlate s z
correlate z t

/*Graph the BLP of (s,z) for the First 200 Observations*/
twoway (scatter z s in 1/200) (lfit z s) 
twoway (scatter s x in 1/200) (lfit s x) 

save class2.dta, replace
log close    
    
