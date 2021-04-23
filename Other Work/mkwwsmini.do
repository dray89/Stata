capture log close                 
log using mkwwsmini, replace
version 11.0                      
set more off                      
clear all                         
set memory 200m                    
* [A] Read in the raw data file
insheet using wws.csv            

* [B] race
* [B1] correct error
replace race = 1 if idcode == 543 
* [B2] label variable and values
label variable race "race of woman"
label define racelab 1 "White" 2 "Black" 3 "Other"
label values race racelab
* [B3] double check that race is only 1, 2 or 3
assert inlist(race,1,2,3)

* [C] age
* [C1] correct errors
replace age = 38 if idcode == 51
replace age = 45 if idcode == 80
* [C2] label variable
label variable age "Age of woman"
* [C3] double check that age is from 21 up to 50
assert (age >= 21 & age <= 50)

* [D] save data file
save wwsmini, replace 

log close 
