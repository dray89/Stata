import excel "C:\Users\Thoma\Documents\Econ 670\Data Case 2.xlsx", sheet("Returns") cellrange(A1:M66) firstrow clear

foreach v of varlist IBM-MKT {
    replace `v' = `v'-RF
} 

foreach v of varlist IBM-HSY {
	reg `v' MKT
	display as text "Alpha"
	di _b[_cons]
	display as text "Beta"
	di _b[MKT]
	
	display as text "Standard Error"
	dis _se[MKT]
	display as text "Lower Interval"
	di _b[_cons]-(_se[MKT]*sqrt(12)*1.96)
	display as text "Upper Interval"
	di _b[_cons]+(_se[MKT]*sqrt(12)*1.96)
}



