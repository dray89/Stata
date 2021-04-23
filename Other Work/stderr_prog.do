
capture program drop stderr

program define stderr
   syntax anything(name=error id="estimates store name for error")

qui {
foreach i in `error' {

replace `i'  = 0 if `i' ==.
scalar `i'sq  = `i'^2
scalar avg_`i'  = sum(`i'sq )/e(N) 
scalar resid_`i'  = (`i'  - avg_`i' )^2 
scalar `i'  = sum(resid_`i' )/(e(N)) 
noisily di "stderr of `i' = " `i' 

}
}

end