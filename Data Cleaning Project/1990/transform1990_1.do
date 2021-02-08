**** drop imputation and tenure variables****
**** I deleted the label commands in sal1980_a, sal90_a, and sal2001_a_s for 
**** all tenure variables. Thus this command below will delete any variables that are unlabeled.

foreach v of varlist * {
       local x : variable label `v'
        if "`x'" == "" drop `v' 
}

 /*
 Labels
 arank
 1 Professors
 2 Associate Professors
 3 Assistant Professors
 4 Instructors
 5 Lecturers
 6 No academic rank

 male
 1 male
 2 women
 
 contract
 1 9/10 month
 2 11/12 month
 */

rename	a4 	num111
rename	a5 	sal111
rename	a9	num211
rename	a10 	sal211
rename	a14 	num311
rename	a15 	sal311
rename	a19 	num411
rename	a20 	sal411
rename	a24 	num511
rename	a25 	sal511
rename	a29 	num611
rename	a30 	sal611
		
rename	a39 	num121
rename	a40 	sal121
rename	a44 	num221
rename	a45    	sal221
rename	a49   	num321
rename	a50    	sal321
rename	a54   	num421
rename	a55    	sal421
rename	a59   	num521
rename	a60    	sal521
rename	a64   	num621
rename	a65    	sal621
		
rename	a79   	num112
rename	a80    	sal112
rename	a84   	num212
rename	a85    	sal212
rename	a89   	num312
rename	a90    	sal312
rename	a94   	num412
rename	a95    	sal412
rename	a99   	num512
rename	a100    	sal512
rename	a104   	num612
rename	a105    	sal612
		
rename	a114   	num122
rename	a115    	sal122
rename	a119   	num222
rename	a120    	sal222
rename	a124   	num322
rename	a125    	sal322
rename	a129   	num422
rename	a130    	sal422
rename	a134   	num522
rename	a135    	sal522
rename	a139   	num622
rename	a140  	sal622

gen id = _n
reshape long num sal, i(id unitid year) j(identifier)

tostring identifier, generate(identifier_str)
gen arank_str = substr(identifier_str, 1,1)
gen male_str = substr(identifier_str, 2,1)
gen contract_str = substr(identifier_str, 3,1)

destring arank_str, generate(arank)
destring male_str, generate(male)
destring contract_str, generate(contract)

drop *_str id
*label values arank
label define labelarank 1 "Professors"
label define labelarank 2 "Associate Professors", add
label define labelarank 3 "Assistant Professors", add
label define labelarank 4 "Instructors", add
label define labelarank 5 "Lecturers", add
label define labelarank 6 "No academic rank", add
label values arank labelarank

*label values male
label define labelmale 1 "male"
label define labelmale 2 "female", add
label values male labelmale

*label values contract
label define labelcontract 1 "9/10 month"
label define labelcontract 2 "11/12 month", add
label values contract labelcontract

rename num emp_count
rename sal outlays
label variable outlays "Salary Outlays"
label variable emp_count "Number of Employees"
label variable male "Gender"
label variable contract "Length of contract with institution"
label variable arank "Rank"

drop identifier