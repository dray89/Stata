****Create DTA Files****
clear all

*1980*
do "./1980/sal1980_a.do"
do "./1980/transform1980_1.do"
save "1980transformed.dta", replace

clear all

*1990*
do "./1990/sal90_a.do"
do "./1990/transform1990_1.do"
save "1990transformed.dta", replace

clear all

*2001*
do "./2001/sal2001_a_s.do"
do "./2001/transform2001_1.do"
save "2001transformed.dta", replace


*****import 1980 data****
use "./1980/1980transformed.dta", clear

*****import 1990 data****
append using "./1990/1990transformed.dta"

*****import 2001 data****
append using "./2001/2001transformed.dta"

***Order the variables with identifying and categorical variables 
***first and analysis variables last
order unitid year arank contract male emp_count outlays

****Save Dataset****
save "1980-1990-2001-instructionalsalaries.dta", replace



