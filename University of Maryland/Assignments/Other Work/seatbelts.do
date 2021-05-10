********************************************************************************
**** Seatbelt.dta: The effect of seatbelts on fatalities
**** Balanced panel data from 50 U.S. States and DC from 1983 - 1997. From "The 
**** Effects of Mandatory Seat Belt Laws on Driving Behavior & Traffic Fatalities"
**** By Prof. Liran Einav, Published in The Review of Economics and Statistics, 
**** 2003, Vol 85, No.4, pp 828 - 843.
********************************************************************************

texsave using "balanced_panel_res.tex", title(Xtreg: Guns Data) footnote(e(cmdline))


use "C:\Users\rayde\iCloudDrive\School\StataDataSets\seatbelts.dta", clear


cap log close
