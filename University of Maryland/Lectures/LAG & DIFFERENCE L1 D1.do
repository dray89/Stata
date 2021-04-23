#delimit;
set more off;
clear;
cap log close;

/* Lecture 10: Time Series */

cd "/Users/shanthi/Desktop/teaching 645/Lecture Slides/Lecture11";
log using "lecture11_example.txt", text replace;

use FERTIL3, clear
sort year

tsset year

reg pe L1.pe
reg gfr L1.gfr

reg D1.gfr D1.pe

reg D1.gfr D1.pe L1.D1.pe L2.D1.pe

use BARIUM, clear
tsset t

reg lchnimp lchempi lgas
predict e, res

reg e L1.e L2.e L3.e lchempi lgas
test L1.e L2.e L3.e
