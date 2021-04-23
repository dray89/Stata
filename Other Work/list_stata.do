
local dep = "lvio"
local ind = "shall incarc_rate density avginc pop"


capture program drop sub
	program define sub
	syntax varlist(fv ts)
	local varlist "`varlist'"
	local dep "`1'"
	local newlist: list varlist - dep
	di "`newlist'"
end

sub `dep' `ind'
