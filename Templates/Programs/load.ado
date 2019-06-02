*********************************************************
**** To install an ado file 
**** 1) Create stata.toc file
**** 2) Create .pkg file
**** 3) Save all files in the same location type command: sysdir to find PERSONAL location
**** 3) Type the following commands: 
****     net query
****     net set from PERSONAL (*** all CAPS)
****     net link C:\ado\personal
****     net install load
****     (Test Command) load
*****************************************************

capture program drop load

program define load
   qui {
   do "${path}\LM_program.do"
   noisily di "loaded LM_program.do"
   do "${path}\stderr_prog.do"
   noisily di "loaded stderr_prog.do"
   }
 end 
