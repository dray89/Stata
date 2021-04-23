************************************************************************************************
* Now you will be replicating some of the main results of the paper.
* First, you will investigate the relationship between birth weight 
* near the cutoff and 1 year mortality using the approach in the paper. 
* Then, you will do some robustnesss checks.
************************************************************************************************

************************************************************************************************
* Start with some basic commands to get set up and save your work
************************************************************************************************
clear all
set more off
capture log close

* The cd command tells stata where to look for the data, save files, etc. 
* To find the path to the data file, right click on the file -> properties -> location 

* cd C:\Users\mac285\Desktop //you can change this to your own directory if necessary

log using myresults.log, replace 
* You've created a log file: a permanent record of your results. 
* This is what you will turn in with your pset. You can change the
* path if you want to.

use adkw.dta //tell stata which data you want to use

************************************************************************************************
* Generate your independent variables: VLBW, VLBW*(g-1500), and (g-1500)
* Note that the meaning of these variables is defined in the equation in your homework assignment
************************************************************************************************

* Create a dummy variable for VLBW using the generate command
[          ]  //Hint: generate VLBW = ...

* Generate and define (g-1500). Call it [BWgrams]
[          ] 

* Generate and define VLBW*(g-1500). Call it [BWinteract]
[          ]

************************************************************************************************
* Now run the regression. Tell stata to calculate robust standard errors using [, robust]  
************************************************************************************************

[          ]  // regress ...

* This will make a table of your coefficients and robust standard errors
estimates table, b(%-8.5f) se(%-8.5f) title(Mortality Coefficient Results) 

************************************************************************************************
* Now make the graph showing the relationship between birthweight in grams and mortality weight  
************************************************************************************************
* Use the "collapse" function to calculate the mean mortality rate for each birthweight in grams.  
* Graphing the means will be easier to understand than graphing every data point.
[          ] 

* Make a scatter plot with the mortality rate on the y-axis and birthweight on the x-axis 
[          ] 

graph export mygraph.pdf, replace //this will save your graph as a PDF

************************************************************************************************
* Re-run your regression dropping birthweights from 1497-1503 (inclusive)
************************************************************************************************
* Recall that your regression must be run at the individual level to get the right answer, 
* but after you collapsed your to make your graph, it is likely not at the indiviual level. 
* Recover the individual level data set then do the following robustness check

[   	] //drop or keep...

[		] // regress ...

* This will make a table of your coefficients and robust standard errors
estimates table, b(%-8.5f) se(%-8.5f) title(Mortality Coefficient Results - Robustness Check) 



