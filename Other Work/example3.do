log using example3
use wws2, clear
summarize age wage hours
tabulate married
log close
translate example3.smcl example3.log
