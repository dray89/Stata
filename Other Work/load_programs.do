
capture program drop load_prog

program define load_prog
   qui {
   do "C:\Users\rayde\Desktop\LM_program.do"
  noisily di "loaded LM_program.do"
   do "C:\Users\rayde\Desktop\stderr_prog.do"
   noisily di "loaded stderr_prog.do"
   }
 end 
