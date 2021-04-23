capture log close
log using example5, replace
use wws2, clear
summarize age wage hours
tabulate married
log close
translate example5.smcl example5.log, replace
