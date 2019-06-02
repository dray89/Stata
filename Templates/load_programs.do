
capture program drop load_prog

program define load_prog
   qui {
   do "${path}\LM_program.do"
   noisily di "loaded LM_program.do"
   do "${path}\stderr_prog.do"
   noisily di "loaded stderr_prog.do"
   }
 end 
