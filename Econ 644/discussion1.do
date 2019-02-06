reg birthweight smoker
/*the coefficient on smoker measures the impact smoking has on birthweight. 
The intercept measures the average birthweight if the woman does not smoke while pregnant.

Smoking could be correlated with nutrition or other health factors like alcohol that could cause low birth 
weight since the smoking while pregnant demonstrates less concern for health. By not including
those variables, the coefficient on smoker would be biased downward.*/

reg birthweight smoker alcohol nprevist

/*If these variables have an effect on y that is signficant from Zero, the coeff will be biased and 
include that effect. The direction of the bias depends on corr and sign of the coefficient. 
Two negatives = positive bias. 
Neg + Pos = Neg*/

corr smoker alcohol nprevist 

/*Smoker will be biased downward. */

reg birthweight alcohol nprevist
predict Y, resid

reg smoker alcohol nprevist
predict X, resid

reg Y X

reg birthweight smoker alcohol nprevist

/*The first regression finds how alcohol and nprevist affect birthweight. The second
regression finds the relationship between alcohol and nprevist and smoker. the third 
regression finds how much of of the unexplained in the relationship between the x variables 
explains the the part which remains unexplained in the relationship between the control variables 
and the y variable. What is unexplained in the both of these regressions, regressed onto each other 
should be the relationship of birthweight regressed on smoker.*/
