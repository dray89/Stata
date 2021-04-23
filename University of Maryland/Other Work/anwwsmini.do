capture log close
log using anwwsmini, replace
set more off
version 11.0
clear all
set memory 200m

* [A] read the data
use wwsmini

* [B] run regression predicting age from race
regress age i.race

log close
