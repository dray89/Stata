** Simulate Simple ARMA Models
clear all
set seed 2016
set obs 100
generate time = _n
tsset time
generate eps = rnormal(0,.1)
generate y = 10 in 1


replace y = 0.9*L.y + eps in 2/l  // note in 2/l that is a lower case L, not a one
*replace y = 0.9*L.y + eps + .5*L.eps in 2/l
tsline y

//What if a1 is almost 1?
//What if a0 != 0?
//What if a1 is negative?
//What if a1>1
//What if there is a large shock?



** Nonstationary Series Example
clear
set obs 100
gen time = _n
tsset time
set seed 1
gen e1=rnormal(0,1)
gen y1 = e1 if time==1
replace y1=L.y1+e1 if time>1

gen e2=rnormal(0,1)
gen y2=e2 if time==1
replace y2=L.y2+e2 if time>1
tsline y1 y2, lpattern (solid longdash)
correlate y1 y2
reg y1 y2, r
reg y1 L.y1 y2,r
