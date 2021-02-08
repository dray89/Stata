* Created: 6/13/2004 7:11:58 AM
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
insheet using "1990/sal90_a_data_stata.csv", comma clear
label data "dct_sal90_a"
label variable unitid "unitid"    
label variable a4 "Professors men 9/10 month, total"
label variable a5 "Professors men 9/10 month, salary outlays"
label variable a9 "Associate professors men 9/10 month, total"
label variable a10 "Associate professors men 9/10 month, salary outlays"
label variable a14 "Assistant professors men 9/10 month, total"
label variable a15 "Assistant professors men 9/10 month, salary outlays"
label variable a19 "Instructors men 9/10 month, total"
label variable a20 "Instructors men 9/10 month, salary outlays"
label variable a24 "Lecturers men 9/10 month, total"
label variable a25 "Lecturers men 9/10 month, salary outlays"
label variable a29 "No academic rank men 9/10 month, total"
label variable a30 "No academic rank men 9/10 month, salary outlays"

label variable a39 "Professors women 9/10 month, total"
label variable a40 "Professors women 9/10 month, salary outlays"
label variable a44 "Associate professors women 9/10 month, total"
label variable a45 "Associate professors women 9/10 month, salary outlays"
label variable a49 "Assistant professors women 9/10 month, total"
label variable a50 "Assistant professors women 9/10 month, salary outlays"
label variable a54 "Instructors women 9/10 month, total"
label variable a55 "Instructors women 9/10 month, salary outlays"
label variable a59 "Lecturers women 9/10 month, total"
label variable a60 "Lecturers women 9/10 month, salary outlays"
label variable a64 "No academic rank women 9/10 month, total"
label variable a65 "No academic rank women 9/10 month, salary outlays"


label variable a79 "Professors men 11/12 month, total"
label variable a80 "Professors men 11/12 month, salary outlays"
label variable a84 "Associate professors men 11/12 month, total"
label variable a85 "Associate professors men 11/12 month, salary outlays"
label variable a89 "Assistant professors men 11/12 month, total"
label variable a90 "Assistant professors men 11/12 month, salary outlays"
label variable a94 "Instructors men 11/12 month, total"
label variable a95 "Instructors men 11/12 month, salary outlays"
label variable a99 "Lecturers men 11/12 month, total"
label variable a100 "Lecturers men 11/12 month, salary outlays"
label variable a104 "No academic rank men 11/12 month, total"
label variable a105 "No academic rank men 11/12 month, salary outlays"

label variable a114 "Professors women 11/12 month, total"
label variable a115 "Professors women 11/12 month, salary outlays"
label variable a119 "Associate professors women 11/12 month, total"
label variable a120 "Associate professors women 11/12 month, salary outlays"
label variable a124 "Assistant professors women 11/12 month, total"
label variable a125 "Assistant professors women 11/12 month, salary outlays"
label variable a129 "Instructors women 11/12 month, total"
label variable a130 "Instructors women 11/12 month, salary outlays"
label variable a134 "Lecturers women 11/12 month, total"
label variable a135 "Lecturers women 11/12 month, salary outlays"
label variable a139 "No academic rank women 11/12 month, total"
label variable a140 "No academic rank women 11/12 month, salary outlays"


gen year = 1990
label variable year "Year"
save dct_sal90_a, replace

