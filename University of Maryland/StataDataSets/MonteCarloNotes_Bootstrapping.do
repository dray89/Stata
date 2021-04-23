**** $100k $105k
**** Senior Associate
**** Validation Strategy:

**** Cross-validation: "Rotation Estimation" "Out-of-sample testing" is any of various similar model validation
**** techniques for assessing how the results of a statistical analysis will generalize to an independent data set.
**** Used in settings where the goal is prediction. Esimates external validity in practice.
**** Step one: Training on known data; 
**** Step two: Testing on unknown or first seen data
**** The goal of cross-validation is to test the model's ability to predict new data that was not used in estimating it.
**** in order to flag problems like overfitting or selection bias.

**** Monte Carlo Cross-Validation: 

**** Creates multiple random splits of the dataset into training and validation data.
**** For each such split, the model is fit to the training data, and predictive accuracy is assessed using the validation data.
**** The results are then averaged over the splits. The proportion of the training/validation split is not dependent on the number of iterations
**** The disadvantage is that some observations may never be selected in the validation subsample whereas others may be selected more than once.

**** Monte Carlo variation: Results will vary if the analysis is repeated with different random splits.

**** Stationary bootstrap: The statistic of the bootstrap needs to accept an interval of the time series and return the summary statistic
**** Bootstrap: Any test or metric that relies on random sampling with replacement
**** Allows assigning measures of accuracy defined in terms of bias variance confidence intervals prediction error or some other such measure
**** Used in applied machine learning to estimate the skill of machine learning models when making 
**** predictions on data not included in the training data. 
**** Bootstrap methods are alternative approaches to traditional hypothesis testing and are notable
**** for being easier to understand and valid for more conditions.

**** Bootstrapping versus Traditional Hypothesis Testing:
**** Monte Carlo simulation assesses the sampling distribution of an estimator
**** Parametric Bootstrap used to estimate the variance of a statistic and its distribution
**** Parametric and non-parametric bootstrap are special cases of Monte Carlo simulations
**** The idea behind bootstrap is that the sample is an estimate of the population 
**** so an estimate of the sampling distribution can be obtained by drawing many samples (with replacement)
**** Parametric bootstrap requires extra restrictions
**** Monte Carlo simulations are more general - basically it refers to repeatedly 
**** creating random data in some way, do something to that random data, and collect some results.

**** Can be used to investigate some general characteristic of an estimator which is 
**** hard to derive analytically

**** Parametric bootstrap: Instead of simulating IID bootstrap samples from the 
**** empirical distribution, the nonparametric estimate of the data distribution, 
**** we simulate bootstrap samples that are IID from the estimated parametric model

/**** Loss forecasting: Roll Rate Models: Portfolio level estimation

The whole portfolio is segmented by various delinquency buckets and charge off.
Evaluate the probability of an accout in a specific delinquency bucket flowing into the
next stage of delinquency status during the course of 1 month.

The projected rate for each delinquency bucket is simply the moving average of previous 
3 months. 

Roll rate models are most applicable to the short-term loss forecasting (usually within 3 months)
and not able to estimate the portfolio loss in a stressed economic scenario.

Moving Average Basis: Lagging indicator, based on past values, \
(Simple moving average versus exponential moving average)
Simple moving average: Arithmetic mean of a security over a number of time periods, A.
The exponential moving average weights more recent data more heavily. Trend direction, support, resistance levels
SMA multiplied by a muliplier 2 + (selected time period +1) 2/(t+1)

Then you use a smoothing factor combined with the previous EMA to arrive at the current value.
Moving 

**** Stress tests:
**** Capital Calculations:
