
/* Frisch-Waugh-Lovell Theorem */
reg testscr el_pct, robust;
predict y_purge, res;

reg str el_pct, robust;
predict x_purge, res;

reg y_purge x_purge, robust;

/* 
(1) Regress student test scores on student to teacher ratio
(2  Predict the fitted values for test scores 
(3) Graph fitted values with original data
*/
reg testscr str, robust;
predict testscr_hat, xb;
graph twoway (scatter testscr str) (line testscr_hat str);

/*
(1) Save as a stata graph 
(2) Save as a pdf file
*/
graph save CAgraph, replace;
graph export "CAgraph.pdf", as(pdf) replace;

