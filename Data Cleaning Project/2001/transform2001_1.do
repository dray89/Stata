**** drop imputation and tenure variables****
**** I deleted the label commands in sal1980_a, sal90_a, and sal2001_a_s for 
**** all tenure variables. Thus this command below will delete any variables that are unlabeled.


foreach v of varlist * {
       local x : variable label `v'
        if "`x'" == "" drop `v' 
}

*delimit arank by comma in 2001

decode arank, gen(arank_labels)
split arank_labels, p(",")

replace arank_labels2 = "women" if arank_labels1=="Total women"
replace arank_labels2 = "Total" if arank_labels1=="Total faculty (men and women)"
replace arank_labels1 = "Total Men" if arank_labels1 == "Total"

drop arank
encode arank_labels2, generate(male)
encode arank_labels1, generate(arank)
drop arank_labels*
drop if male==3
replace male=2 if male==4

gen year = 2001
label variable year "Year"

rename empcount emp_count


*label values contract
label define labelcontract 1 "9/10 month"
label define labelcontract 2 "11/12 month", add
label values contract labelcontract
label variable contract "Length of contract with institution"

*label values male
label define labelmale 1 "male"
label define labelmale 2 "female", add
label values male labelmale
label variable male "Gender"

*recode arank
drop if arank==7
drop if arank==9
recode arank (6=1 "Professors") (2=2 "Associate Professors") (1=3 "Assistant Professors") (3=4 "Instructors") (4=5 "Lecturers") (5=6 "No academic rank"), gen(arank1)
drop arank
rename arank1 arank
label variable arank "Rank"

