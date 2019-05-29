# Stata
These Stata files are samples created in the MPS Economics program at UMD.

Fixed_or_Random_Effects.log, Econ 645, Empirical Analysis III

Guns.dta is a balanced panel of annual data on 50 US states, plus the District of Columbia spanning 1977 through 1999. Each observation is for a given state in a given year. There are a total of 51 states × 23 years = 1,173 observations. These data were provided by Professor John Donohue of Stanford University andwere used in his paper with Ian Ayres: “Shooting Down the ‘More Guns Less Crime’ Hypothesis” Stanford Law Review, 2003, Vol. 55, 1193-1312.

IVRegression.log, Econ 645, Empirical Analysis III

These data are from the 1980 US Census. This particular sample was provided by Bill Evans and is a subset of the data used in his 1998 AER paper with Josh Angrist entitled “Children and Their Parents’ Labor Supply: Evidence from Exogenous Variation in Family Size.”  The file contains data on 254,654 women between ages 21-35 who have at least two kids. 

psmatch.log, Econ 672, Program Analysis & Evaluation

Propensity score matching: In this section, we will use a dataset based on a study on maternal smoking and birthweight to work through an example of propensity score matching. Load in the data using the command: webuse cattaneo2, clear.

IVregression2.log, Econ 672, Program Analysis & Evaluation
Instrumental Variables: For this question we will use a dataset based on a study by Daron Acemoglu, Simon Johnson, and James A. Robinson (AJR), who, like many other economists, believe that rich countries are rich primarily because they have “institutions” which are more conducive to growth. “Institutions” refers to wide set of political and economic arrangements, including democracy versus autocratic rule, the security of property rights, the enforcement of law and contracts, the eﬃciency of the bureaucracy versus corruption, among others. The dataset contains information about 62 non-European countries, such as per capita income in 1995 as well as a number of other variables. In this question we want to assess the particular hypothesis tested by AJR that the protection of property rights is conducive to growth, and hence should be correlated with the level of contemporary per capita income (in other words, if a country is rich now, it must have been growing a lot). The data set contains a variable risk, indicating the protection of property rights (with larger values indicating more protection). The variable loggdp indicates the log of GDP per capita for a given country. 

DID.log, Econ 672, Program Analysis & Evaluation
Diﬀerences-in-diﬀerences: For this question, we will use data collected by David Card and Alan Krueger on fast food restaurants in New Jersey (NJ) and eastern Pennsylvania (PA) during two interview waves in March and November/December of 1992. On April 1, 1992 New Jersey raised its minimum wage from $4.25 to $5.05. The minimum in Pennsylvania remained at the federal level of $4.25. We will use this data to analyze the impact of the minimum wage increase in New Jersey on employment in the fast food industry

RD.log, Econ 672, Program Analysis & Evaluation
Regression Discontinuity: Based on Lingsheng Meng (2013) “Evaluating China’s poverty alleviation program: A regression discontinuity approach,” Journal of Public Economics 101:1-11. In 1994, China implemented a poverty alleviation program, called the 8-7 Plan, in various counties nationwide. Program participation was largely determined by whether a county’s pre-program rural income per capita fell below the poverty line. 

treatment_effects.log, Econ 672, Program Analysis & Evaluation

2. Selection bias: In this exercise, we will work through how random assignment can address selection bias. Download the dataset ps1selectiondta.dta from the course website. This is “fake” dataset, with information about the experience level of 4,000 individuals who are all employed as widget-makers, a variable called randomassignment that is randomly 1 or 0 for each observation, and a random error term u. The intervention is a training program for improving the number of widgets each individual can produce each day.

3. Evaluation with randomized experimental data: Suppose you are advising a member of the Council of the District of Columbia who is concerned about discriminatory hiring practices and would like to help craft an intervention that could alleviate racial disparities in labor market outcomes. To examine some of the potential causal eﬀects, we will use a dataset based on a randomized experiment conducted by Marianne Bertrand and Sendhil Mullainathan, who sent 4,870 ﬁctitious resumes out to employers in response to real job advertisements in Boston and Chicago in 2001. The resumes diﬀered in various attributes including education and experience, and the authors assigned some resumes distinctly white sounding names and other resumes distinctly black sounding names. Diﬀerent resumes were randomly allocated to job openings. The researchers collecting these data were interested in learning whether applicants with black sounding names obtain fewer callbacks for interviews than white sounding names. 

4. Evaluation with observational data: While in last question we analyzed data from ﬁctitious job applicants, we will now analyze data on real-life individuals. We will use data drawn from the U.S. Current Population Survey (CPS), a large on-going labor market study conducted by the Bureau of Labor Statistics; our dataset will include data on 8,891 black and white individuals living in Boston and Chicago in 2001.

Plotting_Beta.log, Econ 670, Financial Economics

Used data on dividend-adjusted price of 10 stocks and the S&P 500 index and the risk-free rate from Yahoo (finance.yahoo.com).
