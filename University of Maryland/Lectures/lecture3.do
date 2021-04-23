/*Lecture 3 - Examples*/

 cd "C:\Users\Max\Documents\UMaryland\ECN644"

/*Determinants of college GPA*/

use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\GPA1.dta",clear

*estimate the single and multiple regression models

reg colGPA hsGPA

/*output using outreg */

outreg using lec3.doc, se replace 

reg colGPA hsGPA ACT
 outreg using lec3.doc, se merge replace

/*"partialling out" in multiple regression model*/
 
 use "C:\Users\Max\Documents\UMaryland\ECN644\Wooldridge Data\401K.dta",clear

 reg prate mrate age
 
 /*how do we determine beta_1_hat*/
 
/*1. regress mrate on age*/

reg mrate age
/*2. obtain residuals from this regression*/
predict rhat,residual

/* 3. run a simple regression of y on rhat*/

reg prate rhat


/*possible bias when age is ommitted?*/

reg prate mrate age

/*lets omitt age*/

reg prate mrate 
 
/*regress age on mrate*/

reg age mrate


/*Data Cleaning*/

use survey1
/*check for duplicates*/

duplicates list id

* drop duplicates

drop in 9

/*prior to merging data sets it is a good practice to compare two files, especially with data types (int vs string)*/

cf _all using survey2, all verbose 

*in this example we get match for all variables, but nou suppose we want to merge two data sets in id, but id is string in the first file

 gen id1 = string(id)

drop id

 rename id1 id

 cf _all using survey2, all verbose 
 
 
 *you can convert string variable back to interger 
 
encode (id), gen(id1)
 
 
 /*checking indivudal variables*/
 
  use wws
  
  describe
  
  /*check categorical variables with tab command */
  
  tab collgrad, missing 
  
  tab race, missing
  
  *we know that race ranges from 1 -3, we can derermine which observation has an erroneous value.
  
  list idcode race if race==4
  
  /*check continuous variables with sum command*/
  
  sunmmarize wage 
  
  /*max wage is too high raising a suspicion of error in the data*/
  
  sunmmarize wage, detail
  
  list idcode wage if wage>100000
  
  /*if we have prior knowledge on a variable we can spot errors in the data*/
  
  sum age
  
  tab age if age >=45
  
  list idcode if age>50
