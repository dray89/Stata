/* Clean Data */
import excel "C:\Users\rayde\Desktop\DSI_kickstarterscrape_dataset.xlsx", sheet("DSI_kickstarterscrape_dataset") firstrow

duplicates drop projectid, force

sum category
describe category
list category

replace category= "Film & Video" if category=="Film &amp; Video"

describe fundeddate
browse fundeddate

split fundeddate, parse

browse fundeddate*
drop fundeddate6


strip fundeddate1, of(",") generate(day)
browse day
drop fundeddate1
browse fundeddate*
rename day weekday
rename fundeddate2 day
rename fundeddate3 month
rename fundeddate4 year
rename funddate5 time
rename fundeddate5 time

gen weekday_dum = 0

browse weekday_dum weekday
replace weekday_dum = 1 if weekday= "Mon"
replace weekday_dum = 1 if weekday== "Mon"
replace weekday_dum = 2 if weekday== "Tues"
replace weekday_dum = 2 if weekday== "Tue"
replace weekday_dum = 3 if weekday== "Wed"
replace weekday_dum = 4 if weekday== "Thu"
replace weekday_dum = 5 if weekday== "Fri"
replace weekday_dum = 6 if weekday== "Sat"
replace weekday_dum = 0 if weekday== "Sun"

gen month_dum = 0

replace month_dum = 1 if month=="Feb"
replace month_dum = 2 if month=="Mar"
replace month_dum = 3 if month=="Apr"
replace month_dum = 4 if month=="May"
replace month_dum = 5 if month=="June"
replace month_dum = 5 if month=="Jun"
replace month_dum = 6 if month=="Jul"
replace month_dum = 7 if month=="Aug"
replace month_dum = 8 if month=="Sep"
replace month_dum = 9 if month=="Oct"
replace month_dum = 10 if month=="Nov"
replace month_dum = 11 if month=="Dec"

/* Get basic info */
describe

sum


/* Relationship between duration and performance measures */
reg fundedpercentage duration

reg backers duration

reg pledged duration

/* Backers distribution */
histogram backers, discrete
histogram backers
histogram backers, percent
histogram backers, frequency
histogram backers, percent

graph save "Graph" "C:\Users\rayde\Desktop\histogram_backers.gph"

/* Relationship between duration and goal with performance measures */
reg fundedpercentage duration goal

reg backers duration goal

reg pledged duration goal

twoway (scatter pledged goal, sort)

twoway (scatter pledged goal)

twoway (scatter pledged goal)
twoway (scatter pledged goal) if goal<5000000
twoway (scatter pledged goal) if goal<1000000
twoway (scatter pledged goal) if goal<500000

graph save "Graph" "C:\Users\rayde\Desktop\goal_pledged.gph"

/* Relationship between category and performance measures */
graph bar (mean) category
graph bar (mean) pledged, by(category)
graph bar (mean) pledged, category, by(category)
graph bar (mean) pledged, category
graph bar (mean) pledged, over(category) over(subcategory)
graph bar (mean) pledged, over(category)
graph bar (mean) pledged, over(category) blabel(group)
graph pie pledged, over(category)
graph pie pledged, over(category) title(Funding by Category)


graph pie pledged, over(category) title(Funding by Category)
graph save "Graph" "C:\Users\rayde\Desktop\FundingbyCategory.gph"
graph pie pledged, over(category) title(Funding by Category)
graph save "Graph" "C:\Users\rayde\Desktop\FundingbyCategory.jpg"
graph export "C:\Users\rayde\Desktop\Graph.png", as(png) name("Graph")

/*Relationship between day month year weekday and time with performance */

reg fundedpercentage weekday_dum
reg fundedpercentage weekday_dum

graph bar (mean) pledged, over(weekday_dum) blabel(group)

graph pie pledged, over(weekday_dum) title(Funding by Category)

ttest pledged weekday_dum

mean pledged, over(weekday_dum)

reg fundedpercentage c.weekday_dum
reg fundedpercentage i.weekday_dum

reg pledged i.weekday_dum
reg pledged i.weekday_dum i.year i.month i.day

reg backers i.weekday_dum

destring year, generate(year_float) float
browse year*
drop year
rename year_float year

browse month
describe month
sum month
sum month, detail

destring day, replace float
reg pledged i.day
reg pledged i.year


reg pledged i.month_dum
reg pledged i.month_dum i.weekday_dum i.year
reg pledged i.month_dum i.weekday_dum i.day

graph bar (mean) pledged, over(day) blabel(group)
graph pie pledged, over(day) title(Funding by Category)
twoway (scatter pledged goal, sort) (scatter pledged day)
twoway (scatter pledged day)
twoway (scatter pledged goal, sort) (scatter pledged day, sort)
twoway (scatter pledged day, sort)
graph save "Graph" "C:\Users\rayde\Desktop\pledged-day.jpg"
graph pie pledged, over(weekday) title(Funding by Weekday)

reg pledged i.weekday_dum

graph bar (mean) pledged, over(weekday_dum) blabel(group)
graph bar (mean) pledged, over(weekday) blabel(group)
graph bar (mean) pledged, over(weekday)
graph save "Graph" "C:\Users\rayde\Desktop\pledgedbyweekday.jpg"
graph export "C:\Users\rayde\Desktop\pledgedbyweekday.png", as(png) name("Graph")
reg pledged i.month_dum i.weekday_dum i.day goal duration
reg pledged month_dum weekday_dum day goal duration
reg fundedpercentage month_dum weekday_dum day goal duration
reg fundedpercentage month_dum weekday_dum day goal duration backers
reg backers month_dum weekday_dum day goal duration
reg pledged month_dum weekday_dum day goal duration
twoway (scatter pledged goal, sort)
twoway (scatter pledged goal, sort) if goal<1000
twoway (scatter pledged goal, sort) if goal<2000
graph export "C:\Users\rayde\Desktop\pledged_goals.png", as(png) name("Graph")