gen year = 1980 
label variable year "Year"

drop ten*

gen id = _n

reshape long num sal con, i(id unitid year arank) j(male) string
drop id
replace male="male" if male=="m"
replace male= "female" if male=="w"

encode male, gen(male1)
drop male
rename male1 male

decode arank, gen(arank_labels)
split arank_labels, p("s ")
drop arank
encode arank_labels2, generate(arank)
encode arank_labels1, generate(contract)

drop arank_labels* con 

rename num emp_count
rename sal outlays

recode male (2=1 "male") (1=2 "female"), gen(male1)
drop male
rename male1 male
label variable male "Gender"

drop if contract==1
recode contract (3=1 "9/10 month") (2=2 "11/12 month"), gen(contract1)
drop contract
rename contract1 contract
label variable contract "Length of contract with institution"

drop if arank== 7
recode arank (6=1 "Professors") (2=2 "Associate Professors") (1=3 "Assistant Professors") (3=4 "Instructors") (4=5 "Lecturers") (5=6 "No academic rank"), gen(arank1)
drop arank
rename arank1 arank
label variable arank "Rank"


label variable outlays "Salary Outlays"
label variable emp_count "Number of Employees"

