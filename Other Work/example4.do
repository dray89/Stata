log using example4, replace
use wws2, clear
summarize age wage hours
tabulate married
log close
translate example4.smcl example4.log, replace
