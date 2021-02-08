* Created: 6/12/2004 9:36:21 PM
*                                                        
* Modify the path below to point to your data file.      
* The specified subdirectory was not created on          
* your computer. You will need to do this.               
*                                                        
* The stat program must be run against the specified     
* data file. This file is specified in the program       
* and must be saved separately.                          
*                                                        
* This program does not provide tab or summarize for all 
* variables.                                             
*                                                        
* There may be missing data for some institutions due    
* to the merge used to create this file.                 
*                                                        
* This program does not include reserved values in its   
* calculations for missing values.                       
*                                                        
* You may need to adjust your memory settings depending  
* upon the number of variables and records.              
*                                                        
* The save command may need to be modified per user      
* requirements.                                          
*                                                        
* For long lists of value labels, the titles may be      
* shortened per program requirements. 
*    
clear all                                                    
insheet using "2001/sal2001_a_s_data_stata.csv", comma clear
label data "dct_sal2001_a_s"
label variable unitid "unitid"
label variable contract "Contract length of faculty"
label variable arank "Academic rank and gender of faculty"
label variable empcount "Number of full-time instructional faculty"
label variable outlays "Salary outlays of full-time instructional faculty"
label variable saverage "Average salary of full-time instructional faculty"
label define label_contract 1 "9/10 Month contract" , add
label define label_contract 2 "11/12 Month contract", add 
label define label_contract 3 "Less than 9 month contract", add 
label values contract label_contract
label define label_arank 1 "Professor, men" 
label define label_arank 10 "Assistant professor, women", add 
label define label_arank 11 "Instructor, women", add 
label define label_arank 12 "Lecturer, women", add 
label define label_arank 13 "No academic rank, women", add 
label define label_arank 14 "Total women", add 
label define label_arank 15 "Total faculty (men and women)", add 
label define label_arank 2 "Associate professor, men", add 
label define label_arank 3 "Assistant professor, men", add 
label define label_arank 4 "Instructor, men", add 
label define label_arank 5 "Lecturer, men", add 
label define label_arank 6 "No academic rank, men", add 
label define label_arank 7 "Total, men", add 
label define label_arank 8 "Professor, women", add 
label define label_arank 9 "Associate professor, women", add 
label values arank label_arank
label values xempcoun label_xempcoun
tab contract
tab arank
tab xempcoun
tab xoutlays
tab xsaverag
summarize empcount
summarize outlays
summarize saverage
save dct_sal2001_a_s, replace
