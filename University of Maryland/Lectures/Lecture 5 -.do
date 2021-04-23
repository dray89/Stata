use "/Users/mafton/Downloads/attend.dta"
gen priGPA_sq = (priGPA)^2
gen ACT_sq = ACT^2
reg atndrte priGPA ACT priGPA_sq ACT_sq
reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA#c.atndrte

/*Add coefficients together (Interaction + the variable we want to look at) */ 

sum priGPA
gen priGPA_demean = priGPA-2.59
reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA_demean#c.atndrte

/*Need c. or it treats it as category variables instead of continuous. */
reg wage female educ exper expersq tenure c.female#c.educ

/*Class Start*/

use "/Users/mafton/Downloads/attend.dta"
gen priGPA_sq = (priGPA)^2
gen ACT_sq = ACT^2
reg atndrte priGPA ACT priGPA_sq ACT_sq
reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA#c.atndrte
reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA#c.atndrte c.priGPA##c.atndrte
reg stndfnl atndrte priGPA ACT c.priGPA#c.atndrte c.priGPA##c.atndrte
sum priGPA
gen priGPA_demean = priGPA-2.59
browse priGPA_demean
reg stndfnl priGPA_demean
reg stndfnl priGPA ACT priGPA_sq

reg stndfnl priGPA ACT priGPA_sq ACT_sq c.priGPA_demean#c.atndrte
reg stndfnl atndrte priGPA ACT priGPA_sq ACT_sq c.priGPA_demean#c.atndrte


use "/Users/mafton/Downloads/wage1.dta", clear
reg wage female educ exper expersq tenure

reg wage female educ exper expersq tenure married
reg wage female educ exper expersq tenure married services
reg wage female educ exper expersq tenure married profocc
reg wage female educ exper expersq tenure female#educ
reg wage female educ exper expersq tenure c.female#c.educ
